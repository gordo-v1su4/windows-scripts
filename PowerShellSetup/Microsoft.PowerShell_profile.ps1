# PowerShell Profile Configuration - Fix PSReadLine screen reader detection
Import-Module PSReadLine -Force
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -BellStyle None

# Initialize Oh My Posh with theme options (uncomment the one you want to use)
# oh-my-posh init pwsh --config "$($env:POSH_THEMES_PATH)\mytheme.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$($env:POSH_THEMES_PATH)\devious-diamonds.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$($env:POSH_THEMES_PATH)\jonnychipz.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$($env:POSH_THEMES_PATH)\jv_sitecorian.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$($env:POSH_THEMES_PATH)\nu4a.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$($env:POSH_THEMES_PATH)\night-owl.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$($env:POSH_THEMES_PATH)\marcduiker.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$($env:POSH_THEMES_PATH)\slim.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$($env:POSH_THEMES_PATH)\cert.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$($env:POSH_THEMES_PATH)\blueish.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$($env:POSH_THEMES_PATH)\atomic.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$($env:POSH_THEMES_PATH)\1_shell.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "$($env:POSH_THEMES_PATH)\1_shell_blue_green.omp.json" | Invoke-Expression  # Custom blue-green version

# Optional: suppress startup banner
$env:POWERSHELL_DISABLE_CONSOLEHOSTSTARTUPMESSAGE = "1"

# Additional color and key binding customizations
Set-PSReadLineOption -Colors @{
    Command = 'Yellow'
    Parameter = 'Gray'
    Operator = 'Magenta'
    Variable = 'Green'
    String = 'Blue'
    Number = 'Red'
    Type = 'Cyan'
    Comment = 'DarkGreen'
}

# Key bindings for better navigation
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# =============================================================================
# CLEANUP FUNCTIONS
# =============================================================================

# Quick clean - just clear screen
function clean {
    Clear-Host
}

# Deep clean - cleanup development processes and system resources
function clean-dev {
    Write-Host "Starting development environment cleanup..." -ForegroundColor Cyan
    
    # Kill orphaned Node.js processes
    $nodeProcesses = Get-Process -Name "node" -ErrorAction SilentlyContinue
    if ($nodeProcesses) {
        Write-Host "Found $($nodeProcesses.Count) Node.js processes - terminating..." -ForegroundColor Yellow
        $nodeProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
    }
    
    # Kill orphaned npm/yarn processes
    Get-Process -Name "npm", "yarn" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    
    # Kill orphaned Python processes (except system ones)
    $pythonProcesses = Get-Process -Name "python*" -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "*Users*" }
    if ($pythonProcesses) {
        Write-Host "Found $($pythonProcesses.Count) user Python processes - terminating..." -ForegroundColor Yellow
        $pythonProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
    }
    
    # Kill orphaned Java processes (development related)
    $javaProcesses = Get-Process -Name "java*", "javaw*" -ErrorAction SilentlyContinue
    if ($javaProcesses) {
        Write-Host "Found $($javaProcesses.Count) Java processes - terminating..." -ForegroundColor Yellow
        $javaProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
    }
    
    # Kill orphaned Git processes
    Get-Process -Name "git*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    
    # Clean up temporary files
    $tempDirs = @(
        "$env:TEMP",
        "$env:TMP",
        "$env:LOCALAPPDATA\Temp"
    )
    
    foreach ($tempDir in $tempDirs) {
        if (Test-Path $tempDir) {
            try {
                Get-ChildItem $tempDir -Force -Recurse -ErrorAction SilentlyContinue | 
                Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-7) } | 
                Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            } catch {
                # Ignore errors for locked files
            }
        }
    }
    
    # Force garbage collection
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    [System.GC]::Collect()
    
    Clear-Host
    Write-Host "Development cleanup completed!" -ForegroundColor Green
}

# System cleanup - more comprehensive
function clean-system {
    Write-Host "Starting comprehensive system cleanup..." -ForegroundColor Cyan
    
    # Run dev cleanup first
    clean-dev
    
    # Clean Windows Update cache
    Write-Host "Cleaning Windows Update cache..." -ForegroundColor Yellow
    Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service wuauserv -ErrorAction SilentlyContinue
    
    # Clean DNS cache
    Write-Host "Flushing DNS cache..." -ForegroundColor Yellow
    ipconfig /flushdns | Out-Null
    
    # Clean prefetch
    Write-Host "Cleaning prefetch files..." -ForegroundColor Yellow
    Remove-Item "C:\Windows\Prefetch\*.pf" -Force -ErrorAction SilentlyContinue
    
    Write-Host "System cleanup completed!" -ForegroundColor Green
}

# Show running development processes
function show-dev-processes {
    Write-Host "Development-related processes:" -ForegroundColor Cyan
    Get-Process | Where-Object { 
        $_.ProcessName -match 'node|npm|yarn|electron|code|python|java|git|docker|chrome' -and
        $_.WorkingSet -gt 10MB
    } | Select-Object ProcessName, Id, @{Name='Memory(MB)';Expression={[math]::Round($_.WorkingSet/1MB,2)}}, StartTime | 
    Sort-Object 'Memory(MB)' -Descending | Format-Table -AutoSize
}

# Kill specific process by name
function kill-process {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ProcessName
    )
    
    $processes = Get-Process -Name "*$ProcessName*" -ErrorAction SilentlyContinue
    if ($processes) {
        Write-Host "Killing $($processes.Count) process(es) matching '$ProcessName'..." -ForegroundColor Yellow
        $processes | Stop-Process -Force -ErrorAction SilentlyContinue
        Write-Host "Done!" -ForegroundColor Green
    } else {
        Write-Host "No processes found matching '$ProcessName'" -ForegroundColor Yellow
    }
}

# =============================================================================
# CUSTOM ALIASES
# =============================================================================

# ls alias - long format sorted by date (newest first)
function ls {
    Get-ChildItem @args | Sort-Object -Property LastWriteTime -Descending | Format-Table Mode, LastWriteTime, Length, Name -AutoSize
}

# Alternative ll alias for the same functionality
Set-Alias -Name ll -Value ls

# =============================================================================
# WARP TERMINAL SAFETY - Prevent accidental exits
# =============================================================================

# Override exit command to confirm before closing
function exit {
    param([int]$ExitCode = 0)
    
    $confirmation = Read-Host "Are you sure you want to exit? This will end your Warp AI session! (y/n)"
    if ($confirmation -eq 'y') {
        Microsoft.PowerShell.Management\Exit-PSSession
        [Environment]::Exit($ExitCode)
    } else {
        Write-Host "Exit cancelled. Your session continues." -ForegroundColor Green
    }
}

# Create a safe exit alias that doesn't prompt
function exit-force {
    param([int]$ExitCode = 0)
    [Environment]::Exit($ExitCode)
}

# Create an alias to clear without exiting
Set-Alias -Name cls -Value Clear-Host -Force
Set-Alias -Name clear -Value Clear-Host -Force
