# Brief del Proyecto: ENIAC Labs - Ecosistema Distribuido

## 1. Vision General
**ENIAC Labs** es una plataforma distribuida de comercio electronico especializada en hardware de computacion de alto rendimiento (gaming, workstations y piezas de ensamble para PC). El sistema resuelve la necesidad critica de cotizar configuraciones personalizadas ("PC Builder") que impulsen las ventas del negocio, verificar inventario en tiempo real, generar ordenes transaccionales con calculo de impuestos (IGV 18% peruano) y procesar pagos con pasarelas externas (Mercado Pago Sandbox).

## 2. Integrantes y Asignacion de Microservicios (2 por Alumno = 4 Microservicios)

Conforme a las directivas docentes, el ecosistema cuenta con **un unico Microservicio Transaccional** (pc-orden-ms) para todo el proyecto y **tres Microservicios No Transaccionales** de soporte comercial y de catalogo:

| Integrante | Rol en el Proyecto | Microservicio 1 | Microservicio 2 |
|---|---|---|---|
| **Eliceo Parillo Mostajo** | Arquitectura backend, ventas y catalogo | **pc-orden-ms** (:8083)<br>âi **UNICO TRANSACCIONAL**<br>*(Cabecera-Detalle, IGV 18%, PostgreSQL :5433)* | **pc-catalogo-ms** (:8081)<br>*(No Transaccional)*<br>*(Catalogo Gamer y Stock :8081)* |
| **Laura Vargas Cristhian Paul** | Motor comercial PC Builder, pasarela de pagos y observabilidad | **pc-cotizacion-ms** (:8089)<br>*(No Transaccional)*<br>ðŸš€ **MOTOR COMERCIAL QUE VENDE**<br>*(Cotizador de Ensamble y Proformas)* | **pc-pago-ms** (:8085)<br>*(No Transaccional / Integracion Externa)*<br>*(Pasarela Mercado Pago Sandbox :5434)* |

> **Nota de Seguridad Perimetral:** La seguridad se gestiona a nivel perimetral directamente en el API Gateway (pc-gateway), sin requerir un microservicio independiente de autenticacion.

## 3. Arquitectura Distribuida Base
1. **Configuracion Centralizada (pc-config - :18888 DEV / :8888 PROD)**:
   - Administra perfiles dev y prod desde infra/pc-config/config-repo/.
2. **Registro y Descubrimiento Dinamico (pc-eureka - :18761 DEV / :8761 PROD)**:
   - Permite el descubrimiento dinamico de servicios y balanceo de carga sin acoplamiento a IPs.
3. **Punto Unico de Acceso (pc-gateway - :18080 DEV / :28080 PROD)**:
   - Implementado con Spring Cloud Gateway Server WebMVC.
   - Enruta el trafico hacia los microservicios con lb://PC-CATALOGO-MS, lb://PC-ORDEN-MS, lb://PC-PAGO-MS, lb://PC-COTIZACION-MS.
4. **Bases de Datos Aisladas (Database-per-Service)**:
   - Cada microservicio posee su propia instancia o esquema PostgreSQL, garantizando autonomia de despliegue y control de migraciones con Flyway.