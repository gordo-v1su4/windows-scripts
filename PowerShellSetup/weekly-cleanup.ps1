# Weekly Windows Cleanup Script
# Schedule this with Task Scheduler or run manually

Write-Host "Starting weekly system cleanup..." -ForegroundColor Cyan

# 1. Clear temp files
Write-Host "`n[1/7] Cleaning temp files..." -ForegroundColor Yellow
Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

# 2. Clear Windows Update cache
Write-Host "[2/7] Cleaning Windows Update cache..." -ForegroundColor Yellow
Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Service wuauserv -ErrorAction SilentlyContinue

# 3. Clear prefetch
Write-Host "[3/7] Cleaning prefetch..." -ForegroundColor Yellow
Remove-Item "C:\Windows\Prefetch\*" -Force -ErrorAction SilentlyContinue

# 4. Clear browser caches
Write-Host "[4/7] Cleaning browser caches..." -ForegroundColor Yellow
Remove-Item "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue

# 5. Clear npm cache
Write-Host "[5/7] Cleaning npm cache..." -ForegroundColor Yellow
if (Get-Command npm -ErrorAction SilentlyContinue) {
    npm cache clean --force 2>$null
}

# 6. Clear pip cache
Write-Host "[6/7] Cleaning pip cache..." -ForegroundColor Yellow
if (Get-Command pip -ErrorAction SilentlyContinue) {
    pip cache purge 2>$null
}

# 7. Disk Cleanup
Write-Host "[7/7] Running Windows Disk Cleanup..." -ForegroundColor Yellow
Start-Process cleanmgr -ArgumentList "/sagerun:1" -NoNewWindow -Wait -ErrorAction SilentlyContinue

Write-Host "`nCleanup complete!" -ForegroundColor Green
Write-Host "Freed up disk space. Consider rebooting if you haven't in a while." -ForegroundColor Cyan
