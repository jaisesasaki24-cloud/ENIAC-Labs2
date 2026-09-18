# Sesión 03: Registro, Descubrimiento y Ejecución Concurrente

## 1. Objetivos de Aprendizaje
- Implementar Netflix Eureka Server como directorio central de servicios.
- Registrar clientes dinámicos enviando latidos (heartbeats).
- Habilitar la ejecución concurrente de múltiples instancias por microservicio para escalabilidad horizontal.

## 2. Servidor Eureka (`pc-eureka`)
Ubicado en `infra/pc-eureka`, escucha en el puerto `18761` (DEV) o `8761` (PROD):
```yaml
eureka:
  server:
    enable-self-preservation: false
  client:
    register-with-eureka: false
    fetch-registry: false
```
Dashboard accesible en: `http://localhost:18761`.

## 3. Registro de Clientes y Ejecución Multi-Instancia
Cada microservicio declara en su configuración:
```yaml
eureka:
  instance:
    hostname: localhost
    instance-id: ${spring.application.name}:${server.port}
  client:
    service-url:
      defaultZone: http://localhost:18761/eureka
```

Para levantar una segunda instancia concurrente de `pc-catalogo-ms` en Windows:
```powershell
.\mvnw.cmd spring-boot:run "-Dspring-boot.run.arguments=--server.port=8082"
```
Ambas instancias (`8081` y `8082`) quedan registradas bajo el mismo Application Name `PC-CATALOGO-MS` en el dashboard de Eureka.