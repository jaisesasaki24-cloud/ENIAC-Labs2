package pe.edu.upeu.eniaclabs.pago.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para la petición de cobro a Culqi Checkout v4.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CulqiChargeRequestDto {

    @NotBlank(message = "El token de Culqi es obligatorio")
    private String token;

    @NotNull(message = "El monto en céntimos es obligatorio")
    private Long amount; // En céntimos (ej. S/ 10.00 = 1000)

    @NotBlank(message = "El email del pagador es obligatorio")
    private String email;

    private String orderId;
}
