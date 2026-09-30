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

    private final OrdenCompraRepository ordenRepository;

    @Transactional
    @KafkaListener(topics = "${app.kafka.topic.pagos:pago-eventos}", groupId = "${spring.kafka.consumer.group-id:pc-orden-ms}")
    public void consumirPagoValidado(ConsumerRecord<String, PagoValidadoEvento> record) {
        PagoValidadoEvento evento = record.value();
        if (evento == null || !"pago.validado".equalsIgnoreCase(evento.getTipoEvento())) {
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

        Optional<OrdenCompra> optionalOrden = ordenRepository.findById(evento.getOrdenId());
        if (optionalOrden.isEmpty()) {
            log.error("component=consumer ordenId={} status=order_not_found", evento.getOrdenId());
            return;
        }

        OrdenCompra orden = optionalOrden.get();
        if (orden.getEstado() == EstadoOrden.PAGADA) {
            log.info("component=consumer ordenId={} status=already_paid", orden.getId());
            return;
        }

        orden.setEstado(EstadoOrden.PAGADA);
        ordenRepository.save(orden);
        log.info("component=consumer ordenId={} status=order_marked_paid", orden.getId());
    }
}
