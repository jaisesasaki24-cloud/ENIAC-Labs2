# Producto de la Unidad 1: Sistema Distribuido Base Orientado a Produccion

## 1. Alcance y Directivas Cumplidas
- **4 Microservicios de Negocio (2 por alumno):**
  - **Alumno 1 (Eliceo Parillo Mostajo):**
    - pc-orden-ms (⭐ **UNICO MICROSERVICIO TRANSACCIONAL**): Relacion Cabecera-Detalle, calculo automatico de IGV 18% peruano y persistencia transaccional.
    - pc-catalogo-ms (No Transaccional): Catalogo de hardware gamer, categorias y verificacion de stock.
  - **Alumno 2 (Laura Vargas Cristhian Paul):**
    - pc-cotizacion-ms (No Transaccional): 🚀 **Motor comercial que vende el sistema** mediante armado de computadoras personalizadas ("PC Builder"), compatibilidad de sockets y generacion de proformas con vigencia de 7 dias, con boton para convertir la cotizacion en orden de compra transaccional.
    - pc-pago-ms (No Transaccional / Integracion Externa): Pasarela Mercado Pago Sandbox y Webhooks para aprobacion de cobros.
- **Seguridad Perimetral:** Desplegada en el API Gateway (pc-gateway), sin microservicio de autenticacion separado.
- **Servidores de Infraestructura:** pc-config (:18888), pc-eureka (:18761), pc-gateway (:18080).
- **Stack de Observabilidad:** Prometheus (:9090), Grafana (:3000), Loki (:3100) y Node Exporter (:9100).