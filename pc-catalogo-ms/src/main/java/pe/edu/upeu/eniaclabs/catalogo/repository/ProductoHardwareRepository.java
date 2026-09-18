package pe.edu.upeu.eniaclabs.catalogo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.eniaclabs.catalogo.entity.ProductoHardware;
import java.util.List;
import java.util.Optional;

public interface ProductoHardwareRepository extends JpaRepository<ProductoHardware, Long> {
    Optional<ProductoHardware> findBySku(String sku);
    List<ProductoHardware> findByCategoriaId(Long categoriaId);
    List<ProductoHardware> findByActivoTrue();
    List<ProductoHardware> findByCategoriaIdAndActivoTrue(Long categoriaId);
    boolean existsBySku(String sku);
}