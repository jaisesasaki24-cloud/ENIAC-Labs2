@echo off
chcp 65001 >nul
title ENIAC Labs - Detener Todo
cls
echo ==============================================================================
echo             ENIAC LABS - DETENER TODOS LOS SERVIDORES Y PROCESOS
echo ==============================================================================

cd /d "%~dp0"

:: 1. Detener servidor de documentacion MkDocs
echo [1/2] Deteniendo servidor de documentacion MkDocs...
if exist .mkdocs.pid (
    for /f %%p in (.mkdocs.pid) do (
        taskkill /F /T /PID %%p >nul 2>nul
    )
    del .mkdocs.pid >nul 2>nul
)

:: Detener cualquier proceso en puerto 4200 (Frontend Angular)
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :4200 ^| findstr LISTENING') do (
    taskkill /F /PID %%a >nul 2>nul
)

:: 2. Detener Docker Compose si docker esta activo
echo [2/2] Verificando Docker...
docker info >nul 2>nul
if %errorlevel% equ 0 (
    echo Deteniendo contenedores Docker Compose...
    docker compose down >nul 2>nul
    if exist keycloak\compose-dev.yml (
        cd keycloak
        docker compose -f compose-dev.yml down >nul 2>nul
        cd ..
    )
    echo [OK] Contenedores detenidos correctamente.
) else (
    echo [OK] Docker no estaba activo. Nada que detener.
)

echo.
echo ==============================================================================
echo [OK] Todos los servicios han sido detenidos exitosamente.
echo ==============================================================================
timeout /t 3 >nul
