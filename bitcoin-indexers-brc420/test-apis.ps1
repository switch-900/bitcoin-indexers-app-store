# BRC-420 & Bitmap Indexer - API Connectivity Test
# PowerShell version

Write-Host "BRC-420 & Bitmap Indexer - API Connectivity Test" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Testing all API endpoints to identify 406 errors..."
Write-Host ""

# Test URLs - using external hostnames that work from host machine  
$LOCAL_ORD_API = "http://umbrel.local:4000"
$LOCAL_MEMPOOL_API = "http://umbrel.local:3006/api"
$FALLBACK_API = "https://ordinals.com"
$LOCAL_APP_API = "http://localhost:8080/api"

function Test-Endpoint {
    param(
        [string]$Url,
        [string]$Description,
        [string]$ExpectedContent = ""
    )
    
    Write-Host "Testing $Description... " -NoNewline
    
    try {
        $headers = @{
            'Accept' = 'application/json'
            'User-Agent' = 'BRC-420-Complete-Indexer/1.0'
        }
        
        $response = Invoke-WebRequest -Uri $Url -Headers $headers -TimeoutSec 30 -UseBasicParsing -ErrorAction Stop
        
        if ($response.StatusCode -eq 200) {
            Write-Host "OK (200)" -ForegroundColor Green
            if ($ExpectedContent -and $response.Content -like "*$ExpectedContent*") {
                Write-Host "   Content validation: Found expected content" -ForegroundColor Green
            }
        }
        
        # Show response preview
        if ($response.Content.Length -gt 10) {
            $preview = $response.Content.Substring(0, [Math]::Min(100, $response.Content.Length))
            Write-Host "   Response preview: $preview..." -ForegroundColor Gray
        }
    }
    catch {
        $statusCode = $null
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode.Value__
        }
        
        if ($statusCode -eq 406) {
            Write-Host "406 NOT ACCEPTABLE" -ForegroundColor Red
            Write-Host "   This is the source of our errors!" -ForegroundColor Red
        }
        elseif ($statusCode -eq 404) {
            Write-Host "404 NOT FOUND" -ForegroundColor Yellow
        }
        elseif ($null -eq $statusCode) {
            Write-Host "CONNECTION FAILED" -ForegroundColor Red
            Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
        }
        else {
            Write-Host "HTTP $statusCode" -ForegroundColor Yellow
            Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
    
    Write-Host ""
}

function Test-Headers {
    param(
        [string]$Url,
        [string]$Description
    )
    
    Write-Host "Testing $Description with different Accept headers:" -ForegroundColor Cyan
    Write-Host "URL: $Url" -ForegroundColor Gray
    
    $acceptHeaders = @("application/json", "text/html", "*/*", "text/plain")
    
    foreach ($acceptHeader in $acceptHeaders) {
        Write-Host "  Accept: $acceptHeader ... " -NoNewline
        
        try {
            $headers = @{
                'Accept' = $acceptHeader
                'User-Agent' = 'BRC-420-Complete-Indexer/1.0'
            }
            
            $response = Invoke-WebRequest -Uri $Url -Headers $headers -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
            Write-Host "OK $($response.StatusCode)" -ForegroundColor Green
        }
        catch {
            $statusCode = $null
            if ($_.Exception.Response) {
                $statusCode = $_.Exception.Response.StatusCode.Value__
            }
            if ($statusCode -eq 406) {
                Write-Host "$statusCode (NOT ACCEPTABLE)" -ForegroundColor Red
            }
            else {
                Write-Host "$statusCode" -ForegroundColor Yellow
            }
        }
    }
    Write-Host ""
}

# Test Local App API first (should always work)
Write-Host "🌐 Testing Local App API (localhost:8080)" -ForegroundColor Blue
Write-Host "==========================================" -ForegroundColor Blue
Test-Endpoint "$LOCAL_APP_API/health" "Health check"
Test-Endpoint "$LOCAL_APP_API/config" "Configuration"
Test-Endpoint "$LOCAL_APP_API/bitmaps/summary" "Bitmaps summary"

# Test Local Ordinals API
Write-Host "🌐 Testing Local Ordinals API (umbrel.local:4000)" -ForegroundColor Blue
Write-Host "================================================" -ForegroundColor Blue
Test-Endpoint "$LOCAL_ORD_API/" "Root endpoint"
Test-Endpoint "$LOCAL_ORD_API/blockheight" "Block height endpoint"
Test-Endpoint "$LOCAL_ORD_API/inscriptions" "Inscriptions list"
Test-Endpoint "$LOCAL_ORD_API/inscription/d0865d9ee4bac83e9b4b7cf2304d27d68dd4eb25501ffa95bfb169b34ac76674i0" "Specific inscription"

# Test Local Mempool API
Write-Host "🌐 Testing Local Mempool API (umbrel.local:3006)" -ForegroundColor Blue
Write-Host "===============================================" -ForegroundColor Blue
Test-Endpoint "$LOCAL_MEMPOOL_API/" "Root endpoint"
Test-Endpoint "$LOCAL_MEMPOOL_API/blocks/tip/height" "Tip height endpoint"
Test-Endpoint "$LOCAL_MEMPOOL_API/block-height/830000" "Block height endpoint"

# Test Fallback API
Write-Host "🌐 Testing Fallback API (ordinals.com)" -ForegroundColor Blue
Write-Host "=======================================" -ForegroundColor Blue
Test-Endpoint "$FALLBACK_API/" "Root endpoint"
Test-Endpoint "$FALLBACK_API/inscription/d0865d9ee4bac83e9b4b7cf2304d27d68dd4eb25501ffa95bfb169b34ac76674i0" "Specific inscription"

# Detailed header testing
Write-Host "DETAILED API HEADERS TEST" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan
Test-Headers "$LOCAL_ORD_API/inscription/d0865d9ee4bac83e9b4b7cf2304d27d68dd4eb25501ffa95bfb169b34ac76674i0" "Local Ordinals Inscription"

# Docker container status
Write-Host "DOCKER CONTAINER STATUS" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan

try {
    $containers = docker ps --filter "name=ordinals" --filter "name=mempool" --format "table {{.Names}}`t{{.Status}}`t{{.Ports}}" 2>$null
    if ($containers) {
        Write-Host "Docker containers:" -ForegroundColor Green
        Write-Host $containers
    } else {
        Write-Host "No ordinals/mempool containers found" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Docker not available or containers not running" -ForegroundColor Red
}

Write-Host ""
Write-Host "SUMMARY AND RECOMMENDATIONS" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host "This test identifies:" -ForegroundColor White
Write-Host "- Which APIs are returning 406 errors" -ForegroundColor White
Write-Host "- Whether it's a header/content-type issue" -ForegroundColor White
Write-Host "- Network connectivity problems" -ForegroundColor White
Write-Host "- Service availability issues" -ForegroundColor White
Write-Host ""
Write-Host "Based on results, we can:" -ForegroundColor White
Write-Host "- Fix Accept headers in the indexer code" -ForegroundColor White
Write-Host "- Adjust API discovery logic" -ForegroundColor White
Write-Host "- Update endpoint URLs if needed" -ForegroundColor White
Write-Host "- Configure proper fallback handling" -ForegroundColor White
