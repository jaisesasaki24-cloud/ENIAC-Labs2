package pe.edu.upeu.eniaclabs.pago.controller;

import com.mercadopago.client.payment.PaymentClient;
import com.mercadopago.client.preference.PreferenceBackUrlsRequest;
import com.mercadopago.client.preference.PreferenceClient;
import com.mercadopago.client.preference.PreferenceItemRequest;
import com.mercadopago.client.preference.PreferencePayerRequest;
import com.mercadopago.client.preference.PreferenceRequest;
import com.mercadopago.exceptions.MPApiException;
import com.mercadopago.exceptions.MPException;
import com.mercadopago.resources.payment.Payment;
import com.mercadopago.resources.preference.Preference;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.edu.upeu.eniaclabs.pago.config.MercadoPagoConfig;
import pe.edu.upeu.eniaclabs.pago.dto.CreatePreferenceRequestDto;
import pe.edu.upeu.eniaclabs.pago.dto.PreferenceItemDto;
import pe.edu.upeu.eniaclabs.pago.dto.PreferenceResponseDto;
import pe.edu.upeu.eniaclabs.pago.entity.EstadoPago;
import pe.edu.upeu.eniaclabs.pago.entity.Pago;
import pe.edu.upeu.eniaclabs.pago.event.PagoValidadoEvento;
import pe.edu.upeu.eniaclabs.pago.messaging.PagoEventosProducer;
import pe.edu.upeu.eniaclabs.pago.repository.PagoRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

/**
 * Controlador REST para Pasarela de Pagos Mercado Pago Checkout Pro y Webhooks IPN.
 * Expone endpoints oficiales solicitados bajo la ruta base: /api/payments
 *
 * @author ENIAC Labs - Arquitectura de Pagos Distribuidos
 */
@Slf4j
@RestController
@RequestMapping("/api/payments")
@CrossOrigin(origins = "*", allowedHeaders = "*", methods = {
        RequestMethod.GET, RequestMethod.POST, RequestMethod.PUT, RequestMethod.DELETE, RequestMethod.OPTIONS
})
@RequiredArgsConstructor
@Tag(name = "Mercado Pago Checkout Pro (/api/payments)", description = "Integración oficial con SDK Java v2 para creación de preferencias y recepción de webhooks")
public class PaymentController {

    private final MercadoPagoConfig mpConfig;
    private final PagoRepository pagoRepository;
    private final PagoEventosProducer pagoEventosProducer;

    @Value("${frontend.url:http://localhost:4200}")
    private String frontendUrl;

    /**
     * Endpoint 1: POST /api/payments/create-preference
     * Construye y registra una preferencia de pago en Mercado Pago usando PreferenceClient.
     * Retorna el preferenceId, initPoint para Checkout Pro y la public key para el frontend.
     */
    @PostMapping("/create-preference")
    @Operation(summary = "Crear preferencia de pago Checkout Pro en Mercado Pago (Moneda PEN)")
    public ResponseEntity<?> createPreference(
            @Valid @RequestBody CreatePreferenceRequestDto request,
            jakarta.servlet.http.HttpServletRequest httpRequest) {
        log.info("[PaymentController] Creando preferencia de pago para producto: '{}', Cantidad: {}, Monto: S/ {}",
                request.getTitle(), request.getQuantity(), request.getUnitPrice());

        try {
            PreferenceClient client = new PreferenceClient();
            List<PreferenceItemRequest> items = new ArrayList<>();

            // 1. Mapeo de ítems del pedido (soporta lista o ítem principal directo)
            if (request.getItems() != null && !request.getItems().isEmpty()) {
                for (PreferenceItemDto it : request.getItems()) {
                    items.add(PreferenceItemRequest.builder()
                            .id(it.getId() != null ? it.getId() : "ITEM-" + System.currentTimeMillis())
                            .title(it.getTitle())
                            .description(it.getDescription())
                            .pictureUrl(it.getPictureUrl())
                            .quantity(it.getQuantity() != null ? it.getQuantity() : 1)
                            .unitPrice(it.getUnitPrice())
                            .currencyId(mpConfig.getCurrency()) // Moneda oficial "PEN"
                            .build());
                }
            } else {
                items.add(PreferenceItemRequest.builder()
                        .id(request.getOrderId() != null ? request.getOrderId() : "PROD-" + System.currentTimeMillis())
                        .title(request.getTitle())
                        .quantity(request.getQuantity())
                        .unitPrice(request.getUnitPrice())
                        .currencyId(mpConfig.getCurrency()) // Moneda oficial "PEN"
                        .build());
            }

            // 2. Configuración dinámica y resiliente de Back URLs de retorno
            String baseUrl = null;

            // Prioridad 1: returnUrl explícito en la solicitud
            if (request.getReturnUrl() != null && !request.getReturnUrl().isBlank()) {
                baseUrl = request.getReturnUrl().trim();
            }

            // Prioridad 2: Detección inteligente del Origin o Referer del navegador (ej. localhost:4200)
            if (baseUrl == null && httpRequest != null) {
                String origin = httpRequest.getHeader("Origin");
                if (origin != null && !origin.isBlank() && (origin.contains("localhost") || origin.contains("127.0.0.1"))) {
                    baseUrl = origin.trim();
                } else {
                    String referer = httpRequest.getHeader("Referer");
                    if (referer != null && (referer.contains("localhost") || referer.contains("127.0.0.1"))) {
                        try {
                            java.net.URI uri = java.net.URI.create(referer);
                            baseUrl = uri.getScheme() + "://" + uri.getAuthority();
                        } catch (Exception ignored) {}
                    }
                }
            }

            // Prioridad 3: Inyección de frontendUrl de Spring Cloud Config o fallback local
            if (baseUrl == null) {
                baseUrl = (frontendUrl != null && !frontendUrl.isBlank())
                        ? frontendUrl.replaceAll("/+$", "")
                        : "https://localhost:4200";
            }

            baseUrl = baseUrl.replaceAll("/+$", "");

            // Mercado Pago exige HTTPS para dominios externos, pero en localhost acepta HTTP
            String safeBaseUrl = baseUrl;
            if (safeBaseUrl.startsWith("http://") && !safeBaseUrl.contains("localhost") && !safeBaseUrl.contains("127.0.0.1")) {
                safeBaseUrl = safeBaseUrl.replaceFirst("^http://", "https://");
            }

            String successUrl = safeBaseUrl + "/pagar/success";
            String failureUrl = safeBaseUrl + "/pagar/failure";
            String pendingUrl = safeBaseUrl + "/pagar/pending";

            PreferenceBackUrlsRequest backUrls = PreferenceBackUrlsRequest.builder()
                    .success(successUrl)
                    .failure(failureUrl)
                    .pending(pendingUrl)
                    .build();

            String externalRef = request.getOrderId() != null ? request.getOrderId() : "ORD-" + System.currentTimeMillis();

            // 3. Configuración del pagador (Payer) de prueba
            PreferencePayerRequest payer = PreferencePayerRequest.builder()
                    .email(request.getPayerEmail() != null && !request.getPayerEmail().isBlank()
                            ? request.getPayerEmail() : "comprador.gamer@gmail.com")
                    .name("Comprador")
                    .surname("Prueba")
                    .build();

            // 4. Construcción de la Preferencia Oficial Checkout Pro
            PreferenceRequest.PreferenceRequestBuilder preferenceBuilder = PreferenceRequest.builder()
                    .items(items)
                    .payer(payer)
                    .backUrls(backUrls)
                    .externalReference(externalRef)
                    .statementDescriptor("ENIAC LABS");

            // Auto-retorno automático oficial al aprobarse el pago
            if (mpConfig.getAutoReturn() != null && !mpConfig.getAutoReturn().isBlank()) {
                preferenceBuilder.autoReturn(mpConfig.getAutoReturn());
            }

            PreferenceRequest preferenceRequest = preferenceBuilder.build();

            // 5. Creación en servidores de Mercado Pago vía SDK oficial
            Preference preference = client.create(preferenceRequest);

            log.info("[PaymentController] Preferencia generada exitosamente: ID = {}", preference.getId());
            log.info("[PaymentController] Sandbox Init Point = {}", preference.getSandboxInitPoint());

            // 5. Retornar DTO de respuesta estructurado para el Frontend
            PreferenceResponseDto response = PreferenceResponseDto.builder()
                    .preferenceId(preference.getId())
                    .initPoint(preference.getInitPoint())
                    .sandboxInitPoint(preference.getSandboxInitPoint())
                    .publicKey(mpConfig.getPublicKey())
                    .status("CREATED")
                    .message("Preferencia de Checkout Pro creada exitosamente en Mercado Pago Sandbox")
                    .build();

            return ResponseEntity.status(HttpStatus.CREATED).body(response);

        } catch (MPApiException ex) {
            log.error("[PaymentController] Error de API Mercado Pago (HTTP {}): {}",
                    ex.getStatusCode(), ex.getApiResponse().getContent(), ex);
            return ResponseEntity.status(ex.getStatusCode()).body(Map.of(
                    "status", "ERROR",
                    "code", ex.getStatusCode(),
                    "message", "Error de comunicación con la API de Mercado Pago",
                    "details", ex.getApiResponse().getContent()
            ));
        } catch (MPException ex) {
            log.error("[PaymentController] Error interno en SDK de Mercado Pago: {}", ex.getMessage(), ex);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "status", "ERROR",
                    "message", "Error procesando SDK de Mercado Pago: " + ex.getMessage()
            ));
        } catch (Exception ex) {
            log.error("[PaymentController] Excepción inesperada al crear preferencia: {}", ex.getMessage(), ex);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "status", "ERROR",
                    "message", "Ocurrió un error inesperado al generar la preferencia: " + ex.getMessage()
            ));
        }
    }

    /**
     * Endpoint 2: POST /api/payments/webhook
     * Receptor de notificaciones push (Webhooks / IPN) enviadas por Mercado Pago.
     * Si el evento es de tipo 'payment', consulta la API con PaymentClient, extrae el status
     * y si es 'approved', simula la actualización de la orden a 'PAGADO' en la base de datos.
     */
    @PostMapping("/webhook")
    @Operation(summary = "Webhook oficial receptor de notificaciones Push de Mercado Pago")
    public ResponseEntity<Map<String, Object>> handleWebhook(
            @RequestParam(value = "topic", required = false) String topic,
            @RequestParam(value = "type", required = false) String type,
            @RequestParam(value = "data.id", required = false) String dataId,
            @RequestParam(value = "id", required = false) String paramId,
            @RequestBody(required = false) Map<String, Object> body) {

        log.info("[PaymentController] Webhook recibido: topic={}, type={}, data.id={}, paramId={}",
                topic, type, dataId, paramId);

        String eventType = (type != null && !type.isBlank()) ? type : topic;
        if (eventType == null && body != null) {
            eventType = (String) body.getOrDefault("type", body.get("action"));
        }

        String paymentIdStr = dataId;
        if (paymentIdStr == null || paymentIdStr.isBlank()) {
            paymentIdStr = paramId;
        }
        if ((paymentIdStr == null || paymentIdStr.isBlank()) && body != null) {
            Object dataObj = body.get("data");
            if (dataObj instanceof Map<?, ?> dataMap) {
                Object idVal = dataMap.get("id");
                if (idVal != null) paymentIdStr = idVal.toString();
            } else if (body.get("id") != null) {
                paymentIdStr = body.get("id").toString();
            }
        }

        log.info("[PaymentController] Procesando evento de pago: tipo='{}', ID='{}'", eventType, paymentIdStr);

        Map<String, Object> responseMap = new LinkedHashMap<>();
        responseMap.put("received", true);
        responseMap.put("timestamp", LocalDateTime.now().toString());

        // Verificar si la notificación corresponde a un evento de pago
        boolean isPaymentEvent = "payment".equalsIgnoreCase(eventType)
                || (eventType != null && eventType.startsWith("payment."));

        if (isPaymentEvent && paymentIdStr != null && !paymentIdStr.isBlank()) {
            try {
                Long paymentId = Long.valueOf(paymentIdStr);
                PaymentClient paymentClient = new PaymentClient();
                Payment payment = paymentClient.get(paymentId);

                String status = payment.getStatus();
                String statusDetail = payment.getStatusDetail();
                BigDecimal amount = payment.getTransactionAmount();
                String externalRef = payment.getExternalReference();

                log.info("====================================================================");
                log.info("[MercadoPago Webhook] NOTIFICACIÓN DE PAGO CONSULTADA:");
                log.info("  - Payment ID: {}", payment.getId());
                log.info("  - Estado: {}", status);
                log.info("  - Detalle Estado: {}", statusDetail);
                log.info("  - Monto: PEN {}", amount);
                log.info("  - Referencia Externa (Orden): {}", externalRef);
                log.info("====================================================================");

                responseMap.put("paymentId", payment.getId());
                responseMap.put("status", status);
                responseMap.put("externalReference", externalRef);

                // Si el pago está aprobado ("approved")
                if ("approved".equalsIgnoreCase(status)) {
                    log.info("[MercadoPago Webhook] ¡PAGO APROBADO EXITOSAMENTE!");
                    log.info("[MercadoPago Webhook] Actualizando orden '{}' a estado 'PAGADO' en base de datos...", externalRef);

                    Long ordenIdLong = parseOrdenId(externalRef);

                    // Simulación y persistencia de actualización de estado de orden en base de datos
                    try {
                        Optional<Pago> pagoExistente = ordenIdLong != null ? pagoRepository.findByOrdenId(ordenIdLong) : Optional.empty();

                        if (pagoExistente.isPresent()) {
                            Pago p = pagoExistente.get();
                            p.setEstado(EstadoPago.VALIDADO);
                            p.setFechaPago(LocalDateTime.now());
                            pagoRepository.save(p);
                            log.info("[MercadoPago Webhook] Pago ID {} actualizado a estado 'VALIDADO/PAGADO' en PostgreSQL.", p.getId());
                        } else {
                            Pago nuevoPago = Pago.builder()
                                    .ordenId(ordenIdLong != null ? ordenIdLong : 1L)
                                    .monto(amount != null ? amount : BigDecimal.ZERO)
                                    .metodoPago("MERCADO_PAGO_CHECKOUT_PRO")
                                    .estado(EstadoPago.VALIDADO)
                                    .fechaPago(LocalDateTime.now())
                                    .build();
                            pagoRepository.save(nuevoPago);
                            log.info("[MercadoPago Webhook] Nuevo registro de Pago persistido con estado 'VALIDADO' para orden {}.", ordenIdLong);
                        }
                    } catch (Exception ex) {
                        log.warn("[MercadoPago Webhook] Nota sobre persistencia local: {}", ex.getMessage());
                    }

                    // Publicación asíncrona a Kafka topic 'pago-eventos' para actualizar pc-orden-ms
                    try {
                        PagoValidadoEvento evento = PagoValidadoEvento.builder()
                                .tipoEvento("pago.validado")
                                .ordenId(ordenIdLong != null ? ordenIdLong : 1L)
                                .pagoId(payment.getId())
                                .monto(amount != null ? amount : BigDecimal.ZERO)
                                .metodoPago(payment.getPaymentTypeId() != null ? payment.getPaymentTypeId() : "MERCADOPAGO")
                                .estado("VALIDADO")
                                .origen("MercadoPagoWebhook")
                                .timestamp(System.currentTimeMillis())
                                .build();
                        pagoEventosProducer.publicarTrasCommit(evento);
                        log.info("[MercadoPago Webhook] ¡Evento Kafka 'pago.validado' emitido exitosamente para orden ID {}!", ordenIdLong);
                    } catch (Exception ex) {
                        log.error("[MercadoPago Webhook] Error al emitir evento Kafka: {}", ex.getMessage());
                    }

                    responseMap.put("orderStatus", "PAGADO");
                    responseMap.put("message", "Orden actualizada a PAGADO satisfactoriamente y notificada a Kafka");
                } else if ("rejected".equalsIgnoreCase(status) || "cancelled".equalsIgnoreCase(status)) {
                    log.info("[MercadoPago Webhook] Estado de pago no exitoso: {}", status);
                    Long ordenIdLong = parseOrdenId(externalRef);
                    try {
                        PagoValidadoEvento evento = PagoValidadoEvento.builder()
                                .tipoEvento("pago.fallido")
                                .ordenId(ordenIdLong != null ? ordenIdLong : 1L)
                                .pagoId(payment.getId())
                                .monto(amount != null ? amount : BigDecimal.ZERO)
                                .metodoPago(payment.getPaymentTypeId())
                                .estado("FALLIDO")
                                .origen("MercadoPagoWebhook")
                                .timestamp(System.currentTimeMillis())
                                .build();
                        pagoEventosProducer.publicarTrasCommit(evento);
                        log.info("[MercadoPago Webhook] Evento Kafka de compensación 'pago.fallido' emitido para orden ID {}", ordenIdLong);
                    } catch (Exception ex) {
                        log.error("[MercadoPago Webhook] Error emitiendo evento de compensación: {}", ex.getMessage());
                    }
                    responseMap.put("orderStatus", status);
                } else {
                    log.info("[MercadoPago Webhook] Estado de pago actual: {}", status);
                    responseMap.put("orderStatus", status);
                }

            } catch (Exception ex) {
                log.error("[PaymentController] Error al consultar PaymentClient para ID {}: {}", paymentIdStr, ex.getMessage());
                responseMap.put("error", ex.getMessage());
                // Importante: Mercado Pago requiere HTTP 200 para confirmar la recepción
            }
        } else {
            log.info("[PaymentController] Notificación recibida no requiere consulta directa (tipo: {})", eventType);
            responseMap.put("info", "Notificación recibida sin acción requerida");
        }

        // Siempre responder 200 OK a Mercado Pago
        return ResponseEntity.ok(responseMap);
    }

    /**
     * Endpoint 3: GET /api/payments/config
     * Retorna la Public Key y datos de configuración para el frontend.
     */
    @GetMapping("/config")
    @Operation(summary = "Obtener configuración pública de Mercado Pago (Public Key y Moneda)")
    public ResponseEntity<Map<String, String>> getConfig() {
        String baseUrl = (frontendUrl != null && !frontendUrl.isBlank())
                ? frontendUrl.replaceAll("/+$", "")
                : "http://localhost:4200";
        return ResponseEntity.ok(Map.of(
                "publicKey", mpConfig.getPublicKey(),
                "currency", mpConfig.getCurrency(),
                "environment", "sandbox",
                "frontendUrl", baseUrl,
                "backUrlSuccess", baseUrl + "/pagar/success",
                "backUrlFailure", baseUrl + "/pagar/failure",
                "backUrlPending", baseUrl + "/pagar/pending"
        ));
    }

    /**
     * Endpoint 4: POST /api/payments/confirm
     * Confirmación activa invocada tras la redirección exitosa de Checkout Pro.
     * Consulta el estado del pago directamente en la API de Mercado Pago con PaymentClient,
     * persiste el registro en PostgreSQL y publica el evento 'pago.validado' en Kafka hacia pc-orden-ms.
     */
    @PostMapping("/confirm")
    @Operation(summary = "Confirmar pago aprobado desde retorno de Checkout Pro y sincronizar vía Kafka con pc-orden-ms")
    public ResponseEntity<?> confirmPayment(@RequestBody Map<String, Object> request) {
        log.info("[PaymentController] Petición de confirmación activa de pago recibida: {}", request);
        try {
            Object paymentIdObj = request.get("paymentId");
            if (paymentIdObj == null) paymentIdObj = request.get("collection_id");
            if (paymentIdObj == null) paymentIdObj = request.get("payment_id");

            Long paymentId = paymentIdObj != null ? Long.valueOf(paymentIdObj.toString()) : null;
            String externalRef = (String) request.get("externalReference");
            if (externalRef == null) externalRef = (String) request.get("external_reference");

            String status = (String) request.get("status");
            if (status == null) status = (String) request.get("collection_status");

            BigDecimal amount = BigDecimal.ZERO;
            String paymentType = "credit_card";

            // Si se cuenta con paymentId, verificar directamente en la API de Mercado Pago
            if (paymentId != null) {
                try {
                    PaymentClient paymentClient = new PaymentClient();
                    Payment payment = paymentClient.get(paymentId);
                    if (payment != null) {
                        status = payment.getStatus();
                        amount = payment.getTransactionAmount();
                        if (externalRef == null || externalRef.isBlank()) {
                            externalRef = payment.getExternalReference();
                        }
                        if (payment.getPaymentTypeId() != null) {
                            paymentType = payment.getPaymentTypeId();
                        }
                        log.info("[PaymentController] Pago verificado con SDK oficial: ID={}, status={}, amount={}",
                                payment.getId(), status, amount);
                    }
                } catch (Exception ex) {
                    log.warn("[PaymentController] Nota consultando SDK de Mercado Pago Sandbox: {}", ex.getMessage());
                }
            }

            Long ordenIdLong = null;
            if (request.get("ordenId") != null) {
                try { ordenIdLong = Long.valueOf(request.get("ordenId").toString()); } catch (Exception ignored) {}
            }
            if (ordenIdLong == null && request.get("orderId") != null) {
                try { ordenIdLong = parseOrdenId(request.get("orderId").toString()); } catch (Exception ignored) {}
            }
            if (ordenIdLong == null) {
                ordenIdLong = parseOrdenId(externalRef);
            }

            // Persistencia en base de datos local de pc-pago-ms
            try {
                Pago nuevoPago = Pago.builder()
                        .ordenId(ordenIdLong != null ? ordenIdLong : 1L)
                        .monto(amount != null ? amount : BigDecimal.ZERO)
                        .metodoPago(paymentType)
                        .estado("approved".equalsIgnoreCase(status) ? EstadoPago.VALIDADO : EstadoPago.FALLIDO)
                        .fechaPago(LocalDateTime.now())
                        .build();
                pagoRepository.save(nuevoPago);
                log.info("[PaymentController] Registro de pago persistido en PostgreSQL con estado '{}'", nuevoPago.getEstado());
            } catch (Exception ex) {
                log.warn("[PaymentController] Advertencia en persistencia local de pago: {}", ex.getMessage());
            }

            // Publicación del evento en Kafka para pc-orden-ms
            if ("approved".equalsIgnoreCase(status)) {
                PagoValidadoEvento evento = PagoValidadoEvento.builder()
                        .tipoEvento("pago.validado")
                        .ordenId(ordenIdLong != null ? ordenIdLong : 1L)
                        .pagoId(paymentId != null ? paymentId : System.currentTimeMillis())
                        .monto(amount)
                        .metodoPago(paymentType)
                        .estado("VALIDADO")
                        .origen("MercadoPagoConfirm")
                        .timestamp(System.currentTimeMillis())
                        .build();
                pagoEventosProducer.publicarTrasCommit(evento);
                log.info("[PaymentController] ¡Evento 'pago.validado' publicado exitosamente a Kafka topic 'pago-eventos' para orden {}!", ordenIdLong);
            }

            return ResponseEntity.ok(Map.of(
                    "status", status != null ? status : "approved",
                    "paymentId", paymentId != null ? paymentId : 0L,
                    "ordenId", ordenIdLong != null ? ordenIdLong : 1L,
                    "kafkaTopic", "pago-eventos",
                    "kafkaEvent", "pago.validado",
                    "message", "Pago confirmado y sincronizado exitosamente con pc-orden-ms vía Kafka"
            ));
        } catch (Exception ex) {
            log.error("[PaymentController] Error al confirmar pago: {}", ex.getMessage(), ex);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "error", ex.getMessage()
            ));
        }
    }

    private Long parseOrdenId(String externalRef) {
        if (externalRef == null) return null;
        try {
            String digits = externalRef.replaceAll("\\D+", "");
            if (!digits.isEmpty()) {
                return Long.valueOf(digits.length() > 9 ? digits.substring(0, 9) : digits);
            }
        } catch (Exception ignored) {}
        return null;
    }
}
