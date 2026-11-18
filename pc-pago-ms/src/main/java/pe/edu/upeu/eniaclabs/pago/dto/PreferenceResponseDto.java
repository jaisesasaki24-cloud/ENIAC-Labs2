package pe.edu.upeu.eniaclabs.pago.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO de respuesta que retorna el preferenceId y los URLs de inicio de pago (InitPoint).
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Respuesta con los datos de la preferencia generada para Checkout Pro")
public class PreferenceResponseDto {

    @Schema(description = "ID único de la preferencia en Mercado Pago", example = "102620-22d3ad8bb4a98ca436917a52a528a8a1-3796765560")
    private String preferenceId;

    @Schema(description = "URL oficial de redirección para pago en producción")
    private String initPoint;

    @Schema(description = "URL de redirección para pruebas en Sandbox")
    private String sandboxInitPoint;

    @Schema(description = "Public Key oficial requerida para inicializar el SDK JS en el Frontend")
    private String publicKey;

    @Schema(description = "Estado de la solicitud", example = "CREATED")
    private String status;

    @Schema(description = "Mensaje informativo")
    private String message;
}
