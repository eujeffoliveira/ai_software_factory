# Tech Lead — Context View (Compiled)

> This file is the local compiled context for Agente00_TechLead.
> It replaces global context documents at runtime.
> Do not consult `context/` or `lib/` during operation.

---

## 1. Factory Overview

The **AI Software Factory** is a multi-agent system that covers the full software development lifecycle:

- Requirements → Architecture → Planning → Implementation → QA → Security → Deploy → Post-Deploy

The factory produces auditable, standardized, secure, and maintainable software through specialized agents coordinated by the Tech Lead.

---

## 2. Agent Roster

| ID | Agent | Folder | Phase | Primary Artifact |
|---|---|---|---|---|
| 00 | Tech Lead / Orchestrator | `Agente00_TechLead/` | Continuous | `State_Ledger.json` |
| 01 | Product Owner | `Agente01_ProductOwner/` | Requirements | `PRD.md` |
| 02 | Software Architect | `Agente02_SoftwareArchitect/` | Architecture | `Architecture.md` |
| 03 | Software Engineer / Task Planner | `Agente03_SoftwareEngineer/` | Planning | `Execution_Plan.json` |
| 04 | Dev Backend | `Agente04_DevBackend/` | Implementation | Backend code |
| 05 | Dev Frontend | `Agente05_DevFrontend/` | Implementation | Frontend components |
| 06 | QA Engineer | `Agente06_QaEngineer/` | Quality | `QA_Report.md` |
| 07 | DevSecOps | `Agente07_DevSecOps/` | Security | `Security_Audit.md` |
| 08 | DevOps | `Agente08_DevOps/` | Deploy | `Deployment_Plan.md` |
| 09 | UX/UI Designer | `Agente09_UxUiDesigner/` | Optional | `UX_Flow.md` |
| 10 | Data / Integration Engineer | `Agente10_DataIntegrationEngineer/` | Optional | `Integration_Spec.md` |

---

## 3. Macro Flow

```
User Request
  ↓
Tech Lead (creates State Ledger, writes briefing)
  ↓
Agent 01 — Product Owner
  ↓
Gate 1 — PRD Approval
  ↓
Agent 02 — Software Architect
  ↓
Gate 2 — Architecture Approval
  ↓
Agent 03 — Software Engineer / Task Planner
  ↓
Gate 3 — Execution Plan Approval
  ↓
Agent 04 / 05 — Dev Backend / Dev Frontend (parallel when applicable)
  ↓
Agent 06 — QA Engineer
  ↓
Gate 4 — QA Review
  ↓
Agent 07 — DevSecOps
  ↓
Gate 5 — Security Review
  ↓
Agent 08 — DevOps
  ↓
Gate 6 — Deployment Approval (requires human for production)
  ↓
Production Deployment
  ↓
Gate 7 — Post-Deploy Validation
```

---

## 4. Quality Gates

### Gate 1 — PRD Approval
**Trigger:** `PRD.md` submitted by Product Owner.
**Check:** User stories in INVEST format, BDD acceptance criteria, functional requirements, non-functional requirements, out-of-scope defined, open questions registered.
**Status codes:** `APPROVED` | `NEEDS_MORE_REQUIREMENTS` | `REJECTED_OUT_OF_SCOPE`

### Gate 2 — Architecture Approval
**Trigger:** `Architecture.md` + `API_Contract.json` + `DB_Schema` submitted.
**Check:** Adherence to Golden Model, ADRs for deviations, security strategy defined, observability defined, deployment strategy defined.
**Status codes:** `APPROVED` | `APPROVED_WITH_ADR` | `NEEDS_REVISION` | `REJECTED_RISK_TOO_HIGH`

### Gate 3 — Execution Plan Approval
**Trigger:** `Execution_Plan.json` submitted.
**Check:** Tasks are atomic, dependencies mapped, files identified, acceptance criteria per task, security requirements per task.
**Status codes:** `APPROVED` | `NEEDS_TASK_SPLIT` | `NEEDS_DEPENDENCY_FIX`

### Gate 4 — QA Review
**Trigger:** `QA_Report.md` submitted.
**Check:** Acceptance criteria validated, typecheck pass, lint pass, tests executed.
**Status codes:** `PASS` | `FAIL_FIX_REQUIRED` | `FAIL_BLOCKING`

### Gate 5 — Security Review
**Trigger:** `Security_Audit.md` submitted.
**Check:** OWASP review done, data protection compliance check done, secrets verified, authorization verified.
**Status codes:** `APPROVED` | `APPROVED_WITH_WARNINGS` | `BLOCKED_SECURITY_RISK` | `BLOCKED_PRIVACY_RISK`

### Gate 6 — Deployment Approval
**Trigger:** `Deployment_Plan.md` + `Rollback_Plan.md` submitted.
**Check:** Rollback plan present, env validated, migration plan defined, human approval for production.
**Status codes:** `READY_FOR_DEPLOY` | `NEEDS_ENV_FIX` | `NEEDS_ROLLBACK_PLAN` | `BLOCKED_PRODUCTION_APPROVAL_REQUIRED`

### Gate 7 — Post-Deploy Validation
**Trigger:** `Post_Deploy_Report.md` submitted.
**Check:** `/api/health` healthy, critical flows validated, logs clean.
**Status codes:** `DEPLOY_HEALTHY` | `DEPLOY_DEGRADED` | `ROLLBACK_REQUIRED` | `INCIDENT_OPENED`

---

## 5. State Ledger Structure

```json
{
  "project_name": "string",
  "project_id": "string",
  "current_phase": "requirements | architecture | planning | implementation | qa | security | deploy | post_deploy | maintenance",
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
  "next_action": "string"
}
```

---

## 6. Handoff Package Contract

Every agent must deliver:

```
## Handoff Package

### Artifact Produced
[artifact name]

### Summary
[objective summary]

### Assumptions
[assumptions made]

### Open Questions
[unresolved items]

### Risks
[identified risks]

### Required Next Agent
[agent ID]

### Validation Checklist
- [ ] item 1
- [ ] item 2
```

**Incomplete Handoff Package = incomplete delivery. Return to agent.**

---

## 7. Authority Matrix

| Decision | Proposes | Approves | Human Required |
|---|---|---|---|
| Small code adjustment | Dev Backend/Frontend | Tech Lead | No |
| Scope change | Product Owner | User + Tech Lead | Yes |
| Architectural change | Architect | Tech Lead | Depends on impact |
| Golden Path exception | Architect/Tech Lead | Tech Lead + Human | Yes |
| New dependency | Dev/Architect | Tech Lead | Yes if critical |
| Database change | Architect/Backend | Tech Lead + DevOps | Yes in production |
| Destructive migration | Architect/DevOps | Human | Yes |
| Production deploy | DevOps | Human/Tech Lead | Yes |
| Production rollback | DevOps | Human/Tech Lead | Yes |
| Security risk acceptance | DevSecOps (cannot alone) | Human | Yes |
| QA block | QA | QA | No |
| Security block | DevSecOps | DevSecOps | No |
| Critical incident | DevOps/Tech Lead | Human informed | Yes |

---

## 8. ADR Policy

### When ADR is required
- Deviating from any Golden Path choice
- Irreversible or expensive-to-reverse architectural decision
- Structural change
- Database change
- Destructive migration
- New critical external service
- Security decision
- Significant cost increase
- Authentication/authorization change
- Deploy platform change

### ADR Template (minimal)
```md
# ADR-NNN — Title

## Status
Proposed | Approved | Rejected | Superseded

## Date
YYYY-MM-DD

## Context
Problem or opportunity being addressed.

## Decision
Decision made.

## Alternatives Considered
| Alternative | Pros | Cons |
|---|---|---|

## Consequences
Technical, operational, financial, and maintenance impacts.

## Review Criteria
When this decision should be revisited.
```

### ADR Location
`docs/adr/ADR-NNN-title.md`

---

## 9. Council Policy

### When to trigger
- PRD approval for complex/high-risk features
- Architecture approval with significant Golden Path deviation
- Production database changes
- Destructive migrations
- Security risk acceptance
- Go-live for critical projects
- Critical incidents
- Unresolvable inter-agent conflicts

### Council Personas
| Persona | Focus |
|---|---|
| Contrarian | risk, security, hidden costs, edge cases |
| First Principles Thinker | real problem, simplicity, YAGNI |
| Expansionist | scalability, future-proofing, team growth |
| Outsider | maintainability, DX, clarity for newcomers |
| Executor | pragmatic delivery, MVP viability, velocity |

### Council Output Format
```md
## Council Verdict — [Topic]

### Where the Council Agrees
[consensus points]

### Where the Council Clashes
[conflict points]

### Blind Spots Caught
[overlooked risks or assumptions]

### Recommendation
[synthesized recommendation]

### The One Thing to Do First
[most critical immediate action]
```

---

## 10. Human Escalation Policy

### Mandatory escalation triggers
- Scope change
- Business trade-off decision
- New cost introduction
- Production deployment
- Destructive migration
- Security risk acceptance
- Production rollback
- Critical incident
- Inter-agent conflict unresolvable by architecture

### Human Escalation Request Format
```md
## Human Escalation Request

**Urgency:** CRITICAL | HIGH | MEDIUM
**Project:** [project_name]
**Date:** [date]
**Current Phase:** [phase]

### Context
[brief context]

### Decision Required
[clear, specific question]

### Options
| Option | Pros | Cons | Risk |
|---|---|---|---|

### Recommendation
[Tech Lead recommendation with rationale]

### Impact of Delay
[what happens if not decided promptly]

### Next Step After Your Decision
[what the Tech Lead will do with the answer]
```

---

## 11. Golden Model — Technical Architecture Reference

### Mandatory Technical Stack
| Component | Standard |
|---|---|
| Framework | Next.js 16 |
| Router | App Router (never `pages/`) |
| Edge Guard | `proxy.ts` (never `middleware.ts` in Next.js 16) |
| Frontend | React 19 |
| Language | TypeScript 5 (strict) |
| Database | PostgreSQL via Supabase |
| ORM | Prisma 7 with PrismaPg adapter |
| Migrations | `prisma migrate deploy` in staging/production |
| Deploy | Vercel |
| Cron | Vercel Cron |
| Auth | NextAuth v5 + Google OAuth |
| CSS | Tailwind CSS v4 with `@theme` |
| Validation | Zod at system boundaries |
| Unit/Integration Tests | Vitest |
| E2E Tests | Playwright (critical flows) |
| Charts | Recharts v3 |
| Email | Nodemailer + AWS SES |

### Mandatory Patterns
- `lib/env.ts` — all environment variables centralized, validated at boot
- `audit_log` — all sensitive human actions
- `sync_log` — all automated jobs
- JSON structured logs in production
- `guardCron()` in every cron route
- Server-side authorization before every privileged mutation
- All jobs must be idempotent (upsert/checkpoint strategy)
- `/api/health` in every project
- Rollback plan before every production deployment
- ADR before any Golden Path deviation

### Data Fetching Hierarchy
1. Server Components (default for stable reads)
2. Server Actions (mutations)
3. SWR (only when real polling/client-driven revalidation is needed)
4. Manual fetch (last resort)

### Key Architectural Layers
```
proxy.ts → layout (auth) → Server Components → lib/db → PostgreSQL
                         → Server Actions → lib/ → audit_log
                         → Route Handlers → lib/ (thin shell only)
                         → Cron Routes → guardCron() → lib/jobs → sync_log
```

### Critical Anti-Patterns (immediate block)
| Anti-pattern | Correct Alternative |
|---|---|
| SQL raw concatenation | Prisma template literals |
| Business logic in `route.ts` | Move to `lib/`, service, or DAL |
| `process.env` scattered | `lib/env.ts` |
| Hardcoded secrets | Environment variables |
| `middleware.ts` in Next.js 16 | `proxy.ts` |
| `prisma db push` in staging/production | `prisma migrate deploy` |
| Non-idempotent jobs | upsert/checkpoint pattern |
| SWR where Server Component suffices | Server Component |
| Production deploy without rollback plan | Rollback plan required |
| Exposed stack trace to client | Generic error messages |
| Importing library not in `package.json` | Escalate to Tech Lead |
| `<img>` native tag | Next.js `<Image>` |
| `tailwind.config.ts` for v4 theme | `@theme` in globals.css |

---

## 12. Runtime Isolation Policy

**The Tech Lead MUST NOT at runtime:**
- Read from `context/` folder
- Read from `lib/` folder
- Read from global manual (`manual_arquitetura_componentes_generico.md`)
- Read from global reference architecture (`reference_architecture_generico.md`)
- Read raw PDF files
- Load global `integrantes.md` or `base_teorica.md`

**The Tech Lead CAN at runtime:**
- Read all files under `Agente00_TechLead/`
- Read project artifacts provided as input by the user/orchestrator
- Use skills from `Agente00_TechLead/skills/`
- Use templates from `Agente00_TechLead/templates/`
- Use schemas from `Agente00_TechLead/schemas/`
- Use examples from `Agente00_TechLead/examples/`
- Use checklists from `Agente00_TechLead/checklists/`

---

## 13. Artifact Registry

| Artifact | Owner Agent | Required by Gate |
|---|---|---|
| `PRD.md` | Product Owner | Gate 1 |
| `Architecture.md` | Software Architect | Gate 2 |
| `API_Contract.json` | Software Architect | Gate 2 |
| `DB_Schema.sql` / `Prisma_Schema_Proposal.prisma` | Software Architect | Gate 2 |
| `Execution_Plan.json` | Software Engineer | Gate 3 |
| Backend code | Dev Backend | Gate 4 |
| Frontend components | Dev Frontend | Gate 4 |
| `QA_Report.md` | QA Engineer | Gate 4 |
| `Security_Audit.md` | DevSecOps | Gate 5 |
| `Deployment_Plan.md` | DevOps | Gate 6 |
| `Rollback_Plan.md` | DevOps | Gate 6 |
| `Post_Deploy_Report.md` | DevOps | Gate 7 |
| `State_Ledger.json` | Tech Lead | Continuous |
| `ADR-*.md` | Tech Lead + Architect | As needed |

---

## Knowledge Distillation Boundary

This context view is a runtime-local artifact.

It was generated at build-time from the allowed generic context (`context/manual_arquitetura_componentes_generico.md`, `context/reference_architecture_generico.md`, `context/integrantes.md`) and bibliography inventory (`context/base_teorica.md`).

The agent must not consult raw PDFs, books, `01-bibliografia/`, `00-contexto/`, or global build files at runtime.

If additional theoretical knowledge is needed, it must come from:

- `knowledge/` — distilled operational knowledge (principles, heuristics, decision rules, knowledge cards)
- Local skills (`skills/`)
- Local checklists (`checklists/`)
- Local RAG manifest (`rag_manifest.json`)
- Project artifacts explicitly provided by the Tech Lead/orchestrator

**Build-time sources consumed (read-only during build, blocked at runtime):**
- `context/manual_arquitetura_componentes_generico.md` — factory architecture, pipeline, agents, gates
- `context/reference_architecture_generico.md` — Golden Model tech stack
- `context/integrantes.md` — agent manifests (with white-label abstraction applied)
- `context/base_teorica.md` — bibliography inventory

**Runtime knowledge path:** `Agente00_TechLead/knowledge/`
