package pe.edu.upeu.eniaclabs.pago.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.eniaclabs.pago.entity.Pago;
import java.util.Optional;

public interface PagoRepository extends JpaRepository<Pago, Long> {
    Optional<Pago> findByOrdenId(Long ordenId);
}
