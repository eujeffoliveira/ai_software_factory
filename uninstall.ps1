# uninstall.ps1 - Remove componentes instalados pelo install.ps1
# Uso:
#   .\uninstall.ps1                     # remove agentes e configs, preserva knowledge.db e logs
#   .\uninstall.ps1 -KeepKnowledge      # idem (explicito)
#   .\uninstall.ps1 -Full               # remove tudo, incluindo knowledge.db, logs, FACTORY_ROOT
#   .\uninstall.ps1 -WhatIf             # preview sem remover nada
#   .\uninstall.ps1 -Full -Force        # Full sem pedir confirmacao

param(
    [switch]$KeepKnowledge,   # preserva knowledge.db e logs (padrao do modo normal)
    [switch]$Full,            # remove tudo incluindo knowledge.db, logs e FACTORY_ROOT
    [switch]$WhatIf,          # mostra o que seria feito sem executar
    [switch]$Force            # pula confirmacoes interativas
)

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

# --- Output helpers ----------------------------------------------------------
function Write-Header($t) {
    Write-Host ""
    Write-Host "  $t" -ForegroundColor Cyan
    Write-Host ("  " + "-" * $t.Length) -ForegroundColor DarkGray
}
function Write-OK($m)   { Write-Host "  [OK]   $m" -ForegroundColor Green }
function Write-Skip($m) { Write-Host "  [SKIP] $m" -ForegroundColor DarkGray }
function Write-Warn($m) { Write-Host "  [WARN] $m" -ForegroundColor Yellow }
function Write-What($m) { Write-Host "  [WHAT] $m" -ForegroundColor DarkCyan }

# Executa acao de remocao - respeita -WhatIf
function Remove-IfExists {
    param(
        [string]$Path,
        [string]$Label,
        [switch]$Recurse
    )
    if (-not (Test-Path $Path)) { Write-Skip "Nao encontrado: $Label"; return }
    if ($WhatIf) {
        Write-What "Removeria: $Label"
    } else {
        if ($Recurse) { Remove-Item $Path -Recurse -Force }
        else          { Remove-Item $Path -Force }
        Write-OK "Removido: $Label"
    }
}

function Convert-PSObjectToOrderedHashtable ($inputObj) {
    if ($null -eq $inputObj) { return $null }
    if ($inputObj -is [System.Collections.IDictionary]) {
        $hash = [ordered]@{}
        foreach ($key in $inputObj.Keys) {
            $hash[$key] = Convert-PSObjectToOrderedHashtable $inputObj[$key]
        }
        return $hash
    }
    if ($inputObj -is [System.Array] -or ($inputObj -is [System.Collections.IList] -and $inputObj -isnot [string])) {
        $list = [System.Collections.ArrayList]::new()
        foreach ($item in $inputObj) {
            [void]$list.Add((Convert-PSObjectToOrderedHashtable $item))
        }
        return $list
    }
    if ($inputObj -is [PSCustomObject]) {
        $hash = [ordered]@{}
        foreach ($prop in $inputObj.PSObject.Properties) {
            $hash[$prop.Name] = Convert-PSObjectToOrderedHashtable $prop.Value
        }
        return $hash
    }
    return $inputObj
}

function ConvertFrom-JsonSafe ($jsonText) {
    if (-not $jsonText -or -not $jsonText.Trim()) { return [ordered]@{} }
    try {
        return (ConvertFrom-Json -InputObject $jsonText -AsHashtable -ErrorAction Stop)
    } catch {
        $obj = ConvertFrom-Json -InputObject $jsonText -ErrorAction Stop
        return (Convert-PSObjectToOrderedHashtable $obj)
    }
}

# --- Caminhos ----------------------------------------------------------------
$FACTORY_PATH      = (Get-Location).Path
$CLAUDE_AGENTS_DIR = "$env:USERPROFILE\.claude\agents"
$CLAUDE_SETTINGS   = "$env:USERPROFILE\.claude.json"
$CODEX_HOME_DIR    = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE ".codex" }
$CODEX_AGENTS_DIR  = Join-Path $CODEX_HOME_DIR "agents"
$CODEX_CONFIG      = Join-Path $CODEX_HOME_DIR "config.toml"
$GEMINI_CONFIG_DIR = Join-Path $env:USERPROFILE ".gemini\config"
$GEMINI_PLUGIN_DIR = Join-Path $GEMINI_CONFIG_DIR "plugins\ai-software-factory"
$GEMINI_MCP_CONFIG = Join-Path $GEMINI_CONFIG_DIR "mcp_config.json"
$COPILOT_DIR          = Join-Path $FACTORY_PATH ".github"
$COPILOT_PROMPTS_DIR  = Join-Path $COPILOT_DIR "prompts"
$COPILOT_AGENTS_DIR   = Join-Path $COPILOT_DIR "agents"
$COPILOT_INSTRUCTIONS = Join-Path $COPILOT_DIR "copilot-instructions.md"
$COPILOT_USER_DIR     = Join-Path $env:USERPROFILE ".copilot"
$COPILOT_USER_AGENTS_DIR = Join-Path $COPILOT_USER_DIR "agents"
$VSCODE_DIR           = Join-Path $FACTORY_PATH ".vscode"
$VSCODE_MCP_CONFIG    = Join-Path $VSCODE_DIR "mcp.json"
$VSCODE_USER_EXTENSIONS_DIR = if ($env:VSCODE_EXTENSIONS) { $env:VSCODE_EXTENSIONS } else { Join-Path $env:USERPROFILE ".vscode\extensions" }
$COPILOT_EXT_DIR            = Join-Path $VSCODE_USER_EXTENSIONS_DIR "ai-software-factory.agents"
$COPILOT_EXT_AGENTS_DIR     = Join-Path $COPILOT_EXT_DIR "agents"
$COPILOT_EXT_PKG            = Join-Path $COPILOT_EXT_DIR "package.json"
$VSCODE_USER_DIR            = if ($env:APPDATA) { Join-Path $env:APPDATA "Code\User" } else { Join-Path $env:USERPROFILE ".config\Code\User" }
$VSCODE_GLOBAL_MCP          = Join-Path $VSCODE_USER_DIR "mcp.json"
$BIN_DIR           = "$env:USERPROFILE\.local\bin"

$agentNames = @("techlead","po","architect","engineer","devbackend","devfrontend","qa","devsecops","devops","uxui","dataengineer","dataanalyst")

# --- Banner ------------------------------------------------------------------
$modeLabel = if ($WhatIf) { "WhatIf" } elseif ($Full) { "Full" } else { "Normal" }

Write-Host ""
Write-Host "  +===================================================+" -ForegroundColor Red
Write-Host "  |      AI Software Factory - Uninstaller           |" -ForegroundColor Red
Write-Host "  +===================================================+" -ForegroundColor Red
Write-Host ""
Write-Host "  Factory : $FACTORY_PATH" -ForegroundColor Gray
Write-Host "  Modo    : $modeLabel" -ForegroundColor Gray
if ($WhatIf) {
    Write-Host "  [WHAT-IF] Nenhuma alteracao sera feita." -ForegroundColor DarkCyan
}
Write-Host ""

# --- Confirmacao para -Full --------------------------------------------------
if ($Full -and -not $WhatIf -and -not $Force) {
    Write-Host "  ATENCAO: -Full ira remover knowledge.db, logs, dependencias Python" -ForegroundColor Yellow
    Write-Host "           e a variavel FACTORY_ROOT. Esta acao nao pode ser desfeita." -ForegroundColor Yellow
    Write-Host ""
    $confirm = Read-Host "  Confirmar desinstalacao completa? (y/N)"
    if ($confirm -notmatch "^[yY]$") {
        Write-Host "  Cancelado." -ForegroundColor Gray
        exit 0
    }
    Write-Host ""
}

# =============================================================================
#  1 - Claude Code: agentes (apenas os gerados pela factory)
# =============================================================================
Write-Header "Claude Code - Agentes"

$removed   = 0
$skipped   = 0
$external  = 0

foreach ($name in $agentNames) {
    $file = Join-Path $CLAUDE_AGENTS_DIR "$name.md"
    if (-not (Test-Path $file)) {
        Write-Skip "Nao encontrado: $name.md"
        $skipped++
        continue
    }
    # Verificar marcador de seguranca - so remove arquivos gerados pela factory
    $isFactoryAgent = Select-String -Path $file -Pattern "AUTO-GENERATED BY ai_software_factory" -Quiet -ErrorAction SilentlyContinue
    if (-not $isFactoryAgent) {
        Write-Warn "$name.md existe mas nao tem marcador AUTO-GENERATED - ignorando (pode ser externo)"
        $external++
        continue
    }
    Remove-IfExists -Path $file -Label "$name.md"
    $removed++
}

# Manifesto (so em -Full)
$manifestPath = Join-Path $CLAUDE_AGENTS_DIR ".ai_software_factory_manifest.json"
if ($Full) {
    Remove-IfExists -Path $manifestPath -Label ".ai_software_factory_manifest.json"
} else {
    Write-Skip "Manifesto preservado (use -Full para remover)"
}

Write-Host "  ---------------------------------" -ForegroundColor DarkGray
Write-Host "  $removed removidos, $skipped nao encontrados, $external externos ignorados" -ForegroundColor Gray

# =============================================================================
#  2 - Codex: custom agents (apenas os gerados pela factory)
# =============================================================================
Write-Header "Codex - Custom Agents"

$codexRemoved  = 0
$codexSkipped  = 0
$codexExternal = 0

foreach ($name in $agentNames) {
    $file = Join-Path $CODEX_AGENTS_DIR "$name.toml"
    if (-not (Test-Path $file)) {
        Write-Skip "Nao encontrado: $name.toml"
        $codexSkipped++
        continue
    }
    $isFactoryAgent = Select-String -Path $file -Pattern "AUTO-GENERATED BY ai_software_factory" -Quiet -ErrorAction SilentlyContinue
    if (-not $isFactoryAgent) {
        Write-Warn "$name.toml existe mas nao tem marcador AUTO-GENERATED - ignorando (pode ser externo)"
        $codexExternal++
        continue
    }
    Remove-IfExists -Path $file -Label "$name.toml"
    $codexRemoved++
}

$codexManifestPath = Join-Path $CODEX_AGENTS_DIR ".ai_software_factory_manifest.json"
if ($Full) {
    Remove-IfExists -Path $codexManifestPath -Label "Codex .ai_software_factory_manifest.json"
} else {
    Write-Skip "Manifesto Codex preservado (use -Full para remover)"
}

Write-Host "  ---------------------------------" -ForegroundColor DarkGray
Write-Host "  $codexRemoved removidos, $codexSkipped nao encontrados, $codexExternal externos ignorados" -ForegroundColor Gray

# =============================================================================
#  2B - Antigravity: plugin e skills
# =============================================================================
Write-Header "Antigravity - Plugin e Skills"

if (Test-Path $GEMINI_PLUGIN_DIR) {
    Remove-IfExists -Path $GEMINI_PLUGIN_DIR -Label "Plugin Antigravity (ai-software-factory)" -Recurse
} else {
    Write-Skip "Plugin Antigravity nao encontrado"
}

# =============================================================================
#  2C - GitHub Copilot: prompt files e copilot-instructions.md
# =============================================================================
Write-Header "GitHub Copilot - Prompt Files e Instructions"

$copilotRemoved  = 0
$copilotSkipped  = 0
$copilotExternal = 0

if (Test-Path $COPILOT_PROMPTS_DIR) {
    foreach ($name in $agentNames) {
        $file = Join-Path $COPILOT_PROMPTS_DIR "$name.prompt.md"
        if (-not (Test-Path $file)) {
            $copilotSkipped++
            continue
        }
        $isFactoryAgent = Select-String -Path $file -Pattern "AUTO-GENERATED BY ai_software_factory" -Quiet -ErrorAction SilentlyContinue
        if (-not $isFactoryAgent) {
            Write-Warn "$name.prompt.md existe mas nao tem marcador AUTO-GENERATED - ignorando (pode ser externo)"
            $copilotExternal++
            continue
        }
        Remove-IfExists -Path $file -Label "copilot/$name.prompt.md"
        $copilotRemoved++
    }

    $copilotManifestPath = Join-Path $COPILOT_PROMPTS_DIR ".ai_software_factory_manifest.json"
    if ($Full) {
        Remove-IfExists -Path $copilotManifestPath -Label "Copilot .ai_software_factory_manifest.json"
    } else {
        Write-Skip "Manifesto Copilot preservado (use -Full para remover)"
    }

    $remaining = Get-ChildItem -Path $COPILOT_PROMPTS_DIR -ErrorAction SilentlyContinue
    if (-not $remaining -or $remaining.Count -eq 0) {
        Remove-IfExists -Path $COPILOT_PROMPTS_DIR -Label ".github/prompts/" -Recurse
    }
} else {
    Write-Skip ".github/prompts/ nao encontrado"
}

if (Test-Path $COPILOT_INSTRUCTIONS) {
    $isFactoryInstr = Select-String -Path $COPILOT_INSTRUCTIONS -Pattern "AUTO-GENERATED BY ai_software_factory" -Quiet -ErrorAction SilentlyContinue
    if ($isFactoryInstr) {
        Remove-IfExists -Path $COPILOT_INSTRUCTIONS -Label ".github/copilot-instructions.md"
    } else {
        Write-Warn ".github/copilot-instructions.md existe mas nao tem marcador AUTO-GENERATED - preservado"
    }
} else {
    Write-Skip ".github/copilot-instructions.md nao encontrado"
}

# Extensao global do VS Code (~/.vscode/extensions/ai-software-factory.agents/)
$copilotExtRemoved  = 0
$copilotExtSkipped  = 0
$copilotExtExternal = 0

if (Test-Path $COPILOT_EXT_AGENTS_DIR) {
    foreach ($name in $agentNames) {
        $file = Join-Path $COPILOT_EXT_AGENTS_DIR "$name.agent.md"
        if (-not (Test-Path $file)) {
            $copilotExtSkipped++
            continue
        }
        $isFactoryAgent = Select-String -Path $file -Pattern "AUTO-GENERATED BY ai_software_factory" -Quiet -ErrorAction SilentlyContinue
        if (-not $isFactoryAgent) {
            Write-Warn "$name.agent.md existe mas nao tem marcador AUTO-GENERATED - ignorando (pode ser externo)"
            $copilotExtExternal++
            continue
        }
        Remove-IfExists -Path $file -Label "copilot-ext/agents/$name.agent.md"
        $copilotExtRemoved++
    }

    $extRemaining = Get-ChildItem -Path $COPILOT_EXT_AGENTS_DIR -ErrorAction SilentlyContinue
    if (-not $extRemaining -or $extRemaining.Count -eq 0) {
        Remove-IfExists -Path $COPILOT_EXT_AGENTS_DIR -Label "copilot-ext/agents/" -Recurse
    }
}

if (Test-Path $COPILOT_EXT_DIR) {
    $copilotExtManifestPath = Join-Path $COPILOT_EXT_DIR ".ai_software_factory_manifest.json"
    if ($Full) {
        Remove-IfExists -Path $copilotExtManifestPath -Label "copilot-ext/.ai_software_factory_manifest.json"
        Remove-IfExists -Path $COPILOT_EXT_PKG -Label "copilot-ext/package.json"
        $allExtRemaining = Get-ChildItem -Path $COPILOT_EXT_DIR -ErrorAction SilentlyContinue
        if (-not $allExtRemaining -or $allExtRemaining.Count -eq 0) {
            Remove-IfExists -Path $COPILOT_EXT_DIR -Label "copilot-ext/" -Recurse
        }
    } else {
        Write-Skip "Manifesto e package.json da extensao Copilot preservados (use -Full para remover)"
    }
}

# Workspace Custom Agents (.github/agents/)
$copilotWsRemoved  = 0
$copilotWsSkipped  = 0
$copilotWsExternal = 0

if (Test-Path $COPILOT_AGENTS_DIR) {
    foreach ($name in $agentNames) {
        $file = Join-Path $COPILOT_AGENTS_DIR "$name.agent.md"
        if (-not (Test-Path $file)) {
            $copilotWsSkipped++
            continue
        }
        $isFactoryAgent = Select-String -Path $file -Pattern "AUTO-GENERATED BY ai_software_factory" -Quiet -ErrorAction SilentlyContinue
        if (-not $isFactoryAgent) {
            Write-Warn "$name.agent.md em .github/agents/ existe mas nao tem marcador AUTO-GENERATED - ignorando"
            $copilotWsExternal++
            continue
        }
        Remove-IfExists -Path $file -Label "copilot-ws/agents/$name.agent.md"
        $copilotWsRemoved++
    }

    $copilotWsManifestPath = Join-Path $COPILOT_AGENTS_DIR ".ai_software_factory_manifest.json"
    if ($Full) {
        Remove-IfExists -Path $copilotWsManifestPath -Label "Copilot workspace .ai_software_factory_manifest.json"
    } else {
        Write-Skip "Manifesto Copilot workspace preservado (use -Full para remover)"
    }

    $wsRemaining = Get-ChildItem -Path $COPILOT_AGENTS_DIR -ErrorAction SilentlyContinue
    if (-not $wsRemaining -or $wsRemaining.Count -eq 0) {
        Remove-IfExists -Path $COPILOT_AGENTS_DIR -Label ".github/agents/" -Recurse
    }
}

# User Custom Agents (~/.copilot/agents/)
$copilotUserRemoved  = 0
$copilotUserSkipped  = 0
$copilotUserExternal = 0

if (Test-Path $COPILOT_USER_AGENTS_DIR) {
    foreach ($name in $agentNames) {
        $file = Join-Path $COPILOT_USER_AGENTS_DIR "$name.agent.md"
        if (-not (Test-Path $file)) {
            $copilotUserSkipped++
            continue
        }
        $isFactoryAgent = Select-String -Path $file -Pattern "AUTO-GENERATED BY ai_software_factory" -Quiet -ErrorAction SilentlyContinue
        if (-not $isFactoryAgent) {
            Write-Warn "$name.agent.md em ~/.copilot/agents/ existe mas nao tem marcador AUTO-GENERATED - ignorando"
            $copilotUserExternal++
            continue
        }
        Remove-IfExists -Path $file -Label "copilot-user/agents/$name.agent.md"
        $copilotUserRemoved++
    }

    $copilotUserManifestPath = Join-Path $COPILOT_USER_DIR ".ai_software_factory_manifest.json"
    if ($Full) {
        Remove-IfExists -Path $copilotUserManifestPath -Label "Copilot user .ai_software_factory_manifest.json"
    } else {
        Write-Skip "Manifesto Copilot user preservado (use -Full para remover)"
    }

    $userRemaining = Get-ChildItem -Path $COPILOT_USER_AGENTS_DIR -ErrorAction SilentlyContinue
    if (-not $userRemaining -or $userRemaining.Count -eq 0) {
        Remove-IfExists -Path $COPILOT_USER_AGENTS_DIR -Label "~/.copilot/agents/" -Recurse
    }
}

Write-Host "  ---------------------------------" -ForegroundColor DarkGray
Write-Host "  Prompt files: $copilotRemoved removidos, $copilotSkipped nao encontrados, $copilotExternal externos ignorados" -ForegroundColor Gray
Write-Host "  WS agents:    $copilotWsRemoved removidos, $copilotWsSkipped nao encontrados, $copilotWsExternal externos ignorados" -ForegroundColor Gray
Write-Host "  User agents:  $copilotUserRemoved removidos, $copilotUserSkipped nao encontrados, $copilotUserExternal externos ignorados" -ForegroundColor Gray
Write-Host "  Ext agents:   $copilotExtRemoved removidos, $copilotExtSkipped nao encontrados, $copilotExtExternal externos ignorados" -ForegroundColor Gray

# =============================================================================
#  3 - ~/.claude.json: remover mcpServers.knowledge
# =============================================================================
Write-Header ".claude.json - MCP entry"

if (Test-Path $CLAUDE_SETTINGS) {
    try {
        $raw      = Get-Content $CLAUDE_SETTINGS -Raw -Encoding UTF8
        $settings = ConvertFrom-JsonSafe $raw

        if ($settings.Contains("mcpServers") -and $settings["mcpServers"] -and $settings["mcpServers"].Contains("knowledge")) {
            if ($WhatIf) {
                Write-What "Removeria mcpServers.knowledge de ~/.claude.json"
            } else {
                $tsBackup = "$CLAUDE_SETTINGS.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                Copy-Item $CLAUDE_SETTINGS $tsBackup -Force
                Write-Host "  [BAK]  $tsBackup" -ForegroundColor DarkGray

                $settings["mcpServers"].Remove("knowledge")
                if ($settings["mcpServers"].Count -eq 0) { $settings.Remove("mcpServers") }

                $newJson  = $settings | ConvertTo-Json -Depth 20
                $tmpFile  = "$CLAUDE_SETTINGS.tmp"
                [System.IO.File]::WriteAllText($tmpFile, ($newJson -replace "`r`n","`n"), $utf8NoBom)
                Move-Item $tmpFile $CLAUDE_SETTINGS -Force
                Write-OK "mcpServers.knowledge removido de ~/.claude.json"
            }
        } else {
            Write-Skip "mcpServers.knowledge nao encontrado em ~/.claude.json"
        }
    } catch {
        Write-Warn "Nao foi possivel editar ~/.claude.json: $_"
    }
} else {
    Write-Skip "~/.claude.json nao encontrado"
}

# --- Backups do .claude.json (modo -Full) ---------------------------------
if ($Full) {
    $bakFiles = @(
        Get-ChildItem "$CLAUDE_SETTINGS.bak_*" -ErrorAction SilentlyContinue
        Get-ChildItem "$CLAUDE_SETTINGS.invalid_*" -ErrorAction SilentlyContinue
    )
    if ($bakFiles.Count -gt 0) {
        foreach ($bak in $bakFiles) {
            Remove-IfExists -Path $bak.FullName -Label $bak.Name
        }
    } else {
        Write-Skip "Nenhum backup de .claude.json encontrado"
    }
}

# =============================================================================
#  4 - ~/.codex/config.toml: remover bloco MCP gerenciado
# =============================================================================
Write-Header ".codex/config.toml - MCP entry"

if (Test-Path $CODEX_CONFIG) {
    try {
        $begin = "# BEGIN ai_software_factory:codex-mcp"
        $end = "# END ai_software_factory:codex-mcp"
        $raw = Get-Content $CODEX_CONFIG -Raw -Encoding UTF8
        $start = $raw.IndexOf($begin)
        $endIndex = if ($start -ge 0) { $raw.IndexOf($end, $start) } else { -1 }

        if ($start -ge 0 -and $endIndex -ge $start) {
            if ($WhatIf) {
                Write-What "Removeria bloco ai_software_factory de ~/.codex/config.toml"
            } else {
                $tsBackup = "$CODEX_CONFIG.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                Copy-Item $CODEX_CONFIG $tsBackup -Force
                Write-Host "  [BAK]  $tsBackup" -ForegroundColor DarkGray

                $endAfter = $endIndex + $end.Length
                while ($endAfter -lt $raw.Length -and ($raw[$endAfter] -eq [char]13 -or $raw[$endAfter] -eq [char]10)) { $endAfter++ }
                $newToml = ($raw.Substring(0, $start).TrimEnd() + [Environment]::NewLine + [Environment]::NewLine + $raw.Substring($endAfter).TrimStart()).Trim()
                if ($newToml) {
                    [System.IO.File]::WriteAllText($CODEX_CONFIG, ($newToml + [Environment]::NewLine), $utf8NoBom)
                } else {
                    Remove-Item $CODEX_CONFIG -Force
                }
                Write-OK "Bloco ai_software_factory removido de ~/.codex/config.toml"
            }
        } else {
            Write-Skip "Bloco ai_software_factory nao encontrado em ~/.codex/config.toml"
        }
    } catch {
        Write-Warn "Nao foi possivel editar ~/.codex/config.toml: $_"
    }
} else {
    Write-Skip "~/.codex/config.toml nao encontrado"
}

# =============================================================================
#  4B - mcp_config.json (Antigravity): remover mcpServers.knowledge
# =============================================================================
Write-Header "mcp_config.json (Antigravity) - MCP entry"

if (Test-Path $GEMINI_MCP_CONFIG) {
    try {
        $raw = Get-Content $GEMINI_MCP_CONFIG -Raw -Encoding UTF8
        if ($raw -and $raw.Trim()) {
            $settings = ConvertFrom-JsonSafe $raw
            if ($settings.Contains("mcpServers") -and $settings["mcpServers"] -and $settings["mcpServers"].Contains("knowledge")) {
                if ($WhatIf) {
                    Write-What "Removeria mcpServers.knowledge de mcp_config.json"
                } else {
                    $tsBackup = "$GEMINI_MCP_CONFIG.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                    Copy-Item $GEMINI_MCP_CONFIG $tsBackup -Force
                    Write-Host "  [BAK]  $tsBackup" -ForegroundColor DarkGray

                    $settings["mcpServers"].Remove("knowledge")
                    if ($settings["mcpServers"].Count -eq 0) { $settings.Remove("mcpServers") }

                    $newJson = $settings | ConvertTo-Json -Depth 10
                    $tmpFile = "$GEMINI_MCP_CONFIG.tmp"
                    [System.IO.File]::WriteAllText($tmpFile, ($newJson -replace "`r`n","`n"), $utf8NoBom)
                    Move-Item $tmpFile $GEMINI_MCP_CONFIG -Force
                    Write-OK "mcpServers.knowledge removido de mcp_config.json"
                }
            } else {
                Write-Skip "mcpServers.knowledge nao encontrado em mcp_config.json"
            }
        }
    } catch {
        Write-Warn "Nao foi possivel editar mcp_config.json: $_"
    }
} else {
    Write-Skip "mcp_config.json nao encontrado"
}

# =============================================================================
#  4C - VS Code User mcp.json: remover servers.knowledge
# =============================================================================
Write-Header "VS Code User mcp.json - MCP entry"

if (Test-Path $VSCODE_GLOBAL_MCP) {
    try {
        $vscodeUserRaw = Get-Content $VSCODE_GLOBAL_MCP -Raw -Encoding UTF8
        if ($vscodeUserRaw -and $vscodeUserRaw.Trim()) {
            $vscodeUserSettings = ConvertFrom-JsonSafe $vscodeUserRaw
            if ($vscodeUserSettings.Contains("servers") -and $vscodeUserSettings["servers"] -and $vscodeUserSettings["servers"].Contains("knowledge")) {
                if ($WhatIf) {
                    Write-What "Removeria servers.knowledge de VS Code User mcp.json"
                } else {
                    $tsBackup = "$VSCODE_GLOBAL_MCP.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                    Copy-Item $VSCODE_GLOBAL_MCP $tsBackup -Force
                    Write-Host "  [BAK]  $tsBackup" -ForegroundColor DarkGray

                    $vscodeUserSettings["servers"].Remove("knowledge")
                    $newJson = $vscodeUserSettings | ConvertTo-Json -Depth 10
                    $tmpSettings = "$VSCODE_GLOBAL_MCP.tmp"
                    [System.IO.File]::WriteAllText($tmpSettings, ($newJson -replace "`r`n","`n"), $utf8NoBom)
                    Move-Item $tmpSettings $VSCODE_GLOBAL_MCP -Force
                    Write-OK "servers.knowledge removido de VS Code User mcp.json"
                }
            } else {
                Write-Skip "servers.knowledge nao encontrado em VS Code User mcp.json"
            }
        }
    } catch {
        Write-Warn "Nao foi possivel editar VS Code User mcp.json: $_"
    }
} else {
    Write-Skip "VS Code User mcp.json nao encontrado"
}

# =============================================================================
#  5 - Scripts auxiliares legados
# =============================================================================
Write-Header "Scripts auxiliares legados"

Remove-IfExists -Path (Join-Path $BIN_DIR "factory.ps1") -Label "~/.local/bin/factory.ps1 (legado)"

# =============================================================================
#  6 - Arquivos gerados no repositorio
# =============================================================================
Write-Header "Arquivos gerados no repositorio"

# Sempre removidos (gerados, nao contem dados do usuario)
$alwaysRemove = @(
    "knowledge-config.json",
    ".mcp.json",
    "tools\mcp-knowledge-search\.requirements.hash"
)
foreach ($rel in $alwaysRemove) {
    Remove-IfExists -Path (Join-Path $FACTORY_PATH $rel) -Label $rel
}

$projectCodexConfig = Join-Path $FACTORY_PATH ".codex\config.toml"
if (Test-Path $projectCodexConfig) {
    $projectCodexRaw = Get-Content $projectCodexConfig -Raw -Encoding UTF8
    if ($projectCodexRaw -match "AUTO-GENERATED BY ai_software_factory/install.ps1") {
        Remove-IfExists -Path $projectCodexConfig -Label ".codex/config.toml"
    } else {
        Write-Warn ".codex/config.toml existe mas nao parece gerado pela factory - preservado"
    }
}

if (Test-Path $VSCODE_MCP_CONFIG) {
    $vscodeRaw = Get-Content $VSCODE_MCP_CONFIG -Raw -Encoding UTF8
    if ($vscodeRaw -like "*tools/mcp-knowledge-search/server.py*" -or $vscodeRaw -like "*knowledge.db*") {
        Remove-IfExists -Path $VSCODE_MCP_CONFIG -Label ".vscode/mcp.json"
        $remainingVscode = Get-ChildItem -Path $VSCODE_DIR -ErrorAction SilentlyContinue
        if (-not $remainingVscode -or $remainingVscode.Count -eq 0) {
            Remove-IfExists -Path $VSCODE_DIR -Label ".vscode/" -Recurse
        }
    } else {
        Write-Warn ".vscode/mcp.json existe mas nao parece gerado pela factory - preservado"
    }
}

# knowledge.db - so em -Full (modo padrao preserva)
if ($Full) {
    Remove-IfExists -Path (Join-Path $FACTORY_PATH "knowledge.db")     -Label "knowledge.db"
    Remove-IfExists -Path (Join-Path $FACTORY_PATH "knowledge.db.bak") -Label "knowledge.db.bak"

    $logsDir = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\logs"
    Remove-IfExists -Path $logsDir -Label "tools/mcp-knowledge-search/logs/" -Recurse
} else {
    Write-Skip "knowledge.db preservado (use -Full para remover)"
    Write-Skip "Logs preservados (use -Full para remover)"
}

# =============================================================================
#  7 - Scripts gerados (restaurar via git se possivel)
# =============================================================================
Write-Header "Scripts gerados - restaurar via git"

$generatedScripts = @("update-knowledge.ps1", "link-mcp.ps1")
foreach ($f in $generatedScripts) {
    $scriptPath = Join-Path $FACTORY_PATH $f
    if (-not (Test-Path $scriptPath)) { Write-Skip "Nao encontrado: $f"; continue }
    if ($WhatIf) {
        Write-What "Restauraria via git: $f"
    } else {
        try {
            $prevGitEAP = $ErrorActionPreference
            $ErrorActionPreference = "SilentlyContinue"
            git -C $FACTORY_PATH checkout -- $f 2>&1 | Out-Null
            $ErrorActionPreference = $prevGitEAP
            if ($LASTEXITCODE -eq 0) {
                Write-OK "Restaurado via git: $f"
            } else {
                Write-Warn "git checkout falhou para $f (nao e repositorio git ou arquivo nao rastreado)"
            }
        } catch {
            Write-Warn "git nao disponivel - $f mantido como esta"
        }
    }
}

# =============================================================================
#  8 - FACTORY_ROOT (apenas -Full)
# =============================================================================
Write-Header "FACTORY_ROOT"

if ($Full) {
    $currentVal = [System.Environment]::GetEnvironmentVariable("FACTORY_ROOT", "User")
    if ($currentVal) {
        if ($WhatIf) {
            Write-What "Removeria variavel FACTORY_ROOT (era: $currentVal)"
        } else {
            [System.Environment]::SetEnvironmentVariable("FACTORY_ROOT", $null, "User")
            Remove-Item Env:\FACTORY_ROOT -ErrorAction SilentlyContinue
            Write-OK "Variavel FACTORY_ROOT removida"
        }
    } else {
        Write-Skip "FACTORY_ROOT nao estava definida"
    }
} else {
    Write-Skip "FACTORY_ROOT preservada (use -Full para remover)"
}

# =============================================================================
#  9 - Dependencias Python (apenas -Full)
# =============================================================================
Write-Header "Dependencias Python"

if ($Full) {
    $REQUIREMENTS_PATH = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\requirements.txt"
    $pythonCmd = $null
    foreach ($cmd in @("python", "python3", "py")) {
        try {
            $ver = & $cmd --version 2>&1
            if ($LASTEXITCODE -eq 0) { $pythonCmd = $cmd; break }
        } catch {}
    }

    if ($pythonCmd -and (Test-Path $REQUIREMENTS_PATH)) {
        if ($WhatIf) {
            Write-What "Desinstalaria pacotes de requirements.txt via pip"
        } else {
            Write-Host "  Desinstalando pacotes..." -ForegroundColor DarkGray
            $prevPipEAP = $ErrorActionPreference
            $ErrorActionPreference = "SilentlyContinue"
            try {
                & $pythonCmd -m pip uninstall -r $REQUIREMENTS_PATH -y -q 2>&1 | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }
            } finally {
                $ErrorActionPreference = $prevPipEAP
            }
            if ($LASTEXITCODE -eq 0) {
                Write-OK "Pacotes Python desinstalados"
            } else {
                Write-Warn "Alguns pacotes podem nao ter sido removidos"
            }
        }
    } elseif (-not $pythonCmd) {
        Write-Skip "Python nao encontrado"
    } else {
        Write-Skip "requirements.txt nao encontrado"
    }
} else {
    Write-Skip "Dependencias Python preservadas (use -Full para remover)"
}

# =============================================================================
#  RESUMO
# =============================================================================
Write-Host ""
if ($WhatIf) {
    Write-Host "  +===================================================+" -ForegroundColor DarkCyan
    Write-Host "  |        WhatIf - nenhuma alteracao feita          |" -ForegroundColor DarkCyan
    Write-Host "  +===================================================+" -ForegroundColor DarkCyan
    Write-Host ""
    Write-Host "  Para executar: remova -WhatIf do comando" -ForegroundColor Gray
} else {
    Write-Host "  +===================================================+" -ForegroundColor Green
    Write-Host "  |             Desinstalacao concluida              |" -ForegroundColor Green
    Write-Host "  +===================================================+" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Modo: $modeLabel" -ForegroundColor Gray
    Write-Host ""

    if (-not $Full) {
        Write-Host "  Preservados:" -ForegroundColor Gray
        Write-Host "    knowledge.db, logs, FACTORY_ROOT, dependencias Python"
        Write-Host "    Use -Full para remover tudo"
        Write-Host ""
    }

    Write-Host "  Para reinstalar:" -ForegroundColor Cyan
    Write-Host "    cd '$FACTORY_PATH' && .\install.ps1"
}
Write-Host ""
