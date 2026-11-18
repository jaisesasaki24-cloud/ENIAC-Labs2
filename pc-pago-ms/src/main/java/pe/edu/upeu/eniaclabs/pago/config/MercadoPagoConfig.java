package pe.edu.upeu.eniaclabs.pago.config;

import jakarta.annotation.PostConstruct;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

/**
 * Configuración oficial del SDK Java de Mercado Pago (Checkout Pro y Webhooks).
 * Inicializa el Access Token de Sandbox en el contexto de Spring Boot mediante @PostConstruct.
 *
 * @author ENIAC Labs - Arquitectura de Pagos Distribuidos
 */
@Slf4j
@Getter
@Configuration
public class MercadoPagoConfig {

    @Value("${mercadopago.access-token}")
    private String accessToken;

    @Value("${mercadopago.public-key}")
    private String publicKey;

    @Value("${mercadopago.currency:PEN}")
    private String currency;

    @Value("${frontend.url:http://localhost:4200}")
    private String frontendUrl;

    @Value("${mercadopago.auto-return:approved}")
    private String autoReturn;

    public String getBaseFrontendUrl() {
        String base = (frontendUrl != null && !frontendUrl.isBlank())
                ? frontendUrl.replaceAll("/+$", "")
                : "https://localhost:4200";
        if (base.startsWith("http://")) {
            base = base.replaceFirst("^http://", "https://");
        }
        return base;
    }

    public String getBackUrlSuccess() {
        return getBaseFrontendUrl() + "/pagar/success";
    }

    public String getBackUrlFailure() {
        return getBaseFrontendUrl() + "/pagar/failure";
    }

    public String getBackUrlPending() {
        return getBaseFrontendUrl() + "/pagar/pending";
    }

    @PostConstruct
    public void init() {
        if (accessToken != null && !accessToken.isBlank()) {
            com.mercadopago.MercadoPagoConfig.setAccessToken(accessToken);
            log.info("====================================================================");
            log.info("[MercadoPagoConfig] SDK Java v2.1.28 inicializado con éxito.");
            log.info("[MercadoPagoConfig] Modo: SANDBOX | Moneda: {}", currency);
            log.info("[MercadoPagoConfig] Public Key: {}...", publicKey != null && publicKey.length() > 15 ? publicKey.substring(0, 15) : publicKey);
            log.info("====================================================================");
        } else {
            log.warn("[MercadoPagoConfig] ATENCIÓN: mercadopago.access-token no está configurado.");
        }
    }

    @org.springframework.context.annotation.Bean
    public org.springframework.web.servlet.config.annotation.WebMvcConfigurer paymentCorsConfigurer() {
        return new org.springframework.web.servlet.config.annotation.WebMvcConfigurer() {
            @Override
            public void addCorsMappings(org.springframework.web.servlet.config.annotation.CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOriginPatterns("*")
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS", "HEAD", "PATCH")
                        .allowedHeaders("*")
                        .allowCredentials(false)
                        .maxAge(3600);
            }
        };
    }
}
