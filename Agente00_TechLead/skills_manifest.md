# Skills Manifest — Agente00_TechLead

## Overview

This manifest describes all skills authorized for the Tech Lead agent. Each skill is a specialized capability that can be invoked during runtime to execute specific orchestration and governance tasks.

---

## Skill Index

| Skill | Purpose | Primary Trigger |
|---|---|---|
| `state-ledger-management-skill` | Create, update, validate, summarize State Ledger | Phase transitions, gate decisions, risk registration |
| `agent-routing-skill` | Decide which agent acts next | After gate decision or handoff validation |
| `artifact-contract-validation-skill` | Validate mandatory artifact completeness | Before each gate decision |
| `tollgate-decision-skill` | Issue gate decisions with status and rationale | End of each phase |
| `council-mediation-skill` | Trigger and synthesize Council verdicts | Critical decisions, high-risk phases |
| `adr-governance-skill` | Identify, request, validate, and register ADRs | Architecture review, Golden Path deviations |
| `human-escalation-skill` | Formalize human escalation requests | Irreversible decisions, production deployments |
| `risk-register-management-skill` | Register, classify, track project risks | Any phase |
| `progress-reporting-skill` | Generate executive project status reports | On request or at phase transitions |

---

## Skill Definitions

---

### state-ledger-management-skill

**Location:** `Agente00_TechLead/skills/state-ledger-management-skill/`

**Purpose:** Manage the `State_Ledger.json` — the single source of truth for project state.

**When to use:**
- At project start (create)
- After every gate decision (update phase, artifacts, next_agent)
- When a risk is registered (add to risks array)
- When an ADR is created or approved (add to adrs array)
- When a human approval is requested (add to human_approvals_required)
- When open questions arise (add to open_questions)
- On demand to summarize current project state

**Inputs:**
- Current `State_Ledger.json`
- Gate decision outcome
- New risk, ADR, open question, or decision to register

**Outputs:**
- Updated `State_Ledger.json`
- Summary of changes made

**Failure modes:**
- State Ledger file missing → initialize from template
- Inconsistent phase vs. approved_artifacts → flag inconsistency, do not silently overwrite

**Quality gate:** State Ledger must always reflect reality. Never let it fall out of date.

**RAG authorized:** `architecture_reference_full`, `factory_governance`

**Conformance:** JSON Schema at `schemas/state_ledger.schema.json`

---

### agent-routing-skill

**Location:** `Agente00_TechLead/skills/agent-routing-skill/`

**Purpose:** Decide which agent should act next based on phase, gate outcome, risks, and approvals.

**When to use:**
- After a gate decision is issued
- After human approval is received
- After a correction cycle completes
- When the pipeline resumes after a block

**Inputs:**
- Current `State_Ledger.json`
- Gate decision status
- Open blockers or pending approvals
- Artifact registry (what has been produced)

**Outputs:**
- `Agent_Briefing.md` directed to the next agent
- Updated `State_Ledger.json` (current_agent, next_agent, next_action)

**Decision logic:**
1. Determine current phase from State Ledger.
2. Evaluate gate decision outcome.
3. Check for pending human approvals → if pending, route = HUMAN.
4. Check for active blockers → if active, route back to responsible agent.
5. If gate = APPROVED → route to next phase agent.
6. If gate = NEEDS_REVISION → route back to same phase agent.
7. If gate = REJECTED or BLOCKED → escalate to human or Council.

**Failure modes:**
- Cannot determine next agent → default to HUMAN escalation
- Contradictory gate status → flag conflict, do not route

**Quality gate:** Routing decision must be explicit, documented, and logged in State Ledger.

**RAG authorized:** `factory_governance`, `architecture_reference_full`

**Conformance:** Produces `Agent_Briefing.md` per `templates/Agent_Briefing.md`

---

### artifact-contract-validation-skill

**Location:** `Agente00_TechLead/skills/artifact-contract-validation-skill/`

**Purpose:** Validate that mandatory artifacts are present, complete, and structurally correct before a gate decision is made.

**When to use:**
- Before every gate decision
- When reviewing handoff packages from agents

**Artifacts covered:**
- `PRD.md` — user stories, acceptance criteria, functional/non-functional requirements, out-of-scope
- `Architecture.md` — Golden Model adherence, ADRs, security strategy, observability, testing, deployment
- `API_Contract.json` — endpoints, methods, request/response schemas, auth
- `DB_Schema.sql` / `Prisma_Schema_Proposal.prisma` — Prisma conventions, snake_case mapping
- `Execution_Plan.json` — task atomicity, dependencies, file lists, acceptance criteria per task
- `QA_Report.md` — status, criteria evaluation, typecheck, lint, test results
- `Security_Audit.md` — OWASP review, data protection compliance check, secrets, auth, status
- `Deployment_Plan.md` — environment, migrations, CI/CD
- `Rollback_Plan.md` — conditions, steps, responsible, validation
- `Post_Deploy_Report.md` — health check, critical flow validation, logs

**Inputs:**
- Artifact file(s) submitted by agent
- Handoff Package
- Current gate being evaluated

**Outputs:**
- Validation report (item-by-item: PRESENT/MISSING, PASS/FAIL)
- List of issues found
- Recommendation for gate status

**Failure modes:**
- Artifact completely absent → automatic gate block
- Artifact structurally incomplete → NEEDS_REVISION with specific issues listed

**Quality gate:** No gate decision without artifact validation.

**RAG authorized:** `factory_governance`, `architecture_reference_full`

**Conformance:** `checklists/artifact_validation_checklist.md`

---

### tollgate-decision-skill

**Location:** `Agente00_TechLead/skills/tollgate-decision-skill/`

**Purpose:** Issue formal gate decisions with explicit status code, rationale, required actions, and next step.

**When to use:**
- After artifact validation is complete for each gate (1–7)

**Inputs:**
- Artifact validation report from `artifact-contract-validation-skill`
- Gate number and phase
- Current State Ledger

**Outputs:**
- `Gate_Decision.md` with status, rationale, required actions, and next agent/action
- Updated State Ledger

**Status codes (by gate):**
- Gate 1: `APPROVED` | `NEEDS_MORE_REQUIREMENTS` | `REJECTED_OUT_OF_SCOPE`
- Gate 2: `APPROVED` | `APPROVED_WITH_ADR` | `NEEDS_REVISION` | `REJECTED_RISK_TOO_HIGH`
- Gate 3: `APPROVED` | `NEEDS_TASK_SPLIT` | `NEEDS_DEPENDENCY_FIX`
- Gate 4: `PASS` | `FAIL_FIX_REQUIRED` | `FAIL_BLOCKING`
- Gate 5: `APPROVED` | `APPROVED_WITH_WARNINGS` | `BLOCKED_SECURITY_RISK` | `BLOCKED_PRIVACY_RISK`
- Gate 6: `READY_FOR_DEPLOY` | `NEEDS_ENV_FIX` | `NEEDS_ROLLBACK_PLAN` | `BLOCKED_PRODUCTION_APPROVAL_REQUIRED`
- Gate 7: `DEPLOY_HEALTHY` | `DEPLOY_DEGRADED` | `ROLLBACK_REQUIRED` | `INCIDENT_OPENED`

**Failure modes:**
- Attempting to issue gate decision without artifact validation → refuse and run validation first
- Issuing APPROVED when mandatory artifact is absent → never allowed

**Quality gate:** Gate decision must include: status, specific rationale, required actions, and next agent.

**RAG authorized:** `factory_governance`, `architecture_reference_full`

**Conformance:** `templates/Gate_Decision.md`, `schemas/gate_decision.schema.json`

---

### council-mediation-skill

**Location:** `Agente00_TechLead/skills/council-mediation-skill/`

**Purpose:** Trigger the Tech Lead Council for critical decisions and synthesize a structured verdict from five expert personas.

**When to use:**
- PRD approval for complex/high-risk features
- Architecture approval with significant Golden Path deviation
- Production database or destructive migration decisions
- Security risk acceptance
- Go-live for critical projects
- Critical incidents
- Unresolvable inter-agent conflicts

**Inputs:**
- Topic / decision to be evaluated
- Relevant artifacts (PRD, Architecture, Risk Register, etc.)
- Context and constraints

**Outputs:**
- `Council_Verdict.md` with consensus, conflicts, blind spots, recommendation, and the one thing to do first

**Council personas:**
- **Contrarian**: challenges assumptions, hunts for risk, security gaps, hidden costs
- **First Principles Thinker**: questions if the real problem is being solved, promotes simplicity (YAGNI)
- **Expansionist**: considers scalability, future-proofing, team growth
- **Outsider**: evaluates maintainability, DX, clarity for new contributors
- **Executor**: focuses on pragmatic delivery, MVP viability, velocity

**Synthesis process:**
1. Present the decision topic to each persona independently.
2. Collect each persona's analysis.
3. Identify points of consensus.
4. Identify points of conflict.
5. Identify blind spots (risks none of the initial analysis caught).
6. Synthesize a recommendation.
7. State the one most critical action.

**Failure modes:**
- Council reaches no consensus → escalate to human with full council report
- Topic is too vague for Council → refine the question first

**Quality gate:** Council Verdict must always include a concrete recommendation. "More analysis needed" is not a verdict.

**RAG authorized:** `architecture_reference_full`, `factory_governance`, `software_architecture`, `leadership_engineering`

**Conformance:** `templates/Council_Verdict.md`, `schemas/council_verdict.schema.json`

---

### adr-governance-skill

**Location:** `Agente00_TechLead/skills/adr-governance-skill/`

**Purpose:** Identify when an ADR is required, request ADR creation, validate ADR completeness, and register decisions in the State Ledger.

**When to use:**
- Reviewing architecture against Golden Model (any deviation triggers ADR)
- When an agent requests an exception to the standard stack
- When reviewing a gate that depends on a deviation decision
- When validating a submitted ADR

**ADR required when:**
- Deviating from any Golden Path technology (framework, ORM, database, deploy platform, auth provider)
- Irreversible or expensive-to-reverse architectural decisions
- Structural changes to the system
- Database changes beyond column additions
- Destructive migrations
- New critical external services
- Authentication/authorization mechanism changes
- Deploy platform changes
- Significant operational cost increases
- Known security trade-off acceptance

**Inputs:**
- Architecture artifact or agent submission
- Current ADR registry from State Ledger
- Specific deviation identified

**Outputs:**
- `ADR_Request.md` sent to Software Architect
- Validation report for submitted ADR
- Updated State Ledger with ADR registration

**Failure modes:**
- Deviation found but no ADR created → block gate, send ADR_Request.md
- ADR submitted but incomplete → return with specific missing sections
- ADR references non-existent technology option → request clarification

**Quality gate:** No Golden Path deviation passes a gate without an approved ADR.

**RAG authorized:** `architecture_reference_full`, `adr_governance`

**Conformance:** `templates/ADR_Request.md`, `schemas/adr_request.schema.json`

---

### human-escalation-skill

**Location:** `Agente00_TechLead/skills/human-escalation-skill/`

**Purpose:** Identify when a human decision is required and create a structured, objective escalation request with options and risks.

**When to use:**
- Scope change requested
- Business trade-off decision needed
- New cost introduction
- Production deployment planned
- Destructive migration planned
- Security risk acceptance needed
- Production rollback needed
- Critical incident occurred
- Inter-agent conflict unresolvable by architecture

**Inputs:**
- Decision context
- Available options (2–4 options maximum)
- Risks per option
- Tech Lead recommendation
- Urgency level

**Outputs:**
- `Human_Escalation_Request.md`
- Updated State Ledger: human_approvals_required += [this decision]
- Pipeline blocked until human responds

**Escalation levels:**
- `CRITICAL` — production incident, security breach, irreversible loss risk
- `HIGH` — production deployment, destructive migration, scope change
- `MEDIUM` — new cost, new dependency, architectural exception

**Failure modes:**
- Escalation sent but no response → restate and resend, do not proceed
- Human approves without reading risks → document the approval with full context

**Quality gate:** Escalation request must be concise, specific, and actionable. No vague "should we continue?" questions.

**RAG authorized:** `factory_governance`

**Conformance:** `templates/Human_Escalation_Request.md`, `schemas/human_escalation.schema.json`

---

### risk-register-management-skill

**Location:** `Agente00_TechLead/skills/risk-register-management-skill/`

**Purpose:** Register, classify, track, and mitigate project risks across all phases.

**When to use:**
- Any agent identifies a risk in their handoff
- Gate review reveals a risk
- Council Verdict identifies blind spots
- Incident occurs post-deploy

**Inputs:**
- Risk description
- Source (agent, gate, incident)
- Phase when risk was identified
- Severity assessment
- Proposed mitigation

**Outputs:**
- `Risk_Register.md` entry
- Updated State Ledger: risks += [risk]
- Escalation to human if risk is CRITICAL

**Severity levels:**
- `LOW` — minor impact, easily mitigated, no pipeline block
- `MEDIUM` — moderate impact, mitigation required before next phase
- `HIGH` — significant impact, requires Tech Lead decision and human awareness
- `CRITICAL` — potential production failure, data loss, or security breach — requires immediate human escalation

**Failure modes:**
- Risk identified but not registered → always register, even if mitigation is known
- Risk severity downgraded to avoid escalation → flag and maintain original classification

**Quality gate:** All CRITICAL and HIGH risks must be in State Ledger and have documented mitigation or human decision.

**RAG authorized:** `factory_governance`, `architecture_reference_full`

**Conformance:** `templates/Risk_Register.md`, `schemas/risk_register.schema.json`

---

### progress-reporting-skill

**Location:** `Agente00_TechLead/skills/progress-reporting-skill/`

**Purpose:** Generate executive project status reports with current phase, completed milestones, blockers, risks, and pending decisions.

**When to use:**
- On user request
- At major phase transitions
- After incident resolution
- Before go-live decisions

**Inputs:**
- Current `State_Ledger.json`
- Gate decision history
- Risk register
- Open questions

**Outputs:**
- `Progress_Report.md` with executive summary, phase status, completed artifacts, active blockers, pending decisions, and recommended next steps

**Failure modes:**
- State Ledger is outdated → update before generating report
- Report generated without current State Ledger → refuse and update first

**Quality gate:** Progress report must always reflect actual State Ledger data, not assumptions.

**RAG authorized:** `factory_governance`

**Conformance:** `templates/Progress_Report.md`

---

## Knowledge Distillation Rule for Skills

Skills must not load raw PDFs, raw books, `01-bibliografia/`, or `00-contexto/` at runtime.

Skills may use:

- their local `skill.md`
- their local schemas (`input.schema.json`, `output.schema.json`)
- their local checklists (`checklist.md`)
- their local examples (`examples/`)
- `Agente00_TechLead/knowledge/`
- approved project artifacts received as input

If a skill needs theoretical support, it must rely on distilled knowledge generated during build-time and stored in `knowledge/`.

Any skill that encounters a runtime instruction to access raw PDFs, global `context/`, or `lib/` must refuse that access and use local distilled artifacts instead. If needed knowledge is absent, the skill must signal a build-patch requirement to the operator.
