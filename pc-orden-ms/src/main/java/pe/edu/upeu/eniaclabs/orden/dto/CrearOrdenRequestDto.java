package pe.edu.upeu.eniaclabs.orden.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CrearOrdenRequestDto {
    @NotNull(message = "El ID del cliente es obligatorio")
    private Long clienteId;

    @NotBlank(message = "El nombre del cliente es obligatorio")
    private String clienteNombre;

    @NotBlank(message = "El email del cliente es obligatorio")
    @Email(message = "Formato de email invalido")
    private String clienteEmail;

    private String metodoPago;
    private String direccionEnvio;
    private String observaciones;

    @NotEmpty(message = "La orden debe contener al menos un producto de hardware")
    @Valid
    private List<DetalleOrdenRequestDto> items;
}