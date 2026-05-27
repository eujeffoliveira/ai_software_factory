# Project Operation — AI Software Factory

How to use the factory to operate a real project from inception through deployment, with State Ledger, `.factory/` workspace, and gate tracking.

---

## Overview

The factory operates in two modes:

| Mode | When to use |
|------|-------------|
| **Simple prompt mode** | Quick questions, single-agent tasks, ad-hoc code review, one-off generation |
| **Operated project mode** | Multi-sprint projects, full SDLC flow, teams using multiple agents across sessions |

This document covers **operated project mode**. For simple prompts, no setup is needed — just `@agent prompt`.

---

## The State Ledger

The State Ledger (`State_Ledger.json`) is the Tech Lead's single source of truth for a project. It tracks:

| Field | Purpose |
|-------|---------|
| `project_archetype` | Gate A0 classification |
| `golden_model` | Which tech stack applies |
| `current_phase` | Active SDLC phase |
| `current_agent` | Agent currently responsible |
| `approved_artifacts` | Which of the 10 artifacts are approved |
| `open_questions` | Blocking and non-blocking questions |
| `decisions` | Gate decisions and rationale |
| `adrs` | Architecture Decision Records |
| `risks` | Tracked risks with severity and status |
| `gate_history` | Complete gate audit trail |
| `human_approvals_required` | Pending human decisions |
| `mcp_status` | MCP server health snapshot |
| `next_action` | Specific, actionable next step |

**Source:** `Agente00_TechLead/templates/State_Ledger.json`
**Schema:** `Agente00_TechLead/schemas/state_ledger.schema.json`
**Examples:** `Agente00_TechLead/examples/good_state_ledger.json`

---

## .factory/ Workspace

The `.factory/` directory in your project is the Tech Lead's workspace. It persists state between Claude Code sessions.

### Initialize

```powershell
cd C:\my-project
& "$env:FACTORY_ROOT\init-project.ps1"
```

This creates:

```
.factory/
├── State_Ledger.json       ← Global project state (commit this)
├── project_profile.md      ← Project brief for agents (commit this)
├── artifacts/              ← PRD.md, Architecture.md, etc.
├── decisions/              ← Gate decisions, ADR files
├── risks/                  ← Risk register entries
└── README_FACTORY.md       ← Usage instructions
```

`init-project.ps1` is **optional** and **idempotent** — existing files are never overwritten unless you use `-Force`.

### Options

```powershell
.\init-project.ps1              # safe mode: skip existing files
.\init-project.ps1 -Force       # overwrite existing (creates .bak backups)
.\init-project.ps1 -WhatIf      # dry-run: show what would be created
```

---

## Project Profile

Fill in `.factory/project_profile.md` before the first Tech Lead session. The profile contains:

- Project name, ID, organization
- Objective: problem statement + business outcome
- Project archetype + golden model (filled after Gate A0)
- Tech stack (filled after Gate 2)
- Integrations and constraints
- Sensitive data classification
- Non-functional requirements
- Responsible parties
- Environments
- Initial risks

Share the profile with the Tech Lead to initialize the State Ledger:

```
@techlead aqui está o perfil do projeto: [paste project_profile.md content]
         Por favor inicialize o State Ledger e conduza o Gate A0.
```

**Template:** `templates/project/project_profile.md`
**Schema:** `schemas/project_profile.schema.json`

---

## SDLC Flow with the Factory

### Full pipeline (8 gates)

```
Humano  → @techlead (Gate A0: classify archetype)
        → @po (Gate 1: PRD + user stories + BDD criteria)
        → @architect (Gate 2: Architecture + API contract + DB schema)
        → @engineer (Gate 3: Execution plan — atomic tasks)
        → @devbackend + @devfrontend (implementation)
        → @qa (Gate 4: tests, coverage ≥ 80%, E2E Playwright)
        → @devsecops (Gate 5: OWASP, secrets, LGPD — incontornável)
        → [Human approval required]
        → @devops (Gate 6: deploy + rollback plan)
        → @devops (Gate 7: post-deploy validation)
```

### Starting a session (resuming project)

Every new Claude Code session, start with:

```
@techlead retome o projeto [PROJECT_NAME].
Estado atual: [paste .factory/State_Ledger.json]
```

Or attach the file directly if your interface supports it.

### After a gate decision

The Tech Lead updates the State Ledger:

```
@techlead o PRD foi aprovado pelo Gate 1. Atualize o State Ledger e gere o Agent Briefing para o Architect.
```

Commit `State_Ledger.json` after each gate decision.

---

## Gates Reference

| Gate | Phase | Owner | Mandatory artifact | Status codes |
|------|-------|-------|-------------------|--------------|
| A0 | Classification | @techlead | Archetype JSON | `A0_APPROVED`, `A0_AMBIGUOUS`, `A0_BLOCKED` |
| 1 | Requirements | @po | PRD.md | `APPROVED`, `NEEDS_MORE_REQUIREMENTS`, `REJECTED_OUT_OF_SCOPE` |
| 2 | Architecture | @architect | Architecture.md + API contract + DB schema | `APPROVED`, `BLOCKED_PENDING_ADR`, `RETURNED_FOR_REVISION` |
| 3 | Planning | @engineer | Execution_Plan.json | `APPROVED`, `RETURNED_FOR_REVISION` |
| 4 | QA | @qa | QA_Report.md | `APPROVED`, `BLOCKED_CRITICAL_DEFECTS`, `RETURNED_FOR_REVISION` |
| 5 | Security | @devsecops | Security_Audit.md | `APPROVED`, `BLOCKED_CRITICAL_VULNERABILITY` — **incontornável** |
| 6 | Deploy | @devops | Deployment_Plan.md + Rollback plan | `APPROVED` — requires human approval |
| 7 | Post-deploy | @devops | Post_Deploy_Report.md | `APPROVED`, `INCIDENT_OPENED` |

**Full gate status codes (21 total):** See `Agente00_TechLead/quality_gate.md`.

---

## Risk Management

Register risks as soon as they are identified. The Tech Lead adds them to the State Ledger:

```
@techlead registre o risco: a API do ERP tem SLA de 99.5% mas nosso objetivo de disponibilidade é 99.9%. Severidade: MEDIUM.
```

Risk severity levels: `LOW`, `MEDIUM`, `HIGH`, `CRITICAL`
Risk statuses: `OPEN`, `MITIGATED`, `ACCEPTED`, `ESCALATED`, `CLOSED`

`CRITICAL` risks without mitigation block the current gate.

---

## ADR Management

Architecture deviations from the Golden Model require an ADR before Gate 2 can be approved.

**Trigger:** Architect proposes something not in the Golden Model.
**Process:**
1. @architect documents the ADR request
2. Tech Lead registers it in State Ledger (`adrs[]`)
3. Human reviews and approves/rejects
4. Gate 2 proceeds only after ADR is `Approved`

**Rule:** Selecting the correct archetype (e.g., automation_script vs web_app) is NOT a deviation and does NOT require an ADR.

---

## Human Escalation

Some decisions require human approval and cannot be delegated to any agent:

- Gate 6 deployment approval
- CRITICAL risk acceptance
- Out-of-scope feature requests
- ADR approval for major deviations
- Regulatory decisions (LGPD, GDPR, PCI)

The Tech Lead escalates via `human_approvals_required[]` in the State Ledger and pauses until a decision is recorded.

---

## Definition of Done

Per-artifact DoD criteria are in `docs/definition-of-done/`:

| Artifact | DoD file |
|----------|---------|
| PRD.md | `docs/definition-of-done/prd.md` |
| Architecture.md | `docs/definition-of-done/architecture.md` |
| Execution_Plan.json | `docs/definition-of-done/execution-plan.md` |
| QA_Report.md | `docs/definition-of-done/qa-report.md` |
| Security_Audit.md | `docs/definition-of-done/security-audit.md` |
| Deployment_Plan.md | `docs/definition-of-done/deployment-plan.md` |
| Automation_Design.md | `docs/definition-of-done/automation-design.md` |
| Runbook.md | `docs/definition-of-done/runbook.md` |
| State_Ledger.json | `docs/definition-of-done/state-ledger.md` |

---

## MCP Status in Projects

The Tech Lead records MCP status in the State Ledger when relevant:

```json
"mcp_status": {
  "server_online": true,
  "last_checked": "2026-05-22T10:00:00Z",
  "documents_indexed": 7718
}
```

If MCP is offline, agents fall back to embedded knowledge (8 files per agent). This is acceptable for short sessions but risks stale data on deep factory queries.

To check MCP status: `.\test-mcp.ps1`

---

## Worked Example

See `docs/recipes/criar-web-app.md` for a complete example of the web_app archetype flow from Gate A0 to Gate 6.

See `docs/recipes/criar-automacao-python.md` for the automation_script archetype flow.
