# update-knowledge.ps1 — Reindexar conhecimento da AI Software Factory
# Execute sempre que alterar knowledge/, skills/, schemas/, templates/, examples/, bibliography/

$ErrorActionPreference = "Stop"
$FACTORY_PATH = if ($env:FACTORY_ROOT) { $env:FACTORY_ROOT } else { (Get-Location).Path }
if (-not (Test-Path (Join-Path $FACTORY_PATH "install.ps1"))) {
    Write-Error "FACTORY_ROOT nao aponta para a factory. Execute install.ps1 primeiro."; exit 1
}
$CONFIG_PATH  = Join-Path $FACTORY_PATH "knowledge-config.json"
$INGEST_PATH  = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\ingest.py"
if (-not (Test-Path $CONFIG_PATH))  { Write-Error "knowledge-config.json nao encontrado. Execute install.ps1."; exit 1 }
if (-not (Test-Path $INGEST_PATH))  { Write-Error "ingest.py nao encontrado."; exit 1 }
$pythonCmd = "python"
foreach ($cmd in @("python","python3","py")) {
    try { $v = & $cmd --version 2>&1; if ($LASTEXITCODE -eq 0) { $pythonCmd = $cmd; break } } catch {}
}
Write-Host "Reindexando conhecimento da AI Software Factory..." -ForegroundColor Cyan
Write-Host "Factory: $FACTORY_PATH" -ForegroundColor DarkGray
$DB_PATH   = Join-Path $FACTORY_PATH "knowledge.db"
$dbTemp    = "$DB_PATH.tmp"
$cfgTemp   = Join-Path $FACTORY_PATH "knowledge-config.tmp.json"
$cfg = Get-Content $CONFIG_PATH | ConvertFrom-Json
$cfg | Add-Member -Force -NotePropertyName "db_path" -NotePropertyValue $dbTemp
$cfg | ConvertTo-Json -Depth 5 | Set-Content $cfgTemp -Encoding UTF8
& $pythonCmd $INGEST_PATH --config $cfgTemp
if ($LASTEXITCODE -eq 0 -and (Test-Path $dbTemp)) {
    if (Test-Path $DB_PATH) { Remove-Item $DB_PATH -Force }
    Move-Item $dbTemp $DB_PATH -Force
    Remove-Item $cfgTemp -Force -ErrorAction SilentlyContinue
    Write-Host "[OK] knowledge.db atualizado." -ForegroundColor Green
} else {
    if (Test-Path $dbTemp)  { Remove-Item $dbTemp  -Force -ErrorAction SilentlyContinue }
    if (Test-Path $cfgTemp) { Remove-Item $cfgTemp -Force -ErrorAction SilentlyContinue }
    Write-Host "[FAIL] Falha ao reindexar." -ForegroundColor Red; exit 1
}