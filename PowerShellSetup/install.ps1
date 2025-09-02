# PowerShell & Oh My Posh Installation Script
# Run as Administrator

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "  PowerShell & Oh My Posh Setup Installer" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator. Exiting..." -ForegroundColor Red
    Exit 1
}

# Function to test if a command exists
function Test-CommandExists {
    param($command)
    $null = Get-Command $command -ErrorAction SilentlyContinue
    return $?
}

Write-Host "Step 1: Installing Chocolatey package manager..." -ForegroundColor Yellow
if (-not (Test-CommandExists choco)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Write-Host "Chocolatey installed successfully!" -ForegroundColor Green
} else {
    Write-Host "Chocolatey already installed." -ForegroundColor Green
}

Write-Host ""
Write-Host "Step 2: Installing PowerShell 7..." -ForegroundColor Yellow
if (-not (Test-Path "C:\Program Files\PowerShell\7\pwsh.exe")) {
    choco install powershell-core -y
    Write-Host "PowerShell 7 installed successfully!" -ForegroundColor Green
} else {
    Write-Host "PowerShell 7 already installed." -ForegroundColor Green
}

Write-Host ""
Write-Host "Step 3: Installing Oh My Posh..." -ForegroundColor Yellow
if (-not (Test-CommandExists oh-my-posh)) {
    # Try winget first
    winget install JanDeDobbeleer.OhMyPosh -s winget --accept-package-agreements --accept-source-agreements
    
    # If winget fails, try Chocolatey
    if (-not (Test-CommandExists oh-my-posh)) {
        choco install oh-my-posh -y
    }
    
    # If both fail, try direct installation
    if (-not (Test-CommandExists oh-my-posh)) {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
    }
    
    Write-Host "Oh My Posh installed successfully!" -ForegroundColor Green
} else {
    Write-Host "Oh My Posh already installed." -ForegroundColor Green
}

Write-Host ""
Write-Host "Step 4: Installing Nerd Font (CaskaydiaCove)..." -ForegroundColor Yellow
$fontName = "CaskaydiaCove NF"
$fontInstalled = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' | Select-Object -ExpandProperty PSObject.Properties | Where-Object { $_.Name -like "*$fontName*" }

if (-not $fontInstalled) {
    Write-Host "Downloading Nerd Font..." -ForegroundColor Yellow
    $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip"
    $fontZip = "$env:TEMP\CascadiaCode.zip"
    $fontExtract = "$env:TEMP\CascadiaCode"
    
    Invoke-WebRequest -Uri $fontUrl -OutFile $fontZip
    Expand-Archive -Path $fontZip -DestinationPath $fontExtract -Force
    
    # Install fonts
    $fonts = Get-ChildItem -Path $fontExtract -Filter "*.ttf" -Recurse
    foreach ($font in $fonts) {
        $fontDestination = "C:\Windows\Fonts\$($font.Name)"
        Copy-Item -Path $font.FullName -Destination $fontDestination -Force
        
        # Register font in registry
        $fontRegistryName = $font.BaseName + " (TrueType)"
        New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' -Name $fontRegistryName -Value $font.Name -PropertyType String -Force | Out-Null
    }
    
    # Cleanup
    Remove-Item -Path $fontZip -Force
    Remove-Item -Path $fontExtract -Recurse -Force
    
    Write-Host "Nerd Font installed successfully!" -ForegroundColor Green
} else {
    Write-Host "Nerd Font already installed." -ForegroundColor Green
}

Write-Host ""
Write-Host "Step 5: Setting up PowerShell profile..." -ForegroundColor Yellow

# Determine the profile path for PowerShell 7
$profileDir = Split-Path -Parent $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

# Copy the profile
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Copy-Item -Path "$scriptDir\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force
Write-Host "PowerShell profile installed!" -ForegroundColor Green

Write-Host ""
Write-Host "Step 6: Installing custom Oh My Posh theme..." -ForegroundColor Yellow

# Find Oh My Posh themes directory
$ohMyPoshPath = (Get-Command oh-my-posh -ErrorAction SilentlyContinue).Source
if ($ohMyPoshPath) {
    $themesPath = Join-Path (Split-Path -Parent (Split-Path -Parent $ohMyPoshPath)) "themes"
    
    if (Test-Path $themesPath) {
        Copy-Item -Path "$scriptDir\1_shell_blue_green.omp.json" -Destination $themesPath -Force
        Write-Host "Custom theme installed!" -ForegroundColor Green
    } else {
        Write-Host "Could not find Oh My Posh themes directory. Manual installation may be required." -ForegroundColor Yellow
        Write-Host "Copy 1_shell_blue_green.omp.json to: $env:POSH_THEMES_PATH" -ForegroundColor Yellow
    }
} else {
    Write-Host "Oh My Posh not found in PATH. Theme will need manual installation." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Step 7: Installing PSReadLine module..." -ForegroundColor Yellow
if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
    Install-Module -Name PSReadLine -Force -SkipPublisherCheck -Scope CurrentUser
    Write-Host "PSReadLine installed successfully!" -ForegroundColor Green
} else {
    Write-Host "PSReadLine already installed." -ForegroundColor Green
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Close this window" -ForegroundColor White
Write-Host "2. Open a new PowerShell 7 window (pwsh.exe)" -ForegroundColor White
Write-Host "3. Your new terminal theme should be active!" -ForegroundColor White
Write-Host ""
Write-Host "To change themes, edit your profile:" -ForegroundColor Cyan
Write-Host "  notepad `$PROFILE" -ForegroundColor White
Write-Host ""
Write-Host "If fonts don't display correctly:" -ForegroundColor Cyan
Write-Host "  Set your terminal font to 'CaskaydiaCove NF'" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
