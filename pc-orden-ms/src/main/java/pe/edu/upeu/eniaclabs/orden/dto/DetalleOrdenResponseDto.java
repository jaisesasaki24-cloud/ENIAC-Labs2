package pe.edu.upeu.eniaclabs.orden.dto;

import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DetalleOrdenResponseDto {
    private Long id;
    private Long productoId;
    private String sku;
    private String productoNombre;
    private BigDecimal precioUnitario;
    private Integer cantidad;
    private BigDecimal subtotalLinea;
}