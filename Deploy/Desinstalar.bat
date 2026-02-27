@echo off
color 0C
title Desinstalador - Monitor SPDC

:: 1. Verifica permissao de Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Solicitando permissao de Administrador...
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

echo ===================================================
echo     DESINSTALANDO O MONITOR DA API SPDC
echo ===================================================
echo.

echo 1. Parando o servico...
net stop SpdcMonitor

:: Aguarda 2 segundos para o Windows matar o processo
timeout /t 2 /nobreak > NUL

echo.
echo 2. Removendo do registro do Windows...
"%~dp0MonitorSpdc.exe" /uninstall /silent

echo.
echo ===================================================
echo Desinstalacao concluida! Agora voce pode apagar a pasta.
echo ===================================================
pause