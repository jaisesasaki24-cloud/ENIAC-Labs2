package pe.edu.upeu.eniaclabs.cotizacion.dto;

import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ConvertirOrdenResponseDto {
    private Long cotizacionId;
    private String codigoProforma;
    private Long ordenId;
    private String codigoOrden;
    private String estadoOrden;
    private BigDecimal total;
    private String mensaje;
}