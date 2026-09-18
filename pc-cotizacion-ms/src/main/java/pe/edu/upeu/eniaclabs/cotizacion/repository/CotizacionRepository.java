package pe.edu.upeu.eniaclabs.cotizacion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import pe.edu.upeu.eniaclabs.cotizacion.entity.CotizacionPc;
import java.util.Optional;
import java.util.List;

@Repository
public interface CotizacionRepository extends JpaRepository<CotizacionPc, Long> {
    Optional<CotizacionPc> findByCodigoProforma(String codigoProforma);
    List<CotizacionPc> findByClienteEmailOrderByFechaCreacionDesc(String clienteEmail);
}