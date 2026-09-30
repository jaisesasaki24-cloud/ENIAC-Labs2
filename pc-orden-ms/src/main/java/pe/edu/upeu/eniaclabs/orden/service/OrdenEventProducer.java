package pe.edu.upeu.eniaclabs.orden.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;
import pe.edu.upeu.eniaclabs.orden.event.OrdenCreadaEvento;

@Slf4j
@Service
@RequiredArgsConstructor
public class OrdenEventProducer {

    private final KafkaTemplate<String, Object> kafkaTemplate;

    @Value("${app.kafka.topic.ordenes:orden-eventos}")
    private String topicOrdenes;

    public void publicarOrdenCreada(OrdenCreadaEvento evento) {
        String key = String.valueOf(evento.getOrdenId());
        kafkaTemplate.send(topicOrdenes, key, evento).whenComplete((result, ex) -> {
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
