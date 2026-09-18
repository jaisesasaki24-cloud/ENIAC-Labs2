package pe.edu.upeu.eniaclabs.cotizacion.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import lombok.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CrearCotizacionRequestDto {
    @NotBlank(message = "El nombre del cliente es obligatorio")
    private String clienteNombre;

    @NotBlank(message = "El correo electronico es obligatorio")
    @Email(message = "Formato de correo invalido")
    private String clienteEmail;

    private String clienteTelefono;
    private String usoDestino; // Gaming 1080p, Render 4K, Edicion, Oficina

    @NotEmpty(message = "Debe incluir al menos un componente en la cotizacion")
    @Valid
    private List<ItemCotizacionDto> items;
}