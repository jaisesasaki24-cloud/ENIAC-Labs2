# Tarea 2: Autenticación JWT y Control de Acceso (S07)

> **Unidad 2:** Sistema distribuido robusto  
> **Sesión 2:** Seguridad distribuida y control de acceso  
> **Criterio de Evaluación:** Autenticación JWT implementada correctamente (100% Competencia de Especialidad)  
> **Documento Oficial PDF:** [Descargar Tarea2_Seguridad_JWT.pdf](Tarea2_Seguridad_JWT.pdf)  
> **Versión Web Interactiva:** [Ver Tarea2_Seguridad_JWT.html](Tarea2_Seguridad_JWT.html)

---

## 1. Arquitectura y Código Fuente en GitHub

| Componente | Archivo en GitHub | Función |
| :--- | :--- | :--- |
| **Controlador de Autenticación** | [`AuthController.java`](https://github.com/jaisesasaki24-cloud/ENIAC-Labs2/blob/main/pc-auth-ms/src/main/java/pe/edu/upeu/eniaclabs/auth/controller/AuthController.java) | Login, Registro y validación |
| **Generador JWT (RS256)** | [`JwtTokenProvider.java`](https://github.com/jaisesasaki24-cloud/ENIAC-Labs2/blob/main/pc-auth-ms/src/main/java/pe/edu/upeu/eniaclabs/auth/security/JwtTokenProvider.java) | Firma asimétrica con clave privada y claims OIDC |
| **Filtro Seguridad Gateway** | [`JwtAuthenticationFilter.java`](https://github.com/jaisesasaki24-cloud/ENIAC-Labs2/blob/main/infra/pc-gateway/src/main/java/pe/edu/upeu/eniaclabs/gateway/security/JwtAuthenticationFilter.java) | Validación perimetral contra JWKS y filtro RBAC |
| **Extracción Claims Orden** | [`OrdenServiceImpl.java`](https://github.com/jaisesasaki24-cloud/ENIAC-Labs2/blob/main/pc-orden-ms/src/main/java/pe/edu/upeu/eniaclabs/orden/service/impl/OrdenServiceImpl.java) | Inyección de identidad del cliente desde JWT |

---

## 2. Evidencias de Ejecución

### Evidencia 1: Petición sin Token Rechazada (401 Unauthorized)
- **Endpoint:** `GET http://localhost:18080/api/v1/ordenes`
- **Resultado:** Bloqueo perimetral en API Gateway sin exponer servicios downstream.

### Evidencia 2: Login y Emisión de Token JWT RS256 (200 OK)
- **Endpoint:** `POST http://localhost:18080/api/v1/auth/login`
- **Resultado:** Retorno de Bearer token con algoritmo RS256, roles `ROLE_CLIENTE` y TTL de 2 horas.

### Evidencia 3: Petición Autorizada con Extracción de Claims (201 Created)
- **Endpoint:** `POST http://localhost:18080/api/v1/ordenes`
- **Resultado:** Orden registrada con `clienteId: 1` obtenido del token verificado sin aceptar suplantación en el payload JSON.

### Evidencia 4: Control de Acceso por Roles RBAC (403 Forbidden)
- **Endpoint:** `POST http://localhost:18080/api/v1/categorias`
- **Resultado:** Acceso denegado con 403 Forbidden por falta de permisos administrativos (`ROLE_ADMIN`).
