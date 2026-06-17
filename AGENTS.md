# AGENTS.md

This file provides guidance to Codex when working in this repository.

This repository is a prompt-engineering and agent-design project, not a runnable
application. Work normally means editing Markdown, JSON, PowerShell, shell, or
Python utility files that define and validate a multi-agent SDLC framework.

## Runtime Matrix

The factory supports multiple agent runtimes from the same canonical sources:

| Runtime | Agent surface | MCP surface | Notes |
|---|---|---|---|
| Claude Code | `~/.claude/agents/<name>.md` and `@name` | `~/.claude.json` plus `.mcp.json` | Primary historical runtime |
| Codex | `~/.codex/agents/<name>.toml` custom agents | `~/.codex/config.toml` plus `.codex/config.toml` | Use as custom subagents, not Claude-style `@name` |
| Gemini CLI | `factory.ps1` wrapper | none | Partial/manual support |

The canonical agent content remains in each `AgenteXX_*/` folder. Generated
runtime files must be derived from those sources, not hand-maintained as forks.

## Core Architecture Rule

Preserve build-time versus runtime isolation:

- Build-time sources: `context/`, `lib/`, bibliography/playbooks, and global
  architecture references used to distill local agent artifacts.
- Runtime sources: the selected agent's own `AgenteXX_*/` folder, especially
  `knowledge/`, plus the `knowledge` MCP server.
- Do not make runtime instructions depend directly on `context/` or `lib/`
  unless the user explicitly asks for a build-time distillation task.

Each `agent_config.json` defines `allowed_runtime_sources` and
`blocked_runtime_sources`. Keep those contracts intact.

## Agent Sources

Each fully built agent follows this structure:

```text
AgenteXX_RoleName/
  prompt.md
  agent_config.json
  context_view.md
  rag_manifest.json
  skills_manifest.md
  quality_gate.md
  handoff_schema.json
  failure_modes.md
  knowledge/
  checklists/
  schemas/
  templates/
  examples/
  skills/
  tools/                 optional executable tools
```

The 11 agents are:

- `techlead` - Tech Lead, gates, ADRs, risks, State Ledger
- `po` - Product Owner, PRD, user stories, acceptance criteria
- `architect` - architecture, UML, ADRs, technical strategy
- `engineer` - task decomposition, execution plans, sequencing
- `devbackend` - APIs, services, data access, backend implementation
- `devfrontend` - React/Next.js UI, accessibility, frontend reports
- `qa` - test strategy, Vitest, Playwright, QA reports
- `devsecops` - security review, hardening, secrets policy
- `devops` - CI/CD, deployment, rollback, runbooks
- `uxui` - UX flows, wireframes, design system, accessibility
- `dataengineer` - pipelines, ETL, integrations, data governance

## Codex-Specific Guidance

Codex reads this file as persistent project guidance. Keep it concise and put
long-form usage documentation in `docs/`.

After `.\install.ps1`, Codex custom agents are generated in
`~/.codex/agents/<name>.toml`. Use them by asking Codex to spawn or use a named
subagent, for example:

```text
Use the qa custom agent to review the test strategy, then summarize gaps.
Spawn techlead and architect as subagents and compare their recommendations.
```

Codex does not use Claude Code's `@techlead` syntax. For project behavior, use
`AGENTS.md`; for reusable Codex roles, use `~/.codex/agents/*.toml`; for MCP,
use `.codex/config.toml` or `~/.codex/config.toml`.

## MCP Knowledge

The MCP server lives in `tools/mcp-knowledge-search/` and exposes:

- `health_check`
- `knowledge_stats`
- `search_knowledge`
- `search_with_filters`
- `get_full_document`
- `get_context`

Use MCP-first behavior when answering about factory internals such as skills,
schemas, templates, examples, checklists, playbooks, Golden Models, gates,
failure modes, knowledge cards, heuristics, and principles.

If MCP fails, say so explicitly, use direct file reads only as declared fallback,
and recommend:

```powershell
.\test-mcp.ps1
```

## Generated Files

`install.ps1` is the source of truth for generated runtime outputs. It creates
or updates:

- Claude agents in `~/.claude/agents/`
- Codex custom agents in `~/.codex/agents/`
- MCP entries in `~/.claude.json`, `~/.codex/config.toml`, and `.mcp.json`
- local `.codex/config.toml` for this factory repository
- helper scripts such as `update-knowledge.ps1` and `link-mcp.ps1`

Do not hand-edit generated user-local files. Update `install.ps1` or the
canonical `AgenteXX_*/` sources, then run the installer.

Generated local artifacts with machine-specific paths are intentionally
gitignored: `knowledge.db`, `knowledge-config.json`, `.mcp.json`, and `.codex/`.

## Validation Commands

Use these commands after changes:

```powershell
python tools/factory-validators/run_all.py
.\test-mcp.ps1
.\doctor.ps1
```

When changing `prompt.md` or `knowledge/`, run:

```powershell
.\install.ps1
```

When changing only indexed knowledge files and not prompts:

```powershell
.\update-knowledge.ps1
```

## Editing Rules

- Preserve agent names, responsibilities, quality gates, ADR policy, State
  Ledger behavior, Definition of Done, MCP-first policy, and source isolation.
- Do not put knowledge artifacts in `tools/`; put shared executable utilities
  in `tools/` and agent-specific executable utilities in `AgenteXX_*/tools/`.
- Do not edit `context/` master files unless the user explicitly asks.
- Do not fill `context/client_profile.md` unless performing a client
  instantiation.
- Do not edit existing `bibliography/playbooks/` files without explicit
  instruction; treat them as append-only reference material.
- Do not commit or push unless the user explicitly authorizes it.

## Documentation Map

- `docs/CODEX.md` - Codex installation, custom agents, MCP, and limits
- `docs/CLIENT_COMPATIBILITY.md` - runtime comparison
- `docs/INSTALLATION.md` - install phases
- `docs/MCP_RAG.md` - knowledge DB and MCP tools
- `docs/TESTING.md` - validators and smoke checks
- `docs/AGENTS.md` - agent role reference
