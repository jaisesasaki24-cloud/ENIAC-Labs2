package pe.edu.upeu.eniaclabs.auth.service;

import pe.edu.upeu.eniaclabs.auth.dto.UsuarioResponseDto;
import java.util.List;

public interface UsuarioService {
    List<UsuarioResponseDto> findAll();
    UsuarioResponseDto findById(Long id);
    UsuarioResponseDto findByUsername(String username);
}