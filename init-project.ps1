<#
.SYNOPSIS
    Initializes a .factory/ workspace in the current project directory.

.DESCRIPTION
    Creates a standard .factory/ directory structure that the Tech Lead uses
    to maintain State Ledger, decisions, and artifacts across long projects.

    This script is OPTIONAL. Prompts simple questions or existing projects
    do not need .factory/. Use it when:
      - Starting a multi-sprint project operated by the factory
      - You want the Tech Lead to persist state between sessions
      - You need an audit trail for gates, ADRs, and decisions

    The script is IDEMPOTENT: running it twice does not overwrite existing files.
    Existing files are preserved. Use -Force to overwrite (creates backups).

.PARAMETER Force
    Overwrite existing files (backs them up first with .bak.<timestamp> suffix).

.PARAMETER WhatIf
    Show what would be created without making any changes.

.EXAMPLE
    cd C:\my-project
    & "$env:FACTORY_ROOT\init-project.ps1"

.EXAMPLE
    & "$env:FACTORY_ROOT\init-project.ps1" -WhatIf

.EXAMPLE
    & "$env:FACTORY_ROOT\init-project.ps1" -Force
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── helpers ──────────────────────────────────────────────────────────────────

function Write-Status {
    param([string]$Status, [string]$Message, [string]$Color = "White")
    $prefix = switch ($Status) {
        "OK"      { "  [OK]     " }
        "CREATED" { "  [CREATED]" }
        "EXISTS"  { "  [EXISTS] " }
        "BACKUP"  { "  [BACKUP] " }
        "SKIP"    { "  [SKIP]   " }
        "DRY"     { "  [DRY-RUN]" }
        "ERROR"   { "  [ERROR]  " }
        default   { "  [INFO]   " }
    }
    $col = switch ($Status) {
        "OK"      { "Green" }
        "CREATED" { "Cyan" }
        "EXISTS"  { "DarkGray" }
        "BACKUP"  { "Yellow" }
        "SKIP"    { "DarkGray" }
        "DRY"     { "Magenta" }
        "ERROR"   { "Red" }
        default   { "White" }
    }
    Write-Host "$prefix $Message" -ForegroundColor $col
}

function New-FactoryFile {
    param([string]$Path, [string]$Content)
    if ($WhatIfPreference) {
        Write-Status "DRY" "Would create: $Path"
        return
    }
    $exists = Test-Path $Path
    if ($exists -and -not $Force) {
        Write-Status "EXISTS" "Already exists (skipping): $Path"
        return
    }
    if ($exists -and $Force) {
        $ts = (Get-Date -Format "yyyyMMdd-HHmmss")
        $backup = "$Path.bak.$ts"
        Copy-Item $Path $backup
        Write-Status "BACKUP" "Backed up to: $(Split-Path $backup -Leaf)"
    }
    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Content, [System.Text.UTF8Encoding]::new($false))
    Write-Status "CREATED" "$(Split-Path $Path -Leaf)"
}

function New-FactoryDir {
    param([string]$Path)
    if ($WhatIfPreference) {
        Write-Status "DRY" "Would create directory: $Path"
        return
    }
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Status "CREATED" "$Path\"
    } else {
        Write-Status "EXISTS" "$Path\"
    }
}

# ── resolve paths ─────────────────────────────────────────────────────────────

$projectRoot = (Get-Location).Path
$factoryDir  = Join-Path $projectRoot ".factory"
$factoryRoot = $env:FACTORY_ROOT

if (-not $factoryRoot) {
    Write-Host "  [ERROR] FACTORY_ROOT is not set. Run '.\install.ps1' first from the factory directory." -ForegroundColor Red
    exit 1
}

$templateDir = Join-Path $factoryRoot "templates\project"

# ── banner ────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "  AI Software Factory — init-project" -ForegroundColor Cyan
Write-Host "  Project: $projectRoot" -ForegroundColor DarkGray
if ($WhatIfPreference) {
    Write-Host "  Mode: DRY-RUN (no changes will be made)" -ForegroundColor Magenta
} elseif ($Force) {
    Write-Host "  Mode: FORCE (existing files will be backed up and overwritten)" -ForegroundColor Yellow
} else {
    Write-Host "  Mode: SAFE (existing files are preserved)" -ForegroundColor Green
}
Write-Host ""

# ── safety check ─────────────────────────────────────────────────────────────

# Prevent accidental initialization inside the factory itself
$factoryRootResolved = (Resolve-Path $factoryRoot -ErrorAction SilentlyContinue)?.Path
$projectRootResolved = (Resolve-Path $projectRoot).Path
if ($factoryRootResolved -and ($projectRootResolved -eq $factoryRootResolved)) {
    Write-Host "  [ERROR] You are inside the factory directory itself. Navigate to your project first." -ForegroundColor Red
    exit 1
}

# ── create directory structure ────────────────────────────────────────────────

New-FactoryDir $factoryDir
New-FactoryDir (Join-Path $factoryDir "artifacts")
New-FactoryDir (Join-Path $factoryDir "decisions")
New-FactoryDir (Join-Path $factoryDir "risks")

# ── load templates ────────────────────────────────────────────────────────────

$now    = (Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ")
$projId = (Split-Path $projectRoot -Leaf) -replace '[^a-z0-9-]', '-' -replace '-+', '-' -replace '^-|-$', ''
$projId = $projId.ToLower()
if (-not $projId) { $projId = "my-project" }

# ── State_Ledger.json ─────────────────────────────────────────────────────────

$stateLedgerContent = @"
{
  "project_name": "$(Split-Path $projectRoot -Leaf)",
  "project_id": "$projId",
  "project_archetype": "",
  "golden_model": "",
  "created_at": "$now",
  "updated_at": "$now",
  "current_phase": "requirements",
  "current_agent": "Agente00_TechLead",
  "next_agent": "Agente01_ProductOwner",
  "approved_artifacts": {
    "prd": false,
    "architecture": false,
    "api_contract": false,
    "db_schema": false,
    "execution_plan": false,
    "qa": false,
    "security": false,
    "deployment": false,
    "rollback": false,
    "post_deploy": false
  },
  "open_questions": [],
  "decisions": [],
  "adrs": [],
  "risks": [],
  "blocked_tasks": [],
  "human_approvals_required": [],
  "gate_history": [],
  "mcp_status": {
    "server_online": null,
    "last_checked": null,
    "documents_indexed": null
  },
  "next_action": "Run Gate A0 — share project_profile.md with @techlead to classify archetype and initialize SDLC"
}
"@

New-FactoryFile (Join-Path $factoryDir "State_Ledger.json") $stateLedgerContent

# ── project_profile.md ────────────────────────────────────────────────────────

$profileSrc = Join-Path $templateDir "project_profile.md"
if (Test-Path $profileSrc) {
    $profileContent = Get-Content $profileSrc -Raw -Encoding UTF8
    $profileContent = $profileContent -replace '\{\{PROJECT_NAME\}\}', (Split-Path $projectRoot -Leaf)
    $profileContent = $profileContent -replace '\{\{PROJECT_ID\}\}', $projId
    $profileContent = $profileContent -replace '\{\{ISO_DATE\}\}', (Get-Date -Format "yyyy-MM-dd")
} else {
    $profileContent = "# Project Profile — $(Split-Path $projectRoot -Leaf)`n`nFill in project details here. See templates/project/project_profile.md for the full template.`n"
}

New-FactoryFile (Join-Path $factoryDir "project_profile.md") $profileContent

# ── decisions/.gitkeep ────────────────────────────────────────────────────────

New-FactoryFile (Join-Path $factoryDir "decisions\.gitkeep") ""
New-FactoryFile (Join-Path $factoryDir "risks\.gitkeep") ""
New-FactoryFile (Join-Path $factoryDir "artifacts\.gitkeep") ""

# ── README_FACTORY.md ─────────────────────────────────────────────────────────

$readmeContent = @"
# .factory/ — AI Software Factory Workspace

This directory is the Tech Lead's workspace for this project.
It is maintained by ``@techlead`` during factory-operated sessions.

## Files

| File | Purpose |
|------|---------|
| ``State_Ledger.json`` | Global project state: phase, gates, artifacts, risks, ADRs, decisions |
| ``project_profile.md`` | Project brief shared with agents at session start |
| ``artifacts/`` | Agent-produced artifacts (PRD.md, Architecture.md, etc.) |
| ``decisions/`` | Gate decisions and ADR files |
| ``risks/`` | Risk register entries |

## Usage

Start every new session with:

``````
@techlead aqui está o perfil do projeto: [attach .factory/project_profile.md]
         e o estado atual: [attach .factory/State_Ledger.json]
``````

Or let the Tech Lead read the files directly:

``````
@techlead leia .factory/State_Ledger.json e retome de onde paramos
``````

## Important

- Commit ``State_Ledger.json`` and ``project_profile.md`` to version control.
- Add ``.factory/artifacts/``, ``.factory/decisions/``, and ``.factory/risks/`` to ``.gitignore`` if they contain sensitive content.
- This directory does NOT replace the factory installation — it is a per-project workspace.

See ``docs/PROJECT_OPERATION.md`` in ``\$env:FACTORY_ROOT`` for full instructions.
"@

New-FactoryFile (Join-Path $factoryDir "README_FACTORY.md") $readmeContent

# ── summary ───────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "  DONE — .factory/ workspace initialized" -ForegroundColor Green
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor White
Write-Host "    1. Fill in .factory/project_profile.md with project details" -ForegroundColor DarkGray
Write-Host "    2. Open Claude Code and run: @techlead conduza o Gate A0 para este projeto" -ForegroundColor DarkGray
Write-Host "    3. Share .factory/project_profile.md with the Tech Lead" -ForegroundColor DarkGray
Write-Host "    4. The Tech Lead will update .factory/State_Ledger.json as the project progresses" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  See: `$env:FACTORY_ROOT\docs\PROJECT_OPERATION.md" -ForegroundColor DarkGray
Write-Host ""
