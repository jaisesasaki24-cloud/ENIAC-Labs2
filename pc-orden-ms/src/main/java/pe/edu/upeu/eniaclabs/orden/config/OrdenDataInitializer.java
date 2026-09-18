package pe.edu.upeu.eniaclabs.orden.config;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import pe.edu.upeu.eniaclabs.orden.entity.EstadoOrden;
import pe.edu.upeu.eniaclabs.orden.entity.OrdenCompra;
import pe.edu.upeu.eniaclabs.orden.entity.OrdenCompraDetalle;
import pe.edu.upeu.eniaclabs.orden.repository.OrdenCompraRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Component
@RequiredArgsConstructor
public class OrdenDataInitializer implements CommandLineRunner {

    private final OrdenCompraRepository ordenRepository;

    @Override
    public void run(String... args) {
        if (ordenRepository.count() > 0) {
            return;
        }

        OrdenCompra o = OrdenCompra.builder()
                .codigoOrden("ENIAC-20260901-0001")
                .clienteId(1L)
                .clienteNombre("Eliceo Parillo Mostajo")
                .clienteEmail("eliceo.parillo@upeu.edu.pe")
                .subtotal(new BigDecimal("6549.00"))
                .igv(new BigDecimal("1178.82"))
                .total(new BigDecimal("7727.82"))
                .estado(EstadoOrden.PAGADA)
                .metodoPago("MERCADO_PAGO")
                .direccionEnvio("Av. La Marina 2500, San Miguel, Lima")
                .observaciones("Ensamble Gamer con refrigeracion liquida")
                .fechaCreacion(LocalDateTime.now())
                .fechaActualizacion(LocalDateTime.now())
                .build();

        OrdenCompraDetalle d1 = OrdenCompraDetalle.builder()
                .productoId(1L).sku("AMD-7800X3D").productoNombre("AMD Ryzen 7 7800X3D 8 Cores 5.0GHz AM5")
                .precioUnitario(new BigDecimal("1850.00")).cantidad(1).subtotalLinea(new BigDecimal("1850.00")).build();

        OrdenCompraDetalle d2 = OrdenCompraDetalle.builder()
                .productoId(3L).sku("NV-RTX4080S").productoNombre("ASUS TUF Gaming GeForce RTX 4080 SUPER 16GB OC")
                .precioUnitario(new BigDecimal("4699.00")).cantidad(1).subtotalLinea(new BigDecimal("4699.00")).build();

        o.addDetalle(d1);
        o.addDetalle(d2);

        ordenRepository.save(o);
    }
}