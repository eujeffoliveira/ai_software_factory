# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## What this repository is

This is a **prompt-engineering and agent-design project** — not a runnable software application. There are no build commands, test runners, or linters. The work here consists of creating and editing Markdown and JSON files that define AI agents following strict structural conventions.

The repository implements a multi-agent Software Development Lifecycle (SDLC) framework with 11 specialized agents (Agente00–Agente10). Each agent has a role, a set of skills, JSON schemas, checklists, examples, and distilled operational knowledge.

**All 11 agents are fully built** (Agente00_TechLead through Agente10_DataIntegrationEngineer).

Agente00–Agente03 received a **knowledge patch on 2026-05-17**: course materials from a Software Engineering postgraduate curriculum (12 modules) were distilled into each agent's `knowledge/` folder. New principles, heuristics, decision rules, knowledge cards, and source_map entries were added to Agente00 (project metrics + IT governance), Agente01 (BPMN, ISO 25010, requirements traceability), Agente02 (UML diagrams: use case, sequence, class), and Agente03 (extracting tasks from UML, cohesion/coupling at task level).

All 11 agents received a **capability upgrade on 2026-05-18**: executable tools, scripts, and operational playbooks were added to the repository. These are runtime-accessible additions and did not modify any existing agent logic or knowledge artifacts. Specifically:

- `tools/` — shared factory scripts, MCP knowledge-search server, document-generation utilities
- `bibliography/playbooks/` — 12 operational playbooks (prompt engineering, security, DevOps, UX, testing, MCPs, workflow automation, etc.)
- `install.ps1` (PowerShell/Windows) + `install.sh` (Git Bash/Linux/macOS) + `docs/INSTALL_CLI.md` — Universal Factory CLI installer
- Agent-specific `tools/` subdirectories: Agente06 (Playwright E2E templates + audit script), Agente07 (git security hooks + SENTINEL framework), Agente08 (branch-protection + parallel-agent locking hooks), Agente10 (predictive-rigor governance framework)

All 8 relevant agents received a **multi-archetype Golden Model upgrade on 2026-05-22**: the factory evolved from a single web-only stack to a matrix of 8 project archetypes. A new `standards/` directory was created at the repo root with archetype-specific Golden Models, Gate A0 (project classification before Gate 1), automation templates and checklists, and example multi-agent prompt sequences. All relevant agent `knowledge/decision_rules.md` files were extended with DR-CLASS-001 through DR-CLASS-005, and all relevant `prompt.md` files received a "Project Archetype Classification" table.

---

## Core architectural rule: Build-time vs. Runtime isolation

This is the single most important concept in the repo.

- **Build-time**: Agents are constructed by reading `context/`, `lib/` (reference books), and global architecture documents. These sources are processed once to produce the agent's local artifacts.
- **Runtime**: Agents read **only** from their own `AgenteXX_*/` folder and `knowledge/`. They never access `context/`, `lib/`, or any global source.

The `agent_config.json` for each agent explicitly lists `allowed_runtime_sources` and `blocked_runtime_sources`. The `knowledge/` subfolder holds the distilled output of the build-time reading — principles, heuristics, decision rules, and knowledge cards.

`lib/` is gitignored (reference books). `context/*_raiz.md` files are also gitignored (internal-only variants).

---

## Shared runtime tools (`tools/`)

The `tools/` directory contains build-time and runtime utilities shared across all agents. It is not agent-specific knowledge — it exposes functionality only.

```
tools/
├── factory-scripts/          # validate-framework.sh, validate-skills.sh, credential-preflight.sh,
│                             # memory-guard.sh, agent-metrics.sh
├── mcp-knowledge-search/     # FastMCP server (SQLite FTS5); configure via .mcp.json
└── document-generation/      # spellcheck_document.py, validate_office_file.py
```

Rules:
- Do not put knowledge (principles, heuristics, decision rules) in `tools/`. That belongs in each agent's `knowledge/` folder.
- Agents may reference scripts in `tools/factory-scripts/` for validation and monitoring.
- The MCP server in `tools/mcp-knowledge-search/` provides runtime document search.

---

## MCP Knowledge Search (`tools/mcp-knowledge-search/`)

The MCP Knowledge Search is a FastMCP server with SQLite FTS5 that indexes all factory content and exposes semantic search tools to agents at runtime.

**Configured automatically by `install.ps1`:**
- `knowledge.db` — SQLite FTS5 database (7,000+ indexed documents)
- `~/.claude/settings.json` — global `mcpServers.knowledge` entry
- `.mcp.json` — local factory configuration (use `link-mcp.ps1` in other projects)

**Exposed tools:**

| Tool | Usage |
|------|-------|
| `search_knowledge("term")` | Full-text search across all factory artifacts |
| `get_full_document("doc_id")` | Retrieve a complete document by ID |
| `get_context("doc_id")` | Retrieve adjacent sections from the same file |
| `knowledge_stats()` | Database statistics and indexed categories |

**What is indexed:** `skills/`, `schemas/`, `templates/`, `examples/`, `checklists/`, `knowledge/`, `bibliography/playbooks/`

**To update after editing content:** `.\update-knowledge.ps1`
**To activate in another project:** `& "$env:FACTORY_ROOT\link-mcp.ps1"`

Rules:
- The MCP serves deep content (skills, schemas, templates, examples) on demand.
- Knowledge embedded in agent files (`~/.claude/agents/`) serves fast responses without a network call.
- The two work in layers: embedded knowledge for quick answers → MCP search for depth.

---

## Roo Code / Cline (`roo/`)

`install.ps1` generates `roo/.roomodes` and `roo/.clinerules` with all 11 agents as **custom modes** for Roo Code / Cline in VS Code.

To activate in a project:

```powershell
# Run from the target project folder
& "$env:FACTORY_ROOT\link-roo.ps1"
```

This copies `.roomodes` and `.clinerules` to the current project (with automatic backup). Open VS Code and select the desired mode in Roo Code.

The `roo/` files are gitignored — generated and updated by `install.ps1`.

---

## Bibliography (`bibliography/`)

The `bibliography/` directory holds operational playbooks distilled from engineering best practices. These are **shared reference material**, not agent-specific knowledge.

```
bibliography/
└── playbooks/                # 12 operational playbooks (01–12)
    ├── 01_Prompt_Engineering_Patterns.md
    ├── 02_Code_Review_Checklist.md
    ├── 03_Seguranca_e_Privacidade.md
    ├── 04_Performance_e_Escalabilidade.md
    ├── 05_Testes_e_Qualidade.md
    ├── 06_DevOps_CI_CD.md
    ├── 07_UX_UI_Design.md
    ├── 08_Gestao_Memoria_Contexto.md
    ├── 09_Integracao_MCPs.md
    ├── 10_Automacao_Workflows.md
    ├── 11_Incorporacao_Software_Existente.md
    └── 12_Dados_e_Integracao.md
```

Playbooks are **build-time reference** for enriching agent knowledge. They are not loaded at runtime automatically.

---

## Standards (`standards/`)

The `standards/` directory houses the Golden Model matrix — archetype-specific tech stacks, Gate A0 definition, automation templates, checklists, and example prompt sequences. All files in `standards/` are indexed by MCP/RAG (`knowledge.db`).

```
standards/
├── project-classification.md          # Gate A0: 8 archetypes, decision tree, ADR rules, JSON output template
├── golden-model-web-app.md            # web_app archetype (Next.js 16 stack)
├── golden-model-python-automation.md  # automation_script archetype (Python 3.12+, uv, Typer, Pydantic v2)
├── golden-model-data-pipeline.md      # data_pipeline archetype (Python + Polars + DuckDB + Pandera)
├── golden-model-api-service.md        # api_service archetype (FastAPI or Next.js Route Handlers)
├── golden-model-cli-tool.md           # cli_tool archetype (Typer + pyproject.toml packaging)
├── golden-model-mcp-server.md         # mcp_server archetype (FastMCP + Pydantic schemas)
├── golden-model-integration-worker.md # integration_worker archetype (Redis/queues + tenacity + dead-letter)
└── golden-model-notebook-analysis.md  # notebook_analysis archetype (Jupyter + Polars/Pandas, never production)
```

Companion directories (also indexed by MCP/RAG):
- `templates/automation/` — 10 artifact templates for the `automation_script` archetype
- `checklists/automation/` — 8 operational checklists (idempotency, dry-run, secrets, logging, retries, testing, etc.)
- `examples/requests/` — 6 example multi-agent prompt sequences (one per archetype)

Rules:
- Do not put agent knowledge (principles, heuristics, decision rules) in `standards/`. That belongs in each agent's `knowledge/` folder.
- `standards/project-classification.md` is the authoritative source for Gate A0 and archetype selection.
- After editing any file in `standards/`, `templates/automation/`, `checklists/automation/`, or `examples/requests/`, run `.\update-knowledge.ps1` to reindex.

---

## Universal Factory CLI

**Prerequisites:** Python 3.x must be available on PATH (required for MCP Knowledge Search).

Run the installer from the repo root in PowerShell:

```powershell
.\install.ps1
# Force pip dependency reinstall even if already up-to-date:
.\install.ps1 -ForceDeps
```

`install.ps1` is fully idempotent — running it twice reports all items as `sem mudancas`. It uses content comparison with LF normalization and UTF-8 without BOM. `~/.claude/settings.json` receives a surgical merge that adds `mcpServers.knowledge` without touching any other keys; a timestamped backup is created only when a real change is made.

**What `install.ps1` does (11 phases):**

1. Sets `FACTORY_ROOT` as a Windows user environment variable
2. Detects Python and installs MCP dependencies via pip (controlled by SHA256 hash — skipped if unchanged)
3. Creates `~/.claude/agents/<name>.md` for each of the 11 agents with **hybrid content**:
   - `prompt.md` of the agent
   - 8 embedded knowledge files: `knowledge/principles.md`, `knowledge/heuristics.md`, `knowledge/decision_rules.md`, `knowledge/knowledge_cards.md`, `skills_manifest.md`, `quality_gate.md`, `context_view.md`, `failure_modes.md`
   - MCP instructions block at the end
4. Creates `knowledge-config.json` (gitignored)
5. Creates/updates `knowledge.db` via `ingest.py` — SQLite FTS5 with 7,000+ indexed documents (reindexes only if any `.md` is newer than the DB)
6. Creates `.mcp.json` (gitignored) at the factory root
7. Merges `mcpServers.knowledge` into `~/.claude/settings.json` without touching other keys
8. Creates `roo/.roomodes` and `roo/.clinerules` (gitignored) for Roo Code / Cline
9. Generates helper scripts: `factory.ps1`, `update-knowledge.ps1`, `link-mcp.ps1`, `link-roo.ps1`

After installation, all 11 agents are available as `@agent-name` inside any Claude Code session from any directory:

```
@techlead I need to design a payments API
@po write user stories for the authentication module
@architect propose a microservices split for this monolith
@qa generate Playwright E2E tests for the login flow
```

For Gemini CLI, use the `factory` wrapper:

```powershell
factory Agente06_QaEngineer gemini 'Write E2E tests'
factory Agente02_SoftwareArchitect gemini
```

**Helper scripts (generated by `install.ps1`, gitignored):**

| Script | Purpose |
|--------|---------|
| `update-knowledge.ps1` | Reindex `knowledge.db` after editing `knowledge/`, `skills/`, etc. without regenerating agent files |
| `link-mcp.ps1` | From another project: `& "$env:FACTORY_ROOT\link-mcp.ps1"` — activates MCP Knowledge Search in that project |
| `link-roo.ps1` | From another project: `& "$env:FACTORY_ROOT\link-roo.ps1"` — copies `.roomodes`/`.clinerules` to that project |

**When to re-run `install.ps1`:** after `git pull`, after editing any agent's `prompt.md`, after editing any `knowledge/` file, or after cloning to a new machine.

Full documentation: `docs/INSTALL_CLI.md`.

When working on this repo, update the `install.ps1` `$agents` array if agent folder names change.

---

## Agent folder structure

Every fully-built agent follows this layout:

```
AgenteXX_NomeAgente/
├── prompt.md                  # System prompt (the agent's identity and rules)
├── agent_config.json          # Runtime config: allowed/blocked sources, capabilities, Golden Model
├── context_view.md            # Compiled local context (replaces context/ at runtime)
├── rag_manifest.json          # RAG policy: collections, chunking, blocked raw sources
├── skills_manifest.md         # Index of all skills + when/how to trigger each
├── quality_gate.md            # Gate criteria this agent validates (format varies by role)
├── handoff_schema.json        # JSON Schema for the agent's output Handoff Package
├── failure_modes.md           # Known failure modes with symptoms, causes, actions
├── knowledge/
│   ├── principles.md          # Operational principles (P1–PN)
│   ├── heuristics.md          # Decision heuristics (H1–HN)
│   ├── decision_rules.md      # If-then rules (DR001–DRNNN)
│   ├── knowledge_cards.md     # Reusable concept cards
│   └── source_map.json        # Build-time source → distilled artifact mapping
├── checklists/                # One checklist per major operation
├── schemas/                   # JSON Schemas for all I/O contracts
├── templates/                 # Markdown/JSON templates for produced artifacts
├── examples/                  # good_*.md and bad_*.md pairs
├── skills/
│   └── name-of-skill/
│       ├── skill.md           # What the skill does, when to use, inputs, outputs
│       ├── input.schema.json
│       ├── output.schema.json
│       ├── checklist.md
│       └── examples/
│           ├── good_output.md
│           └── bad_output.md
└── tools/                     # Optional: executable tools specific to this agent's role
    └── <tool-category>/       # e.g. git-hooks/, sentinel/, e2e-templates/, predictive-rigor/
```

The `tools/` subfolder under an agent is **optional** and only present for agents whose role involves executable tooling (QA, DevSecOps, DevOps, DataEngineer). Knowledge never goes here — tools go here, knowledge goes in `knowledge/`.

When building a new agent, produce build reports in `build/`:
- `AgenteXX_build_report.md`
- `AgenteXX_generated_files_index.md`
- `AgenteXX_runtime_readiness_checklist.md`
- `AgenteXX_knowledge_distillation_patch_report.md`

---

## Key source files (build-time reference)

| File | Purpose |
|------|---------|
| `context/base_teorica.md` | System prompts and knowledge bases for all 11 agents |
| `context/integrantes.md` | Full operational manifesto (~2,300 lines) — roles, rules, behaviors |
| `context/reference_architecture_generico.md` | Golden Model: mandatory tech stack and forbidden patterns |
| `context/manual_arquitetura_componentes_generico.md` | Artifact structure, handoff contracts, gate definitions |
| `context/prompts/prompt_*_generico.md` | Ready-to-use system prompts for each agent |
| `context/client_profile.md` | Client instantiation profile — filled by whoever forks the repo |
| `context/prompts/instantiation_prompt.md` | Instantiation prompt — run after cloning to adapt agents to a client |
| `lib/STATUS_DOWNLOADS.md` | Status index of all reference books per agent |
| `standards/project-classification.md` | Gate A0: 8 archetypes, decision tree, archetype classification rules |
| `standards/golden-model-*.md` | Archetype-specific Golden Models (8 files) |

Never modify `context/` files unless explicitly asked to update the master definitions.
Never modify `context/client_profile.md` on behalf of a client without explicit instruction — it is their source of truth.

---

## Client instantiation workflow

This repo is designed to be forked and customized for any organization. The workflow is:

1. **Fork** this repo on GitHub (keeps the generic version intact as upstream)
2. **Clone** the fork locally
3. **Fill in** `context/client_profile.md` — organization identity, stack overrides, integrations, regulatory context, which agents to activate
4. **Run** `context/prompts/instantiation_prompt.md` in Claude Code — it reads the profile and patches all active agent artifacts
5. **Commit** the result — the fork now contains the client-specific version of the factory

The instantiation prompt is idempotent: re-run it whenever the client profile changes (new integration, stack update, regulatory change). It only touches the fields mapped to the profile — structural artifacts, gates, schemas, and checklists are never modified.

`context/*_raiz.md` files (gitignored) are a pre-existing example of a completed instantiation for a specific organization and were the source material used to design `client_profile.md`. They are not templates and should not be referenced during new instantiations.

---

## Golden Model (governed by Agente00)

The Golden Model is a **matrix of 8 archetypes**, not a single stack. Before applying any technical standard, classify the project using Gate A0 (`standards/project-classification.md`).

**Rule:** Choosing the correct archetype requires no ADR. ADRs are only required for deviations *within* the chosen archetype.

| Archetype | Golden Model | Primary stack |
|-----------|-------------|---------------|
| `web_app` | `standards/golden-model-web-app.md` | Next.js 16 + React 19 + TypeScript + Tailwind + NextAuth + Supabase + Prisma + Vercel |
| `automation_script` | `standards/golden-model-python-automation.md` | Python 3.12+ + uv + Typer + Pydantic v2 + structlog + pytest |
| `data_pipeline` | `standards/golden-model-data-pipeline.md` | Python + Polars + DuckDB + Pandera |
| `api_service` | `standards/golden-model-api-service.md` | FastAPI (Python) or Next.js Route Handlers |
| `cli_tool` | `standards/golden-model-cli-tool.md` | Python + Typer + pyproject.toml |
| `mcp_server` | `standards/golden-model-mcp-server.md` | Python + FastMCP + Pydantic schemas |
| `integration_worker` | `standards/golden-model-integration-worker.md` | Python + Redis/queues + tenacity + dead-letter |
| `notebook_analysis` | `standards/golden-model-notebook-analysis.md` | Jupyter + Polars/Pandas (never directly production) |

### `web_app` stack (default for user-facing applications)

- **Framework**: Next.js 16 (App Router) — never `middleware.ts`, always `proxy.ts`
- **Frontend**: React 19 + TypeScript 5 + Tailwind CSS v4
- **Auth**: NextAuth v5 + Google OAuth
- **Database**: PostgreSQL via Supabase, ORM: Prisma 7 with PrismaPg adapter
- **Migrations**: `prisma migrate deploy` in staging/prod — never `prisma db push`
- **Deploy**: Vercel + Vercel Cron
- **Validation**: Zod at all system boundaries
- **Tests**: Vitest (unit) + Playwright (E2E)
- **Charts**: Recharts v3
- **Data fetching order**: Server Components → Server Actions → SWR (polling only)
- **Env vars**: always via `lib/env.ts`, never scattered `process.env`
- **Logs**: structured JSON (`audit_log` for human actions, `sync_log` for jobs)

Any deviation within an archetype requires an ADR. Gate 2 is blocked until the ADR is approved.

---

## Quality gates and status codes

**Gate A0 — Project Classification** runs before all numbered gates. It classifies the project archetype and selects the corresponding Golden Model. Status codes: `A0_APPROVED` | `A0_AMBIGUOUS` | `A0_BLOCKED`. Gate A0 is only required when the archetype is not immediately obvious.

8 sequential gates govern pipeline advancement (A0 + Gates 1–7). Key rules:

- Gates never skip — RETURNED always goes back to the previous agent
- Gate 5 (Security) and Gate 4 (QA) blocks cannot be overridden by the Tech Lead
- Gate 6 (Deploy) requires both a rollback plan and explicit human approval — no exceptions
- CRITICAL risks without mitigation block the current gate

The 21 valid gate status codes live in `Agente00_TechLead/quality_gate.md`. When writing gate decisions, always use one of the exact codes (e.g., `BLOCKED_PENDING_ADR`, `RETURNED_FOR_REVISION`, `APPROVED`).

---

## Naming conventions

- `_generico` suffix = white-label edition (no client or domain-specific references)
- Agent IDs follow `AgenteXX_RoleName` (two-digit zero-padded number + PascalCase role)
- Skill folders use `kebab-case-skill` naming
- JSON schema files use `snake_case.schema.json`
- Risk IDs: `RISK-NNN` (zero-padded three digits)
- ADR IDs: `ADR-NNN`
- Decision rules: `DR001`–`DRNNN`
- Knowledge cards: `Card NNN`

---

## Editing skills

Each skill requires exactly 6 files. When adding a skill to an existing agent:

1. Create the skill folder under `AgenteXX_*/skills/skill-name/`
2. Write `skill.md` with sections: Purpose, When to Use, Inputs, Outputs, Constraints
3. Write `input.schema.json` and `output.schema.json` as valid JSON Schema (draft-07)
4. Write `checklist.md` — ordered pre/post execution checks
5. Write `examples/good_output.md` and `examples/bad_output.md` showing a realistic scenario
6. Add a `## Knowledge Access Policy` section to `skill.md` and a `## Runtime Knowledge Policy` item to `checklist.md` — this enforces the build/runtime isolation rule at skill level
7. Update `skills_manifest.md` to include the new skill

---

## When working on this repo

- Read `context/base_teorica.md` to understand an agent's role before building its artifacts
- Read any `AgenteXX_*/` folder from Agente00 through Agente10 as reference implementations for fully-built agents — `Agente04_DevBackend/` and `Agente07_DevSecOps/` are particularly comprehensive
- Do not introduce references to specific organizations, client names, or domain-specific terminology in `_generico` files
- `lib/` is gitignored — do not attempt to commit book files
- When updating `lib/STATUS_DOWNLOADS.md`, follow the existing table format: ✅ found, ⚠️ partial, ❌ not found, 📂 already in another agent's folder
- `context/client_profile.md` is a template in the generic repo — do not fill it in unless you are explicitly performing a client instantiation
- After running `instantiation_prompt.md`, verify `build/instantiation_report.md` before reporting the task as complete
- When adding agent-specific executable tools, place them under `AgenteXX_*/tools/<category>/` — never inside `knowledge/` or `skills/`
- When adding shared utilities (used by multiple agents), place them in `tools/` at the repo root, not inside any agent folder
- `bibliography/playbooks/` is append-only — do not edit existing playbooks without explicit instruction
- Re-run `.\install.ps1` whenever: (a) any agent's `prompt.md` changes, (b) any `knowledge/` file changes, (c) the repo is cloned to a new machine or relocated. The installer propagates the full hybrid content (prompt + 8 knowledge files + MCP block) to `~/.claude/agents/`. Running it twice is safe — second run reports all items unchanged.
- `update-knowledge.ps1` reindexes `knowledge.db` without regenerating the agent files — use it for knowledge-only edits after `install.ps1` has run at least once.
- `link-mcp.ps1` and `link-roo.ps1` are generated by the installer and live at the factory root — they are gitignored and machine-specific.
- When adding a new archetype or updating a Golden Model spec, edit the corresponding `standards/golden-model-<archetype>.md` — never embed archetype-specific stack rules inside individual agent files
- `standards/project-classification.md` is the authoritative source for Gate A0 — update it when adding new archetypes or changing classification criteria
- After editing files in `standards/`, `templates/automation/`, `checklists/automation/`, or `examples/requests/`, run `.\update-knowledge.ps1` to reindex the knowledge base (or `.\install.ps1` if any `prompt.md` also changed)
- Never commit or push changes without explicit authorization from the user
