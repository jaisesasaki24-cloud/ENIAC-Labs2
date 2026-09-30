package pe.edu.upeu.eniaclabs.pago.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.upeu.eniaclabs.pago.entity.EstadoPago;
import pe.edu.upeu.eniaclabs.pago.entity.TransaccionPago;
import pe.edu.upeu.eniaclabs.pago.event.OrdenCreadaEvento;
import pe.edu.upeu.eniaclabs.pago.event.PagoValidadoEvento;
import pe.edu.upeu.eniaclabs.pago.repository.TransaccionPagoRepository;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class OrdenEventConsumer {

    private final TransaccionPagoRepository transaccionPagoRepository;
    private final PagoEventProducer pagoEventProducer;

    @Transactional
    @KafkaListener(topics = "${app.kafka.topic.ordenes:orden-eventos}", groupId = "${spring.kafka.consumer.group-id:pc-pago-ms}")
    public void consumirOrdenCreada(ConsumerRecord<String, OrdenCreadaEvento> record) {
        OrdenCreadaEvento evento = record.value();
        if (evento == null || !"orden.creada".equalsIgnoreCase(evento.getTipoEvento())) {
            log.warn("component=consumer status=ignored partition={} offset={}", record.partition(), record.offset());
            return;
        }

        log.info("component=consumer eventType={} ordenId={} idCliente={} metodoPago={} total={} partition={} offset={} status=consumed",
                evento.getTipoEvento(),
                evento.getOrdenId(),
                evento.getIdCliente(),
                evento.getMetodoPago(),
                evento.getTotal(),
                record.partition(),
                record.offset());

        // Manejo idempotente de pagos
        List<TransaccionPago> existentes = transaccionPagoRepository.findByOrdenId(evento.getOrdenId());
        TransaccionPago pago;
        if (!existentes.isEmpty()) {
            pago = existentes.get(0);
            log.info("component=consumer ordenId={} status=already_processed pagoId={}", evento.getOrdenId(), pago.getId());
        } else {
            pago = TransaccionPago.builder()
                    .ordenId(evento.getOrdenId())
                    .codigoOrden("ORD-" + evento.getOrdenId())
                    .monto(evento.getTotal())
                    .moneda("PEN")
                    .metodoPago(evento.getMetodoPago() != null ? evento.getMetodoPago() : "TARJETA")
                    .estado(EstadoPago.APROBADO)
                    .payerEmail("cliente" + evento.getIdCliente() + "@eniaclabs.pe")
                    .build();
            pago = transaccionPagoRepository.save(pago);
            log.info("component=pago ordenId={} pagoId={} status=aprobado", evento.getOrdenId(), pago.getId());
        }

        // Publicar evento pago.validado
        PagoValidadoEvento pagoEvento = PagoValidadoEvento.builder()
                .tipoEvento("pago.validado")
                .ordenId(pago.getOrdenId())
                .pagoId(pago.getId())
                .monto(pago.getMonto())
                .metodoPago(pago.getMetodoPago())
                .estado(pago.getEstado().name())
                .origen("pc-pago-ms")
                .timestamp(System.currentTimeMillis())
                .build();

        pagoEventProducer.publicarPagoValidado(pagoEvento);
    }
}
