package pe.edu.upeu.eniaclabs.orden.client;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.circuitbreaker.CircuitBreaker;
import org.springframework.cloud.client.circuitbreaker.CircuitBreakerFactory;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.math.BigDecimal;
import java.time.Duration;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ThreadLocalRandom;

@Slf4j
@Component
public class ProductoClient {

    private final DiscoveryClient discoveryClient;
    private final RestClient restClient;
    private final CircuitBreakerFactory<?, ?> circuitBreakerFactory;

    public ProductoClient(DiscoveryClient discoveryClient, CircuitBreakerFactory<?, ?> circuitBreakerFactory) {
        this.discoveryClient = discoveryClient;
        this.circuitBreakerFactory = circuitBreakerFactory;

        SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
        requestFactory.setConnectTimeout(Duration.ofMillis(2000));
        requestFactory.setReadTimeout(Duration.ofMillis(3500));

        this.restClient = RestClient.builder()
                .requestFactory(requestFactory)
                .build();
    }

    private String getBaseUrl() {
        try {
            List<ServiceInstance> instances = discoveryClient.getInstances("PC-CATALOGO-MS");
            if (instances == null || instances.isEmpty()) {
                instances = discoveryClient.getInstances("pc-catalogo-ms");
            }

            if (instances != null && !instances.isEmpty()) {
                // Client-side randomized load balancing across healthy instances
                int index = ThreadLocalRandom.current().nextInt(instances.size());
                return instances.get(index).getUri().toString();
            }
        } catch (Exception e) {
            log.warn("Error al resolver URL de PC-CATALOGO-MS desde Eureka: {}", e.getMessage());
        }
        return "http://pc-catalogo-ms:8080";
    }

    private String getCorrelationId() {
        String correlationId = org.slf4j.MDC.get("correlationId");
        return correlationId != null ? correlationId : java.util.UUID.randomUUID().toString();
    }

    public BigDecimal consultarPrecioProducto(Long productoId) {
        CircuitBreaker cb = circuitBreakerFactory.create("catalogoPrecio");
        return cb.run(() -> {
            String baseUrl = getBaseUrl();
            log.debug("Consultando precio del producto {} a {}", productoId, baseUrl);

            @SuppressWarnings("unchecked")
            Map<String, Object> resp = restClient.get()
                    .uri(baseUrl + "/api/v1/productos/{id}", productoId)
                    .header("X-Correlation-Id", getCorrelationId())
                    .retrieve()
                    .body(Map.class);

            if (resp != null && resp.containsKey("precio")) {
                return new BigDecimal(resp.get("precio").toString());
            }
            return null;
        }, throwable -> {
            log.warn("Circuit Breaker activado en consulta de precio para producto {}: {}", productoId, throwable.getMessage());
            return null;
        });
    }

    public boolean reservarStock(Long productoId, Integer cantidad) {
        CircuitBreaker cb = circuitBreakerFactory.create("catalogoStock");
        return Boolean.TRUE.equals(cb.run(() -> {
            String baseUrl = getBaseUrl();
            log.info("Saga Step: Solicitando reserva atómica de stock en Catálogo para producto {} x {}", productoId, cantidad);

            restClient.post()
                    .uri(baseUrl + "/api/v1/productos/{id}/stock/descontar", productoId)
                    .header("X-Correlation-Id", getCorrelationId())
                    .body(Map.of("cantidad", cantidad))
                    .retrieve()
                    .toBodilessEntity();
            return true;
        }, throwable -> {
            log.error("Fallo al reservar stock para producto {}: {}", productoId, throwable.getMessage());
            return false;
        }));
    }

    public void compensarStock(Long productoId, Integer cantidad) {
        try {
            String baseUrl = getBaseUrl();
            log.warn("Saga Compensating Action: Reponiendo stock para producto {} x {}", productoId, cantidad);

            restClient.post()
                    .uri(baseUrl + "/api/v1/productos/{id}/stock/reponer", productoId)
                    .header("X-Correlation-Id", getCorrelationId())
                    .body(Map.of("cantidad", cantidad))
                    .retrieve()
                    .toBodilessEntity();
        } catch (Exception e) {
            log.error("CRÍTICO: Falló la compensación de stock en Catálogo para producto {}: {}", productoId, e.getMessage());
        }
    }
}