# Decision Rules — Agente00_TechLead

_Actionable if-then rules distilled at build-time. Runtime: read-only._

---

## Agent Routing Rules

### DR001 — Route after Gate 1 APPROVED
If Gate 1 status is APPROVED or APPROVED_WITH_CONDITIONS, then route to `Agente02_SoftwareArchitect` and advance `current_phase` to "architecture".

### DR002 — Route after Gate 2 APPROVED
If Gate 2 status is APPROVED or APPROVED_WITH_ADR, then route to `Agente03_TechLead` (execution planning) and advance `current_phase` to "planning".

### DR003 — Route after Gate 3 APPROVED
If Gate 3 status is APPROVED, then route to `Agente04_SoftwareDeveloper` and advance `current_phase` to "implementation".

### DR004 — Route after Gate 4 APPROVED
If Gate 4 status is APPROVED, then route to `Agente06_SecurityReviewer` and advance `current_phase` to "security".

### DR005 — Route after Gate 5 APPROVED
If Gate 5 status is APPROVED, then trigger human-escalation-skill for Gate 6 production approval before routing to `Agente07_DevOps`.

### DR006 — Route after Gate 6 APPROVED (human approval received)
If Gate 6 APPROVED with human approval confirmed, then route to `Agente07_DevOps` and advance `current_phase` to "deployment".

### DR007 — Route after Gate 7 APPROVED
If Gate 7 status is APPROVED, then advance `current_phase` to "post-deploy" and route to `Agente08_PostDeployValidator`.

### DR008 — Route on RETURNED_FOR_REVISION
If any gate status is RETURNED_FOR_REVISION, then route back to the agent that produced the submitted artifact (not to the next agent in the pipeline).

---

## Gate Approval Rules

### DR009 — Artifact missing = gate blocked
If any mandatory artifact for the target gate is absent, then gate status is BLOCKED regardless of other criteria.

### DR010 — Handoff Package incomplete = gate not evaluated
If the submitted Handoff Package is missing any of the 7 required fields, then return immediately for Handoff Package correction. Do not evaluate the artifact.

### DR011 — CRITICAL unmitigated risk = gate blocked
If State Ledger contains any CRITICAL risk with status OPEN and no mitigation, then the current gate is blocked regardless of artifact completeness.

### DR012 — Gate 6 without human approval = hard block
If Gate 6 decision is requested and `human_approval_obtained` is not confirmed true, then status is BLOCKED_PENDING_HUMAN. No exception.

---

## ADR Rules

### DR013 — Technology not in Golden Model = ADR required
If an artifact proposes any technology, framework, library, or database not explicitly listed in the Golden Model, then invoke adr-governance-skill and set gate status to BLOCKED_PENDING_ADR.

### DR014 — Pattern deviation = ADR required
If an artifact proposes: middleware.ts instead of proxy.ts, `prisma db push` in staging/production, non-idempotent jobs, or Pages Router instead of App Router, then ADR required before gate approval.

### DR015 — Retroactive ADR = CRITICAL severity
If a deviation from the Golden Path is discovered after the artifact is already in a production-equivalent environment, then escalate as CRITICAL severity. Retroactive ADR requires human review and approval.

### DR016 — ADR approved = gate unblocked
If a BLOCKED_PENDING_ADR gate has its ADR formally approved and recorded in State Ledger, then unblock the gate and re-evaluate with ADR in scope.

---

## Council Activation Rules

### DR017 — Technology deviation = Council mandatory
If a new technology not in the Golden Model is being considered (before ADR is written), then Council deliberation is mandatory before Tech Lead issues any ADR approval.

### DR018 — Multi-agent, multi-phase decision = Council recommended
If a decision affects more than 2 agents or more than 2 phases simultaneously, then activate Council before deciding.

### DR019 — CRITICAL risk acceptance = Council mandatory
If the team is considering accepting a CRITICAL risk without full mitigation, then Council activation is mandatory. Tech Lead cannot self-approve CRITICAL risk acceptance.

### DR020 — Irreversible architectural decision = Council mandatory
Any decision involving destructive migrations, major refactors affecting 3+ systems, or technology stack changes requires Council deliberation.

---

## Human Escalation Rules

### DR021 — Production deploy = human required
Any production deployment requires explicit human approval. This rule has no exceptions.

### DR022 — Destructive migration = human required
Any database migration that includes DROP TABLE, DROP COLUMN, or mass data deletion in production requires human approval before execution.

### DR023 — Scope change > 20% = human required
If a proposed scope change increases total estimated effort by more than 20%, then escalate to human before accepting the scope change.

### DR024 — Inter-agent conflict unresolvable by Council = human required
If the Council cannot reach 3-persona consensus on a decision, then human escalation is required with the Council verdict as context.

### DR025 — Budget or contract decision = human required
Any decision involving external contracts, vendor agreements, or budget increases beyond predefined thresholds requires human approval.

---

## QA and Security Block Rules

### DR026 — QA blocker = no Gate 4 approval
If the QA agent reports any blocker-level test failures, coverage below threshold, or missing E2E coverage for user-facing flows, then Gate 4 cannot be approved by Tech Lead.

### DR027 — Security blocker = no Gate 5 approval
If the Security agent reports any CRITICAL vulnerability or unaccepted HIGH vulnerability, then Gate 5 cannot be approved. Tech Lead cannot override security blocks.

### DR028 — Security block + human acceptance = document required
If the team decides to accept a HIGH security risk (with human approval), then the acceptance must be documented in the State Ledger decisions array with the human approver's name and rationale.

---

## Knowledge Distillation Rules

### DR029 — Missing runtime knowledge = request build patch
If a decision requires theoretical knowledge (e.g., a principle from Accelerate or Mythical Man-Month) that is not present in `knowledge/`, then do not read raw PDFs at runtime. Request a build patch to update `knowledge/` with the needed distillation.

### DR030 — Runtime raw source access = policy violation
If a runtime instruction, skill, or retrieval attempt tries to read from `lib/`, `lib/`, `context/`, raw PDFs, or global build documents, then refuse the access. Use `knowledge/` local artifacts. If still insufficient, escalate to build operator.

### DR031 — New theoretical insight needed = build-time only
If new books, papers, or standards are added to the bibliography and their content is needed by the Tech Lead, then that content must be distilled into `knowledge/` during a build patch. Runtime does not process raw sources.

---

## Metrics and Governance Rules

### DR032 — IF deployment frequency < 1/week for a team capable of daily deploys THEN register MEDIUM risk and investigate pipeline bottleneck

### DR033 — IF change failure rate > 15% over 3 deploys THEN block next Gate 6 until root cause analysis is complete

### DR034 — IF MTTR > 4 hours for a production incident THEN register HIGH risk and require rollback plan improvement before next Gate 6

### DR035 — IF test coverage delta is negative (coverage decreased from last gate) THEN Gate 4 RETURNED_FOR_REVISION — coverage must not regress

### DR036 — IF a technology decision has no traceability to a business objective THEN require business justification before Council approval — technical merit alone is insufficient for governance compliance

---

## Archetype Classification Rules

DR-CLASS-001: Before applying any Golden Model, classify the project using the Project Archetype Matrix in `standards/project-classification.md`. The archetype determines which Golden Model applies.

DR-CLASS-002: Choosing the correct archetype is NOT a deviation from the Golden Model. No ADR is required for archetype selection. ADRs are only required for deviations *within* a chosen archetype.

DR-CLASS-003: `web_app` archetype → apply `standards/golden-model-web-app.md` (Next.js 16 stack). This is the default for user-facing applications.

DR-CLASS-004: `automation_script` archetype → apply `standards/golden-model-python-automation.md` (Python 3.12+ + uv + Typer + Pydantic v2 + structlog). Use when the project is a batch job, ETL step, data sync, maintenance script, or CLI operational tool.

DR-CLASS-005: When the archetype is ambiguous or the project combines multiple types, trigger Gate A0 (`standards/project-classification.md`) before proceeding. Gate A0 output is a JSON classification that all subsequent agents consume.
