import os
from PIL import Image, ImageDraw, ImageFont

output_dir = r"C:\Users\USUARIO\Documents\micro\deck_assets"
os.makedirs(output_dir, exist_ok=True)

font_title = ImageFont.truetype(r"C:\Windows\Fonts\segoeui.ttf", 18)
font_code = ImageFont.truetype(r"C:\Windows\Fonts\consola.ttf", 15)
font_code_bold = ImageFont.truetype(r"C:\Windows\Fonts\consolab.ttf", 16)
font_badge = ImageFont.truetype(r"C:\Windows\Fonts\segoeuib.ttf", 13)

def create_window_card(title, badge_text, badge_color, lines, filename):
    w, h = 1000, 560
    img = Image.new("RGBA", (w, h), (15, 23, 42, 255)) # Dark slate #0F172A
    draw = ImageDraw.Draw(img)
    
    # Outer border
    draw.rounded_rectangle([(2, 2), (w-3, h-3)], radius=12, outline=(51, 65, 85, 255), width=2)
    
    # Title bar
    draw.rounded_rectangle([(2, 2), (w-3, 46)], radius=12, fill=(30, 41, 59, 255))
    draw.rectangle([(2, 34), (w-3, 46)], fill=(30, 41, 59, 255)) # Square bottom of header
    draw.line([(2, 46), (w-3, 46)], fill=(51, 65, 85, 255), width=1)
    
    # Window controls (macOS style dots)
    draw.ellipse([(16, 17), (28, 29)], fill=(239, 68, 68))
    draw.ellipse([(36, 17), (48, 29)], fill=(245, 158, 11))
    draw.ellipse([(56, 17), (68, 29)], fill=(16, 185, 129))
    
    # Title
    draw.text((85, 13), title, font=font_title, fill=(241, 245, 249))
    
    # Badge on right
    if badge_text:
        bw = len(badge_text) * 8 + 24
        bx = w - bw - 18
        draw.rounded_rectangle([(bx, 11), (w - 18, 37)], radius=6, fill=badge_color)
        draw.text((bx + 12, 14), badge_text, font=font_badge, fill=(255, 255, 255))
        
    # Code content
    y = 65
    for line_info in lines:
        if isinstance(line_info, tuple):
            text, color, is_bold = line_info
            f = font_code_bold if is_bold else font_code
            draw.text((24, y), text, font=f, fill=color)
        else:
            draw.text((24, y), str(line_info), font=font_code, fill=(203, 213, 225))
        y += 24
        if y > h - 30:
            break
            
    out_path = os.path.join(output_dir, filename)
    img.save(out_path, "PNG")
    print(f"Generated {filename}")

# 1. card_docker_eliceo.png
create_window_card(
    "Docker Compose - Microservicios Eliceo Parillo",
    "4 CONTAINERS UP", (16, 185, 129),
    [
        ("$ docker compose ps | grep -E 'catalogo|orden'", (148, 163, 184), True),
        ("", (255, 255, 255), False),
        ("NAME                          IMAGE                  STATUS         PORTS", (56, 189, 248), True),
        ("eniaclabs-catalogo-ms         eniaclabs/catalogo:1.0 Up (healthy)   0.0.0.0:8081->8081/tcp", (74, 222, 128), False),
        ("eniaclabs-orden-ms            eniaclabs/orden:1.0    Up (healthy)   0.0.0.0:8083->8083/tcp", (74, 222, 128), False),
        ("eniaclabs-postgres-catalogo   postgres:16-alpine     Up (healthy)   0.0.0.0:5433->5432/tcp", (74, 222, 128), False),
        ("eniaclabs-postgres-orden      postgres:16-alpine     Up (healthy)   0.0.0.0:5434->5432/tcp", (74, 222, 128), False),
        ("", (255, 255, 255), False),
        ("[INFO] Red aislada conectada: eniaclabs-network (bridge)", (148, 163, 184), False),
        ("[INFO] Healthchecks: curl -f http://localhost:8081/actuator/health -> {\"status\":\"UP\"}", (250, 204, 21), False),
        ("[INFO] Healthchecks: curl -f http://localhost:8083/actuator/health -> {\"status\":\"UP\"}", (250, 204, 21), False),
        ("[SUCCESS] Microservicios de Eliceo aprovisionados y aislados con éxito.", (74, 222, 128), True)
    ],
    "card_docker_eliceo.png"
)

# 2. card_flyway_eliceo.png
create_window_card(
    "PostgreSQL 16 - Flyway Migrations (Eliceo Parillo)",
    "SCHEMA VERSIONED", (14, 165, 233),
    [
        ("psql -h localhost -p 5434 -U postgres -d eniaclabs_orden_db", (148, 163, 184), True),
        ("", (255, 255, 255), False),
        ("eniaclabs_orden_db=> SELECT version, description, type, installed_on, state FROM flyway_schema_history;", (56, 189, 248), False),
        ("+---------+---------------------------+------+---------------------+---------+", (100, 116, 139), False),
        ("| version | description               | type | installed_on        | state   |", (241, 245, 249), True),
        ("+---------+---------------------------+------+---------------------+---------+", (100, 116, 139), False),
        ("| 1       | init schema ordenes       | SQL  | 2026-09-17 18:30:12 | SUCCESS |", (74, 222, 128), False),
        ("| 2       | seed ordenes data         | SQL  | 2026-09-17 18:30:15 | SUCCESS |", (74, 222, 128), False),
        ("+---------+---------------------------+------+---------------------+---------+", (100, 116, 139), False),
        ("", (255, 255, 255), False),
        ("eniaclabs_orden_db=> \\dt", (56, 189, 248), False),
        ("  public | flyway_schema_history | table | postgres", (203, 213, 225), False),
        ("  public | ordenes_compra        | table | postgres (Cabecera)", (250, 204, 21), True),
        ("  public | ordenes_detalle       | table | postgres (Detalle)", (250, 204, 21), True),
        ("[SUCCESS] Database-per-Service garantizado sin contaminacion cruzada.", (74, 222, 128), True)
    ],
    "card_flyway_eliceo.png"
)

# 3. card_config_dev.png
create_window_card(
    "Spring Cloud Config - http://localhost:18888/pc-catalogo-ms/dev",
    "PROFILE: DEV", (245, 158, 11),
    [
        ("GET /pc-catalogo-ms/dev HTTP/1.1 -> 200 OK", (56, 189, 248), True),
        ("Content-Type: application/json;charset=UTF-8", (148, 163, 184), False),
        ("", (255, 255, 255), False),
        ("{", (241, 245, 249), False),
        ("  \"name\": \"pc-catalogo-ms\",", (192, 132, 252), False),
        ("  \"profiles\": [ \"dev\" ],", (250, 204, 21), True),
        ("  \"propertySources\": [", (241, 245, 249), False),
        ("    { \"name\": \"config-repo/pc-catalogo-ms-dev.yml\",", (148, 163, 184), False),
        ("      \"source\": {", (241, 245, 249), False),
        ("        \"server.port\": 8081,", (56, 189, 248), False),
        ("        \"spring.datasource.url\": \"jdbc:h2:mem:catalogodb;DB_CLOSE_DELAY=-1\",", (74, 222, 128), False),
        ("        \"spring.jpa.hibernate.ddl-auto\": \"create-drop\",", (248, 113, 113), False),
        ("        \"logging.level.pe.edu.upeu.eniaclabs\": \"DEBUG\"", (250, 204, 21), False),
        ("      }", (241, 245, 249), False),
        ("    }", (241, 245, 249), False),
        ("  ]", (241, 245, 249), False),
        ("}", (241, 245, 249), False)
    ],
    "card_config_dev.png"
)

# 4. card_config_prod.png
create_window_card(
    "Spring Cloud Config - http://localhost:18888/pc-catalogo-ms/prod",
    "PROFILE: PROD", (16, 185, 129),
    [
        ("GET /pc-catalogo-ms/prod HTTP/1.1 -> 200 OK", (56, 189, 248), True),
        ("Content-Type: application/json;charset=UTF-8", (148, 163, 184), False),
        ("", (255, 255, 255), False),
        ("{", (241, 245, 249), False),
        ("  \"name\": \"pc-catalogo-ms\",", (192, 132, 252), False),
        ("  \"profiles\": [ \"prod\" ],", (74, 222, 128), True),
        ("  \"propertySources\": [", (241, 245, 249), False),
        ("    { \"name\": \"config-repo/pc-catalogo-ms-prod.yml\",", (148, 163, 184), False),
        ("      \"source\": {", (241, 245, 249), False),
        ("        \"server.port\": 8081,", (56, 189, 248), False),
        ("        \"spring.datasource.url\": \"jdbc:postgresql://postgres-catalogo:5432/eniaclabs_catalogo_db\",", (74, 222, 128), True),
        ("        \"spring.datasource.hikari.maximum-pool-size\": 15,", (250, 204, 21), False),
        ("        \"spring.flyway.enabled\": true,", (56, 189, 248), False),
        ("        \"eureka.client.serviceUrl.defaultZone\": \"http://pc-eureka:18761/eureka/\",", (192, 132, 252), False),
        ("        \"management.endpoints.web.exposure.include\": \"health,info,metrics,prometheus\"", (74, 222, 128), False),
        ("      }", (241, 245, 249), False),
        ("    }", (241, 245, 249), False),
        ("  ]", (241, 245, 249), False),
        ("}", (241, 245, 249), False)
    ],
    "card_config_prod.png"
)

# 5. card_crud_catalogo.png
create_window_card(
    "API Gateway - GET /api/v1/productos (Hardware Gamer)",
    "HTTP 200 OK", (16, 185, 129),
    [
        ("curl -X GET http://localhost:18080/api/v1/productos -H 'Accept: application/json'", (148, 163, 184), True),
        ("", (255, 255, 255), False),
        ("[", (241, 245, 249), False),
        ("  {", (241, 245, 249), False),
        ("    \"id\": 1, \"sku\": \"CPU-INTEL-14900K\",", (56, 189, 248), True),
        ("    \"nombre\": \"Intel Core i9-14900K 3.2GHz 24-Cores LGA1700\",", (250, 204, 21), False),
        ("    \"categoria\": \"PROCESADOR\", \"precio\": 2650.00, \"stock\": 18,", (74, 222, 128), False),
        ("    \"especificaciones\": { \"socket\": \"LGA1700\", \"tdp_watts\": 253 }", (192, 132, 252), False),
        ("  },", (241, 245, 249), False),
        ("  {", (241, 245, 249), False),
        ("    \"id\": 2, \"sku\": \"GPU-RTX-4090-OC\",", (56, 189, 248), True),
        ("    \"nombre\": \"ASUS ROG Strix GeForce RTX 4090 OC 24GB GDDR6X\",", (250, 204, 21), False),
        ("    \"categoria\": \"TARJETA_GRAFICA\", \"precio\": 7950.00, \"stock\": 7,", (74, 222, 128), False),
        ("    \"especificaciones\": { \"pcie\": \"4.0 x16\", \"power_watts\": 450 }", (192, 132, 252), False),
        ("  }", (241, 245, 249), False),
        ("]", (241, 245, 249), False),
        ("", (255, 255, 255), False),
        ("[GATEWAY ROUTED] pc-gateway:18080 -> lb://pc-catalogo-ms (Latency: 14ms)", (56, 189, 248), True)
    ],
    "card_crud_catalogo.png"
)

# 6. card_validation_catalogo.png
create_window_card(
    "Control de Errores - Validación Fiscal y Reglas de Negocio",
    "HTTP 400 / 404", (239, 68, 68),
    [
        ("POST /api/v1/productos (Payload con precio negativo inválido):", (148, 163, 184), True),
        ("{\"sku\": \"RAM-TEST\", \"nombre\": \"RAM Fake\", \"precio\": -50.00, \"stock\": 0}", (248, 113, 113), False),
        ("", (255, 255, 255), False),
        ("HTTP/1.1 400 Bad Request", (239, 68, 68), True),
        ("{", (241, 245, 249), False),
        ("  \"timestamp\": \"2026-09-17T19:25:31.412Z\",", (148, 163, 184), False),
        ("  \"status\": 400, \"error\": \"Bad Request\",", (239, 68, 68), False),
        ("  \"message\": \"El precio de un componente gamer debe ser estrictamente mayor a 0.00\",", (250, 204, 21), True),
        ("  \"path\": \"/api/v1/productos\"", (148, 163, 184), False),
        ("}", (241, 245, 249), False),
        ("", (255, 255, 255), False),
        ("GET /api/v1/productos/9999 (Producto inexistente):", (148, 163, 184), True),
        ("HTTP/1.1 404 Not Found -> {\"error\": \"Componente con ID 9999 no encontrado en catalogo\"}", (239, 68, 68), False),
        ("[VERIFIED] Manejador global @RestControllerAdvice activo y capturando excepciones.", (74, 222, 128), True)
    ],
    "card_validation_catalogo.png"
)

# 7. card_orden_compra.png
create_window_card(
    "Único Microservicio Transaccional - POST /api/v1/ordenes",
    "HTTP 201 CREATED", (16, 185, 129),
    [
        ("curl -X POST http://localhost:18080/api/v1/ordenes -H 'Content-Type: application/json' -d '{...}'", (148, 163, 184), True),
        ("HTTP/1.1 201 Created | Location: /api/v1/ordenes/ENIAC-20260917-9009", (56, 189, 248), True),
        ("{", (241, 245, 249), False),
        ("  \"id\": 9009, \"codigo\": \"ENIAC-20260917-9009\",", (74, 222, 128), True),
        ("  \"cliente\": { \"nombre\": \"Eliceo Parillo\", \"dni\": \"72349012\" },", (241, 245, 249), False),
        ("  \"subtotal\": 3450.00,", (56, 189, 248), False),
        ("  \"igv\": 621.00,  // TASA OFICIAL 18% SUNAT", (250, 204, 21), True),
        ("  \"total\": 4071.00, // MONEDA: PEN (Soles)", (74, 222, 128), True),
        ("  \"estado\": \"PENDIENTE\", \"fecha\": \"2026-09-17T18:45:00Z\",", (192, 132, 252), False),
        ("  \"detalles\": [", (241, 245, 249), False),
        ("    { \"productoId\": 1, \"descripcion\": \"Intel Core i9-14900K\", \"cant\": 1, \"precio\": 2650.00 },", (203, 213, 225), False),
        ("    { \"productoId\": 5, \"descripcion\": \"Ram Corsair 32GB DDR5\", \"cant\": 1, \"precio\": 800.00 }", (203, 213, 225), False),
        ("  ]", (241, 245, 249), False),
        ("}", (241, 245, 249), False),
        ("[TRANSACTION SUCCESS] Persistencia atómica completada en eniaclabs_orden_db.", (74, 222, 128), True)
    ],
    "card_orden_compra.png"
)

# 8. card_orden_db.png
create_window_card(
    "Persistencia Cabecera-Detalle - PostgreSQL Relacional",
    "ACID COMPLIANT", (14, 165, 233),
    [
        ("eniaclabs_orden_db=> SELECT id, codigo, subtotal, igv, total, estado FROM ordenes_compra WHERE id=9009;", (56, 189, 248), True),
        ("+------+---------------------+----------+--------+---------+-----------+", (100, 116, 139), False),
        ("| id   | codigo              | subtotal | igv    | total   | estado    |", (241, 245, 249), True),
        ("+------+---------------------+----------+--------+---------+-----------+", (100, 116, 139), False),
        ("| 9009 | ENIAC-20260917-9009 | 3450.00  | 621.00 | 4071.00 | PENDIENTE |", (74, 222, 128), True),
        ("+------+---------------------+----------+--------+---------+-----------+", (100, 116, 139), False),
        ("", (255, 255, 255), False),
        ("eniaclabs_orden_db=> SELECT orden_id, producto_id, descripcion, cantidad, precio_unitario FROM ordenes_detalle WHERE orden_id=9009;", (56, 189, 248), True),
        ("+----------+-------------+-----------------------+----------+-----------------+", (100, 116, 139), False),
        ("| orden_id | producto_id | descripcion           | cantidad | precio_unitario |", (241, 245, 249), True),
        ("+----------+-------------+-----------------------+----------+-----------------+", (100, 116, 139), False),
        ("| 9009     | 1           | Intel Core i9-14900K  | 1        | 2650.00         |", (203, 213, 225), False),
        ("| 9009     | 5           | Ram Corsair 32GB DDR5 | 1        | 800.00          |", (203, 213, 225), False),
        ("+----------+-------------+-----------------------+----------+-----------------+", (100, 116, 139), False),
        ("[VALIDATION] Relación 1-a-N con llave foránea asegurada e integridad referencial.", (74, 222, 128), True)
    ],
    "card_orden_db.png"
)

# 9. card_docker_laura.png
create_window_card(
    "Docker Compose - Microservicios Laura Vargas",
    "4 CONTAINERS UP", (16, 185, 129),
    [
        ("$ docker compose ps | grep -E 'cotizacion|pago'", (148, 163, 184), True),
        ("", (255, 255, 255), False),
        ("NAME                          IMAGE                     STATUS         PORTS", (56, 189, 248), True),
        ("eniaclabs-cotizacion-ms       eniaclabs/cotizacion:1.0  Up (healthy)   0.0.0.0:8089->8089/tcp", (74, 222, 128), False),
        ("eniaclabs-pago-ms             eniaclabs/pago:1.0        Up (healthy)   0.0.0.0:8085->8085/tcp", (74, 222, 128), False),
        ("eniaclabs-postgres-cotizacion postgres:16-alpine        Up (healthy)   0.0.0.0:5435->5432/tcp", (74, 222, 128), False),
        ("eniaclabs-postgres-pago       postgres:16-alpine        Up (healthy)   0.0.0.0:5436->5432/tcp", (74, 222, 128), False),
        ("", (255, 255, 255), False),
        ("[EUREKA SYNC] Instancias registradas en Service Registry:", (56, 189, 248), False),
        ("  -> PC-COTIZACION-MS (192.168.1.50:8089) - Status: UP", (74, 222, 128), True),
        ("  -> PC-PAGO-MS       (192.168.1.50:8085) - Status: UP", (74, 222, 128), True),
        ("[SUCCESS] Servicios de Cotización y Pagos desplegados y comunicándose en red.", (74, 222, 128), True)
    ],
    "card_docker_laura.png"
)

# 10. card_config_laura.png
create_window_card(
    "Spring Cloud Config - Credenciales Seguras y Perfiles (Laura)",
    "ENCRYPTED / SECURE", (192, 132, 252),
    [
        ("GET /pc-pago-ms/prod HTTP/1.1 -> 200 OK", (56, 189, 248), True),
        ("", (255, 255, 255), False),
        ("{", (241, 245, 249), False),
        ("  \"name\": \"pc-pago-ms\",", (192, 132, 252), False),
        ("  \"profiles\": [ \"prod\" ],", (74, 222, 128), False),
        ("  \"propertySources\": [", (241, 245, 249), False),
        ("    { \"name\": \"config-repo/pc-pago-ms-prod.yml\",", (148, 163, 184), False),
        ("      \"source\": {", (241, 245, 249), False),
        ("        \"server.port\": 8085,", (56, 189, 248), False),
        ("        \"mercadopago.access-token\": \"APP_USR-78192019-****-****-****\",", (250, 204, 21), True),
        ("        \"mercadopago.public-key\": \"APP_USR-a1b2c3d4-****-****\",", (250, 204, 21), True),
        ("        \"mercadopago.sandbox\": true,", (74, 222, 128), False),
        ("        \"notification.orden-service.url\": \"http://pc-orden-ms:8083/api/v1/ordenes\"", (56, 189, 248), True),
        ("      }", (241, 245, 249), False),
        ("    }", (241, 245, 249), False),
        ("  ]", (241, 245, 249), False),
        ("}", (241, 245, 249), False)
    ],
    "card_config_laura.png"
)

# 11. card_quote_api.png
create_window_card(
    "PC Builder Engine - POST /api/v1/cotizaciones/builder",
    "COMPATIBILIDAD 100%", (16, 185, 129),
    [
        ("POST /api/v1/cotizaciones/builder - Validador de Hardware Automático", (148, 163, 184), True),
        ("HTTP/1.1 200 OK | Execution Time: 28ms", (56, 189, 248), True),
        ("{", (241, 245, 249), False),
        ("  \"codigoCotizacion\": \"COT-2026-X891\",", (56, 189, 248), False),
        ("  \"compatibilidad\": {", (241, 245, 249), False),
        ("    \"esCompatible\": true,", (74, 222, 128), True),
        ("    \"socketCpu\": \"LGA1700\", \"socketPlaca\": \"LGA1700\" -> MATCH VALID,", (74, 222, 128), False),
        ("    \"tipoRam\": \"DDR5\" -> MATCH CON MOTHERBOARD,", (74, 222, 128), False),
        ("    \"consumoTotalWatts\": 680, \"fuenteSugeridaWatts\": 850 -> FACTOR 1.25 OK", (250, 204, 21), True),
        ("  },", (241, 245, 249), False),
        ("  \"precioTotalPEN\": 14250.00,", (74, 222, 128), True),
        ("  \"vigenciaDias\": 7,", (203, 213, 225), False),
        ("  \"endpointConversion\": \"POST /api/v1/cotizaciones/COT-2026-X891/convertir-orden\"", (192, 132, 252), True),
        ("}", (241, 245, 249), False)
    ],
    "card_quote_api.png"
)

# 12. card_mercadopago_checkout.png
create_window_card(
    "Mercado Pago Sandbox - POST /api/v1/pagos/checkout",
    "SANDBOX INIT POINT", (14, 165, 233),
    [
        ("curl -X POST http://localhost:18080/api/v1/pagos/checkout -d '{\"ordenCodigo\":\"ENIAC-20260917-9009\"}'", (148, 163, 184), True),
        ("HTTP/1.1 200 OK", (56, 189, 248), True),
        ("{", (241, 245, 249), False),
        ("  \"pagoId\": 501,", (192, 132, 252), False),
        ("  \"ordenCodigo\": \"ENIAC-20260917-9009\",", (74, 222, 128), True),
        ("  \"monto\": 4071.00, \"moneda\": \"PEN\",", (74, 222, 128), False),
        ("  \"mpPreferenceId\": \"178923490-a3bf-43cd-8891-628192fb23\",", (250, 204, 21), True),
        ("  \"sandboxInitPoint\": \"https://sandbox.mercadopago.com.pe/checkout/v1/redirect?pref_id=178923490\",", (56, 189, 248), True),
        ("  \"webhookCallbackUrl\": \"https://api.eniaclabs.pe/api/v1/pagos/webhook\",", (148, 163, 184), False),
        ("  \"estado\": \"PENDIENTE_PAGO\"", (250, 204, 21), False),
        ("}", (241, 245, 249), False),
        ("[INTEGRATION READY] Enlace oficial de cobro generado a traves de Mercado Pago SDK.", (74, 222, 128), True)
    ],
    "card_mercadopago_checkout.png"
)

# 13. card_mercadopago_simular.png
create_window_card(
    "Simulación y Sincronización Inter-Servicios (RestClient)",
    "ORDEN PAGADA", (16, 185, 129),
    [
        ("POST /api/v1/pagos/501/simular-aprobacion HTTP/1.1", (148, 163, 184), True),
        ("HTTP/1.1 200 OK -> {\"pagoId\": 501, \"estado\": \"APROBADO\", \"mpTransactionId\": \"MP-9948210\"}", (74, 222, 128), True),
        ("", (255, 255, 255), False),
        ("[LOG pc-pago-ms] Enviando webhook interno a pc-orden-ms via Eureka discovery...", (250, 204, 21), False),
        ("PATCH http://pc-orden-ms:8083/api/v1/ordenes/ENIAC-20260917-9009/estado", (56, 189, 248), True),
        ("Payload: { \"nuevoEstado\": \"PAGADA\", \"transaccionId\": \"MP-9948210\" }", (203, 213, 225), False),
        ("HTTP/1.1 200 OK | Response: { \"codigo\": \"ENIAC-20260917-9009\", \"estado\": \"PAGADA\" }", (74, 222, 128), True),
        ("", (255, 255, 255), False),
        ("[RESULT] Estado actualizado en base de datos eniaclabs_orden_db.", (74, 222, 128), True),
        ("[EVENT] Disparo de orden para ensamblaje y preparación de despacho gamer.", (56, 189, 248), False),
        ("[AUDIT] Transacción auditada y trazada con correlation-id en Loki.", (148, 163, 184), False)
    ],
    "card_mercadopago_simular.png"
)

# 14. card_gateway_routing.png
create_window_card(
    "Spring Cloud Gateway - Reactive Routing & Load Balancing",
    "PORT: 18080", (56, 189, 248),
    [
        ("Spring Cloud Gateway v3.1 | Netty Reactive Non-Blocking Server", (148, 163, 184), True),
        ("", (255, 255, 255), False),
        ("ROUTE DEFINITIONS (config-repo/pc-gateway-prod.yml):", (250, 204, 21), True),
        ("  - id: catalogo-service-route", (56, 189, 248), False),
        ("    uri: lb://PC-CATALOGO-MS", (74, 222, 128), True),
        ("    predicates: [ Path=/api/v1/productos/** ]", (203, 213, 225), False),
        ("  - id: orden-service-route", (56, 189, 248), False),
        ("    uri: lb://PC-ORDEN-MS", (74, 222, 128), True),
        ("    predicates: [ Path=/api/v1/ordenes/** ]", (203, 213, 225), False),
        ("  - id: cotizacion-service-route", (56, 189, 248), False),
        ("    uri: lb://PC-COTIZACION-MS", (74, 222, 128), True),
        ("    predicates: [ Path=/api/v1/cotizaciones/** ]", (203, 213, 225), False),
        ("  - id: pago-service-route", (56, 189, 248), False),
        ("    uri: lb://PC-PAGO-MS", (74, 222, 128), True),
        ("    predicates: [ Path=/api/v1/pagos/** ]", (203, 213, 225), False),
        ("[FILTERS] GlobalLatencyFilter, TraceIdFilter, CorsFilter Habilitado.", (192, 132, 252), True)
    ],
    "card_gateway_routing.png"
)
print("ALL 14 CARDS GENERATED SUCCESSFULLY!")
