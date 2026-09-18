package pe.edu.upeu.eniaclabs.orden.dto;

import jakarta.validation.constraints.NotNull;
import lombok.*;
import pe.edu.upeu.eniaclabs.orden.entity.EstadoOrden;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ActualizarEstadoOrdenDto {
    @NotNull(message = "El nuevo estado es requerido")
    private EstadoOrden nuevoEstado;
}