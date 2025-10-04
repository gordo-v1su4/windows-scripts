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
Write-Host "Step 5: Setting up PowerShell profiles..." -ForegroundColor Yellow

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Install profile for PowerShell 7
$pwsh7ProfileDir = "$env:USERPROFILE\Documents\PowerShell"
if (-not (Test-Path $pwsh7ProfileDir)) {
    New-Item -ItemType Directory -Path $pwsh7ProfileDir -Force | Out-Null
}
Copy-Item -Path "$scriptDir\Microsoft.PowerShell_profile.ps1" -Destination "$pwsh7ProfileDir\Microsoft.PowerShell_profile.ps1" -Force
Write-Host "PowerShell 7 profile installed!" -ForegroundColor Green

# Install profile for Windows PowerShell (optional, for compatibility)
$winPSProfileDir = "$env:USERPROFILE\Documents\WindowsPowerShell"
if (-not (Test-Path $winPSProfileDir)) {
    New-Item -ItemType Directory -Path $winPSProfileDir -Force | Out-Null
}
Copy-Item -Path "$scriptDir\Microsoft.PowerShell_profile.ps1" -Destination "$winPSProfileDir\Microsoft.PowerShell_profile.ps1" -Force
Write-Host "Windows PowerShell profile installed!" -ForegroundColor Green

Write-Host ""
Write-Host "Step 6: Downloading and installing Oh My Posh themes..." -ForegroundColor Yellow

# Create themes directory
$themesPath = "$env:USERPROFILE\.oh-my-posh\themes"
if (-not (Test-Path $themesPath)) {
    New-Item -ItemType Directory -Path $themesPath -Force | Out-Null
}

# Download official themes
try {
    Write-Host "Downloading official Oh My Posh themes..." -ForegroundColor Yellow
    $themesZip = "$env:TEMP\omp-themes.zip"
    Invoke-WebRequest -Uri "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip" -OutFile $themesZip
    Expand-Archive -Path $themesZip -DestinationPath $themesPath -Force
    Remove-Item $themesZip -Force
    Write-Host "Official themes downloaded successfully!" -ForegroundColor Green
} catch {
    Write-Host "Warning: Could not download official themes. You may need to download them manually." -ForegroundColor Yellow
}

# Copy custom theme
Copy-Item -Path "$scriptDir\1_shell_blue_green.omp.json" -Destination "$themesPath\1_shell_blue_green.omp.json" -Force
Write-Host "Custom blue-green theme installed!" -ForegroundColor Green

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
