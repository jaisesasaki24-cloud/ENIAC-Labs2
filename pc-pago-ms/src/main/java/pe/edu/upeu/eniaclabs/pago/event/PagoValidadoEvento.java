package pe.edu.upeu.eniaclabs.pago.event;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PagoValidadoEvento {
    private String tipoEvento;
    private Long ordenId;
    private Long pagoId;
    private BigDecimal monto;
    private String metodoPago;
    private String estado;
    private String origen;
    private Long timestamp;
}
