CREATE TABLE IF NOT EXISTS ordenes_compra (
    id BIGSERIAL PRIMARY KEY,
    codigo_orden VARCHAR(50) NOT NULL UNIQUE,
    cliente_id BIGINT NOT NULL,
    cliente_nombre VARCHAR(150) NOT NULL,
    cliente_email VARCHAR(150) NOT NULL,
    subtotal NUMERIC(12, 2) NOT NULL,
    igv NUMERIC(12, 2) NOT NULL,
    total NUMERIC(12, 2) NOT NULL,
    estado VARCHAR(30) NOT NULL DEFAULT 'PENDIENTE',
    metodo_pago VARCHAR(50),
    direccion_envio VARCHAR(255),
    observaciones VARCHAR(500),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP
);

CREATE TABLE IF NOT EXISTS ordenes_compra_detalle (
    id BIGSERIAL PRIMARY KEY,
    orden_compra_id BIGINT NOT NULL,
    producto_id BIGINT NOT NULL,
    sku VARCHAR(60) NOT NULL,
    producto_nombre VARCHAR(150) NOT NULL,
    precio_unitario NUMERIC(12, 2) NOT NULL,
    cantidad INT NOT NULL,
    subtotal_linea NUMERIC(12, 2) NOT NULL,
    CONSTRAINT fk_detalle_orden FOREIGN KEY (orden_compra_id) REFERENCES ordenes_compra (id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_ordenes_codigo ON ordenes_compra(codigo_orden);
CREATE INDEX IF NOT EXISTS idx_ordenes_cliente ON ordenes_compra(cliente_id);
CREATE INDEX IF NOT EXISTS idx_detalle_orden ON ordenes_compra_detalle(orden_compra_id);