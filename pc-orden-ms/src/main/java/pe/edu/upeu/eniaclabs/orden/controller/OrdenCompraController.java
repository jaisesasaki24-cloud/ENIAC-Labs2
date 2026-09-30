package pe.edu.upeu.eniaclabs.orden.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.edu.upeu.eniaclabs.orden.dto.ActualizarEstadoOrdenDto;
import pe.edu.upeu.eniaclabs.orden.dto.CrearOrdenRequestDto;
import pe.edu.upeu.eniaclabs.orden.dto.OrdenResponseDto;
import pe.edu.upeu.eniaclabs.orden.entity.EstadoOrden;
import pe.edu.upeu.eniaclabs.orden.service.OrdenService;

import java.util.List;

@RestController
@RequestMapping("/api/v1/ordenes")
@RequiredArgsConstructor
@Tag(name = "Ordenes de Compra y Cotizaciones", description = "Endpoints transaccionales para cabecera-detalle con calculo de IGV 18%")
public class OrdenCompraController {

    private final OrdenService ordenService;

    @GetMapping
    @Operation(summary = "Listar ordenes de compra con filtros opcionales")
    public ResponseEntity<List<OrdenResponseDto>> findAll(
            @RequestParam(required = false) Long clienteId,
            @RequestParam(required = false) EstadoOrden estado) {
        return ResponseEntity.ok(ordenService.findAll(clienteId, estado));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener orden de compra por ID con desglose de detalle e IGV")
    public ResponseEntity<OrdenResponseDto> findById(@PathVariable Long id) {
        return ResponseEntity.ok(ordenService.findById(id));
    }

    @GetMapping("/codigo/{codigo}")
    @Operation(summary = "Buscar orden de compra por codigo de seguimiento")
    public ResponseEntity<OrdenResponseDto> findByCodigo(@PathVariable String codigo) {
        return ResponseEntity.ok(ordenService.findByCodigoOrden(codigo));
    }

    @PostMapping
    @Operation(summary = "Crear nueva orden de compra con calculo automatico de subtotal, IGV 18% y total")
    public ResponseEntity<OrdenResponseDto> create(
            @RequestHeader(value = "X-User-Id", required = false) Long headerClienteId,
            @Valid @RequestBody CrearOrdenRequestDto request) {
        // CORREGIDO por Nemotron: eliminado fallback hardcoded a clienteId=1L (vulnerabilidad de seguridad)
        if (headerClienteId == null) {
            return ResponseEntity.status(org.springframework.http.HttpStatus.UNAUTHORIZED).build();
        }
        return ResponseEntity.status(HttpStatus.CREATED).body(ordenService.create(request, headerClienteId));
    }


    @PatchMapping("/{id}/estado")
    @Operation(summary = "Actualizar estado de la orden (PENDIENTE, PAGADA, ENSAMBLANDO, ENVIADA, etc.)")
    public ResponseEntity<OrdenResponseDto> updateStatus(
            @PathVariable Long id,
            @Valid @RequestBody ActualizarEstadoOrdenDto request) {
        return ResponseEntity.ok(ordenService.updateStatus(id, request));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Cancelar orden de compra")
    public ResponseEntity<Void> cancel(@PathVariable Long id) {
        ordenService.cancel(id);
        return ResponseEntity.noContent().build();
    }
}