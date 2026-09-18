package pe.edu.upeu.eniaclabs.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.edu.upeu.eniaclabs.auth.entity.Rol;
import java.util.Optional;

public interface RolRepository extends JpaRepository<Rol, Long> {
    Optional<Rol> findByNombre(String nombre);
}