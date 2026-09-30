package pe.edu.upeu.eniaclabs.orden.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductoResponseDto {
    private Long id;
    private String sku;
    private String nombre;
    private BigDecimal precio;
    private Integer stock;
    private Boolean activo;
}
