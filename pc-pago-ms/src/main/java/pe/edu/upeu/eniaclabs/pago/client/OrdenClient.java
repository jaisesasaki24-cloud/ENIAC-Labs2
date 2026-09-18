package pe.edu.upeu.eniaclabs.pago.client;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.List;
import java.util.Map;

@Slf4j
@Component
public class OrdenClient {

    private final DiscoveryClient discoveryClient;
    private final RestClient restClient;

    public OrdenClient(DiscoveryClient discoveryClient) {
        this.discoveryClient = discoveryClient;
        this.restClient = RestClient.builder().build();
    }

    public void actualizarEstadoOrden(Long ordenId, String nuevoEstado) {
        try {
            List<ServiceInstance> instances = discoveryClient.getInstances("PC-ORDEN-MS");
            if (instances == null || instances.isEmpty()) {
                instances = discoveryClient.getInstances("pc-orden-ms");
            }

            if (instances != null && !instances.isEmpty()) {
                String baseUrl = instances.get(0).getUri().toString();
                log.info("Comunicacion sincrona validada: notificando pago a {}/api/v1/ordenes/{}/estado", baseUrl, ordenId);

                restClient.patch()
                        .uri(baseUrl + "/api/v1/ordenes/{id}/estado", ordenId)
                        .body(Map.of("nuevoEstado", nuevoEstado))
                        .retrieve()
                        .toBodilessEntity();
            } else {
                log.warn("Eureka no tiene instancias registradas de PC-ORDEN-MS todavia");
            }
        } catch (Exception e) {
            log.warn("Fallo o fallback al notificar orden en pc-orden-ms: {}", e.getMessage());
        }
    }
}