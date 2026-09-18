package pe.edu.upeu.eniaclabs.auth.service;

import pe.edu.upeu.eniaclabs.auth.dto.*;

public interface AuthService {
    AuthResponseDto login(LoginRequestDto request);
    UsuarioResponseDto register(RegistroRequestDto request);
    TokenValidationResponseDto validateToken(String token);
}