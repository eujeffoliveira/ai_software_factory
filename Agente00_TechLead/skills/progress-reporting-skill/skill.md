# Progress Reporting Skill

## Purpose
Generate structured progress reports from the State Ledger, summarizing project phase, agent status, milestone completion, blockers, open decisions, active risks, and next actions for human stakeholders.

## When to Use
- When a human stakeholder requests a status update
- After each gate decision (to document the transition)
- When the project is blocked (escalation context)
- Periodically, at the Tech Lead's discretion, for visibility
- During post-deploy validation summary

## Inputs
- `report_type` — EXECUTIVE / TECHNICAL / GATE_TRANSITION / INCIDENT
- `current_ledger` — State Ledger (full, current)
- `audience` — STAKEHOLDER / TECH_LEAD / AGENT (affects detail level)
- `period_covered` — optional date range for the report

## Outputs
- `report` — complete formatted report following `templates/Progress_Report.md`
- `health_status` — GREEN / YELLOW / RED (overall project health)
- `key_metrics` — quantifiable summary (gates passed, risks active, tasks completed)
- `blocking_items` — list of what is currently blocking progress

## Health Status Definitions

| Status | Meaning |
|--------|---------|
| GREEN | On track, no unresolved blockers, all CRITICAL risks mitigated, no gate blocked |
| YELLOW | Minor delays or risks; no gate blocked; no CRITICAL unmitigated risk; human approval may be pending |
| RED | Gate blocked **OR** CRITICAL risk with no mitigation (regardless of whether human approval is pending) |

## Report Types

### EXECUTIVE
- Audience: Human stakeholders, non-technical
- Content: Phase status, key milestones, health indicator, blockers in business terms, next milestone
- Length: 1 page equivalent
- No technical jargon, no stack-specific details

### TECHNICAL
- Audience: Tech Lead, technical team
- Content: All gates, per-criterion status, ADRs, risks (all), open decisions, pending human approvals, next action
- Length: Complete, no length limit
- Include agent IDs and handoff status

### GATE_TRANSITION
- Audience: Audit record, all agents
- Content: What gate transitioned, from/to status, validation results, next agent briefed
- Length: Gate-focused, concise

### INCIDENT
- Audience: Human operators, immediate response
- Content: What failed, impact, current state, immediate actions taken, options
- Length: Immediate facts first, context second

## Procedure

1. Determine report type and audience
2. Load State Ledger — do not assume, read all fields
3. Compute `health_status` — apply rules in this exact order (first match wins):
   - Any gate BLOCKED → **RED**
   - Any open CRITICAL risk with no mitigation → **RED**
   - Any HIGH risk with no mitigation → **YELLOW**
   - Any pending human approval (and no gate is BLOCKED and no CRITICAL risk is unmitigated) → **YELLOW**
   - Otherwise → **GREEN**
4. Compute `key_metrics`:
   - Gates approved count / 7
   - Active risks by severity count
   - Open questions (blocking vs non-blocking)
   - Approved artifacts count
5. List `blocking_items` in order of severity
6. Format report using `templates/Progress_Report.md`
7. Adjust language and detail level for audience

## Quality Gate
Progress reports must reflect the State Ledger exactly — no optimism bias, no paraphrasing that changes meaning. If the project is RED, the report says RED.

## Failure Modes
- State Ledger missing → cannot generate report, return error
- State Ledger inconsistency detected (e.g., gate marked APPROVED but no corresponding entry in `approved_artifacts`, or `current_phase` incompatible with gate history) → return error `LEDGER_INCONSISTENCY` and request ledger repair via `state-ledger-management-skill` before proceeding
- `health_status` GREEN with open CRITICAL risk → inconsistency, re-evaluate
- EXECUTIVE report with unexplained technical jargon → re-format for audience

## RAG Authorized
- `project_state` — State Ledger (current)
- `factory_architecture` — gate criteria for milestone evaluation

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:

- its local files (`skill.md`, schemas, checklist, examples)
- `Agente00_TechLead/knowledge/`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
