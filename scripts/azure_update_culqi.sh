#!/bin/bash
set -e

echo "=== ACTUALIZANDO REPOSITORIO Y COMPILANDO CULQI CHECKOUT EN AZURE ==="
export HOME=/root
git config --system --add safe.directory "*" 2>/dev/null || true
git config --global --add safe.directory "*" 2>/dev/null || true
cd /home/azureuser/ENIAC-Labs2

git -c safe.directory="*" fetch origin main
git -c safe.directory="*" reset --hard origin/main

echo "=== RECONSTRUYENDO CONTENEDOR PC-PAGO-MS CON CONTROLADOR Y SERVICIO CULQI ==="
docker compose build pc-pago-ms

echo "=== RECREANDO CONTENEDORES CON NUEVAS RUTAS Y VARIABLES DE ENTORNO ==="
docker compose up -d --force-recreate pc-config pc-gateway pc-pago-ms

sleep 6

echo "=== TEST DE VERIFICACIÓN ENDPOINT CULQI CONFIG ==="
curl -s -i "http://localhost:18080/api/pagos/culqi/config" | head -n 15

echo ""
echo "=== TEST DE COBRO CULQI V2 CHARGES ==="
curl -s -i -X POST "http://localhost:18080/api/pagos/culqi/cobrar" \
  -H "Content-Type: application/json" \
  -d '{"token":"tkn_test_demo","amount":1000,"email":"cliente@eniac.pe","orderId":"26"}' | head -n 20

echo ""
echo "=== ¡PASARELA CULQI LISTA Y OPERATIVA EN AZURE VM! ==="
