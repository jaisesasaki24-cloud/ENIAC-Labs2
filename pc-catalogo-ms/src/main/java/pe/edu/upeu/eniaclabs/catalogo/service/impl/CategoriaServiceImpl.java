package pe.edu.upeu.eniaclabs.catalogo.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.upeu.eniaclabs.catalogo.dto.CategoriaRequestDto;
import pe.edu.upeu.eniaclabs.catalogo.dto.CategoriaResponseDto;
import pe.edu.upeu.eniaclabs.catalogo.entity.CategoriaHardware;
import pe.edu.upeu.eniaclabs.catalogo.exception.ResourceNotFoundException;
import pe.edu.upeu.eniaclabs.catalogo.repository.CategoriaHardwareRepository;
import pe.edu.upeu.eniaclabs.catalogo.service.CategoriaService;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CategoriaServiceImpl implements CategoriaService {

    private final CategoriaHardwareRepository categoriaRepository;

    @Override
    @Transactional(readOnly = true)
    public List<CategoriaResponseDto> findAll() {
        return categoriaRepository.findAll().stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public CategoriaResponseDto findById(Long id) {
        CategoriaHardware cat = categoriaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Categoria no encontrada con ID: " + id));
        return mapToDto(cat);
    }

    @Override
    @Transactional
    public CategoriaResponseDto create(CategoriaRequestDto request) {
        if (categoriaRepository.existsByCodigo(request.getCodigo())) {
            throw new IllegalArgumentException("Ya existe una categoria con el codigo: " + request.getCodigo());
        }
        CategoriaHardware cat = CategoriaHardware.builder()
                .codigo(request.getCodigo().toUpperCase())
                .nombre(request.getNombre())
                .descripcion(request.getDescripcion())
                .activo(request.getActivo() != null ? request.getActivo() : true)
                .build();
        return mapToDto(categoriaRepository.save(cat));
    }

    @Override
    @Transactional
    public CategoriaResponseDto update(Long id, CategoriaRequestDto request) {
        CategoriaHardware cat = categoriaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Categoria no encontrada con ID: " + id));
        cat.setNombre(request.getNombre());
        cat.setDescripcion(request.getDescripcion());
        if (request.getActivo() != null) {
            cat.setActivo(request.getActivo());
        }
        return mapToDto(categoriaRepository.save(cat));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        CategoriaHardware cat = categoriaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Categoria no encontrada con ID: " + id));
        cat.setActivo(false);
        categoriaRepository.save(cat);
    }

    private CategoriaResponseDto mapToDto(CategoriaHardware cat) {
        return CategoriaResponseDto.builder()
                .id(cat.getId())
                .codigo(cat.getCodigo())
                .nombre(cat.getNombre())
                .descripcion(cat.getDescripcion())
                .activo(cat.getActivo())
                .totalProductos(cat.getProductos() != null ? cat.getProductos().size() : 0)
                .build();
    }
}