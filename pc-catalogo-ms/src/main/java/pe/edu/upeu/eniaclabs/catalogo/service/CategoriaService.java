package pe.edu.upeu.eniaclabs.catalogo.service;

import pe.edu.upeu.eniaclabs.catalogo.dto.CategoriaRequestDto;
import pe.edu.upeu.eniaclabs.catalogo.dto.CategoriaResponseDto;
import java.util.List;

public interface CategoriaService {
    List<CategoriaResponseDto> findAll();
    CategoriaResponseDto findById(Long id);
    CategoriaResponseDto create(CategoriaRequestDto request);
    CategoriaResponseDto update(Long id, CategoriaRequestDto request);
    void delete(Long id);
}