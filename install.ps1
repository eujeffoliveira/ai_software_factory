# install.ps1 — Universal Factory CLI Installer (PowerShell)
# Usage: .\install.ps1

$ErrorActionPreference = "Stop"

$FACTORY_PATH = (Get-Location).Path
$CLAUDE_AGENTS_DIR = "$env:USERPROFILE\.claude\agents"
$BIN_DIR = "$env:USERPROFILE\.local\bin"
$FACTORY_SCRIPT = "$BIN_DIR\factory.ps1"

Write-Host "======================================================"
Write-Host " AI Software Factory — CLI Installer (PowerShell)"
Write-Host "======================================================"
Write-Host " Factory path: $FACTORY_PATH"
Write-Host ""

# ── 1. Criar ~/.claude/agents/ ────────────────────────────

if (-not (Test-Path $CLAUDE_AGENTS_DIR)) {
    New-Item -ItemType Directory -Path $CLAUDE_AGENTS_DIR -Force | Out-Null
    Write-Host "[OK] Criado: $CLAUDE_AGENTS_DIR"
} else {
    Write-Host "[SKIP] Já existe: $CLAUDE_AGENTS_DIR"
}

# ── 2. Mapeamento de agentes ──────────────────────────────

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

# ── 3. Criar arquivos em ~/.claude/agents/ ────────────────

Write-Host ""
Write-Host "Configurando agentes em Claude Code..."
Write-Host ""

foreach ($agent in $agents) {
    $promptFile = Join-Path $FACTORY_PATH "$($agent.Folder)\prompt.md"
    $outputFile = Join-Path $CLAUDE_AGENTS_DIR "$($agent.Name).md"

    if (-not (Test-Path $promptFile)) {
        Write-Host "[WARN] prompt.md nao encontrado: $promptFile"
        continue
    }

    $promptContent = Get-Content $promptFile -Raw

    $fileContent = @"
---
name: $($agent.Name)
description: $($agent.Description)
---

$promptContent
"@

    Set-Content -Path $outputFile -Value $fileContent -Encoding UTF8
    Write-Host "[OK] @$($agent.Name)"
}

# ── 4. Criar factory.ps1 para Gemini ─────────────────────

if (-not (Test-Path $BIN_DIR)) {
    New-Item -ItemType Directory -Path $BIN_DIR | Out-Null
}

$factoryScript = @"
# factory.ps1 — AI Agent CLI para Gemini
# Gerado por install.ps1 — para atualizar, re-execute install.ps1

param(
    [string]`$AgentFolder,
    [string]`$Engine = "gemini",
    [Parameter(ValueFromRemainingArguments=`$true)]
    [string[]]`$QueryParts
)

`$FACTORY_PATH = "$FACTORY_PATH"

if (-not `$AgentFolder) {
    Write-Host "Uso: factory <agent-folder> [engine] [query...]"
    Write-Host ""
    Write-Host "  engine     gemini (padrao) | claude"
    Write-Host "  query      Prompt direto. Omitir para modo interativo."
    Write-Host ""
    Write-Host "Exemplos:"
    Write-Host "  factory Agente00_TechLead gemini"
    Write-Host "  factory Agente02_SoftwareArchitect gemini 'Projete uma API REST'"
    exit 1
}

`$AgentDir = Join-Path `$FACTORY_PATH `$AgentFolder
`$PromptFile = Join-Path `$AgentDir "prompt.md"

if (-not (Test-Path `$AgentDir)) {
    Write-Error "Pasta do agente nao encontrada: `$AgentDir"
    exit 1
}

if (-not (Test-Path `$PromptFile)) {
    Write-Error "prompt.md nao encontrado em `$AgentDir"
    exit 1
}

`$System = Get-Content `$PromptFile -Raw
`$QueryStr = `$QueryParts -join " "

switch (`$Engine) {
    "gemini" {
        if (`$QueryStr) {
            & gemini --system-prompt `$System -p `$QueryStr
        } else {
            & gemini --system-prompt `$System
        }
    }
    "claude" {
        if (`$QueryStr) {
            & claude --system-prompt `$System -p `$QueryStr --add-dir `$AgentDir
        } else {
            & claude --system-prompt `$System --add-dir `$AgentDir
        }
    }
    default {
        Write-Error "Engine desconhecida: '`$Engine'. Use 'gemini' ou 'claude'."
        exit 1
    }
}
"@

Set-Content -Path $FACTORY_SCRIPT -Value $factoryScript -Encoding UTF8
Write-Host ""
Write-Host "[OK] factory.ps1 para Gemini: $FACTORY_SCRIPT"

# ── 5. Done ───────────────────────────────────────────────

Write-Host ""
Write-Host "======================================================"
Write-Host " Instalacao concluida!"
Write-Host "======================================================"
Write-Host ""
Write-Host " Claude Code (qualquer sessao aberta):"
Write-Host "   @techlead faca um levantamento dos requisitos"
Write-Host "   @po crie as user stories para pagamentos"
Write-Host "   @architect desenhe a arquitetura do sistema"
Write-Host ""
Write-Host " Gemini (terminal):"
Write-Host "   factory Agente00_TechLead gemini 'sua query'"
Write-Host ""
Write-Host " Nota: se voce tinha aliases antigos no `$PROFILE, pode remover"
Write-Host " o bloco entre '# BEGIN factory-aliases' e '# END factory-aliases'."
Write-Host ""
