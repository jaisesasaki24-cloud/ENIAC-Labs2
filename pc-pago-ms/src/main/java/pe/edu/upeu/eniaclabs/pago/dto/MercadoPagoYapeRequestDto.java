package pe.edu.upeu.eniaclabs.pago.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO para la petición de pago Yape a través de la Orders API de Mercado Pago (/v1/orders).
 * Procesa el pago de forma síncrona en modo automatic ("processing_mode": "automatic").
 *
 * @author ENIAC Labs - Arquitectura de Pagos Distribuidos
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MercadoPagoYapeRequestDto {

    @NotBlank(message = "El token de Yape es obligatorio")
    private String token;

    @NotNull(message = "El monto a cobrar es obligatorio")
    private BigDecimal amount;

    private String orderId;
    private String email;
    private String phoneNumber;
    private String dni;
    private String nombre;
    private String stateId; // Código ISO ej: "PE-LIM"
}
