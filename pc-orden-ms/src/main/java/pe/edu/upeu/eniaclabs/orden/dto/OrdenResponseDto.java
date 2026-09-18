package pe.edu.upeu.eniaclabs.orden.dto;

import lombok.*;
import pe.edu.upeu.eniaclabs.orden.entity.EstadoOrden;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrdenResponseDto {
    private Long id;
    private String codigoOrden;
    private Long clienteId;
    private String clienteNombre;
    private String clienteEmail;
    private BigDecimal subtotal;
    private BigDecimal igv;
    private BigDecimal total;
    private EstadoOrden estado;
    private String metodoPago;
    private String direccionEnvio;
    private String observaciones;
    private LocalDateTime fechaCreacion;
    private LocalDateTime fechaActualizacion;
    private List<DetalleOrdenResponseDto> detalles;
}