#!/bin/bash
set -e

echo "=== ACTUALIZANDO REPOSITORIO Y COMPILANDO YAPE (ORDERS API) EN AZURE ==="
export HOME=/root
git config --system --add safe.directory "*" 2>/dev/null || true
git config --global --add safe.directory "*" 2>/dev/null || true
cd /home/azureuser/ENIAC-Labs2

git -c safe.directory="*" fetch origin main
git -c safe.directory="*" reset --hard origin/main

echo "=== RECONSTRUYENDO CONTENEDOR PC-PAGO-MS CON ORDERS API YAPE ==="
docker compose build pc-pago-ms

echo "=== RECREANDO CONTENEDORES CON NUEVAS RUTAS Y VARIABLES DE ENTORNO ==="
docker compose up -d --force-recreate pc-config pc-gateway pc-pago-ms

sleep 6

echo "=== TEST DE VERIFICACIÓN ENDPOINT MERCADO PAGO YAPE (/api/payments/yape) ==="
curl -s -i -X POST "http://localhost:18080/api/payments/yape" \
  -H "Content-Type: application/json" \
  -d '{"token":"test_token_validation","amount":6.00,"orderId":"26","email":"cliente@eniac.pe","phoneNumber":"984512870"}' | head -n 25

echo ""
echo "=== ¡MERCADO PAGO ORDERS API (YAPE) LISTA Y OPERATIVA EN AZURE VM! ==="
