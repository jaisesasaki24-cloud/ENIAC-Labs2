package pe.edu.upeu.eniaclabs.orden.messaging;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;
import pe.edu.upeu.eniaclabs.orden.event.PagoValidadoEvento;
import pe.edu.upeu.eniaclabs.orden.service.OrdenService;

@Slf4j
@Component
@RequiredArgsConstructor
public class PagoEventosConsumer {

    private static final String PAGO_VALIDADO = "pago.validado";
    private static final String PAGO_FALLIDO = "pago.fallido";
    private final OrdenService ordenService;

    @KafkaListener(topics = "${app.kafka.topic.pagos:pago-eventos}", groupId = "${spring.kafka.consumer.group-id:pc-orden-ms}")
    public void alRecibirPago(PagoValidadoEvento evento) {
        if (evento == null || evento.getTipoEvento() == null) {
            log.warn("component=consumer eventType=null status=ignored");
            return;
        }
        switch (evento.getTipoEvento()) {
            case PAGO_VALIDADO -> {
                log.info("component=consumer eventType={} ordenId={} status=consumed", evento.getTipoEvento(), evento.getOrdenId());
                ordenService.marcarPagada(evento.getOrdenId());
            }
            case PAGO_FALLIDO -> {
                log.info("component=consumer eventType={} ordenId={} status=consumed", evento.getTipoEvento(), evento.getOrdenId());
                ordenService.compensar(evento.getOrdenId());
            }
            default -> log.warn("component=consumer eventType={} status=ignored", evento.getTipoEvento());
        }
    }
}
