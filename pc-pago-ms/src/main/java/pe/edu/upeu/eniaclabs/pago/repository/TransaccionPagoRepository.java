package pe.edu.upeu.eniaclabs.pago.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.eniaclabs.pago.entity.EstadoPago;
import pe.edu.upeu.eniaclabs.pago.entity.TransaccionPago;
import java.util.List;
import java.util.Optional;

public interface TransaccionPagoRepository extends JpaRepository<TransaccionPago, Long> {
    List<TransaccionPago> findByOrdenId(Long ordenId);
    Optional<TransaccionPago> findByExternalReference(String externalReference);
    Optional<TransaccionPago> findByMpPreferenceId(String mpPreferenceId);
    Optional<TransaccionPago> findByMpPaymentId(String mpPaymentId);
    List<TransaccionPago> findByEstado(EstadoPago estado);
}