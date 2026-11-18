# S9 - Consistencia Distribuida en Procesos de Negocio

> **Proyecto Sello de Sistemas Distribuidos — ENIAC Labs**  
> **Integrantes:**  
> - **Eliceo Parillo Mostajo** (`pc-orden-ms`, `pc-catalogo-ms`)  
> - **Laura Vargas Cristhian Paul** (`pc-pago-ms`, `pc-auth-ms`, `pc-gateway`, `pc-cotizacion-ms`)  
> **Docente:** Angel Sullon Macalupu (@asullom) / Mg. Juan Carlos Condori  
> **Unidad:** U2 - Sistema distribuido robusto  

---

## 1. Introducción

**Tiempo estimado:** 20 min.

### 1.1 Presentación de la Sesión
La sesión S08 dejó dos interrogantes fundamentales abiertas a propósito:
1. *Si Apache Kafka garantiza entrega "al menos una vez" (at-least-once delivery), ¿qué ocurre cuando un mensaje `orden.creada` se reenvía o reprocesa?* En S08, el consumidor de pagos no verificaba si la orden ya había sido cobrada, provocando un choque frontal contra la restricción `UNIQUE (orden_id)` de la base de datos PostgreSQL.
2. *En S08 la pasarela externa se simulaba validando siempre de forma exitosa.* En el mundo real del e-commerce gamer, las transacciones fallan: tarjetas sin fondos suficientes, bloqueos antifraude o caídas de pasarelas de pago.

Esta sesión responde a ambos desafíos:
* Primero, reproducimos el error de duplicados en vivo y lo resolvemos implementando el patrón **Idempotent Consumer** con dos capas defensivas (revisión explícita `findByOrdenId` y captura de `DataIntegrityViolationException`).
* Segundo, introducimos el estado `FALLIDO` y el evento **`pago.fallido`** desencadenado deterministamente mediante el método `TARJETA_RECHAZADA`.
* Tercero, `pc-orden-ms` reacciona ante `pago.fallido` ejecutando una **acción compensatoria**: transiciona la orden de `PENDIENTE` a `CANCELADA` y repone el stock previamente reservado en `pc-catalogo-ms`.

Este flujo coordinado de transacciones locales con acciones de reversión sin bloqueo distribuido conforma una **Saga Coreografiada**.

---

## 2. Arquitectura y Conceptos Teóricos

```
                        ╔═════════════════════════════════════════════════╗
                        ║           ARQUITECTURA DE LA SESIÓN S09         ║
                        ║              (Saga Coreografiada)               ║
                        ╚═════════════════════════════════════════════════╝

   [ Cliente Gamer ] ──POST /api/v1/ordenes──► [ pc-orden-ms ] (201 Created inmediato)
                                                    │
                                            (publica orden.creada)
                                                    ▼
                                        ╔═══════════════════════╗
                                        ║  Topic: orden-eventos ║
                                        ╚═══════════════════════╝
                                                    │
                                            (consume asíncrono)
                                                    ▼
                                             [ pc-pago-ms ]
                                                    │
                        ┌───────────────────────────┴───────────────────────────┐
                        ▼                                                       ▼
            ¿Pago ya procesado?                                     ¿metodoPago == TARJETA_RECHAZADA?
              (findByOrdenId)                                                   │
             SI: status=ignored                                    ┌────────────┴────────────┐
             NO: procesa en BD                                     ▼                         ▼
                                                             [ VALIDADO ]               [ FALLIDO ]
                                                                   │                         │
                                                            (pago.validado)           (pago.fallido)
                                                                   ▼                         ▼
                                                        ╔═══════════════════════════════════════╗
                                                        ║          Topic: pago-eventos          ║
                                                        ╚═══════════════════════════════════════╝
                                                                   │                         │
                                                                   └────────────┬────────────┘
                                                                                ▼
                                                                         [ pc-orden-ms ]
                                                                                │
                                                            ┌───────────────────┴───────────────────┐
                                                            ▼                                       ▼
                                                     [ pago.validado ]                       [ pago.fallido ]
                                                            │                                       │
                                                   PENDIENTE ➔ PAGADA                     PENDIENTE ➔ CANCELADA
                                                  (Orden confirmada)                     (Compensación de stock)
```

### 2.1 Entrega "Al Menos Una Vez" e Idempotencia
* **At-Least-Once Delivery:** Kafka garantiza que ningún mensaje se pierda, pero admite reentregas si un consumidor procesa un evento y se reinicia antes de confirmar su offset en el broker.
* **Idempotencia:** Propiedad según la cual una operación produce exactamente el mismo resultado final si se ejecuta una o múltiples veces ($f(f(x)) = f(x)$).

### 2.2 Patrón Saga Coreografiada vs Orquestada
* **Saga Coreografiada (ENIAC Labs):** No existe un coordinador centralizado. Cada microservicio escucha eventos, ejecuta transacciones locales y publica nuevos eventos. Maximiza la autonomía y elimina puntos únicos de fallo.
* **Saga Orquestada:** Un componente central orquesta paso a paso y emite comandos directos. Recomendable cuando la cadena de eventos supera los 5 microservicios para evitar dispersión lógica.

---

## 3. Implementación Práctica Paso a Paso

### 3.1 Idempotencia en `pc-pago-ms`

Se agregaron dos capas defensivas en [`PagoServiceImpl.java`](file:///c:/Users/USUARIO/Pictures/finalmicro/2/pc-pago-ms/src/main/java/pe/edu/upeu/eniaclabs/pago/service/impl/PagoServiceImpl.java):

```java
@Override
@Transactional
public void procesar(OrdenCreadaEvento orden) {
    log.info("component=service ordenId={} status=processing", orden.getOrdenId());

    // Capa 1: Verificación preventiva sin bloqueo
    if (pagoRepository.findByOrdenId(orden.getOrdenId()).isPresent()) {
        log.warn("component=processor ordenId={} status=ignored motivo=\"pago ya procesado (evento duplicado)\"", orden.getOrdenId());
        return;
    }

    boolean rechazado = METODO_RECHAZADO.equalsIgnoreCase(orden.getMetodoPago());
    EstadoPago estadoResultante = rechazado ? EstadoPago.FALLIDO : EstadoPago.VALIDADO;

    // Capa 2: Respaldo contra condiciones de carrera concurrentes
    Pago pago;
    try {
        pago = pagoRepository.save(Pago.builder()
                .ordenId(orden.getOrdenId())
                .monto(orden.getTotal())
                .metodoPago(orden.getMetodoPago() != null ? orden.getMetodoPago() : "TARJETA")
                .estado(estadoResultante)
                .fechaPago(LocalDateTime.now())
                .build());
    } catch (DataIntegrityViolationException ex) {
        log.warn("component=processor ordenId={} status=ignored motivo=\"pago ya procesado (condicion de carrera)\"", orden.getOrdenId());
        return;
    }

    String tipoEventoResultante = rechazado ? PAGO_FALLIDO : PAGO_VALIDADO;
    pagoEventosProducer.publicarTrasCommit(PagoValidadoEvento.builder()
            .tipoEvento(tipoEventoResultante)
            .ordenId(pago.getOrdenId())
            .pagoId(pago.getId())
            .monto(pago.getMonto())
            .metodoPago(pago.getMetodoPago())
            .estado(pago.getEstado().name())
            .origen(nombreServicio)
            .timestamp(Instant.now().toEpochMilli())
            .build());

    log.info("component=processor ordenId={} estado={} status=processed", pago.getOrdenId(), pago.getEstado());
}
```

---

### 3.2 Consumo de `pago.fallido` y Compensación en `pc-orden-ms`

En [`PagoEventosConsumer.java`](file:///c:/Users/USUARIO/Pictures/finalmicro/2/pc-orden-ms/src/main/java/pe/edu/upeu/eniaclabs/orden/messaging/PagoEventosConsumer.java):

```java
@KafkaListener(topics = "${app.kafka.topic.pagos:pago-eventos}")
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
```

En [`OrdenServiceImpl.java`](file:///c:/Users/USUARIO/Pictures/finalmicro/2/pc-orden-ms/src/main/java/pe/edu/upeu/eniaclabs/orden/service/impl/OrdenServiceImpl.java):

```java
@Override
@Transactional
public void compensar(Long ordenId) {
    OrdenCompra orden = ordenRepository.findById(ordenId).orElse(null);
    if (orden == null || (orden.getEstado() != EstadoOrden.PENDIENTE)) {
        log.warn("component=processor ordenId={} status=ignored motivo=\"la orden no existe o ya no esta pendiente de pago\"", ordenId);
        return;
    }
    orden.setEstado(EstadoOrden.CANCELADA);
    ordenRepository.save(orden);

    // Compensación de stock en Catálogo (Parte E)
    if (orden.getDetalles() != null) {
        for (OrdenCompraDetalle det : orden.getDetalles()) {
            try {
                productoClient.compensarStock(det.getProductoId(), det.getCantidad());
            } catch (Exception e) {
                log.error("[CATALOGO] No se pudo restaurar stock de producto {} al compensar orden {}. Motivo: {}",
                        det.getProductoId(), ordenId, e.getMessage());
            }
        }
    }
    log.info("component=processor ordenId={} estado={} status=compensated", ordenId, orden.getEstado());
}
```

---

### 3.3 Reserva y Compensación de Stock en Catálogo (Parte E - Opcional)

En [`pc-catalogo-ms`](file:///c:/Users/USUARIO/Pictures/finalmicro/2/pc-catalogo-ms/src/main/java/pe/edu/upeu/eniaclabs/catalogo/controller/ProductoController.java):
* `POST /api/v1/productos/{id}/stock/descontar`: Reduce el stock atómicamente con `@Transactional` al registrar la orden.
* `POST /api/v1/productos/{id}/stock/reponer`: Repone el stock exacto cuando la Saga ejecuta la compensación por pago rechazado.

| Momento de Evaluación | Stock de AMD Ryzen 7 7800X3D (ID 1) |
|---|:---:|
| **Inicial:** Antes de registrar la orden | **50 unidades** |
| **Paso 1:** Al registrar orden con `TARJETA_RECHAZADA` (cantidad 2) | **48 unidades** (descontado) |
| **Paso 2:** Tras recibir `pago.fallido` y ejecutar `compensar()` | **50 unidades** (restituido) |

---

## 4. Guía de Ejecución y Pruebas en PowerShell

### Test 1: Prueba de Idempotencia ante Mensaje Duplicado
```powershell
# Enviar orden normal
$orden = Invoke-RestMethod -Method Post -Uri "http://localhost:18080/api/v1/ordenes" `
    -Headers @{ "X-User-Id" = "1" } `
    -ContentType "application/json" `
    -Body '{"metodoPago": "YAPE_PLIN", "detalles": [{"productoId": 1, "cantidad": 1}]}'

# En Kafka UI (:18085), republicar el mismo mensaje en orden-eventos con la misma key
# Log esperado en pc-pago-ms:
# status=ignored motivo="pago ya procesado (evento duplicado)"
```

### Test 2: Prueba de Pago Fallido y Compensación
```powershell
# Enviar orden con método de pago que detona rechazo determinista
$rechazada = Invoke-RestMethod -Method Post -Uri "http://localhost:18080/api/v1/ordenes" `
    -Headers @{ "X-User-Id" = "1" } `
    -ContentType "application/json" `
    -Body '{"metodoPago": "TARJETA_RECHAZADA", "detalles": [{"productoId": 1, "cantidad": 2}]}'

# Esperar 2 segundos y consultar estado
$estado = (Invoke-RestMethod -Method Get -Uri "http://localhost:18080/api/v1/ordenes/$($rechazada.id)").estado
Write-Host "Estado de la orden compensada:" $estado -ForegroundColor Yellow
# Resultado esperado: CANCELADA
```

### Test 3: Idempotencia de la Compensación
```powershell
# Republicar el mensaje pago.fallido en pago-eventos
# Log esperado en pc-orden-ms:
# status=ignored motivo="la orden no existe o ya no esta pendiente de pago"
```

---

## 5. Preguntas de Defensa Técnica (Sección 4.5)

1. **¿Por qué Kafka garantiza "al menos una vez" y no "exactamente una vez" por defecto?**  
   *Respuesta:* Porque exactamente una vez requeriría transacciones distribuidas 2PC entre broker y clientes, degradando el throughput. La práctica estándar es delegar la idempotencia al consumidor.
2. **¿Por qué la idempotencia en `pc-pago-ms` combina `findByOrdenId` con `try-catch`?**  
   *Respuesta:* `findByOrdenId` resuelve rápidamente el 99.9% de duplicados sin sobrecargar la BD; el `try-catch` de `DataIntegrityViolationException` protege contra condiciones de carrera cuando dos mensajes idénticos llegan simultáneamente.
3. **¿Por qué `compensar` no borra la orden sino que la pasa a `CANCELADA`?**  
   *Respuesta:* Porque una compensación de negocio debe ser auditable y trazable en el tiempo, sin destruir el historial transaccional del cliente.
4. **¿Por qué `restaurarStock` no aborta si Catálogo está caído?**  
   *Respuesta:* La prioridad de la Saga es garantizar la consistencia del estado de la orden (`CANCELADA`); la discrepancia de stock se registra en el log para reconciliación asíncrona sin trabar el flujo.
