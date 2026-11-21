package pe.edu.upeu.eniaclabs.pago.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO de respuesta para el frontend tras procesar el cobro en Culqi.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CulqiChargeResponseDto {

    private boolean success;
    private String status;
    private String chargeId;
    private String outcomeType;
    private String message;
    private Long orderId;
    private Long amount;
    private String currency;
}
