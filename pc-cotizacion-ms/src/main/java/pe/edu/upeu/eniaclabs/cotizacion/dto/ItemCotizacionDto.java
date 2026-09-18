package pe.edu.upeu.eniaclabs.cotizacion.dto;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ItemCotizacionDto {
    @NotNull(message = "El ID del producto es obligatorio")
    private Long productoId;

    private String categoria;

    @NotBlank(message = "El SKU es obligatorio")
    private String sku;

    @NotBlank(message = "La descripcion del componente es obligatoria")
    private String descripcion;

    @NotNull(message = "El precio unitario es obligatorio")
    @DecimalMin(value = "0.01", message = "El precio debe ser mayor a 0")
    private BigDecimal precioUnitario;

    @NotNull(message = "La cantidad es obligatoria")
    @Min(value = 1, message = "La cantidad minima es 1")
    private Integer cantidad;

    private BigDecimal subtotal;
}