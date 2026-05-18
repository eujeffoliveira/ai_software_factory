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
- `install.sh` + `docs/INSTALL_CLI.md` — Universal Factory CLI installer
- Agent-specific `tools/` subdirectories: Agente06 (Playwright E2E templates + audit script), Agente07 (git security hooks + SENTINEL framework), Agente08 (branch-protection + parallel-agent locking hooks), Agente10 (predictive-rigor governance framework)

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

## Universal Factory CLI (`install.sh`)

`install.sh` at the repo root installs a `factory` wrapper at `~/.local/bin/factory` and injects 11 shell aliases. Run it once per machine after cloning:

```bash
chmod +x install.sh && ./install.sh
source ~/.bashrc   # or ~/.zshrc
```

After that, any of the 11 agents can be invoked from any directory:

```bash
techlead       # → Agente00_TechLead (claude, interactive)
architect 'Design a payments API'  # → Agente02_SoftwareArchitect (one-shot)
factory Agente06_QaEngineer gemini 'Write E2E tests'   # → explicit engine
```

Full documentation: `docs/INSTALL_CLI.md`. The installer is idempotent — safe to re-run after moving the repo.

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

The mandatory tech stack for all projects produced by this factory:

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

Any deviation from the Golden Model requires an ADR. Gate 2 is blocked until the ADR is approved.

---

## Quality gates and status codes

7 sequential gates govern pipeline advancement. Key rules:

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
- `install.sh` embeds `FACTORY_PATH` at install time — re-run it whenever the repo is cloned to a new machine or relocated
