# 🎮 ENIAC Labs - Documentación Oficial del Ecosistema Distribuido

Bienvenido a la documentación técnica de **ENIAC Labs**, plataforma de comercio electrónico distribuido orientada a producción para el ensamblaje inteligente ("PC Builder"), cotización y venta de computadoras gamer de alto rendimiento, periféricos y piezas de hardware.

*Desarrollado como Proyecto Sello de la asignatura de **Sistemas Distribuidos** en la **Universidad Peruana Unión (UPeU)**.*

---

## 👥 Integrantes y Asignación de Microservicios

El sistema está diseñado respetando estrictamente las directivas académicas: **un único Microservicio Transaccional** para todo el ecosistema y **tres Microservicios No Transaccionales** distribuidos equitativamente (2 microservicios por integrante):

| Integrante | Rol en el Proyecto | Microservicio 1 | Microservicio 2 |
|---|---|---|---|
| **Eliceo Parillo Mostajo** | Arquitectura backend, persistencia transaccional y catálogo gamer | **`pc-orden-ms`** (:8083)<br>⭐ **ÚNICO TRANSACCIONAL**<br>*(Cabecera-Detalle, IGV 18% peruano, PostgreSQL :5433)* | **`pc-catalogo-ms`** (:8081)<br>*(No Transaccional)*<br>*(Catálogo Gamer, Stock en tiempo real, PostgreSQL :15432)* |
| **Laura Vargas Cristhian Paul** | Motor comercial PC Builder, pasarela externa y observabilidad | **`pc-cotizacion-ms`** (:8089)<br>🚀 **MOTOR QUE VENDE EL SISTEMA**<br>*(PC Builder, Compatibilidad y Proformas de 7 días, PostgreSQL :5436)* | **`pc-pago-ms`** (:8085)<br>*(No Transaccional / Integración Externa)*<br>*(Pasarela Mercado Pago Sandbox y Webhooks, PostgreSQL :5434)* |

---

## 🏛️ Modelo Arquitectónico Completo

```mermaid
flowchart TB
    classDef clientStyle fill:#0284c7,stroke:#0369a1,stroke-width:2px,color:#ffffff,font-weight:bold;
    classDef gatewayStyle fill:#6366f1,stroke:#4338ca,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef infraStyle fill:#334155,stroke:#1e293b,stroke-width:2px,color:#ffffff,font-weight:bold;
    classDef eurekaStyle fill:#d97706,stroke:#b45309,stroke-width:2px,color:#ffffff,font-weight:bold;
    classDef transStyle fill:#e11d48,stroke:#9f1239,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef commercialStyle fill:#059669,stroke:#047857,stroke-width:3px,color:#ffffff,font-weight:bold;
    classDef catalogStyle fill:#2563eb,stroke:#1d4ed8,stroke-width:2px,color:#ffffff,font-weight:bold;
    classDef paymentStyle fill:#7c3aed,stroke:#6d28d9,stroke-width:2px,color:#ffffff,font-weight:bold;
    classDef dbStyle fill:#0f172a,stroke:#38bdf8,stroke-width:2px,color:#38bdf8,font-weight:bold;
    classDef obsStyle fill:#ea580c,stroke:#c2410c,stroke-width:2px,color:#ffffff,font-weight:bold;
    classDef externalStyle fill:#0891b2,stroke:#0e7490,stroke-width:2px,color:#ffffff,font-weight:bold;

    subgraph CLIENT_LAYER ["🌐 Capa de Clientes"]
        CLIENT["💻 Cliente Web / PC Builder UI / Postman"]:::clientStyle
    end

    subgraph GATEWAY_LAYER ["🛡️ Capa Perimetral (:18080)"]
        GATEWAY["🚪 PC-GATEWAY\n(Spring Cloud Gateway Server WebMVC)\nFiltros Perimetrales & Balanceador lb://"]:::gatewayStyle
    end

    subgraph INFRA_LAYER ["⚙️ Servidores Spring Cloud"]
        direction LR
        CONFIG["📁 PC-CONFIG (:18888)\nConfiguración Centralizada Native"]:::infraStyle
        EUREKA["🔍 PC-EUREKA (:18761)\nEureka Service Registry"]:::eurekaStyle
    end

    subgraph BUSINESS_LAYER ["🚀 Microservicios de Negocio"]
        subgraph ELICEO_GROUP ["👤 Eliceo Parillo Mostajo"]
            ORDEN_MS["⭐ PC-ORDEN-MS (:8083)\n⚡ ÚNICO TRANSACCIONAL\n• IGV 18% & Cabecera-Detalle"]:::transStyle
            CATALOGO_MS["📦 PC-CATALOGO-MS (:8081)\n• Catálogo Gamer & Stock"]:::catalogStyle
        end

        subgraph LAURA_GROUP ["👤 Laura Vargas Cristhian Paul"]
            COTIZACION_MS["🚀 PC-COTIZACION-MS (:8089)\n🔥 MOTOR COMERCIAL\n• PC Builder & Proformas 7 días"]:::commercialStyle
            PAGO_MS["💳 PC-PAGO-MS (:8085)\n• Pasarela Mercado Pago"]:::paymentStyle
        end
    end

    subgraph DATA_LAYER ["🗄️ Persistencia Aislada (PostgreSQL 16 + Flyway)"]
        direction LR
        DB_CATALOGO[("🛢️ DB Catálogo\n:15432")]:::dbStyle
        DB_ORDEN[("🛢️ DB Orden\n:5433")]:::dbStyle
        DB_COTIZACION[("🛢️ DB Cotización\n:5436")]:::dbStyle
        DB_PAGO[("🛢️ DB Pago\n:5434")]:::dbStyle
    end

    subgraph OBS_LAYER ["📊 Observabilidad y Monitoreo"]
        direction LR
        PROMETHEUS["🔥 Prometheus (:9090)"]:::obsStyle
        GRAFANA["📈 Grafana (:3000)"]:::obsStyle
        LOKI["📑 Loki (:3100)"]:::obsStyle
    end

    CLIENT ==>|HTTP REST :18080| GATEWAY
    GATEWAY -.-> EUREKA
    GATEWAY -->|lb://| COTIZACION_MS
    GATEWAY -->|lb://| CATALOGO_MS
    GATEWAY -->|lb://| ORDEN_MS
    GATEWAY -->|lb://| PAGO_MS

    CONFIG -.-> EUREKA & GATEWAY & CATALOGO_MS & ORDEN_MS & COTIZACION_MS & PAGO_MS

    COTIZACION_MS -->|Valida Stock| CATALOGO_MS
    COTIZACION_MS ==>|Convierte en Orden| ORDEN_MS
    PAGO_MS -->|Sincroniza Estado| ORDEN_MS

    CATALOGO_MS --- DB_CATALOGO
    ORDEN_MS --- DB_ORDEN
    COTIZACION_MS --- DB_COTIZACION
    PAGO_MS --- DB_PAGO

    BUSINESS_LAYER -.->|Micrometer /metrics| PROMETHEUS
    GATEWAY -.->|Micrometer /metrics| PROMETHEUS
    PROMETHEUS ==> GRAFANA
    LOKI ==> GRAFANA
```

---

## 🧭 Guías y Sesiones de la Unidad 1

* [Brief del Proyecto Sello](proyecto-sello/brief.md)
* [Producto de la Unidad 1: Sistema Distribuido Base](proyecto-sello/u1-producto.md)
* [Sesión 01: Construcción del Servicio Base con Spring Boot y PostgreSQL](sesiones/S01_Construccion_Servicio_Base.md)
* [Sesión 02: Configuración Centralizada y Gestión de Ambientes (Config Server)](sesiones/S02_Configuracion_Centralizada_Ambientes.md)
* [Sesión 03: Registro, Descubrimiento Dinámico y Concurrencia (Eureka)](sesiones/S03_Registro_Descubrimiento_Ejecucion_Concurrente.md)
* [Sesión 04: Punto Único de Acceso y Distribución de Tráfico (API Gateway)](sesiones/S04_Punto_Unico_Acceso_Distribucion_Trafico.md)
* [Sesión 05: Evaluación y Checklist de Sustentación](sesiones/S05_Evaluacion_Unidad_1.md)
* [Sesión 06: Monitoreo y Observabilidad Completa con Prometheus, Grafana, Loki y Node Exporter](sesiones/S06_Monitoreo_Prometheus_Grafana_Loki.md)
