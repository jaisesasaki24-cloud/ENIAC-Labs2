package pe.edu.upeu.eniaclabs.catalogo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.edu.upeu.eniaclabs.catalogo.entity.ProductoHardware;
import java.util.List;
import java.util.Optional;

public interface ProductoHardwareRepository extends JpaRepository<ProductoHardware, Long> {
    Optional<ProductoHardware> findBySku(String sku);
    List<ProductoHardware> findByCategoriaId(Long categoriaId);
    List<ProductoHardware> findByActivoTrue();
    List<ProductoHardware> findByCategoriaIdAndActivoTrue(Long categoriaId);
    boolean existsBySku(String sku);

    @Modifying
    @Query("UPDATE ProductoHardware p SET p.stockActual = p.stockActual - :cantidad " +
           "WHERE p.id = :id AND p.stockActual >= :cantidad AND p.activo = true")
    int descontarStockAtomico(@Param("id") Long id, @Param("cantidad") Integer cantidad);

    @Modifying
    @Query("UPDATE ProductoHardware p SET p.stockActual = p.stockActual + :cantidad " +
           "WHERE p.id = :id AND p.activo = true")
    int reponerStockAtomico(@Param("id") Long id, @Param("cantidad") Integer cantidad);

    @Modifying
    @Query("UPDATE ProductoHardware p SET p.stockActual = p.stockActual - :cantidad " +
           "WHERE p.sku = :sku AND p.stockActual >= :cantidad AND p.activo = true")
    int descontarStockPorSkuAtomico(@Param("sku") String sku, @Param("cantidad") Integer cantidad);

    @Modifying
    @Query("UPDATE ProductoHardware p SET p.stockActual = p.stockActual + :cantidad " +
           "WHERE p.sku = :sku AND p.activo = true")
    int reponerStockPorSkuAtomico(@Param("sku") String sku, @Param("cantidad") Integer cantidad);
}