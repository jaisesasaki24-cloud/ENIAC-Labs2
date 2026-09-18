package pe.edu.upeu.eniaclabs.catalogo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.eniaclabs.catalogo.entity.CategoriaHardware;
import java.util.List;
import java.util.Optional;

public interface CategoriaHardwareRepository extends JpaRepository<CategoriaHardware, Long> {
    Optional<CategoriaHardware> findByCodigo(String codigo);
    List<CategoriaHardware> findByActivoTrue();
    boolean existsByCodigo(String codigo);
}