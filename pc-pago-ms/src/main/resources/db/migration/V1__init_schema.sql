CREATE TABLE IF NOT EXISTS transacciones_pago (
    id BIGSERIAL PRIMARY KEY,
    orden_id BIGINT NOT NULL,
    codigo_orden VARCHAR(50) NOT NULL,
    monto NUMERIC(12, 2) NOT NULL,
    moneda VARCHAR(10) NOT NULL DEFAULT 'PEN',
    metodo_pago VARCHAR(50) NOT NULL DEFAULT 'MERCADO_PAGO',
    estado VARCHAR(30) NOT NULL DEFAULT 'PENDIENTE',
    mp_payment_id VARCHAR(100),
    mp_preference_id VARCHAR(100),
    sandbox_init_point VARCHAR(500),
    external_reference VARCHAR(100),
    payer_email VARCHAR(150),
    raw_webhook_payload TEXT,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_pago_orden ON transacciones_pago(orden_id);
CREATE INDEX IF NOT EXISTS idx_pago_mp_pref ON transacciones_pago(mp_preference_id);
CREATE INDEX IF NOT EXISTS idx_pago_estado ON transacciones_pago(estado);