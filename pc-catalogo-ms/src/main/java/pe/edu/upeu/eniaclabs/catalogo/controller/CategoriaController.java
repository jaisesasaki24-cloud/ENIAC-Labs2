package pe.edu.upeu.eniaclabs.catalogo.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.edu.upeu.eniaclabs.catalogo.dto.CategoriaRequestDto;
import pe.edu.upeu.eniaclabs.catalogo.dto.CategoriaResponseDto;
import pe.edu.upeu.eniaclabs.catalogo.service.CategoriaService;

import java.util.List;

@RestController
@RequestMapping("/api/v1/categorias")
@RequiredArgsConstructor
@Tag(name = "Categorias de Hardware", description = "Endpoints para gestion del catalogo gamer por categorias")
public class CategoriaController {

    private final CategoriaService categoriaService;

    @GetMapping
    @Operation(summary = "Listar todas las categorias de hardware")
    public ResponseEntity<List<CategoriaResponseDto>> findAll() {
        return ResponseEntity.ok(categoriaService.findAll());
    }

    @GetMapping("/{id}")
    @Operation(summary = "Obtener categoria por ID")
    public ResponseEntity<CategoriaResponseDto> findById(@PathVariable Long id) {
        return ResponseEntity.ok(categoriaService.findById(id));
    }

    @PostMapping
    @Operation(summary = "Crear nueva categoria de hardware")
    public ResponseEntity<CategoriaResponseDto> create(@Valid @RequestBody CategoriaRequestDto request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(categoriaService.create(request));
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar categoria existente")
    public ResponseEntity<CategoriaResponseDto> update(@PathVariable Long id, @Valid @RequestBody CategoriaRequestDto request) {
        return ResponseEntity.ok(categoriaService.update(id, request));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Desactivar categoria de hardware")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        categoriaService.delete(id);
        return ResponseEntity.noContent().build();
    }
}