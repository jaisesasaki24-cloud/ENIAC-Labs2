# Sesion 02: Configuracion Centralizada y Ambientes

## 1. Objetivos de Aprendizaje
- Centralizar y versionar las propiedades del ecosistema mediante Spring Cloud Config Server.
- Separar parametros segun entornos de ejecucion (`dev` vs. `prod`).
- Configurar el cliente `spring-cloud-starter-config` en cada microservicio de negocio e infraestructura.

## 2. Arquitectura de Configuracion en ENIAC Labs

### 2.1 Servidor `pc-config`
Ubicado en `infra/pc-config`, corre en el puerto `18888` en entorno DEV y `8888` en PROD. Utiliza perfil nativo apuntando a `config-repo/`:
```yaml
spring:
  application:
    name: pc-config
  profiles:
    active: native
  cloud:
    config:
      server:
        native:
          search-locations: ${CONFIG_REPO_LOCATION:file:./config-repo}
```

### 2.2 Repositorio de Configuracion (`config-repo/`)
El directorio `infra/pc-config/config-repo/` almacena los archivos:
- `pc-eureka-dev.yml` y `pc-eureka-prod.yml`
- `pc-gateway-dev.yml` y `pc-gateway-prod.yml`
- `pc-catalogo-ms-dev.yml` y `pc-catalogo-ms-prod.yml`
- `pc-orden-ms-dev.yml` y `pc-orden-ms-prod.yml`
- `pc-pago-ms-dev.yml` y `pc-pago-ms-prod.yml`
- `pc-auth-ms-dev.yml` y `pc-auth-ms-prod.yml`

### 2.3 Bootstrap en los Clientes
Cada cliente especifica en su `application.yml` local la importacion opcional:
```yaml
spring:
  config:
    import: "optional:configserver:${CONFIG_SERVER_URL:http://localhost:18888}"
```