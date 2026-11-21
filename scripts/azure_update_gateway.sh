#!/bin/bash
set -e

echo "=== ACTUALIZANDO REPOSITORIO Y CONFIGURACIÓN DE CORS EN AZURE ==="
export HOME=/root
git config --system --add safe.directory "*" 2>/dev/null || true
git config --global --add safe.directory "*" 2>/dev/null || true
cd /home/azureuser/ENIAC-Labs2

git -c safe.directory="*" fetch origin main
git -c safe.directory="*" reset --hard origin/main

echo "=== REINICIANDO CONFIG SERVER Y API GATEWAY ==="
docker compose restart pc-config pc-gateway

sleep 4

echo "=== TEST DE CORS PREFLIGHT DESDE VERCEL ==="
curl -i -X OPTIONS "http://localhost:18080/api/payments/create-preference" \
  -H "Origin: https://eniaclabs-nine.vercel.app" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: content-type" | head -n 15

echo ""
echo "=== ¡API GATEWAY ACTUALIZADO! AHORA VERCEL PUEDE REDIRIGIR A MERCADO PAGO ==="
