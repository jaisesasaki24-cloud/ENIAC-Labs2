package pe.edu.upeu.eniaclabs.auth.config;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import pe.edu.upeu.eniaclabs.auth.entity.Rol;
import pe.edu.upeu.eniaclabs.auth.entity.Usuario;
import pe.edu.upeu.eniaclabs.auth.repository.RolRepository;
import pe.edu.upeu.eniaclabs.auth.repository.UsuarioRepository;

import java.util.Set;

@Component
@RequiredArgsConstructor
public class AuthDataInitializer implements CommandLineRunner {

    private final RolRepository rolRepository;
    private final UsuarioRepository usuarioRepository;

    @Override
    public void run(String... args) {
        if (rolRepository.count() > 0) {
            return;
        }

        Rol rAdmin = rolRepository.save(Rol.builder().nombre("ROLE_ADMIN").descripcion("Administrador del sistema").build());
        Rol rCliente = rolRepository.save(Rol.builder().nombre("ROLE_CLIENTE").descripcion("Cliente de ENIAC Labs").build());
        Rol rTecnico = rolRepository.save(Rol.builder().nombre("ROLE_TECNICO").descripcion("TÃƒÂ©cnico de ensamblaje").build());

        // Password hash de "eniaclabs2026"
        String hash = "f1086ad5d2e101a3612a4894408c3c335a0619e7403e6ec6369c5ebff8604227";

        Usuario admin = Usuario.builder()
                .username("admin").email("admin@eniaclabs.pe")
                .passwordHash(hash).nombres("Administrador").apellidos("ENIAC Labs")
                .telefono("987654321").activo(true).roles(Set.of(rAdmin)).build();

        Usuario laura = Usuario.builder()
                .username("laura.vargas").email("laura.vargas@upeu.edu.pe")
                .passwordHash(hash).nombres("Laura Vargas").apellidos("Cristhian Paul")
                .telefono("998877665").activo(true).roles(Set.of(rAdmin, rCliente)).build();

        Usuario eliceo = Usuario.builder()
                .username("eliceo.parillo").email("eliceo.parillo@upeu.edu.pe")
                .passwordHash(hash).nombres("Eliceo").apellidos("Parillo Mostajo")
                .telefono("911223344").activo(true).roles(Set.of(rAdmin, rCliente)).build();

        usuarioRepository.saveAll(Set.of(admin, laura, eliceo));
    }
}