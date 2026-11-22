#!/bin/bash
set -e

echo "=== 1. ACTUALIZANDO REPOSITORIO DESDE ORIGIN MAIN ==="
export HOME=/root
git config --system --add safe.directory "*" 2>/dev/null || true
git config --global --add safe.directory "*" 2>/dev/null || true
cd /home/azureuser/ENIAC-Labs2

git -c safe.directory="*" fetch origin main
git -c safe.directory="*" reset --hard origin/main

echo "=== 2. COMPILANDO EL MICROSERVICIO PC-PAGO-MS (CON CULQI Y YAPE) ==="
cd pc-pago-ms
chmod +x mvnw || true
if command -v mvn &> /dev/null; then
    mvn clean package -DskipTests
elif [ -f "./mvnw" ] && command -v java &> /dev/null; then
    ./mvnw clean package -DskipTests
else
    docker run --rm -v "$(pwd)":/app -w /app eclipse-temurin:21-jdk-alpine sh -c "chmod +x ./mvnw && ./mvnw clean package -DskipTests"
fi

cp -f target/pc-pago-ms-*.jar target/app.jar
cd ..

echo "=== 3. CONSTRUYENDO IMAGEN DOCKER PC-PAGO-MS CON EL NUEVO JAR ==="
docker compose build --no-cache pc-pago-ms

echo "=== 4. RECREANDO CONTENEDOR ENIACLABS-PAGO-MS ==="
docker compose up -d --force-recreate pc-pago-ms

echo "=== 5. ESPERANDO A QUE EL SERVICIO ESTE ONLINE ==="
sleep 10

echo "=== 6. VERIFICANDO ENDPOINTS CULQI Y PAGO ==="
curl -s -i "http://localhost:18080/api/pagos/culqi/config" | head -n 15 || true
echo ""
curl -s -i "http://localhost:8080/actuator/health" | head -n 10 || true

echo ""
echo "=== ¡DESPLIEGUE DE CULQI Y YAPE COMPLETADO AL 100% EN AZURE! ==="
