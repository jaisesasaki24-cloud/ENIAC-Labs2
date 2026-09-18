package pe.edu.upeu.eniaclabs.pago.dto;

import jakarta.validation.constraints.NotNull;
import lombok.*;
import pe.edu.upeu.eniaclabs.pago.entity.EstadoPago;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SimularPagoDto {
    @NotNull(message = "El estado del pago es requerido")
    private EstadoPago nuevoEstado;
    private String mpPaymentId;
}