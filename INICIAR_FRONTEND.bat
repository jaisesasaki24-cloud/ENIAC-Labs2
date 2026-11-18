@echo off
chcp 65001 >nul
title ENIAC Labs - Frontend Gamer SPA (Angular)
cls
echo ==============================================================================
echo             ENIAC LABS - FRONTEND GAMER SPA (ANGULAR 22)
echo ==============================================================================
cd /d "%~dp0\clients\eniaclabs-frontend"

echo [1/2] Verificando dependencias...
if not exist node_modules (
    echo Instalando paquetes npm...
    call npm install
)

echo.
echo [2/2] Iniciando Frontend Angular en http://localhost:4200 ...
echo Presione Ctrl+C para detener el frontend en cualquier momento.
echo.
call npm start

pause

