# 🏛️ Documentación de Arquitectura con el Modelo C4

Bienvenido a la documentación arquitectónica oficial de **ENIAC Labs PC Gamer E-Commerce**, estructurada siguiendo el estándar internacional **Modelo C4** (creado por Simon Brown).

El modelo C4 proporciona cuatro niveles jerárquicos de abstracción ("zoom") para comunicar la arquitectura tanto a nivel de negocio como a nivel técnico y de implementación.

---

## 🗺️ Los 4 Niveles de Abstracción del Modelo C4

```
                                      ┌────────────────────────────────────────┐
  Nivel 1: Contexto del Sistema       │               [Personas]               │
  (System Context)                    │                   │                    │
  ¿Quién usa el sistema y qué         │                   ▼                    │
  sistemas externos lo rodean?        │   ┌────────────────────────────────┐   │
                                      │   │    ENIAC Labs E-Commerce       │   │
                                      │   └────────────────────────────────┘   │
                                      └───────────────────┬────────────────────┘
                                                          │ zoom
                                                          ▼
                                      ┌────────────────────────────────────────┐
  Nivel 2: Contenedores               │        [Single Page App Angular]       │
  (Containers)                        │                   │                    │
  ¿Cuáles son las aplicaciones,       │                   ▼                    │
  microservicios, brokers y BDs?      │ [API Gateway] ───► [Microservicios]    │
                                      │                        │               │
                                      │                        ▼               │
                                      │                [Kafka / PostgreSQL]    │
                                      └───────────────────┬────────────────────┘
                                                          │ zoom
                                                          ▼
                                      ┌────────────────────────────────────────┐
  Nivel 3: Componentes                │ [pc-orden-ms]                          │
  (Components)                        │   ├─ OrdenCompraController             │
  ¿Cómo se estructuran los            │   ├─ OrdenServiceImpl (@Transactional) │
  controladores, servicios y clientes?│   ├─ ProductoClient (Feign + CB)       │
                                      │   └─ OrdenEventProducer (Kafka)        │
                                      └───────────────────┬────────────────────┘
                                                          │ zoom
                                                          ▼
                                      ┌────────────────────────────────────────┐
  Nivel 4: Código y Clases            │  OrdenCompra (1) ──* OrdenCompraDetalle│
  (Code / Classes)                    │                        │ (M:N)         │
  Entidades, DTOs, cálculos contables │                        ▼               │
  y métodos de persistencia.          │                 ProductoHardware       │
                                      └────────────────────────────────────────┘
```

---

## 📚 Secciones de la Documentación C4

1. [**Nivel 1 - Contexto del Sistema**](nivel1-contexto.md):
   - Visión perimetral del sistema.
   - Actores: Cliente Gamer, Administrador / Auditor, Docente / Evaluador UPeU.
   - Sistemas Externos: Keycloak IAM, Mercado Pago Sandbox, SUNAT.

2. [**Nivel 2 - Contenedores**](nivel2-contenedores.md):
   - Mapa de despliegue y topología de red.
   - Frontend SPA Angular 22 (`:4200`), API Gateway (`:18080`), Microservicio Transaccional `pc-orden-ms` (`:8083`), Microservicio No Transaccional `pc-catalogo-ms` (`:8081`).
   - Broker Apache Kafka (`:9092`), Caché Redis (`:6379`), 5 Bases de Datos PostgreSQL independientes y Stack de Observabilidad (Prometheus + Grafana + Loki).

3. [**Nivel 3 - Componentes**](nivel3-componentes.md):
   - Zoom interno en los microservicios principales.
   - Controladores REST, Servicios Spring con `@Transactional`, clientes Feign con Circuit Breakers Resilience4j y productores/consumidores Kafka.

4. [**Nivel 4 - Código y Clases**](nivel4-codigo.md):
   - Diagrama de clases y entidades JPA.
   - Relación Muchos a Muchos (Cabecera - Detalle).
   - Cálculo del **IGV (18% Perú)** y sincronización `afterCommit`.
