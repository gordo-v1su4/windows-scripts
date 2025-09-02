@echo off
title PowerShell and Oh My Posh Setup Installer

echo ================================================
echo   PowerShell and Oh My Posh Setup Installer
echo ================================================
echo.
echo This installer will set up:
echo   - PowerShell 7 (latest)
echo   - Oh My Posh (terminal themes)
echo   - Nerd Fonts (for icons)
echo   - Custom PowerShell profile
echo   - Multiple terminal themes
echo.
echo IMPORTANT: This script requires Administrator privileges
echo.
pause

:: Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ERROR: Administrator privileges required!
    echo Please right-click this file and select "Run as Administrator"
    echo.
    pause
    exit /b 1
)

:: Run PowerShell installation script
echo.
echo Starting PowerShell installation script...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"

if %errorLevel% equ 0 (
    echo.
    echo ================================================
    echo   Installation completed successfully!
    echo ================================================
    echo.
    echo Next steps:
    echo 1. Open a new PowerShell 7 window
    echo 2. Your terminal should have the new theme!
    echo.
    echo To open PowerShell 7, run: pwsh
    echo.
) else (
    echo.
    echo ================================================
    echo   Installation encountered errors
    echo ================================================
    echo.
    echo Please check the error messages above.
    echo You may need to run the PowerShell script directly.
    echo.
)

pause
exit /b %errorLevel%
