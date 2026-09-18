package pe.edu.upeu.eniaclabs.catalogo.dto;

import jakarta.validation.constraints.*;
import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductoRequestDto {
    @NotBlank(message = "El SKU es obligatorio")
    @Size(max = 60, message = "El SKU no puede exceder 60 caracteres")
    private String sku;

    @NotBlank(message = "El nombre es obligatorio")
    @Size(max = 150, message = "El nombre no puede exceder 150 caracteres")
    private String nombre;

    @NotBlank(message = "La marca es obligatoria")
    @Size(max = 80, message = "La marca no puede exceder 80 caracteres")
    private String marca;

    @NotBlank(message = "El modelo es obligatorio")
    @Size(max = 80, message = "El modelo no puede exceder 80 caracteres")
    private String modelo;

    @NotNull(message = "El precio es obligatorio")
    @DecimalMin(value = "0.01", message = "El precio debe ser mayor a cero")
    private BigDecimal precio;

    @NotNull(message = "El stock actual es obligatorio")
    @Min(value = 0, message = "El stock no puede ser negativo")
    private Integer stockActual;

    @Builder.Default
    @Min(value = 0, message = "El stock minimo no puede ser negativo")
    private Integer stockMinimo = 3;

    @Builder.Default
    @Min(value = 0, message = "La garantia no puede ser negativa")
    private Integer garantiaMeses = 24;

    private String especificaciones;

    @NotNull(message = "La categoria es obligatoria")
    private Long categoriaId;

    @Builder.Default
    private Boolean activo = true;
}