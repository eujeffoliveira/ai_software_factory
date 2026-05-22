# uninstall.ps1 — Remove tudo que foi instalado pelo install.ps1
# Uso: .\uninstall.ps1
# Execute a partir da raiz do repositorio ai_software_factory

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Write-Header($t) {
    Write-Host ""
    Write-Host "  $t" -ForegroundColor Cyan
    Write-Host ("  " + "─" * $t.Length) -ForegroundColor DarkGray
}
function Write-OK($m)   { Write-Host "  [OK]   $m" -ForegroundColor Green }
function Write-Skip($m) { Write-Host "  [SKIP] $m" -ForegroundColor DarkGray }
function Write-Warn($m) { Write-Host "  [WARN] $m" -ForegroundColor Yellow }

$FACTORY_PATH      = (Get-Location).Path
$CLAUDE_AGENTS_DIR = "$env:USERPROFILE\.claude\agents"
$CLAUDE_SETTINGS   = "$env:USERPROFILE\.claude\settings.json"
$BIN_DIR           = "$env:USERPROFILE\.local\bin"

$agentNames = @(
    "techlead", "po", "architect", "engineer", "devbackend",
    "devfrontend", "qa", "devsecops", "devops", "uxui", "dataengineer"
)

Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "  ║      AI Software Factory — Uninstaller           ║" -ForegroundColor Red
Write-Host "  ╚═══════════════════════════════════════════════════╝" -ForegroundColor Red
Write-Host ""
Write-Host "  Factory: $FACTORY_PATH" -ForegroundColor Gray
Write-Host ""

# ─── FACTORY_ROOT ────────────────────────────────────────────────────────────
Write-Header "FACTORY_ROOT"
$currentVal = [System.Environment]::GetEnvironmentVariable("FACTORY_ROOT", "User")
if ($currentVal) {
    [System.Environment]::SetEnvironmentVariable("FACTORY_ROOT", $null, "User")
    Remove-Item Env:\FACTORY_ROOT -ErrorAction SilentlyContinue
    Write-OK "Variavel de ambiente FACTORY_ROOT removida (era: $currentVal)"
} else {
    Write-Skip "FACTORY_ROOT nao estava definida"
}

# ─── Agentes Claude Code ──────────────────────────────────────────────────────
Write-Header "Claude Code — Agentes"
$removed = 0
foreach ($name in $agentNames) {
    $file = Join-Path $CLAUDE_AGENTS_DIR "$name.md"
    if (Test-Path $file) {
        Remove-Item $file -Force
        Write-OK "Removido: $name.md"
        $removed++
    } else {
        Write-Skip "Nao encontrado: $name.md"
    }
}
Write-Host "  ─────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  $removed agentes removidos de $CLAUDE_AGENTS_DIR" -ForegroundColor Gray

# ─── settings.json — remover mcpServers.knowledge ────────────────────────────
Write-Header "settings.json — MCP entry"
if (Test-Path $CLAUDE_SETTINGS) {
    try {
        $raw      = Get-Content $CLAUDE_SETTINGS -Raw -Encoding UTF8
        $settings = $raw | ConvertFrom-Json -AsHashtable

        if ($settings.ContainsKey("mcpServers") -and $settings["mcpServers"].ContainsKey("knowledge")) {
            $settings["mcpServers"].Remove("knowledge")

            # Se mcpServers ficou vazio, remove a chave inteira
            if ($settings["mcpServers"].Count -eq 0) {
                $settings.Remove("mcpServers")
            }

            $newJson     = $settings | ConvertTo-Json -Depth 5
            $tmpSettings = "$CLAUDE_SETTINGS.tmp"
            [System.IO.File]::WriteAllText($tmpSettings, ($newJson -replace "`r`n","`n"), $utf8NoBom)
            Move-Item $tmpSettings $CLAUDE_SETTINGS -Force
            Write-OK "mcpServers.knowledge removido de settings.json"
        } else {
            Write-Skip "mcpServers.knowledge nao encontrado em settings.json"
        }
    } catch {
        Write-Warn "Nao foi possivel ler/editar settings.json: $_"
    }
} else {
    Write-Skip "settings.json nao encontrado"
}

# ─── factory.ps1 ─────────────────────────────────────────────────────────────
Write-Header "factory.ps1"
$factoryScript = Join-Path $BIN_DIR "factory.ps1"
if (Test-Path $factoryScript) {
    Remove-Item $factoryScript -Force
    Write-OK "Removido: $factoryScript"
} else {
    Write-Skip "Nao encontrado: $factoryScript"
}

# ─── Arquivos gerados dentro do repositorio (gitignored) ──────────────────────
Write-Header "Arquivos gerados no repositorio"

$filesToRemove = @(
    "knowledge.db",
    "knowledge.db.bak",
    "knowledge-config.json",
    ".mcp.json",
    "tools\mcp-knowledge-search\.requirements.hash"
)

foreach ($rel in $filesToRemove) {
    $full = Join-Path $FACTORY_PATH $rel
    if (Test-Path $full) {
        Remove-Item $full -Force
        Write-OK "Removido: $rel"
    } else {
        Write-Skip "Nao encontrado: $rel"
    }
}

$rooDir = Join-Path $FACTORY_PATH "roo"
if (Test-Path $rooDir) {
    Remove-Item $rooDir -Recurse -Force
    Write-OK "Removido: roo/"
} else {
    Write-Skip "Nao encontrado: roo/"
}

# ─── Restaurar arquivos rastreados pelo git ───────────────────────────────────
Write-Header "Restaurar arquivos via git"
$trackedFiles = @("update-knowledge.ps1", "link-mcp.ps1", "link-roo.ps1")
foreach ($f in $trackedFiles) {
    $full = Join-Path $FACTORY_PATH $f
    if (Test-Path $full) {
        try {
            git -C $FACTORY_PATH checkout -- $f 2>&1 | Out-Null
            Write-OK "Restaurado: $f (git checkout)"
        } catch {
            Write-Warn "Nao foi possivel restaurar $f via git: $_"
        }
    } else {
        Write-Skip "Nao encontrado no disco: $f"
    }
}

# ─── Dependencias Python ──────────────────────────────────────────────────────
Write-Header "Dependencias Python"
$REQUIREMENTS_PATH = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\requirements.txt"
$pythonCmd = $null
foreach ($cmd in @("python", "python3", "py")) {
    try {
        $ver = & $cmd --version 2>&1
        if ($LASTEXITCODE -eq 0) { $pythonCmd = $cmd; break }
    } catch {}
}

if ($pythonCmd -and (Test-Path $REQUIREMENTS_PATH)) {
    Write-Host "  Desinstalando pacotes de $REQUIREMENTS_PATH..." -ForegroundColor DarkGray
    & $pythonCmd -m pip uninstall -r $REQUIREMENTS_PATH -y -q 2>&1 | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }
    if ($LASTEXITCODE -eq 0) {
        Write-OK "Pacotes desinstalados"
    } else {
        Write-Warn "Alguns pacotes podem nao ter sido removidos"
    }
} elseif (-not $pythonCmd) {
    Write-Skip "Python nao encontrado — nada a desinstalar"
} else {
    Write-Skip "requirements.txt nao encontrado"
}

# ─── Resumo ───────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║             Desinstalacao concluida              ║" -ForegroundColor Green
Write-Host "  ╚═══════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "  O que foi removido:" -ForegroundColor Gray
Write-Host "    - Variavel FACTORY_ROOT"
Write-Host "    - ~/.claude/agents/ (11 agentes da factory)"
Write-Host "    - mcpServers.knowledge em ~/.claude/settings.json"
Write-Host "    - ~/.local/bin/factory.ps1"
Write-Host "    - knowledge.db, knowledge-config.json, .mcp.json, roo/"
Write-Host "    - .requirements.hash"
Write-Host "    - Pacotes Python do requirements.txt"
Write-Host "    - update-knowledge.ps1, link-mcp.ps1, link-roo.ps1 restaurados via git"
Write-Host ""
Write-Host "  Para reinstalar, siga as instrucoes do README.md:" -ForegroundColor Cyan
Write-Host "    .\install.ps1"
Write-Host ""
