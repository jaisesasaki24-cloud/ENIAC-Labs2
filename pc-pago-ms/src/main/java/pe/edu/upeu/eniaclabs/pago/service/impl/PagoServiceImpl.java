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

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class PagoServiceImpl implements PagoService {

    private final TransaccionPagoRepository transaccionRepository;
    private final OrdenClient ordenClient;

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

        List<TransaccionPago> pendientes = transaccionRepository.findByEstado(EstadoPago.PENDIENTE);
        TransaccionPago tx;
        if (!pendientes.isEmpty()) {
            tx = pendientes.get(pendientes.size() - 1);
        } else {
            List<TransaccionPago> all = transaccionRepository.findAll();
            if (all.isEmpty()) {
                throw new ResourceNotFoundException("No existen transacciones de pago para asociar el webhook de Mercado Pago");
            }
            tx = all.get(all.size() - 1);
        }

        tx.setMpPaymentId(paymentId != null ? paymentId : "MP-WH-" + System.currentTimeMillis());
        tx.setRawWebhookPayload(rawPayload);

        if ("payment.created".equalsIgnoreCase(webhook.getAction()) || "payment".equalsIgnoreCase(webhook.getType())) {
            tx.setEstado(EstadoPago.APROBADO);
            // Notificacion sincrona distribuida hacia pc-orden-ms via Eureka
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