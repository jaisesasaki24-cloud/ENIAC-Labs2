package pe.edu.upeu.eniaclabs.catalogo.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StockResponseDto {
    private Long productoId;
    private String sku;
    private Integer stockAnterior;
    private Integer stockActual;
    private boolean disponible;
    private String mensaje;
}