package pe.edu.upeu.eniaclabs.pago.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * DTO de respuesta para el pago con Yape (Mercado Pago Orders API).
 * Proporciona el resultado síncrono en tiempo real (processing_mode: automatic).
 *
 * @author ENIAC Labs - Arquitectura de Pagos Distribuidos
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MercadoPagoYapeResponseDto {

    private boolean success;
    private String status;           // "processed", "failed", "rejected"
    private String statusDetail;     // "accredited", etc.
    private String orderId;          // Referencia externa (número de orden ENIAC Labs)
    private String mpOrderId;        // ID de la orden en Mercado Pago (ej. ORDPE...)
    private String paymentId;        // ID del pago en Mercado Pago (ej. PAYPE...)
    private BigDecimal amount;       // Monto efectivamente pagado
    private String currency;         // "PEN"
    private String message;          // Mensaje informativo para el usuario
}
