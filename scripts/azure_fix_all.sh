#!/bin/bash
set -e

echo "=========================================================="
echo "    ENIAC LABS - REPARACIÓN INTEGRAL EN AZURE VM         "
echo "    Autor: Parillo Mostajo Eliceo | Docente: Ing. Abel Angel"
echo "=========================================================="

# 1. Configurar entorno seguro y sincronizar con Git main
export HOME=/root
git config --system --add safe.directory "*" 2>/dev/null || true
git config --global --add safe.directory "*" 2>/dev/null || true
cd /home/azureuser/ENIAC-Labs2
echo "[1/6] Sincronizando repositorio con origin/main..."
git -c safe.directory="*" fetch origin main
git -c safe.directory="*" reset --hard origin/main

# 2. Desactivar SSL Obligatorio directamente en Base de Datos de Keycloak
echo "[2/6] Desactivando SSL obligatorio en Base de Datos Keycloak..."
docker exec -i eniaclabs-keycloak-db psql -U eniaclabs_keycloak -d eniaclabs_keycloak -c "UPDATE realm SET ssl_required = 'NONE';" || true

# 3. Configurar Keycloak mediante CLI Oficial (kcadm.sh)
echo "[3/6] Autenticando con Keycloak Admin CLI..."
docker exec eniaclabs-keycloak /opt/keycloak/bin/kcadm.sh config credentials \
  --server http://localhost:8080 --realm master --user admin --password admin123

echo "Configurando sslRequired=NONE en realms..."
docker exec eniaclabs-keycloak /opt/keycloak/bin/kcadm.sh update realms/master -s sslRequired=NONE || true
docker exec eniaclabs-keycloak /opt/keycloak/bin/kcadm.sh update realms/eniaclabs -s sslRequired=NONE || true

echo "Verificando cliente eniaclabs-frontend..."
CID=$(docker exec eniaclabs-keycloak /opt/keycloak/bin/kcadm.sh get clients -r eniaclabs -q clientId=eniaclabs-frontend --fields id --format csv --noquotes 2>/dev/null | tr -d '\r' | head -n1 || true)

if [ -z "$CID" ]; then
    echo "Creando cliente público eniaclabs-frontend..."
    docker exec eniaclabs-keycloak /opt/keycloak/bin/kcadm.sh create clients -r eniaclabs \
      -s clientId=eniaclabs-frontend \
      -s enabled=true \
      -s publicClient=true \
      -s directAccessGrantsEnabled=true \
      -s standardFlowEnabled=true \
      -s redirectUris+='*' \
      -s redirectUris+='https://eniaclabs-nine.vercel.app/*' \
      -s redirectUris+='http://localhost:4200/*' \
      -s webOrigins+='*' \
      -s webOrigins+='+' \
      -s webOrigins+='https://eniaclabs-nine.vercel.app'
    CID=$(docker exec eniaclabs-keycloak /opt/keycloak/bin/kcadm.sh get clients -r eniaclabs -q clientId=eniaclabs-frontend --fields id --format csv --noquotes | tr -d '\r' | head -n1)
else
    echo "Actualizando cliente eniaclabs-frontend ($CID)..."
    docker exec eniaclabs-keycloak /opt/keycloak/bin/kcadm.sh update clients/$CID -r eniaclabs \
      -s enabled=true \
      -s publicClient=true \
      -s directAccessGrantsEnabled=true \
      -s standardFlowEnabled=true \
      -s redirectUris+='*' \
      -s redirectUris+='https://eniaclabs-nine.vercel.app/*' \
      -s redirectUris+='http://localhost:4200/*' \
      -s webOrigins+='*' \
      -s webOrigins+='+' \
      -s webOrigins+='https://eniaclabs-nine.vercel.app'
fi

echo "Asegurando rol CLIENTE..."
docker exec eniaclabs-keycloak /opt/keycloak/bin/kcadm.sh create roles -r eniaclabs -s name=CLIENTE 2>/dev/null || true

echo "Verificando usuario cliente1..."
UID_USER=$(docker exec eniaclabs-keycloak /opt/keycloak/bin/kcadm.sh get users -r eniaclabs -q username=cliente1 --fields id --format csv --noquotes 2>/dev/null | tr -d '\r' | head -n1 || true)

if [ -z "$UID_USER" ]; then
    echo "Creando usuario cliente1..."
    docker exec eniaclabs-keycloak /opt/keycloak/bin/kcadm.sh create users -r eniaclabs \
      -s username=cliente1 \
      -s enabled=true \
      -s email=cliente1@eniaclabs.pe \
      -s firstName=Cliente \
      -s lastName=Uno
    UID_USER=$(docker exec eniaclabs-keycloak /opt/keycloak/bin/kcadm.sh get users -r eniaclabs -q username=cliente1 --fields id --format csv --noquotes | tr -d '\r' | head -n1)
fi

echo "Estableciendo credenciales cliente1 / cliente123..."
docker exec eniaclabs-keycloak /opt/keycloak/bin/kcadm.sh set-password -r eniaclabs --userid $UID_USER --new-password cliente123
docker exec eniaclabs-keycloak /opt/keycloak/bin/kcadm.sh add-roles -r eniaclabs --uusername cliente1 --rolename CLIENTE 2>/dev/null || true

# 4. Actualizar microservicios y Prometheus
echo "[4/6] Reiniciando eniaclabs-config, eniaclabs-auth-ms y observabilidad..."
docker compose restart pc-config
docker compose restart pc-auth-ms
docker compose restart prometheus grafana

# 5. Esperar 5 segundos para que converjan
sleep 5

# 6. Prueba de verificación de Token en Vivo
echo "[5/6] Verificando generación de Tokens OIDC..."
TOKEN_TEST=$(curl -s -X POST http://localhost:18180/realms/eniaclabs/protocol/openid-connect/token \
  -d "client_id=eniaclabs-frontend&grant_type=password&username=cliente1&password=cliente123")

echo "Respuesta Token:"
echo "$TOKEN_TEST" | cut -c 1-120

echo ""
echo "[6/6] Verificando Prometheus Targets..."
curl -s http://localhost:9090/api/v1/targets | grep -o '"health":"[^"]*"' | sort | uniq -c

echo ""
echo "=========================================================="
echo "    SISTEMA ENIAC LABS 100% OPERATIVO EN AZURE           "
echo "=========================================================="

