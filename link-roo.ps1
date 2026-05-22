# link-roo.ps1 — Vincular agentes Roo Code/Cline ao projeto atual
# Uso: $env:FACTORY_ROOT\link-roo.ps1

$ErrorActionPreference = "Stop"
$FACTORY_PATH = if ($env:FACTORY_ROOT) { $env:FACTORY_ROOT } else { Write-Error "FACTORY_ROOT nao definido."; exit 1 }
$projectRoot = (Get-Location).Path
$copied = 0
foreach ($src in @((Join-Path $FACTORY_PATH "roo\.roomodes"), (Join-Path $FACTORY_PATH "roo\.clinerules"))) {
    if (-not (Test-Path $src)) { continue }
    $tgt = Join-Path $projectRoot (Split-Path $src -Leaf)
    if (Test-Path $tgt) {
        $bak = "$tgt.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item $tgt $bak; Write-Host "  [BAK] $bak" -ForegroundColor DarkGray
    }
    Copy-Item $src $tgt -Force
    Write-Host "[OK] $(Split-Path $src -Leaf) -> $projectRoot" -ForegroundColor Green
    $copied++
}
if ($copied -eq 0) { Write-Error "Nenhum arquivo encontrado em roo/. Execute install.ps1 primeiro."; exit 1 }
Write-Host "Agentes: techlead po architect engineer devbackend devfrontend qa devsecops devops uxui dataengineer"