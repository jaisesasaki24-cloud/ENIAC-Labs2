package pe.edu.upeu.eniaclabs.pago.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO que representa un ítem individual dentro de una preferencia de pago.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Detalle de un producto individual dentro de la preferencia")
public class PreferenceItemDto {

    @Schema(description = "ID o SKU del producto", example = "gpu-rtx4080")
    private String id;

    @Schema(description = "Título del producto", example = "GeForce RTX 4080 Super OC 16GB")
    private String title;

    @Schema(description = "Descripción del ítem", example = "Ada Lovelace 16GB GDDR6X")
    private String description;

    @Schema(description = "URL de la imagen del producto", example = "https://eniaclabs.pe/images/gpu-rtx4080.jpg")
    private String pictureUrl;

    @Schema(description = "Cantidad", example = "1")
    private Integer quantity;

    @Schema(description = "Precio unitario", example = "3399.00")
    private BigDecimal unitPrice;

    @Schema(description = "Moneda (ej. PEN)", example = "PEN")
    private String currencyId;
}
