package pe.edu.upeu.eniaclabs.catalogo.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.upeu.eniaclabs.catalogo.dto.*;
import pe.edu.upeu.eniaclabs.catalogo.entity.CategoriaHardware;
import pe.edu.upeu.eniaclabs.catalogo.entity.ProductoHardware;
import pe.edu.upeu.eniaclabs.catalogo.exception.InsufficientStockException;
import pe.edu.upeu.eniaclabs.catalogo.exception.ResourceNotFoundException;
import pe.edu.upeu.eniaclabs.catalogo.repository.CategoriaHardwareRepository;
import pe.edu.upeu.eniaclabs.catalogo.repository.ProductoHardwareRepository;
import pe.edu.upeu.eniaclabs.catalogo.service.ProductoService;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ProductoServiceImpl implements ProductoService {

    private final ProductoHardwareRepository productoRepository;
    private final CategoriaHardwareRepository categoriaRepository;

    @Override
    @Transactional(readOnly = true)
    public List<ProductoResponseDto> findAll(Long categoriaId, Boolean activo) {
        List<ProductoHardware> list;
        if (categoriaId != null && Boolean.TRUE.equals(activo)) {
            list = productoRepository.findByCategoriaIdAndActivoTrue(categoriaId);
        } else if (categoriaId != null) {
            list = productoRepository.findByCategoriaId(categoriaId);
        } else if (Boolean.TRUE.equals(activo)) {
            list = productoRepository.findByActivoTrue();
        } else {
            list = productoRepository.findAll();
        }
        return list.stream().map(this::mapToDto).collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public ProductoResponseDto findById(Long id) {
        ProductoHardware p = productoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Producto no encontrado con ID: " + id));
        return mapToDto(p);
    }

    @Override
    @Transactional(readOnly = true)
    public ProductoResponseDto findBySku(String sku) {
        ProductoHardware p = productoRepository.findBySku(sku)
                .orElseThrow(() -> new ResourceNotFoundException("Producto no encontrado con SKU: " + sku));
        return mapToDto(p);
    }

    @Override
    @Transactional
    public ProductoResponseDto create(ProductoRequestDto req) {
        if (productoRepository.existsBySku(req.getSku())) {
            throw new IllegalArgumentException("Ya existe un producto con SKU: " + req.getSku());
        }
        CategoriaHardware cat = categoriaRepository.findById(req.getCategoriaId())
                .orElseThrow(() -> new ResourceNotFoundException("Categoria no encontrada con ID: " + req.getCategoriaId()));

        ProductoHardware p = ProductoHardware.builder()
                .sku(req.getSku().toUpperCase())
                .nombre(req.getNombre())
                .marca(req.getMarca())
                .modelo(req.getModelo())
                .precio(req.getPrecio())
                .stockActual(req.getStockActual())
                .stockMinimo(req.getStockMinimo() != null ? req.getStockMinimo() : 3)
                .garantiaMeses(req.getGarantiaMeses() != null ? req.getGarantiaMeses() : 24)
                .especificaciones(req.getEspecificaciones())
                .activo(req.getActivo() != null ? req.getActivo() : true)
                .categoria(cat)
                .build();
        return mapToDto(productoRepository.save(p));
    }

    @Override
    @Transactional
    public ProductoResponseDto update(Long id, ProductoRequestDto req) {
        ProductoHardware p = productoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Producto no encontrado con ID: " + id));

        CategoriaHardware cat = categoriaRepository.findById(req.getCategoriaId())
                .orElseThrow(() -> new ResourceNotFoundException("Categoria no encontrada con ID: " + req.getCategoriaId()));

        p.setNombre(req.getNombre());
        p.setMarca(req.getMarca());
        p.setModelo(req.getModelo());
        p.setPrecio(req.getPrecio());
        p.setStockActual(req.getStockActual());
        if (req.getStockMinimo() != null) p.setStockMinimo(req.getStockMinimo());
        if (req.getGarantiaMeses() != null) p.setGarantiaMeses(req.getGarantiaMeses());
        p.setEspecificaciones(req.getEspecificaciones());
        if (req.getActivo() != null) p.setActivo(req.getActivo());
        p.setCategoria(cat);

        return mapToDto(productoRepository.save(p));
    }

    @Override
    @Transactional(readOnly = true)
    public StockResponseDto verificarStock(Long id, Integer cantidad) {
        ProductoHardware p = productoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Producto no encontrado con ID: " + id));
        boolean disponible = p.getStockActual() >= cantidad;
        return StockResponseDto.builder()
                .productoId(p.getId())
                .sku(p.getSku())
                .stockAnterior(p.getStockActual())
                .stockActual(p.getStockActual())
                .disponible(disponible)
                .mensaje(disponible ? "Stock suficiente para atender la orden" : "Stock insuficiente. Solicitado: " + cantidad + ", Disponible: " + p.getStockActual())
                .build();
    }

    @Override
    @Transactional
    public StockResponseDto descontarStock(Long id, Integer cantidad) {
        int updated = productoRepository.descontarStockAtomico(id, cantidad);
        if (updated == 0) {
            ProductoHardware p = productoRepository.findById(id)
                    .orElseThrow(() -> new ResourceNotFoundException("Producto no encontrado con ID: " + id));
            throw new InsufficientStockException("Stock insuficiente para SKU: " + p.getSku() + ". Requerido: " + cantidad + ", Actual: " + p.getStockActual());
        }
        ProductoHardware p = productoRepository.findById(id).orElseThrow();
        return StockResponseDto.builder()
                .productoId(p.getId())
                .sku(p.getSku())
                .stockAnterior(p.getStockActual() + cantidad)
                .stockActual(p.getStockActual())
                .disponible(true)
                .mensaje("Stock descontado exitosamente de forma atómica")
                .build();
    }

    @Override
    @Transactional
    public StockResponseDto reponerStock(Long id, Integer cantidad) {
        int updated = productoRepository.reponerStockAtomico(id, cantidad);
        if (updated == 0) {
            throw new ResourceNotFoundException("Producto no encontrado con ID: " + id);
        }
        ProductoHardware p = productoRepository.findById(id).orElseThrow();
        return StockResponseDto.builder()
                .productoId(p.getId())
                .sku(p.getSku())
                .stockAnterior(p.getStockActual() - cantidad)
                .stockActual(p.getStockActual())
                .disponible(true)
                .mensaje("Stock repuesto exitosamente tras compensación Saga")
                .build();
    }

    @Override
    @Transactional
    public void delete(Long id) {
        ProductoHardware p = productoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Producto no encontrado con ID: " + id));
        p.setActivo(false);
        productoRepository.save(p);
    }

    private ProductoResponseDto mapToDto(ProductoHardware p) {
        return ProductoResponseDto.builder()
                .id(p.getId())
                .sku(p.getSku())
                .nombre(p.getNombre())
                .marca(p.getMarca())
                .modelo(p.getModelo())
                .precio(p.getPrecio())
                .stockActual(p.getStockActual())
                .stockMinimo(p.getStockMinimo())
                .garantiaMeses(p.getGarantiaMeses())
                .especificaciones(p.getEspecificaciones())
                .activo(p.getActivo())
                .categoriaId(p.getCategoria() != null ? p.getCategoria().getId() : null)
                .categoriaNombre(p.getCategoria() != null ? p.getCategoria().getNombre() : null)
                .build();
    }
}