package pe.edu.upeu.eniaclabs.pago.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.upeu.eniaclabs.pago.client.OrdenClient;
import pe.edu.upeu.eniaclabs.pago.dto.CheckoutRequestDto;
import pe.edu.upeu.eniaclabs.pago.dto.MercadoPagoWebhookDto;
import pe.edu.upeu.eniaclabs.pago.dto.PagoResponseDto;
import pe.edu.upeu.eniaclabs.pago.dto.SimularPagoDto;
import pe.edu.upeu.eniaclabs.pago.entity.EstadoPago;
import pe.edu.upeu.eniaclabs.pago.entity.TransaccionPago;
import pe.edu.upeu.eniaclabs.pago.exception.ResourceNotFoundException;
import pe.edu.upeu.eniaclabs.pago.repository.TransaccionPagoRepository;
import pe.edu.upeu.eniaclabs.pago.service.PagoService;

import org.springframework.beans.factory.annotation.Value;
import pe.edu.upeu.eniaclabs.pago.entity.Pago;
import pe.edu.upeu.eniaclabs.pago.event.OrdenCreadaEvento;
import pe.edu.upeu.eniaclabs.pago.event.PagoValidadoEvento;
import pe.edu.upeu.eniaclabs.pago.messaging.PagoEventosProducer;
import pe.edu.upeu.eniaclabs.pago.repository.PagoRepository;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class PagoServiceImpl implements PagoService {

    private final TransaccionPagoRepository transaccionRepository;
    private final PagoRepository pagoRepository;
    private final PagoEventosProducer pagoEventosProducer;
    private final OrdenClient ordenClient;

    @Value("${spring.application.name:pc-pago-ms}")
    private String nombreServicio;

    @Override
    @Transactional
    public void procesar(OrdenCreadaEvento orden) {
        log.info("component=service ordenId={} status=processing", orden.getOrdenId());
        Pago pago = pagoRepository.save(Pago.builder()
                .ordenId(orden.getOrdenId())
                .monto(orden.getTotal())
                .metodoPago(orden.getMetodoPago() != null ? orden.getMetodoPago() : "TARJETA")
                .estado(EstadoPago.VALIDADO)
                .fechaPago(LocalDateTime.now())
                .build());

        pagoEventosProducer.publicarTrasCommit(PagoValidadoEvento.builder()
                .tipoEvento("pago.validado")
                .ordenId(pago.getOrdenId())
                .pagoId(pago.getId())
                .monto(pago.getMonto())
                .metodoPago(pago.getMetodoPago())
                .estado(pago.getEstado().name())
                .origen(nombreServicio)
                .timestamp(Instant.now().toEpochMilli())
                .build());

        log.info("component=processor ordenId={} estado={} status=processed", pago.getOrdenId(), pago.getEstado());
    }

    @Override
    @Transactional
    public PagoResponseDto crearCheckoutSandbox(CheckoutRequestDto req) {
        String prefId = "PREF-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        String extRef = "EXT-" + req.getCodigoOrden() + "-" + System.currentTimeMillis();
        String sandboxUrl = "https://sandbox.mercadopago.com.pe/checkout/v1/redirect?pref_id=" + prefId;

        TransaccionPago tx = TransaccionPago.builder()
                .ordenId(req.getOrdenId())
                .codigoOrden(req.getCodigoOrden())
                .monto(req.getMonto())
                .moneda("PEN")
                .metodoPago("MERCADO_PAGO_SANDBOX")
                .estado(EstadoPago.PENDIENTE)
                .mpPreferenceId(prefId)
                .sandboxInitPoint(sandboxUrl)
                .externalReference(extRef)
                .payerEmail(req.getPayerEmail())
                .build();

        return mapToDto(transaccionRepository.save(tx));
    }

    @Override
    @Transactional
    public PagoResponseDto procesarWebhook(MercadoPagoWebhookDto webhook, String rawPayload) {
        String paymentId = null;
        if (webhook.getData() != null && webhook.getData().get("id") != null) {
            paymentId = String.valueOf(webhook.getData().get("id"));
        } else if (webhook.getId() != null) {
            paymentId = String.valueOf(webhook.getId());
        }

        // Búsqueda determinista por correlación real o preferencia
        TransaccionPago tx = null;
        if (webhook.getExternalReference() != null) {
            tx = transaccionRepository.findByExternalReference(webhook.getExternalReference()).orElse(null);
        }

        if (tx == null && webhook.getPreferenceId() != null) {
            tx = transaccionRepository.findByMpPreferenceId(webhook.getPreferenceId()).orElse(null);
        }

        if (tx == null && paymentId != null) {
            tx = transaccionRepository.findByMpPaymentId(paymentId).orElse(null);
        }

        if (tx == null) {
            // Fallback para pruebas si no viene referencia explícita
            List<TransaccionPago> pendientes = transaccionRepository.findByEstado(EstadoPago.PENDIENTE);
            if (!pendientes.isEmpty()) {
                tx = pendientes.get(pendientes.size() - 1);
                log.warn("Webhook sin correlación explícita. Asociado a la transacción pendiente ID: {}", tx.getId());
            } else {
                throw new ResourceNotFoundException("No se encontró transacción para la referencia del webhook de Mercado Pago");
            }
        }

        // Idempotencia: Si ya estaba aprobada, no duplicar la notificación a la orden
        if (tx.getEstado() == EstadoPago.APROBADO) {
            log.info("Transacción {} ya fue aprobada previamente. Operación idempotente omitida.", tx.getId());
            return mapToDto(tx);
        }

        tx.setMpPaymentId(paymentId != null ? paymentId : "MP-WH-" + System.currentTimeMillis());
        tx.setRawWebhookPayload(rawPayload);

        if ("payment.created".equalsIgnoreCase(webhook.getAction()) || 
            "payment".equalsIgnoreCase(webhook.getType()) ||
            "approved".equalsIgnoreCase(webhook.getStatus())) {
            
            tx.setEstado(EstadoPago.APROBADO);
            // Notificación sincrona distribuida hacia pc-orden-ms via Eureka
            ordenClient.actualizarEstadoOrden(tx.getOrdenId(), "PAGADA");
        } else {
            tx.setEstado(EstadoPago.EN_PROCESO);
        }

        return mapToDto(transaccionRepository.save(tx));
    }

    @Override
    @Transactional
    public PagoResponseDto simularResultadoPago(Long id, SimularPagoDto req) {
        TransaccionPago tx = transaccionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Transaccion de pago no encontrada con ID: " + id));

        tx.setEstado(req.getNuevoEstado());
        if (req.getMpPaymentId() != null) {
            tx.setMpPaymentId(req.getMpPaymentId());
        } else if (tx.getMpPaymentId() == null) {
            tx.setMpPaymentId("MP-SIM-" + System.currentTimeMillis());
        }

        if (req.getNuevoEstado() == EstadoPago.APROBADO) {
            // Notificacion sincrona distribuida hacia pc-orden-ms via Eureka
            ordenClient.actualizarEstadoOrden(tx.getOrdenId(), "PAGADA");
        }

        return mapToDto(transaccionRepository.save(tx));
    }

    @Override
    @Transactional(readOnly = true)
    public PagoResponseDto findById(Long id) {
        TransaccionPago tx = transaccionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Transaccion de pago no encontrada con ID: " + id));
        return mapToDto(tx);
    }

    @Override
    @Transactional(readOnly = true)
    public List<PagoResponseDto> findByOrdenId(Long ordenId) {
        return transaccionRepository.findByOrdenId(ordenId).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<PagoResponseDto> findAll(EstadoPago estado) {
        List<TransaccionPago> list = (estado != null) ?
                transaccionRepository.findByEstado(estado) :
                transaccionRepository.findAll();
        return list.stream().map(this::mapToDto).collect(Collectors.toList());
    }

    private PagoResponseDto mapToDto(TransaccionPago t) {
        return PagoResponseDto.builder()
                .id(t.getId())
                .ordenId(t.getOrdenId())
                .codigoOrden(t.getCodigoOrden())
                .monto(t.getMonto())
                .moneda(t.getMoneda())
                .metodoPago(t.getMetodoPago())
                .estado(t.getEstado())
                .mpPaymentId(t.getMpPaymentId())
                .mpPreferenceId(t.getMpPreferenceId())
                .sandboxInitPoint(t.getSandboxInitPoint())
                .externalReference(t.getExternalReference())
                .payerEmail(t.getPayerEmail())
                .fechaCreacion(t.getFechaCreacion())
                .fechaActualizacion(t.getFechaActualizacion())
                .build();
    }
}