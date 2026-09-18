package pe.edu.upeu.eniaclabs.catalogo.dto;

import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductoResponseDto {
    private Long id;
    private String sku;
    private String nombre;
    private String marca;
    private String modelo;
    private BigDecimal precio;
    private Integer stockActual;
    private Integer stockMinimo;
    private Integer garantiaMeses;
    private String especificaciones;
    private Boolean activo;
    private Long categoriaId;
    private String categoriaNombre;
}