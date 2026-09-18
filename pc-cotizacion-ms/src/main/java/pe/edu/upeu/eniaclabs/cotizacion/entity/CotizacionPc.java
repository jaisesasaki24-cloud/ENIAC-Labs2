package pe.edu.upeu.eniaclabs.cotizacion.entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "cotizaciones")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CotizacionPc {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 30)
    private String codigoProforma;

    @Column(nullable = false, length = 100)
    private String clienteNombre;

    @Column(nullable = false, length = 100)
    private String clienteEmail;

    @Column(length = 20)
    private String clienteTelefono;

    @Column(length = 100)
    private String usoDestino;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal subtotal;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal igv;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal total;

    @Column(nullable = false, length = 30)
    private String estado; // VIGENTE, CONVERTIDA_A_ORDEN, VENCIDA

    @Column(nullable = false)
    private LocalDateTime fechaExpiracion;

    @Column(nullable = false, updatable = false)
    private LocalDateTime fechaCreacion;

    @OneToMany(mappedBy = "cotizacion", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    @Builder.Default
    private List<CotizacionItem> items = new ArrayList<>();

    @PrePersist
    public void prePersist() {
        if (fechaCreacion == null) fechaCreacion = LocalDateTime.now();
        if (fechaExpiracion == null) fechaExpiracion = fechaCreacion.plusDays(7);
        if (estado == null) estado = "VIGENTE";
    }

    public void addItem(CotizacionItem item) {
        items.add(item);
        item.setCotizacion(this);
    }
}