# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## What this repository is

This is a **prompt-engineering and agent-design project** — not a runnable software application. There are no build commands, test runners, or linters. The work here consists of creating and editing Markdown and JSON files that define AI agents following strict structural conventions.

The repository implements a multi-agent Software Development Lifecycle (SDLC) framework with 11 specialized agents (Agente00–Agente10). Each agent has a role, a set of skills, JSON schemas, checklists, examples, and distilled operational knowledge.

**Agente00_TechLead and Agente01_ProductOwner are fully built.** Agents 02–08 have skeleton folders but incomplete artifacts. Agents 09–10 have no local artifacts yet.

---

## Core architectural rule: Build-time vs. Runtime isolation

This is the single most important concept in the repo.

- **Build-time**: Agents are constructed by reading `context/`, `lib/` (reference books), and global architecture documents. These sources are processed once to produce the agent's local artifacts.
- **Runtime**: Agents read **only** from their own `AgenteXX_*/` folder and `knowledge/`. They never access `context/`, `lib/`, or any global source.

The `agent_config.json` for each agent explicitly lists `allowed_runtime_sources` and `blocked_runtime_sources`. The `knowledge/` subfolder holds the distilled output of the build-time reading — principles, heuristics, decision rules, and knowledge cards.

`lib/` is gitignored (reference books). `context/*_raiz.md` files are also gitignored (internal-only variants).

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
└── skills/
    └── name-of-skill/
        ├── skill.md           # What the skill does, when to use, inputs, outputs
        ├── input.schema.json
        ├── output.schema.json
        ├── checklist.md
        └── examples/
            ├── good_output.md
            └── bad_output.md
```

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
| `lib/STATUS_DOWNLOADS.md` | Status index of all reference books per agent |

Never modify `context/` files unless explicitly asked to update the master definitions.

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
- Read `Agente00_TechLead/` as the reference implementation — it is the only complete agent
- Do not introduce references to specific organizations, client names, or domain-specific terminology in `_generico` files
- `lib/` is gitignored — do not attempt to commit book files
- When updating `lib/STATUS_DOWNLOADS.md`, follow the existing table format: ✅ found, ⚠️ partial, ❌ not found, 📂 already in another agent's folder
