package pe.edu.upeu.eniaclabs.auth.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.upeu.eniaclabs.auth.dto.UsuarioResponseDto;
import pe.edu.upeu.eniaclabs.auth.entity.Rol;
import pe.edu.upeu.eniaclabs.auth.entity.Usuario;
import pe.edu.upeu.eniaclabs.auth.exception.ResourceNotFoundException;
import pe.edu.upeu.eniaclabs.auth.repository.UsuarioRepository;
import pe.edu.upeu.eniaclabs.auth.service.UsuarioService;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UsuarioServiceImpl implements UsuarioService {

    private final UsuarioRepository usuarioRepository;

    @Override
    @Transactional(readOnly = true)
    public List<UsuarioResponseDto> findAll() {
        return usuarioRepository.findAll().stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public UsuarioResponseDto findById(Long id) {
        Usuario u = usuarioRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado con ID: " + id));
        return mapToDto(u);
    }

    @Override
    @Transactional(readOnly = true)
    public UsuarioResponseDto findByUsername(String username) {
        Usuario u = usuarioRepository.findByUsername(username)
                .orElseThrow(() -> new ResourceNotFoundException("Usuario no encontrado con username: " + username));
        return mapToDto(u);
    }

    private UsuarioResponseDto mapToDto(Usuario u) {
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