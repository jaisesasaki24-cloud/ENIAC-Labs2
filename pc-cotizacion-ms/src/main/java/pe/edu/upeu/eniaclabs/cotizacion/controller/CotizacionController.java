package pe.edu.upeu.eniaclabs.cotizacion.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.edu.upeu.eniaclabs.cotizacion.dto.*;
import pe.edu.upeu.eniaclabs.cotizacion.service.CotizacionService;

import java.util.List;

@RestController
@RequestMapping("/api/v1/cotizaciones")
@RequiredArgsConstructor
@Tag(name = "Cotizador PC Builder y Proformas Comerciales", description = "Endpoints para cotizaciones de computadoras gamer, validacion de compatibilidad y conversion en ordenes de compra")
public class CotizacionController {

    private final CotizacionService cotizacionService;

    @PostMapping
    @Operation(summary = "Crear nueva proforma de PC Gamer con calculo de IGV (18%) y vigencia de 7 dias")
    public ResponseEntity<CotizacionResponseDto> crearCotizacion(@Valid @RequestBody CrearCotizacionRequestDto request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(cotizacionService.crearCotizacion(request));
    }

    @GetMapping
    @Operation(summary = "Listar todas las proformas y presupuestos de ensamble de computadoras")
    public ResponseEntity<List<CotizacionResponseDto>> listarTodas() {
        return ResponseEntity.ok(cotizacionService.listarTodas());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener detalle completo de una proforma o presupuesto por ID")
    public ResponseEntity<CotizacionResponseDto> buscarPorId(@PathVariable Long id) {
        return ResponseEntity.ok(cotizacionService.buscarPorId(id));
    }

    @PostMapping("/validar-compatibilidad")
    @Operation(summary = "Verificar compatibilidad tecnica de sockets, chipset y fuente de poder antes de comprar")
    public ResponseEntity<ValidarCompatibilidadDto> validarCompatibilidad(@RequestBody ValidarCompatibilidadDto request) {
        return ResponseEntity.ok(cotizacionService.validarCompatibilidad(request));
    }

    @PostMapping("/{id}/comprar")
    @Operation(summary = "Convertir proforma/cotizacion en una Orden de Compra Transaccional en pc-orden-ms")
    public ResponseEntity<ConvertirOrdenResponseDto> convertirAOrden(@PathVariable Long id) {
        return ResponseEntity.ok(cotizacionService.convertirAOrden(id));
    }
}