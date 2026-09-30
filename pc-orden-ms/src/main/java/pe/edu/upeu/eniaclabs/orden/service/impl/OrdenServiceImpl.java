package pe.edu.upeu.eniaclabs.orden.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.upeu.eniaclabs.orden.client.ProductoClient;
import pe.edu.upeu.eniaclabs.orden.dto.*;
import pe.edu.upeu.eniaclabs.orden.entity.EstadoOrden;
import pe.edu.upeu.eniaclabs.orden.entity.OrdenCompra;
import pe.edu.upeu.eniaclabs.orden.entity.OrdenCompraDetalle;
import pe.edu.upeu.eniaclabs.orden.exception.ResourceNotFoundException;
import pe.edu.upeu.eniaclabs.orden.repository.OrdenCompraRepository;
import pe.edu.upeu.eniaclabs.orden.service.OrdenService;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import pe.edu.upeu.eniaclabs.orden.event.OrdenCreadaEvento;
import pe.edu.upeu.eniaclabs.orden.service.OrdenEventProducer;
import java.util.*;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class OrdenServiceImpl implements OrdenService {

    private static final BigDecimal IGV_RATE = new BigDecimal("0.18");
    private final OrdenCompraRepository ordenRepository;
    private final ProductoClient productoClient;
    private final ProductoConsultaService productoConsultaService;
    private final OrdenEventProducer ordenEventProducer;

    @Override
    @Transactional(readOnly = true)
    public List<OrdenResponseDto> findAll(Long clienteId, EstadoOrden estado) {
        List<OrdenCompra> list;
        if (clienteId != null) {
            list = ordenRepository.findByClienteId(clienteId);
        } else if (estado != null) {
            list = ordenRepository.findByEstado(estado);
        } else {
            list = ordenRepository.findAll();
        }
        return list.stream().map(this::mapToDto).collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public OrdenResponseDto findById(Long id) {
        OrdenCompra orden = ordenRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Orden no encontrada con ID: " + id));
        return mapToDto(orden);
    }

    @Override
    @Transactional(readOnly = true)
    public OrdenResponseDto findByCodigoOrden(String codigoOrden) {
        OrdenCompra orden = ordenRepository.findByCodigoOrden(codigoOrden)
                .orElseThrow(() -> new ResourceNotFoundException("Orden no encontrada con código: " + codigoOrden));
        return mapToDto(orden);
    }

    /**
     * Orquestación Saga para la creación de órdenes:
     * 1. Fase Externa (Fuera de DB TX): Validación de precios y reserva atómica de stock en Catálogo.
     * 2. Fase Local (DB TX corta): Persistencia ACID de la Orden y Detalle en PostgreSQL.
     * 3. Compensación: Si la persistencia local falla, se restituye el stock en Catálogo.
     */
    @Override
    public OrdenResponseDto create(CrearOrdenRequestDto req) {
        return create(req, 1L);
    }

    @Override
    public OrdenResponseDto create(CrearOrdenRequestDto req, Long clienteId) {
        List<OrdenCompraDetalle> detallesCalculados = new ArrayList<>();
        List<Map.Entry<Long, Integer>> reservasExitosas = new ArrayList<>();
        BigDecimal subtotal = BigDecimal.ZERO;

        try {
            // PASO 1 (SAGA): Consultar catálogo y reservar stock sin retener conexión DB
            for (DetalleOrdenRequestDto item : req.getItems()) {
                // Consulta síncrona declarativa mediante OpenFeign protegida por Resilience4j Circuit Breaker
                BigDecimal precioOficial = productoConsultaService.consultarPrecio(item.getProductoId());
                BigDecimal precioFinal = (precioOficial != null) ? precioOficial : item.getPrecioUnitario();

                boolean reservado = productoClient.reservarStock(item.getProductoId(), item.getCantidad());
                if (!reservado) {
                    throw new IllegalStateException("Stock insuficiente o no disponible para el producto ID: " + item.getProductoId());
                }
                reservasExitosas.add(Map.entry(item.getProductoId(), item.getCantidad()));

                BigDecimal linea = precioFinal.multiply(BigDecimal.valueOf(item.getCantidad())).setScale(2, RoundingMode.HALF_UP);
                subtotal = subtotal.add(linea);

                detallesCalculados.add(OrdenCompraDetalle.builder()
                        .productoId(item.getProductoId())
                        .sku(item.getSku().toUpperCase())
                        .productoNombre(item.getProductoNombre())
                        .precioUnitario(precioFinal)
                        .cantidad(item.getCantidad())
                        .subtotalLinea(linea)
                        .build());
            }

            // PASO 2: Transacción ACID local de duración mínima
            return persistirOrdenLocalmente(req, clienteId, detallesCalculados, subtotal);

        } catch (Exception ex) {
            // PASO 3 (SAGA COMPENSACIÓN): Rollback compensatorio de reservas
            log.error("Fallo en la creación de orden. Ejecutando compensaciones Saga: {}", ex.getMessage());
            for (Map.Entry<Long, Integer> reserva : reservasExitosas) {
                productoClient.compensarStock(reserva.getKey(), reserva.getValue());
            }
            throw new RuntimeException("Error al procesar la orden distribuida: " + ex.getMessage(), ex);
        }
    }

    @Transactional
    public OrdenResponseDto persistirOrdenLocalmente(CrearOrdenRequestDto req, Long clienteId, List<OrdenCompraDetalle> detalles, BigDecimal subtotal) {
        String codigoGenerado = "ENIAC-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + "-" +
                String.format("%04d", ThreadLocalRandom.current().nextInt(1000, 9999));

        BigDecimal igv = subtotal.multiply(IGV_RATE).setScale(2, RoundingMode.HALF_UP);
        BigDecimal total = subtotal.add(igv).setScale(2, RoundingMode.HALF_UP);

        OrdenCompra orden = OrdenCompra.builder()
                .codigoOrden(codigoGenerado)
                .clienteId(clienteId)
                .clienteNombre(req.getClienteNombre())
                .clienteEmail(req.getClienteEmail())
                .estado(EstadoOrden.PENDIENTE)
                .metodoPago(req.getMetodoPago() != null ? req.getMetodoPago() : "MERCADO_PAGO")
                .direccionEnvio(req.getDireccionEnvio())
                .observaciones(req.getObservaciones())
                .subtotal(subtotal)
                .igv(igv)
                .total(total)
                .build();

        detalles.forEach(orden::addDetalle);
        OrdenCompra ordenGuardada = ordenRepository.save(orden);

        // Publicación asíncrona desacoplada: emitir orden.creada únicamente tras el commit ACID de la BD
        if (TransactionSynchronizationManager.isActualTransactionActive()) {
            TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
                @Override
                public void afterCommit() {
                    OrdenCreadaEvento evento = OrdenCreadaEvento.builder()
                            .tipoEvento("orden.creada")
                            .ordenId(ordenGuardada.getId())
                            .idCliente(ordenGuardada.getClienteId())
                            .total(ordenGuardada.getTotal())
                            .metodoPago(ordenGuardada.getMetodoPago())
                            .origen("pc-orden-ms")
                            .timestamp(System.currentTimeMillis())
                            .build();
                    ordenEventProducer.publicarOrdenCreada(evento);
                }
            });
        } else {
            OrdenCreadaEvento evento = OrdenCreadaEvento.builder()
                    .tipoEvento("orden.creada")
                    .ordenId(ordenGuardada.getId())
                    .idCliente(ordenGuardada.getClienteId())
                    .total(ordenGuardada.getTotal())
                    .metodoPago(ordenGuardada.getMetodoPago())
                    .origen("pc-orden-ms")
                    .timestamp(System.currentTimeMillis())
                    .build();
            ordenEventProducer.publicarOrdenCreada(evento);
        }

        return mapToDto(ordenGuardada);
    }

    @Override
    @Transactional
    public OrdenResponseDto updateStatus(Long id, ActualizarEstadoOrdenDto req) {
        OrdenCompra orden = ordenRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Orden no encontrada con ID: " + id));
        orden.setEstado(req.getNuevoEstado());

        if (req.getNuevoEstado() == EstadoOrden.CANCELADA) {
            // Compensación de stock
            for (OrdenCompraDetalle det : orden.getDetalles()) {
                productoClient.compensarStock(det.getProductoId(), det.getCantidad());
            }
        }

        return mapToDto(ordenRepository.save(orden));
    }

    @Override
    @Transactional
    public void marcarPagada(Long ordenId) {
        OrdenCompra orden = ordenRepository.findById(ordenId).orElse(null);
        if (orden == null || (orden.getEstado() != EstadoOrden.PENDIENTE)) {
            log.warn("component=processor ordenId={} status=ignored motivo=\"la orden no existe o no esta pendiente de pago\"", ordenId);
            return;
        }
        orden.setEstado(EstadoOrden.PAGADA);
        ordenRepository.save(orden);
        log.info("component=processor ordenId={} estado={} status=processed", ordenId, orden.getEstado());
    }

    @Override
    @Transactional
    public void cancel(Long id) {
        OrdenCompra orden = ordenRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Orden no encontrada con ID: " + id));
        orden.setEstado(EstadoOrden.CANCELADA);
        ordenRepository.save(orden);

        // Compensación de stock al cancelar
        for (OrdenCompraDetalle det : orden.getDetalles()) {
            productoClient.compensarStock(det.getProductoId(), det.getCantidad());
        }
    }

    private OrdenResponseDto mapToDto(OrdenCompra o) {
        List<DetalleOrdenResponseDto> detList = o.getDetalles().stream()
                .map(d -> DetalleOrdenResponseDto.builder()
                        .id(d.getId())
                        .productoId(d.getProductoId())
                        .sku(d.getSku())
                        .productoNombre(d.getProductoNombre())
                        .precioUnitario(d.getPrecioUnitario())
                        .cantidad(d.getCantidad())
                        .subtotalLinea(d.getSubtotalLinea())
                        .build())
                .collect(Collectors.toList());

        return OrdenResponseDto.builder()
                .id(o.getId())
                .codigoOrden(o.getCodigoOrden())
                .clienteId(o.getClienteId())
                .clienteNombre(o.getClienteNombre())
                .clienteEmail(o.getClienteEmail())
                .subtotal(o.getSubtotal())
                .igv(o.getIgv())
                .total(o.getTotal())
                .estado(o.getEstado())
                .metodoPago(o.getMetodoPago())
                .direccionEnvio(o.getDireccionEnvio())
                .observaciones(o.getObservaciones())
                .fechaCreacion(o.getFechaCreacion())
                .fechaActualizacion(o.getFechaActualizacion())
                .detalles(detList)
                .build();
    }
}