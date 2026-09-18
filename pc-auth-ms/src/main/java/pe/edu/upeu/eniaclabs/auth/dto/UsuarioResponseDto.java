package pe.edu.upeu.eniaclabs.auth.dto;

import lombok.*;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UsuarioResponseDto {
    private Long id;
    private String username;
    private String email;
    private String nombres;
    private String apellidos;
    private String telefono;
    private Boolean activo;
    private List<String> roles;
    private LocalDateTime fechaCreacion;
}