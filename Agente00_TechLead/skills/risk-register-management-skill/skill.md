# Risk Register Management Skill

## Purpose
Add, update, close, and summarize risks in the project risk register, ensuring all CRITICAL and HIGH risks have mitigations or escalations and that the State Ledger reflects current risk status.

## When to Use
- When an agent reports a new risk in their handoff package
- When a risk's severity or status changes
- When a CRITICAL risk has no mitigation (mandatory escalation)
- When generating a progress report
- After each gate decision (risks evolve through phases)

## Risk Categories

| Category | Description |
|----------|-------------|
| TECHNICAL | Architecture, technology, implementation risks |
| SCOPE | Scope creep, requirement changes, gold-plating |
| SCHEDULE | Timeline, dependency delays, velocity risks |
| RESOURCE | Team availability, skill gaps, turnover |
| EXTERNAL | Third-party APIs, vendors, regulatory changes |
| SECURITY | Vulnerabilities, compliance, data exposure |
| QUALITY | Test coverage, tech debt, defect density |
| OPERATIONAL | Deployment, monitoring, incident response |
| BUSINESS | Stakeholder alignment, budget, market changes |

## Risk Severity Matrix

| Severity | Definition |
|----------|-----------|
| CRITICAL | Threatens project viability or production safety |
| HIGH | Significant impact on timeline, quality, or security |
| MEDIUM | Manageable impact, needs monitoring |
| LOW | Minimal impact, informational |

## Risk Status Lifecycle
`OPEN` → `MITIGATED` → `CLOSED`
`OPEN` → `ESCALATED` → `CLOSED`
`OPEN` → `ACCEPTED` (with human approval) → `CLOSED`

## Inputs
- `operation` — ADD / UPDATE / CLOSE / SUMMARIZE
- `risk` — risk object (for ADD/UPDATE)
- `risk_id` — identifier (for UPDATE/CLOSE)
- `update_payload` — fields to change (for UPDATE)
- `current_ledger` — State Ledger with existing risks

## Outputs
- `updated_risks` — current risk register after operation
- `escalation_required` — boolean (true if CRITICAL risk has no mitigation)
- `summary` — formatted risk summary (for SUMMARIZE operation)
- `state_ledger_update` — risks array update payload

## Risk ID Format
`RISK-{NNN}` — sequential, zero-padded (e.g., `RISK-001`, `RISK-002`)

## Procedure

### ADD
1. Assign sequential RISK-ID
2. Set severity, likelihood, category, status = OPEN
3. Require mitigation for HIGH and CRITICAL
4. If CRITICAL with no mitigation → set `escalation_required = true`
5. Append to State Ledger risks array

### UPDATE
1. Load existing risk by ID
2. Apply only the specified fields
3. If severity changed to CRITICAL → re-evaluate escalation requirement
4. Set `updated_at` timestamp

### CLOSE
1. Verify risk can be closed (mitigation confirmed or accepted)
2. Set status to CLOSED, add `closed_at` timestamp
3. Retain in register — do not delete

### SUMMARIZE
1. Group by severity: CRITICAL → HIGH → MEDIUM → LOW
2. For each risk: ID, description, status, mitigation summary
3. Flag any CRITICAL/HIGH without mitigation
4. Count by status: OPEN, MITIGATED, ESCALATED, ACCEPTED, CLOSED

## Escalation Rules
- CRITICAL + no mitigation field populated + no existing escalation in progress → during the ADD or UPDATE operation, set `escalation_required = true` and immediately invoke `human-escalation-skill` with `escalation_reason = "critical_risk_no_mitigation"` and `context = {risk_id, description, category}`. Do not complete the ADD/UPDATE without triggering the escalation.
- HIGH + no mitigation after 2 phases → flag for Tech Lead review; include in next SUMMARIZE output under "Overdue Mitigations"
- CRITICAL + ACCEPTED status → requires documented `human_approval_reference` field (escalation request ID or decision record ID); reject ACCEPTED status if reference is absent

## Quality Gate
All CRITICAL risks must have one of: mitigation documented, escalation in progress, or human-accepted status. An open CRITICAL risk with no action is a gate blocker for any gate.

## Failure Modes
- Risk added without severity → set `severity = UNKNOWN`, `status = OPEN`, flag as `needs_triage = true`; do **not** apply escalation rules until severity is explicitly assigned. Include in next SUMMARIZE output under "Pending Triage".
- CRITICAL risk accepted without human approval document → reject ACCEPTED status
- Duplicate risk description → flag and ask for clarification

## RAG Authorized
- `project_state` — State Ledger and existing risk register
- `factory_architecture` — escalation policy for CRITICAL risks

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:

- its local files (`skill.md`, schemas, checklist, examples)
- `Agente00_TechLead/knowledge/`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
