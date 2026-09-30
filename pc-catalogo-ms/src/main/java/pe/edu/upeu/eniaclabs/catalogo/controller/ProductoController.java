package pe.edu.upeu.eniaclabs.catalogo.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.edu.upeu.eniaclabs.catalogo.dto.*;
import pe.edu.upeu.eniaclabs.catalogo.service.InventarioRedisReservationService;
import pe.edu.upeu.eniaclabs.catalogo.service.ProductoService;

import java.util.List;

@RestController
@RequestMapping("/api/v1/productos")
@RequiredArgsConstructor
@Tag(name = "Productos de Hardware Gamer", description = "Endpoints para componentes, piezas de ensamble y stock en tiempo real")
public class ProductoController {

    private final ProductoService productoService;
    private final InventarioRedisReservationService inventarioRedisService;

    @GetMapping
    @Operation(summary = "Listar productos de hardware con filtros opcionales")
    public ResponseEntity<List<ProductoResponseDto>> findAll(
            @RequestParam(required = false) Long categoriaId,
            @RequestParam(required = false, defaultValue = "true") Boolean activo) {
        return ResponseEntity.ok(productoService.findAll(categoriaId, activo));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener producto por ID")
    public ResponseEntity<ProductoResponseDto> findById(@PathVariable Long id) {
        return ResponseEntity.ok(productoService.findById(id));
    }

    @GetMapping("/sku/{sku}")
    @Operation(summary = "Buscar producto gamer por codigo SKU")
    public ResponseEntity<ProductoResponseDto> findBySku(@PathVariable String sku) {
        return ResponseEntity.ok(productoService.findBySku(sku));
    }

    @PostMapping
    @Operation(summary = "Registrar nuevo componente o perifÃ©rico")
    public ResponseEntity<ProductoResponseDto> create(@Valid @RequestBody ProductoRequestDto request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(productoService.create(request));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar componente existente")
    public ResponseEntity<ProductoResponseDto> update(@PathVariable Long id, @Valid @RequestBody ProductoRequestDto request) {
        return ResponseEntity.ok(productoService.update(id, request));
    }

    @PostMapping("/{id}/stock/verificar")
    @Operation(summary = "Verificar disponibilidad de stock en tiempo real")
    public ResponseEntity<StockResponseDto> verificarStock(
            @PathVariable Long id,
            @Valid @RequestBody StockOperationDto request) {
        return ResponseEntity.ok(productoService.verificarStock(id, request.getCantidad()));
    }

    @PostMapping("/{id}/stock/descontar")
    @Operation(summary = "Descontar stock para venta u orden de compra")
    public ResponseEntity<StockResponseDto> descontarStock(
            @PathVariable Long id,
            @Valid @RequestBody StockOperationDto request) {
        return ResponseEntity.ok(productoService.descontarStock(id, request.getCantidad()));
    }

    @PostMapping("/{id}/stock/reponer")
    @Operation(summary = "Reponer stock tras compensacion Saga o cancelacion")
    public ResponseEntity<StockResponseDto> reponerStock(
            @PathVariable Long id,
            @Valid @RequestBody StockOperationDto request) {
        return ResponseEntity.ok(productoService.reponerStock(id, request.getCantidad()));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Desactivar componente del catalogo")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        productoService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/stock/reservar-redis")
    @Operation(summary = "Reserva atómica de stock en memoria L4/L7 (Redis Lua Script) recomendada por Nemotron 3 Ultra")
    public ResponseEntity<Boolean> reservarStockRedis(
            @RequestParam String sku,
            @RequestParam int cantidad,
            @RequestParam String orderId) {
        return ResponseEntity.ok(inventarioRedisService.tryReserveStock(sku, cantidad, orderId));
    }

    @PostMapping("/stock/revertir-redis")
    @Operation(summary = "Reversión atómica de reserva en Redis recomendada por Nemotron 3 Ultra")
    public ResponseEntity<Void> revertirReservaRedis(
            @RequestParam String sku,
            @RequestParam int cantidad,
            @RequestParam String orderId) {
        inventarioRedisService.rollbackReservation(sku, cantidad, orderId);
        return ResponseEntity.ok().build();
    }
}