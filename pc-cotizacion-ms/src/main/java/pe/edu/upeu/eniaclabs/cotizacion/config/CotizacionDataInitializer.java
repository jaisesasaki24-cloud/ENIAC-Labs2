package pe.edu.upeu.eniaclabs.cotizacion.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import pe.edu.upeu.eniaclabs.cotizacion.entity.CotizacionItem;
import pe.edu.upeu.eniaclabs.cotizacion.entity.CotizacionPc;
import pe.edu.upeu.eniaclabs.cotizacion.repository.CotizacionRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Slf4j
@Component
@RequiredArgsConstructor
public class CotizacionDataInitializer implements CommandLineRunner {

    private final CotizacionRepository cotizacionRepository;

    @Override
    public void run(String... args) {
        if (cotizacionRepository.count() > 0) {
            return;
        }

        // Cotizacion 1: Setup Esports Competitivo
        CotizacionPc cot1 = CotizacionPc.builder()
                .codigoProforma("COT-2026-0001")
                .clienteNombre("Carlos Mendoza")
                .clienteEmail("carlos.mendoza@gmail.com")
                .clienteTelefono("987654321")
                .usoDestino("Esports Competitivo (Valorant, CS2, Dota 2)")
                .subtotal(new BigDecimal("2350.00"))
                .igv(new BigDecimal("423.00"))
                .total(new BigDecimal("2773.00"))
                .estado("VIGENTE")
                .fechaCreacion(LocalDateTime.now())
                .fechaExpiracion(LocalDateTime.now().plusDays(7))
                .build();

        cot1.addItem(CotizacionItem.builder()
                .productoId(1L).categoria("CPU").sku("CPU-AMD-7800X3D")
                .descripcion("AMD Ryzen 7 7800X3D 8 Cores AM5").precioUnitario(new BigDecimal("1850.00")).cantidad(1)
                .subtotal(new BigDecimal("1850.00")).build());

        cot1.addItem(CotizacionItem.builder()
                .productoId(3L).categoria("RAM").sku("RAM-KNG-DDR5-32")
                .descripcion("Kingston Fury Beast 32GB (2x16GB) DDR5 6000MHz").precioUnitario(new BigDecimal("500.00")).cantidad(1)
                .subtotal(new BigDecimal("500.00")).build());

        // Cotizacion 2: Setup Streaming & Creator 4K
        CotizacionPc cot2 = CotizacionPc.builder()
                .codigoProforma("COT-2026-0002")
                .clienteNombre("Mariana Torres")
                .clienteEmail("mariana.torres@gmail.com")
                .clienteTelefono("998877665")
                .usoDestino("Streaming y Edicion de Video 4K")
                .subtotal(new BigDecimal("5800.00"))
                .igv(new BigDecimal("1044.00"))
                .total(new BigDecimal("6844.00"))
                .estado("VIGENTE")
                .fechaCreacion(LocalDateTime.now())
                .fechaExpiracion(LocalDateTime.now().plusDays(7))
                .build();

        cot2.addItem(CotizacionItem.builder()
                .productoId(1L).categoria("CPU").sku("CPU-AMD-7800X3D")
                .descripcion("AMD Ryzen 7 7800X3D 8 Cores AM5").precioUnitario(new BigDecimal("1850.00")).cantidad(1)
                .subtotal(new BigDecimal("1850.00")).build());

        cot2.addItem(CotizacionItem.builder()
                .productoId(2L).categoria("GPU").sku("GPU-ASUS-RTX4070TIS")
                .descripcion("ASUS TUF Gaming GeForce RTX 4070 Ti Super 16GB").precioUnitario(new BigDecimal("3450.00")).cantidad(1)
                .subtotal(new BigDecimal("3450.00")).build());

        cot2.addItem(CotizacionItem.builder()
                .productoId(3L).categoria("RAM").sku("RAM-KNG-DDR5-32")
                .descripcion("Kingston Fury Beast 32GB (2x16GB) DDR5 6000MHz").precioUnitario(new BigDecimal("500.00")).cantidad(1)
                .subtotal(new BigDecimal("500.00")).build());

        cotizacionRepository.save(cot1);
        cotizacionRepository.save(cot2);

        log.info("CotizacionDataInitializer: 2 proformas precargadas para demostracion comercial.");
    }
}