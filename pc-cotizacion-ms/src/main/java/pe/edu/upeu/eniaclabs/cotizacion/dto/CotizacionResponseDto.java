package pe.edu.upeu.eniaclabs.cotizacion.dto;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CotizacionResponseDto {
    private Long id;
    private String codigoProforma;
    private String clienteNombre;
    private String clienteEmail;
    private String clienteTelefono;
    private String usoDestino;
    private BigDecimal subtotal;
    private BigDecimal igv;
    private BigDecimal total;
    private String estado;
    private LocalDateTime fechaExpiracion;
    private LocalDateTime fechaCreacion;
    private List<ItemCotizacionDto> items;
}