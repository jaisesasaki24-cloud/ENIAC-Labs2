package pe.edu.upeu.eniaclabs.cotizacion.dto;

import lombok.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AsesorIaRequestDto {
    private String consulta;
    private String tipoUso; // Ej: GAMING_4K, DISENO_3D, ENTRENAMIENTO_IA, OFIMATICA
    private BigDecimal presupuestoAproximado;
    private String procesador;
    private String placaMadre;
    private String tarjetaGrafica;
    private String memoriaRam;
    private Integer fuenteWatts;
}
