# Sesion 06: Monitoreo y Observabilidad Completa con Prometheus, Grafana, Loki y Node Exporter

> **Ecosistema Distribuido ENIAC Labs**  
> **Integrantes:**  
> - **Eliceo Parillo Mostajo** (Metricas de negocio, throughput transaccional y catalogo)  
> - **Laura Vargas Cristhian Paul** (Observabilidad de pasarela de pagos, latencias y logs de seguridad)  
> **Objetivo:** Implementar observabilidad de nivel empresarial en los tres pilares fundamentales: **Metricas** (Prometheus), **Visualizacion de Dashboards** (Grafana), **Logs Centralizados** (Loki) y **Metricas de Sistema** (Node / Windows Exporter).

---

## 1. Arquitectura de Observabilidad de ENIAC Labs

`
  +-------------------------------------------------------------------------------+
  |                        GRAFANA DASHBOARDS (:3000)                             |
  |    (JVM Metrics, Host Node Exporter, Throughput HTTP, Stream Logs Loki)       |
  +-----------------------+-------------------------------+-----------------------+
                          |                               |
                 (PromQL Metrics)                   (LogQL Logs)
                          |                               |
                          v                               v
               +--------------------+           +-------------------+
               | PROMETHEUS (:9090) |           |   LOKI (:3100)    |
               | (Scrape cada 5s)   |           | (Log Aggregation) |
               +---------+----------+           +---------+---------+
                         |                                |
        +----------------+----------------+               | (Logs Stream)
        |                |                |               |
        v                v                v               v
 +-------------+  +-------------+  +-------------+  +-------------+
 | API Gateway |  | pc-catalogo |  | pc-orden-ms |  | pc-pago-ms  |
 |  (:18080)   |  |   (:8081)   |  |   (:8083)   |  |   (:8085)   |
 +-------------+  +-------------+  +-------------+  +-------------+
        |                |                |               |
        +----------------+----------------+---------------+
                                 |
                 /actuator/prometheus (Micrometer)
`

---

## 2. Componentes del Stack Implementado

### 2.1 Prometheus Server (:9090)
- **Rol:** Servidor de base de datos de series temporales (TSDB).
- **Mecanismo:** Modelo Pull (scraping periodico cada 5 segundos).
- **Targets Monitoreados:**
  - pc-gateway (/actuator/prometheus)
  - pc-catalogo-ms (/actuator/prometheus)
  - pc-orden-ms (/actuator/prometheus)
  - pc-pago-ms (/actuator/prometheus)
  - pc-auth-ms (/actuator/prometheus)
  - 
ode-exporter (/metrics)
  - prometheus (/metrics)
- **Configuracion:** infra/monitoring/prometheus/prometheus.yml

### 2.2 Grafana (:3000)
- **Rol:** Centro de comando y visualizacion en tiempo real.
- **Credenciales por defecto:** Usuario dmin, Contrasena dmin.
- **Aprovisionamiento Automatico:**
  - Data Sources: **Prometheus** (default) y **Loki**.
  - Dashboards precargados:
    1. **ENIAC Labs - Microservicios & Metricas JVM:** Memoria Heap/Non-Heap, Garbage Collection, Hilos en vivo, Tasa de peticiones por segundo, Latencia percentil p95 y conexiones HikariCP.
    2. **ENIAC Labs - Infraestructura & Node Exporter:** CPU del sistema, RAM disponible, Trafico de Red RX/TX y E/S de disco.
    3. **ENIAC Labs - Logs Centralizados con Loki:** Grafico de volumen de eventos y visor de stream de logs con filtros por microservicio y nivel (INFO, WARN, ERROR).

### 2.3 Grafana Loki (:3100)
- **Rol:** Motor de indexacion y almacenamiento de logs distribuidos, optimizado para metadatos (etiquetas job, service, level).
- **Endpoint de Ingesta:** POST /loki/api/v1/push
- **Consultas:** Compatibilidad total con LogQL desde el explorador de Grafana.

### 2.4 Node Exporter / Windows Exporter (:9100)
- **Rol:** Recoleccion de telemetria de hardware, sistema operativo, sockets de red y almacenamiento en disco.

---

## 3. Consultas PromQL Esenciales para Sustentacion

| Metrica Monitoreada | Expresion PromQL | Proposito en el Ecosistema |
|---|---|---|
| **Disponibilidad de Microservicios** | up{job=~'pc-.*'} | Alerta instantanea si un microservicio cae |
| **Consumo de Memoria Heap** | jvm_memory_used_bytes{area='heap'} | Deteccion de memory leaks en Spring Boot |
| **Throughput de Solicitudes (req/s)** | sum(rate(http_server_requests_seconds_count[1m])) by (application) | Medir la carga distribuida por cada microservicio |
| **Latencia Percentil 95** | histogram_quantile(0.95, sum(rate(http_server_requests_seconds_bucket[1m])) by (le, application)) | Asegurar SLAs en cotizaciones y pagos |
| **Conexiones Activas a BD** | hikaricp_connections_active | Monitoreo del pool de conexiones PostgreSQL/H2 |

---

## 4. Consultas LogQL en Loki

`logql
# Ver todos los logs del ecosistema en vivo
{job="eniaclabs-microservices"}

# Filtrar solo errores o advertencias de la pasarela de pagos
{service="pc-pago-ms"} |= "ERROR"

# Calcular la tasa de errores por minuto
sum by (service) (rate({job="eniaclabs-microservices"} |= "ERROR" [1m]))
`

---

## 5. Enlaces de Acceso Inmediato

- **Grafana Dashboard:** [http://localhost:3000](http://localhost:3000) *(Usuario: dmin / Password: dmin)*
- **Prometheus UI:** [http://localhost:9090](http://localhost:9090)
- **Prometheus Targets Status:** [http://localhost:9090/targets](http://localhost:9090/targets)
- **Loki Readiness:** [http://localhost:3100/ready](http://localhost:3100/ready)
- **Node Exporter Metrics:** [http://localhost:9100/metrics](http://localhost:9100/metrics)