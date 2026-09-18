package pe.edu.upeu.eniaclabs.auth.dto;

import lombok.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AuthResponseDto {
    private String token;
    private String tokenType;
    private Long id;
    private String username;
    private String email;
    private String nombresCompletos;
    private List<String> roles;
}