package pe.edu.upeu.eniaclabs.orden.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.eniaclabs.orden.entity.EstadoOrden;
import pe.edu.upeu.eniaclabs.orden.entity.OrdenCompra;
import java.util.List;
import java.util.Optional;

public interface OrdenCompraRepository extends JpaRepository<OrdenCompra, Long> {
    Optional<OrdenCompra> findByCodigoOrden(String codigoOrden);
    List<OrdenCompra> findByClienteId(Long clienteId);
    List<OrdenCompra> findByEstado(EstadoOrden estado);
    boolean existsByCodigoOrden(String codigoOrden);
}