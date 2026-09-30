# Producto de la Unidad II: Sistema Distribuido Seguro, Resiliente, Consistente, Observable e Integrado

> **Proyecto Sello — ENIAC Labs (Ecosistema Gamer de Alto Rendimiento)**  
> **Universidad Peruana Unión — Facultad de Ingeniería y Arquitectura**  
> **Curso:** Desarrollo de Aplicaciones Distribuidas (2026)  
> **Docente:** Angel Sullon Macalupu (@asullom) / Mg. Juan Carlos Condori  
> **Integrantes del Equipo:**  
> - **Laura Vargas Cristhian Paul** (`pc-pago-ms`, `pc-auth-ms`, `pc-gateway`, `pc-cotizacion-ms`)  
> - **Eliceo Parillo Mostajo** (`pc-orden-ms`, `pc-catalogo-ms`)  
> **Competencia Evaluada:** CE023 — Nivel 3: *Diseño, implementación y operación de sistemas distribuidos robustos, tolerantes a fallos, seguros y observables bajo estándares de la industria.*

---

## 1. Visión General del Producto de Unidad

El producto de la Unidad II consolida la evolución del ecosistema distribuido **ENIAC Labs** desde una arquitectura base funcional (Unidad I) hacia un **sistema distribuido empresarial de misión crítica** dotado de los seis atributos de calidad exigidos en el sílabo de la asignatura:

```
                                  ╔═══════════════════════════════════════╗
                                  ║         CLIENTE FRONTEND (S11)        ║
                                  ║    Angular / SPA Gamer (:4200)        ║
                                  ╚═══════════════════════════════════════╝
                                                     │
                                           (HTTPS / Bearer JWT)
                                                     ▼
    ╔═══════════════════════════════════════════════════════════════════════════════════════╗
    ║                     SEGURIDAD Y CONTROL DE ACCESO PERIMETRAL (S7)                     ║
    ║                               pc-gateway (:18080)                                     ║
    ║         - Resource Server perimetral con validación de firma asimétrica RS256        ║
    ║         - Control de Acceso Basado en Roles (RBAC: ADMIN vs CLIENTE)                  ║
    ╚═══════════════════════════════════════════════════════════════════════════════════════╝
               │                                      │                                 │
     (lb://pc-catalogo-ms)                   (lb://pc-orden-ms)                 (lb://pc-pago-ms)
               │                                      │                                 │
               ▼                                      ▼                                 ▼
   ╔═══════════════════════╗              ╔═══════════════════════╗         ╔═══════════════════════╗
   ║    pc-catalogo-ms     ║◄────Feign────║      pc-orden-ms      ║         ║      pc-pago-ms       ║
   ║    (:8081 / :15432)   ║   Circuit    ║    (:8083 / :5433)    ║         ║    (:8085 / :5434)    ║
   ║                       ║   Breaker    ║  ÚNICO TRANSACCIONAL  ║         ║   Pasarela y Cobros   ║
   ╚═══════════════════════╝    (S6)      ╚═══════════════════════╝         ╚═══════════════════════╝
               ▲                                      │                                 │
               │                               (orden.creada)                    (pago.validado)
               │                                      ▼                                 ▲
               │                          ╔═════════════════════════════════════════════╩═══╗
               │                          ║           MENSAJERÍA KAFKA (S8/S9)               ║
               │                          ║  Topics: orden-eventos / pago-eventos (KRaft)    ║
               │                          ╚═════════════════════════════════════════════╦═══╝
               │                                                                        │
               └──────────── Compensación Saga: Restitución de Stock (S9) ──────────────┘

    ═════════════════════════════════════════════════════════════════════════════════════════
    PILARES TRANSVERSALES:
    - OBSERVABILIDAD (S10): Prometheus (:9090), Grafana (:3000), Loki (:3100), Zipkin Tracing
    - CONFIG SERVER (S2): pc-config (:18888) inyectando perfiles DEV y PROD
    - SERVICE DISCOVERY (S3): pc-eureka (:18761) con registro dinámico de instancias
    ═════════════════════════════════════════════════════════════════════════════════════════
```

---

## 2. Ensamblaje de Capacidades por Sesión (S6 a S11)

La siguiente tabla resume la correlación entre cada sesión temática de la Unidad II y la implementación concreta en el código y arquitectura de **ENIAC Labs**:

### Tabla 1. Matriz de Ensamblaje Técnico de la Unidad II
| Sesión | Atributo de Calidad | Problema que Resuelve en ENIAC Labs | Componentes y Tecnologías | Evidencia Demostrable |
|---|---|---|---|---|
| **S6** | **Comunicación Síncrona Resiliente** | La consulta de precios/stock de componentes gamer no debe tumbar a `pc-orden-ms` si `pc-catalogo-ms` sufre lentitud o caída. | Spring Cloud OpenFeign + **Resilience4j Circuit Breaker** (`catalogoPrecio`) con ventana tipo `COUNT_BASED` (5 llamadas, umbral 50%, wait 10s). | Inyección de fallo o caída de catálogo: el circuito pasa a `OPEN`, ejecuta fallback controlado y responde en milisegundos sin congelar hilos HTTP. |
| **S7** | **Seguridad Distribuida y Control de Acceso** | Evitar la suplantación de identidad en compras (`clienteId` libre) y proteger endpoints administrativos del catálogo gamer. | **`pc-auth-ms`** (emite JWT con RS256 y publica `/.well-known/jwks.json`), **`pc-gateway`** como Resource Server con filtro RBAC (`ADMIN` vs `CLIENTE`), y defensa en profundidad en `pc-orden-ms`. | Petición sin token (`401 Unauthorized`), petición de cliente a catálogo admin (`403 Forbidden`) y creación de orden tomando `clienteId` inmutable del claim JWT. |
| **S8** | **Mensajería Asíncrona entre Servicios** | Desacoplar temporalmente el registro de compras gamer de la pasarela de pagos, evitando que el usuario espere cobros externos lentos. | **Apache Kafka (KRaft)** en Docker (:19092, :18085), tópicos `orden-eventos` y `pago-eventos` (3 particiones, key `ordenId`), productores con `afterCommit` y deserializadores tolerantes a errores. | Apagar `pc-pago-ms`: la orden se registra de inmediato (`201 Created` en `PENDIENTE`), el lag se acumula en Kafka UI y se procesa automáticamente al encenderlo pasando a `PAGADA`. |
| **S9** | **Consistencia Distribuida (Saga)** | Mantener consistencia de stock y cobros entre bases de datos aisladas sin transacciones distribuidas 2PC bloqueantes. | **Saga Coreografiada**: eventos compensatorios `pago.fallido`, restitución atómica de stock en `pc-catalogo-ms` y cancelación de orden en `pc-orden-ms` con idempotencia estricta. | Simular rechazo de tarjeta: la orden pasa a `CANCELADA`, se emite evento compensatorio y el stock del hardware en Catálogo regresa a su valor previo. |
| **S10** | **Observabilidad y Diagnóstico** | Localizar cuellos de botella e incidentes distribuidos entre 6 microservicios sin inspeccionar terminales independientes. | **Prometheus** (métricas de negocio y JVM), **Grafana** (dashboards unificados), **Loki** (recolección centralizada de logs) y Micrometer Tracing con header de correlación `X-Trace-ID`. | Panel de Grafana correlacionando métricas de latencia de Gateway con trazas distribuidas y logs etiquetados por `traceId` y `ordenId`. |
| **S11** | **Integración con Cliente Frontend** | Proporcionar una experiencia fluida al usuario gamer consumiendo la API de forma segura y centralizada. | **Cliente Web SPA** consumiendo exclusivamente a través de `pc-gateway` (`:18080`), guards de autenticación por rol, almacenamiento seguro de JWT e interceptores HTTP. | Flujo de ensamble y compra en frontend: inicio de sesión, catálogo filtrado por stock, creación de orden y seguimiento en tiempo real del estado de pago. |

---

## 3. Demostración Técnica y Evidencias de Operación Real

Para la sustentación de la Unidad II, el equipo demuestra en vivo los siguientes escenarios de operación real:

### 3.1 Escenario 1: Resiliencia Síncrona ante Caída de Catálogo (S6)
1. Con `pc-catalogo-ms` detenido intencionalmente, se envía una petición de creación de orden desde `pc-orden-ms`.
2. El Circuit Breaker de Resilience4j intercepta el fallo de conexión.
3. Se activa el método fallback sin retener conexiones a la base de datos ni provocar caídas en cascada.
4. El circuito abre su estado (`OPEN`) y protege el ecosistema ante saturación de peticiones.

### 3.2 Escenario 2: Matriz de Control de Acceso Distribuido (S7)
1. **Acceso Anónimo:** Intento de consulta de órdenes sin cabecera `Authorization` $\rightarrow$ Respuesta `401 Unauthorized` desde el Gateway.
2. **Acceso Denegado por Rol:** Cliente con rol `CLIENTE` intenta modificar el precio de una tarjeta RTX 4090 en `/api/v1/productos/1` $\rightarrow$ Respuesta `403 Forbidden`.
3. **Defensa en Profundidad:** El cliente crea una orden indicando en el cuerpo JSON `"clienteId": 999`. `pc-orden-ms` descarta dicho valor y asocia la compra al ID autenticado en el token JWT verificado por JWKS.

### 3.3 Escenario 3: Desacople Temporal y Consumer Lag en Kafka (S8)
1. Se detiene el microservicio `pc-pago-ms`.
2. Se emite una orden de compra desde el Gateway.
3. `pc-orden-ms` persiste la orden en PostgreSQL (`PENDIENTE`) y entrega `201 Created` al usuario en menos de 100 ms.
4. En **Kafka UI** ([http://localhost:18085](http://localhost:18085)), se constata que el tópico `orden-eventos` tiene un mensaje no consumido y el **Consumer Lag es 1**.
5. Se inicia `pc-pago-ms`. Al arrancar, el consumidor lee el mensaje pendiente, persiste el cobro en `eniaclabs_pago_db`, emite `pago.validado` y `pc-orden-ms` transiciona la orden a `PAGADA`. El lag desciende a 0.

### 3.4 Escenario 4: Compensación Saga ante Pago Rechazado (S9)
1. Se registra una orden reservando la última unidad de un procesador Ryzen 9. El stock en Catálogo desciende de 1 a 0.
2. En la simulación de cobro, se fuerza un pago rechazado por pasarela (`pago.fallido`).
3. La Saga Coreografiada se activa: `pc-pago-ms` notifica el fallo; `pc-orden-ms` marca la orden como `CANCELADA` y publica la orden de restitución; `pc-catalogo-ms` restaura el stock a 1 unidad.
4. La base de datos queda consistente de manera eventual sin bloqueos pesados de recursos.

### 3.5 Escenario 5: Diagnóstico y Correlación en Observabilidad (S10)
1. Se realiza una transacción completa asignándole el encabezado de trazabilidad `X-Trace-ID: eniac-trace-demo-777`.
2. En Grafana Loki, se busca `{app=~"pc-.*"} |= "eniac-trace-demo-777"`.
3. Se evidencia la traza cronológica completa a través del Gateway, Orden, Pago y Catálogo, verificando latencias y respuestas en un solo panel unificado.

---

## 4. Rúbrica Oficial de Evaluación de la Unidad II

Conforme al sílabo oficial de la asignatura **Desarrollo de Aplicaciones Distribuidas**, la evaluación del producto de la Unidad II se rige por los siguientes criterios ponderados:

| Criterio del Sílabo / Dimensión | Peso | 3 - Logro Destacado | 2 - Logro | 1 - En Proceso | 0 - No Logrado |
|---|:---:|---|---|---|---|
| **1. Comunicación Síncrona Resiliente (S6)** | 15% | Circuit Breaker, timeout y fallback implementados con Resilience4j, evitando fallos en cascada y evidenciados con caída forzada en vivo. | Circuit Breaker funcional pero sin fallback personalizado o con métricas parciales. | Fallback implementado solo con try-catch simple sin Circuit Breaker. | No implementa resiliencia síncrona ni tolerancia a fallos. |
| **2. Seguridad Distribuida y RBAC (S7)** | 15% | JWT asimétrico (RS256/JWKS), Gateway Resource Server, control de acceso estricto por roles (`ADMIN`/`CLIENTE`) y defensa en profundidad. | JWT implementado y validado en Gateway pero sin validación en microservicios internos. | Seguridad basada en tokens simétricos simples o sin control granular de roles. | Endpoints expuestos sin autenticación ni control de acceso. |
| **3. Mensajería Asíncrona Desacoplada (S8)** | 15% | Apache Kafka KRaft con tópicos particionados por key (`ordenId`), publicación tras `afterCommit`, logs estructurados y desacople temporal probado. | Kafka funcional con publicación y consumo, pero sin garantía `afterCommit` o tópicos de 1 sola partición. | Comunicación por eventos incompleta o con pérdida de mensajes ante apagado. | No utiliza intermediario de mensajería asíncrona. |
| **4. Consistencia Distribuida y Sagas (S9)** | 15% | Patrón Saga implementado con transacciones compensatorias automáticas ante fallos, e idempotencia probada contra duplicados. | Saga implementada pero la compensación requiere intervención manual o carece de idempotencia. | Concepto de compensación documentado pero no funcional en el código. | No resuelve la consistencia distribuida entre microservicios. |
| **5. Observabilidad y Diagnóstico (S10)** | 15% | Stack completo operativo (Prometheus, Grafana, Loki, Zipkin) correlacionando métricas, logs y trazas distribuidas con `X-Trace-ID`. | Métricas y logs centralizados pero sin correlación distribuida entre microservicios. | Solo logs tradicionales en consola o endpoints de Actuator sin paneles visuales. | Sin observabilidad ni herramientas de diagnóstico centralizado. |
| **6. Integración con Cliente Frontend (S11)** | 10% | Frontend SPA integrado consumiendo la API exclusivamente vía Gateway, con gestión de sesión JWT y vistas restringidas por rol. | Frontend funcional integrado con Gateway pero con lógica de seguridad parcial en cliente. | Frontend que consume microservicios directamente saltándose el API Gateway. | No presenta cliente frontend funcional integrado. |
| **7. Sustentación Integral y Dominio Técnico** | 15% | Video pitch ejecutivo, defensa individual sólida, respuesta precisa a preguntas de arquitectura y demostración en vivo sin errores. | Sustentación adecuada con dominio técnico aceptable y fallos menores en la demo. | Explicación superficial o dependencia excesiva de un solo integrante del equipo. | No sustenta o demuestra desconocimiento de su propio código. |

### Cálculo de la Calificación Final

$$\text{Puntuación Ponderada} = \sum_{i=1}^{7} \left( \text{Peso}_i \times \text{Nivel}_i \right) \quad \text{donde } \text{Nivel}_i \in [0, 3]$$

$$\text{Nota Final sobre 20} = \left( \frac{\text{Puntuación Ponderada}}{3.00} \right) \times 20$$

---

## 5. Trazabilidad con la Malla Curricular (Competencia CE023 - Nivel 3)

El presente producto certifica que los integrantes del equipo demuestran las capacidades terminales de la Unidad II:
- **Diseño de topologías desacopladas:** Separación de dominios de persistencia (Database-per-Service) y orquestación híbrida (síncrona para consultas críticas y asíncrona para transacciones de negocio).
- **Ingeniería de fiabilidad:** Implementación de arquitecturas tolerantes a particiones de red y caídas de nodos conforme al Teorema CAP (priorizando Disponibilidad y Consistencia Eventual).
- **Seguridad en profundidad:** Cumplimiento de las mejores prácticas de OWASP para microservicios (claves efímeras, validación de firma asimétrica en el borde y no repudio de identidad).
