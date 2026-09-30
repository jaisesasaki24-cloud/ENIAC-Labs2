package pe.edu.upeu.eniaclabs.cotizacion.dto;

import lombok.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AsesorIaResponseDto {
    private boolean compatible;
    private String conclusion;
    private String analisisDetallado;
    private String razonamientoNemotron;
    private List<String> advertencias;
    private List<String> recomendaciones;
    private String modeloUtilizado;
}
