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
import java.util.List;
import java.util.concurrent.ThreadLocalRandom;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class OrdenServiceImpl implements OrdenService {

    private static final BigDecimal IGV_RATE = new BigDecimal("0.18");
    private final OrdenCompraRepository ordenRepository;
    private final ProductoClient productoClient;

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
                .orElseThrow(() -> new ResourceNotFoundException("Orden de compra no encontrada con ID: " + id));
        return mapToDto(orden);
    }

    @Override
    @Transactional(readOnly = true)
    public OrdenResponseDto findByCodigoOrden(String codigoOrden) {
        OrdenCompra orden = ordenRepository.findByCodigoOrden(codigoOrden)
                .orElseThrow(() -> new ResourceNotFoundException("Orden de compra no encontrada con Codigo: " + codigoOrden));
        return mapToDto(orden);
    }

    @Override
    @Transactional
    public OrdenResponseDto create(CrearOrdenRequestDto req) {
        BigDecimal subtotal = BigDecimal.ZERO;

        String codigoGenerado = "ENIAC-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + "-" +
                String.format("%04d", ThreadLocalRandom.current().nextInt(1000, 9999));

        OrdenCompra orden = OrdenCompra.builder()
                .codigoOrden(codigoGenerado)
                .clienteId(req.getClienteId())
                .clienteNombre(req.getClienteNombre())
                .clienteEmail(req.getClienteEmail())
                .estado(EstadoOrden.PENDIENTE)
                .metodoPago(req.getMetodoPago() != null ? req.getMetodoPago() : "MERCADO_PAGO")
                .direccionEnvio(req.getDireccionEnvio())
                .observaciones(req.getObservaciones())
                .build();

        for (DetalleOrdenRequestDto item : req.getItems()) {
            // Validacion y sincronizacion de precio real con pc-catalogo-ms
            BigDecimal precioOficial = productoClient.consultarPrecioProducto(item.getProductoId());
            BigDecimal precioFinal = (precioOficial != null) ? precioOficial : item.getPrecioUnitario();

            BigDecimal linea = precioFinal
                    .multiply(BigDecimal.valueOf(item.getCantidad()))
                    .setScale(2, RoundingMode.HALF_UP);

            subtotal = subtotal.add(linea);

            OrdenCompraDetalle det = OrdenCompraDetalle.builder()
                    .productoId(item.getProductoId())
                    .sku(item.getSku().toUpperCase())
                    .productoNombre(item.getProductoNombre())
                    .precioUnitario(precioFinal)
                    .cantidad(item.getCantidad())
                    .subtotalLinea(linea)
                    .build();

            orden.addDetalle(det);
        }

        // Calculo oficial de IGV 18% para el PerÃº
        BigDecimal igv = subtotal.multiply(IGV_RATE).setScale(2, RoundingMode.HALF_UP);
        BigDecimal total = subtotal.add(igv).setScale(2, RoundingMode.HALF_UP);

        orden.setSubtotal(subtotal);
        orden.setIgv(igv);
        orden.setTotal(total);

        OrdenCompra guardada = ordenRepository.save(orden);
        return mapToDto(guardada);
    }

    @Override
    @Transactional
    public OrdenResponseDto updateStatus(Long id, ActualizarEstadoOrdenDto req) {
        OrdenCompra orden = ordenRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Orden no encontrada con ID: " + id));
        orden.setEstado(req.getNuevoEstado());
        return mapToDto(ordenRepository.save(orden));
    }

    @Override
    @Transactional
    public void cancel(Long id) {
        OrdenCompra orden = ordenRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Orden no encontrada con ID: " + id));
        orden.setEstado(EstadoOrden.CANCELADA);
        ordenRepository.save(orden);
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