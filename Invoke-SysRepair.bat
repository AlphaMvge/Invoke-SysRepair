@echo off
:: ==============================================================================
:: Invoke-SysRepair - Windows Command Line Bootstrap Launcher
:: https://github.com/AlphaMvge/Invoke-SysRepair
:: ==============================================================================
chcp 65001 >nul
title Invoke-SysRepair Bootstrap Launcher

:: Test for Administrator Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Administrative privileges required. Invoking UAC elevation...
    powershell.exe -NoProfile -Command "Start-Process cmd.exe -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

:: Launch the PowerShell Suite
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Invoke-SysRepair.ps1" %*
