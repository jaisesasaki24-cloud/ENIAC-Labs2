package pe.edu.upeu.eniaclabs.cotizacion.service;

import pe.edu.upeu.eniaclabs.cotizacion.dto.*;
import java.util.List;

public interface CotizacionService {
    CotizacionResponseDto crearCotizacion(CrearCotizacionRequestDto request);
    List<CotizacionResponseDto> listarTodas();
    CotizacionResponseDto buscarPorId(Long id);
    ValidarCompatibilidadDto validarCompatibilidad(ValidarCompatibilidadDto request);
    ConvertirOrdenResponseDto convertirAOrden(Long cotizacionId);
}