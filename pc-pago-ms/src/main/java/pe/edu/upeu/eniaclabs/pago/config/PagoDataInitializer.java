package pe.edu.upeu.eniaclabs.pago.config;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import pe.edu.upeu.eniaclabs.pago.entity.EstadoPago;
import pe.edu.upeu.eniaclabs.pago.entity.TransaccionPago;
import pe.edu.upeu.eniaclabs.pago.repository.TransaccionPagoRepository;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Component
@RequiredArgsConstructor
public class PagoDataInitializer implements CommandLineRunner {

    private final TransaccionPagoRepository transaccionRepository;

    @Override
    public void run(String... args) {
        if (transaccionRepository.count() > 0) {
            return;
        }

        TransaccionPago tx = TransaccionPago.builder()
                .ordenId(1L)
                .codigoOrden("ENIAC-20260901-0001")
                .monto(new BigDecimal("7727.82"))
                .moneda("PEN")
                .metodoPago("MERCADO_PAGO_SANDBOX")
                .estado(EstadoPago.APROBADO)
                .mpPaymentId("MP-PAY-987654321")
                .mpPreferenceId("PREF-7800X3D-RTX4080")
                .sandboxInitPoint("https://sandbox.mercadopago.com.pe/checkout/v1/redirect?pref_id=PREF-7800X3D-RTX4080")
                .externalReference("EXT-ENIAC-20260901-0001-1726000000")
                .payerEmail("eliceo.parillo@upeu.edu.pe")
                .fechaCreacion(LocalDateTime.now())
                .fechaActualizacion(LocalDateTime.now())
                .build();

        transaccionRepository.save(tx);
    }
}