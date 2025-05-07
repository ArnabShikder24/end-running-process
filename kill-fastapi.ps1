$ports = @(8000, 8001) # Add more ports if needed
foreach ($port in $ports) {
    $processes = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | 
                Where-Object { $_.State -eq "Listen" }
    
    foreach ($proc in $processes) {
        try {
            Stop-Process -Id $proc.OwningProcess -Force -ErrorAction Stop
            Write-Host "✅ Killed process $($proc.OwningProcess) on port $port"
        } catch {
            Write-Host "[⚠️] Could not kill process $($proc.OwningProcess) on port $port - $($_.Exception.Message)"
        }
    }
}

taskkill /f /im python.exe /im uvicorn.exe 2>$null
Write-Host "`n✅ All Python/Uvicorn processes terminated."
