# Tarea 1: Feign y Circuit Breaker (S06)

> **Unidad 2:** Sistema distribuido robusto  
> **Sesión 1:** Comunicación sincrónica resiliente  
> **Criterio de Evaluación:** Patrón de consistencia distribuida implementado y documentado (100% Competencia de Especialidad)  
> **Documento Oficial PDF:** [Descargar Tarea1_Feign_CircuitBreaker.pdf](Tarea1_Feign_CircuitBreaker.pdf)  
> **Versión Web Interactiva:** [Ver Tarea1_Feign_CircuitBreaker.html](Tarea1_Feign_CircuitBreaker.html)

---

## 1. Arquitectura y Código Fuente en GitHub

| Componente | Archivo en GitHub | Función |
| :--- | :--- | :--- |
| **Cliente Feign** | [`CatalogoFeignClient.java`](https://github.com/jaisesasaki24-cloud/ENIAC-Labs2/blob/main/pc-orden-ms/src/main/java/pe/edu/upeu/eniaclabs/orden/client/CatalogoFeignClient.java) | Consulta síncrona declarativa `lb://pc-catalogo-ms` |
| **Circuit Breaker** | [`ProductoConsultaService.java`](https://github.com/jaisesasaki24-cloud/ENIAC-Labs2/blob/main/pc-orden-ms/src/main/java/pe/edu/upeu/eniaclabs/orden/service/ProductoConsultaService.java) | Anotado con `@CircuitBreaker` y método fallback |
| **Lógica de Negocio** | [`OrdenServiceImpl.java`](https://github.com/jaisesasaki24-cloud/ENIAC-Labs2/blob/main/pc-orden-ms/src/main/java/pe/edu/upeu/eniaclabs/orden/service/impl/OrdenServiceImpl.java) | Persistencia de orden con IGV 18% y precios inmutables |

---

## 2. Evidencias de Ejecución

### Evidencia 1: Consulta Feign Exitosa y Creación de Orden (201 Created)
- **Petición:** `POST http://localhost:18080/api/v1/ordenes`
- **Resultado:** Cálculo de IGV (18%) y snapshot de precios de catálogo obtenido vía Feign sin intervención manual de precios.

### Evidencia 2: Fallback Resiliente ante Caída de Catálogo (503 Service Unavailable)
- **Simulación:** `pc-catalogo-ms` apagado o saturado.
- **Resultado:** `pc-orden-ms` intercepta la falla en su método fallback controlado, impidiendo errores 500 y protegiendo el pool de hilos Tomcat (*Cascading Failure Prevention*).

### Evidencia 3: Transición del Circuito a Estado OPEN
- **Endpoint:** `GET http://localhost:8083/actuator/health`
- **Resultado:** Estado `catalogoCB: OPEN`, tasa de fallos registrada en 100% y activación del modo Fail-Fast a 0ms.
