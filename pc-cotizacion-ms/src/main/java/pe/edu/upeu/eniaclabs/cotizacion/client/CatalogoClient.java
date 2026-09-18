package pe.edu.upeu.eniaclabs.cotizacion.client;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
public class CatalogoClient {

    private final DiscoveryClient discoveryClient;
    private final RestClient restClient;

    public CatalogoClient(DiscoveryClient discoveryClient) {
        this.discoveryClient = discoveryClient;
        this.restClient = RestClient.builder().build();
    }

    public BigDecimal consultarPrecioActualizado(Long productoId) {
        try {
            List<ServiceInstance> instances = discoveryClient.getInstances("PC-CATALOGO-MS");
            if (instances == null || instances.isEmpty()) {
                instances = discoveryClient.getInstances("pc-catalogo-ms");
            }

            if (instances != null && !instances.isEmpty()) {
                String baseUrl = instances.get(0).getUri().toString();
                log.info("Cotizador validando precio con Catalogo en: {}/api/v1/productos/{}", baseUrl, productoId);

                @SuppressWarnings("unchecked")
                Map<String, Object> resp = restClient.get()
                        .uri(baseUrl + "/api/v1/productos/{id}", productoId)
                        .retrieve()
                        .body(Map.class);

                if (resp != null && resp.containsKey("precio")) {
                    return new BigDecimal(resp.get("precio").toString());
                }
            }
        } catch (Exception e) {
            log.warn("No se pudo consultar catalogo para producto {}: {}", productoId, e.getMessage());
        }
        return null;
    }
}