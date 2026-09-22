# ============================================================
# MarketGrid - Start All Services (Single Terminal Mode)
# Usage: .\start-all.ps1
# All services run in background jobs - same terminal!
# ============================================================

$Root = $PSScriptRoot

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  MarketGrid Backend - Starting All      " -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Load .env file
$EnvFile = Join-Path $Root ".env"
if (Test-Path $EnvFile) {
    Write-Host "[.env] Loading environment variables..." -ForegroundColor Yellow
    Get-Content $EnvFile | Where-Object { $_ -match '^\w' } | ForEach-Object {
        $parts = $_ -split '=', 2
        [System.Environment]::SetEnvironmentVariable($parts[0], $parts[1], 'Process')
    }
    Write-Host "[.env] Loaded!" -ForegroundColor Green
} else {
    Write-Host "[WARN] .env not found. Using defaults." -ForegroundColor Yellow
}

# ─── Build all services ───────────────────────────────────────────────────────
Write-Host ""
Write-Host "[BUILD] Building all services (this takes ~30s)..." -ForegroundColor Magenta
Push-Location $Root
mvn clean package -DskipTests -q
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Build FAILED! Fix errors and try again." -ForegroundColor Red
    Pop-Location
    exit 1
}
Pop-Location
Write-Host "[BUILD] All JARs built successfully!" -ForegroundColor Green
Write-Host ""

# ─── Helper: Get JAR path ─────────────────────────────────────────────────────
function Get-Jar {
    param([string]$Dir)
    Get-Item (Join-Path $Dir "target\*.jar") -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -notlike "*.original" } |
        Select-Object -First 1 -ExpandProperty FullName
}

# ─── Capture current env vars to pass to jobs ─────────────────────────────────
$envVars = @{
    MONGODB_URI              = [System.Environment]::GetEnvironmentVariable('MONGODB_URI', 'Process')
    JWT_SECRET               = [System.Environment]::GetEnvironmentVariable('JWT_SECRET', 'Process')
    JWT_EXPIRATION_MS        = [System.Environment]::GetEnvironmentVariable('JWT_EXPIRATION_MS', 'Process')
    JWT_REFRESH_EXPIRATION_MS= [System.Environment]::GetEnvironmentVariable('JWT_REFRESH_EXPIRATION_MS', 'Process')
    MAIL_HOST                = [System.Environment]::GetEnvironmentVariable('MAIL_HOST', 'Process')
    MAIL_PORT                = [System.Environment]::GetEnvironmentVariable('MAIL_PORT', 'Process')
    MAIL_USERNAME            = [System.Environment]::GetEnvironmentVariable('MAIL_USERNAME', 'Process')
    MAIL_PASSWORD            = [System.Environment]::GetEnvironmentVariable('MAIL_PASSWORD', 'Process')
    FRONTEND_URL             = [System.Environment]::GetEnvironmentVariable('FRONTEND_URL', 'Process')
    EUREKA_SERVER_URL        = 'http://localhost:8761/eureka'
}

# ─── Start a service as background job ───────────────────────────────────────
function Start-Svc {
    param(
        [string]$Name,
        [string]$JarPath,
        [hashtable]$Env
    )
    Start-Job -Name $Name -ScriptBlock {
        param($jar, $env)
        foreach ($k in $env.Keys) {
            [System.Environment]::SetEnvironmentVariable($k, $env[$k], 'Process')
        }
        & java -Xms64m -Xmx256m -jar $jar
    } -ArgumentList $JarPath, $Env | Out-Null
}

# ─── 1) Eureka Server ─────────────────────────────────────────────────────────
$eurekaJar = Get-Jar "$Root\eureka-server"
Write-Host "[1/7] Starting Eureka Server  (port 8761)..." -ForegroundColor Cyan
Start-Svc -Name "EUREKA" -JarPath $eurekaJar -Env $envVars
Write-Host "      Waiting 25s for Eureka to be ready..." -ForegroundColor Gray
Start-Sleep -Seconds 25

# ─── 2) API Gateway ───────────────────────────────────────────────────────────
$gatewayJar = Get-Jar "$Root\api-gateway"
Write-Host "[2/7] Starting API Gateway     (port 8080)..." -ForegroundColor Yellow
Start-Svc -Name "GATEWAY" -JarPath $gatewayJar -Env $envVars
Start-Sleep -Seconds 10

# ─── 3) Auth Service ──────────────────────────────────────────────────────────
$authJar = Get-Jar "$Root\auth-service"
Write-Host "[3/7] Starting Auth Service    (port 8081)..." -ForegroundColor Green
Start-Svc -Name "AUTH" -JarPath $authJar -Env $envVars
Start-Sleep -Seconds 5

# ─── 4) Product Service ───────────────────────────────────────────────────────
$productJar = Get-Jar "$Root\product-service"
Write-Host "[4/7] Starting Product Service (port 8082)..." -ForegroundColor Blue
Start-Svc -Name "PRODUCT" -JarPath $productJar -Env $envVars
Start-Sleep -Seconds 5

# ─── 5) Vendor Service ────────────────────────────────────────────────────────
$vendorJar = Get-Jar "$Root\vendor-service"
Write-Host "[5/7] Starting Vendor Service  (port 8083)..." -ForegroundColor Magenta
Start-Svc -Name "VENDOR" -JarPath $vendorJar -Env $envVars
Start-Sleep -Seconds 5

# ─── 6) Order Service ─────────────────────────────────────────────────────────
$orderJar = Get-Jar "$Root\order-service"
Write-Host "[6/7] Starting Order Service   (port 8084)..." -ForegroundColor DarkYellow
Start-Svc -Name "ORDER" -JarPath $orderJar -Env $envVars
Start-Sleep -Seconds 5

# ─── 7) Notification Service ──────────────────────────────────────────────────
$notifJar = Get-Jar "$Root\notification-service"
Write-Host "[7/7] Starting Notification    (port 8085)..." -ForegroundColor White
Start-Svc -Name "NOTIFICATION" -JarPath $notifJar -Env $envVars
Start-Sleep -Seconds 8

# ─── Summary ──────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "  All 7 Services Running! (Background)   " -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "  ┌─────────────────────────────────────────────┐" -ForegroundColor DarkGray
Write-Host "  │  Eureka Dashboard  →  http://localhost:8761  │" -ForegroundColor Cyan
Write-Host "  │  API Gateway       →  http://localhost:8080  │" -ForegroundColor Yellow
Write-Host "  │  Auth Service      →  http://localhost:8081  │" -ForegroundColor Green
Write-Host "  │  Product Service   →  http://localhost:8082  │" -ForegroundColor Blue
Write-Host "  │  Vendor Service    →  http://localhost:8083  │" -ForegroundColor Magenta
Write-Host "  │  Order Service     →  http://localhost:8084  │" -ForegroundColor DarkYellow
Write-Host "  │  Notification Svc  →  http://localhost:8085  │" -ForegroundColor White
Write-Host "  └─────────────────────────────────────────────┘" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Running Jobs:" -ForegroundColor White
Get-Job | Format-Table Name, State -AutoSize

Write-Host ""
Write-Host "  Useful commands:" -ForegroundColor White
Write-Host "  Get-Job                    → See all running services" -ForegroundColor Gray
Write-Host "  Receive-Job -Name AUTH     → See AUTH service logs" -ForegroundColor Gray
Write-Host "  Receive-Job -Name EUREKA   → See Eureka logs" -ForegroundColor Gray
Write-Host "  .\stop-all.ps1             → Stop all services" -ForegroundColor Gray
Write-Host ""
Write-Host "  Open Eureka Dashboard: http://localhost:8761" -ForegroundColor Cyan
Write-Host ""

# ─── Live log stream (press Ctrl+C to stop streaming, services keep running) ──
Write-Host "  Streaming logs (Ctrl+C to stop log view, services keep running)..." -ForegroundColor DarkGray
Write-Host ""

while ($true) {
    Get-Job | ForEach-Object {
        $output = Receive-Job -Job $_ -ErrorAction SilentlyContinue
        if ($output) {
            $color = switch ($_.Name) {
                "EUREKA"       { "Cyan" }
                "GATEWAY"      { "Yellow" }
                "AUTH"         { "Green" }
                "PRODUCT"      { "Blue" }
                "VENDOR"       { "Magenta" }
                "ORDER"        { "DarkYellow" }
                "NOTIFICATION" { "White" }
                default        { "Gray" }
            }
            $output | ForEach-Object { Write-Host "[$($_.PSObject.Properties['Name']?.Value ?? 'SVC')] $_" -ForegroundColor $color }
        }
    }
    Start-Sleep -Milliseconds 500
}
