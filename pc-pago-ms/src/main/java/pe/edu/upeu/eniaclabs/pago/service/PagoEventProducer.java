package pe.edu.upeu.eniaclabs.pago.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;
import pe.edu.upeu.eniaclabs.pago.event.PagoValidadoEvento;

@Slf4j
@Service
@RequiredArgsConstructor
public class PagoEventProducer {

    private final KafkaTemplate<String, Object> kafkaTemplate;

    @Value("${app.kafka.topic.pagos:pago-eventos}")
    private String topicPagos;

    public void publicarPagoValidado(PagoValidadoEvento evento) {
        String key = String.valueOf(evento.getOrdenId());
        kafkaTemplate.send(topicPagos, key, evento).whenComplete((result, ex) -> {
            if (ex == null) {
                log.info("component=producer eventType={} ordenId={} partition={} offset={} status=published",
                        evento.getTipoEvento(),
                        evento.getOrdenId(),
                        result.getRecordMetadata().partition(),
                        result.getRecordMetadata().offset());
            } else {
                log.error("component=producer eventType={} ordenId={} status=error error={}",
                        evento.getTipoEvento(),
                        evento.getOrdenId(),
                        ex.getMessage());
            }
        });
    }
}
