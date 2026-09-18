# Sesion 05: Evaluacion y Checklist de Sustentacion de la Unidad 1

## 1. Criterios de Evaluacion y Rubrica S05

| Criterio Evaluado | Estado | Evidencia en ENIAC Labs |
|---|---|---|
| **Arquitectura de Microservicios** | Cumplido | 4 microservicios de negocio independientes + 3 de infraestructura (`config`, `eureka`, `gateway`). |
| **Separacion de Roles por Integrante** | Cumplido | **Eliceo Parillo**: `pc-orden-ms` (transaccional) y `pc-catalogo-ms`.<br>**Laura Vargas**: `pc-pago-ms` (transaccional) y `pc-auth-ms`. |
| **Persistencia y Migraciones** | Cumplido | PostgreSQL con esquemas aislados y migraciones versionadas Flyway (`V1`, `V2`) en cada microservicio. |
| **Calculo de Impuestos** | Cumplido | `pc-orden-ms` calcula automaticamente el 18% de IGV peruano en todas las ordenes. |
| **Integracion de Pasarela** | Cumplido | `pc-pago-ms` genera preferencias para Mercado Pago Sandbox y procesa webhooks IPN. |
| **Configuracion Centralizada** | Cumplido | `pc-config` administra 12 archivos de perfil (`dev` y `prod`) en `config-repo/`. |
| **Registro y Descubrimiento** | Cumplido | `pc-eureka` registra todos los servicios con heartbeat e identificador de instancia. |
| **Acceso Perimetral y Balanceo** | Cumplido | `pc-gateway` enruta todo el trafico a traves del puerto `18080` con balanceador `lb://`. |

## 2. Flujo Completo de Prueba para la Sustentacion

1. **Autenticacion en Gateway**:
   - `POST http://localhost:18080/api/v1/auth/login` con usuario `laura.vargas` o `eliceo.parillo`.
2. **Consulta de Catalogo**:
   - `GET http://localhost:18080/api/v1/productos`
3. **Verificacion de Stock**:
   - `POST http://localhost:18080/api/v1/productos/1/stock/verificar`
4. **Generacion de Orden con IGV 18%**:
   - `POST http://localhost:18080/api/v1/ordenes`
5. **Checkout Sandbox de Mercado Pago**:
   - `POST http://localhost:18080/api/v1/pagos/checkout`
6. **Recepcion de Webhook / Simulacion de Pago**:
   - `POST http://localhost:18080/api/v1/pagos/webhook` o `POST http://localhost:18080/api/v1/pagos/{id}/simular`