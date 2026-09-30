package pe.edu.upeu.eniaclabs.orden.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import pe.edu.upeu.eniaclabs.orden.dto.ProductoResponseDto;

@FeignClient(name = "pc-catalogo-ms")
public interface CatalogoFeignClient {

    @GetMapping("/api/v1/productos/{id}")
    ProductoResponseDto consultarPorId(@PathVariable("id") Long id);
}
