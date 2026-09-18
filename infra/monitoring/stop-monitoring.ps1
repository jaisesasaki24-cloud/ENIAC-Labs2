Write-Host "Deteniendo Stack de Monitoreo ENIAC Labs..." -ForegroundColor Yellow

 = @("windows_exporter", "prometheus", "loki-windows-amd64", "grafana-server")
foreach ( in ) {
    Get-Process -Name  -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "[STOP]  detenido."
}
Write-Host "Stack de Monitoreo Detenido." -ForegroundColor Cyan