package pe.edu.upeu.eniaclabs.auth.dto;

import lombok.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TokenValidationResponseDto {
    private boolean valid;
    private String username;
    private Long userId;
    private List<String> roles;
    private String message;
}