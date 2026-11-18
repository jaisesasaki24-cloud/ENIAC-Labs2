# 💻 C4 Modelo - Nivel 4: Código y Estructura de Clases (Code Level)

El **Diagrama de Código** desciende al nivel más granular del modelo C4, mostrando las clases de dominio, entidades JPA, patrones de diseño, DTOs y la estructura de datos que sustenta la **relación Muchos a Muchos (Cabecera - Detalle)** y el cálculo contable del **IGV (18% Perú)**.

---

## 1. Diagrama de Clases del Dominio Transaccional y Catálogo (Mermaid)

```mermaid
classDiagram
    direction TB

    class OrdenCompra {
        +Long id
        +String codigoOrden
        +Long clienteId
        +String clienteNombre
        +String clienteEmail
        +EstadoOrden estado
        +String metodoPago
        +String direccionEnvio
        +String observaciones
        +BigDecimal subtotal
        +BigDecimal igv
        +BigDecimal total
        +LocalDateTime fechaCreacion
        +LocalDateTime fechaActualizacion
        +List~OrdenCompraDetalle~ detalles
        +addDetalle(OrdenCompraDetalle detalle) void
    }

    class OrdenCompraDetalle {
        +Long id
        +OrdenCompra orden
        +Long productoId
        +String sku
        +String productoNombre
        +BigDecimal precioUnitario
        +Integer cantidad
        +BigDecimal subtotalLinea
        +calcularSubtotal() BigDecimal
    }

    class EstadoOrden {
        <<enumeration>>
        PENDIENTE
        PENDIENTE_PAGO
        PAGADA
        CONFIRMADA
        CANCELADA
        RECHAZADA
    }

    class ProductoHardware {
        +Long id
        +String sku
        +String nombre
        +String marca
        +String modelo
        +BigDecimal precio
        +Integer stockActual
        +Integer stockMinimo
        +Integer garantiaMeses
        +String especificaciones
        +Boolean activo
        +CategoriaHardware categoria
    }

    class CategoriaHardware {
        +Long id
        +String codigo
        +String nombre
        +String descripcion
        +Boolean activo
        +List~ProductoHardware~ productos
    }

    class CrearOrdenRequestDto {
        +String clienteNombre
        +String clienteEmail
        +String metodoPago
        +String direccionEnvio
        +String observaciones
        +List~ItemOrdenDto~ items
    }

    class ItemOrdenDto {
        +Long productoId
        +String sku
        +String productoNombre
        +BigDecimal precioUnitario
        +Integer cantidad
    }

    class OrdenResponseDto {
        +Long id
        +String codigoOrden
        +Long clienteId
        +EstadoOrden estado
        +BigDecimal subtotal
        +BigDecimal igv
        +BigDecimal total
        +List~DetalleOrdenDto~ detalles
    }

    class OrdenCreadaEvento {
        +String tipoEvento
        +Long ordenId
        +Long idCliente
        +BigDecimal total
        +String metodoPago
        +String origen
        +Long timestamp
    }

    %% Relaciones
    OrdenCompra "1" *-- "1..*" OrdenCompraDetalle : contiene (CascadeType.ALL)
    OrdenCompra --> EstadoOrden : estado
    OrdenCompraDetalle ..> ProductoHardware : referencia (productoId / M:N)
    CategoriaHardware "1" o-- "0..*" ProductoHardware : categoriza
    
    CrearOrdenRequestDto "1" *-- "1..*" ItemOrdenDto : contiene
    OrdenResponseDto ..> OrdenCompra : mapea desde
    OrdenCompra ..> OrdenCreadaEvento : genera tras commit
```

---

## 2. Explicación de la Relación Muchos a Muchos (M:N)

En el modelo de datos relacional de ENIAC Labs:
1. **Problema del Negocio**: Una orden de compra (`OrdenCompra`) puede incluir múltiples productos gamer (procesador, tarjeta gráfica, memoria RAM), y a su vez, un mismo producto puede estar incluido en cientos de órdenes de diferentes clientes.
2. **Implementación de la Entidad Asociativa**:
   - Se utiliza la entidad [`OrdenCompraDetalle`](file:///c:/Users/USUARIO/Music/nicro3/2/pc-orden-ms/src/main/java/pe/edu/upeu/eniaclabs/orden/entity/OrdenCompraDetalle.java) como tabla intermedia enriquecida con atributos propios de la transacción:
     - `cantidad`: Unidades adquiridas del componente.
     - `precioUnitario`: Precio histórico congelado al momento de la compra (inmune a variaciones futuras de catálogo).
     - `subtotalLinea`: Resultado de `cantidad * precioUnitario`.
     - `sku` y `productoNombre`: Snapshot de la descripción del producto para auditoría forense.

```
[OrdenCompra (Cabecera)] (1)
        │
        └───< (N) [OrdenCompraDetalle (Tabla Asociativa M:N)] >─── (1) [ProductoHardware (Catálogo)]
```

---

## 3. Lógica Contable y Transaccional (ACID)

En [`OrdenServiceImpl.java`](file:///c:/Users/USUARIO/Music/nicro3/2/pc-orden-ms/src/main/java/pe/edu/upeu/eniaclabs/orden/service/impl/OrdenServiceImpl.java):

```java
// Tasa de Impuesto General a las Ventas (Perú)
private static final BigDecimal IGV_RATE = new BigDecimal("0.18");

@Transactional
public OrdenResponseDto persistirOrdenLocalmente(
        CrearOrdenRequestDto req, 
        Long clienteId, 
        List<OrdenCompraDetalle> detalles, 
        BigDecimal subtotal) {

    // 1. Cálculo de IGV y Total con redondeo legal HALF_UP
    BigDecimal igv = subtotal.multiply(IGV_RATE).setScale(2, RoundingMode.HALF_UP);
    BigDecimal total = subtotal.add(igv).setScale(2, RoundingMode.HALF_UP);

    // 2. Construcción de la Cabecera
    OrdenCompra orden = OrdenCompra.builder()
            .codigoOrden(codigoGenerado)
            .clienteId(clienteId)
            .clienteNombre(req.getClienteNombre())
            .clienteEmail(req.getClienteEmail())
            .estado(EstadoOrden.PENDIENTE)
            .metodoPago(req.getMetodoPago())
            .direccionEnvio(req.getDireccionEnvio())
            .subtotal(subtotal)
            .igv(igv)
            .total(total)
            .build();

    // 3. Asociación bidireccional de detalles
    detalles.forEach(orden::addDetalle);

    // 4. Persistencia atómica en PostgreSQL
    OrdenCompra ordenGuardada = ordenRepository.save(orden);

    // 5. Emisión del evento Kafka ÚNICAMENTE tras el commit exitoso en BD
    TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization() {
        @Override
        public void afterCommit() {
            ordenEventProducer.publicarOrdenCreada(evento);
        }
    });

    return ordenMapper.toResponseDto(ordenGuardada);
}
```
