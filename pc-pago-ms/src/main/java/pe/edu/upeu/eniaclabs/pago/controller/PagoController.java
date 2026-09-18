package pe.edu.upeu.eniaclabs.pago.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.edu.upeu.eniaclabs.pago.dto.CheckoutRequestDto;
import pe.edu.upeu.eniaclabs.pago.dto.MercadoPagoWebhookDto;
import pe.edu.upeu.eniaclabs.pago.dto.PagoResponseDto;
import pe.edu.upeu.eniaclabs.pago.dto.SimularPagoDto;
import pe.edu.upeu.eniaclabs.pago.entity.EstadoPago;
import pe.edu.upeu.eniaclabs.pago.service.PagoService;

import java.util.List;

@RestController
@RequestMapping("/api/v1/pagos")
@RequiredArgsConstructor
@Tag(name = "Pasarela Mercado Pago Sandbox y Webhooks", description = "Endpoints transaccionales para procesamiento de pagos y recepcion de IPN Webhooks")
public class PagoController {

    private final PagoService pagoService;
    private final ObjectMapper objectMapper;

    @GetMapping
    @Operation(summary = "Listar transacciones de pago con filtro opcional por estado")
    public ResponseEntity<List<PagoResponseDto>> findAll(@RequestParam(required = false) EstadoPago estado) {
        return ResponseEntity.ok(pagoService.findAll(estado));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener detalle de transaccion de pago por ID")
    public ResponseEntity<PagoResponseDto> findById(@PathVariable Long id) {
        return ResponseEntity.ok(pagoService.findById(id));
    }

    @GetMapping("/orden/{ordenId}")
    @Operation(summary = "Consultar pagos asociados a una orden de compra")
    public ResponseEntity<List<PagoResponseDto>> findByOrdenId(@PathVariable Long ordenId) {
        return ResponseEntity.ok(pagoService.findByOrdenId(ordenId));
    }

    @PostMapping("/checkout")
    @Operation(summary = "Generar preferencia de pago Mercado Pago Sandbox y link de pago (Init Point)")
    public ResponseEntity<PagoResponseDto> checkout(@Valid @RequestBody CheckoutRequestDto request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(pagoService.crearCheckoutSandbox(request));
    }

    @PostMapping("/webhook")
    @Operation(summary = "Endpoint receptor de notificaciones Webhook / IPN de Mercado Pago")
    public ResponseEntity<PagoResponseDto> handleWebhook(@RequestBody String rawPayload) {
        try {
            MercadoPagoWebhookDto dto = objectMapper.readValue(rawPayload, MercadoPagoWebhookDto.class);
            return ResponseEntity.ok(pagoService.procesarWebhook(dto, rawPayload));
        } catch (Exception e) {
            MercadoPagoWebhookDto fallback = MercadoPagoWebhookDto.builder()
                    .action("payment.created")
                    .type("payment")
                    .build();
            return ResponseEntity.ok(pagoService.procesarWebhook(fallback, rawPayload));
        }
    }

    @PostMapping("/{id}/simular")
    @Operation(summary = "Simular aprobacion o rechazo de pago para pruebas de laboratorio y sustentacion S05")
    public ResponseEntity<PagoResponseDto> simularPago(
            @PathVariable Long id,
            @Valid @RequestBody SimularPagoDto request) {
        return ResponseEntity.ok(pagoService.simularResultadoPago(id, request));
    }
}