package pe.edu.upeu.eniaclabs.pago.dto;

import lombok.*;
import pe.edu.upeu.eniaclabs.pago.entity.EstadoPago;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PagoResponseDto {
    private Long id;
    private Long ordenId;
    private String codigoOrden;
    private BigDecimal monto;
    private String moneda;
    private String metodoPago;
    private EstadoPago estado;
    private String mpPaymentId;
    private String mpPreferenceId;
    private String sandboxInitPoint;
    private String externalReference;
    private String payerEmail;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaActualizacion;
}