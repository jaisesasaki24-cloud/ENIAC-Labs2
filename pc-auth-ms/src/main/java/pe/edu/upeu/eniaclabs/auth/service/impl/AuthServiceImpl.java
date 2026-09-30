package pe.edu.upeu.eniaclabs.auth.service.impl;

import io.jsonwebtoken.Claims;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.upeu.eniaclabs.auth.dto.*;
import pe.edu.upeu.eniaclabs.auth.entity.Rol;
import pe.edu.upeu.eniaclabs.auth.entity.Usuario;
import pe.edu.upeu.eniaclabs.auth.exception.AuthenticationException;
import pe.edu.upeu.eniaclabs.auth.repository.RolRepository;
import pe.edu.upeu.eniaclabs.auth.repository.UsuarioRepository;
import pe.edu.upeu.eniaclabs.auth.security.JwtUtil;
import pe.edu.upeu.eniaclabs.auth.service.AuthService;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UsuarioRepository usuarioRepository;
    private final RolRepository rolRepository;
    private final JwtUtil jwtUtil;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional(readOnly = true)
    public AuthResponseDto login(LoginRequestDto req) {
        Usuario usuario = usuarioRepository.findByUsernameOrEmail(req.getUsernameOrEmail(), req.getUsernameOrEmail())
                .orElseThrow(() -> new AuthenticationException("Credenciales invalidas: usuario o email no registrado"));

        if (!Boolean.TRUE.equals(usuario.getActivo())) {
            throw new AuthenticationException("La cuenta de usuario esta inactiva o suspendida");
        }

        if (!passwordEncoder.matches(req.getPassword(), usuario.getPasswordHash())) {
            throw new AuthenticationException("Credenciales invalidas: contrasena incorrecta");
        }

        List<String> roles = usuario.getRoles().stream()
                .map(Rol::getNombre)
                .collect(Collectors.toList());

        String token = jwtUtil.generateToken(usuario.getUsername(), usuario.getId(), roles);

        return AuthResponseDto.builder()
                .token(token)
                .tokenType("Bearer")
                .id(usuario.getId())
                .username(usuario.getUsername())
                .email(usuario.getEmail())
                .nombresCompletos(usuario.getNombres() + " " + usuario.getApellidos())
                .roles(roles)
                .build();
    }

    @Override
    @Transactional
    public UsuarioResponseDto register(RegistroRequestDto req) {
        if (usuarioRepository.existsByUsername(req.getUsername())) {
            throw new IllegalArgumentException("El nombre de usuario ya se encuentra registrado: " + req.getUsername());
        }
        if (usuarioRepository.existsByEmail(req.getEmail())) {
            throw new IllegalArgumentException("El correo electronico ya esta en uso: " + req.getEmail());
        }

        Rol rolCliente = rolRepository.findByNombre("ROLE_CLIENTE")
                .orElseGet(() -> rolRepository.save(Rol.builder().nombre("ROLE_CLIENTE").descripcion("Cliente de ENIAC Labs").build()));

        Set<Rol> roles = new HashSet<>();
        roles.add(rolCliente);

        Usuario nuevo = Usuario.builder()
                .username(req.getUsername())
                .email(req.getEmail())
                .passwordHash(passwordEncoder.encode(req.getPassword()))
                .nombres(req.getNombres())
                .apellidos(req.getApellidos())
                .telefono(req.getTelefono())
                .activo(true)
                .roles(roles)
                .build();

        Usuario guardado = usuarioRepository.save(nuevo);

        return mapToUserDto(guardado);
    }

    @Override
    public TokenValidationResponseDto validateToken(String token) {
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
        }

        if (token == null || !jwtUtil.validateToken(token)) {
            return TokenValidationResponseDto.builder()
                    .valid(false)
                    .message("Token JWT invalido o expirado")
                    .build();
        }

        Claims claims = jwtUtil.extractClaims(token);
        String username = claims.getSubject();
        Long userId = claims.get("userId", Long.class);
        @SuppressWarnings("unchecked")
        List<String> roles = claims.get("roles", List.class);

        return TokenValidationResponseDto.builder()
                .valid(true)
                .username(username)
                .userId(userId)
                .roles(roles)
                .message("Token verificado correctamente para seguridad perimetral")
                .build();
    }

    private UsuarioResponseDto mapToUserDto(Usuario u) {
        return UsuarioResponseDto.builder()
                .id(u.getId())
                .username(u.getUsername())
                .email(u.getEmail())
                .nombres(u.getNombres())
                .apellidos(u.getApellidos())
                .telefono(u.getTelefono())
                .activo(u.getActivo())
                .roles(u.getRoles().stream().map(Rol::getNombre).collect(Collectors.toList()))
                .fechaCreacion(u.getFechaCreacion())
                .build();
    }
}