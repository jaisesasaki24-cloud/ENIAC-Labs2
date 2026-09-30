package pe.edu.upeu.eniaclabs.pago.service;

import pe.edu.upeu.eniaclabs.pago.dto.CheckoutRequestDto;
import pe.edu.upeu.eniaclabs.pago.dto.MercadoPagoWebhookDto;
import pe.edu.upeu.eniaclabs.pago.dto.PagoResponseDto;
import pe.edu.upeu.eniaclabs.pago.dto.SimularPagoDto;
import pe.edu.upeu.eniaclabs.pago.entity.EstadoPago;

import pe.edu.upeu.eniaclabs.pago.event.OrdenCreadaEvento;

import java.util.List;

public interface PagoService {
    void procesar(OrdenCreadaEvento orden);
    PagoResponseDto crearCheckoutSandbox(CheckoutRequestDto request);
    PagoResponseDto procesarWebhook(MercadoPagoWebhookDto webhookPayload, String rawPayload);
    PagoResponseDto simularResultadoPago(Long id, SimularPagoDto request);
    PagoResponseDto findById(Long id);
    List<PagoResponseDto> findByOrdenId(Long ordenId);
    List<PagoResponseDto> findAll(EstadoPago estado);
}