@echo off
echo ========================================================
echo    ENIAC Labs - Actualizar Frontend en Vercel
echo ========================================================
echo.
echo Compilando la version mas reciente de Angular (S/ 6.00)...
cd /d "%~dp0clients\eniaclabs-frontend"
call npm run build
echo.
echo ========================================================
echo Carpeta compilada con exito: dist\app\browser
echo Abriendo la carpeta y Vercel en tu navegador...
echo ========================================================
start "" "%~dp0clients\eniaclabs-frontend\dist\app\browser"
start https://vercel.com
echo.
echo INSTRUCCION:
echo Arrastra los archivos de la carpeta abierta y sueltalos en tu proyecto de Vercel.
pause
