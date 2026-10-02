# install.ps1 - AI Software Factory Global Installer
# Uso: .\install.ps1 [-ForceDeps]
# Documentacao: docs/INSTALL_CLI.md

param(
    [switch]$ForceDeps,          # Forca reinstalacao das dependencias Python
    [string[]]$Runtime,          # Runtimes a instalar: claude, codex, antigravity, copilot, all
    [switch]$Claude,             # Instalar para Claude Code (~/.claude/agents/)
    [switch]$Codex,              # Instalar para Codex (~/.codex/agents/)
    [switch]$Antigravity,        # Instalar para Antigravity (~/.gemini/.../skills/)
    [switch]$Copilot,            # Instalar para GitHub Copilot (.github/prompts/)
    [switch]$All,                # Instalar para todos os runtimes suportados
    [switch]$NonInteractive      # Executar sem prompts interativos
)

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

# --- Utilitarios de output ----------------------------------------------------
function Write-Header($t) {
    Write-Host ""
    Write-Host "  $t" -ForegroundColor Cyan
    Write-Host ("  " + "-" * $t.Length) -ForegroundColor DarkGray
}
function Write-OK($m)   { Write-Host "  [OK]   $m" -ForegroundColor Green }
function Write-Skip($m) { Write-Host "  [SKIP] $m" -ForegroundColor DarkGray }
function Write-Warn($m) { Write-Host "  [WARN] $m" -ForegroundColor Yellow }
function Write-Fail($m) { Write-Host "  [FAIL] $m" -ForegroundColor Red }

# --- Escrita idempotente ------------------------------------------------------
# Normaliza para LF, compara com conteudo em disco, escreve apenas se mudou.
# Retorna "created", "updated" ou "unchanged".
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)

function Write-IfChanged {
    param(
        [string]$Path,
        [string]$Content,
        [string]$Label
    )
    $normalized = $Content -replace "`r`n", "`n" -replace "`r", "`n"
    $changed = $true
    $status  = "created"

    if (Test-Path $Path) {
        $existing = [System.IO.File]::ReadAllText($Path, $utf8NoBom) -replace "`r`n", "`n" -replace "`r", "`n"
        if ($existing -eq $normalized) {
            Write-Skip "$Label (sem mudancas)"
            return "unchanged"
        }
        $status = "updated"
    }

    [System.IO.File]::WriteAllText($Path, $normalized, $utf8NoBom)
    Write-OK "$Label ($status)"
    return $status
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

function ConvertTo-TomlString {
    param([string]$Value)
    $escaped = $Value.Replace("\", "\\").Replace('"', '\"')
    return '"' + $escaped + '"'
}

function ConvertTo-TomlMultilineString {
    param([string]$Value)
    $escaped = $Value.Replace("\", "\\").Replace('"""', '\"""')
    return '"""' + "`n" + $escaped.TrimEnd() + "`n" + '"""'
}

function Set-ManagedTextBlock {
    param(
        [string]$Path,
        [string]$BeginMarker,
        [string]$EndMarker,
        [string]$Block,
        [string]$Label
    )

    $parent = Split-Path $Path
    if ($parent -and -not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    $existing = if (Test-Path $Path) {
        [System.IO.File]::ReadAllText($Path, $utf8NoBom)
    } else { "" }

    $normalizedBlock = $Block.Trim() + "`n"
    $start = $existing.IndexOf($BeginMarker)
    $end = if ($start -ge 0) { $existing.IndexOf($EndMarker, $start) } else { -1 }

    if ($start -ge 0 -and $end -ge $start) {
        $endAfter = $end + $EndMarker.Length
        while ($endAfter -lt $existing.Length -and ($existing[$endAfter] -eq "`r" -or $existing[$endAfter] -eq "`n")) {
            $endAfter++
        }
        $updated = $existing.Substring(0, $start).TrimEnd() + "`n`n" + $normalizedBlock + $existing.Substring($endAfter).TrimStart()
    } elseif ($existing.Trim()) {
        $updated = $existing.TrimEnd() + "`n`n" + $normalizedBlock
    } else {
        $updated = $normalizedBlock
    }

    return Write-IfChanged -Path $Path -Content $updated -Label $Label
}

# --- Caminhos base ------------------------------------------------------------
$FACTORY_PATH      = (Get-Location).Path
$CLAUDE_AGENTS_DIR = "$env:USERPROFILE\.claude\agents"
$CLAUDE_SETTINGS   = "$env:USERPROFILE\.claude.json"
$CODEX_HOME_DIR    = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE ".codex" }
$CODEX_AGENTS_DIR  = Join-Path $CODEX_HOME_DIR "agents"
$CODEX_CONFIG      = Join-Path $CODEX_HOME_DIR "config.toml"
$PROJECT_CODEX_DIR = Join-Path $FACTORY_PATH ".codex"
$PROJECT_CODEX_CONFIG = Join-Path $PROJECT_CODEX_DIR "config.toml"
$GEMINI_CONFIG_DIR = Join-Path $env:USERPROFILE ".gemini\config"
$GEMINI_MCP_SETTINGS = Join-Path $GEMINI_CONFIG_DIR "mcp_config.json"
$GEMINI_PLUGIN_DIR = Join-Path $GEMINI_CONFIG_DIR "plugins\ai-software-factory"
$GEMINI_SKILLS_DIR = Join-Path $GEMINI_PLUGIN_DIR "skills"
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
$DB_PATH           = Join-Path $FACTORY_PATH "knowledge.db"
$CONFIG_PATH       = Join-Path $FACTORY_PATH "knowledge-config.json"
$SERVER_PATH       = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\server.py"
$INGEST_PATH       = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\ingest.py"
$REQUIREMENTS_PATH = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\requirements.txt"
$REQ_HASH_FILE     = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\.requirements.hash"
$FACTORY_VERSION   = if (Test-Path (Join-Path $FACTORY_PATH "VERSION")) {
    (Get-Content (Join-Path $FACTORY_PATH "VERSION") -Raw).Trim()
} else { "0.0.0" }

# --- Mapeamento de agentes ----------------------------------------------------
$agents = @(
    @{ Folder = "Agente00_TechLead";                Name = "techlead";     Description = "Tech Lead e orquestrador do SDLC - quality gates, ADRs, decisoes tecnicas e oversight do projeto" },
    @{ Folder = "Agente01_ProductOwner";            Name = "po";           Description = "Product Owner - user stories, criterios de aceitacao, backlog e definicao de escopo" },
    @{ Folder = "Agente02_SoftwareArchitect";       Name = "architect";    Description = "Arquiteto de Software - design de sistemas, diagramas UML, decisoes de arquitetura e ADRs" },
    @{ Folder = "Agente03_SoftwareEngineer";        Name = "engineer";     Description = "Engenheiro de Software - decomposicao de tarefas, planejamento de implementacao e estimativas" },
    @{ Folder = "Agente04_DevBackend";              Name = "devbackend";   Description = "Dev Backend - APIs REST, servicos, banco de dados, migrations Prisma e autenticacao" },
    @{ Folder = "Agente05_DevFrontend";             Name = "devfrontend";  Description = "Dev Frontend - componentes React, paginas Next.js, UI com Tailwind e logica de interface" },
    @{ Folder = "Agente06_QaEngineer";              Name = "qa";           Description = "QA Engineer - planos de teste, testes unitarios Vitest, E2E Playwright e cobertura de codigo" },
    @{ Folder = "Agente07_DevSecOps";               Name = "devsecops";    Description = "DevSecOps - auditorias de seguranca, SAST, OWASP Top 10, hardening e secrets management" },
    @{ Folder = "Agente08_DevOps";                  Name = "devops";       Description = "DevOps - CI/CD, infraestrutura Vercel, monitoramento, deployment e runbooks operacionais" },
    @{ Folder = "Agente09_UxUiDesigner";            Name = "uxui";         Description = "UX/UI Designer - pesquisa de usuario, wireframes, design system e acessibilidade" },
    @{ Folder = "Agente10_DataIntegrationEngineer"; Name = "dataengineer"; Description = "Data Engineer - pipelines de dados, ETL, integracoes de sistemas e governanca de dados" },
    @{ Folder = "Agente11_DataAnalyst";             Name = "dataanalyst";  Description = "Data Analyst - metricas, analise exploratoria, insights e especificacao de dashboards" }
)

$knowledgeFiles = @(
    "knowledge\principles.md",
    "knowledge\heuristics.md",
    "knowledge\decision_rules.md",
    "knowledge\knowledge_cards.md",
    "skills_manifest.md",
    "quality_gate.md",
    "context_view.md",
    "failure_modes.md"
)

# --- Contadores do resumo -----------------------------------------------------
$tally = @{
    agents_created        = 0
    agents_updated        = 0
    agents_unchanged      = 0
    codex_created         = 0
    codex_updated         = 0
    codex_unchanged       = 0
    antigravity_created   = 0
    antigravity_updated   = 0
    antigravity_unchanged = 0
    copilot_created         = 0
    copilot_updated         = 0
    copilot_unchanged       = 0
    copilot_ws_created      = 0
    copilot_ws_updated      = 0
    copilot_ws_unchanged    = 0
    copilot_user_created    = 0
    copilot_user_updated    = 0
    copilot_user_unchanged  = 0
    copilot_instr_status  = "unchanged"
    knowledge_docs        = 0
    knowledge_status      = "skipped"
    mcp_status            = "unchanged"
    claude_mcp_status     = "unchanged"
    codex_mcp_status      = "unchanged"
    codex_project_status  = "unchanged"
    gemini_mcp_status        = "unchanged"
    vscode_mcp_status        = "unchanged"
    vscode_global_mcp_status = "unchanged"
    deps_status              = "skipped"
    scripts_updated       = 0
    scripts_unchanged     = 0
}

# =============================================================================
#  BANNER
# =============================================================================
Write-Host ""
Write-Host "  +===================================================+" -ForegroundColor Blue
Write-Host "  |      AI Software Factory - Global Installer      |" -ForegroundColor Blue
Write-Host "  +===================================================+" -ForegroundColor Blue
Write-Host ""
Write-Host "  Factory: $FACTORY_PATH" -ForegroundColor Gray
Write-Host "  Version: $FACTORY_VERSION" -ForegroundColor DarkGray
Write-Host ""

# --- Deteccao de runtimes no sistema ------------------------------------------
$detected = [ordered]@{
    claude      = $false
    codex       = $false
    antigravity = $false
    copilot     = $false
}
$detectionDetails = @{}

# Claude Code
if (Get-Command claude -ErrorAction SilentlyContinue) {
    $detected.claude = $true
    $detectionDetails["claude"] = "CLI 'claude' encontrado no PATH"
} elseif (Test-Path "$env:USERPROFILE\.claude") {
    $detected.claude = $true
    $detectionDetails["claude"] = "~/.claude encontrado"
}

# Codex
$detectedCodexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE ".codex" }
if (Get-Command codex -ErrorAction SilentlyContinue) {
    $detected.codex = $true
    $detectionDetails["codex"] = "CLI 'codex' encontrado no PATH"
} elseif (Test-Path $detectedCodexHome) {
    $detected.codex = $true
    $detectionDetails["codex"] = "$detectedCodexHome encontrado"
}

# Antigravity
if (Get-Command agy -ErrorAction SilentlyContinue) {
    $detected.antigravity = $true
    $detectionDetails["antigravity"] = "CLI 'agy' encontrado no PATH"
} elseif (Test-Path "$env:USERPROFILE\.gemini") {
    $detected.antigravity = $true
    $detectionDetails["antigravity"] = "~/.gemini encontrado"
}

# GitHub Copilot
if (Get-Command code -ErrorAction SilentlyContinue) {
    $detected.copilot = $true
    $detectionDetails["copilot"] = "VS Code ('code') encontrado no PATH"
} elseif (Test-Path "$env:USERPROFILE\.vscode") {
    $detected.copilot = $true
    $detectionDetails["copilot"] = "~/.vscode encontrado"
} elseif ((Test-Path (Join-Path $FACTORY_PATH ".vscode")) -or (Test-Path (Join-Path $FACTORY_PATH ".github"))) {
    $detected.copilot = $true
    $detectionDetails["copilot"] = "Workspace .vscode/.github"
}

# --- Resolucao dos runtimes selecionados --------------------------------------
$enableClaude      = $false
$enableCodex       = $false
$enableAntigravity = $false
$enableCopilot     = $false

$hasExplicitSelection = $All -or $Claude -or $Codex -or $Antigravity -or $Copilot -or ($Runtime -and $Runtime.Count -gt 0)

if ($All) {
    $enableClaude      = $true
    $enableCodex       = $true
    $enableAntigravity = $true
    $enableCopilot     = $true
} elseif ($hasExplicitSelection) {
    $enableClaude      = [bool]$Claude
    $enableCodex       = [bool]$Codex
    $enableAntigravity = [bool]$Antigravity
    $enableCopilot     = [bool]$Copilot

    if ($Runtime) {
        foreach ($r in $Runtime) {
            switch ($r.ToLower().Trim()) {
                "all"         { $enableClaude = $true; $enableCodex = $true; $enableAntigravity = $true; $enableCopilot = $true }
                "claude"      { $enableClaude = $true }
                "codex"       { $enableCodex = $true }
                "antigravity" { $enableAntigravity = $true }
                "gemini"      { $enableAntigravity = $true }
                "copilot"     { $enableCopilot = $true }
                "github"      { $enableCopilot = $true }
            }
        }
    }
} else {
    $isInteractive = $false
    if (-not $NonInteractive -and [Environment]::UserInteractive) {
        try {
            $isInteractive = (-not [Console]::IsInputRedirected)
        } catch {
            $isInteractive = $false
        }
    }

    if ($isInteractive) {
        Write-Host "  Runtimes de IA detectados neste ambiente:" -ForegroundColor Cyan
        Write-Host ("    [{0}] Claude Code      {1}" -f $(if ($detected.claude) {"X"} else {" "}), $(if ($detected.claude) {"($($detectionDetails['claude']))"} else {"(nao detectado)"})) -ForegroundColor $(if ($detected.claude) {"Green"} else {"DarkGray"})
        Write-Host ("    [{0}] Codex            {1}" -f $(if ($detected.codex) {"X"} else {" "}), $(if ($detected.codex) {"($($detectionDetails['codex']))"} else {"(nao detectado)"})) -ForegroundColor $(if ($detected.codex) {"Green"} else {"DarkGray"})
        Write-Host ("    [{0}] Antigravity      {1}" -f $(if ($detected.antigravity) {"X"} else {" "}), $(if ($detected.antigravity) {"($($detectionDetails['antigravity']))"} else {"(nao detectado)"})) -ForegroundColor $(if ($detected.antigravity) {"Green"} else {"DarkGray"})
        Write-Host ("    [{0}] GitHub Copilot   {1}" -f $(if ($detected.copilot) {"X"} else {" "}), $(if ($detected.copilot) {"($($detectionDetails['copilot']))"} else {"(nao detectado)"})) -ForegroundColor $(if ($detected.copilot) {"Green"} else {"DarkGray"})
        Write-Host ""
        Write-Host "  Opcoes de instalacao:" -ForegroundColor Cyan
        Write-Host "    [D] Instalar apenas para os runtimes detectados (Padrao)" -ForegroundColor Yellow
        Write-Host "    [A] Instalar para TODOS os runtimes suportados"
        Write-Host "    [C] Personalizar selecao (escolher um por um)"
        Write-Host "    [Q] Cancelar e sair"
        Write-Host ""

        $choice = Read-Host "  Escolha [D/a/c/q] (padrao: D)"
        $choice = if ([string]::IsNullOrWhiteSpace($choice)) { "D" } else { $choice.Trim().ToUpper() }

        switch ($choice) {
            "A" {
                $enableClaude      = $true
                $enableCodex       = $true
                $enableAntigravity = $true
                $enableCopilot     = $true
            }
            "C" {
                Write-Host ""
                Write-Host "  Selecao personalizada:" -ForegroundColor Cyan
                $ans = Read-Host "    Instalar para Claude Code? [s/N]"
                $enableClaude = ($ans -match '^[sSyY]')
                $ans = Read-Host "    Instalar para Codex? [s/N]"
                $enableCodex = ($ans -match '^[sSyY]')
                $ans = Read-Host "    Instalar para Antigravity? [S/n]"
                $enableAntigravity = ([string]::IsNullOrWhiteSpace($ans) -or $ans -match '^[sSyY]')
                $ans = Read-Host "    Instalar para GitHub Copilot? [S/n]"
                $enableCopilot = ([string]::IsNullOrWhiteSpace($ans) -or $ans -match '^[sSyY]')
            }
            "Q" {
                Write-Host "  Instalacao cancelada pelo usuario." -ForegroundColor Yellow
                exit 0
            }
            default {
                $enableClaude      = $detected.claude
                $enableCodex       = $detected.codex
                $enableAntigravity = $detected.antigravity
                $enableCopilot     = $detected.copilot

                if (-not ($enableClaude -or $enableCodex -or $enableAntigravity -or $enableCopilot)) {
                    Write-Host "  Nenhum runtime detectado automaticamente. Habilitando todos por padrao." -ForegroundColor Yellow
                    $enableClaude      = $true
                    $enableCodex       = $true
                    $enableAntigravity = $true
                    $enableCopilot     = $true
                }
            }
        }
    } else {
        $hasAnyDetected = $detected.claude -or $detected.codex -or $detected.antigravity -or $detected.copilot
        if ($hasAnyDetected) {
            $enableClaude      = $detected.claude
            $enableCodex       = $detected.codex
            $enableAntigravity = $detected.antigravity
            $enableCopilot     = $detected.copilot
        } else {
            $enableClaude      = $true
            $enableCodex       = $true
            $enableAntigravity = $true
            $enableCopilot     = $true
        }
    }
}

if (-not ($enableClaude -or $enableCodex -or $enableAntigravity -or $enableCopilot)) {
    Write-Warn "Nenhum runtime selecionado. Nada a ser instalado."
    exit 0
}

$selectedNames = @()
if ($enableClaude)      { $selectedNames += "Claude Code" }
if ($enableCodex)       { $selectedNames += "Codex" }
if ($enableAntigravity) { $selectedNames += "Antigravity" }
if ($enableCopilot)     { $selectedNames += "GitHub Copilot" }

Write-Host ("  Runtimes selecionados: " + ($selectedNames -join ", ")) -ForegroundColor Green
Write-Host ""

# =============================================================================
#  FASE 1 - FACTORY_ROOT
# =============================================================================
$frWasUnset = -not [System.Environment]::GetEnvironmentVariable("FACTORY_ROOT", "User")
Write-Header "FACTORY_ROOT"
[System.Environment]::SetEnvironmentVariable("FACTORY_ROOT", $FACTORY_PATH, [System.EnvironmentVariableTarget]::User)
$env:FACTORY_ROOT = $FACTORY_PATH
Write-OK "FACTORY_ROOT = $FACTORY_PATH"
Write-OK "Variavel de ambiente de usuario configurada"

# =============================================================================
#  FASE 2 - Python
# =============================================================================
Write-Header "Python"
$pythonCmd = $null
$hasPython = $false
foreach ($cmd in @("python", "python3", "py")) {
    try {
        $ver = & $cmd --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            $pythonCmd = $cmd
            $hasPython = $true
            Write-OK "$cmd - $ver"
            break
        }
    } catch {}
}
if (-not $hasPython) {
    Write-Warn "Python nao encontrado no PATH."
    Write-Warn "  MCP/RAG nao sera configurado nesta instalacao."
    Write-Warn "  Instale Python 3.x e re-execute install.ps1 para ativar o RAG."
}

# =============================================================================
#  FASE 3 - Dependencias pip (hash-driven)
# =============================================================================
if ($hasPython) {
    Write-Header "Dependencias MCP"

    if (Test-Path $REQUIREMENTS_PATH) {
        $reqHash    = (Get-FileHash $REQUIREMENTS_PATH -Algorithm SHA256).Hash
        $savedHash  = if (Test-Path $REQ_HASH_FILE) { (Get-Content $REQ_HASH_FILE -Raw).Trim() } else { "" }

        # Verificar se mcp esta instalado
        $mcpMissing = $true
        $prevEAP = $ErrorActionPreference
        $ErrorActionPreference = "SilentlyContinue"
        try {
            $null = & $pythonCmd -c "import mcp" 2>$null
            $mcpMissing = ($LASTEXITCODE -ne 0)
        } catch {
            $mcpMissing = $true
        } finally {
            $ErrorActionPreference = $prevEAP
        }

        $needsPip = $ForceDeps -or $mcpMissing -or ($reqHash -ne $savedHash)

        if ($needsPip) {
            $reason = if ($ForceDeps) { "-ForceDeps" } elseif ($mcpMissing) { "mcp ausente" } else { "requirements.txt modificado" }
            Write-Host "  Instalando dependencias ($reason)..." -ForegroundColor DarkGray
            $prevEAP = $ErrorActionPreference
            $ErrorActionPreference = "SilentlyContinue"
            try {
                & $pythonCmd -m pip install -r $REQUIREMENTS_PATH -q
            } finally {
                $ErrorActionPreference = $prevEAP
            }
            if ($LASTEXITCODE -eq 0) {
                Set-Content $REQ_HASH_FILE -Value $reqHash -Encoding UTF8
                Write-OK "Dependencias instaladas"
                $tally.deps_status = "installed"
            } else {
                Write-Warn "Falha ao instalar dependencias. MCP pode nao funcionar."
                $hasPython = $false
                $tally.deps_status = "failed"
            }
        } else {
            Write-Skip "Dependencias ja satisfeitas (hash inalterado)"
            $tally.deps_status = "skipped"
        }
    } else {
        Write-Skip "requirements.txt nao encontrado"
    }
}

# =============================================================================
#  FASE 4 - Claude Code: ~/.claude/agents/
# =============================================================================
$manifest     = $null
$manifestPath = $null

if ($enableClaude) {
    Write-Header "Claude Code - Agentes"

if (-not (Test-Path $CLAUDE_AGENTS_DIR)) {
    New-Item -ItemType Directory -Path $CLAUDE_AGENTS_DIR -Force | Out-Null
    Write-OK "Criado: $CLAUDE_AGENTS_DIR"
} else {
    Write-Skip "Ja existe: $CLAUDE_AGENTS_DIR"
}

$mcpBlock = @"

---

<!-- BEGIN ai_software_factory:mcp-knowledge -->
## Acesso ao Conhecimento via MCP

Este agente tem acesso ao banco de conhecimento completo da AI Software Factory
via servidor MCP "knowledge" (SQLite FTS5 full-text search).

**MCP-first policy:**
Consulte o MCP antes de responder sobre qualquer knowledge interna da factory (skills, schemas, templates, examples, checklists, playbooks, Golden Models, gates, failure modes, knowledge cards, heuristicas, principios).

Nao invente artefatos. Busque primeiro.

Antes de afirmar que uma skill/schema/template/checklist nao existe, consulte o MCP.

**Se o MCP falhar:**
1. Informe explicitamente que o MCP falhou.
2. Declare que esta usando fallback via leitura direta de arquivos.
3. Recomende: ``& "`$env:FACTORY_ROOT\test-mcp.ps1"``
4. Prossiga com fallback declarado se seguro - nunca use fallback silencioso.

### Ferramentas disponiveis

| Ferramenta | Quando usar | Parametros principais |
|-----------|-------------|----------------------|
| ``health_check()`` | Verificar saude do MCP: DB existe, FTS funciona, conta docs | nenhum |
| ``knowledge_stats()`` | Ver estatisticas do banco e categorias indexadas | nenhum |
| ``search_knowledge("termo")`` | Busca full-text geral em todos os artefatos | ``query``, ``category`` (opcional), ``limit`` (default 20) |
| ``search_with_filters("termo", filters="{}")`` | Busca com filtros de metadata (categoria, tipo, agente) | ``query``, ``filters`` (JSON string), ``limit`` |
| ``get_full_document("doc_id")`` | Obter documento completo por ID retornado pelo search | ``doc_id`` |
| ``get_context("doc_id")`` | Obter secoes adjacentes do mesmo arquivo | ``doc_id``, ``window`` (default 5) |

**Prefira ``search_with_filters`` quando souber a categoria ou tipo do artefato.**

### O que esta indexado

- ``Agente*/knowledge/`` - principles, heuristics, decision_rules, knowledge_cards
- ``Agente*/skills/`` - documentacao e checklists de cada skill
- ``Agente*/schemas/`` - contratos JSON de input/output
- ``Agente*/templates/`` - templates de artefatos
- ``Agente*/examples/`` - exemplos bom/ruim de outputs
- ``Agente*/checklists/`` - checklists operacionais
- ``bibliography/playbooks/`` - playbooks de engenharia

### FACTORY_ROOT

$FACTORY_PATH

Para acessar arquivos diretamente: leia a partir de FACTORY_ROOT.
<!-- END ai_software_factory:mcp-knowledge -->
"@

$factoryAgentNames = $agents | ForEach-Object { "$($_.Name).md" }

# Preservar installed_at do manifesto existente para idempotencia
$manifestPath       = Join-Path $CLAUDE_AGENTS_DIR ".ai_software_factory_manifest.json"
$existingInstalledAt = if (Test-Path $manifestPath) {
    try { (Get-Content $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json).installed_at } catch { $null }
} else { $null }

# Manifesto de instalacao - rastreamento do que foi criado/atualizado
$manifest = [ordered]@{
    factory_version   = $FACTORY_VERSION
    factory_root      = $FACTORY_PATH
    installed_at      = if ($existingInstalledAt) { $existingInstalledAt } else { (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") }
    knowledge_db_path = $DB_PATH
    knowledge_db_hash = $null
    mcp_server        = "knowledge"
    agents            = [ordered]@{}
    scripts           = [ordered]@{
        install          = Join-Path $FACTORY_PATH "install.ps1"
        uninstall        = Join-Path $FACTORY_PATH "uninstall.ps1"
        update_knowledge = Join-Path $FACTORY_PATH "update-knowledge.ps1"
        test_mcp         = Join-Path $FACTORY_PATH "test-mcp.ps1"
        doctor           = Join-Path $FACTORY_PATH "doctor.ps1"
        link_mcp         = Join-Path $FACTORY_PATH "link-mcp.ps1"
    }
}

foreach ($agent in $agents) {
    $agentDir   = Join-Path $FACTORY_PATH $agent.Folder
    $promptFile = Join-Path $agentDir "prompt.md"
    $outputFile = Join-Path $CLAUDE_AGENTS_DIR "$($agent.Name).md"

    if (-not (Test-Path $promptFile)) {
        Write-Warn "prompt.md nao encontrado: $($agent.Folder)"
        $manifest.agents[$agent.Name] = [ordered]@{ status = "skipped"; source = $agent.Folder; reason = "prompt.md not found" }
        continue
    }

    $autoGeneratedHeader = @"
<!--
AUTO-GENERATED BY ai_software_factory/install.ps1
DO NOT EDIT DIRECTLY - changes will be overwritten on next install.
To update: cd $FACTORY_PATH && .\install.ps1
Sources: $($agent.Folder)/prompt.md + $($agent.Folder)/knowledge/* + install.ps1 mcpBlock
-->
"@

    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine("---")
    [void]$sb.AppendLine("name: $($agent.Name)")
    [void]$sb.AppendLine("description: $($agent.Description)")
    [void]$sb.AppendLine("---")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine($autoGeneratedHeader.TrimEnd())
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("<!-- BEGIN ai_software_factory managed block -->")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine((Get-Content $promptFile -Raw -Encoding UTF8).TrimEnd())
    [void]$sb.AppendLine("")

    foreach ($relPath in $knowledgeFiles) {
        $fullPath = Join-Path $agentDir $relPath
        if (Test-Path $fullPath) {
            $display = "$($agent.Folder)/$($relPath.Replace('\','/'))"
            [void]$sb.AppendLine("---")
            [void]$sb.AppendLine("<!-- SOURCE: $display -->")
            [void]$sb.AppendLine("")
            [void]$sb.AppendLine((Get-Content $fullPath -Raw -Encoding UTF8).TrimEnd())
            [void]$sb.AppendLine("")
        }
    }

    [void]$sb.AppendLine($mcpBlock)
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("<!-- END ai_software_factory managed block -->")

    $status = Write-IfChanged -Path $outputFile -Content $sb.ToString() -Label "@$($agent.Name)"
    switch ($status) {
        "created"   { $tally.agents_created++ }
        "updated"   { $tally.agents_updated++ }
        "unchanged" { $tally.agents_unchanged++ }
    }
    $sourceHash    = (Get-FileHash $promptFile -Algorithm SHA256).Hash.Substring(0, 16)
    $installedHash = if (Test-Path $outputFile) { (Get-FileHash $outputFile -Algorithm SHA256).Hash.Substring(0, 16) } else { $null }
    $manifest.agents[$agent.Name] = [ordered]@{
        status         = $status
        source         = $agent.Folder
        source_hash    = $sourceHash
        installed_path = $outputFile
        installed_hash = $installedHash
    }
}

    Write-Host "  ---------------------------------" -ForegroundColor DarkGray
    Write-Host ("  Agentes: {0} criados, {1} atualizados, {2} sem mudancas" -f `
        $tally.agents_created, $tally.agents_updated, $tally.agents_unchanged) -ForegroundColor Gray
} else {
    Write-Header "Claude Code - Agentes"
    Write-Skip "Runtime Claude Code nao selecionado para instalacao"
}

# =============================================================================
#  FASE 5 - Codex: ~/.codex/agents/
# =============================================================================
if ($enableCodex) {
    Write-Header "Codex - Custom Agents"

if (-not (Test-Path $CODEX_AGENTS_DIR)) {
    New-Item -ItemType Directory -Path $CODEX_AGENTS_DIR -Force | Out-Null
    Write-OK "Criado: $CODEX_AGENTS_DIR"
} else {
    Write-Skip "Ja existe: $CODEX_AGENTS_DIR"
}

$codexMcpBlock = @"

---

<!-- BEGIN ai_software_factory:codex-runtime -->
## Codex Runtime

Este arquivo e um custom agent do Codex. Ele e usado como subagente quando o
usuario pede explicitamente para delegar trabalho a um papel especializado
(por exemplo: "use o agente qa" ou "spawn techlead e architect").

No Codex, a invocacao principal nao usa a sintaxe Claude `@nome`. Use:
- `AGENTS.md` para instrucoes persistentes do repositorio.
- `.codex/config.toml` ou `~/.codex/config.toml` para MCP e settings.
- `~/.codex/agents/*.toml` para estes custom agents.

## Acesso ao Conhecimento via MCP

Use o servidor MCP `knowledge` antes de responder sobre artefatos internos da
factory: skills, schemas, templates, examples, checklists, playbooks, Golden
Models, gates, failure modes, knowledge cards, heuristicas e principios.

Se o MCP falhar:
1. Informe explicitamente que o MCP falhou.
2. Declare que esta usando fallback via leitura direta de arquivos.
3. Recomende: `& "$env:FACTORY_ROOT\test-mcp.ps1"`.
4. Prossiga com fallback declarado se seguro; nunca use fallback silencioso.

Ferramentas esperadas: `health_check`, `knowledge_stats`, `search_knowledge`,
`search_with_filters`, `get_full_document`, `get_context`.

## Isolamento runtime

No runtime, leia primeiro apenas a pasta do agente (`AgenteXX_*`) e o MCP
knowledge. `context/` e `lib/` sao fontes build-time e nao devem ser usadas
para substituir knowledge destilada, salvo instrucao explicita do usuario.

FACTORY_ROOT deve apontar para a raiz da factory. Se estiver ausente, peca ao
usuario para executar `install.ps1` a partir da factory.
<!-- END ai_software_factory:codex-runtime -->
"@

$codexManifestPath = Join-Path $CODEX_AGENTS_DIR ".ai_software_factory_manifest.json"
$existingCodexInstalledAt = if (Test-Path $codexManifestPath) {
    try { (Get-Content $codexManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json).installed_at } catch { $null }
} else { $null }

$codexManifest = [ordered]@{
    factory_version   = $FACTORY_VERSION
    factory_root      = $FACTORY_PATH
    installed_at      = if ($existingCodexInstalledAt) { $existingCodexInstalledAt } else { (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") }
    knowledge_db_path = $DB_PATH
    mcp_server        = "knowledge"
    agents            = [ordered]@{}
}

foreach ($agent in $agents) {
    $agentDir   = Join-Path $FACTORY_PATH $agent.Folder
    $promptFile = Join-Path $agentDir "prompt.md"
    $outputFile = Join-Path $CODEX_AGENTS_DIR "$($agent.Name).toml"

    if (-not (Test-Path $promptFile)) {
        Write-Warn "prompt.md nao encontrado: $($agent.Folder)"
        $codexManifest.agents[$agent.Name] = [ordered]@{ status = "skipped"; source = $agent.Folder; reason = "prompt.md not found" }
        continue
    }

    $agentInstructions = [System.Text.StringBuilder]::new()
    [void]$agentInstructions.AppendLine("<!--")
    [void]$agentInstructions.AppendLine("AUTO-GENERATED BY ai_software_factory/install.ps1")
    [void]$agentInstructions.AppendLine("DO NOT EDIT DIRECTLY - changes will be overwritten on next install.")
    [void]$agentInstructions.AppendLine("To update: cd `$env:FACTORY_ROOT && .\install.ps1")
    [void]$agentInstructions.AppendLine("Sources: $($agent.Folder)/prompt.md + selected runtime knowledge files + install.ps1 codexMcpBlock")
    [void]$agentInstructions.AppendLine("-->")
    [void]$agentInstructions.AppendLine("")
    [void]$agentInstructions.AppendLine("<!-- BEGIN ai_software_factory managed block -->")
    [void]$agentInstructions.AppendLine("")
    [void]$agentInstructions.AppendLine((Get-Content $promptFile -Raw -Encoding UTF8).TrimEnd())
    [void]$agentInstructions.AppendLine("")

    foreach ($relPath in $knowledgeFiles) {
        $fullPath = Join-Path $agentDir $relPath
        if (Test-Path $fullPath) {
            $display = "$($agent.Folder)/$($relPath.Replace('\','/'))"
            [void]$agentInstructions.AppendLine("---")
            [void]$agentInstructions.AppendLine("<!-- SOURCE: $display -->")
            [void]$agentInstructions.AppendLine("")
            [void]$agentInstructions.AppendLine((Get-Content $fullPath -Raw -Encoding UTF8).TrimEnd())
            [void]$agentInstructions.AppendLine("")
        }
    }

    [void]$agentInstructions.AppendLine($codexMcpBlock)
    [void]$agentInstructions.AppendLine("")
    [void]$agentInstructions.AppendLine("<!-- END ai_software_factory managed block -->")

    $nickname = (($agent.Description -split ' - ')[0].Trim())
    $nickname = (($nickname -replace '[^A-Za-z0-9 _-]', ' ') -replace '\s+', ' ').Trim()
    $toml = @(
        "# AUTO-GENERATED BY ai_software_factory/install.ps1",
        "# DO NOT EDIT DIRECTLY - changes will be overwritten on next install.",
        "name = $(ConvertTo-TomlString $agent.Name)",
        "description = $(ConvertTo-TomlString $agent.Description)",
        "nickname_candidates = [$(ConvertTo-TomlString $nickname)]",
        "developer_instructions = $(ConvertTo-TomlMultilineString $agentInstructions.ToString())"
    ) -join "`n"

    $status = Write-IfChanged -Path $outputFile -Content $toml -Label "codex/$($agent.Name).toml"
    switch ($status) {
        "created"   { $tally.codex_created++ }
        "updated"   { $tally.codex_updated++ }
        "unchanged" { $tally.codex_unchanged++ }
    }

    $sourceHash    = (Get-FileHash $promptFile -Algorithm SHA256).Hash.Substring(0, 16)
    $installedHash = if (Test-Path $outputFile) { (Get-FileHash $outputFile -Algorithm SHA256).Hash.Substring(0, 16) } else { $null }
    $codexManifest.agents[$agent.Name] = [ordered]@{
        status         = $status
        source         = $agent.Folder
        source_hash    = $sourceHash
        installed_path = $outputFile
        installed_hash = $installedHash
    }
}

$codexManifestJson = $codexManifest | ConvertTo-Json -Depth 10
Write-IfChanged -Path $codexManifestPath -Content $codexManifestJson -Label "codex/.ai_software_factory_manifest.json" | Out-Null

    Write-Host "  ---------------------------------" -ForegroundColor DarkGray
    Write-Host ("  Codex agents: {0} criados, {1} atualizados, {2} sem mudancas" -f `
        $tally.codex_created, $tally.codex_updated, $tally.codex_unchanged) -ForegroundColor Gray
} else {
    Write-Header "Codex - Custom Agents"
    Write-Skip "Runtime Codex nao selecionado para instalacao"
}

# =============================================================================
#  FASE 5B - Antigravity: ~/.gemini/config/plugins/ai-software-factory/
# =============================================================================
if ($enableAntigravity) {
    Write-Header "Antigravity - Plugin e Skills"

if (-not (Test-Path $GEMINI_SKILLS_DIR)) {
    New-Item -ItemType Directory -Path $GEMINI_SKILLS_DIR -Force | Out-Null
    Write-OK "Criado: $GEMINI_SKILLS_DIR"
} else {
    Write-Skip "Ja existe: $GEMINI_SKILLS_DIR"
}

# Manifest do plugin
$pluginJson = [ordered]@{
    name        = "ai-software-factory"
    version     = $FACTORY_VERSION
    description = "AI Software Factory - Framework SDLC com 12 agentes especializados, Quality Gates, State Ledger, ADRs e busca semantica via MCP."
    author      = [ordered]@{ name = "AI Software Factory" }
    keywords    = @("sdlc", "multi-agent", "software-engineering", "quality-gates", "mcp")
} | ConvertTo-Json -Depth 5
Write-IfChanged -Path (Join-Path $GEMINI_PLUGIN_DIR "plugin.json") -Content $pluginJson -Label "antigravity/plugin.json" | Out-Null

# plugin mcp_config.json
$pluginMcpConfig = [ordered]@{
    mcpServers = [ordered]@{
        knowledge = [ordered]@{
            command = "python"
            args    = @($SERVER_PATH)
            env     = [ordered]@{ KNOWLEDGE_DB = $DB_PATH }
            tools   = [ordered]@{
                search_knowledge    = [ordered]@{ eager = $true }
                get_full_document   = [ordered]@{ eager = $true }
                get_context         = [ordered]@{ eager = $true }
                health_check        = [ordered]@{ eager = $true }
                knowledge_stats     = [ordered]@{ eager = $true }
                search_with_filters = [ordered]@{ eager = $true }
            }
        }
    }
} | ConvertTo-Json -Depth 6
Write-IfChanged -Path (Join-Path $GEMINI_PLUGIN_DIR "mcp_config.json") -Content $pluginMcpConfig -Label "antigravity/mcp_config.json" | Out-Null

$antigravityMcpBlock = @"

---

<!-- BEGIN ai_software_factory:antigravity-runtime -->
## Antigravity Runtime

Esta skill representa o agente especializado no runtime do Google Antigravity.
Ela e ativada sob demanda (progressive disclosure) para orientar este papel no SDLC.

### Uso do Conhecimento via MCP

Consulte o servidor MCP ``knowledge`` antes de responder sobre artefatos internos da factory:
skills, schemas, templates, examples, checklists, playbooks, Golden Models, quality gates,
failure modes, knowledge cards, heuristicas e principios.

Ferramentas MCP disponiveis no Antigravity:
- ``mcp_knowledge_search_knowledge`` ou ``search_knowledge``
- ``mcp_knowledge_search_with_filters`` ou ``search_with_filters``
- ``mcp_knowledge_get_full_document`` ou ``get_full_document``
- ``mcp_knowledge_get_context`` ou ``get_context``
- ``mcp_knowledge_knowledge_stats`` ou ``knowledge_stats``
- ``mcp_knowledge_health_check`` ou ``health_check``

### Politica de Fallback

Se o MCP falhar ou estiver indisponivel:
1. Declare explicitamente que o MCP falhou ou esta indisponivel nesta sessao.
2. Utilize leitura direta de arquivos apenas como fallback declarado.
3. FACTORY_ROOT: $FACTORY_PATH
4. Recomende: `& "`$env:FACTORY_ROOT\test-mcp.ps1"` ou `& "`$env:FACTORY_ROOT\doctor.ps1"`.
5. NUNCA utilize fallback silencioso.

### Isolamento de Fontes

No runtime, utilize apenas os arquivos da pasta do agente e o MCP knowledge.
Fontes como ``context/`` e ``lib/`` sao exclusivas de build-time e nao devem ser consultadas em tempo de execucao,
salvo pedido explicito do usuario.
<!-- END ai_software_factory:antigravity-runtime -->
"@

$antigravityManifestPath = Join-Path $GEMINI_PLUGIN_DIR ".ai_software_factory_manifest.json"
$existingAntigravityInstalledAt = if (Test-Path $antigravityManifestPath) {
    try { (Get-Content $antigravityManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json).installed_at } catch { $null }
} else { $null }

$antigravityManifest = [ordered]@{
    factory_version   = $FACTORY_VERSION
    factory_root      = $FACTORY_PATH
    installed_at      = if ($existingAntigravityInstalledAt) { $existingAntigravityInstalledAt } else { (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") }
    knowledge_db_path = $DB_PATH
    mcp_server        = "knowledge"
    skills            = [ordered]@{}
}

# Limpar versoes legadas com prefixo factory- se existirem
Get-ChildItem -Path $GEMINI_SKILLS_DIR -Directory -Filter "factory-*" -ErrorAction SilentlyContinue | ForEach-Object {
    Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
}

foreach ($agent in $agents) {
    $agentDir   = Join-Path $FACTORY_PATH $agent.Folder
    $promptFile = Join-Path $agentDir "prompt.md"
    $skillFolder = Join-Path $GEMINI_SKILLS_DIR $agent.Name
    if (-not (Test-Path $skillFolder)) {
        New-Item -ItemType Directory -Path $skillFolder -Force | Out-Null
    }
    $outputFile = Join-Path $skillFolder "SKILL.md"

    if (-not (Test-Path $promptFile)) {
        Write-Warn "prompt.md nao encontrado: $($agent.Folder)"
        $antigravityManifest.skills[$agent.Name] = [ordered]@{ status = "skipped"; source = $agent.Folder; reason = "prompt.md not found" }
        continue
    }

    $skillHeader = @"
---
name: $($agent.Name)
description: >-
  $($agent.Description). Use esta skill quando o usuario pedir acoes de $($agent.Name), analise, revisao de qualidade ou artefatos relacionados a este papel no SDLC.
---

<!--
AUTO-GENERATED BY ai_software_factory/install.ps1
DO NOT EDIT DIRECTLY - changes will be overwritten on next install.
To update: cd $FACTORY_PATH && .\install.ps1
Sources: $($agent.Folder)/prompt.md + selected runtime knowledge files + install.ps1 antigravityMcpBlock
-->
"@

    $sbSkill = [System.Text.StringBuilder]::new()
    [void]$sbSkill.AppendLine($skillHeader.TrimEnd())
    [void]$sbSkill.AppendLine("")
    [void]$sbSkill.AppendLine("<!-- BEGIN ai_software_factory managed block -->")
    [void]$sbSkill.AppendLine("")
    [void]$sbSkill.AppendLine((Get-Content $promptFile -Raw -Encoding UTF8).TrimEnd())
    [void]$sbSkill.AppendLine("")

    foreach ($relPath in $knowledgeFiles) {
        $fullPath = Join-Path $agentDir $relPath
        if (Test-Path $fullPath) {
            $display = "$($agent.Folder)/$($relPath.Replace('\','/'))"
            [void]$sbSkill.AppendLine("---")
            [void]$sbSkill.AppendLine("<!-- SOURCE: $display -->")
            [void]$sbSkill.AppendLine("")
            [void]$sbSkill.AppendLine((Get-Content $fullPath -Raw -Encoding UTF8).TrimEnd())
            [void]$sbSkill.AppendLine("")
        }
    }

    [void]$sbSkill.AppendLine($antigravityMcpBlock)
    [void]$sbSkill.AppendLine("")
    [void]$sbSkill.AppendLine("<!-- END ai_software_factory managed block -->")

    $status = Write-IfChanged -Path $outputFile -Content $sbSkill.ToString() -Label "antigravity/$($agent.Name)"
    switch ($status) {
        "created"   { $tally.antigravity_created++ }
        "updated"   { $tally.antigravity_updated++ }
        "unchanged" { $tally.antigravity_unchanged++ }
    }

    $sourceHash    = (Get-FileHash $promptFile -Algorithm SHA256).Hash.Substring(0, 16)
    $installedHash = if (Test-Path $outputFile) { (Get-FileHash $outputFile -Algorithm SHA256).Hash.Substring(0, 16) } else { $null }
    $antigravityManifest.skills[$agent.Name] = [ordered]@{
        status         = $status
        source         = $agent.Folder
        source_hash    = $sourceHash
        installed_path = $outputFile
        installed_hash = $installedHash
    }
}

$antigravityManifestJson = $antigravityManifest | ConvertTo-Json -Depth 10
Write-IfChanged -Path $antigravityManifestPath -Content $antigravityManifestJson -Label "antigravity/.ai_software_factory_manifest.json" | Out-Null

    Write-Host "  ---------------------------------" -ForegroundColor DarkGray
    Write-Host ("  Antigravity skills: {0} criadas, {1} atualizadas, {2} sem mudancas" -f `
        $tally.antigravity_created, $tally.antigravity_updated, $tally.antigravity_unchanged) -ForegroundColor Gray
} else {
    Write-Header "Antigravity - Plugin e Skills"
    Write-Skip "Runtime Antigravity nao selecionado para instalacao"
}

# =============================================================================
#  FASE 5C - GitHub Copilot: .github/prompts/ & copilot-instructions.md
# =============================================================================
if ($enableCopilot) {
    Write-Header "GitHub Copilot - Prompt Files e Instructions"

if (-not (Test-Path $COPILOT_DIR)) {
    New-Item -ItemType Directory -Path $COPILOT_DIR -Force | Out-Null
}
if (-not (Test-Path $COPILOT_PROMPTS_DIR)) {
    New-Item -ItemType Directory -Path $COPILOT_PROMPTS_DIR -Force | Out-Null
    Write-OK "Criado: $COPILOT_PROMPTS_DIR"
} else {
    Write-Skip "Ja existe: $COPILOT_PROMPTS_DIR"
}
if (-not (Test-Path $COPILOT_AGENTS_DIR)) {
    New-Item -ItemType Directory -Path $COPILOT_AGENTS_DIR -Force | Out-Null
    Write-OK "Criado: $COPILOT_AGENTS_DIR"
} else {
    Write-Skip "Ja existe: $COPILOT_AGENTS_DIR"
}

# Diretorios de agentes do usuario (~/.copilot/agents/)
if (-not (Test-Path $COPILOT_USER_DIR)) {
    New-Item -ItemType Directory -Path $COPILOT_USER_DIR -Force | Out-Null
}
if (-not (Test-Path $COPILOT_USER_AGENTS_DIR)) {
    New-Item -ItemType Directory -Path $COPILOT_USER_AGENTS_DIR -Force | Out-Null
    Write-OK "Criado: $COPILOT_USER_AGENTS_DIR"
} else {
    Write-Skip "Ja existe: $COPILOT_USER_AGENTS_DIR"
}

# Auto-limpeza de extensao legada (~/.vscode/extensions/ai-software-factory.agents/)
# O Copilot carrega agentes nativamente de ~/.copilot/agents/. Manter a extensao causa agentes duplicados no picker.
if (Test-Path $COPILOT_EXT_DIR) {
    try {
        Remove-Item -Recurse -Force $COPILOT_EXT_DIR -ErrorAction Stop
        Write-OK "Removida extensao legada duplicada: $COPILOT_EXT_DIR"
    } catch {
        Write-Warn "Nao foi possivel remover extensao legada $COPILOT_EXT_DIR : $_"
    }
}

# 1. Gerar .github/copilot-instructions.md
$copilotInstructionsContent = @"
<!--
AUTO-GENERATED BY ai_software_factory/install.ps1
DO NOT EDIT DIRECTLY - changes will be overwritten on next install.
To update: .\install.ps1
-->

# AI Software Factory - Diretrizes para GitHub Copilot

Este repositorio opera como uma **AI Software Factory**, implementando um framework SDLC (Software Development Life Cycle) multiagente com 12 personas especializadas, Quality Gates inviolaveis, State Ledger e busca semantica de conhecimento via MCP.

Ao interagir neste projeto ou em projetos vinculados a factory, o GitHub Copilot deve aderir estritamente as regras de engenharia abaixo.

---

## 1. Personas e Papeis Especializados

A factory conta com 12 personas especializadas. No GitHub Copilot (VS Code Chat ou Agent mode), utilize os arquivos de prompt reutilizaveis em `.github/prompts/<nome>.prompt.md` ou solicite explicitamente para atuar sob o papel correspondente:

| Papel | Prompt File | Responsabilidade Principal |
|---|---|---|
| ``techlead`` | ``.github/prompts/techlead.prompt.md`` | Tech Lead, orquestrador do SDLC, validacao de Quality Gates, ADRs, State Ledger |
| ``po`` | ``.github/prompts/po.prompt.md`` | Product Owner, PRD, user stories, criterios de aceitacao e backlog |
| ``architect`` | ``.github/prompts/architect.prompt.md`` | Arquiteto de Software, design de sistemas, diagramas UML, decisoes arquiteturais e ADRs |
| ``engineer`` | ``.github/prompts/engineer.prompt.md`` | Engenheiro de Software, decomposicao de tarefas, planos de execucao e estimativas |
| ``devbackend`` | ``.github/prompts/devbackend.prompt.md`` | Dev Backend, APIs REST, servicos, banco de dados, migrations Prisma e autenticacao |
| ``devfrontend`` | ``.github/prompts/devfrontend.prompt.md`` | Dev Frontend, componentes React, paginas Next.js, UI com Tailwind e acessibilidade |
| ``qa`` | ``.github/prompts/qa.prompt.md`` | QA Engineer, estrategia de testes, Vitest, Playwright E2E e cobertura |
| ``devsecops`` | ``.github/prompts/devsecops.prompt.md`` | DevSecOps, auditorias de seguranca, SAST, OWASP Top 10, hardening e secrets |
| ``devops`` | ``.github/prompts/devops.prompt.md`` | DevOps, CI/CD, infraestrutura Vercel, deployment e runbooks operacionais |
| ``uxui`` | ``.github/prompts/uxui.prompt.md`` | UX/UI Designer, fluxos de usuario, wireframes, design system e acessibilidade |
| ``dataengineer`` | ``.github/prompts/dataengineer.prompt.md`` | Data Engineer, pipelines de dados, ETL, integracoes e governanca |
| ``dataanalyst`` | ``.github/prompts/dataanalyst.prompt.md`` | Data Analyst, metricas, analise exploratoria, insights e dashboards |

---

## 2. Regras Inviolaveis do SDLC

1. **Quality Gates Obrigatorios**:
   - Nenhuma funcionalidade avanca sem a aprovacao explicita do gate correspondente:
     - **G0 (Problema/PRD)**: Aprovado pelo PO.
     - **G1 (Arquitetura & ADRs)**: Aprovado pelo Architect.
     - **G2 (Decomposicao & Plano)**: Aprovado pelo Engineer.
     - **G3 (Implementacao)**: Desenvolvido por DevBackend / DevFrontend / DataEngineer.
     - **G4 (Seguranca & Hardening)**: Aprovado pelo DevSecOps.
     - **G5 (Garantia de Qualidade & Testes)**: Aprovado pelo QA.
     - **G6 (Deploy & Observabilidade)**: Aprovado pelo DevOps.
   - O **Tech Lead** audita e valida todas as transicoes entre gates.

2. **Decisoes Arquiteturais Exigem ADRs**:
   - Qualquer decisao tecnica com impacto estrutural (banco de dados, protocolo, autenticacao, framework) DEVE ser registrada em um Architecture Decision Record (ADR) numerado e formal.

3. **Rastreabilidade e State Ledger**:
   - Manter registro claro do progresso e do estado das tarefas (status dos gates, riscos, decisoes pendentes).

4. **Definition of Done (DoD)**:
   - Codigo nao e considerado pronto sem testes automatizados (unitarios e/ou integracao), conformidade de seguranca e documentacao do artefato.

---

## 3. Isolamento entre Build-time e Runtime

- **Fontes de Build-time**: ``context/``, ``lib/``, bibliografia e referencias globais de arquitetura. Sao usadas exclusivamente para destilar o conhecimento e gerar os prompts.
- **Fontes de Runtime**: A pasta do agente correspondente (``AgenteXX_*/``, especialmente ``knowledge/``) e o servidor MCP ``knowledge``.
- O GitHub Copilot **NAO** deve consultar ``context/`` ou ``lib/`` em tempo de execucao para substituir o conhecimento destilado, salvo instrucao explicita do usuario.

---

## 4. Servidor MCP de Conhecimento (``knowledge``)

No VS Code com Copilot Agent Mode, o servidor MCP esta configurado em ``.vscode/mcp.json``. Ele indexa todos os artefatos canonicos da factory (principios, heuristicas, cards, playbooks, schemas, templates, checklists).

### Ferramentas MCP Disponiveis
- ``search_knowledge``: Busca full-text com operadores FTS5 (AND, OR, NOT, "frase").
- ``search_with_filters``: Busca com filtros por categoria ou metadados.
- ``get_full_document``: Retorna o documento completo sem truncamento dado seu doc_id.
- ``get_context``: Retorna documentos adjacentes no mesmo arquivo.
- ``knowledge_stats``: Estatisticas da base e contagem de documentos.
- ``health_check``: Valida a saude do servidor MCP.

### Politica MCP-First e Fallback
- **Consulte o MCP primeiro** para esclarecer duvidas sobre os padroes, templates e regras da factory.
- Se o MCP falhar ou estiver indisponivel no ambiente:
  1. Declare explicitamente que o servidor MCP nao esta disponivel.
  2. Use a leitura direta de arquivos (``AgenteXX_*/knowledge/*``) apenas como fallback declarado.
  3. Recomende a execucao de `.\test-mcp.ps1` ou `.\doctor.ps1`.
  4. NUNCA use fallback silencioso.
"@

$tally.copilot_instr_status = Write-IfChanged -Path $COPILOT_INSTRUCTIONS -Content $copilotInstructionsContent -Label ".github/copilot-instructions.md"

# 2. Gerar Prompt Files (.github/prompts/*.prompt.md)
$copilotMcpBlock = @"

---

<!-- BEGIN ai_software_factory:copilot-runtime -->
## GitHub Copilot Runtime

Este arquivo e um prompt reutilizavel do GitHub Copilot (VS Code Prompt File).
Ao carregar este prompt no Copilot Chat ou no VS Code Agent mode, assuma a persona,
as responsabilidades e os padroes de qualidade definidos acima para atuar como o agente.

### Regras do Papel no SDLC
- Respeite rigorosamente os Quality Gates associados ao seu papel.
- Mantenha a rastreabilidade atraves do State Ledger.
- Crie ADRs para decisoes tecnicas estruturais.
- Garanta a Definition of Done antes de aprovar qualquer entrega.

### Acesso ao Conhecimento via MCP
Consulte o servidor MCP ``knowledge`` antes de responder sobre artefatos internos da factory:
skills, schemas, templates, examples, checklists, playbooks, Golden Models, quality gates,
failure modes, knowledge cards, heuristicas e principios.

Ferramentas MCP disponiveis no VS Code:
- ``search_knowledge`` ou ``knowledge_search_knowledge``
- ``search_with_filters`` ou ``knowledge_search_with_filters``
- ``get_full_document`` ou ``knowledge_get_full_document``
- ``get_context`` ou ``knowledge_get_context``
- ``knowledge_stats`` ou ``knowledge_knowledge_stats``
- ``health_check`` ou ``knowledge_health_check``

### Politica de Fallback
Se o servidor MCP ``knowledge`` nao estiver conectado ou falhar:
1. Declare explicitamente que o MCP esta indisponivel.
2. Utilize leitura direta dos arquivos do agente como fallback declarado.
3. FACTORY_ROOT: utilize a variavel `$env:FACTORY_ROOT` ou a raiz deste repositorio
4. NUNCA utilize fallback silencioso.

### Isolamento de Fontes
No runtime, utilize apenas os arquivos da pasta do agente (``AgenteXX_*``) e o MCP knowledge.
As pastas ``context/`` e ``lib/`` sao exclusivas de build-time e nao devem ser consultadas em tempo de execucao, salvo instrucao explicita do usuario.
<!-- END ai_software_factory:copilot-runtime -->
"@

$copilotManifestPath = Join-Path $COPILOT_PROMPTS_DIR ".ai_software_factory_manifest.json"
$existingCopilotInstalledAt = if (Test-Path $copilotManifestPath) {
    try { (Get-Content $copilotManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json).installed_at } catch { $null }
} else { $null }

$copilotManifest = [ordered]@{
    factory_version   = $FACTORY_VERSION
    factory_root      = $FACTORY_PATH
    installed_at      = if ($existingCopilotInstalledAt) { $existingCopilotInstalledAt } else { (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") }
    knowledge_db_path = $DB_PATH
    mcp_server        = "knowledge"
    prompts           = [ordered]@{}
}

$copilotWsManifestPath = Join-Path $COPILOT_AGENTS_DIR ".ai_software_factory_manifest.json"
$existingWsInstalledAt = if (Test-Path $copilotWsManifestPath) {
    try { (Get-Content $copilotWsManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json).installed_at } catch { $null }
} else { $null }

$copilotWsManifest = [ordered]@{
    factory_version   = $FACTORY_VERSION
    factory_root      = $FACTORY_PATH
    installed_at      = if ($existingWsInstalledAt) { $existingWsInstalledAt } else { (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") }
    knowledge_db_path = $DB_PATH
    mcp_server        = "knowledge"
    agents            = [ordered]@{}
}

$copilotUserManifestPath = Join-Path $COPILOT_USER_DIR ".ai_software_factory_manifest.json"
$existingUserInstalledAt = if (Test-Path $copilotUserManifestPath) {
    try { (Get-Content $copilotUserManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json).installed_at } catch { $null }
} else { $null }

$copilotUserManifest = [ordered]@{
    factory_version   = $FACTORY_VERSION
    factory_root      = $FACTORY_PATH
    installed_at      = if ($existingUserInstalledAt) { $existingUserInstalledAt } else { (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ") }
    knowledge_db_path = $DB_PATH
    mcp_server        = "knowledge"
    agents            = [ordered]@{}
}

foreach ($agent in $agents) {
    $agentDir       = Join-Path $FACTORY_PATH $agent.Folder
    $promptFile     = Join-Path $agentDir "prompt.md"
    $outputFile     = Join-Path $COPILOT_PROMPTS_DIR "$($agent.Name).prompt.md"
    $wsOutputFile   = Join-Path $COPILOT_AGENTS_DIR "$($agent.Name).agent.md"
    $userOutputFile = Join-Path $COPILOT_USER_AGENTS_DIR "$($agent.Name).agent.md"

    if (-not (Test-Path $promptFile)) {
        Write-Warn "prompt.md nao encontrado: $($agent.Folder)"
        $copilotManifest.prompts[$agent.Name]     = [ordered]@{ status = "skipped"; source = $agent.Folder; reason = "prompt.md not found" }
        $copilotWsManifest.agents[$agent.Name]   = [ordered]@{ status = "skipped"; source = $agent.Folder; reason = "prompt.md not found" }
        $copilotUserManifest.agents[$agent.Name] = [ordered]@{ status = "skipped"; source = $agent.Folder; reason = "prompt.md not found" }
        continue
    }

    # Montar corpo gerenciado compartilhado (prompt.md + runtime knowledge + MCP block)
    $sbManaged = [System.Text.StringBuilder]::new()
    [void]$sbManaged.AppendLine("<!-- BEGIN ai_software_factory managed block -->")
    [void]$sbManaged.AppendLine("")
    [void]$sbManaged.AppendLine((Get-Content $promptFile -Raw -Encoding UTF8).TrimEnd())
    [void]$sbManaged.AppendLine("")

    foreach ($relPath in $knowledgeFiles) {
        $fullPath = Join-Path $agentDir $relPath
        if (Test-Path $fullPath) {
            $display = "$($agent.Folder)/$($relPath.Replace('\','/'))"
            [void]$sbManaged.AppendLine("---")
            [void]$sbManaged.AppendLine("<!-- SOURCE: $display -->")
            [void]$sbManaged.AppendLine("")
            [void]$sbManaged.AppendLine((Get-Content $fullPath -Raw -Encoding UTF8).TrimEnd())
            [void]$sbManaged.AppendLine("")
        }
    }

    [void]$sbManaged.AppendLine($copilotMcpBlock)
    [void]$sbManaged.AppendLine("")
    [void]$sbManaged.AppendLine("<!-- END ai_software_factory managed block -->")
    $managedBody = $sbManaged.ToString()

    # 1. Gerar .github/prompts/<name>.prompt.md (Prompt files reutilizaveis)
    $promptHeader = @"
---
description: >-
  $($agent.Description)
---

<!--
AUTO-GENERATED BY ai_software_factory/install.ps1
DO NOT EDIT DIRECTLY - changes will be overwritten on next install.
To update: .\install.ps1
Sources: $($agent.Folder)/prompt.md + selected runtime knowledge files + install.ps1 copilotMcpBlock
-->
"@
    $promptContent = $promptHeader.TrimEnd() + "`n`n" + $managedBody
    $status = Write-IfChanged -Path $outputFile -Content $promptContent -Label "copilot/$($agent.Name).prompt.md"
    switch ($status) {
        "created"   { $tally.copilot_created++ }
        "updated"   { $tally.copilot_updated++ }
        "unchanged" { $tally.copilot_unchanged++ }
    }

    $sourceHash    = (Get-FileHash $promptFile -Algorithm SHA256).Hash.Substring(0, 16)
    $installedHash = if (Test-Path $outputFile) { (Get-FileHash $outputFile -Algorithm SHA256).Hash.Substring(0, 16) } else { $null }
    $copilotManifest.prompts[$agent.Name] = [ordered]@{
        status         = $status
        source         = $agent.Folder
        source_hash    = $sourceHash
        installed_path = $outputFile
        installed_hash = $installedHash
    }

    # 2. Gerar Definicao de Agente (.agent.md) para Workspace, Usuario e Extensao
    $agentHeader = @"
---
name: $($agent.Name)
description: >-
  $($agent.Description)
tools: [vscode, tool_search, execute, read, agent, browser, edit, search, web, knowledge/*]
---

<!--
AUTO-GENERATED BY ai_software_factory/install.ps1
DO NOT EDIT DIRECTLY - changes will be overwritten on next install.
To update: .\install.ps1
Sources: $($agent.Folder)/prompt.md + selected runtime knowledge files + install.ps1 copilotMcpBlock
-->
"@
    $agentContent = $agentHeader.TrimEnd() + "`n`n" + $managedBody

    # 2A. Workspace Custom Agent (.github/agents/<name>.agent.md)
    $wsStatus = Write-IfChanged -Path $wsOutputFile -Content $agentContent -Label "copilot-ws/agents/$($agent.Name).agent.md"
    switch ($wsStatus) {
        "created"   { $tally.copilot_ws_created++ }
        "updated"   { $tally.copilot_ws_updated++ }
        "unchanged" { $tally.copilot_ws_unchanged++ }
    }
    $wsHash = if (Test-Path $wsOutputFile) { (Get-FileHash $wsOutputFile -Algorithm SHA256).Hash.Substring(0, 16) } else { $null }
    $copilotWsManifest.agents[$agent.Name] = [ordered]@{
        status         = $wsStatus
        source         = $agent.Folder
        source_hash    = $sourceHash
        installed_path = $wsOutputFile
        installed_hash = $wsHash
    }

    # 2B. User Global Custom Agent (~/.copilot/agents/<name>.agent.md)
    $userStatus = Write-IfChanged -Path $userOutputFile -Content $agentContent -Label "copilot-user/agents/$($agent.Name).agent.md"
    switch ($userStatus) {
        "created"   { $tally.copilot_user_created++ }
        "updated"   { $tally.copilot_user_updated++ }
        "unchanged" { $tally.copilot_user_unchanged++ }
    }
    $userHash = if (Test-Path $userOutputFile) { (Get-FileHash $userOutputFile -Algorithm SHA256).Hash.Substring(0, 16) } else { $null }
    $copilotUserManifest.agents[$agent.Name] = [ordered]@{
        status         = $userStatus
        source         = $agent.Folder
        source_hash    = $sourceHash
        installed_path = $userOutputFile
        installed_hash = $userHash
    }

}

$copilotManifestJson = $copilotManifest | ConvertTo-Json -Depth 10
Write-IfChanged -Path $copilotManifestPath -Content $copilotManifestJson -Label "copilot/.ai_software_factory_manifest.json" | Out-Null

$copilotWsManifestJson = $copilotWsManifest | ConvertTo-Json -Depth 10
Write-IfChanged -Path $copilotWsManifestPath -Content $copilotWsManifestJson -Label "copilot-ws/.ai_software_factory_manifest.json" | Out-Null

$copilotUserManifestJson = $copilotUserManifest | ConvertTo-Json -Depth 10
Write-IfChanged -Path $copilotUserManifestPath -Content $copilotUserManifestJson -Label "copilot-user/.ai_software_factory_manifest.json" | Out-Null

    Write-Host "  ---------------------------------" -ForegroundColor DarkGray
    Write-Host ("  Copilot prompt files:     {0} criados, {1} atualizados, {2} sem mudancas" -f `
        $tally.copilot_created, $tally.copilot_updated, $tally.copilot_unchanged) -ForegroundColor Gray
    Write-Host ("  Copilot workspace agents: {0} criados, {1} atualizados, {2} sem mudancas" -f `
        $tally.copilot_ws_created, $tally.copilot_ws_updated, $tally.copilot_ws_unchanged) -ForegroundColor Gray
    Write-Host ("  Copilot user agents:      {0} criados, {1} atualizados, {2} sem mudancas" -f `
        $tally.copilot_user_created, $tally.copilot_user_updated, $tally.copilot_user_unchanged) -ForegroundColor Gray
} else {
    Write-Header "GitHub Copilot - Prompt Files e Instructions"
    Write-Skip "Runtime GitHub Copilot nao selecionado para instalacao"
}

# =============================================================================
#  FASE 6 - knowledge-config.json + ingest (backup/restore on failure)
# =============================================================================
if ($hasPython) {
    Write-Header "MCP Knowledge Base"

    $knowledgeConfig = [ordered]@{
        base_dir = $FACTORY_PATH
        db_path  = $DB_PATH
        sources  = @(
            [ordered]@{
                type             = "markdown"
                paths            = @("*.md")
                recursive        = $true
                split_by_heading = $true
            }
        )
    }
    $configJson = $knowledgeConfig | ConvertTo-Json -Depth 5
    Write-IfChanged -Path $CONFIG_PATH -Content $configJson -Label "knowledge-config.json" | Out-Null

    # Decidir se reindexar: pular se knowledge.db e mais recente que todos os .md
    $runIngest = $true
    if (Test-Path $DB_PATH) {
        $dbTime = (Get-Item $DB_PATH).LastWriteTime
        $newestMd = Get-ChildItem $FACTORY_PATH -Recurse -Filter "*.md" -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending |
            Select-Object -First 1
        if ($newestMd -and $newestMd.LastWriteTime -le $dbTime) {
            $runIngest = $false
        }
    }

    if (-not $runIngest) {
        # Obter contagem do DB existente sem reindexar
        try {
            $statsRaw = & $pythonCmd $INGEST_PATH --config $CONFIG_PATH --stats 2>&1 | Out-String
            $stats = $statsRaw | ConvertFrom-Json -ErrorAction SilentlyContinue
            $tally.knowledge_docs = if ($stats.total_documents) { $stats.total_documents } else { "?" }
        } catch { $tally.knowledge_docs = "?" }
        Write-Skip "knowledge.db ja atualizado ($($tally.knowledge_docs) docs)"
        $tally.knowledge_status = "unchanged"
    } elseif (Test-Path $INGEST_PATH) {
        Write-Host "  Indexando conhecimento..." -ForegroundColor DarkGray

        # Backup do DB existente para restaurar em caso de falha
        $dbBackup = "$DB_PATH.bak"
        if (Test-Path $DB_PATH) { Copy-Item $DB_PATH $dbBackup -Force }

        # Ingerir em arquivo temporario para escrita atomica
        $dbTemp       = "$DB_PATH.tmp"
        $configTemp   = "$CONFIG_PATH.tmp"
        $tempConfig   = [ordered]@{
            base_dir = $FACTORY_PATH
            db_path  = $dbTemp
            sources  = $knowledgeConfig.sources
        }
        [System.IO.File]::WriteAllText($configTemp, ($tempConfig | ConvertTo-Json -Depth 5), $utf8NoBom)

        & $pythonCmd $INGEST_PATH --config $configTemp 2>&1 | Write-Host

        if ($LASTEXITCODE -eq 0 -and (Test-Path $dbTemp)) {
            # Substituicao atomica
            if (Test-Path $DB_PATH) { Remove-Item $DB_PATH -Force }
            Move-Item $dbTemp $DB_PATH -Force
            if (Test-Path $dbBackup) { Remove-Item $dbBackup -Force }
            Remove-Item $configTemp -Force -ErrorAction SilentlyContinue

            # Capturar contagem de documentos
            try {
                $statsRaw = & $pythonCmd $INGEST_PATH --config $CONFIG_PATH --stats 2>&1 | Out-String
                $stats = $statsRaw | ConvertFrom-Json -ErrorAction SilentlyContinue
                $tally.knowledge_docs = if ($stats.total_documents) { $stats.total_documents } else { "?" }
            } catch { $tally.knowledge_docs = "?" }

            Write-OK "knowledge.db atualizado ($($tally.knowledge_docs) documentos)"
            $tally.knowledge_status = "rebuilt"
        } else {
            # Falha - restaurar backup se existir
            if (Test-Path $dbBackup) {
                Move-Item $dbBackup $DB_PATH -Force
                Write-Warn "Falha na indexacao. knowledge.db anterior restaurado."
            } else {
                Write-Warn "Falha na indexacao. Nenhum knowledge.db anterior disponivel."
            }
            if (Test-Path $dbTemp)    { Remove-Item $dbTemp    -Force -ErrorAction SilentlyContinue }
            if (Test-Path $configTemp) { Remove-Item $configTemp -Force -ErrorAction SilentlyContinue }
            $tally.knowledge_status = "failed"
        }
    } else {
        Write-Warn "ingest.py nao encontrado: $INGEST_PATH"
        $tally.knowledge_status = "failed"
    }
} else {
    Write-Header "MCP Knowledge Base"
    Write-Skip "Python nao disponivel - pulando indexacao"
    $tally.knowledge_status = "skipped"
}

# Atualizar hash do DB no manifesto (calculado apos o ingest)
if ($manifest) {
    $manifest.knowledge_db_hash = if (Test-Path $DB_PATH) {
        (Get-FileHash $DB_PATH -Algorithm SHA256).Hash.Substring(0, 16)
    } else { $null }
}

# =============================================================================
#  FASE 6 - .mcp.json + .claude.json (merge cirurgico, atomico)
# =============================================================================
Write-Header "MCP Configuration"

$mcpEntry = [ordered]@{
    type    = "stdio"
    command = "python"
    args    = @($SERVER_PATH)
    env     = [ordered]@{ KNOWLEDGE_DB = $DB_PATH }
}

# .mcp.json na raiz da factory
$mcpJson  = [ordered]@{ mcpServers = [ordered]@{ knowledge = $mcpEntry } }
$mcpJsonStr = $mcpJson | ConvertTo-Json -Depth 5
$mcpStatus = Write-IfChanged -Path (Join-Path $FACTORY_PATH ".mcp.json") -Content $mcpJsonStr -Label ".mcp.json"
$tally.mcp_status = $mcpStatus

# .claude.json global - merge cirurgico com escrita atomica
if ($enableClaude) {
    $claudeDir = Split-Path $CLAUDE_SETTINGS
    if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null }

    try {
        # Ler .claude.json existente
        $settings = [ordered]@{}
        $settingsRaw = ""
        if (Test-Path $CLAUDE_SETTINGS) {
            $settingsRaw = Get-Content $CLAUDE_SETTINGS -Raw -Encoding UTF8
        }

        $parseOk = $false
        if ($settingsRaw -and $settingsRaw.Trim()) {
            try {
                $settings = ConvertFrom-JsonSafe $settingsRaw
                $parseOk = $true
            } catch {
                # JSON invalido - criar backup antes de qualquer alteracao
                $badBackup = "$CLAUDE_SETTINGS.invalid_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                Copy-Item $CLAUDE_SETTINGS $badBackup -Force
                Write-Warn ".claude.json estava invalido. Backup criado: $badBackup"
                Write-Warn "Recriando .claude.json com apenas a entrada MCP."
            }
        }

        # Verificar se ja esta correto (evita escrita desnecessaria)
        $existing = if ($parseOk -and $settings.Contains("mcpServers")) { $settings["mcpServers"]["knowledge"] } else { $null }
        $alreadyCurrent = $existing -and
                          ($existing["type"]    -eq $mcpEntry.type) -and
                          ($existing["command"] -eq $mcpEntry.command) -and
                          ($existing["args"]    -contains $SERVER_PATH) -and
                          ($existing.Contains("env") -and $existing["env"]["KNOWLEDGE_DB"] -eq $DB_PATH)

        if ($alreadyCurrent) {
            Write-Skip ".claude.json ja configurado corretamente"
            $tally.claude_mcp_status = "unchanged"
        } else {
            # Backup com timestamp apenas quando ha mudanca real
            if ($parseOk -and (Test-Path $CLAUDE_SETTINGS)) {
                $tsBackup = "$CLAUDE_SETTINGS.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                Copy-Item $CLAUDE_SETTINGS $tsBackup -Force
                Write-Host "  [BAK]  $tsBackup" -ForegroundColor DarkGray
            }

            # Atualizar apenas a chave da factory
            if (-not $settings.Contains("mcpServers")) { $settings["mcpServers"] = [ordered]@{} }
            $settings["mcpServers"]["knowledge"] = $mcpEntry

            # Validar JSON resultante antes de escrever (depth 20 para preservar toda a estrutura)
            $newJson = $settings | ConvertTo-Json -Depth 20
            $newJson | ConvertFrom-Json | Out-Null  # lanca excecao se invalido

            # Escrita atomica: temp -> rename
            $tmpSettings = "$CLAUDE_SETTINGS.tmp"
            [System.IO.File]::WriteAllText($tmpSettings, ($newJson -replace "`r`n","`n"), $utf8NoBom)
            Move-Item $tmpSettings $CLAUDE_SETTINGS -Force

            Write-OK ".claude.json atualizado (MCP global registrado)"
            $tally.claude_mcp_status = "updated"
        }
    } catch {
        Write-Warn "Nao foi possivel atualizar .claude.json: $_"
        # Restaurar backup se disponivel
        $latestBak = Get-ChildItem "$CLAUDE_SETTINGS.bak_*" -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($latestBak) {
            Copy-Item $latestBak.FullName $CLAUDE_SETTINGS -Force
            Write-Warn ".claude.json restaurado: $($latestBak.Name)"
        }
        Write-Warn "Use link-mcp.ps1 em cada projeto como alternativa."
        $tally.claude_mcp_status = "failed"
    }
} else {
    $tally.claude_mcp_status = "pulado"
}

# Codex global config.toml - bloco gerenciado, sem sobrescrever configuracoes pessoais
if ($enableCodex) {
    $codexGlobalBegin = "# BEGIN ai_software_factory:codex-mcp"
    $codexGlobalEnd   = "# END ai_software_factory:codex-mcp"
    $codexGlobalBlock = @"
$codexGlobalBegin
[mcp_servers.knowledge]
command = "python"
args = [$(ConvertTo-TomlString $SERVER_PATH)]
startup_timeout_sec = 20
tool_timeout_sec = 60

[mcp_servers.knowledge.env]
KNOWLEDGE_DB = $(ConvertTo-TomlString $DB_PATH)
$codexGlobalEnd
"@

    try {
        $codexConfigRaw = if (Test-Path $CODEX_CONFIG) { Get-Content $CODEX_CONFIG -Raw -Encoding UTF8 } else { "" }
        $hasUnmanagedKnowledge = ($codexConfigRaw -match "(?m)^\s*\[mcp_servers\.knowledge\]\s*$") -and ($codexConfigRaw -notlike "*$codexGlobalBegin*")

        if ($hasUnmanagedKnowledge) {
            Write-Warn "Codex config ja possui [mcp_servers.knowledge] fora do bloco gerenciado; preservando configuracao existente."
            Write-Warn "  Para trocar para a factory, remova a entrada antiga e reexecute install.ps1."
            $tally.codex_mcp_status = "skipped"
        } else {
            $tally.codex_mcp_status = Set-ManagedTextBlock -Path $CODEX_CONFIG -BeginMarker $codexGlobalBegin -EndMarker $codexGlobalEnd -Block $codexGlobalBlock -Label "~/.codex/config.toml (MCP)"
        }
    } catch {
        Write-Warn "Nao foi possivel atualizar ~/.codex/config.toml: $_"
        $tally.codex_mcp_status = "failed"
    }

    # Codex project config - gerado com caminhos relativos para a propria factory
    $projectCodexConfig = @"
# AUTO-GENERATED BY ai_software_factory/install.ps1
# Project-scoped Codex configuration for this factory repository.
# Paths are resolved relative to the Codex workspace directory.

[agents]
max_threads = 6
max_depth = 1

[mcp_servers.knowledge]
command = "python"
args = ["tools/mcp-knowledge-search/server.py"]
cwd = "."
startup_timeout_sec = 20
tool_timeout_sec = 60

[mcp_servers.knowledge.env]
KNOWLEDGE_DB = "knowledge.db"
"@
    if (-not (Test-Path $PROJECT_CODEX_DIR)) { New-Item -ItemType Directory -Path $PROJECT_CODEX_DIR -Force | Out-Null }
    $tally.codex_project_status = Write-IfChanged -Path $PROJECT_CODEX_CONFIG -Content $projectCodexConfig -Label ".codex/config.toml"
} else {
    $tally.codex_mcp_status = "pulado"
    $tally.codex_project_status = "pulado"
}

# Antigravity global mcp_config.json - merge cirurgico com escrita atomica
if ($enableAntigravity) {
    if (Test-Path $GEMINI_CONFIG_DIR) {
        try {
            $geminiSettings = [ordered]@{}
            $geminiSettingsRaw = ""
            if (Test-Path $GEMINI_MCP_SETTINGS) {
                $geminiSettingsRaw = Get-Content $GEMINI_MCP_SETTINGS -Raw -Encoding UTF8
            }

            $parseOk = $false
            if ($geminiSettingsRaw -and $geminiSettingsRaw.Trim()) {
                try {
                    $geminiSettings = ConvertFrom-JsonSafe $geminiSettingsRaw
                    $parseOk = $true
                } catch {
                    $badBackup = "$GEMINI_MCP_SETTINGS.invalid_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                    Copy-Item $GEMINI_MCP_SETTINGS $badBackup -Force
                    Write-Warn "mcp_config.json estava invalido. Backup criado: $badBackup"
                }
            }

            $geminiMcpEntry = [ordered]@{
                command = "python"
                args    = @($SERVER_PATH)
                env     = [ordered]@{ KNOWLEDGE_DB = $DB_PATH }
                tools   = [ordered]@{
                    search_knowledge    = [ordered]@{ eager = $true }
                    get_full_document   = [ordered]@{ eager = $true }
                    get_context         = [ordered]@{ eager = $true }
                    health_check        = [ordered]@{ eager = $true }
                    knowledge_stats     = [ordered]@{ eager = $true }
                    search_with_filters = [ordered]@{ eager = $true }
                }
            }

            $existingGemini = if ($parseOk -and $geminiSettings.Contains("mcpServers")) { $geminiSettings["mcpServers"]["knowledge"] } else { $null }
            $alreadyCurrentGemini = $existingGemini -and
                                    ($existingGemini["command"] -eq $geminiMcpEntry.command) -and
                                    ($existingGemini["args"]    -contains $SERVER_PATH) -and
                                    ($existingGemini.Contains("env") -and $existingGemini["env"]["KNOWLEDGE_DB"] -eq $DB_PATH)

            if ($alreadyCurrentGemini) {
                Write-Skip "mcp_config.json ja configurado corretamente"
                $tally.gemini_mcp_status = "unchanged"
            } else {
                if ($parseOk -and (Test-Path $GEMINI_MCP_SETTINGS) -and (Get-Item $GEMINI_MCP_SETTINGS).Length -gt 0) {
                    $tsBackup = "$GEMINI_MCP_SETTINGS.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                    Copy-Item $GEMINI_MCP_SETTINGS $tsBackup -Force
                    Write-Host "  [BAK]  $tsBackup" -ForegroundColor DarkGray
                }

                if (-not $geminiSettings.Contains("mcpServers")) { $geminiSettings["mcpServers"] = [ordered]@{} }
                $geminiSettings["mcpServers"]["knowledge"] = $geminiMcpEntry

                $newJson = $geminiSettings | ConvertTo-Json -Depth 10
                $tmpSettings = "$GEMINI_MCP_SETTINGS.tmp"
                [System.IO.File]::WriteAllText($tmpSettings, ($newJson -replace "`r`n","`n"), $utf8NoBom)
                Move-Item $tmpSettings $GEMINI_MCP_SETTINGS -Force

                Write-OK "mcp_config.json atualizado (MCP Antigravity registrado)"
                $tally.gemini_mcp_status = "updated"
            }
        } catch {
            Write-Warn "Nao foi possivel atualizar mcp_config.json: $_"
            $tally.gemini_mcp_status = "failed"
        }
    }
} else {
    $tally.gemini_mcp_status = "pulado"
}

# VS Code project config - gerado para Copilot Agent Mode com suporte MCP
if ($enableCopilot) {
    $vscodeMcpEntry = [ordered]@{
        mcpServers = [ordered]@{
            knowledge = [ordered]@{
                command = "python"
                args    = @("tools/mcp-knowledge-search/server.py")
                env     = [ordered]@{ KNOWLEDGE_DB = "knowledge.db" }
            }
        }
    }
    $vscodeMcpJsonStr = $vscodeMcpEntry | ConvertTo-Json -Depth 5
    if (-not (Test-Path $VSCODE_DIR)) { New-Item -ItemType Directory -Path $VSCODE_DIR -Force | Out-Null }
    $tally.vscode_mcp_status = Write-IfChanged -Path $VSCODE_MCP_CONFIG -Content $vscodeMcpJsonStr -Label ".vscode/mcp.json"

    # VS Code User config global - registrar MCP knowledge para disponibilidade em qualquer projeto
    if (Test-Path $VSCODE_USER_DIR) {
        try {
            $vscodeUserMcp = [ordered]@{}
            $vscodeUserMcpRaw = ""
            if (Test-Path $VSCODE_GLOBAL_MCP) {
                $vscodeUserMcpRaw = Get-Content $VSCODE_GLOBAL_MCP -Raw -Encoding UTF8
            }

            $parseOk = $false
            if ($vscodeUserMcpRaw -and $vscodeUserMcpRaw.Trim()) {
                try {
                    $vscodeUserMcp = ConvertFrom-JsonSafe $vscodeUserMcpRaw
                    $parseOk = $true
                } catch {
                    $badBackup = "$VSCODE_GLOBAL_MCP.invalid_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                    Copy-Item $VSCODE_GLOBAL_MCP $badBackup -Force
                    Write-Warn "VS Code User mcp.json estava invalido. Backup criado: $badBackup"
                }
            }

            $vscodeGlobalEntry = [ordered]@{
                type    = "stdio"
                command = "python"
                args    = @($SERVER_PATH)
                env     = [ordered]@{ KNOWLEDGE_DB = $DB_PATH }
            }

            $existingVscode = if ($parseOk -and $vscodeUserMcp.Contains("servers")) { $vscodeUserMcp["servers"]["knowledge"] } else { $null }
            $alreadyCurrentVscode = $existingVscode -and
                                    ($existingVscode["command"] -eq $vscodeGlobalEntry.command) -and
                                    ($existingVscode["args"]    -contains $SERVER_PATH) -and
                                    ($existingVscode.Contains("env") -and $existingVscode["env"]["KNOWLEDGE_DB"] -eq $DB_PATH)

            if ($alreadyCurrentVscode) {
                Write-Skip "VS Code User mcp.json ja configurado corretamente"
                $tally.vscode_global_mcp_status = "unchanged"
            } else {
                if ($parseOk -and (Test-Path $VSCODE_GLOBAL_MCP) -and (Get-Item $VSCODE_GLOBAL_MCP).Length -gt 0) {
                    $tsBackup = "$VSCODE_GLOBAL_MCP.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
                    Copy-Item $VSCODE_GLOBAL_MCP $tsBackup -Force
                    Write-Host "  [BAK]  $tsBackup" -ForegroundColor DarkGray
                }

                if (-not $vscodeUserMcp.Contains("servers")) { $vscodeUserMcp["servers"] = [ordered]@{} }
                $vscodeUserMcp["servers"]["knowledge"] = $vscodeGlobalEntry
                if (-not $vscodeUserMcp.Contains("inputs")) { $vscodeUserMcp["inputs"] = @() }

                $newJson = $vscodeUserMcp | ConvertTo-Json -Depth 10
                $tmpSettings = "$VSCODE_GLOBAL_MCP.tmp"
                [System.IO.File]::WriteAllText($tmpSettings, ($newJson -replace "`r`n","`n"), $utf8NoBom)
                Move-Item $tmpSettings $VSCODE_GLOBAL_MCP -Force

                Write-OK "VS Code User mcp.json atualizado (MCP global registrado)"
                $tally.vscode_global_mcp_status = "updated"
            }

            # Configurar settings.json para evitar duplicacao de agentes caso ~/.claude/agents exista
            $vscodeSettingsPath = Join-Path $VSCODE_USER_DIR "settings.json"
            if (Test-Path $vscodeSettingsPath) {
                try {
                    $rawSettings = Get-Content $vscodeSettingsPath -Raw -Encoding UTF8
                    $settingsUpdated = $false
                    if ($rawSettings -notmatch '"chat\.agentHost\.claudeAgent\.enabled"\s*:\s*false') {
                        if ($rawSettings -match '"chat\.agentHost\.claudeAgent\.enabled"\s*:\s*true') {
                            $rawSettings = $rawSettings -replace '"chat\.agentHost\.claudeAgent\.enabled"\s*:\s*true', '"chat.agentHost.claudeAgent.enabled": false'
                        } else {
                            $rawSettings = $rawSettings -replace '\{(\r?\n)?', "{`$1  `"chat.agentHost.claudeAgent.enabled`": false,`$1"
                        }
                        $settingsUpdated = $true
                    }
                    if ($rawSettings -notmatch '"github\.copilot\.chat\.claudeAgent\.enabled"\s*:\s*false') {
                        if ($rawSettings -match '"github\.copilot\.chat\.claudeAgent\.enabled"\s*:\s*true') {
                            $rawSettings = $rawSettings -replace '"github\.copilot\.chat\.claudeAgent\.enabled"\s*:\s*true', '"github.copilot.chat.claudeAgent.enabled": false'
                        } else {
                            $rawSettings = $rawSettings -replace '\{(\r?\n)?', "{`$1  `"github.copilot.chat.claudeAgent.enabled`": false,`$1"
                        }
                        $settingsUpdated = $true
                    }
                    if ($settingsUpdated) {
                        [System.IO.File]::WriteAllText($vscodeSettingsPath, $rawSettings, $utf8NoBom)
                        Write-OK "VS Code settings.json: descoberta de agentes Claude desativada no Copilot (evita duplicacao)"
                    } else {
                        Write-Skip "VS Code settings.json: deduplicacao de Claude ja configurada"
                    }
                } catch {
                    Write-Warn "Nao foi possivel atualizar VS Code settings.json para desativar Claude agents: $_"
                }
            }
        } catch {
            Write-Warn "Nao foi possivel atualizar VS Code User mcp.json: $_"
            $tally.vscode_global_mcp_status = "failed"
        }
    } else {
        $tally.vscode_global_mcp_status = "skipped"
    }
} else {
    $tally.vscode_mcp_status = "pulado"
    $tally.vscode_global_mcp_status = "pulado"
}

# =============================================================================
#  FASE 7 - Scripts auxiliares
# =============================================================================
Write-Header "Scripts auxiliares"

# Limpeza de factory.ps1 legado (Gemini CLI depreciado)
$legacyFactoryPs1 = Join-Path $BIN_DIR "factory.ps1"
if (Test-Path $legacyFactoryPs1) {
    Remove-Item $legacyFactoryPs1 -Force -ErrorAction SilentlyContinue
}

# update-knowledge.ps1
$updateKnowledge = @"
# update-knowledge.ps1 - Reindexar conhecimento da AI Software Factory
# Execute sempre que alterar knowledge/, skills/, schemas/, templates/, examples/, bibliography/

`$ErrorActionPreference = "Stop"
`$FACTORY_PATH = if (`$env:FACTORY_ROOT) { `$env:FACTORY_ROOT } else { (Get-Location).Path }
if (-not (Test-Path (Join-Path `$FACTORY_PATH "install.ps1"))) {
    Write-Error "FACTORY_ROOT nao aponta para a factory. Execute install.ps1 primeiro."; exit 1
}
`$CONFIG_PATH  = Join-Path `$FACTORY_PATH "knowledge-config.json"
`$INGEST_PATH  = Join-Path `$FACTORY_PATH "tools\mcp-knowledge-search\ingest.py"
if (-not (Test-Path `$CONFIG_PATH))  { Write-Error "knowledge-config.json nao encontrado. Execute install.ps1."; exit 1 }
if (-not (Test-Path `$INGEST_PATH))  { Write-Error "ingest.py nao encontrado."; exit 1 }
`$pythonCmd = "python"
foreach (`$cmd in @("python","python3","py")) {
    try { `$v = & `$cmd --version 2>&1; if (`$LASTEXITCODE -eq 0) { `$pythonCmd = `$cmd; break } } catch {}
}
Write-Host "Reindexando conhecimento da AI Software Factory..." -ForegroundColor Cyan
Write-Host "Factory: `$FACTORY_PATH" -ForegroundColor DarkGray
`$DB_PATH   = Join-Path `$FACTORY_PATH "knowledge.db"
`$dbTemp    = "`$DB_PATH.tmp"
`$cfgTemp   = Join-Path `$FACTORY_PATH "knowledge-config.tmp.json"
`$cfg = Get-Content `$CONFIG_PATH | ConvertFrom-Json
`$cfg | Add-Member -Force -NotePropertyName "db_path" -NotePropertyValue `$dbTemp
`$cfg | ConvertTo-Json -Depth 5 | Set-Content `$cfgTemp -Encoding UTF8
& `$pythonCmd `$INGEST_PATH --config `$cfgTemp
if (`$LASTEXITCODE -eq 0 -and (Test-Path `$dbTemp)) {
    if (Test-Path `$DB_PATH) { Remove-Item `$DB_PATH -Force }
    Move-Item `$dbTemp `$DB_PATH -Force
    Remove-Item `$cfgTemp -Force -ErrorAction SilentlyContinue
    Write-Host "[OK] knowledge.db atualizado." -ForegroundColor Green
} else {
    if (Test-Path `$dbTemp)  { Remove-Item `$dbTemp  -Force -ErrorAction SilentlyContinue }
    if (Test-Path `$cfgTemp) { Remove-Item `$cfgTemp -Force -ErrorAction SilentlyContinue }
    Write-Host "[FAIL] Falha ao reindexar." -ForegroundColor Red; exit 1
}
"@
$s = Write-IfChanged -Path (Join-Path $FACTORY_PATH "update-knowledge.ps1") -Content $updateKnowledge -Label "update-knowledge.ps1"
if ($s -ne "unchanged") { $tally.scripts_updated++ } else { $tally.scripts_unchanged++ }

# link-mcp.ps1
$linkMcp = @"
# link-mcp.ps1 - Vincular MCP da factory ao projeto atual
# Uso: & "`$env:FACTORY_ROOT\link-mcp.ps1"

`$ErrorActionPreference = "Stop"
`$FACTORY_PATH = if (`$env:FACTORY_ROOT) { `$env:FACTORY_ROOT } else { Write-Error "FACTORY_ROOT nao definido."; exit 1 }
`$SOURCE_MCP = Join-Path `$FACTORY_PATH ".mcp.json"
`$TARGET_MCP = Join-Path (Get-Location).Path ".mcp.json"
if (-not (Test-Path `$SOURCE_MCP)) { Write-Error ".mcp.json nao encontrado. Execute install.ps1 primeiro."; exit 1 }

function ConvertTo-TomlString([string]`$Value) {
    return '"' + `$Value.Replace("\", "\\").Replace('"', '\"') + '"'
}

function Set-ManagedBlock([string]`$Path, [string]`$Begin, [string]`$End, [string]`$Block) {
    `$nl = [Environment]::NewLine
    `$existing = if (Test-Path `$Path) { Get-Content `$Path -Raw -Encoding UTF8 } else { "" }
    `$start = `$existing.IndexOf(`$Begin)
    `$endIndex = if (`$start -ge 0) { `$existing.IndexOf(`$End, `$start) } else { -1 }
    if (`$start -ge 0 -and `$endIndex -ge `$start) {
        `$endAfter = `$endIndex + `$End.Length
        while (`$endAfter -lt `$existing.Length -and (`$existing[`$endAfter] -eq [char]13 -or `$existing[`$endAfter] -eq [char]10)) { `$endAfter++ }
        return (`$existing.Substring(0, `$start).TrimEnd() + `$nl + `$nl + `$Block.Trim() + `$nl + `$existing.Substring(`$endAfter).TrimStart())
    }
    if (`$existing.Trim()) { return `$existing.TrimEnd() + `$nl + `$nl + `$Block.Trim() + `$nl }
    return `$Block.Trim() + `$nl
}

if (Test-Path `$TARGET_MCP) {
    `$bak = "`$TARGET_MCP.bak_`$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item `$TARGET_MCP `$bak; Write-Host "  [BAK] `$bak" -ForegroundColor DarkGray
}
Copy-Item `$SOURCE_MCP `$TARGET_MCP -Force
Write-Host "[OK] .mcp.json vinculado: `$(Get-Location)" -ForegroundColor Green

`$TARGET_CODEX_DIR = Join-Path (Get-Location).Path ".codex"
`$TARGET_CODEX_CONFIG = Join-Path `$TARGET_CODEX_DIR "config.toml"
if (-not (Test-Path `$TARGET_CODEX_DIR)) { New-Item -ItemType Directory -Path `$TARGET_CODEX_DIR -Force | Out-Null }

`$begin = "# BEGIN ai_software_factory:codex-mcp"
`$end = "# END ai_software_factory:codex-mcp"
`$serverPath = Join-Path `$FACTORY_PATH "tools\mcp-knowledge-search\server.py"
`$dbPath = Join-Path `$FACTORY_PATH "knowledge.db"
`$codexRaw = if (Test-Path `$TARGET_CODEX_CONFIG) { Get-Content `$TARGET_CODEX_CONFIG -Raw -Encoding UTF8 } else { "" }
`$hasUnmanagedKnowledge = (`$codexRaw -match "(?m)^\s*\[mcp_servers\.knowledge\]\s*$") -and (`$codexRaw -notlike "*`$begin*")

if (`$hasUnmanagedKnowledge) {
    Write-Host "[WARN] .codex/config.toml ja possui [mcp_servers.knowledge] fora do bloco gerenciado; preservado." -ForegroundColor Yellow
} else {
    `$codexBlock = @(
        `$begin,
        "[mcp_servers.knowledge]",
        'command = "python"',
        "args = [`$(ConvertTo-TomlString `$serverPath)]",
        "startup_timeout_sec = 20",
        "tool_timeout_sec = 60",
        "",
        "[mcp_servers.knowledge.env]",
        "KNOWLEDGE_DB = `$(ConvertTo-TomlString `$dbPath)",
        `$end
    ) -join [Environment]::NewLine
    if (Test-Path `$TARGET_CODEX_CONFIG) {
        `$bak = "`$TARGET_CODEX_CONFIG.bak_`$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item `$TARGET_CODEX_CONFIG `$bak; Write-Host "  [BAK] `$bak" -ForegroundColor DarkGray
    }
    `$newCodexConfig = Set-ManagedBlock `$TARGET_CODEX_CONFIG `$begin `$end `$codexBlock
    Set-Content -Path `$TARGET_CODEX_CONFIG -Value `$newCodexConfig -Encoding UTF8
    Write-Host "[OK] .codex/config.toml vinculado: `$(Get-Location)" -ForegroundColor Green
}

`$TARGET_VSCODE_DIR = Join-Path (Get-Location).Path ".vscode"
`$TARGET_VSCODE_CONFIG = Join-Path `$TARGET_VSCODE_DIR "mcp.json"
`$SOURCE_VSCODE_CONFIG = Join-Path `$FACTORY_PATH ".vscode\mcp.json"
if (Test-Path `$SOURCE_VSCODE_CONFIG) {
    if (-not (Test-Path `$TARGET_VSCODE_DIR)) { New-Item -ItemType Directory -Path `$TARGET_VSCODE_DIR -Force | Out-Null }
    if (Test-Path `$TARGET_VSCODE_CONFIG) {
        `$bak = "`$TARGET_VSCODE_CONFIG.bak_`$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item `$TARGET_VSCODE_CONFIG `$bak; Write-Host "  [BAK] `$bak" -ForegroundColor DarkGray
    }
    Copy-Item `$SOURCE_VSCODE_CONFIG `$TARGET_VSCODE_CONFIG -Force
    Write-Host "[OK] .vscode/mcp.json vinculado: `$(Get-Location)" -ForegroundColor Green
}

Write-Host "     MCP knowledge search disponivel na proxima sessao Claude Code, Codex ou GitHub Copilot."
"@
$s = Write-IfChanged -Path (Join-Path $FACTORY_PATH "link-mcp.ps1") -Content $linkMcp -Label "link-mcp.ps1"
if ($s -ne "unchanged") { $tally.scripts_updated++ } else { $tally.scripts_unchanged++ }

# =============================================================================
#  FASE FINAL - MCP Health Check
# =============================================================================
Write-Header "MCP Health Check"

$testMcpPath    = Join-Path $FACTORY_PATH "test-mcp.ps1"
$testHealthPath = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\test_health.py"

if (Test-Path $testMcpPath) {
    try {
        & $testMcpPath
        if ($LASTEXITCODE -eq 0) {
            Write-OK "MCP health check passou"
        } else {
            Write-Warn "MCP health check reportou problemas (veja output acima)"
            Write-Warn "  Para diagnostico: .\test-mcp.ps1"
            Write-Warn "  Para corrigir:    .\install.ps1 -ForceDeps"
        }
    } catch {
        Write-Warn "Nao foi possivel executar test-mcp.ps1: $_"
    }
} elseif ($hasPython -and (Test-Path $testHealthPath)) {
    # Fallback: rodar test_health.py diretamente
    try {
        & $pythonCmd $testHealthPath --db $DB_PATH
        if ($LASTEXITCODE -eq 0) {
            Write-OK "MCP health check passou (via test_health.py)"
        } else {
            Write-Warn "MCP health check falhou (via test_health.py)"
            Write-Warn "  Execute: .\update-knowledge.ps1"
        }
    } catch {
        Write-Warn "Nao foi possivel executar test_health.py: $_"
    }
} else {
    Write-Skip "Health check pulado (test-mcp.ps1 nao disponivel nesta fase)"
}

# --- Gravar manifesto completo (apos todas as fases) -------------------------
if ($enableClaude -and $manifest -and $manifestPath) {
    $manifestJson = $manifest | ConvertTo-Json -Depth 10
    Write-IfChanged -Path $manifestPath -Content $manifestJson -Label ".ai_software_factory_manifest.json" | Out-Null
}

# =============================================================================
#  RESUMO
# =============================================================================
Write-Host ""
Write-Host "  +===================================================+" -ForegroundColor Green
Write-Host "  |                    Resumo                        |" -ForegroundColor Green
Write-Host "  +===================================================+" -ForegroundColor Green

$agentSummary = if ($enableClaude) {
    "{0} criados  {1} atualizados  {2} sem mudancas" -f `
        $tally.agents_created, $tally.agents_updated, $tally.agents_unchanged
} else { "pulado (nao selecionado)" }
Write-Host ("  |  Agentes      {0,-36}|" -f $agentSummary) -ForegroundColor Green

$codexSummary = if ($enableCodex) {
    "{0} criados  {1} atualizados  {2} sem mudancas" -f `
        $tally.codex_created, $tally.codex_updated, $tally.codex_unchanged
} else { "pulado (nao selecionado)" }
Write-Host ("  |  Codex agents {0,-36}|" -f $codexSummary) -ForegroundColor Green

$antigravitySummary = if ($enableAntigravity) {
    "{0} criadas  {1} atualizadas  {2} sem mudancas" -f `
        $tally.antigravity_created, $tally.antigravity_updated, $tally.antigravity_unchanged
} else { "pulado (nao selecionado)" }
Write-Host ("  |  Antigravity  {0,-36}|" -f $antigravitySummary) -ForegroundColor Green

$copilotSummary = if ($enableCopilot) {
    "{0} criados  {1} atualizados  {2} sem mudancas" -f `
        $tally.copilot_created, $tally.copilot_updated, $tally.copilot_unchanged
} else { "pulado (nao selecionado)" }
Write-Host ("  |  Copilot Prmp {0,-36}|" -f $copilotSummary) -ForegroundColor Green

$copilotWsSummary = if ($enableCopilot) {
    "{0} criados  {1} atualizados  {2} sem mudancas" -f `
        $tally.copilot_ws_created, $tally.copilot_ws_updated, $tally.copilot_ws_unchanged
} else { "pulado (nao selecionado)" }
Write-Host ("  |  Copilot WSAgt{0,-36}|" -f $copilotWsSummary) -ForegroundColor Green

$copilotUserSummary = if ($enableCopilot) {
    "{0} criados  {1} atualizados  {2} sem mudancas" -f `
        $tally.copilot_user_created, $tally.copilot_user_updated, $tally.copilot_user_unchanged
} else { "pulado (nao selecionado)" }
Write-Host ("  |  Copilot UsrAg{0,-36}|" -f $copilotUserSummary) -ForegroundColor Green

$copilotInstrSummary = if ($enableCopilot) { $tally.copilot_instr_status } else { "pulado" }
Write-Host ("  |  Copilot Inst {0,-36}|" -f $copilotInstrSummary) -ForegroundColor Green

$kbSummary = switch ($tally.knowledge_status) {
    "rebuilt"   { "reconstruido - $($tally.knowledge_docs) documentos" }
    "unchanged" { "sem mudancas - $($tally.knowledge_docs) documentos" }
    "failed"    { "FALHA - DB anterior mantido" }
    default     { "nao configurado (Python ausente)" }
}
Write-Host ("  |  Knowledge DB {0,-36}|" -f $kbSummary) -ForegroundColor Green
Write-Host ("  |  MCP Config   {0,-36}|" -f $tally.mcp_status) -ForegroundColor Green
Write-Host ("  |  Claude MCP   {0,-36}|" -f $tally.claude_mcp_status) -ForegroundColor Green
Write-Host ("  |  Codex MCP    {0,-36}|" -f $tally.codex_mcp_status) -ForegroundColor Green
Write-Host ("  |  Codex local  {0,-36}|" -f $tally.codex_project_status) -ForegroundColor Green
Write-Host ("  |  Gemini MCP   {0,-36}|" -f $tally.gemini_mcp_status) -ForegroundColor Green
Write-Host ("  |  VS Code MCP  {0,-36}|" -f $tally.vscode_mcp_status) -ForegroundColor Green
Write-Host ("  |  VS Code Usr  {0,-36}|" -f $tally.vscode_global_mcp_status) -ForegroundColor Green
Write-Host ("  |  Dependencias {0,-36}|" -f $tally.deps_status) -ForegroundColor Green
Write-Host ("  |  Scripts      {0,-36}|" -f ("{0} atualizados  {1} sem mudancas" -f $tally.scripts_updated, $tally.scripts_unchanged)) -ForegroundColor Green
Write-Host "  +===================================================+" -ForegroundColor Green

Write-Host ""
Write-Host "  FACTORY_ROOT = $FACTORY_PATH" -ForegroundColor DarkGray
Write-Host ""
if ($enableClaude) {
    Write-Host "  Claude Code - use em qualquer projeto:" -ForegroundColor Cyan
    Write-Host "    @techlead  @qa  @architect  @po  @devbackend ..."
    Write-Host ""
}
if ($enableCodex) {
    Write-Host "  Codex - custom agents instalados:" -ForegroundColor Cyan
    Write-Host "    spawn/use techlead, qa, architect, po, devbackend ... como subagentes"
    Write-Host "    MCP: ~/.codex/config.toml e .codex/config.toml nesta factory"
    Write-Host ""
}
if ($enableAntigravity) {
    Write-Host "  Antigravity (AGY) - plugin e skills instalados:" -ForegroundColor Cyan
    Write-Host "    Skills: techlead, qa, architect, po, devbackend ... sob demanda"
    Write-Host "    MCP: ~/.gemini/config/mcp_config.json e ~/.gemini/config/plugins/ai-software-factory"
    Write-Host ""
}
if ($enableCopilot) {
    Write-Host "  GitHub Copilot - agentes de usuario e prompt files configurados:" -ForegroundColor Cyan
    Write-Host "    User agents: ~/.copilot/agents/*.agent.md (disponivel em qualquer projeto)"
    Write-Host "    Agentes no Copilot Chat: @techlead  @qa  @architect  @po  @devbackend ..."
    Write-Host "    Prompt files: .github/prompts/*.prompt.md"
    Write-Host "    Instrucoes globais: .github/copilot-instructions.md"
    Write-Host "    MCP: .vscode/mcp.json e User mcp.json (VS Code Copilot Agent mode)"
    Write-Host ""
}
if ($hasPython) {
    Write-Host "  Atualizar apos git pull / editar conhecimento:" -ForegroundColor Cyan
    Write-Host "    .\update-knowledge.ps1"
    Write-Host ""
    Write-Host "  Vincular MCP a outro projeto:" -ForegroundColor Cyan
    Write-Host "    & `"`$env:FACTORY_ROOT\link-mcp.ps1`""
    Write-Host ""
}
Write-Host "  Diagnostico completo:" -ForegroundColor Cyan
Write-Host "    .\doctor.ps1"
Write-Host ""
if ($frWasUnset) {
    Write-Host "  NOTA: FACTORY_ROOT foi definido pela primeira vez." -ForegroundColor Yellow
    Write-Host "        Abra um novo terminal para que a variavel esteja disponivel." -ForegroundColor Yellow
    Write-Host ""
}
