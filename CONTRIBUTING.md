# Contributing to AI Software Factory

Thank you for your interest in contributing. This document explains how to set up, test, and submit changes.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Commands](#commands)
- [How to Contribute](#how-to-contribute)
  - [Adding Knowledge](#adding-knowledge)
  - [Adding or Modifying an Agent](#adding-or-modifying-an-agent)
  - [Adding a Skill](#adding-a-skill)
  - [Adding a Golden Model](#adding-a-golden-model)
  - [Adding a Template, Checklist, or Schema](#adding-a-template-checklist-or-schema)
  - [Updating source_map.json](#updating-source_mapjson)
  - [Using the Standard Knowledge Distillation Prompt](#using-the-standard-knowledge-distillation-prompt)
  - [Fixing a Bug](#fixing-a-bug)
  - [Improving Documentation](#improving-documentation)
- [Antes de abrir PR](#antes-de-abrir-pr)
- [Licensing Policy](#licensing-policy)

---

## Prerequisites

| Tool | Minimum version | Purpose |
|---|---|---|
| Python | 3.10+ | MCP server, knowledge ingestion |
| PowerShell | 7.2+ | Install/doctor/uninstall scripts |
| Claude Code | latest | Running agents (Claude Code CLI) |

Optional but recommended:
- Roo Code extension (VS Code) — for testing Roo modes
- SQLite CLI — for inspecting knowledge.db manually

---

## Setup

```powershell
# 1. Clone the repository
git clone https://github.com/eujeffoliveira/ai_software_factory
cd ai_software_factory

# 2. Install the factory into your Claude Code environment
.\install.ps1

# 3. Verify everything is healthy
.\doctor.ps1

# 4. Run MCP health check
.\test-mcp.ps1
```

The installer is idempotent — re-running it after changes updates only what changed.

---

## Commands

| Command | What it does |
|---|---|
| `.\install.ps1` | Installs/updates agents, MCP server, Roo modes |
| `.\install.ps1 -WhatIf` | Dry-run — shows what would change |
| `.\doctor.ps1` | Full diagnostic (14 categories) |
| `.\test-mcp.ps1` | MCP health check (7 checks) |
| `.\update-knowledge.ps1` | Re-ingests all knowledge files into knowledge.db |
| `.\uninstall.ps1 -WhatIf` | Dry-run uninstall |
| `.\link-mcp.ps1` | Links MCP server to a project's .mcp.json |
| `.\link-roo.ps1` | Generates Roo Code modes for a project |
| `python tools/factory-validators/run_all.py` | Run all 10 factory structure validators |
| `python -m pytest tools/mcp-knowledge-search/tests/ -v` | Run 39 MCP unit tests |

---

## Running Tests

Before submitting a PR, verify that all automated checks pass.

**Factory validators** (no install required, no external deps):

```powershell
python tools/factory-validators/run_all.py
```

Checks 10 categories: governance files, licensing, JSON validity, agent structure, skill structure, source maps, golden models, prompt policies, hardcoded paths, and internal markdown links.

**MCP pytest suite** (requires `pip install fastmcp pytest`):

```powershell
python -m pytest tools/mcp-knowledge-search/tests/ -v
```

39 tests covering `database.py` and all 6 server tools. Uses in-memory SQLite fixtures — no `knowledge.db` required.

**Installation diagnostics** (requires completed install):

```powershell
.\doctor.ps1    # 14 environment categories
.\test-mcp.ps1  # 7 MCP server checks
```

CI runs factory validators and pytest automatically on every push and PR (see `.github/workflows/validate-factory.yml`).

---

## How to Contribute

### Adding Knowledge

Knowledge files live in `Agente*/knowledge/` and are Markdown documents. The ingest pipeline indexes them into the SQLite FTS5 database.

1. Create a `.md` file in the appropriate agent's `knowledge/` folder.
2. Use clear section headings — the FTS index ranks by heading matches.
3. Re-run `.\install.ps1` or `.\update-knowledge.ps1` to ingest.
4. Verify with `.\test-mcp.ps1` that the document count increased.
5. Test a query via MCP: ask Claude Code something the document should answer.

Guidelines for knowledge files:
- Write original synthesis, not verbatim reproduction of copyrighted works.
- Cite sources in a `## References` section at the bottom.
- Keep files under 500 lines for best FTS performance.
- Use Brazilian Portuguese or English consistently throughout a single file.

See `docs/ADDING_KNOWLEDGE.md` for a step-by-step walkthrough.

### Adding or Modifying an Agent

Agent prompts live in `Agente*/prompt.md`. Each agent also has:

```
Agente*/
  prompt.md          # The sub-agent system prompt (CC BY 4.0)
  context_view.md    # What context the agent expects
  quality_gate.md    # Quality criteria for the agent's output
  failure_modes.md   # Known failure patterns and mitigations
  knowledge/         # Domain knowledge files
  skills/            # Reusable skill definitions
  templates/         # Output templates
  checklists/        # Validation checklists
  examples/          # Good and bad output examples
```

When modifying a prompt:
1. Edit `Agente*/prompt.md` directly.
2. Run `.\install.ps1` — it detects the hash change and reinstalls only that agent.
3. Test the agent in Claude Code by invoking it with a realistic scenario.
4. Update `context_view.md`, `quality_gate.md`, and `failure_modes.md` if behavior changed.

When adding a new agent:
1. Create a new `AgenteNN_Name/` directory following the naming convention.
2. Add a `prompt.md` with the system prompt.
3. Add the agent to the `$agents` array in `install.ps1` with the correct `Emoji`, `Name`, `Description`, and `File` fields.
4. Add at least one knowledge file.
5. Run `.\install.ps1` and `.\doctor.ps1`.

### Adding a Skill

Skills live in `Agente*/skills/skill-name-skill/`. Each skill consists of:

```
skill.md       # Skill definition and instructions
checklist.md   # Validation checklist
examples/
  good_output.md
  bad_output.md
```

After adding a skill, reference it from the agent's `prompt.md` using the skill invocation pattern already present in that agent.

### Adding a Golden Model

Golden Models live in `standards/golden-model-<archetype>.md`. Each file defines the canonical tech stack for one of the 8 project archetypes.

1. Create `standards/golden-model-<archetype>.md` following the structure of an existing Golden Model file.
2. Add a row to the archetype matrix in `standards/project-classification.md` (Gate A0).
3. Add a corresponding `DR-CLASS-NNN` decision rule to any agent `knowledge/decision_rules.md` files that need to be aware of the new archetype.
4. Update the archetype table in any relevant agent `prompt.md` files (search with `search_knowledge("archetype classification")`).
5. Run `.\update-knowledge.ps1` to reindex the new file.
6. Test with `@techlead Classifique o arquétipo deste projeto: [description that should match the new archetype]`.

### Adding a Template, Checklist, or Schema

- **Templates** — `AgenteXX_*/templates/` (agent-specific) or `templates/automation/` (automation archetype).
- **Checklists** — `AgenteXX_*/checklists/` (agent-specific) or `checklists/automation/` (automation archetype).
- **Schemas** — `AgenteXX_*/schemas/` following the `snake_case.schema.json` naming convention; use JSON Schema draft-07.

After adding any of these:
1. Run `.\update-knowledge.ps1` to ingest the new file.
2. Verify it appears in search: `search_knowledge("<keyword from the file>")`.
3. Reference it from the relevant skill's `skill.md` or from the agent's `skills_manifest.md`.

### Updating source_map.json

`source_map.json` (inside each agent's `knowledge/` folder) records the mapping from build-time source material to distilled artifacts. Update it whenever you:

- Add a new knowledge file that was derived from a specific book, article, or course module.
- Modify an existing knowledge file to incorporate a new source.

Format:
```json
{
  "sources": [
    {
      "source_id": "unique-id",
      "title": "Book or Article Title",
      "type": "book | article | course | playbook",
      "distilled_into": ["knowledge/principles.md", "knowledge/decision_rules.md"]
    }
  ]
}
```

### Using the Standard Knowledge Distillation Prompt

When adding new knowledge sources (books, course modules, articles, playbooks), use the standard distillation workflow instead of editing knowledge files manually.

1. Open `context/prompts/prompt_padrao_destilacao_conhecimento.md`.
2. Copy its contents into a new Claude Code or Roo Code session.
3. In the "Fontes novas a processar" section, list the paths or descriptions of your new sources.
4. Run the prompt — it guides the AI through 27 distillation steps covering all artifact types.
5. After the session completes, run `.\install.ps1` to propagate the changes.

The distillation prompt enforces copyright policy (no verbatim reproduction), updates `source_map.json`, and generates a build report in `build/`.

### Fixing a Bug

1. Reproduce the bug using `.\doctor.ps1` or `.\test-mcp.ps1`.
2. Fix the root cause — do not work around safety checks.
3. Verify the fix with both scripts.
4. Add a note to `CHANGELOG.md` under `[Unreleased]`.

### Improving Documentation

All `.md` files in `docs/`, agent prompts, knowledge files, templates, checklists, examples, and playbooks are licensed under CC BY 4.0. You may improve, translate, or extend them freely.

For corrections to code or scripts (`*.ps1`, `*.py`, `*.json`), the Apache 2.0 license applies.

---

## Antes de abrir PR

Run through this checklist before opening a pull request:

- [ ] Rodei `python tools/factory-validators/run_all.py` (0 failures)
- [ ] Rodei `python -m pytest tools/mcp-knowledge-search/tests/` (39 passed), se editei database.py ou server.py
- [ ] Rodei `.\doctor.ps1`, se disponível
- [ ] Rodei `.\test-mcp.ps1`, se disponível
- [ ] Rodei `.\install.ps1`, quando aplicável (sempre que `prompt.md` ou `knowledge/` mudou)
- [ ] Atualizei docs quando necessário
- [ ] Atualizei `source_map.json` quando adicionei conhecimento
- [ ] Não incluí secrets
- [ ] Não copiei conteúdo protegido de terceiros (verbatim)
- [ ] Respeitei Apache-2.0 para código e CC BY 4.0 para conteúdo
- [ ] `CHANGELOG.md` atualizado em `[Unreleased]`
- [ ] Se prompt foi alterado, agente foi testado com cenário realista

---

## Licensing Policy

This project uses a dual-license model:

| File type | License |
|---|---|
| Code, scripts, tooling (`*.ps1`, `*.py`, `*.sh`, `*.js`, `*.ts`) | Apache 2.0 |
| Docs, prompts, templates, knowledge, examples, checklists (`*.md` in doc paths) | CC BY 4.0 |

By submitting a contribution, you agree that:
1. Your code contributions are licensed under Apache 2.0.
2. Your documentation/prompt contributions are licensed under CC BY 4.0.
3. You have the right to contribute any material you include.
4. Knowledge files represent original synthesis, not verbatim reproduction of third-party copyrighted works.

See `LICENSE`, `LICENSE-DOCS`, and `NOTICE` for full details.
