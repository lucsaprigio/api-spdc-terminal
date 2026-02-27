@echo off
color 0A
title Instalador - Monitor SPDC

:: 1. Verifica se ja tem permissao de Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Solicitando permissao de Administrador...
    :: Se nao tiver, chama o PowerShell para pedir a tela de "Sim/Nao" e reabrir o script
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)

echo ===================================================
echo      INSTALANDO O MONITOR DA API SPDC
echo ===================================================
echo.

:: 2. Instala o servico. O "%~dp0" garante que ele ache o .exe na pasta certa
echo 1. Registrando o servico no Windows...
"%~dp0MonitorSpdc.exe" /install /silent

:: Aguarda 2 segundos para o Windows registrar o servico
timeout /t 2 /nobreak > NUL

echo.
echo 2. Iniciando o servico no fundo...
net start SpdcMonitor

echo.
echo ===================================================
echo Instalacao concluida com sucesso! A API esta protegida.
echo ===================================================
pause