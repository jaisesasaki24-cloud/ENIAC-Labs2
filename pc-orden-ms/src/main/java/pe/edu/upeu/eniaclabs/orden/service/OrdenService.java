package pe.edu.upeu.eniaclabs.orden.service;

import pe.edu.upeu.eniaclabs.orden.dto.ActualizarEstadoOrdenDto;
import pe.edu.upeu.eniaclabs.orden.dto.CrearOrdenRequestDto;
import pe.edu.upeu.eniaclabs.orden.dto.OrdenResponseDto;
import pe.edu.upeu.eniaclabs.orden.entity.EstadoOrden;

import java.util.List;

public interface OrdenService {
    List<OrdenResponseDto> findAll(Long clienteId, EstadoOrden estado);
    OrdenResponseDto findById(Long id);
    OrdenResponseDto findByCodigoOrden(String codigoOrden);
    OrdenResponseDto create(CrearOrdenRequestDto request);
    OrdenResponseDto create(CrearOrdenRequestDto request, Long clienteId);
    OrdenResponseDto updateStatus(Long id, ActualizarEstadoOrdenDto request);
    void marcarPagada(Long ordenId);
    void cancel(Long id);
}