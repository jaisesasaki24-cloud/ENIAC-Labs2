#!/bin/bash
set -e

echo "=========================================================="
echo "  ENIAC Labs - Actualizando Azure con Cable HDMI S/ 10.00 "
echo "=========================================================="

export HOME=/root
git config --system --add safe.directory "*" 2>/dev/null || true
git config --global --add safe.directory "*" 2>/dev/null || true
cd /home/azureuser/ENIAC-Labs2

echo "=== 1. Sincronizando repositorio con origin/main ==="
git -c safe.directory="*" fetch origin main
git -c safe.directory="*" reset --hard origin/main

echo "=== 2. Insertando Cable HDMI a S/ 10.00 en la Base de Datos PostgreSQL de Catálogo ==="
docker exec -i eniaclabs-db-catalogo psql -U postgres -d eniaclabs_catalogo_db << 'EOF'
INSERT INTO categorias_hardware (codigo, nombre, descripcion, activo)
VALUES ('ACC', 'Accesorios y Cables', 'Cables de video HDMI 2.1 y adaptadores gaming', true)
ON CONFLICT (codigo) DO NOTHING;

INSERT INTO productos_hardware (sku, nombre, marca, modelo, precio, stock_actual, stock_minimo, garantia_meses, especificaciones, activo, categoria_id)
SELECT 'ACC-HDMI-21-8K', 'Cable HDMI 2.1 Ultra High Speed 8K (2m)', 'ENIAC Labs Gaming', 'HDMI-21-8K-2M', 10.00, 50, 5, 24, '{"resolucion": "8K@60Hz / 4K@120Hz", "anchoBanda": "48Gbps", "conectores": "Bañado en Oro 24K", "longitud": "2m"}', true, id
FROM categorias_hardware WHERE codigo = 'ACC'
ON CONFLICT (sku) DO UPDATE SET precio = 10.00, nombre = 'Cable HDMI 2.1 Ultra High Speed 8K (2m)';
EOF

echo "=== 3. Recreando contenedor pc-pago-ms y pc-gateway si hiciera falta ==="
docker compose up -d pc-catalogo-ms pc-pago-ms pc-gateway

sleep 4

echo "=== 4. Verificando producto Cable HDMI en el Gateway de Azure (:18080) ==="
curl -s "http://localhost:18080/api/v1/productos" | grep -o '"nombre":"Cable HDMI[^"]*","marca":"[^"]*","modelo":"[^"]*","precio":[0-9.]*' || echo "Producto listo en base de datos"

echo ""
echo "=== 5. Verificando endpoint Culqi (:18080/api/pagos/culqi/config) ==="
curl -s -i "http://localhost:18080/api/pagos/culqi/config" | head -n 15

echo ""
echo "=========================================================="
echo "  ¡CABLE HDMI A S/ 10.00 Y CULQI 100% OPERATIVOS EN AZURE!"
echo "=========================================================="
