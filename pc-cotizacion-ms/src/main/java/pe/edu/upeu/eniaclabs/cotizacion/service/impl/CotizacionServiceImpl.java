package pe.edu.upeu.eniaclabs.cotizacion.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.upeu.eniaclabs.cotizacion.client.CatalogoClient;
import pe.edu.upeu.eniaclabs.cotizacion.client.NemotronAiClient;
import pe.edu.upeu.eniaclabs.cotizacion.client.OrdenClient;
import pe.edu.upeu.eniaclabs.cotizacion.dto.*;
import pe.edu.upeu.eniaclabs.cotizacion.entity.CotizacionItem;
import pe.edu.upeu.eniaclabs.cotizacion.entity.CotizacionPc;
import pe.edu.upeu.eniaclabs.cotizacion.exception.ResourceNotFoundException;
import pe.edu.upeu.eniaclabs.cotizacion.repository.CotizacionRepository;
import pe.edu.upeu.eniaclabs.cotizacion.service.CotizacionService;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class CotizacionServiceImpl implements CotizacionService {

    private final CotizacionRepository cotizacionRepository;
    private final CatalogoClient catalogoClient;
    private final OrdenClient ordenClient;
    private final NemotronAiClient nemotronAiClient;

    private static final BigDecimal IGV_RATE = new BigDecimal("0.18");

    @Override
    @Transactional
    public CotizacionResponseDto crearCotizacion(CrearCotizacionRequestDto req) {
        String codigoProforma = "COT-2026-" + String.format("%04d", cotizacionRepository.count() + 1);

        BigDecimal subtotalAcumulado = BigDecimal.ZERO;

        CotizacionPc cotizacion = CotizacionPc.builder()
                .codigoProforma(codigoProforma)
                .clienteNombre(req.getClienteNombre())
                .clienteEmail(req.getClienteEmail())
                .clienteTelefono(req.getClienteTelefono())
                .usoDestino(req.getUsoDestino() != null ? req.getUsoDestino() : "Gaming y Alto Rendimiento")
                .estado("VIGENTE")
                .fechaCreacion(LocalDateTime.now())
                .fechaExpiracion(LocalDateTime.now().plusDays(7))
                .build();

        for (ItemCotizacionDto itemDto : req.getItems()) {
            // Validar o actualizar precio en vivo con catalogo
            BigDecimal precioFinal = itemDto.getPrecioUnitario();
            BigDecimal precioCatalogo = catalogoClient.consultarPrecioActualizado(itemDto.getProductoId());
            if (precioCatalogo != null) {
                precioFinal = precioCatalogo;
            }

            BigDecimal itemSubtotal = precioFinal.multiply(new BigDecimal(itemDto.getCantidad())).setScale(2, RoundingMode.HALF_UP);
            subtotalAcumulado = subtotalAcumulado.add(itemSubtotal);

            CotizacionItem item = CotizacionItem.builder()
                    .productoId(itemDto.getProductoId())
                    .categoria(itemDto.getCategoria())
                    .sku(itemDto.getSku())
                    .descripcion(itemDto.getDescripcion())
                    .precioUnitario(precioFinal)
                    .cantidad(itemDto.getCantidad())
                    .subtotal(itemSubtotal)
                    .build();

            cotizacion.addItem(item);
        }

        BigDecimal igvCalculado = subtotalAcumulado.multiply(IGV_RATE).setScale(2, RoundingMode.HALF_UP);
        BigDecimal totalCalculado = subtotalAcumulado.add(igvCalculado);

        cotizacion.setSubtotal(subtotalAcumulado);
        cotizacion.setIgv(igvCalculado);
        cotizacion.setTotal(totalCalculado);

        CotizacionPc guardada = cotizacionRepository.save(cotizacion);
        log.info("Proforma de PC Gamer generada exitosamente: {} por total S/. {}", codigoProforma, totalCalculado);

        return mapToDto(guardada);
    }

    @Override
    @Transactional(readOnly = true)
    public List<CotizacionResponseDto> listarTodas() {
        return cotizacionRepository.findAll().stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public CotizacionResponseDto buscarPorId(Long id) {
        CotizacionPc cot = cotizacionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cotizacion no encontrada con ID: " + id));
        return mapToDto(cot);
    }

    @Override
    public ValidarCompatibilidadDto validarCompatibilidad(ValidarCompatibilidadDto req) {
        List<String> advertencias = new ArrayList<>();
        boolean compatible = true;

        // Reglas de negocio para hardware gamer
        if (req.getProcesador() != null && req.getPlacaMadre() != null) {
            if (req.getProcesador().toUpperCase().contains("AM5") && !req.getPlacaMadre().toUpperCase().contains("AM5") && !req.getPlacaMadre().toUpperCase().contains("B650") && !req.getPlacaMadre().toUpperCase().contains("X670")) {
                compatible = false;
                advertencias.add("Incompatibilidad de socket: El procesador requiere placa madre con socket AM5 (chipsets B650/X670)");
            }
        }

        if (req.getFuenteWatts() != null && req.getTarjetaGrafica() != null) {
            if (req.getTarjetaGrafica().toUpperCase().contains("4080") || req.getTarjetaGrafica().toUpperCase().contains("4090")) {
                if (req.getFuenteWatts() < 850) {
                    compatible = false;
                    advertencias.add("Fuente insuficiente: Las graficas RTX 4080/4090 requieren minimo 850W certificados Gold");
                }
            } else if (req.getTarjetaGrafica().toUpperCase().contains("4070") || req.getTarjetaGrafica().toUpperCase().contains("7800")) {
                if (req.getFuenteWatts() < 700) {
                    advertencias.add("Recomendacion: Se sugiere una fuente de 750W para maxima eficiencia y estabilidad");
                }
            }
        }

        req.setCompatible(compatible);
        req.setAdvertencias(advertencias);
        req.setMensaje(compatible ? "Configuracion de hardware 100% compatible y optima para ensamblaje" : "Se detectaron incompatibilidades tecnicas en la cotizacion");
        return req;
    }

    @Override
    @Transactional
    public ConvertirOrdenResponseDto convertirAOrden(Long cotizacionId) {
        CotizacionPc cot = cotizacionRepository.findById(cotizacionId)
                .orElseThrow(() -> new ResourceNotFoundException("Cotizacion no encontrada con ID: " + cotizacionId));

        // Preparar payload para el microservicio transaccional pc-orden-ms
        List<Map<String, Object>> itemsOrden = cot.getItems().stream().map(i -> {
            Map<String, Object> it = new HashMap<>();
            it.put("productoId", i.getProductoId());
            it.put("sku", i.getSku());
            it.put("productoNombre", i.getDescripcion());
            it.put("precioUnitario", i.getPrecioUnitario());
            it.put("cantidad", i.getCantidad());
            return it;
        }).collect(Collectors.toList());

        Map<String, Object> reqOrden = new HashMap<>();
        reqOrden.put("clienteId", 1L);
        reqOrden.put("clienteNombre", cot.getClienteNombre());
        reqOrden.put("clienteEmail", cot.getClienteEmail());
        reqOrden.put("metodoPago", "MERCADO_PAGO");
        reqOrden.put("direccionEnvio", "Entrega Inmediata / Envio a Domicilio ENIAC Labs");
        reqOrden.put("observaciones", "Orden generada automaticamente desde proforma: " + cot.getCodigoProforma());
        reqOrden.put("items", itemsOrden);

        Map<String, Object> ordenCreada = ordenClient.crearOrdenDesdeCotizacion(reqOrden);

        Long ordenId = null;
        String codigoOrden = "ORD-" + cot.getCodigoProforma();
        String estadoOrden = "PENDIENTE";

        if (ordenCreada != null && ordenCreada.containsKey("id")) {
            ordenId = Long.valueOf(ordenCreada.get("id").toString());
            if (ordenCreada.containsKey("codigo")) {
                codigoOrden = ordenCreada.get("codigo") != null ? ordenCreada.get("codigo").toString() : codigoOrden;
            }
            if (ordenCreada.containsKey("estado")) {
                estadoOrden = ordenCreada.get("estado").toString();
            }
        }

        cot.setEstado("CONVERTIDA_A_ORDEN");
        cotizacionRepository.save(cot);

        return ConvertirOrdenResponseDto.builder()
                .cotizacionId(cot.getId())
                .codigoProforma(cot.getCodigoProforma())
                .ordenId(ordenId)
                .codigoOrden(codigoOrden)
                .estadoOrden(estadoOrden)
                .total(cot.getTotal())
                .mensaje("Cotizacion convertida exitosamente en Orden de Compra Transaccional en pc-orden-ms")
                .build();
    }

    private CotizacionResponseDto mapToDto(CotizacionPc c) {
        List<ItemCotizacionDto> itemsDto = c.getItems().stream()
                .map(i -> ItemCotizacionDto.builder()
                        .productoId(i.getProductoId())
                        .categoria(i.getCategoria())
                        .sku(i.getSku())
                        .descripcion(i.getDescripcion())
                        .precioUnitario(i.getPrecioUnitario())
                        .cantidad(i.getCantidad())
                        .subtotal(i.getSubtotal())
                        .build())
                .collect(Collectors.toList());

        return CotizacionResponseDto.builder()
                .id(c.getId())
                .codigoProforma(c.getCodigoProforma())
                .clienteNombre(c.getClienteNombre())
                .clienteEmail(c.getClienteEmail())
                .clienteTelefono(c.getClienteTelefono())
                .usoDestino(c.getUsoDestino())
                .subtotal(c.getSubtotal())
                .igv(c.getIgv())
                .total(c.getTotal())
                .estado(c.getEstado())
                .fechaExpiracion(c.getFechaExpiracion())
                .fechaCreacion(c.getFechaCreacion())
                .items(itemsDto)
                .build();
    }

    @Override
    public AsesorIaResponseDto asesorarConIa(AsesorIaRequestDto request) {
        log.info("Procesando asesoria de hardware con NVIDIA Nemotron 3 Ultra para: {}", request.getTipoUso());
        return nemotronAiClient.consultarAsesorHardware(request);
    }
}