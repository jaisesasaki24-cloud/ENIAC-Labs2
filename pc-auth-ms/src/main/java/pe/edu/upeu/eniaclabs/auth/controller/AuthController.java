package pe.edu.upeu.eniaclabs.auth.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.edu.upeu.eniaclabs.auth.dto.*;
import pe.edu.upeu.eniaclabs.auth.service.AuthService;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@Tag(name = "Autenticacion y Seguridad Perimetral", description = "Endpoints de registro, login y validacion JWT para el Gateway")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    @Operation(summary = "Iniciar sesion y generar token JWT firmado")
    public ResponseEntity<AuthResponseDto> login(@Valid @RequestBody LoginRequestDto request) {
        return ResponseEntity.ok(authService.login(request));
    }

    @PostMapping("/register")
    @Operation(summary = "Registrar nuevo usuario o cliente en ENIAC Labs")
    public ResponseEntity<UsuarioResponseDto> register(@Valid @RequestBody RegistroRequestDto request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(authService.register(request));
    }

    @PostMapping("/validate")
    @Operation(summary = "Validar token JWT para la seguridad perimetral del Gateway")
    public ResponseEntity<TokenValidationResponseDto> validate(@Valid @RequestBody TokenValidationRequestDto request) {
        return ResponseEntity.ok(authService.validateToken(request.getToken()));
    }
}