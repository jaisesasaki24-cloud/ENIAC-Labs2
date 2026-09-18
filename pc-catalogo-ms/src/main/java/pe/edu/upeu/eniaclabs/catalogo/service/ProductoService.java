package pe.edu.upeu.eniaclabs.catalogo.service;

import pe.edu.upeu.eniaclabs.catalogo.dto.*;
import java.util.List;

public interface ProductoService {
    List<ProductoResponseDto> findAll(Long categoriaId, Boolean activo);
    ProductoResponseDto findById(Long id);
    ProductoResponseDto findBySku(String sku);
    ProductoResponseDto create(ProductoRequestDto request);
    ProductoResponseDto update(Long id, ProductoRequestDto request);
    StockResponseDto verificarStock(Long id, Integer cantidad);
    StockResponseDto descontarStock(Long id, Integer cantidad);
    void delete(Long id);
}