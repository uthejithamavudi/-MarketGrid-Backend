# ============================================================
# MarketGrid - Stop All Services
# Usage: .\stop-all.ps1
# ============================================================

Write-Host ""
Write-Host "Stopping all MarketGrid services..." -ForegroundColor Red
Write-Host ""

# Stop PowerShell background jobs
$jobNames = @("EUREKA", "GATEWAY", "AUTH", "PRODUCT", "VENDOR", "ORDER", "NOTIFICATION")
foreach ($name in $jobNames) {
    $job = Get-Job -Name $name -ErrorAction SilentlyContinue
    if ($job) {
        Stop-Job -Name $name -ErrorAction SilentlyContinue
        Remove-Job -Name $name -Force -ErrorAction SilentlyContinue
        Write-Host "  [STOPPED] $name" -ForegroundColor Yellow
    }
}

# Also kill by port (fallback)
$ports = @(8761, 8080, 8081, 8082, 8083, 8084, 8085)
foreach ($port in $ports) {
    $result = netstat -ano | Select-String ":$port\s"
    if ($result) {
        $procId = ($result -split '\s+')[-1]
        if ($procId -and $procId -match '^\d+$' -and $procId -ne "0") {
            Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
        }
    }
}

Write-Host ""
Write-Host "All MarketGrid services stopped!" -ForegroundColor Green
Write-Host ""
