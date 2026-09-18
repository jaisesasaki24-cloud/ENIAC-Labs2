package pe.edu.upeu.eniaclabs.cotizacion.dto;

import lombok.*;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ValidarCompatibilidadDto {
    private String procesador; // Ej: AMD Ryzen 7 7800X3D (AM5)
    private String placaMadre; // Ej: ASUS TUF B650 (AM5)
    private String tarjetaGrafica; // Ej: RTX 4070 Ti Super
    private Integer fuenteWatts; // Ej: 750W
    private Boolean compatible;
    private String mensaje;
    private List<String> advertencias;
}