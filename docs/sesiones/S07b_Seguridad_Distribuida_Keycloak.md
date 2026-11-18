# S07b - Reemplazo de pc-auth-ms por Keycloak (Guía de Referencia Práctica)

**Proyecto:** ENIAC Labs - Ecosistema de Microservicios para Hardware Gamer de Alto Rendimiento  
**Autores:** Eliceo Parillo Mostajo & Laura Vargas Cristhian Paul  
**Basado en la Guía de Referencia:** Angel Sullon Macalupu (@asullom) - 2026  

---

## 0. Qué es esta guía y qué no es

Esta guía técnica documenta la transición arquitectónica desde nuestro servidor de autorización temporal **`pc-auth-ms`** (construido en la sesión evaluada [S07_Seguridad_Distribuida_Control_Acceso.md](S07_Seguridad_Distribuida_Control_Acceso.md)) hacia **Keycloak 26.8.0**, el Identity & Access Management (IAM) estándar empresarial de la industria.

```
+-----------------------------------------------------------------------------------------+
|                                    ESTADO S07 (Evaluado)                                |
|  Cliente (cURL / Postman)                                                               |
|         │                                                                               |
|         ▼                                                                               |
|    pc-auth-ms (:8087) ── emite JWT ──► pc-gateway (:18080) / pc-orden-ms (:8083)        |
|    (Firma asimétrica RSA)              (jwk-set-uri: http://localhost:8087/...)         |
+-----------------------------------------------------------------------------------------+
                                             │
                                     TRANSICIÓN S07b
                                             ▼
+-----------------------------------------------------------------------------------------+
|                                   ESTADO S07b / S11 (Objetivo)                          |
|  Cliente Frontend Angular (S11)                                                         |
|  (PKCE Flow en :4200)                                                                   |
|         │                                                                               |
|         ▼                                                                               |
|    Keycloak (:18180)  ── emite JWT ──► pc-gateway (:18080) / microservicios             |
|    (Realm: eniaclabs)                  (issuer-uri: http://localhost:18180/...)         |
+-----------------------------------------------------------------------------------------+
```

### Contexto y Prerrequisito para S11
* **Continuación directa de S07:** En S07 se diseñó `pc-auth-ms` deliberadamente desacoplado mediante estándares OAuth2 / OIDC con endpoints JWKS (`/.well-known/jwks.json`), garantizando que la migración a Keycloak se redujera a cambiar propiedades de configuración sin reescribir la lógica de autorización.
* **Prerrequisito de S11:** La sesión S11 integrará el cliente frontend en Angular 22 utilizando el flujo **OAuth2 Authorization Code con PKCE (Proof Key for Code Exchange)** contra Keycloak.
* **Divergencia fundamental respecto a S07:** En S07, `clienteId` era un dato de negocio numérico (`Long`) emitido como claim adicional. En Keycloak, el identificador único canónico es el claim estándar **`sub` (Subject)**, generado como un **UUID v4 (String de 36 caracteres)**. Por ende, en ENIAC Labs migramos la columna `cliente_id` de `BIGINT` a `VARCHAR(36)` y adaptamos los DTOs y eventos de mensajería asíncrona.

---

## 1. Qué cambia y qué no cambia

### Tabla Comparativa de Arquitectura de Seguridad

| Componente / Aspecto | En S07 (`pc-auth-ms`) | En S07b (Keycloak) | Impacto en el Código |
| :--- | :--- | :--- | :--- |
| **Servidor de Identidad** | `pc-auth-ms` (Spring Boot + Nimbus JOSE) | **Keycloak 26.8.0** en contenedor Docker | Se levanta `keycloak/compose-dev.yml` y se apaga `pc-auth-ms`. |
| **Descubrimiento de Claves** | `jwk-set-uri: http://localhost:8087/.well-known/jwks.json` | **`issuer-uri: http://localhost:18180/realms/eniaclabs`** | **Solo propiedad YAML** en Config Server (`pc-gateway-dev.yml`, etc.). |
| **Mapeo de Roles RBAC** | `realm_access.roles` (`ROLE_CLIENTE`, `ROLE_ADMIN`) | `realm_access.roles` (`CLIENTE`, `ADMIN`) | **Cero cambios** en `KeycloakJwtAuthenticationConverter`. |
| **Reglas de Acceso en Gateway** | `hasRole("ADMIN")` para catálogo, `hasAnyRole` para órdenes | Mismas reglas y rutas protegidas | **Cero cambios** en `SecurityConfig` del Gateway. |
| **Identificador de Cliente** | Claim manual `userId` / `clienteId` (`Long`) | Claim estándar **`sub`** (`UUID String`) | **Migración JPA y Flyway** en `pc-orden-ms` y `pc-pago-ms`. |
| **Columna de Base de Datos** | `cliente_id BIGINT` en `ordenes_compra` | **`cliente_id VARCHAR(36)`** en `ordenes_compra` | Migración Flyway `V3__alter_cliente_id_varchar.sql`. |

---

## PARTE A: Configuración de Keycloak (Aislado)

Las secciones 2 a 6 levantan y prueban Keycloak de manera autónoma sin tocar el código fuente del Gateway ni de los microservicios.

### 2. Levantar Keycloak 26.8.0 con Docker Compose

El servicio se despliega mediante [`keycloak/compose-dev.yml`](file:///c:/Users/USUARIO/Pictures/finalmicro/2/keycloak/compose-dev.yml) siguiendo la convención de puertos del proyecto:
* **`18180`**: Tráfico HTTP de autenticación (prefijo 1 = entorno DEV).
* **`15436`**: Puerto de PostgreSQL para la base de datos `eniaclabs_keycloak`.
* **`19000`**: Puerto de gestión aislado para métricas Prometheus (`/metrics`) y salud (`/health`).

```yaml
# keycloak/compose-dev.yml
name: eniaclabs-keycloak-dev

services:
  keycloak-db:
    image: postgres:17-alpine
    container_name: eniaclabs-keycloak-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: eniaclabs_keycloak
      POSTGRES_USER: eniaclabs_keycloak
      POSTGRES_PASSWORD: eniaclabs
    ports:
      - "15436:5432"
    volumes:
      - eniaclabs_keycloak_db_dev_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U eniaclabs_keycloak -d eniaclabs_keycloak"]
      interval: 10s
      timeout: 5s
      retries: 10
      start_period: 15s

  keycloak:
    image: quay.io/keycloak/keycloak:26.8.0
    container_name: eniaclabs-keycloak
    restart: unless-stopped
    command: start-dev
    environment:
      KC_BOOTSTRAP_ADMIN_USERNAME: admin
      KC_BOOTSTRAP_ADMIN_PASSWORD: admin123
      KC_DB: postgres
      KC_DB_URL: jdbc:postgresql://keycloak-db:5432/eniaclabs_keycloak
      KC_DB_USERNAME: eniaclabs_keycloak
      KC_DB_PASSWORD: eniaclabs
      KC_METRICS_ENABLED: "true"
      KC_HEALTH_ENABLED: "true"
      KC_LOG: console,file
      KC_LOG_FILE: /opt/keycloak/data/log/keycloak.log
      KC_HTTP_MANAGEMENT_PORT: 9000
    ports:
      - "18180:8080"
      - "19000:9000"
    volumes:
      - eniaclabs_keycloak_dev_data:/opt/keycloak/data
      - ./logs:/opt/keycloak/data/log
    depends_on:
      keycloak-db:
        condition: service_healthy

volumes:
  eniaclabs_keycloak_db_dev_data:
  eniaclabs_keycloak_dev_data:
```

Para iniciar el contenedor:
```powershell
cd keycloak
docker compose -f compose-dev.yml up -d
```
Verificar en la consola web: [http://localhost:18180](http://localhost:18180) con credenciales `admin` / `admin123`.

---

### 3. Configurar el Realm `eniaclabs` y Roles

1. En la consola de Keycloak: **Manage realms** ➔ **Create realm** ➔ **Realm name:** `eniaclabs` ➔ **Create**.
2. Seleccionar el realm `eniaclabs`.
3. Navegar a **Realm roles** ➔ **Create role**:
   * Crear rol `CLIENTE` (para compradores de PCs gamer y periféricos).
   * Crear rol `ADMIN` (para administradores de inventario de hardware).
4. *Nota técnica:* Al crearlos como Realm Roles, Keycloak los inyecta en el claim `realm_access.roles`, que coincide exactamente con la configuración de Spring Security en `pc-catalogo-ms` y `pc-gateway`.

---

### 4. Crear el Cliente OIDC `eniaclabs-frontend`

1. Ir a **Clients** ➔ **Create client**:
   * **Client type:** `OpenID Connect`
   * **Client ID:** `eniaclabs-frontend`
2. **Capability config:**
   * **Client authentication:** `Off` (Cliente público SPA, no puede custodiar secretos).
   * **Authorization:** `Off`.
   * **Authentication flow:** Marcar `Standard flow` (Authorization Code). Desmarcar `Direct access grants`.
   * **Proof Key for Code Exchange (PKCE):** Seleccionar `S256` (obligatorio para evitar intercepción de códigos de autorización).
3. **Login settings:**
   * **Root URL:** `http://localhost:4200`
   * **Valid redirect URIs:** `http://localhost:4200/*`
   * **Valid post logout redirect URIs:** `http://localhost:4200/*`
   * **Web origins:** `http://localhost:4200`
4. Clic en **Save**.

---

### 5. Crear los Usuarios Semilla

Ir a **Users** ➔ **Add user**:

1. **Usuario Cliente:**
   * **Username:** `cliente1`
   * **Email:** `cliente1@eniaclabs.com`
   * **Email verified:** `Yes`
   * **Credentials:** `cliente123` (Temporary: `Off`).
   * **Role mapping:** Asignar rol `CLIENTE`.

2. **Usuario Administrador:**
   * **Username:** `admin`
   * **Email:** `admin@eniaclabs.com`
   * **Email verified:** `Yes`
   * **Credentials:** `admin123` (Temporary: `Off`).
   * **Role mapping:** Asignar rol `ADMIN`.

---

### 6. Verificación de Token Real con PKCE en PowerShell

Ejecutar la siguiente rutina en PowerShell para generar el desafío criptográfico PKCE:

```powershell
# 1. Función para calcular code_challenge SHA-256 base64url
function Get-Pkce([string]$verifier) {
    $hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash([System.Text.Encoding]::ASCII.GetBytes($verifier))
    [Convert]::ToBase64String($hash).TrimEnd('=').Replace('+','-').Replace('/','_')
}

# 2. Generar entropía aleatoria de 48 bytes
$bytes = New-Object byte[] 48
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
$codeVerifier = [Convert]::ToBase64String($bytes).TrimEnd('=').Replace('+','-').Replace('/','_')
$codeChallenge = Get-Pkce $codeVerifier

Write-Host "code_verifier: $codeVerifier" -ForegroundColor Cyan
Write-Host "code_challenge: $codeChallenge" -ForegroundColor Yellow

# 3. Construir URL de autorización para el navegador
$authUrl = "http://localhost:18180/realms/eniaclabs/protocol/openid-connect/auth?client_id=eniaclabs-frontend&response_type=code&redirect_uri=http://localhost:4200/auth/callback&scope=openid+profile&code_challenge=$codeChallenge&code_challenge_method=S256"
Write-Host "`nAbre la siguiente URL en tu navegador e inicia sesion:`n$authUrl" -ForegroundColor Green
```

1. Pega la URL en el navegador e ingresa con `cliente1@eniaclabs.com` / `cliente123`.
2. El navegador redirigirá a `http://localhost:4200/auth/callback?code=...`.
3. Copia el parámetro `code` de la barra de direcciones y canjéalo por el JWT:

```powershell
$code = "<PEGA_AQUI_EL_CODE_COPIADO>"

$body = @{
    grant_type    = "authorization_code"
    client_id     = "eniaclabs-frontend"
    redirect_uri  = "http://localhost:4200/auth/callback"
    code          = $code
    code_verifier = $codeVerifier
}

$tokenResponse = Invoke-RestMethod -Method Post -Uri "http://localhost:18180/realms/eniaclabs/protocol/openid-connect/token" -Body $body
$tokenCliente = $tokenResponse.access_token
Write-Host "Token JWT Cliente obtenido:`n$tokenCliente" -ForegroundColor Green
```

Inspeccionando el token en [jwt.io](https://jwt.io/):
* `sub`: `"d6b2c89f-8e54-4a2b-b6d3-2e4b4765a089"` (UUID v4 estándar).
* `iss`: `"http://localhost:18180/realms/eniaclabs"`
* `realm_access.roles`: `["CLIENTE", "default-roles-eniaclabs"]`

Repetir el procedimiento para el usuario `admin` y almacenar `$tokenAdmin`.

---

## PARTE B: Integración del Gateway y Microservicios

### 7.1 Cambiar la Propiedad de Validación en Config Server

En el repositorio centralizado de configuraciones (`infra/pc-config/config-repo/`), actualizamos la resolución de tokens para validar contra el issuer de Keycloak:

#### `pc-gateway-dev.yml` / `pc-orden-ms-dev.yml`
```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: http://localhost:18180/realms/eniaclabs
          # Anterior (pc-auth-ms):
          # jwk-set-uri: http://localhost:8087/.well-known/jwks.json
```

#### `pc-gateway-prod.yml` / `pc-orden-ms-prod.yml` (Entorno Docker)
```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          issuer-uri: http://eniaclabs-keycloak:8080/realms/eniaclabs
```

Con `issuer-uri`, Spring Boot auto-descubre dinámicamente las claves públicas mediante el endpoint OIDC `/.well-known/openid-configuration` y verifica estrictamente que el claim `iss` del token coincida con el servidor emisor.

---

### 7.2 Validación de RBAC con Tokens Reales

Con el Gateway (`:18080`) y los microservicios activos, comprobamos la matriz de autorización:

#### Test 1: Crear Producto de Hardware con Rol CLIENTE (Debe fallar con 403 Forbidden)
```powershell
try {
    Invoke-RestMethod -Method Post -Uri "http://localhost:18080/api/v1/productos" `
        -Headers @{ Authorization = "Bearer $tokenCliente" } `
        -ContentType "application/json" `
        -Body '{"nombre": "NVIDIA RTX 5090 32GB", "precio": 8999.00, "stock": 5, "categoriaId": 1}'
} catch {
    Write-Host "Status Code:" $_.Exception.Response.StatusCode.value__ -ForegroundColor Red
}
# Resultado esperado: 403 Forbidden (Token valido pero carece de ROLE_ADMIN)
```

#### Test 2: Crear Producto de Hardware con Rol ADMIN (Debe responder 201 Created)
```powershell
$nuevoProd = Invoke-RestMethod -Method Post -Uri "http://localhost:18080/api/v1/productos" `
    -Headers @{ Authorization = "Bearer $tokenAdmin" } `
    -ContentType "application/json" `
    -Body '{"nombre": "Intel Core Ultra 9 285K", "precio": 2499.00, "stock": 10, "categoriaId": 1}'
Write-Host "Producto Creado ID:" $nuevoProd.id -ForegroundColor Green
# Resultado esperado: 201 Created
```

#### Test 3: Acceso a Órdenes (`/api/v1/ordenes`)
* Con `$tokenCliente` ➔ **200 OK** (Permitido para `CLIENTE` y `ADMIN`).
* Sin cabecera `Authorization` ➔ **401 Unauthorized** (Rechazado en el perímetro).

---

## PARTE C: Migración de `clienteId` a UUID (`sub`) y Retiro de `pc-auth-ms`

### 7.3 Migración Flyway en PostgreSQL (`pc-orden-ms`)

Creamos el script de migración Flyway [`pc-orden-ms/src/main/resources/db/migration/V3__alter_cliente_id_varchar.sql`](file:///c:/Users/USUARIO/Pictures/finalmicro/2/pc-orden-ms/src/main/resources/db/migration/V3__alter_cliente_id_varchar.sql):

```sql
-- Migracion S07b: Adaptar cliente_id para almacenar el claim 'sub' (UUID de 36 caracteres) de Keycloak
ALTER TABLE ordenes_compra ALTER COLUMN cliente_id TYPE VARCHAR(36) USING cliente_id::text;
```

PostgreSQL ejecuta la conversión en caliente con `USING cliente_id::text`, permitiendo que los registros históricos numéricos (ej. `'1'`) coexistan pacíficamente con los nuevos UUIDs de Keycloak (ej. `'d6b2c89f-8e54-4a2b-b6d3-2e4b4765a089'`).

---

### 7.4 Actualización de Clases Java y Eventos de Negocio

#### 1. Entidad JPA: `OrdenCompra.java`
```java
// Cambia de Long a String (UUID v4 de 36 caracteres)
@Column(name = "cliente_id", nullable = false, length = 36)
private String clienteId;
```

#### 2. DTO de Creación y Respuesta: `CrearOrdenRequestDto.java` y `OrdenResponseDto.java`
```java
private String clienteId;
```

#### 3. Controlador: `OrdenCompraController.java`
```java
@PostMapping
public ResponseEntity<OrdenResponseDto> create(
        @RequestHeader(value = "X-User-Id", required = false) String headerClienteId,
        @Valid @RequestBody CrearOrdenRequestDto request) {
    if (headerClienteId == null || headerClienteId.isBlank()) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
    return ResponseEntity.status(HttpStatus.CREATED).body(ordenService.create(request, headerClienteId));
}
```

#### 4. Evento Kafka en `pc-orden-ms` y `pc-pago-ms`: `OrdenCreadaEvento.java`
```java
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrdenCreadaEvento {
    private String tipoEvento;
    private Long ordenId;
    private String idCliente; // String para aceptar el UUID de Keycloak
    private BigDecimal total;
    private String metodoPago;
    private String origen;
    private Long timestamp;
}
```
*Importante:* Al actualizar ambas clases espejo, Kafka serializa y deserializa el JSON sin errores de deserialización numérica.

---

### 8. Retiro Ordenado de `pc-auth-ms`

Una vez verificado que Keycloak emite los tokens y que el Gateway y microservicios los validan:

```powershell
# Detener el contenedor de PostgreSQL de autenticación antigua
cd pc-auth-ms
docker compose -f compose-dev.yml down -v
```

El código de `pc-auth-ms` permanece en el repositorio como referencia académica de implementación de un Authorization Server desde cero con Nimbus JOSE y RSA, pero queda fuera de la cadena de arranque operativa.

---

### 9. Prueba End-to-End de Creación de Orden

Crear una orden de componentes gamer a través del Gateway autenticado con Keycloak:

```powershell
$ordenRequest = @{
    metodoPago = "MERCADO_PAGO"
    direccionEnvio = "Av. Javier Prado Este 4200, Lima"
    detalles = @(
        @{ productoId = 1; cantidad = 1 } # AMD Ryzen 7 7800X3D
    )
} | ConvertTo-Json -Depth 5

$nuevaOrden = Invoke-RestMethod -Method Post -Uri "http://localhost:18080/api/v1/ordenes" `
    -Headers @{ Authorization = "Bearer $tokenCliente" } `
    -ContentType "application/json" `
    -Body $ordenRequest

Write-Host "Orden Creada Exitosamente!" -ForegroundColor Green
Write-Host "Codigo Orden:" $nuevaOrden.codigoOrden
Write-Host "Cliente ID (UUID de Keycloak):" $nuevaOrden.clienteId
Write-Host "Total Calculado (con 18% IGV): S/" $nuevaOrden.total
```

**Resultado:**
* Código HTTP: **201 Created**
* `clienteId`: `"d6b2c89f-8e54-4a2b-b6d3-2e4b4765a089"` (Persistido como String en PostgreSQL).
* El evento Kafka `OrdenCreadaEvento` fluye de `pc-orden-ms` a `pc-pago-ms` sin contratiempos.

---

## 10. Aspectos para S11 (Frontend Angular)

1. **Angular 22 SPA:** Se implementará el flujo Authorization Code + PKCE mediante `@angular/oauth2-oidc` o `keycloak-js`.
2. **CORS en el Gateway:** En S11 se habilitará la configuración global de CORS en `pc-gateway` para permitir orígenes cruzados desde `http://localhost:4200`.
3. **Entorno de Producción:** Para despliegues en Kubernetes o nubes públicas, Keycloak deberá configurarse en modo `start` con certificados SSL/TLS y dominio público calificado (FQDN).
