# doctor.ps1 — Diagnostico geral da AI Software Factory
# Uso: .\doctor.ps1
# Exit code: 0 se OK (pode ter avisos), 1 se qualquer ERROR

$ErrorActionPreference = "SilentlyContinue"

# ─── Output helpers ──────────────────────────────────────────────────────────

function Write-CheckOK($msg)   { Write-Host "  [OK]    $msg" -ForegroundColor Green }
function Write-CheckWarn($msg) { Write-Host "  [WARN]  $msg" -ForegroundColor Yellow }
function Write-CheckError($msg, $fix = "") {
    Write-Host "  [ERROR] $msg" -ForegroundColor Red
    if ($fix) { Write-Host "          Fix: $fix" -ForegroundColor DarkYellow }
}
function Write-Section($title) {
    Write-Host ""
    Write-Host "  $title" -ForegroundColor Cyan
    Write-Host ("  " + "─" * $title.Length) -ForegroundColor DarkGray
    Write-Host ""
}

$hadError   = $false
$hadWarning = $false

# ─── Detectar factory root ───────────────────────────────────────────────────

$factoryRoot = $env:FACTORY_ROOT
if (-not $factoryRoot -or -not (Test-Path $factoryRoot)) {
    $factoryRoot = (Get-Location).Path
}

# ─── Header ──────────────────────────────────────────────────────────────────

$versionFile    = Join-Path $factoryRoot "VERSION"
$factoryVersion = if (Test-Path $versionFile) { (Get-Content $versionFile -Raw).Trim() } else { "desconhecida" }

Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "  ║      AI Software Factory — Doctor                ║" -ForegroundColor Blue
Write-Host "  ╚═══════════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""
Write-Host "  Factory : $factoryRoot" -ForegroundColor Gray
Write-Host "  Version : $factoryVersion" -ForegroundColor Gray
Write-Host ""

# ═════════════════════════════════════════════════════════════════════════════
#  1. FACTORY_ROOT
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "1. FACTORY_ROOT"

$frUser = [System.Environment]::GetEnvironmentVariable("FACTORY_ROOT", "User")
if ($frUser) {
    Write-CheckOK "FACTORY_ROOT (env usuario) = $frUser"
    if (-not (Test-Path $frUser)) {
        Write-CheckError "Diretorio em FACTORY_ROOT nao existe: $frUser" "Execute .\install.ps1 novamente a partir do diretorio correto"
        $hadError = $true
    } elseif ($frUser -ne $factoryRoot) {
        Write-CheckWarn "FACTORY_ROOT difere do CWD — usando: $factoryRoot"
        $hadWarning = $true
    }
} else {
    Write-CheckWarn "FACTORY_ROOT nao definido como variavel de usuario"
    Write-CheckWarn "          Fix: cd '$factoryRoot' && .\install.ps1"
    $hadWarning = $true
}

if ($env:FACTORY_ROOT) {
    Write-CheckOK "FACTORY_ROOT disponivel na sessao atual"
} else {
    Write-CheckWarn "FACTORY_ROOT ausente na sessao atual — abra um novo terminal apos install.ps1"
    $hadWarning = $true
}

if (Test-Path $factoryRoot) {
    Write-CheckOK "Diretorio factory existe"
} else {
    Write-CheckError "Diretorio factory nao encontrado: $factoryRoot" "Verifique o caminho ou execute install.ps1 novamente"
    $hadError = $true
}

# ═════════════════════════════════════════════════════════════════════════════
#  2. VERSAO
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "2. Versao"

if (Test-Path $versionFile) {
    Write-CheckOK "VERSION = $factoryVersion"
} else {
    Write-CheckWarn "Arquivo VERSION nao encontrado"
    $hadWarning = $true
}

$manifestPath = "$env:USERPROFILE\.claude\agents\.ai_software_factory_manifest.json"
if (Test-Path $manifestPath) {
    try {
        $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
        if ($manifest.factory_version) {
            if ($manifest.factory_version -eq $factoryVersion) {
                Write-CheckOK "Manifesto alinhado com VERSION ($($manifest.factory_version))"
            } else {
                Write-CheckWarn "Manifesto v$($manifest.factory_version) != VERSION v$factoryVersion — reinstale"
                $hadWarning = $true
            }
        } else {
            Write-CheckWarn "Campo factory_version ausente no manifesto — reinstale para atualizar"
            $hadWarning = $true
        }
        if ($manifest.installed_at) {
            Write-CheckOK "Instalado em: $($manifest.installed_at)"
        }
    } catch {
        Write-CheckWarn "Manifesto existe mas JSON invalido: $_"
        $hadWarning = $true
    }
} else {
    Write-CheckError "Manifesto nao encontrado em ~/.claude/agents/" "cd '$factoryRoot' && .\install.ps1"
    $hadError = $true
}

# ═════════════════════════════════════════════════════════════════════════════
#  3. PYTHON
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "3. Python"

$pythonCmd = $null
foreach ($cmd in @("python", "python3", "py")) {
    try {
        $ver = & $cmd --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            $pythonCmd = $cmd
            Write-CheckOK "$cmd $($ver.ToString().Trim())"
            break
        }
    } catch {}
}
if (-not $pythonCmd) {
    Write-CheckError "Python nao encontrado no PATH" "Instale Python 3.x em python.org e adicione ao PATH"
    $hadError = $true
}

if ($pythonCmd) {
    $mcpCheck = & $pythonCmd -m pip show mcp 2>&1
    if ($LASTEXITCODE -eq 0) {
        $mcpVer = ($mcpCheck | Select-String "^Version:") -replace "Version:\s*", ""
        Write-CheckOK "Pacote mcp instalado (v$($mcpVer.ToString().Trim()))"
    } else {
        Write-CheckError "Pacote mcp nao instalado" "cd '$factoryRoot' && .\install.ps1 -ForceDeps"
        $hadError = $true
    }
}

# ═════════════════════════════════════════════════════════════════════════════
#  4. CLAUDE CODE
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "4. Claude Code"

try {
    $claudeVer = & claude --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-CheckOK "Claude Code: $($claudeVer.ToString().Trim())"
    } else {
        Write-CheckWarn "claude --version retornou erro (pode ser versao sem --version)"
        $hadWarning = $true
    }
} catch {
    Write-CheckWarn "Claude Code nao encontrado no PATH (opcional para diagnostico)"
    $hadWarning = $true
}

# ═════════════════════════════════════════════════════════════════════════════
#  5. ROO CODE / CLINE
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "5. Roo Code / Cline"

$rooExtPaths = @(
    "$env:APPDATA\Code\User\globalStorage\rooveterinaryinc.roo-cline",
    "$env:APPDATA\Code\User\globalStorage\RooVeterinaryInc.roo-cline"
)
$rooDetected = $false
foreach ($rooPath in $rooExtPaths) {
    if (Test-Path $rooPath) {
        Write-CheckOK "Roo Code detectado: $rooPath"
        $rooDetected = $true

        # Verificar mcp_settings.json
        $rooMcp = Join-Path $rooPath "settings\mcp_settings.json"
        if (Test-Path $rooMcp) {
            try {
                $rooSettings = Get-Content $rooMcp -Raw | ConvertFrom-Json
                if ($rooSettings.mcpServers.knowledge) {
                    Write-CheckOK "mcpServers.knowledge configurado em Roo mcp_settings.json"
                } else {
                    Write-CheckWarn "mcpServers.knowledge ausente em Roo mcp_settings.json"
                    Write-CheckWarn "          Fix: cd '$factoryRoot' && .\install.ps1"
                    $hadWarning = $true
                }
            } catch {
                Write-CheckWarn "mcp_settings.json invalido: $_"
                $hadWarning = $true
            }
        } else {
            Write-CheckWarn "mcp_settings.json nao encontrado em Roo settings"
            $hadWarning = $true
        }
        break
    }
}
if (-not $rooDetected) {
    Write-CheckWarn "Roo Code/Cline nao detectado (extensao VS Code — opcional)"
    $hadWarning = $true
}

# ═════════════════════════════════════════════════════════════════════════════
#  6. CLAUDE AGENTS
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "6. Claude Code — Agentes"

$claudeAgentsDir = "$env:USERPROFILE\.claude\agents"
$agentNames = @("techlead","po","architect","engineer","devbackend","devfrontend","qa","devsecops","devops","uxui","dataengineer")

if (Test-Path $claudeAgentsDir) {
    Write-CheckOK "Diretorio ~/.claude/agents/ existe"
} else {
    Write-CheckError "~/.claude/agents/ nao encontrado" "cd '$factoryRoot' && .\install.ps1"
    $hadError = $true
}

$agentsMissing  = @()
$agentsNoMarker = @()
$agentsOK       = @()

foreach ($name in $agentNames) {
    $file = Join-Path $claudeAgentsDir "$name.md"
    if (-not (Test-Path $file)) {
        $agentsMissing += $name
    } elseif (-not (Select-String -Path $file -Pattern "AUTO-GENERATED BY ai_software_factory" -Quiet -ErrorAction SilentlyContinue)) {
        $agentsNoMarker += $name
    } else {
        $agentsOK += $name
    }
}

if ($agentsOK.Count -eq 11) {
    Write-CheckOK "Todos os 11 agentes instalados com marcador AUTO-GENERATED"
} else {
    if ($agentsOK.Count -gt 0) {
        Write-CheckOK "$($agentsOK.Count)/11 agentes OK"
    }
    if ($agentsMissing.Count -gt 0) {
        Write-CheckError "Agentes ausentes ($($agentsMissing.Count)): $($agentsMissing -join ', ')" "cd '$factoryRoot' && .\install.ps1"
        $hadError = $true
    }
    if ($agentsNoMarker.Count -gt 0) {
        Write-CheckWarn "Agentes sem marcador AUTO-GENERATED (podem ser externos): $($agentsNoMarker -join ', ')"
        $hadWarning = $true
    }
}

# ═════════════════════════════════════════════════════════════════════════════
#  7. KNOWLEDGE DB
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "7. Knowledge Database"

$dbPath = Join-Path $factoryRoot "knowledge.db"
if (Test-Path $dbPath) {
    $dbSize = [math]::Round((Get-Item $dbPath).Length / 1MB, 2)
    Write-CheckOK "knowledge.db existe ($dbSize MB)"
} else {
    Write-CheckError "knowledge.db nao encontrado" "cd '$factoryRoot' && .\update-knowledge.ps1"
    $hadError = $true
}

# ═════════════════════════════════════════════════════════════════════════════
#  8. MCP HEALTH CHECK (via test-mcp.ps1)
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "8. MCP Health Check"

$testMcpPath = Join-Path $factoryRoot "test-mcp.ps1"
if (Test-Path $testMcpPath) {
    # Garantir que FACTORY_ROOT aponte para esta factory durante o check
    $savedEnv = $env:FACTORY_ROOT
    $env:FACTORY_ROOT = $factoryRoot
    try {
        & $testMcpPath 2>&1 | ForEach-Object {
            $line = $_.ToString()
            if ($line -match "^\[OK\]") {
                Write-Host "    $line" -ForegroundColor Green
            } elseif ($line -match "^\[WARN\]") {
                Write-Host "    $line" -ForegroundColor Yellow
            } elseif ($line -match "^\[ERROR\]|^\[FAIL\]") {
                Write-Host "    $line" -ForegroundColor Red
            } elseif ($line -match "^MCP Knowledge|^──────") {
                # header do test-mcp, omitir
            } else {
                Write-Host "    $line" -ForegroundColor Gray
            }
        }
        if ($LASTEXITCODE -eq 0) {
            Write-CheckOK "test-mcp.ps1 passou — MCP pronto"
        } else {
            Write-CheckError "test-mcp.ps1 falhou" "cd '$factoryRoot' && .\install.ps1 -ForceDeps"
            $hadError = $true
        }
    } catch {
        Write-CheckWarn "Nao foi possivel executar test-mcp.ps1: $_"
        $hadWarning = $true
    } finally {
        $env:FACTORY_ROOT = $savedEnv
    }
} else {
    Write-CheckError "test-mcp.ps1 nao encontrado" "git -C '$factoryRoot' checkout -- test-mcp.ps1"
    $hadError = $true
}

# ═════════════════════════════════════════════════════════════════════════════
#  9. MCP CONFIGURACAO
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "9. MCP Configuracao"

$claudeSettings = "$env:USERPROFILE\.claude.json"
if (Test-Path $claudeSettings) {
    try {
        $settings  = Get-Content $claudeSettings -Raw | ConvertFrom-Json
        $knowledge = $settings.mcpServers.knowledge
        if ($knowledge) {
            Write-CheckOK "mcpServers.knowledge configurado em ~/.claude.json"
            $configuredServer = if ($knowledge.args) { $knowledge.args[0] } else { "" }
            $expectedServer   = Join-Path $factoryRoot "tools\mcp-knowledge-search\server.py"
            if ($configuredServer -eq $expectedServer) {
                Write-CheckOK "server.py path correto em ~/.claude.json"
            } else {
                Write-CheckWarn "server.py em ~/.claude.json aponta para: $configuredServer"
                Write-CheckWarn "          Esperado: $expectedServer"
                Write-CheckWarn "          Fix: cd '$factoryRoot' && .\install.ps1"
                $hadWarning = $true
            }
        } else {
            Write-CheckError "mcpServers.knowledge ausente em ~/.claude.json" "cd '$factoryRoot' && .\install.ps1"
            $hadError = $true
        }
    } catch {
        Write-CheckWarn "Nao foi possivel ler ~/.claude.json: $_"
        $hadWarning = $true
    }
} else {
    Write-CheckError "~/.claude.json nao encontrado" "cd '$factoryRoot' && .\install.ps1"
    $hadError = $true
}

$mcpJson = Join-Path $factoryRoot ".mcp.json"
if (Test-Path $mcpJson) {
    Write-CheckOK ".mcp.json existe na raiz da factory"
} else {
    Write-CheckWarn ".mcp.json ausente (execute .\install.ps1)"
    $hadWarning = $true
}

# ═════════════════════════════════════════════════════════════════════════════
#  10. ROO CONFIGS
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "10. Roo Code — Configuracoes"

$rooModes = Join-Path $factoryRoot "roo\.roomodes"
$rooRules = Join-Path $factoryRoot "roo\.clinerules"

if (Test-Path $rooModes) {
    try {
        $modes = (Get-Content $rooModes -Raw | ConvertFrom-Json).customModes
        Write-CheckOK "roo/.roomodes existe ($($modes.Count) modos)"
    } catch {
        Write-CheckWarn "roo/.roomodes existe mas JSON invalido"
        $hadWarning = $true
    }
} else {
    Write-CheckWarn "roo/.roomodes nao encontrado — execute .\install.ps1 se usar Roo Code"
    $hadWarning = $true
}

if (Test-Path $rooRules) {
    Write-CheckOK "roo/.clinerules existe"
} else {
    Write-CheckWarn "roo/.clinerules nao encontrado"
    $hadWarning = $true
}

# ═════════════════════════════════════════════════════════════════════════════
#  11. PATHS NOS AGENTES GERADOS
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "11. Paths em agentes (FACTORY_ROOT)"

$staleAgents = @()
foreach ($name in $agentNames) {
    $file = Join-Path $claudeAgentsDir "$name.md"
    if (-not (Test-Path $file)) { continue }
    try {
        $content = Get-Content $file -Raw
        # Procura o bloco FACTORY_ROOT no mcpBlock
        if ($content -match "### FACTORY_ROOT\s*[\r\n]+\s*([^\r\n]+)") {
            $embeddedRoot = $Matches[1].Trim()
            if ($embeddedRoot -and ($embeddedRoot -ne $factoryRoot)) {
                $staleAgents += "$name (tem: $embeddedRoot)"
            }
        }
    } catch {}
}

if ($staleAgents.Count -gt 0) {
    Write-CheckWarn "Agentes com FACTORY_ROOT desatualizado (factory foi movida?):"
    $staleAgents | ForEach-Object { Write-CheckWarn "          $_" }
    Write-CheckWarn "          Fix: cd '$factoryRoot' && .\install.ps1"
    $hadWarning = $true
} else {
    Write-CheckOK "FACTORY_ROOT correto em todos os agentes instalados"
}

# ═════════════════════════════════════════════════════════════════════════════
#  12. SCRIPTS PRINCIPAIS
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "12. Scripts principais"

$requiredScripts = @{
    "install.ps1"          = "Instalador principal"
    "uninstall.ps1"        = "Desinstalador"
    "test-mcp.ps1"         = "Health check do MCP"
    "update-knowledge.ps1" = "Reindexador do knowledge"
    "doctor.ps1"           = "Diagnostico geral"
    "link-mcp.ps1"         = "Vinculador MCP por projeto"
    "link-roo.ps1"         = "Vinculador Roo por projeto"
}

foreach ($script in $requiredScripts.Keys) {
    $path = Join-Path $factoryRoot $script
    if (Test-Path $path) {
        Write-CheckOK "$script — $($requiredScripts[$script])"
    } else {
        Write-CheckError "$script nao encontrado" "git -C '$factoryRoot' checkout -- $script"
        $hadError = $true
    }
}

# ═════════════════════════════════════════════════════════════════════════════
#  13. PERMISSOES
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "13. Permissoes de escrita"

# ~/.claude/agents/
$testFile = Join-Path $claudeAgentsDir ".doctor_write_test"
try {
    [System.IO.File]::WriteAllText($testFile, "test", [System.Text.UTF8Encoding]::new($false))
    Remove-Item $testFile -Force
    Write-CheckOK "Escrita em ~/.claude/agents/ OK"
} catch {
    Write-CheckError "Sem permissao de escrita em ~/.claude/agents/" "Verifique permissoes do diretorio"
    $hadError = $true
}

# Factory root
$testFile2 = Join-Path $factoryRoot ".doctor_write_test"
try {
    [System.IO.File]::WriteAllText($testFile2, "test", [System.Text.UTF8Encoding]::new($false))
    Remove-Item $testFile2 -Force
    Write-CheckOK "Escrita em FACTORY_ROOT OK"
} catch {
    Write-CheckError "Sem permissao de escrita em FACTORY_ROOT" "Verifique permissoes de: $factoryRoot"
    $hadError = $true
}

# ═════════════════════════════════════════════════════════════════════════════
#  14. VARIAVEIS DE AMBIENTE NA SESSAO
# ═════════════════════════════════════════════════════════════════════════════
Write-Section "14. Variaveis de ambiente na sessao"

$envVars = @("FACTORY_ROOT")
foreach ($var in $envVars) {
    $val = [System.Environment]::GetEnvironmentVariable($var)
    if ($val) {
        Write-CheckOK "$var = $val"
    } else {
        Write-CheckWarn "$var nao disponivel nesta sessao — abra um novo terminal"
        $hadWarning = $true
    }
}

# ═════════════════════════════════════════════════════════════════════════════
#  RESUMO
# ═════════════════════════════════════════════════════════════════════════════
Write-Host ""
Write-Host "  ─────────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""

if ($hadError) {
    Write-Host "  [FAIL]  Problemas criticos encontrados — veja detalhes acima." -ForegroundColor Red
    Write-Host "          Corrija e execute: cd '$factoryRoot' && .\install.ps1" -ForegroundColor DarkYellow
    exit 1
} elseif ($hadWarning) {
    Write-Host "  [WARN]  Factory funcional com avisos — veja detalhes acima." -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "  [OK]    Factory saudavel — todos os checks passaram." -ForegroundColor Green
    exit 0
}
