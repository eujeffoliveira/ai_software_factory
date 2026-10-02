# doctor.ps1 - Diagnostico geral da AI Software Factory
# Uso: .\doctor.ps1
# Exit code: 0 se OK (pode ter avisos), 1 se qualquer ERROR

$ErrorActionPreference = "SilentlyContinue"

# --- Output helpers ----------------------------------------------------------

function Write-CheckOK($msg)   { Write-Host "  [OK]    $msg" -ForegroundColor Green }
function Write-CheckWarn($msg) { Write-Host "  [WARN]  $msg" -ForegroundColor Yellow }
function Write-CheckError($msg, $fix = "") {
    Write-Host "  [ERROR] $msg" -ForegroundColor Red
    if ($fix) { Write-Host "          Fix: $fix" -ForegroundColor DarkYellow }
}
function Write-Section($title) {
    Write-Host ""
    Write-Host "  $title" -ForegroundColor Cyan
    Write-Host ("  " + "-" * $title.Length) -ForegroundColor DarkGray
    Write-Host ""
}

$hadError   = $false
$hadWarning = $false

# --- Detectar factory root ---------------------------------------------------

$factoryRoot = $env:FACTORY_ROOT
if (-not $factoryRoot -or -not (Test-Path $factoryRoot)) {
    $factoryRoot = (Get-Location).Path
}

# --- Header ------------------------------------------------------------------

$versionFile    = Join-Path $factoryRoot "VERSION"
$factoryVersion = if (Test-Path $versionFile) { (Get-Content $versionFile -Raw).Trim() } else { "desconhecida" }
$codexHome      = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE ".codex" }
$codexAgentsDir = Join-Path $codexHome "agents"
$codexConfig    = Join-Path $codexHome "config.toml"
$projectCodexConfig = Join-Path $factoryRoot ".codex\config.toml"
$geminiConfigDir = Join-Path $env:USERPROFILE ".gemini\config"
$geminiPluginDir = Join-Path $geminiConfigDir "plugins\ai-software-factory"
$geminiSkillsDir = Join-Path $geminiPluginDir "skills"
$geminiMcpConfig = Join-Path $geminiConfigDir "mcp_config.json"
$copilotDir = Join-Path $factoryRoot ".github"
$copilotPromptsDir = Join-Path $copilotDir "prompts"
$copilotAgentsDir = Join-Path $copilotDir "agents"
$copilotUserDir = Join-Path $env:USERPROFILE ".copilot"
$copilotUserAgentsDir = Join-Path $copilotUserDir "agents"
$copilotUserManifestPath = Join-Path $copilotUserDir ".ai_software_factory_manifest.json"
$copilotInstructions = Join-Path $copilotDir "copilot-instructions.md"
$vscodeDir = Join-Path $factoryRoot ".vscode"
$vscodeMcpConfig = Join-Path $vscodeDir "mcp.json"
$vscodeExtensionsDir = if ($env:VSCODE_EXTENSIONS) { $env:VSCODE_EXTENSIONS } else { Join-Path $env:USERPROFILE ".vscode\extensions" }
$copilotExtDir = Join-Path $vscodeExtensionsDir "ai-software-factory.agents"
$copilotExtAgentsDir = Join-Path $copilotExtDir "agents"
$copilotExtPkg = Join-Path $copilotExtDir "package.json"
$vscodeUserDir = if ($env:APPDATA) { Join-Path $env:APPDATA "Code\User" } else { Join-Path $env:USERPROFILE ".config\Code\User" }
$vscodeGlobalMcp = Join-Path $vscodeUserDir "mcp.json"
$agentNames = @("techlead","po","architect","engineer","devbackend","devfrontend","qa","devsecops","devops","uxui","dataengineer","dataanalyst")
$expectedAgentCount = $agentNames.Count

Write-Host ""
Write-Host "  +===================================================+" -ForegroundColor Blue
Write-Host "  |      AI Software Factory - Doctor                |" -ForegroundColor Blue
Write-Host "  +===================================================+" -ForegroundColor Blue
Write-Host ""
Write-Host "  Factory : $factoryRoot" -ForegroundColor Gray
Write-Host "  Version : $factoryVersion" -ForegroundColor Gray
Write-Host ""

# =============================================================================
#  1. FACTORY_ROOT
# =============================================================================
Write-Section "1. FACTORY_ROOT"

$frUser = [System.Environment]::GetEnvironmentVariable("FACTORY_ROOT", "User")
if ($frUser) {
    Write-CheckOK "FACTORY_ROOT (env usuario) = $frUser"
    if (-not (Test-Path $frUser)) {
        Write-CheckError "Diretorio em FACTORY_ROOT nao existe: $frUser" "Execute .\install.ps1 novamente a partir do diretorio correto"
        $hadError = $true
    } elseif ($frUser -ne $factoryRoot) {
        Write-CheckWarn "FACTORY_ROOT difere do CWD - usando: $factoryRoot"
        $hadWarning = $true
    }
} else {
    Write-CheckWarn "FACTORY_ROOT nao definido como variavel de usuario"
    Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1"
    $hadWarning = $true
}

if ($env:FACTORY_ROOT) {
    Write-CheckOK "FACTORY_ROOT disponivel na sessao atual"
} else {
    Write-CheckWarn "FACTORY_ROOT ausente na sessao atual - abra um novo terminal apos install.ps1"
    $hadWarning = $true
}

if (Test-Path $factoryRoot) {
    Write-CheckOK "Diretorio factory existe"
} else {
    Write-CheckError "Diretorio factory nao encontrado: $factoryRoot" "Verifique o caminho ou execute install.ps1 novamente"
    $hadError = $true
}

# =============================================================================
#  2. VERSAO
# =============================================================================
Write-Section "2. Versao"

if (Test-Path $versionFile) {
    Write-CheckOK "VERSION = $factoryVersion"
} else {
    Write-CheckWarn "Arquivo VERSION nao encontrado"
    $hadWarning = $true
}

$claudeAgentsDir    = "$env:USERPROFILE\.claude\agents"
$manifestPath       = "$claudeAgentsDir\.ai_software_factory_manifest.json"
$codexManifestPath  = Join-Path $codexAgentsDir ".ai_software_factory_manifest.json"
$geminiManifestPath = Join-Path $geminiPluginDir ".ai_software_factory_manifest.json"
$copilotManifestPath    = Join-Path $copilotPromptsDir ".ai_software_factory_manifest.json"
$copilotExtManifestPath = Join-Path $copilotExtDir ".ai_software_factory_manifest.json"

$hasClaudeManifest       = Test-Path $manifestPath
$hasCodexManifest        = Test-Path $codexManifestPath
$hasAntigravityManifest  = Test-Path $geminiManifestPath
$hasCopilotManifest      = (Test-Path $copilotManifestPath) -or (Test-Path $copilotUserManifestPath) -or (Test-Path $copilotExtManifestPath)

$anyRuntimeInstalled = $hasClaudeManifest -or $hasCodexManifest -or $hasAntigravityManifest -or $hasCopilotManifest

if (-not $anyRuntimeInstalled) {
    Write-CheckError "Nenhum manifesto de runtime encontrado (Claude, Codex, Antigravity ou Copilot)" "cd '$factoryRoot'; .\install.ps1"
    $hadError = $true
}

if ($hasClaudeManifest) {
    try {
        $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
        if ($manifest.factory_version) {
            if ($manifest.factory_version -eq $factoryVersion) {
                Write-CheckOK "Manifesto Claude alinhado com VERSION ($($manifest.factory_version))"
            } else {
                Write-CheckWarn "Manifesto Claude v$($manifest.factory_version) != VERSION v$factoryVersion - reinstale"
                $hadWarning = $true
            }
        } else {
            Write-CheckWarn "Campo factory_version ausente no manifesto Claude - reinstale para atualizar"
            $hadWarning = $true
        }
        if ($manifest.installed_at) {
            Write-CheckOK "Claude instalado em: $($manifest.installed_at)"
        }
    } catch {
        Write-CheckWarn "Manifesto Claude existe mas JSON invalido: $_"
        $hadWarning = $true
    }
}

if ($hasCodexManifest) {
    try {
        $codexManifest = Get-Content $codexManifestPath -Raw | ConvertFrom-Json
        if ($codexManifest.factory_version -eq $factoryVersion) {
            Write-CheckOK "Manifesto Codex alinhado com VERSION ($($codexManifest.factory_version))"
        } else {
            Write-CheckWarn "Manifesto Codex v$($codexManifest.factory_version) != VERSION v$factoryVersion - reinstale"
            $hadWarning = $true
        }
        if ($codexManifest.installed_at) {
            Write-CheckOK "Codex instalado em: $($codexManifest.installed_at)"
        }
    } catch {
        Write-CheckWarn "Manifesto Codex existe mas JSON invalido: $_"
        $hadWarning = $true
    }
}

if ($hasAntigravityManifest) {
    try {
        $antigravityManifest = Get-Content $geminiManifestPath -Raw | ConvertFrom-Json
        if ($antigravityManifest.factory_version -eq $factoryVersion) {
            Write-CheckOK "Manifesto Antigravity alinhado com VERSION ($($antigravityManifest.factory_version))"
        } else {
            Write-CheckWarn "Manifesto Antigravity v$($antigravityManifest.factory_version) != VERSION v$factoryVersion - reinstale"
            $hadWarning = $true
        }
        if ($antigravityManifest.installed_at) {
            Write-CheckOK "Antigravity instalado em: $($antigravityManifest.installed_at)"
        }
    } catch {
        Write-CheckWarn "Manifesto Antigravity existe mas JSON invalido: $_"
        $hadWarning = $true
    }
}

if (Test-Path $copilotManifestPath) {
    try {
        $copilotManifest = Get-Content $copilotManifestPath -Raw | ConvertFrom-Json
        if ($copilotManifest.factory_version -eq $factoryVersion) {
            Write-CheckOK "Manifesto Copilot prompts alinhado com VERSION ($($copilotManifest.factory_version))"
        } else {
            Write-CheckWarn "Manifesto Copilot prompts v$($copilotManifest.factory_version) != VERSION v$factoryVersion - reinstale"
            $hadWarning = $true
        }
        if ($copilotManifest.installed_at) {
            Write-CheckOK "Copilot prompts instalado em: $($copilotManifest.installed_at)"
        }
    } catch {
        Write-CheckWarn "Manifesto Copilot prompts existe mas JSON invalido: $_"
        $hadWarning = $true
    }
}

if (Test-Path $copilotUserManifestPath) {
    try {
        $copilotUserManifest = Get-Content $copilotUserManifestPath -Raw | ConvertFrom-Json
        if ($copilotUserManifest.factory_version -eq $factoryVersion) {
            Write-CheckOK "Manifesto Copilot user agents alinhado com VERSION ($($copilotUserManifest.factory_version))"
        } else {
            Write-CheckWarn "Manifesto Copilot user agents v$($copilotUserManifest.factory_version) != VERSION v$factoryVersion - reinstale"
            $hadWarning = $true
        }
        if ($copilotUserManifest.installed_at) {
            Write-CheckOK "Copilot user agents instalados em: $($copilotUserManifest.installed_at)"
        }
    } catch {
        Write-CheckWarn "Manifesto Copilot user agents existe mas JSON invalido: $_"
        $hadWarning = $true
    }
}

if (Test-Path $copilotExtManifestPath) {
    try {
        $copilotExtManifest = Get-Content $copilotExtManifestPath -Raw | ConvertFrom-Json
        if ($copilotExtManifest.factory_version -eq $factoryVersion) {
            Write-CheckOK "Manifesto Copilot extensao alinhado com VERSION ($($copilotExtManifest.factory_version))"
        } else {
            Write-CheckWarn "Manifesto Copilot extensao v$($copilotExtManifest.factory_version) != VERSION v$factoryVersion - reinstale"
            $hadWarning = $true
        }
        if ($copilotExtManifest.installed_at) {
            Write-CheckOK "Copilot extensao instalada em: $($copilotExtManifest.installed_at)"
        }
    } catch {
        Write-CheckWarn "Manifesto Copilot extensao existe mas JSON invalido: $_"
        $hadWarning = $true
    }
}

# =============================================================================
#  3. PYTHON
# =============================================================================
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
    $prevEAP = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"
    $mcpCheck = & $pythonCmd -m pip show mcp 2>&1
    $ErrorActionPreference = $prevEAP
    if ($LASTEXITCODE -eq 0) {
        $mcpVer = ($mcpCheck | Select-String "^Version:") -replace "Version:\s*", ""
        Write-CheckOK "Pacote mcp instalado (v$($mcpVer.ToString().Trim()))"
    } else {
        Write-CheckError "Pacote mcp nao instalado" "cd '$factoryRoot'; .\install.ps1 -ForceDeps"
        $hadError = $true
    }
}

# =============================================================================
#  4. CLAUDE CODE
# =============================================================================
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

# =============================================================================
#  5. CODEX
# =============================================================================
Write-Section "5. Codex"

try {
    $codexVer = & codex --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-CheckOK "Codex: $($codexVer.ToString().Trim())"
    } else {
        Write-CheckWarn "codex --version retornou erro (pode ser versao sem --version)"
        $hadWarning = $true
    }
} catch {
    Write-CheckWarn "Codex CLI nao encontrado no PATH (opcional para diagnostico)"
    $hadWarning = $true
}

if (Test-Path $codexConfig) {
    Write-CheckOK "Codex config existe: $codexConfig"
} else {
    Write-CheckWarn "Codex config global nao encontrado em ~/.codex/config.toml"
    Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1"
    $hadWarning = $true
}

# =============================================================================
#  6. CLAUDE AGENTS
# =============================================================================
Write-Section "6. Claude Code - Agentes"

if ($hasClaudeManifest) {
    if (Test-Path $claudeAgentsDir) {
        Write-CheckOK "Diretorio ~/.claude/agents/ existe"
    } else {
        Write-CheckError "~/.claude/agents/ nao encontrado" "cd '$factoryRoot'; .\install.ps1 -Claude"
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

    if ($agentsOK.Count -eq $expectedAgentCount) {
        Write-CheckOK "Todos os $expectedAgentCount agentes instalados com marcador AUTO-GENERATED"
    } else {
        if ($agentsOK.Count -gt 0) {
            Write-CheckOK "$($agentsOK.Count)/$expectedAgentCount agentes OK"
        }
        if ($agentsMissing.Count -gt 0) {
            Write-CheckError "Agentes ausentes ($($agentsMissing.Count)): $($agentsMissing -join ', ')" "cd '$factoryRoot'; .\install.ps1 -Claude"
            $hadError = $true
        }
        if ($agentsNoMarker.Count -gt 0) {
            Write-CheckWarn "Agentes sem marcador AUTO-GENERATED (podem ser externos): $($agentsNoMarker -join ', ')"
            $hadWarning = $true
        }
    }
} else {
    Write-Host "  [SKIP]  Claude Code nao configurado neste ambiente (opcional - .\install.ps1 -Claude)" -ForegroundColor DarkGray
}

# =============================================================================
#  7. CODEX CUSTOM AGENTS
# =============================================================================
Write-Section "7. Codex - Custom Agents"

if ($hasCodexManifest) {
    if (Test-Path $codexAgentsDir) {
        Write-CheckOK "Diretorio ~/.codex/agents/ existe"
    } else {
        Write-CheckError "~/.codex/agents/ nao encontrado" "cd '$factoryRoot'; .\install.ps1 -Codex"
        $hadError = $true
    }

    $codexMissing  = @()
    $codexNoMarker = @()
    $codexOK       = @()

    foreach ($name in $agentNames) {
        $file = Join-Path $codexAgentsDir "$name.toml"
        if (-not (Test-Path $file)) {
            $codexMissing += $name
        } else {
            $content = Get-Content $file -Raw -Encoding UTF8
            if ($content -match "AUTO-GENERATED BY ai_software_factory" -and $content -match "(?m)^developer_instructions\s*=") {
                $codexOK += $name
            } else {
                $codexNoMarker += $name
            }
        }
    }

    if ($codexOK.Count -eq $expectedAgentCount) {
        Write-CheckOK "Todos os $expectedAgentCount custom agents Codex instalados"
    } else {
        if ($codexOK.Count -gt 0) {
            Write-CheckOK "$($codexOK.Count)/$expectedAgentCount custom agents Codex OK"
        }
        if ($codexMissing.Count -gt 0) {
            Write-CheckError "Custom agents Codex ausentes ($($codexMissing.Count)): $($codexMissing -join ', ')" "cd '$factoryRoot'; .\install.ps1 -Codex"
            $hadError = $true
        }
        if ($codexNoMarker.Count -gt 0) {
            Write-CheckWarn "Custom agents Codex sem marcador/campo esperado: $($codexNoMarker -join ', ')"
            $hadWarning = $true
        }
    }
} else {
    Write-Host "  [SKIP]  Codex nao configurado neste ambiente (opcional - .\install.ps1 -Codex)" -ForegroundColor DarkGray
}

# =============================================================================
#  7B. ANTIGRAVITY - PLUGIN & SKILLS
# =============================================================================
Write-Section "7B. Antigravity - Plugin & Skills"

if ($hasAntigravityManifest) {
    if (Test-Path $geminiPluginDir) {
        Write-CheckOK "Diretorio do plugin Antigravity existe: $geminiPluginDir"
        $pluginJsonPath = Join-Path $geminiPluginDir "plugin.json"
        if (Test-Path $pluginJsonPath) {
            Write-CheckOK "plugin.json do Antigravity presente"
        } else {
            Write-CheckWarn "plugin.json ausente no plugin Antigravity"
            $hadWarning = $true
        }
    } else {
        Write-CheckWarn "Plugin Antigravity nao encontrado em $geminiPluginDir"
        Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1 -Antigravity"
        $hadWarning = $true
    }

    $antigravityMissing  = @()
    $antigravityNoMarker = @()
    $antigravityOK       = @()

    foreach ($name in $agentNames) {
        $file = Join-Path $geminiSkillsDir "$name\SKILL.md"
        if (-not (Test-Path $file)) {
            $antigravityMissing += $name
        } else {
            $content = Get-Content $file -Raw -Encoding UTF8
            if ($content -match "AUTO-GENERATED BY ai_software_factory" -and $content -match "(?m)^name:\s*$name") {
                $antigravityOK += $name
            } else {
                $antigravityNoMarker += $name
            }
        }
    }

    if ($antigravityOK.Count -eq $expectedAgentCount) {
        Write-CheckOK "Todas as $expectedAgentCount skills do Antigravity instaladas com marcador AUTO-GENERATED"
    } else {
        if ($antigravityOK.Count -gt 0) {
            Write-CheckOK "$($antigravityOK.Count)/$expectedAgentCount skills Antigravity OK"
        }
        if ($antigravityMissing.Count -gt 0) {
            Write-CheckWarn "Skills Antigravity ausentes ($($antigravityMissing.Count)): $($antigravityMissing -join ', ')"
            Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1 -Antigravity"
            $hadWarning = $true
        }
        if ($antigravityNoMarker.Count -gt 0) {
            Write-CheckWarn "Skills Antigravity sem marcador AUTO-GENERATED: $($antigravityNoMarker -join ', ')"
            $hadWarning = $true
        }
    }
} else {
    Write-Host "  [SKIP]  Antigravity nao configurado neste ambiente (opcional - .\install.ps1 -Antigravity)" -ForegroundColor DarkGray
}

# =============================================================================
#  7C. GITHUB COPILOT - PROMPT FILES & INSTRUCTIONS
# =============================================================================
Write-Section "7C. GitHub Copilot - Prompt Files & Instructions"

if ($hasCopilotManifest) {
    if (Test-Path $copilotInstructions) {
        $instrContent = Get-Content $copilotInstructions -Raw -Encoding UTF8
        if ($instrContent -match "AUTO-GENERATED BY ai_software_factory") {
            Write-CheckOK ".github/copilot-instructions.md presente com marcador AUTO-GENERATED"
        } else {
            Write-CheckWarn ".github/copilot-instructions.md presente mas sem marcador AUTO-GENERATED"
            $hadWarning = $true
        }
    } else {
        Write-CheckWarn ".github/copilot-instructions.md nao encontrado"
        Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1 -Copilot"
        $hadWarning = $true
    }

    if (Test-Path $copilotPromptsDir) {
        Write-CheckOK "Diretorio de prompts do Copilot existe: $copilotPromptsDir"
    } else {
        Write-CheckWarn "Diretorio .github/prompts/ nao encontrado"
        Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1 -Copilot"
        $hadWarning = $true
    }

    $copilotMissing  = @()
    $copilotNoMarker = @()
    $copilotOK       = @()

    foreach ($name in $agentNames) {
        $file = Join-Path $copilotPromptsDir "$name.prompt.md"
        if (-not (Test-Path $file)) {
            $copilotMissing += $name
        } else {
            $content = Get-Content $file -Raw -Encoding UTF8
            if ($content -match "AUTO-GENERATED BY ai_software_factory" -and $content -match "(?m)^description:\s*>-?") {
                $copilotOK += $name
            } else {
                $copilotNoMarker += $name
            }
        }
    }

    if ($copilotOK.Count -eq $expectedAgentCount) {
        Write-CheckOK "Todos os $expectedAgentCount prompt files do Copilot instalados com marcador AUTO-GENERATED"
    } else {
        if ($copilotOK.Count -gt 0) {
            Write-CheckOK "$($copilotOK.Count)/$expectedAgentCount prompt files Copilot OK"
        }
        if ($copilotMissing.Count -gt 0) {
            Write-CheckWarn "Prompt files Copilot ausentes ($($copilotMissing.Count)): $($copilotMissing -join ', ')"
            Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1 -Copilot"
            $hadWarning = $true
        }
        if ($copilotNoMarker.Count -gt 0) {
            Write-CheckWarn "Prompt files Copilot sem marcador/formato esperado: $($copilotNoMarker -join ', ')"
            $hadWarning = $true
        }
    }

    # Verificacao de Workspace Custom Agents (.github/agents/)
    if (Test-Path $copilotAgentsDir) {
        Write-CheckOK "Diretorio de workspace agents do Copilot existe: $copilotAgentsDir"
        $wsMissing = @()
        $wsOK      = @()
        foreach ($name in $agentNames) {
            $file = Join-Path $copilotAgentsDir "$name.agent.md"
            if (-not (Test-Path $file)) {
                $wsMissing += $name
            } else {
                $content = Get-Content $file -Raw -Encoding UTF8
                if ($content -match "AUTO-GENERATED BY ai_software_factory" -and $content -match "(?m)^name:\s*$name") {
                    $wsOK += $name
                }
            }
        }
        if ($wsOK.Count -eq $expectedAgentCount) {
            Write-CheckOK "Todos os $expectedAgentCount workspace custom agents do Copilot instalados com marcador AUTO-GENERATED"
        } elseif ($wsOK.Count -gt 0) {
            Write-CheckOK "$($wsOK.Count)/$expectedAgentCount workspace agents Copilot OK"
            if ($wsMissing.Count -gt 0) {
                Write-CheckWarn "Workspace agents Copilot ausentes ($($wsMissing.Count)): $($wsMissing -join ', ')"
                $hadWarning = $true
            }
        }
    }

    # Verificacao de User Custom Agents (~/.copilot/agents/)
    if (Test-Path $copilotUserAgentsDir) {
        $userOK       = @()
        $userMissing  = @()
        $userNoMarker = @()
        foreach ($name in $agentNames) {
            $file = Join-Path $copilotUserAgentsDir "$name.agent.md"
            if (-not (Test-Path $file)) {
                $userMissing += $name
            } else {
                $content = Get-Content $file -Raw -Encoding UTF8
                if ($content -match "AUTO-GENERATED BY ai_software_factory" -and $content -match "(?m)^name:\s*$name") {
                    $userOK += $name
                } else {
                    $userNoMarker += $name
                }
            }
        }
        if ($userOK.Count -eq $expectedAgentCount) {
            Write-CheckOK "Todos os $expectedAgentCount user custom agents do Copilot instalados em ~/.copilot/agents/ com marcador AUTO-GENERATED"
        } else {
            if ($userOK.Count -gt 0) {
                Write-CheckOK "$($userOK.Count)/$expectedAgentCount user custom agents Copilot OK"
            }
            if ($userMissing.Count -gt 0) {
                Write-CheckWarn "User custom agents Copilot ausentes ($($userMissing.Count)): $($userMissing -join ', ')"
                Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1 -Copilot"
                $hadWarning = $true
            }
            if ($userNoMarker.Count -gt 0) {
                Write-CheckWarn "User custom agents Copilot sem marcador AUTO-GENERATED: $($userNoMarker -join ', ')"
                $hadWarning = $true
            }
        }
    } else {
        Write-CheckWarn "Diretorio de user custom agents Copilot (~/.copilot/agents/) nao encontrado"
        Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1 -Copilot"
        $hadWarning = $true
    }

    # Verificacao preventiva contra extensao legada (evita duplicacao no Copilot e Antigravity)
    if (Test-Path $copilotExtDir) {
        Write-CheckWarn "Extensao legada encontrada em $copilotExtDir (causa duplicacao de agentes no Copilot e Antigravity)"
        Write-CheckWarn "          Fix: Remove-Item -Recurse -Force '$copilotExtDir'"
        $hadWarning = $true
    } else {
        Write-CheckOK "Extensao legada ~/.vscode/extensions/ai-software-factory.agents ausente (sem duplicacao)"
    }

    # Verificacao de settings.json para evitar duplicacao de agentes caso ~/.claude/agents exista
    $vscodeUserDir = if ($env:APPDATA) { Join-Path $env:APPDATA "Code\User" } else { Join-Path $env:USERPROFILE ".config\Code\User" }
    $vscodeSettingsPath = Join-Path $vscodeUserDir "settings.json"
    if (Test-Path $vscodeSettingsPath) {
        $rawSettings = Get-Content $vscodeSettingsPath -Raw -Encoding UTF8
        $claudeDisabled = ($rawSettings -match '"chat\.agentHost\.claudeAgent\.enabled"\s*:\s*false') -or ($rawSettings -match '"github\.copilot\.chat\.claudeAgent\.enabled"\s*:\s*false')
        if ($claudeDisabled) {
            Write-CheckOK "Descoberta de Claude agents desativada no Copilot (previne duplicacao com ~/.claude/agents)"
        } else {
            Write-CheckWarn "Claude agents habilitados no Copilot - se ~/.claude/agents tiver arquivos, eles aparecerao duplicados"
            Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1 -Copilot"
            $hadWarning = $true
        }
    }
} else {
    Write-Host "  [SKIP]  GitHub Copilot nao configurado neste ambiente (opcional - .\install.ps1 -Copilot)" -ForegroundColor DarkGray
}

# =============================================================================
#  8. KNOWLEDGE DB
# =============================================================================
Write-Section "8. Knowledge Database"

$dbPath = Join-Path $factoryRoot "knowledge.db"
if (Test-Path $dbPath) {
    $dbSize = [math]::Round((Get-Item $dbPath).Length / 1MB, 2)
    Write-CheckOK "knowledge.db existe ($dbSize MB)"
} else {
    Write-CheckError "knowledge.db nao encontrado" "cd '$factoryRoot'; .\update-knowledge.ps1"
    $hadError = $true
}

# =============================================================================
#  9. MCP HEALTH CHECK (via test-mcp.ps1)
# =============================================================================
Write-Section "9. MCP Health Check"

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
            } elseif ($line -match "^MCP Knowledge|^------") {
                # header do test-mcp, omitir
            } else {
                Write-Host "    $line" -ForegroundColor Gray
            }
        }
        if ($LASTEXITCODE -eq 0) {
            Write-CheckOK "test-mcp.ps1 passou - MCP pronto"
        } else {
            Write-CheckError "test-mcp.ps1 falhou" "cd '$factoryRoot'; .\install.ps1 -ForceDeps"
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

# =============================================================================
#  10. MCP CONFIGURACAO
# =============================================================================
Write-Section "10. MCP Configuracao"

if ($hasClaudeManifest) {
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
                    Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1 -Claude"
                    $hadWarning = $true
                }
            } else {
                Write-CheckError "mcpServers.knowledge ausente em ~/.claude.json" "cd '$factoryRoot'; .\install.ps1 -Claude"
                $hadError = $true
            }
        } catch {
            Write-CheckWarn "Nao foi possivel ler ~/.claude.json: $_"
            $hadWarning = $true
        }
    } else {
        Write-CheckError "~/.claude.json nao encontrado" "cd '$factoryRoot'; .\install.ps1 -Claude"
        $hadError = $true
    }
} else {
    Write-Host "  [SKIP]  Claude Code nao configurado neste ambiente (opcional - .\install.ps1 -Claude)" -ForegroundColor DarkGray
}

$mcpJson = Join-Path $factoryRoot ".mcp.json"
if (Test-Path $mcpJson) {
    Write-CheckOK ".mcp.json existe na raiz da factory"
} else {
    Write-CheckWarn ".mcp.json ausente (execute .\install.ps1)"
    $hadWarning = $true
}

$expectedServer = Join-Path $factoryRoot "tools\mcp-knowledge-search\server.py"

if ($hasCodexManifest) {
    if (Test-Path $codexConfig) {
        try {
            $codexRaw = Get-Content $codexConfig -Raw -Encoding UTF8
            if ($codexRaw -match "(?m)^\s*\[mcp_servers\.knowledge\]\s*$") {
                Write-CheckOK "mcp_servers.knowledge configurado em ~/.codex/config.toml"
                $expectedServerEscaped = $expectedServer.Replace("\", "\\")
                if ($codexRaw -like "*$expectedServer*" -or $codexRaw -like "*$expectedServerEscaped*") {
                    Write-CheckOK "server.py path correto em ~/.codex/config.toml"
                } else {
                    Write-CheckWarn "Codex global config possui knowledge, mas nao aponta claramente para esta factory"
                    Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1 -Codex"
                    $hadWarning = $true
                }
            } else {
                Write-CheckError "mcp_servers.knowledge ausente em ~/.codex/config.toml" "cd '$factoryRoot'; .\install.ps1 -Codex"
                $hadError = $true
            }
        } catch {
            Write-CheckWarn "Nao foi possivel ler ~/.codex/config.toml: $_"
            $hadWarning = $true
        }
    } else {
        Write-CheckError "~/.codex/config.toml nao encontrado" "cd '$factoryRoot'; .\install.ps1 -Codex"
        $hadError = $true
    }

    if (Test-Path $projectCodexConfig) {
        $projectCodexRaw = Get-Content $projectCodexConfig -Raw -Encoding UTF8
        if ($projectCodexRaw -match "(?m)^\s*\[mcp_servers\.knowledge\]\s*$") {
            Write-CheckOK ".codex/config.toml existe na raiz da factory com MCP knowledge"
        } else {
            Write-CheckWarn ".codex/config.toml existe, mas sem mcp_servers.knowledge"
            $hadWarning = $true
        }
    } else {
        Write-CheckWarn ".codex/config.toml ausente na factory (execute .\install.ps1 -Codex)"
        $hadWarning = $true
    }
} else {
    Write-Host "  [SKIP]  Codex nao configurado neste ambiente (opcional - .\install.ps1 -Codex)" -ForegroundColor DarkGray
}

if ($hasAntigravityManifest) {
    if (Test-Path $geminiMcpConfig) {
        try {
            $geminiRaw = Get-Content $geminiMcpConfig -Raw -Encoding UTF8
            if ($geminiRaw -and $geminiRaw.Trim()) {
                $geminiSettings = $geminiRaw | ConvertFrom-Json
                if ($geminiSettings.mcpServers.knowledge) {
                    Write-CheckOK "mcpServers.knowledge configurado em ~/.gemini/config/mcp_config.json"
                    $configuredServer = if ($geminiSettings.mcpServers.knowledge.args) { $geminiSettings.mcpServers.knowledge.args[0] } else { "" }
                    if ($configuredServer -eq $expectedServer) {
                        Write-CheckOK "server.py path correto em mcp_config.json"
                    } else {
                        Write-CheckWarn "server.py em mcp_config.json aponta para: $configuredServer"
                        Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1 -Antigravity"
                        $hadWarning = $true
                    }
                } else {
                    Write-CheckWarn "mcpServers.knowledge ausente em ~/.gemini/config/mcp_config.json"
                    $hadWarning = $true
                }
            }
        } catch {
            Write-CheckWarn "Nao foi possivel ler ~/.gemini/config/mcp_config.json: $_"
            $hadWarning = $true
        }
    } else {
        Write-CheckWarn "~/.gemini/config/mcp_config.json nao encontrado"
        $hadWarning = $true
    }

    $pluginMcpPath = Join-Path $geminiPluginDir "mcp_config.json"
    if (Test-Path $pluginMcpPath) {
        Write-CheckOK "mcp_config.json presente no plugin Antigravity"
    } else {
        Write-CheckWarn "mcp_config.json ausente no plugin Antigravity"
        $hadWarning = $true
    }
} else {
    Write-Host "  [SKIP]  Antigravity nao configurado neste ambiente (opcional - .\install.ps1 -Antigravity)" -ForegroundColor DarkGray
}

if ($hasCopilotManifest) {
    if (Test-Path $vscodeMcpConfig) {
        try {
            $vscodeRaw = Get-Content $vscodeMcpConfig -Raw -Encoding UTF8
            if ($vscodeRaw -and $vscodeRaw.Trim()) {
                $vscodeSettings = $vscodeRaw | ConvertFrom-Json
                if ($vscodeSettings.mcpServers.knowledge) {
                    Write-CheckOK ".vscode/mcp.json configurado com MCP knowledge"
                } else {
                    Write-CheckWarn ".vscode/mcp.json existe mas sem mcpServers.knowledge"
                    $hadWarning = $true
                }
            }
        } catch {
            Write-CheckWarn "Nao foi possivel ler .vscode/mcp.json: $_"
            $hadWarning = $true
        }
    } else {
        Write-CheckWarn ".vscode/mcp.json nao encontrado (execute .\install.ps1 -Copilot)"
        $hadWarning = $true
    }

    if (Test-Path $vscodeGlobalMcp) {
        try {
            $vscodeUserRaw = Get-Content $vscodeGlobalMcp -Raw -Encoding UTF8
            if ($vscodeUserRaw -and $vscodeUserRaw.Trim()) {
                $vscodeUserSettings = $vscodeUserRaw | ConvertFrom-Json
                $userKnowledge = if ($vscodeUserSettings.servers) { $vscodeUserSettings.servers.knowledge } else { $null }
                if ($userKnowledge) {
                    Write-CheckOK "servers.knowledge configurado em VS Code User mcp.json"
                    $configuredServer = if ($userKnowledge.args) { $userKnowledge.args[0] } else { "" }
                    $expectedServer   = Join-Path $factoryRoot "tools\mcp-knowledge-search\server.py"
                    if ($configuredServer -eq $expectedServer) {
                        Write-CheckOK "server.py path correto em VS Code User mcp.json"
                    } else {
                        Write-CheckWarn "server.py em VS Code User mcp.json aponta para: $configuredServer"
                        Write-CheckWarn "          Esperado: $expectedServer"
                        $hadWarning = $true
                    }
                } else {
                    Write-CheckWarn "servers.knowledge ausente em VS Code User mcp.json (execute .\install.ps1 -Copilot)"
                    $hadWarning = $true
                }
            }
        } catch {
            Write-CheckWarn "Nao foi possivel ler VS Code User mcp.json: $_"
            $hadWarning = $true
        }
    }
} else {
    Write-Host "  [SKIP]  GitHub Copilot nao configurado neste ambiente (opcional - .\install.ps1 -Copilot)" -ForegroundColor DarkGray
}

# =============================================================================
#  11. PATHS NOS AGENTES GERADOS
# =============================================================================
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
    Write-CheckWarn "          Fix: cd '$factoryRoot'; .\install.ps1"
    $hadWarning = $true
} else {
    Write-CheckOK "FACTORY_ROOT correto em todos os agentes instalados"
}

# =============================================================================
#  12. SCRIPTS PRINCIPAIS
# =============================================================================
Write-Section "12. Scripts principais"

$requiredScripts = @{
    "install.ps1"          = "Instalador principal"
    "uninstall.ps1"        = "Desinstalador"
    "test-mcp.ps1"         = "Health check do MCP"
    "update-knowledge.ps1" = "Reindexador do knowledge"
    "doctor.ps1"           = "Diagnostico geral"
    "link-mcp.ps1"         = "Vinculador MCP por projeto"
}

foreach ($script in $requiredScripts.Keys) {
    $path = Join-Path $factoryRoot $script
    if (Test-Path $path) {
        Write-CheckOK "$script - $($requiredScripts[$script])"
    } else {
        Write-CheckError "$script nao encontrado" "git -C '$factoryRoot' checkout -- $script"
        $hadError = $true
    }
}

# =============================================================================
#  13. PERMISSOES
# =============================================================================
Write-Section "13. Permissoes de escrita"

# ~/.claude/agents/
if (Test-Path $claudeAgentsDir) {
    $testFile = Join-Path $claudeAgentsDir ".doctor_write_test"
    try {
        [System.IO.File]::WriteAllText($testFile, "test", [System.Text.UTF8Encoding]::new($false))
        Remove-Item $testFile -Force
        Write-CheckOK "Escrita em ~/.claude/agents/ OK"
    } catch {
        Write-CheckError "Sem permissao de escrita em ~/.claude/agents/" "Verifique permissoes do diretorio"
        $hadError = $true
    }
} elseif ($hasClaudeManifest) {
    Write-CheckError "~/.claude/agents/ nao existe" "cd '$factoryRoot'; .\install.ps1 -Claude"
    $hadError = $true
}

# ~/.codex/agents/
if (Test-Path $codexAgentsDir) {
    $testCodexFile = Join-Path $codexAgentsDir ".doctor_write_test"
    try {
        [System.IO.File]::WriteAllText($testCodexFile, "test", [System.Text.UTF8Encoding]::new($false))
        Remove-Item $testCodexFile -Force
        Write-CheckOK "Escrita em ~/.codex/agents/ OK"
    } catch {
        Write-CheckError "Sem permissao de escrita em ~/.codex/agents/" "Verifique permissoes do diretorio"
        $hadError = $true
    }
} elseif ($hasCodexManifest) {
    Write-CheckError "~/.codex/agents/ nao existe" "cd '$factoryRoot'; .\install.ps1 -Codex"
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

# Antigravity plugin
if (Test-Path $geminiPluginDir) {
    $testGeminiFile = Join-Path $geminiPluginDir ".doctor_write_test"
    try {
        [System.IO.File]::WriteAllText($testGeminiFile, "test", [System.Text.UTF8Encoding]::new($false))
        Remove-Item $testGeminiFile -Force
        Write-CheckOK "Escrita em plugin Antigravity OK"
    } catch {
        Write-CheckError "Sem permissao de escrita em plugin Antigravity" "Verifique permissoes de: $geminiPluginDir"
        $hadError = $true
    }
} elseif ($hasAntigravityManifest) {
    Write-CheckError "Plugin Antigravity nao encontrado em $geminiPluginDir" "cd '$factoryRoot'; .\install.ps1 -Antigravity"
    $hadError = $true
}

# GitHub Copilot prompts
if (Test-Path $copilotPromptsDir) {
    $testCopilotFile = Join-Path $copilotPromptsDir ".doctor_write_test"
    try {
        [System.IO.File]::WriteAllText($testCopilotFile, "test", [System.Text.UTF8Encoding]::new($false))
        Remove-Item $testCopilotFile -Force
        Write-CheckOK "Escrita em .github/prompts/ OK"
    } catch {
        Write-CheckError "Sem permissao de escrita em .github/prompts/" "Verifique permissoes do diretorio"
        $hadError = $true
    }
} elseif ($hasCopilotManifest) {
    Write-CheckError "Diretorio .github/prompts/ nao encontrado" "cd '$factoryRoot'; .\install.ps1 -Copilot"
    $hadError = $true
}

# GitHub Copilot user custom agents (~/.copilot/agents/)
if (Test-Path $copilotUserAgentsDir) {
    $testCopilotUserFile = Join-Path $copilotUserAgentsDir ".doctor_write_test"
    try {
        [System.IO.File]::WriteAllText($testCopilotUserFile, "test", [System.Text.UTF8Encoding]::new($false))
        Remove-Item $testCopilotUserFile -Force
        Write-CheckOK "Escrita em ~/.copilot/agents/ OK"
    } catch {
        Write-CheckError "Sem permissao de escrita em ~/.copilot/agents/" "Verifique permissoes de: $copilotUserAgentsDir"
        $hadError = $true
    }
}

# =============================================================================
#  14. VARIAVEIS DE AMBIENTE NA SESSAO
# =============================================================================
Write-Section "14. Variaveis de ambiente na sessao"

$envVars = @("FACTORY_ROOT")
foreach ($var in $envVars) {
    $val = [System.Environment]::GetEnvironmentVariable($var)
    if ($val) {
        Write-CheckOK "$var = $val"
    } else {
        Write-CheckWarn "$var nao disponivel nesta sessao - abra um novo terminal"
        $hadWarning = $true
    }
}

# =============================================================================
#  RESUMO
# =============================================================================
Write-Host ""
Write-Host "  -----------------------------------------------------" -ForegroundColor DarkGray
Write-Host ""

if ($hadError) {
    Write-Host "  [FAIL]  Problemas criticos encontrados - veja detalhes acima." -ForegroundColor Red
    Write-Host "          Corrija e execute: cd '$factoryRoot'; .\install.ps1" -ForegroundColor DarkYellow
    exit 1
} elseif ($hadWarning) {
    Write-Host "  [WARN]  Factory funcional com avisos - veja detalhes acima." -ForegroundColor Yellow
    exit 0
} else {
    Write-Host "  [OK]    Factory saudavel - todos os checks passaram." -ForegroundColor Green
    exit 0
}
