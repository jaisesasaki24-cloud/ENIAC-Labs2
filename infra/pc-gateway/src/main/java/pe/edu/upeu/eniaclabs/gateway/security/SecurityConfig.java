package pe.edu.upeu.eniaclabs.gateway.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.web.server.SecurityWebFilterChain;

@Configuration
@EnableWebFluxSecurity
public class SecurityConfig {

    @Bean
    public SecurityWebFilterChain securityWebFilterChain(ServerHttpSecurity http) {
        return http
                .csrf(ServerHttpSecurity.CsrfSpec::disable)
                .cors(ServerHttpSecurity.CorsSpec::disable)
                .authorizeExchange(exchange -> exchange
                        // Rutas públicas (Autenticación, salud, pagos Mercado Pago y catálogo público)
                        .pathMatchers("/api/v1/auth/**").permitAll()
                        .pathMatchers("/api/payments/**").permitAll()
                        .pathMatchers("/api/v1/pagos/**").permitAll()
                        .pathMatchers("/api/contabilidad/**").permitAll()
                        .pathMatchers("/actuator/**").permitAll()
                        .pathMatchers(HttpMethod.GET, "/api/v1/productos/**").permitAll()
                        .pathMatchers(HttpMethod.GET, "/api/v1/categorias/**").permitAll()
                        .pathMatchers("/swagger-ui/**", "/v3/api-docs/**", "/swagger-ui.html").permitAll()
                        // Permitir todas las demás peticiones para la demo y pruebas de frontend/móvil
                        .anyExchange().permitAll()
                )
                .build();
    }
}
