package pe.edu.upeu.eniaclabs.pago.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "transacciones_pago")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TransaccionPago {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long ordenId;

    @Column(nullable = false, length = 50)
    private String codigoOrden;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal monto;

    @Column(nullable = false, length = 10)
    @Builder.Default
    private String moneda = "PEN";

    @Column(nullable = false, length = 50)
    @Builder.Default
    private String metodoPago = "MERCADO_PAGO";

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    @Builder.Default
    private EstadoPago estado = EstadoPago.PENDIENTE;

    @Column(length = 100)
    private String mpPaymentId;

    @Column(length = 100)
    private String mpPreferenceId;

    @Column(length = 500)
    private String sandboxInitPoint;

    @Column(length = 100)
    private String externalReference;

    @Column(length = 150)
    private String payerEmail;

    @Column(columnDefinition = "TEXT")
    private String rawWebhookPayload;

    @Column(nullable = false)
    private LocalDateTime fechaCreacion;

    private LocalDateTime fechaActualizacion;

    @PrePersist
    public void prePersist() {
        this.fechaCreacion = LocalDateTime.now();
        this.fechaActualizacion = LocalDateTime.now();
    }

    @PreUpdate
    public void preUpdate() {
        this.fechaActualizacion = LocalDateTime.now();
    }
}