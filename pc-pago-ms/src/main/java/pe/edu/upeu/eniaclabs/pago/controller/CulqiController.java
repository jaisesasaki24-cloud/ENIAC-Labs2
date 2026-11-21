package pe.edu.upeu.eniaclabs.pago.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.edu.upeu.eniaclabs.pago.dto.CulqiChargeRequestDto;
import pe.edu.upeu.eniaclabs.pago.dto.CulqiChargeResponseDto;
import pe.edu.upeu.eniaclabs.pago.service.CulqiService;

import java.util.Map;

/**
 * Controlador REST oficial para la pasarela de pagos Culqi (Checkout v4).
 * Soporta cobros de Yape y tarjetas de crédito/débito.
 * Mapeado a ambas rutas para máxima compatibilidad con el API Gateway y clientes directos:
 *  - /api/pagos/culqi
 *  - /api/v1/pagos/culqi
 */
@Slf4j
@RestController
@RequestMapping({"/api/pagos/culqi", "/api/v1/pagos/culqi"})
@CrossOrigin(origins = "*", allowedHeaders = "*", methods = {
        RequestMethod.GET, RequestMethod.POST, RequestMethod.OPTIONS
})
@RequiredArgsConstructor
@Tag(name = "Culqi Checkout v4 (/api/pagos/culqi)", description = "Integración con pasarela Culqi para cobros de Yape y tarjetas de crédito/débito")
public class CulqiController {

    private final CulqiService culqiService;

    /**
     * Endpoint oficial para cobrar un cargo generado en Culqi Checkout v4:
     * POST /api/pagos/culqi/cobrar
     *
     * @param request Datos del cobro: token (source_id), amount (céntimos), email, orderId.
     * @return Resultado de la transacción (aprobado o rechazado).
     */
    @PostMapping("/cobrar")
    @Operation(summary = "Procesar cobro directo en Culqi v2 Charges (Yape / Tarjetas)")
    public ResponseEntity<CulqiChargeResponseDto> cobrar(@Valid @RequestBody CulqiChargeRequestDto request) {
        log.info("[CulqiController] Recibida solicitud de cobro: token={}, monto={} céntimos, email={}, orden={}",
                request.getToken(), request.getAmount(), request.getEmail(), request.getOrderId());

        CulqiChargeResponseDto response = culqiService.procesarCobro(request);

        if (response.isSuccess()) {
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } else {
            // Devolver 400 con el DTO para que el frontend obtenga los detalles del rechazo
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }
    }

    /**
     * Endpoint para obtener la configuración pública de Culqi (Public Key y Moneda):
     * GET /api/pagos/culqi/config
     */
    @GetMapping("/config")
    @Operation(summary = "Obtener configuración pública de Culqi (Public Key y Moneda)")
    public ResponseEntity<Map<String, String>> getConfig() {
        return ResponseEntity.ok(culqiService.getPublicConfig());
    }
}
