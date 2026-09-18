CREATE TABLE IF NOT EXISTS categorias_hardware (
    id BIGSERIAL PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500),
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS productos_hardware (
    id BIGSERIAL PRIMARY KEY,
    sku VARCHAR(60) NOT NULL UNIQUE,
    nombre VARCHAR(150) NOT NULL,
    marca VARCHAR(80) NOT NULL,
    modelo VARCHAR(80) NOT NULL,
    precio NUMERIC(12, 2) NOT NULL,
    stock_actual INT NOT NULL,
    stock_minimo INT NOT NULL DEFAULT 3,
    garantia_meses INT NOT NULL DEFAULT 24,
    especificaciones TEXT,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    categoria_id BIGINT NOT NULL,
    CONSTRAINT fk_productos_categoria FOREIGN KEY (categoria_id) REFERENCES categorias_hardware (id)
);

CREATE INDEX IF NOT EXISTS idx_productos_sku ON productos_hardware(sku);
CREATE INDEX IF NOT EXISTS idx_productos_cat ON productos_hardware(categoria_id);