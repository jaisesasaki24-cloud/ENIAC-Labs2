package pe.edu.upeu.eniaclabs.orden.config;

import feign.RequestInterceptor;
import org.slf4j.MDC;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FeignTraceConfig {

    public static final String TRACE_ID_HEADER = "X-Trace-ID";
    public static final String CORRELATION_ID_HEADER = CorrelationIdFilter.CORRELATION_ID_HEADER;

    @Bean
    public RequestInterceptor traceIdInterceptor() {
        return template -> {
            String correlationId = MDC.get(CorrelationIdFilter.CORRELATION_ID_MDC_KEY);
            if (correlationId != null) {
                template.header(CORRELATION_ID_HEADER, correlationId);
                template.header(TRACE_ID_HEADER, correlationId);
            }
        };
    }
}
