-- V3: Seed Cable HDMI 2.1 a S/ 10.00
INSERT INTO categorias_hardware (codigo, nombre, descripcion, activo)
VALUES ('ACC', 'Accesorios y Cables', 'Cables de video HDMI 2.1, DisplayPort y adaptadores gaming', true)
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO productos_hardware (sku, nombre, marca, modelo, precio, stock_actual, stock_minimo, garantia_meses, especificaciones, activo, categoria_id)
SELECT 'ACC-HDMI-21-8K', 'Cable HDMI 2.1 Ultra High Speed 8K (2m)', 'ENIAC Labs Gaming', 'HDMI-21-8K-2M', 10.00, 50, 5, 24, '{"resolucion": "8K@60Hz / 4K@120Hz", "anchoBanda": "48Gbps", "conectores": "Bañado en Oro 24K", "longitud": "2m"}', true, id
FROM categorias_hardware WHERE codigo = 'ACC'
ON CONFLICT (sku) DO UPDATE SET precio = 10.00, nombre = 'Cable HDMI 2.1 Ultra High Speed 8K (2m)';
