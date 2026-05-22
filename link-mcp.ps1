# link-mcp.ps1 — Vincular MCP da factory ao projeto atual
# Uso: $env:FACTORY_ROOT\link-mcp.ps1

$ErrorActionPreference = "Stop"
$FACTORY_PATH = if ($env:FACTORY_ROOT) { $env:FACTORY_ROOT } else { Write-Error "FACTORY_ROOT nao definido."; exit 1 }
$SOURCE_MCP = Join-Path $FACTORY_PATH ".mcp.json"
$TARGET_MCP = Join-Path (Get-Location).Path ".mcp.json"
if (-not (Test-Path $SOURCE_MCP)) { Write-Error ".mcp.json nao encontrado. Execute install.ps1 primeiro."; exit 1 }
if (Test-Path $TARGET_MCP) {
    $bak = "$TARGET_MCP.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $TARGET_MCP $bak; Write-Host "  [BAK] $bak" -ForegroundColor DarkGray
}
Copy-Item $SOURCE_MCP $TARGET_MCP -Force
Write-Host "[OK] .mcp.json vinculado: $(Get-Location)" -ForegroundColor Green
Write-Host "     MCP knowledge search disponivel na proxima sessao Claude Code."