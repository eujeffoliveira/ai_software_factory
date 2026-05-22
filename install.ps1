# install.ps1 — AI Software Factory Global Installer
# Uso: .\install.ps1 [-ForceDeps]
# Documentacao: docs/INSTALL_CLI.md

param(
    [switch]$ForceDeps  # Forca reinstalacao das dependencias Python
)

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

# ─── Utilitários de output ────────────────────────────────────────────────────
function Write-Header($t) {
    Write-Host ""
    Write-Host "  $t" -ForegroundColor Cyan
    Write-Host ("  " + "─" * $t.Length) -ForegroundColor DarkGray
}
function Write-OK($m)   { Write-Host "  [OK]   $m" -ForegroundColor Green }
function Write-Skip($m) { Write-Host "  [SKIP] $m" -ForegroundColor DarkGray }
function Write-Warn($m) { Write-Host "  [WARN] $m" -ForegroundColor Yellow }
function Write-Fail($m) { Write-Host "  [FAIL] $m" -ForegroundColor Red }

# ─── Escrita idempotente ──────────────────────────────────────────────────────
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

# ─── Caminhos base ────────────────────────────────────────────────────────────
$FACTORY_PATH      = (Get-Location).Path
$CLAUDE_AGENTS_DIR = "$env:USERPROFILE\.claude\agents"
$CLAUDE_SETTINGS   = "$env:USERPROFILE\.claude.json"
$ROO_MCP_PATHS     = @(
    "$env:APPDATA\Code\User\globalStorage\rooveterinaryinc.roo-cline\settings\mcp_settings.json",
    "$env:APPDATA\Code\User\globalStorage\RooVeterinaryInc.roo-cline\settings\mcp_settings.json"
)
$BIN_DIR           = "$env:USERPROFILE\.local\bin"
$DB_PATH           = Join-Path $FACTORY_PATH "knowledge.db"
$CONFIG_PATH       = Join-Path $FACTORY_PATH "knowledge-config.json"
$SERVER_PATH       = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\server.py"
$INGEST_PATH       = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\ingest.py"
$REQUIREMENTS_PATH = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\requirements.txt"
$REQ_HASH_FILE     = Join-Path $FACTORY_PATH "tools\mcp-knowledge-search\.requirements.hash"

# ─── Mapeamento de agentes ────────────────────────────────────────────────────
$agents = @(
    @{ Folder = "Agente00_TechLead";                Name = "techlead";     Description = "Tech Lead e orquestrador do SDLC — quality gates, ADRs, decisoes tecnicas e oversight do projeto" },
    @{ Folder = "Agente01_ProductOwner";            Name = "po";           Description = "Product Owner — user stories, criterios de aceitacao, backlog e definicao de escopo" },
    @{ Folder = "Agente02_SoftwareArchitect";       Name = "architect";    Description = "Arquiteto de Software — design de sistemas, diagramas UML, decisoes de arquitetura e ADRs" },
    @{ Folder = "Agente03_SoftwareEngineer";        Name = "engineer";     Description = "Engenheiro de Software — decomposicao de tarefas, planejamento de implementacao e estimativas" },
    @{ Folder = "Agente04_DevBackend";              Name = "devbackend";   Description = "Dev Backend — APIs REST, servicos, banco de dados, migrations Prisma e autenticacao" },
    @{ Folder = "Agente05_DevFrontend";             Name = "devfrontend";  Description = "Dev Frontend — componentes React, paginas Next.js, UI com Tailwind e logica de interface" },
    @{ Folder = "Agente06_QaEngineer";              Name = "qa";           Description = "QA Engineer — planos de teste, testes unitarios Vitest, E2E Playwright e cobertura de codigo" },
    @{ Folder = "Agente07_DevSecOps";               Name = "devsecops";    Description = "DevSecOps — auditorias de seguranca, SAST, OWASP Top 10, hardening e secrets management" },
    @{ Folder = "Agente08_DevOps";                  Name = "devops";       Description = "DevOps — CI/CD, infraestrutura Vercel, monitoramento, deployment e runbooks operacionais" },
    @{ Folder = "Agente09_UxUiDesigner";            Name = "uxui";         Description = "UX/UI Designer — pesquisa de usuario, wireframes, design system e acessibilidade" },
    @{ Folder = "Agente10_DataIntegrationEngineer"; Name = "dataengineer"; Description = "Data Engineer — pipelines de dados, ETL, integracoes de sistemas e governanca de dados" }
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

# ─── Contadores do resumo ─────────────────────────────────────────────────────
$tally = @{
    agents_created   = 0
    agents_updated   = 0
    agents_unchanged = 0
    knowledge_docs   = 0
    knowledge_status = "skipped"
    mcp_status       = "unchanged"
    roo_status       = "unchanged"
    deps_status      = "skipped"
    scripts_updated  = 0
    scripts_unchanged = 0
}

# ═════════════════════════════════════════════════════════════════════════════
#  BANNER
# ═════════════════════════════════════════════════════════════════════════════
Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════════╗" -ForegroundColor Blue
Write-Host "  ║      AI Software Factory — Global Installer      ║" -ForegroundColor Blue
Write-Host "  ╚═══════════════════════════════════════════════════╝" -ForegroundColor Blue
Write-Host ""
Write-Host "  Factory: $FACTORY_PATH" -ForegroundColor Gray
Write-Host ""

# ═════════════════════════════════════════════════════════════════════════════
#  FASE 1 — FACTORY_ROOT
# ═════════════════════════════════════════════════════════════════════════════
Write-Header "FACTORY_ROOT"
[System.Environment]::SetEnvironmentVariable("FACTORY_ROOT", $FACTORY_PATH, [System.EnvironmentVariableTarget]::User)
$env:FACTORY_ROOT = $FACTORY_PATH
Write-OK "FACTORY_ROOT = $FACTORY_PATH"
Write-OK "Variavel de ambiente de usuario configurada"

# ═════════════════════════════════════════════════════════════════════════════
#  FASE 2 — Python
# ═════════════════════════════════════════════════════════════════════════════
Write-Header "Python"
$pythonCmd = $null
$hasPython = $false
foreach ($cmd in @("python", "python3", "py")) {
    try {
        $ver = & $cmd --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            $pythonCmd = $cmd
            $hasPython = $true
            Write-OK "$cmd — $ver"
            break
        }
    } catch {}
}
if (-not $hasPython) {
    Write-Warn "Python nao encontrado no PATH."
    Write-Warn "  MCP/RAG nao sera configurado nesta instalacao."
    Write-Warn "  Instale Python 3.x e re-execute install.ps1 para ativar o RAG."
}

# ═════════════════════════════════════════════════════════════════════════════
#  FASE 3 — Dependencias pip (hash-driven)
# ═════════════════════════════════════════════════════════════════════════════
if ($hasPython) {
    Write-Header "Dependencias MCP"

    if (Test-Path $REQUIREMENTS_PATH) {
        $reqHash    = (Get-FileHash $REQUIREMENTS_PATH -Algorithm SHA256).Hash
        $savedHash  = if (Test-Path $REQ_HASH_FILE) { (Get-Content $REQ_HASH_FILE -Raw).Trim() } else { "" }

        # Verificar se mcp esta instalado
        $mcpPresent = & $pythonCmd -m pip show mcp 2>&1
        $mcpMissing = ($LASTEXITCODE -ne 0)

        $needsPip = $ForceDeps -or $mcpMissing -or ($reqHash -ne $savedHash)

        if ($needsPip) {
            $reason = if ($ForceDeps) { "-ForceDeps" } elseif ($mcpMissing) { "mcp ausente" } else { "requirements.txt modificado" }
            Write-Host "  Instalando dependencias ($reason)..." -ForegroundColor DarkGray
            & $pythonCmd -m pip install -r $REQUIREMENTS_PATH -q
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

# ═════════════════════════════════════════════════════════════════════════════
#  FASE 4 — Claude Code: ~/.claude/agents/
# ═════════════════════════════════════════════════════════════════════════════
Write-Header "Claude Code — Agentes"

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

**Consulte o MCP antes de afirmar que um skill, schema, template ou checklist nao existe.**

### Ferramentas disponiveis

| Ferramenta | Quando usar |
|-----------|-------------|
| ``search_knowledge("termo")`` | Buscar em skills, schemas, templates, checklists, playbooks |
| ``get_full_document("doc_id")`` | Obter documento completo por ID retornado pelo search |
| ``get_context("doc_id")`` | Obter secoes adjacentes do mesmo arquivo |
| ``knowledge_stats()`` | Ver estatisticas do banco e categorias indexadas |

### O que esta indexado

- ``Agente*/knowledge/`` — principles, heuristics, decision_rules, knowledge_cards
- ``Agente*/skills/`` — documentacao e checklists de cada skill
- ``Agente*/schemas/`` — contratos JSON de input/output
- ``Agente*/templates/`` — templates de artefatos
- ``Agente*/examples/`` — exemplos bom/ruim de outputs
- ``Agente*/checklists/`` — checklists operacionais
- ``bibliography/playbooks/`` — playbooks de engenharia

### FACTORY_ROOT

$FACTORY_PATH

Para acessar arquivos diretamente: leia a partir de FACTORY_ROOT.
<!-- END ai_software_factory:mcp-knowledge -->
"@

$factoryAgentNames = $agents | ForEach-Object { "$($_.Name).md" }

foreach ($agent in $agents) {
    $agentDir   = Join-Path $FACTORY_PATH $agent.Folder
    $promptFile = Join-Path $agentDir "prompt.md"
    $outputFile = Join-Path $CLAUDE_AGENTS_DIR "$($agent.Name).md"

    if (-not (Test-Path $promptFile)) {
        Write-Warn "prompt.md nao encontrado: $($agent.Folder)"
        continue
    }

    $sb = [System.Text.StringBuilder]::new()
    [void]$sb.AppendLine("---")
    [void]$sb.AppendLine("name: $($agent.Name)")
    [void]$sb.AppendLine("description: $($agent.Description)")
    [void]$sb.AppendLine("---")
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
}

Write-Host "  ─────────────────────────────────" -ForegroundColor DarkGray
Write-Host ("  Agentes: {0} criados, {1} atualizados, {2} sem mudancas" -f `
    $tally.agents_created, $tally.agents_updated, $tally.agents_unchanged) -ForegroundColor Gray

# ═════════════════════════════════════════════════════════════════════════════
#  FASE 5 — knowledge-config.json + ingest (backup/restore on failure)
# ═════════════════════════════════════════════════════════════════════════════
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
            Where-Object { $_.FullName -notlike "*\roo\*" } |
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
        $tempConfig | ConvertTo-Json -Depth 5 | Set-Content $configTemp -Encoding UTF8

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
            # Falha — restaurar backup se existir
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
    Write-Skip "Python nao disponivel — pulando indexacao"
    $tally.knowledge_status = "skipped"
}

# ═════════════════════════════════════════════════════════════════════════════
#  FASE 6 — .mcp.json + .claude.json (merge cirurgico, atomico)
# ═════════════════════════════════════════════════════════════════════════════
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

# .claude.json global — merge cirurgico com escrita atomica
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
            $settings = $settingsRaw | ConvertFrom-Json -AsHashtable
            $parseOk = $true
        } catch {
            # JSON invalido — criar backup antes de qualquer alteracao
            $badBackup = "$CLAUDE_SETTINGS.invalid_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Copy-Item $CLAUDE_SETTINGS $badBackup -Force
            Write-Warn ".claude.json estava invalido. Backup criado: $badBackup"
            Write-Warn "Recriando .claude.json com apenas a entrada MCP."
        }
    }

    # Verificar se ja esta correto (evita escrita desnecessaria)
    $existing = if ($parseOk) { $settings["mcpServers"]?["knowledge"] } else { $null }
    $alreadyCurrent = $existing -and
                      ($existing["type"]    -eq $mcpEntry.type) -and
                      ($existing["command"] -eq $mcpEntry.command) -and
                      ($existing["args"]    -contains $SERVER_PATH) -and
                      ($existing["env"]?["KNOWLEDGE_DB"] -eq $DB_PATH)

    if ($alreadyCurrent) {
        Write-Skip ".claude.json ja configurado corretamente"
    } else {
        # Backup com timestamp apenas quando ha mudanca real
        if ($parseOk -and (Test-Path $CLAUDE_SETTINGS)) {
            $tsBackup = "$CLAUDE_SETTINGS.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
            Copy-Item $CLAUDE_SETTINGS $tsBackup -Force
            Write-Host "  [BAK]  $tsBackup" -ForegroundColor DarkGray
        }

        # Atualizar apenas a chave da factory
        if (-not $settings.ContainsKey("mcpServers")) { $settings["mcpServers"] = @{} }
        $settings["mcpServers"]["knowledge"] = $mcpEntry

        # Validar JSON resultante antes de escrever (depth 20 para preservar toda a estrutura)
        $newJson = $settings | ConvertTo-Json -Depth 20
        $newJson | ConvertFrom-Json | Out-Null  # lanca excecao se invalido

        # Escrita atomica: temp → rename
        $tmpSettings = "$CLAUDE_SETTINGS.tmp"
        [System.IO.File]::WriteAllText($tmpSettings, ($newJson -replace "`r`n","`n"), $utf8NoBom)
        Move-Item $tmpSettings $CLAUDE_SETTINGS -Force

        Write-OK ".claude.json atualizado (MCP global registrado)"
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
}

# Roo Code mcp_settings.json — mesmo merge cirurgico para cada instalacao encontrada
foreach ($rooMcp in $ROO_MCP_PATHS) {
    if (-not (Test-Path (Split-Path $rooMcp))) { continue }
    try {
        $rooSettings = [ordered]@{ mcpServers = [ordered]@{} }
        if (Test-Path $rooMcp) {
            $rooRaw = Get-Content $rooMcp -Raw -Encoding UTF8
            if ($rooRaw -and $rooRaw.Trim()) {
                $rooSettings = $rooRaw | ConvertFrom-Json -AsHashtable
            }
        }

        $existingRoo = $rooSettings["mcpServers"]?["knowledge"]
        $rooAlreadyCurrent = $existingRoo -and
                             ($existingRoo["command"] -eq $mcpEntry.command) -and
                             ($existingRoo["args"]    -contains $SERVER_PATH) -and
                             ($existingRoo["env"]?["KNOWLEDGE_DB"] -eq $DB_PATH)

        if ($rooAlreadyCurrent) {
            Write-Skip "Roo mcp_settings.json ja configurado: $rooMcp"
        } else {
            if (-not $rooSettings.ContainsKey("mcpServers")) { $rooSettings["mcpServers"] = @{} }
            $rooSettings["mcpServers"]["knowledge"] = $mcpEntry

            $rooJson = $rooSettings | ConvertTo-Json -Depth 10
            $rooJson | ConvertFrom-Json | Out-Null

            $tmpRoo = "$rooMcp.tmp"
            [System.IO.File]::WriteAllText($tmpRoo, ($rooJson -replace "`r`n","`n"), $utf8NoBom)
            Move-Item $tmpRoo $rooMcp -Force

            Write-OK "Roo mcp_settings.json atualizado: $rooMcp"
        }
    } catch {
        Write-Warn "Nao foi possivel atualizar Roo mcp_settings.json ($rooMcp): $_"
    }
}

# ═════════════════════════════════════════════════════════════════════════════
#  FASE 7 — Roo Code: roo/.roomodes + roo/.clinerules
# ═════════════════════════════════════════════════════════════════════════════
Write-Header "Roo Code / Cline"

$rooDir = Join-Path $FACTORY_PATH "roo"
if (-not (Test-Path $rooDir)) { New-Item -ItemType Directory -Path $rooDir -Force | Out-Null }

$customModes = [System.Collections.Generic.List[object]]::new()
foreach ($agent in $agents) {
    $agentDir   = Join-Path $FACTORY_PATH $agent.Folder
    $promptFile = Join-Path $agentDir "prompt.md"
    if (-not (Test-Path $promptFile)) { continue }

    $promptContent = (Get-Content $promptFile -Raw -Encoding UTF8).TrimEnd()
    $agentLabel    = ($agent.Description -split " — ")[0].Trim()

    $customInstructions = @"
FACTORY_ROOT: $FACTORY_PATH

Voce opera sobre o projeto aberto no VS Code. Use as ferramentas do editor
(leitura de arquivos, terminal integrado, git) para trabalhar no projeto atual.

Para consultar o conhecimento completo da factory (skills, schemas, templates,
checklists e playbooks), use o MCP knowledge search se disponivel.
Se o MCP nao estiver disponivel, leia diretamente os arquivos em FACTORY_ROOT.
"@

    $customModes.Add([ordered]@{
        slug               = $agent.Name
        name               = $agentLabel
        roleDefinition     = $promptContent
        customInstructions = $customInstructions.Trim()
        groups             = @("read", "edit", "browser", "command", "mcp")
    })
}

$roomodesStr  = (@{ customModes = $customModes.ToArray() } | ConvertTo-Json -Depth 10)
$roomodesStatus = Write-IfChanged -Path (Join-Path $rooDir ".roomodes") -Content $roomodesStr -Label "roo/.roomodes ($($customModes.Count) modos)"

$agentListLines = ($agents | ForEach-Object { "- $($_.Name): $($_.Description)" }) -join "`n"
$clinerules = @"
# BEGIN ai_software_factory managed block
# AI Software Factory — Cline/Roo Code Configuration
# Gerado por install.ps1 — re-execute para atualizar
# FACTORY_ROOT: $FACTORY_PATH

## Agentes disponíveis como custom modes

$agentListLines

## Acesso ao conhecimento

O banco de conhecimento completo esta disponivel via MCP knowledge search.
Para vincular o MCP a este projeto: & "`$env:FACTORY_ROOT\link-mcp.ps1"

# END ai_software_factory managed block
"@
$clinerulesStatus = Write-IfChanged -Path (Join-Path $rooDir ".clinerules") -Content $clinerules -Label "roo/.clinerules"

if ($roomodesStatus -ne "unchanged" -or $clinerulesStatus -ne "unchanged") {
    $tally.roo_status = "updated"
} else {
    $tally.roo_status = "unchanged"
}

# ═════════════════════════════════════════════════════════════════════════════
#  FASE 8 — factory.ps1 (Gemini CLI)
# ═════════════════════════════════════════════════════════════════════════════
Write-Header "Scripts auxiliares"

if (-not (Test-Path $BIN_DIR)) { New-Item -ItemType Directory -Path $BIN_DIR | Out-Null }

$agentHelpLines = ($agents | ForEach-Object {
    "    Write-Host `"  $($_.Name.PadRight(14)) — $($_.Folder)`""
}) -join "`n"

$factoryScript = @"
# factory.ps1 — AI Agent CLI para Gemini/Claude
# Gerado por install.ps1 — re-execute para atualizar
# Uso: factory <agent-folder> [engine] [query]

param(
    [string]`$AgentFolder,
    [string]`$Engine = "gemini",
    [Parameter(ValueFromRemainingArguments=`$true)]
    [string[]]`$QueryParts
)

`$FACTORY_PATH = if (`$env:FACTORY_ROOT) { `$env:FACTORY_ROOT } else { "$FACTORY_PATH" }

if (-not `$AgentFolder) {
    Write-Host "Uso: factory <agent-folder> [engine] [query]"
    Write-Host "  engine: gemini (padrao) | claude"
    Write-Host "Agentes:"
$agentHelpLines
    exit 1
}

`$AgentDir   = Join-Path `$FACTORY_PATH `$AgentFolder
`$PromptFile = Join-Path `$AgentDir "prompt.md"
if (-not (Test-Path `$AgentDir))   { Write-Error "Pasta nao encontrada: `$AgentDir"; exit 1 }
if (-not (Test-Path `$PromptFile)) { Write-Error "prompt.md nao encontrado em `$AgentDir"; exit 1 }

`$System   = Get-Content `$PromptFile -Raw
`$QueryStr = `$QueryParts -join " "

switch (`$Engine) {
    "gemini" {
        if (`$QueryStr) { & gemini --system-prompt `$System -p `$QueryStr }
        else            { & gemini --system-prompt `$System }
    }
    "claude" {
        if (`$QueryStr) { & claude --system-prompt `$System -p `$QueryStr --add-dir `$AgentDir }
        else            { & claude --system-prompt `$System --add-dir `$AgentDir }
    }
    default { Write-Error "Engine desconhecida: '`$Engine'. Use 'gemini' ou 'claude'."; exit 1 }
}
"@

$s = Write-IfChanged -Path (Join-Path $BIN_DIR "factory.ps1") -Content $factoryScript -Label "factory.ps1"
if ($s -ne "unchanged") { $tally.scripts_updated++ } else { $tally.scripts_unchanged++ }

# update-knowledge.ps1
$updateKnowledge = @"
# update-knowledge.ps1 — Reindexar conhecimento da AI Software Factory
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
# link-mcp.ps1 — Vincular MCP da factory ao projeto atual
# Uso: & "`$env:FACTORY_ROOT\link-mcp.ps1"

`$ErrorActionPreference = "Stop"
`$FACTORY_PATH = if (`$env:FACTORY_ROOT) { `$env:FACTORY_ROOT } else { Write-Error "FACTORY_ROOT nao definido."; exit 1 }
`$SOURCE_MCP = Join-Path `$FACTORY_PATH ".mcp.json"
`$TARGET_MCP = Join-Path (Get-Location).Path ".mcp.json"
if (-not (Test-Path `$SOURCE_MCP)) { Write-Error ".mcp.json nao encontrado. Execute install.ps1 primeiro."; exit 1 }
if (Test-Path `$TARGET_MCP) {
    `$bak = "`$TARGET_MCP.bak_`$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item `$TARGET_MCP `$bak; Write-Host "  [BAK] `$bak" -ForegroundColor DarkGray
}
Copy-Item `$SOURCE_MCP `$TARGET_MCP -Force
Write-Host "[OK] .mcp.json vinculado: `$(Get-Location)" -ForegroundColor Green
Write-Host "     MCP knowledge search disponivel na proxima sessao Claude Code."
"@
$s = Write-IfChanged -Path (Join-Path $FACTORY_PATH "link-mcp.ps1") -Content $linkMcp -Label "link-mcp.ps1"
if ($s -ne "unchanged") { $tally.scripts_updated++ } else { $tally.scripts_unchanged++ }

# link-roo.ps1
$linkRoo = @"
# link-roo.ps1 — Vincular agentes Roo Code/Cline ao projeto atual
# Uso: & "`$env:FACTORY_ROOT\link-roo.ps1"

`$ErrorActionPreference = "Stop"
`$FACTORY_PATH = if (`$env:FACTORY_ROOT) { `$env:FACTORY_ROOT } else { Write-Error "FACTORY_ROOT nao definido."; exit 1 }
`$projectRoot = (Get-Location).Path
`$copied = 0
foreach (`$src in @((Join-Path `$FACTORY_PATH "roo\.roomodes"), (Join-Path `$FACTORY_PATH "roo\.clinerules"))) {
    if (-not (Test-Path `$src)) { continue }
    `$tgt = Join-Path `$projectRoot (Split-Path `$src -Leaf)
    if (Test-Path `$tgt) {
        `$bak = "`$tgt.bak_`$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item `$tgt `$bak; Write-Host "  [BAK] `$bak" -ForegroundColor DarkGray
    }
    Copy-Item `$src `$tgt -Force
    Write-Host "[OK] `$(Split-Path `$src -Leaf) -> `$projectRoot" -ForegroundColor Green
    `$copied++
}
if (`$copied -eq 0) { Write-Error "Nenhum arquivo encontrado em roo/. Execute install.ps1 primeiro."; exit 1 }
Write-Host "Agentes: techlead po architect engineer devbackend devfrontend qa devsecops devops uxui dataengineer"
"@
$s = Write-IfChanged -Path (Join-Path $FACTORY_PATH "link-roo.ps1") -Content $linkRoo -Label "link-roo.ps1"
if ($s -ne "unchanged") { $tally.scripts_updated++ } else { $tally.scripts_unchanged++ }

# ═════════════════════════════════════════════════════════════════════════════
#  RESUMO
# ═════════════════════════════════════════════════════════════════════════════
Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║                    Resumo                        ║" -ForegroundColor Green
Write-Host "  ╠═══════════════════════════════════════════════════╣" -ForegroundColor Green

$agentSummary = "{0} criados  {1} atualizados  {2} sem mudancas" -f `
    $tally.agents_created, $tally.agents_updated, $tally.agents_unchanged
Write-Host ("  ║  Agentes      {0,-36}║" -f $agentSummary) -ForegroundColor Green

$kbSummary = switch ($tally.knowledge_status) {
    "rebuilt"   { "reconstruido — $($tally.knowledge_docs) documentos" }
    "unchanged" { "sem mudancas — $($tally.knowledge_docs) documentos" }
    "failed"    { "FALHA — DB anterior mantido" }
    default     { "nao configurado (Python ausente)" }
}
Write-Host ("  ║  Knowledge DB {0,-36}║" -f $kbSummary) -ForegroundColor Green
Write-Host ("  ║  MCP Config   {0,-36}║" -f $tally.mcp_status) -ForegroundColor Green
Write-Host ("  ║  Roo Config   {0,-36}║" -f $tally.roo_status) -ForegroundColor Green
Write-Host ("  ║  Dependencias {0,-36}║" -f $tally.deps_status) -ForegroundColor Green
Write-Host ("  ║  Scripts      {0,-36}║" -f ("{0} atualizados  {1} sem mudancas" -f $tally.scripts_updated, $tally.scripts_unchanged)) -ForegroundColor Green
Write-Host "  ╚═══════════════════════════════════════════════════╝" -ForegroundColor Green

Write-Host ""
Write-Host "  FACTORY_ROOT = $FACTORY_PATH" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Claude Code — use em qualquer projeto:" -ForegroundColor Cyan
Write-Host "    @techlead  @qa  @architect  @po  @devbackend ..."
Write-Host ""
if ($hasPython) {
    Write-Host "  Atualizar apos git pull / editar conhecimento:" -ForegroundColor Cyan
    Write-Host "    .\update-knowledge.ps1"
    Write-Host ""
    Write-Host "  Vincular MCP ou Roo a outro projeto:" -ForegroundColor Cyan
    Write-Host "    & `"`$env:FACTORY_ROOT\link-mcp.ps1`""
    Write-Host "    & `"`$env:FACTORY_ROOT\link-roo.ps1`""
    Write-Host ""
}
