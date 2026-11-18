package pe.edu.upeu.eniaclabs.orden.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.upeu.eniaclabs.orden.entity.EstadoOrden;
import pe.edu.upeu.eniaclabs.orden.entity.OrdenCompra;
import pe.edu.upeu.eniaclabs.orden.event.PagoValidadoEvento;
import pe.edu.upeu.eniaclabs.orden.repository.OrdenCompraRepository;

import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class PagoEventConsumer {

    private final pe.edu.upeu.eniaclabs.orden.service.OrdenService ordenService;

    // Listener delegado de forma centralizada en pe.edu.upeu.eniaclabs.orden.messaging.PagoEventosConsumer
    public void consumirPagoValidado(ConsumerRecord<String, PagoValidadoEvento> record) {
        PagoValidadoEvento evento = record.value();
        if (evento == null || evento.getTipoEvento() == null) {
            log.warn("component=consumer status=ignored partition={} offset={}", record.partition(), record.offset());
            return;
        }

        log.info("component=consumer eventType={} ordenId={} pagoId={} estado={} partition={} offset={} status=consumed",
                evento.getTipoEvento(),
                evento.getOrdenId(),
                evento.getPagoId(),
                evento.getEstado(),
                record.partition(),
                record.offset());

        if ("pago.validado".equalsIgnoreCase(evento.getTipoEvento())) {
            ordenService.marcarPagada(evento.getOrdenId());
        } else if ("pago.fallido".equalsIgnoreCase(evento.getTipoEvento())) {
            ordenService.compensar(evento.getOrdenId());
        } else {
            log.warn("component=consumer eventType={} status=ignored", evento.getTipoEvento());
        }
    }
}
