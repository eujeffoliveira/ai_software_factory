# test-mcp.ps1 — Validador de saude do MCP knowledge server
# Uso: .\test-mcp.ps1
# Exit code: 0 se tudo OK, 1 se qualquer ERROR

$ErrorActionPreference = "SilentlyContinue"

# ─── Utilitarios de output colorido ──────────────────────────────────────────
function Write-CheckOK($msg)   { Write-Host "[OK]    $msg" -ForegroundColor Green }
function Write-CheckWarn($msg) { Write-Host "[WARN]  $msg" -ForegroundColor Yellow }
function Write-CheckError($msg, $fix = "") {
    Write-Host "[ERROR] $msg" -ForegroundColor Red
    if ($fix) { Write-Host "        Fix: $fix" -ForegroundColor DarkYellow }
}

$hadError = $false

Write-Host ""
Write-Host "MCP Knowledge Health Check" -ForegroundColor Cyan
Write-Host "──────────────────────────" -ForegroundColor DarkGray
Write-Host ""

# ─── Check 1: FACTORY_ROOT ───────────────────────────────────────────────────
$factoryRoot = $env:FACTORY_ROOT
if (-not $factoryRoot) {
    $factoryRoot = (Get-Location).Path
    Write-CheckWarn "FACTORY_ROOT nao definido — usando CWD: $factoryRoot"
} else {
    Write-CheckOK "FACTORY_ROOT = $factoryRoot"
}

# ─── Check 2: server.py existe ───────────────────────────────────────────────
$serverPath = Join-Path $factoryRoot "tools\mcp-knowledge-search\server.py"
if (Test-Path $serverPath) {
    Write-CheckOK "server.py existe: $serverPath"
} else {
    Write-CheckError "server.py nao encontrado: $serverPath" "git clone ou reinstale a factory"
    $hadError = $true
}

# ─── Check 3: knowledge.db existe ────────────────────────────────────────────
$dbPath = Join-Path $factoryRoot "knowledge.db"
if (Test-Path $dbPath) {
    $dbSize = [math]::Round((Get-Item $dbPath).Length / 1MB, 2)
    Write-CheckOK "knowledge.db existe ($dbSize MB)"
} else {
    Write-CheckError "knowledge.db nao encontrado" "cd '$factoryRoot' && .\update-knowledge.ps1"
    $hadError = $true
}

# ─── Check 4: Python no PATH ─────────────────────────────────────────────────
$pythonCmd = $null
foreach ($cmd in @("python", "python3", "py")) {
    try {
        $ver = & $cmd --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            $pythonCmd = $cmd
            Write-CheckOK "Python encontrado: $cmd ($($ver.ToString().Trim()))"
            break
        }
    } catch {}
}
if (-not $pythonCmd) {
    Write-CheckError "Python nao encontrado no PATH" "Instale Python 3.x e adicione ao PATH"
    $hadError = $true
}

# ─── Check 5: pacote mcp instalado ───────────────────────────────────────────
if ($pythonCmd) {
    $mcpCheck = & $pythonCmd -m pip show mcp 2>&1
    if ($LASTEXITCODE -eq 0) {
        $mcpVer = ($mcpCheck | Select-String "^Version:") -replace "Version:\s*", ""
        Write-CheckOK "Pacote mcp instalado (v$($mcpVer.Trim()))"
    } else {
        Write-CheckError "Pacote mcp nao instalado" "cd '$factoryRoot' && .\install.ps1 -ForceDeps"
        $hadError = $true
    }
}

# ─── Check 6: test_health.py roda com exit 0 ─────────────────────────────────
$testHealthPath = Join-Path $factoryRoot "tools\mcp-knowledge-search\test_health.py"
if ($pythonCmd -and (Test-Path $testHealthPath)) {
    $healthOutput = & $pythonCmd $testHealthPath --db $dbPath 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-CheckOK "test_health.py passou (DB integro)"
    } else {
        Write-CheckError "test_health.py falhou — DB com problemas" "cd '$factoryRoot' && .\update-knowledge.ps1"
        # Mostrar output do test_health para detalhe
        $healthOutput | ForEach-Object {
            if ($_ -match "^\[ERROR\]") {
                Write-Host "        $_" -ForegroundColor Red
            }
        }
        $hadError = $true
    }
} elseif (-not (Test-Path $testHealthPath)) {
    Write-CheckWarn "test_health.py nao encontrado — pulando verificacao detalhada do DB"
}

# ─── Check 7: import do modulo database ──────────────────────────────────────
if ($pythonCmd -and (Test-Path $serverPath)) {
    $dbModulePath = Join-Path $factoryRoot "tools\mcp-knowledge-search"
    $importTest = & $pythonCmd -c "import sys; sys.path.insert(0,'$($dbModulePath -replace '\\','/')'); from database import get_connection, search, search_filtered, get_document, get_related, get_stats; print('ok')" 2>&1
    if ($LASTEXITCODE -eq 0 -and ($importTest | Select-String "^ok")) {
        Write-CheckOK "Modulo database importa corretamente"
    } else {
        Write-CheckError "Falha ao importar modulo database" "Verifique tools\mcp-knowledge-search\database.py"
        $hadError = $true
    }
}

# ─── Check 8: Codex project config nao aponta para cwd errado ────────────────
$projectCodexConfig = Join-Path $factoryRoot ".codex\config.toml"
if (Test-Path $projectCodexConfig) {
    $codexRaw = Get-Content $projectCodexConfig -Raw -Encoding UTF8
    $hasKnowledgeMcp = $codexRaw -match "(?m)^\s*\[mcp_servers\.knowledge\]\s*$"
    if ($hasKnowledgeMcp -and ($codexRaw -match '(?m)^\s*cwd\s*=\s*"\.\."\s*$')) {
        Write-CheckError "Codex project config usa cwd = `"..`", que quebra o startup a partir da raiz do repo" "cd '$factoryRoot' && .\install.ps1"
        $hadError = $true
    } elseif ($hasKnowledgeMcp) {
        Write-CheckOK "Codex project config contem MCP knowledge sem cwd legado"
    } else {
        Write-CheckWarn ".codex/config.toml existe, mas nao contem [mcp_servers.knowledge]"
    }
} else {
    Write-CheckWarn ".codex/config.toml nao encontrado — execute .\install.ps1 para habilitar MCP no Codex"
}

# ─── Check 9: handshake MCP real + list_tools ────────────────────────────────
$mcpToolsTestPath = Join-Path $factoryRoot "tools\mcp-knowledge-search\test_mcp_tools.py"
if ($pythonCmd -and (Test-Path $mcpToolsTestPath) -and (Test-Path $serverPath) -and (Test-Path $dbPath)) {
    $toolsOutput = & $pythonCmd $mcpToolsTestPath --factory-root $factoryRoot 2>&1
    if ($LASTEXITCODE -eq 0) {
        $toolsLine = ($toolsOutput | Select-String "^TOOLS:" | Select-Object -First 1).Line
        if ($toolsLine) {
            $toolNames = $toolsLine -replace "^TOOLS:\s*", ""
            Write-CheckOK "MCP list_tools passou ($toolNames)"
        } else {
            Write-CheckOK "MCP list_tools passou"
        }
    } else {
        Write-CheckError "MCP list_tools falhou — Codex provavelmente mostrara Tools: (none)" "cd '$factoryRoot' && .\install.ps1 -ForceDeps"
        $toolsOutput | Select-Object -First 8 | ForEach-Object {
            Write-Host "        $_" -ForegroundColor Red
        }
        $hadError = $true
    }
} elseif (-not (Test-Path $mcpToolsTestPath)) {
    Write-CheckWarn "test_mcp_tools.py nao encontrado — pulando verificacao MCP list_tools"
}

# ─── Resumo ───────────────────────────────────────────────────────────────────
Write-Host ""
if ($hadError) {
    Write-Host "[FAIL]  Um ou mais checks falharam — MCP pode nao funcionar" -ForegroundColor Red
    Write-Host "        Execute: cd '$factoryRoot' && .\install.ps1" -ForegroundColor DarkYellow
    exit 1
} else {
    Write-Host "[OK]    Todos os checks passaram — MCP knowledge server esta pronto" -ForegroundColor Green
    exit 0
}
