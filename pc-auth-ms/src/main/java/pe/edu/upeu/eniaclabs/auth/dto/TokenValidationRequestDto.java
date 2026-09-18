package pe.edu.upeu.eniaclabs.auth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TokenValidationRequestDto {
    @NotBlank(message = "El token es obligatorio")
    private String token;
}