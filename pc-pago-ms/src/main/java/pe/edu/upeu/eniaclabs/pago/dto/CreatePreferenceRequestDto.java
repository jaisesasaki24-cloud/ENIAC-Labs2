package pe.edu.upeu.eniaclabs.pago.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

/**
 * DTO de solicitud para generar preferencia de pago Checkout Pro en Mercado Pago.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Datos del pedido para generar la preferencia de Checkout Pro")
public class CreatePreferenceRequestDto {

    @NotBlank(message = "El título o descripción del producto es obligatorio")
    @Schema(description = "Título o nombre del producto", example = "GeForce RTX 4080 Super OC 16GB")
    private String title;

    @NotNull(message = "La cantidad es obligatoria")
    @Min(value = 1, message = "La cantidad mínima es 1")
    @Schema(description = "Cantidad de unidades", example = "1")
    private Integer quantity;

    @NotNull(message = "El precio unitario es obligatorio")
    @DecimalMin(value = "0.01", message = "El precio unitario debe ser mayor a 0")
    @Schema(description = "Precio unitario en PEN (Soles)", example = "3399.00")
    private BigDecimal unitPrice;

    @Schema(description = "Identificador de moneda ISO (ej. PEN, USD)", example = "PEN")
    private String currencyId;

    @Schema(description = "Identificador o código de la orden de compra en ENIAC Labs", example = "ORD-2026-9041")
    private String orderId;

    @Schema(description = "Correo electrónico del pagador", example = "comprador.gamer@gmail.com")
    private String payerEmail;

    @Schema(description = "Lista detallada de ítems (opcional si se envían múltiples productos del carrito)")
    private List<PreferenceItemDto> items;

    @Schema(description = "URL base de retorno personalizada (opcional, ej. https://localhost:4200)", example = "https://localhost:4200")
    private String returnUrl;
}
