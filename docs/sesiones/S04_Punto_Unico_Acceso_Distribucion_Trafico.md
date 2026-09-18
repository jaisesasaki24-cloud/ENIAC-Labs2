# Sesión 04: Punto Unico de Acceso y Distribución de Tráfico

## 1. Objetivos de Aprendizaje
- Configurar Spring Cloud Gateway Server WebMVC como puerta de enlace perimetral del sistema.
- Definir rutas mediante predicados de ruta (`Path`) y URIs balanceadas `lb://<service-name>`.
- Eliminar la exposición de puertos individuales al cliente externo.

## 2. Configuración de Rutas en `pc-gateway`
`pc-gateway` escucha en el puerto `18080` (DEV) y centraliza las peticiones de los 4 microservicios:

```yaml
server:
  port: 18080

spring:
  cloud:
    gateway:
      server:
        webmvc:
          routes:
            - id: pc-catalogo-categorias
              uri: lb://pc-catalogo-ms
              predicates:
                - Path=/api/v1/categorias/**
            - id: pc-catalogo-productos
              uri: lb://pc-catalogo-ms
              predicates:
                - Path=/api/v1/productos/**
            - id: pc-orden-ms
              uri: lb://pc-orden-ms
              predicates:
                - Path=/api/v1/ordenes/**
            - id: pc-pago-ms
              uri: lb://pc-pago-ms
              predicates:
                - Path=/api/v1/pagos/**
            - id: pc-auth-auth
              uri: lb://pc-auth-ms
              predicates:
                - Path=/api/v1/auth/**
            - id: pc-auth-usuarios
              uri: lb://pc-auth-ms
              predicates:
                - Path=/api/v1/usuarios/**
```

## 3. Balanceo de Carga en Acción
Cuando el Gateway recibe una solicitud hacia `/api/v1/productos`, consulta el registro dinámico de Eureka para `pc-catalogo-ms` y distribuye las peticiones entre las instancias disponibles (`8081` y `8082`) aplicando round-robin de forma transparente.