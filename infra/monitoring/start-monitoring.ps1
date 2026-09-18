Write-Host "Iniciando Stack de Monitoreo ENIAC Labs (Prometheus, Grafana, Loki, Node Exporter)..." -ForegroundColor Cyan

# 1. Windows Exporter (:9100)
Start-Process -FilePath ".\infra\monitoring\bin\node-exporter\windows_exporter.exe" -ArgumentList '--web.listen-address=":9100"' -WindowStyle Hidden
Write-Host "[OK] Node/Windows Exporter activo en http://localhost:9100/metrics" -ForegroundColor Green

# 2. Prometheus (:9090)
Start-Process -FilePath ".\infra\monitoring\bin\prometheus\prometheus.exe" -ArgumentList '--config.file=infra\monitoring\prometheus\prometheus.yml', '--storage.tsdb.path=infra\monitoring\bin\prometheus\data' -WindowStyle Hidden
Write-Host "[OK] Prometheus Server activo en http://localhost:9090" -ForegroundColor Green

# 3. Loki (:3100)
Start-Process -FilePath ".\infra\monitoring\bin\loki\loki-windows-amd64.exe" -ArgumentList '--config.file=infra\monitoring\loki\loki-config.yml' -WindowStyle Hidden
Write-Host "[OK] Grafana Loki activo en http://localhost:3100" -ForegroundColor Green

# 4. Grafana (:3000)
Start-Process -FilePath ".\infra\monitoring\bin\grafana\bin\grafana-server.exe" -ArgumentList '--homepath=infra\monitoring\bin\grafana' -WindowStyle Hidden
Write-Host "[OK] Grafana Server activo en http://localhost:3000 (admin/admin)" -ForegroundColor Green

Write-Host "
Stack de Observabilidad Completo Iniciado Correctamente!" -ForegroundColor Yellow