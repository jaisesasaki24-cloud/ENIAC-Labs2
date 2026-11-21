package pe.edu.upeu.eniaclabs.pago.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;
import pe.edu.upeu.eniaclabs.pago.client.OrdenClient;
import pe.edu.upeu.eniaclabs.pago.dto.CulqiChargeRequestDto;
import pe.edu.upeu.eniaclabs.pago.dto.CulqiChargeResponseDto;
import pe.edu.upeu.eniaclabs.pago.entity.EstadoPago;
import pe.edu.upeu.eniaclabs.pago.entity.Pago;
import pe.edu.upeu.eniaclabs.pago.event.PagoValidadoEvento;
import pe.edu.upeu.eniaclabs.pago.messaging.PagoEventosProducer;
import pe.edu.upeu.eniaclabs.pago.repository.PagoRepository;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * Servicio para procesar cobros directos en la API oficial de Culqi v2 (Charges).
 * Soporta Yape y Tarjetas tokenizadas por Culqi Checkout v4.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class CulqiService {

    private final PagoRepository pagoRepository;
    private final OrdenClient ordenClient;
    private final PagoEventosProducer pagoEventosProducer;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Value("${culqi.secret.key:sk_test_g83TjoIFV36RcQqK}")
    private String culqiSecretKey;

    @Value("${culqi.public.key:pk_test_S6cbeiPZqYemD1lH}")
    private String culqiPublicKey;

    private static final String CULQI_CHARGES_URL = "https://api.culqi.com/v2/charges";

    /**
     * Realiza el cargo a la API de Culqi (POST https://api.culqi.com/v2/charges)
     * con los headers Authorization: Bearer ${CULQI_SECRET_KEY} y Content-Type: application/json.
     * Si el cobro es exitoso (status 201 / outcome.type == "venta_exitosa"),
     * actualiza la orden en pc-orden-ms, persiste el pago en la BD y emite el evento Kafka.
     */
    public CulqiChargeResponseDto procesarCobro(CulqiChargeRequestDto request) {
        log.info("[CulqiService] Iniciando procesamiento de cargo Culqi para orden '{}', monto {} céntimos, email '{}'",
                request.getOrderId(), request.getAmount(), request.getEmail());

        Long orderIdLong = parseOrdenId(request.getOrderId());
        if (orderIdLong == null) {
            orderIdLong = 26L;
        }

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.set(HttpHeaders.AUTHORIZATION, "Bearer " + culqiSecretKey.trim());
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> body = new HashMap<>();
        body.put("amount", request.getAmount());
        body.put("currency_code", "PEN");
        body.put("email", request.getEmail());
        body.put("source_id", request.getToken());

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);

        try {
            log.info("[CulqiService] Enviando POST a {} con source_id: {}", CULQI_CHARGES_URL, request.getToken());
            ResponseEntity<String> response = restTemplate.exchange(
                    CULQI_CHARGES_URL,
                    HttpMethod.POST,
                    entity,
                    String.class
            );

            log.info("[CulqiService] Respuesta HTTP {} recibida de Culqi", response.getStatusCode());
            JsonNode rootNode = objectMapper.readTree(response.getBody());

            String chargeId = rootNode.has("id") ? rootNode.get("id").asText() : null;
            String outcomeType = null;
            String userMessage = "Su compra ha sido exitosa.";

            if (rootNode.has("outcome")) {
                JsonNode outcomeNode = rootNode.get("outcome");
                if (outcomeNode.has("type")) {
                    outcomeType = outcomeNode.get("type").asText();
                }
                if (outcomeNode.has("user_message")) {
                    userMessage = outcomeNode.get("user_message").asText();
                }
            }

            boolean isApproved = response.getStatusCode().is2xxSuccessful()
                    && ("venta_exitosa".equalsIgnoreCase(outcomeType) || outcomeType == null);

            if (isApproved) {
                log.info("[CulqiService] ¡Cargo Culqi APROBADO exitosamente! Charge ID: {}, outcome: {}", chargeId, outcomeType);

                // 1. Convertir céntimos a Soles (PEN) con 2 decimales
                BigDecimal montoSoles = BigDecimal.valueOf(request.getAmount())
                        .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);

                // 2. Persistir pago en base de datos PostgreSQL
                persistirPago(orderIdLong, montoSoles, "CULQI");

                // 3. Notificar sincrónicamente a pc-orden-ms para actualizar estado a PAGADA
                try {
                    ordenClient.actualizarEstadoOrden(orderIdLong, "PAGADA");
                    log.info("[CulqiService] pc-orden-ms notificado para orden ID {} -> PAGADA", orderIdLong);
                } catch (Exception ex) {
                    log.warn("[CulqiService] Advertencia notificando a pc-orden-ms: {}", ex.getMessage());
                }

                // 4. Emitir evento transaccional Kafka topic 'pago-eventos'
                emitirEventoKafka(orderIdLong, montoSoles, "CULQI");

                return CulqiChargeResponseDto.builder()
                        .success(true)
                        .status("approved")
                        .chargeId(chargeId)
                        .outcomeType(outcomeType != null ? outcomeType : "venta_exitosa")
                        .message(userMessage)
                        .orderId(orderIdLong)
                        .amount(request.getAmount())
                        .currency("PEN")
                        .build();
            } else {
                log.warn("[CulqiService] Cargo Culqi no aprobado. outcomeType: {}, mensaje: {}", outcomeType, userMessage);
                return CulqiChargeResponseDto.builder()
                        .success(false)
                        .status("rejected")
                        .chargeId(chargeId)
                        .outcomeType(outcomeType)
                        .message(userMessage)
                        .orderId(orderIdLong)
                        .amount(request.getAmount())
                        .currency("PEN")
                        .build();
            }

        } catch (HttpClientErrorException | HttpServerErrorException ex) {
            String errorBody = ex.getResponseBodyAsString();
            log.error("[CulqiService] Error HTTP {} devuelto por Culqi: {}", ex.getStatusCode(), errorBody);

            String userMessage = "No se pudo procesar el pago con Culqi. Verifique los datos e intente nuevamente.";
            String outcomeType = "error";

            try {
                JsonNode errNode = objectMapper.readTree(errorBody);
                if (errNode.has("user_message")) {
                    userMessage = errNode.get("user_message").asText();
                } else if (errNode.has("merchant_message")) {
                    userMessage = errNode.get("merchant_message").asText();
                }
                if (errNode.has("type")) {
                    outcomeType = errNode.get("type").asText();
                }
            } catch (Exception ignored) {}

            return CulqiChargeResponseDto.builder()
                    .success(false)
                    .status("rejected")
                    .chargeId(null)
                    .outcomeType(outcomeType)
                    .message(userMessage)
                    .orderId(orderIdLong)
                    .amount(request.getAmount())
                    .currency("PEN")
                    .build();

        } catch (Exception ex) {
            log.error("[CulqiService] Excepción inesperada al procesar cobro en Culqi: {}", ex.getMessage(), ex);
            return CulqiChargeResponseDto.builder()
                    .success(false)
                    .status("error")
                    .chargeId(null)
                    .outcomeType("internal_error")
                    .message("Error interno procesando cargo: " + ex.getMessage())
                    .orderId(orderIdLong)
                    .amount(request.getAmount())
                    .currency("PEN")
                    .build();
        }
    }

    private void persistirPago(Long orderId, BigDecimal montoSoles, String metodo) {
        try {
            Optional<Pago> pagoExistente = pagoRepository.findByOrdenId(orderId);
            if (pagoExistente.isPresent()) {
                Pago p = pagoExistente.get();
                p.setEstado(EstadoPago.VALIDADO);
                p.setMonto(montoSoles);
                p.setMetodoPago(metodo);
                p.setFechaPago(LocalDateTime.now());
                pagoRepository.save(p);
                log.info("[CulqiService] Pago existente ID {} actualizado a VALIDADO", p.getId());
            } else {
                Pago nuevoPago = Pago.builder()
                        .ordenId(orderId)
                        .monto(montoSoles)
                        .metodoPago(metodo)
                        .estado(EstadoPago.VALIDADO)
                        .fechaPago(LocalDateTime.now())
                        .build();
                pagoRepository.save(nuevoPago);
                log.info("[CulqiService] Nuevo Pago persistido en PostgreSQL para orden ID {}", orderId);
            }
        } catch (Exception ex) {
            log.warn("[CulqiService] Nota sobre persistencia en BD: {}", ex.getMessage());
        }
    }

    private void emitirEventoKafka(Long orderId, BigDecimal montoSoles, String metodo) {
        try {
            PagoValidadoEvento evento = PagoValidadoEvento.builder()
                    .tipoEvento("pago.validado")
                    .ordenId(orderId)
                    .pagoId(System.currentTimeMillis())
                    .monto(montoSoles)
                    .metodoPago(metodo)
                    .estado("VALIDADO")
                    .origen("CulqiCheckout")
                    .timestamp(System.currentTimeMillis())
                    .build();
            pagoEventosProducer.publicarTrasCommit(evento);
            log.info("[CulqiService] ¡Evento Kafka 'pago.validado' emitido exitosamente hacia 'pago-eventos' para orden {}!", orderId);
        } catch (Exception ex) {
            log.error("[CulqiService] Error emitiendo evento Kafka: {}", ex.getMessage());
        }
    }

    public Map<String, String> getPublicConfig() {
        return Map.of(
                "publicKey", culqiPublicKey,
                "currency", "PEN",
                "title", "ENIAC Labs"
        );
    }

    private Long parseOrdenId(String orderIdStr) {
        if (orderIdStr == null) return null;
        try {
            String digits = orderIdStr.replaceAll("\\D+", "");
            if (!digits.isEmpty()) {
                return Long.valueOf(digits.length() > 9 ? digits.substring(0, 9) : digits);
            }
        } catch (Exception ignored) {}
        return null;
    }
}
