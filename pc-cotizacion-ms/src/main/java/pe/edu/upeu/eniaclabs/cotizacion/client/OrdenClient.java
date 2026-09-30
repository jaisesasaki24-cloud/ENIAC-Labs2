package pe.edu.upeu.eniaclabs.cotizacion.client;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.List;
import java.util.Map;

import org.springframework.http.client.SimpleClientHttpRequestFactory;
import java.time.Duration;

@Slf4j
@Component
public class OrdenClient {

    private final DiscoveryClient discoveryClient;
    private final RestClient restClient;

    public OrdenClient(DiscoveryClient discoveryClient) {
        this.discoveryClient = discoveryClient;
        SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
        requestFactory.setConnectTimeout(Duration.ofMillis(2000));
        requestFactory.setReadTimeout(Duration.ofMillis(4000));
        this.restClient = RestClient.builder().requestFactory(requestFactory).build();
    }

    @SuppressWarnings("unchecked")
    public Map<String, Object> crearOrdenDesdeCotizacion(Map<String, Object> ordenRequest) {
        try {
            List<ServiceInstance> instances = discoveryClient.getInstances("PC-ORDEN-MS");
            if (instances == null || instances.isEmpty()) {
                instances = discoveryClient.getInstances("pc-orden-ms");
            }

            if (instances != null && !instances.isEmpty()) {
                String baseUrl = instances.get(0).getUri().toString();
                log.info("Cotizador enviando venta a microservicio transaccional pc-orden-ms: {}/api/v1/ordenes", baseUrl);

                return restClient.post()
                        .uri(baseUrl + "/api/v1/ordenes")
                        .header("X-User-Id", String.valueOf(ordenRequest.getOrDefault("clienteId", "1")))
                        .body(ordenRequest)
                        .retrieve()
                        .body(Map.class);
            } else {
                log.warn("pc-orden-ms no esta disponible en Eureka todavia");
            }
        } catch (Exception e) {
            log.warn("Fallo al crear orden transaccional desde cotizacion: {}", e.getMessage());
        }
        return null;
    }
}