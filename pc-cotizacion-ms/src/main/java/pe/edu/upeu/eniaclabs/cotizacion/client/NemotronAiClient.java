package pe.edu.upeu.eniaclabs.cotizacion.client;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import pe.edu.upeu.eniaclabs.cotizacion.dto.AsesorIaRequestDto;
import pe.edu.upeu.eniaclabs.cotizacion.dto.AsesorIaResponseDto;

import java.time.Duration;
import java.util.*;

@Slf4j
@Component
public class NemotronAiClient {

    private final RestClient restClient;
    private final String baseUrl;
    private final String apiKey;
    private final String model;

    public NemotronAiClient(
            @Value("${eniaclabs.ai.nemotron.base-url:https://integrate.api.nvidia.com/v1}") String baseUrl,
            @Value("${eniaclabs.ai.nemotron.api-key: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}") String apiKey,
            @Value("${eniaclabs.ai.nemotron.model:nvidia/nemotron-3-ultra-550b-a55b}") String model
    ) {
        this.baseUrl = baseUrl;
        this.apiKey = apiKey;
        this.model = model;

        SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
        requestFactory.setConnectTimeout(Duration.ofSeconds(10));
        requestFactory.setReadTimeout(Duration.ofSeconds(45));

        this.restClient = RestClient.builder()
                .baseUrl(baseUrl)
                .requestFactory(requestFactory)
                .build();
    }

    public AsesorIaResponseDto consultarAsesorHardware(AsesorIaRequestDto req) {
        String systemPrompt = """
            Eres el Asesor Principal de Hardware y Ensambles Especializados de ENIAC Labs, impulsado por NVIDIA Nemotron 3 Ultra (550B).
            Tu objetivo es analizar la configuración de componentes, evaluar compatibilidad eléctrica, sockets, chipsets, cuellos de botella (bottlenecks) y equilibrio térmico.
            Responde en español de forma profesional, concisa y estructurada.
            """;

        StringBuilder userPrompt = new StringBuilder();
        userPrompt.append("Evalúa y asesora sobre la siguiente configuración de hardware:\n");
        if (req.getConsulta() != null && !req.getConsulta().isBlank()) {
            userPrompt.append("- Consulta/Objetivo: ").append(req.getConsulta()).append("\n");
        }
        if (req.getTipoUso() != null) userPrompt.append("- Tipo de uso: ").append(req.getTipoUso()).append("\n");
        if (req.getPresupuestoAproximado() != null) userPrompt.append("- Presupuesto aproximado: $").append(req.getPresupuestoAproximado()).append("\n");
        if (req.getProcesador() != null) userPrompt.append("- Procesador (CPU): ").append(req.getProcesador()).append("\n");
        if (req.getPlacaMadre() != null) userPrompt.append("- Placa Madre (Motherboard): ").append(req.getPlacaMadre()).append("\n");
        if (req.getTarjetaGrafica() != null) userPrompt.append("- Tarjeta Gráfica (GPU): ").append(req.getTarjetaGrafica()).append("\n");
        if (req.getMemoriaRam() != null) userPrompt.append("- Memoria RAM: ").append(req.getMemoriaRam()).append("\n");
        if (req.getFuenteWatts() != null) userPrompt.append("- Fuente de poder: ").append(req.getFuenteWatts()).append("W\n");

        userPrompt.append("\nPor favor analiza: 1. Compatibilidad, 2. Cuello de botella, 3. Recomendaciones de optimización.");

        Map<String, Object> payload = new HashMap<>();
        payload.put("model", model);
        payload.put("messages", List.of(
                Map.of("role", "system", "content", systemPrompt),
                Map.of("role", "user", "content", userPrompt.toString())
        ));
        payload.put("temperature", 0.6);
        payload.put("top_p", 0.95);
        payload.put("max_tokens", 2048);
        payload.put("extra_body", Map.of("chat_template_kwargs", Map.of("enable_thinking", true)));

        try {
            log.info("Invocando NVIDIA Nemotron 3 Ultra en {} para consulta de hardware...", baseUrl);

            @SuppressWarnings("unchecked")
            Map<String, Object> response = restClient.post()
                    .uri("/chat/completions")
                    .header("Authorization", "Bearer " + apiKey)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(payload)
                    .retrieve()
                    .body(Map.class);

            if (response != null && response.containsKey("choices")) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> choices = (List<Map<String, Object>>) response.get("choices");
                if (!choices.isEmpty()) {
                    @SuppressWarnings("unchecked")
                    Map<String, Object> msg = (Map<String, Object>) choices.get(0).get("message");
                    String content = (String) msg.get("content");
                    String reasoning = (String) msg.get("reasoning_content");

                    return AsesorIaResponseDto.builder()
                            .compatible(true)
                            .conclusion("Análisis de hardware generado con éxito por NVIDIA Nemotron 3 Ultra")
                            .analisisDetallado(content)
                            .razonamientoNemotron(reasoning != null ? reasoning : "Razonamiento procesado internamente por el modelo de 550B.")
                            .advertencias(List.of("Verificar revisiones de BIOS de la placa antes del ensamble final."))
                            .recomendaciones(List.of(
                                    "Asegurar flujo de aire positivo en el chasis para disipar el TDP de la GPU.",
                                    "Habilitar perfil EXPO/XMP en BIOS para máxima velocidad de RAM."
                            ))
                            .modeloUtilizado(model)
                            .build();
                }
            }
        } catch (Exception e) {
            log.warn("NVIDIA Nemotron 3 Ultra API no disponible temporalmente ({}), aplicando motor heurístico de contingencia.", e.getMessage());
        }

        // Fallback heurístico resiliente si la API externa no está activa o autorizada
        return fallbackAsesorLocal(req);
    }

    private AsesorIaResponseDto fallbackAsesorLocal(AsesorIaRequestDto req) {
        List<String> adv = new ArrayList<>();
        List<String> rec = new ArrayList<>();
        boolean comp = true;

        if (req.getProcesador() != null && req.getProcesador().toUpperCase().contains("AM5")) {
            if (req.getPlacaMadre() != null && !req.getPlacaMadre().toUpperCase().contains("AM5") && !req.getPlacaMadre().toUpperCase().contains("B650") && !req.getPlacaMadre().toUpperCase().contains("X670")) {
                comp = false;
                adv.add("Alerta de socket: AMD AM5 requiere placas base con chipset A620, B650 o X670.");
            }
        }

        if (req.getFuenteWatts() != null && req.getFuenteWatts() < 750 && req.getTarjetaGrafica() != null && (req.getTarjetaGrafica().contains("4080") || req.getTarjetaGrafica().contains("4090"))) {
            comp = false;
            adv.add("Alerta de potencia: GPUs serie RTX 4080/4090 requieren mínimo 850W con certificación Gold o conector 12VHPWR.");
        }

        rec.add("Recomendado por ENIAC Labs: Instalar memoria RAM en configuración Dual Channel (mínimo 32GB DDR5 6000MHz CL30).");
        rec.add("Garantizar SSD NVMe PCIe 4.0 para reducir tiempos de carga y evitar cuellos de botella en I/O.");

        return AsesorIaResponseDto.builder()
                .compatible(comp)
                .conclusion(comp ? "Configuración balanceada y técnicamente viable (Motor Heurístico ENIAC Labs)" : "Se detectaron posibles incompatibilidades técnicas")
                .analisisDetallado("Análisis preventivo: Verifique el TDP conjunto de CPU + GPU y asegure espacio libre de al menos 340mm en el gabinete para el disipador de la tarjeta gráfica.")
                .razonamientoNemotron("Modo de contingencia: Respuesta generada por el motor de reglas locales ante latencia o autorización pendiente en NVIDIA NIM.")
                .advertencias(adv)
                .recomendaciones(rec)
                .modeloUtilizado(model + " (Fallback Heurístico)")
                .build();
    }
}
