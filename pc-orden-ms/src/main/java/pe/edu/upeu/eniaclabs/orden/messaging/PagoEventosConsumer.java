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
    private final OrdenService ordenService;

    @KafkaListener(topics = "${app.kafka.topic.pagos:pago-eventos}")
    public void alRecibirPago(PagoValidadoEvento evento) {
        if (evento == null || !PAGO_VALIDADO.equals(evento.getTipoEvento())) {
            log.warn("component=consumer eventType={} status=ignored", evento != null ? evento.getTipoEvento() : "null");
            return;
        }
        log.info("component=consumer eventType={} ordenId={} status=consumed", evento.getTipoEvento(), evento.getOrdenId());
        ordenService.marcarPagada(evento.getOrdenId());
    }
}
