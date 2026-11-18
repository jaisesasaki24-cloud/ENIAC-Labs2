# ⚙️ C4 Modelo - Nivel 3: Componentes (Component Diagram)

El **Diagrama de Componentes** realiza un zoom sobre los microservicios principales del sistema, en particular sobre el **Microservicio Transaccional ([`pc-orden-ms`](file:///c:/Users/USUARIO/Music/nicro3/2/pc-orden-ms))** y el **Microservicio No Transaccional ([`pc-catalogo-ms`](file:///c:/Users/USUARIO/Music/nicro3/2/pc-catalogo-ms))**, detallando sus controladores REST, servicios de lógica de negocio, clientes Feign con Circuit Breaker, productores/consumidores de Kafka y repositorios JPA.

---

## 1. Diagrama de Componentes de `pc-orden-ms` (Transaccional)

```mermaid
C4Component
    title Diagrama de Componentes - pc-orden-ms (Transaccional)

    Container_Boundary(b_orden, "Contenedor: pc-orden-ms (:8083)") {
        Component(ctrl, "OrdenCompraController", "Spring MVC RestController", "Expone endpoints REST (/api/v1/ordenes) para creación, búsqueda y consulta de órdenes de compra.")
        Component(srv, "OrdenServiceImpl", "Spring Service con @Transactional", "Ejecuta lógica ACID: valida ítems, calcula IGV (18%), persiste cabecera-detalle, coordina Saga con stock y registra hook afterCommit.")
        Component(feign, "ProductoClient (Feign)", "Spring Cloud OpenFeign", "Invoca síncronamente a pc-catalogo-ms para verificar y reservar stock. Protegido con Circuit Breaker Resilience4j.")
        Component(cb, "Circuit Breaker & Fallback", "Resilience4j", "Interrumpe llamadas si pc-catalogo-ms supera el umbral de fallas y ejecuta lógica de fallback.")
        Component(prod, "OrdenEventProducer", "Spring Kafka Template", "Publica el evento orden.creada al broker de Kafka únicamente tras el commit exitoso en BD.")
        Component(cons, "PagoEventConsumer", "Spring Kafka Listener", "Escucha los eventos pago.procesado y pago.rechazado para transicionar el estado de la orden (PAGADA o CANCELADA).")
        Component(repo_ord, "OrdenCompraRepository", "Spring Data JPA Repository", "Operaciones CRUD sobre la entidad OrdenCompra (Cabecera).")
        Component(repo_det, "OrdenCompraDetalleRepository", "Spring Data JPA Repository", "Operaciones CRUD sobre la entidad OrdenCompraDetalle (Detalle).")
    }

    Container(gateway, "API Gateway", "Spring Cloud Gateway", "Enruta peticiones /api/v1/ordenes/**")
    Container(catalogo_ms, "pc-catalogo-ms", "Spring Boot", "Microservicio No Transaccional de Catálogo")
    ContainerDb(db_orden, "Base de Datos", "PostgreSQL (:5433)", "Almacena orden_compra y orden_compra_detalle")
    Container(kafka, "Apache Kafka", "Broker (:9092)", "Tópicos: orden.creada, pago.procesado, pago.rechazado")

    Rel(gateway, ctrl, "Petición HTTP POST / GET", "REST / JSON")
    Rel(ctrl, srv, "Invoca lógica de creación", "Java Method Call")
    Rel(srv, feign, "Reserva de inventario", "Java Method Call")
    Rel(feign, cb, "Monitoreo de tasa de error", "Resilience4j")
    Rel(cb, catalogo_ms, "POST /api/v1/productos/reservar", "HTTP REST")

    Rel(srv, repo_ord, "Persiste cabecera de orden", "JPA / Hibernate")
    Rel(srv, repo_det, "Persiste líneas de detalle", "JPA / Hibernate")
    Rel(repo_ord, db_orden, "INSERT / UPDATE", "SQL / JDBC")
    Rel(repo_det, db_orden, "INSERT", "SQL / JDBC")

    Rel(srv, prod, "afterCommit() trigger", "TransactionSynchronizationManager")
    Rel(prod, kafka, "Publica orden.creada", "Kafka Producer")
    Rel(kafka, cons, "Notifica pago.procesado", "Kafka Consumer")
    Rel(cons, srv, "Actualiza estado a PAGADA", "Java Method Call")
```

---

## 2. Diagrama de Componentes de `pc-catalogo-ms` (No Transaccional)

```mermaid
C4Component
    title Diagrama de Componentes - pc-catalogo-ms (No Transaccional)

    Container_Boundary(b_cat, "Contenedor: pc-catalogo-ms (:8081)") {
        Component(prod_ctrl, "ProductoController", "Spring MVC RestController", "Expone /api/v1/productos para consulta, filtrado por categorías y verificación de stock.")
        Component(cat_ctrl, "CategoriaController", "Spring MVC RestController", "Expone /api/v1/categorias para mantenimiento CRUD de líneas de hardware.")
        
        Component(prod_srv, "ProductoServiceImpl", "Spring Service (@Transactional readOnly)", "Consultas rápidas de componentes, actualización de stock y orquestación de lecturas.")
        Component(cat_srv, "CategoriaServiceImpl", "Spring Service", "Gestión de familias de componentes gamer (Motherboards, GPUs, CPUs, etc.).")
        
        Component(redis_srv, "InventarioRedisReservationService", "Spring Service", "Maneja candados distribuidos y caché de stock en tiempo real en Redis.")
        
        Component(prod_repo, "ProductoRepository", "Spring Data JPA Repository", "Acceso a tabla producto_hardware.")
        Component(cat_repo, "CategoriaRepository", "Spring Data JPA Repository", "Acceso a tabla categoria_hardware.")
    }

    Container(gateway_c, "API Gateway", "Spring Cloud Gateway", "Enruta /api/v1/productos/** y /api/v1/categorias/**")
    Container(orden_c, "pc-orden-ms", "Spring Boot", "Llamadas Feign para reserva/compensación de stock")
    ContainerDb(redis_db, "Redis Cache", "Redis 7 (:6379)", "Lectura/escritura de stock en memoria")
    ContainerDb(db_cat_db, "Base de Datos", "PostgreSQL (:15432)", "Almacén persistente de catálogo")

    Rel(gateway_c, prod_ctrl, "GET /productos", "HTTP REST")
    Rel(gateway_c, cat_ctrl, "GET /categorias", "HTTP REST")
    Rel(orden_c, prod_ctrl, "POST /stock/verificar y reservar", "HTTP Feign")

    Rel(prod_ctrl, prod_srv, "Invoca consulta / reserva", "Java Method")
    Rel(cat_ctrl, cat_srv, "Invoca CRUD categorías", "Java Method")

    Rel(prod_srv, redis_srv, "Verifica stock en memoria", "Java Method")
    Rel(redis_srv, redis_db, "GET / DECRBY / INCRBY", "RESP Protocol")

    Rel(prod_srv, prod_repo, "Consulta / Actualiza stock", "JPA")
    Rel(cat_srv, cat_repo, "CRUD de categorías", "JPA")

    Rel(prod_repo, db_cat_db, "SQL SELECT / UPDATE", "JDBC")
    Rel(cat_repo, db_cat_db, "SQL SELECT / INSERT", "JDBC")
```

---

## 3. Matriz de Componentes

| Microservicio | Componente | Rol Técnico |
| :--- | :--- | :--- |
| **`pc-orden-ms`** | `OrdenCompraController` | Controlador perimetral que recibe la solicitud de orden, extrae cabeceras de usuario (`X-User-Id`) y devuelve el DTO con el desglose contable. |
| **`pc-orden-ms`** | `OrdenServiceImpl` | Lógica de negocio con `@Transactional`. Realiza el cálculo del **18% de IGV** con redondeo legal `HALF_UP`, orquesta la compensación Saga y activa el hook `afterCommit`. |
| **`pc-orden-ms`** | `ProductoClient` | Cliente Feign con tolerancia a fallos Resilience4j (`@CircuitBreaker(name = "catalogoService")`) para comunicarse con `pc-catalogo-ms`. |
| **`pc-catalogo-ms`** | `ProductoController` | Expone endpoints para búsqueda por SKU, filtrado por categorías y verificación de stock disponible. |
| **`pc-catalogo-ms`** | `ProductoServiceImpl` | Lógica de consulta de hardware con `@Transactional(readOnly = true)` para optimizar lecturas directas en PostgreSQL. |
| **`pc-catalogo-ms`** | `InventarioRedisReservationService` | Bloqueo atómico y decremento de stock en Redis previo a la confirmación de la orden. |
