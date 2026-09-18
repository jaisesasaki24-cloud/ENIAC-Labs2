# Sesion 01: Construccion del Servicio Base

## 1. Objetivos de Aprendizaje
- Inicializar la estructura modular de microservicios con Spring Boot 4 y Java 21 LTS.
- Implementar la arquitectura en capas: Controller, Service, Repository, Entity, DTO y Exceptions.
- Integrar Flyway para el control de versiones de esquemas en PostgreSQL.
- Disenar entidades segun el modelo de dominio ENIAC Labs.

## 2. Implementacion Tecnica en ENIAC Labs

### 2.1 Estructura Estandar y Capas
Cada microservicio implementa una separacion estricta:
```text
pe.edu.upeu.eniaclabs.<contexto>
|-- config
|-- controller
|-- dto
|-- entity
|-- exception
|-- repository
`-- service
    `-- impl
```

### 2.2 Migraciones Flyway
Las migraciones se encuentran en `src/main/resources/db/migration/`:
- `V1__init_schema.sql`: DDL de tablas e indices.
- `V2__seed_*.sql`: Datos semilla para pruebas inmediatas.
En configuracion:
```yaml
spring:
  flyway:
    enabled: true
    locations: classpath:db/migration
  jpa:
    hibernate:
      ddl-auto: validate
```

### 2.3 Docker Compose Local por Microservicio
Cada microservicio incluye su archivo `compose-dev.yml` con su base de datos PostgreSQL aislada para desarrollo local independiente.