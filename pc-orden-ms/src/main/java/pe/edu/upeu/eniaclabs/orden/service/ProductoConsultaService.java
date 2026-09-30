package pe.edu.upeu.eniaclabs.orden.service;

import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import pe.edu.upeu.eniaclabs.orden.client.CatalogoFeignClient;
import pe.edu.upeu.eniaclabs.orden.dto.ProductoResponseDto;

import java.math.BigDecimal;

@Slf4j
@Service
@RequiredArgsConstructor
public class ProductoConsultaService {

    private final CatalogoFeignClient catalogoFeignClient;

    @CircuitBreaker(name = "catalogoPrecio", fallbackMethod = "fallbackConsultarPrecio")
    public BigDecimal consultarPrecio(Long productoId) {
        log.info("Llamando a pc-catalogo-ms mediante OpenFeign para producto ID: {}", productoId);
        ProductoResponseDto prod = catalogoFeignClient.consultarPorId(productoId);
        if (prod != null && prod.getPrecio() != null) {
            return prod.getPrecio();
        }
        return null;
    }

    public BigDecimal fallbackConsultarPrecio(Long productoId, Throwable ex) {
        log.warn("Circuit Breaker 'catalogoPrecio' activado (Fallback). Falla al consultar precio para producto {}: {}",
                productoId, ex.getMessage());
        return null;
    }
}
