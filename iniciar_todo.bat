@echo off
chcp 65001 >nul
title ENIAC Labs - Iniciador Universal Portable
cls
echo ==============================================================================
echo             ENIAC LABS - INICIADOR UNIVERSAL PORTABLE
echo       (Compatible con cualquier PC, Laptop o ruta de carpetas)
echo ==============================================================================

:: 1. Posicionarse siempre en el directorio donde reside este script
cd /d "%~dp0"

:: 2. Detectar comando de Python disponible
set PY_CMD=
where python >nul 2>nul
if %errorlevel% equ 0 (
    set PY_CMD=python
    goto PYTHON_FOUND
)

where py >nul 2>nul
if %errorlevel% equ 0 (
    set PY_CMD=py -3
    goto PYTHON_FOUND
)

echo [ERROR] No se encontro Python en el sistema.
echo Por favor asegurese de tener instalado Python 3.8+ (marcar la casilla 'Add Python to PATH').
echo Descarga: https://www.python.org/downloads/
pause
exit /b 1

:PYTHON_FOUND
:: 3. Ejecutar el orquestador inteligente
%PY_CMD% iniciar_todo.py %*

if %errorlevel% neq 0 (
    echo.
    echo [AVISO] El iniciador se cerro con codigo %errorlevel%.
    pause
)
