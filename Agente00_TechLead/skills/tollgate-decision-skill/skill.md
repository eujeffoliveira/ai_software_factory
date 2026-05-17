# Tollgate Decision Skill

## Purpose
Issue a formal gate decision (with status code, rationale, and required actions) based on the validation results from the artifact-contract-validation-skill and any Council verdicts.

## When to Use
- After artifact validation is complete and has produced a `validation_result`
- After Council deliberation (if it was triggered)
- When a previously BLOCKED gate has its blocking condition resolved

## Inputs
- `gate_number` (1–7)
- `validation_result` — from artifact-contract-validation-skill
- `validation_table` — per-criterion results
- `issues_found` — list of violations
- `conditions` — if PASS_WITH_CONDITIONS
- `adr_required` — boolean
- `council_verdict` — optional, from council-mediation-skill
- `human_approval_obtained` — boolean (required for Gate 6)
- `current_ledger` — State Ledger

## Outputs
- `gate_decision` — complete Gate_Decision object following `templates/Gate_Decision.md`
- `status_code` — one of the 21 valid status codes
- `required_actions` — specific list of actions before proceeding
- `state_ledger_update` — gate_history entry to append

## Status Code Reference

| Code | Meaning |
|------|---------|
| APPROVED | All criteria met, proceed |
| APPROVED_WITH_CONDITIONS | Minor issues, proceed with stated conditions |
| APPROVED_WITH_ADR | Golden Path deviation approved with ADR |
| RETURNED_FOR_REVISION | Blocker found, agent must fix and resubmit |
| BLOCKED_PENDING_ADR | Deviation detected, gate frozen until ADR approved |
| BLOCKED_PENDING_HUMAN | Requires human decision before proceeding |
| BLOCKED_PENDING_SECURITY | Security review not complete |
| BLOCKED_PENDING_QA | QA gates not passed |
| ESCALATED_TO_COUNCIL | Complex decision referred to Council |
| ESCALATED_TO_HUMAN | Human escalation triggered |
| FAILED | Irrecoverable failure in this gate |
| REVOKED | Previously approved gate decision revoked |
| CONDITIONAL_PASS | Criteria partially met with documented risk acceptance |
| PARTIAL_APPROVAL | Some artifacts approved, others pending |
| DEFERRED | Deliberately deferred by human decision |
| FAST_TRACKED | Expedited approval with documented rationale |
| SUSPENDED | Gate suspended due to external event |
| EXPIRED | Gate approval expired (time-limited) |
| CONTESTED | Decision disputed by agent or stakeholder |
| PENDING_REVIEW | Submitted, under review |
| RESUBMITTED | Previously returned, now resubmitted |

## Procedure

1. Map `validation_result` to candidate status code
   - PASS → APPROVED
   - PASS_WITH_CONDITIONS → APPROVED_WITH_CONDITIONS
   - FAIL (with fixable issues) → RETURNED_FOR_REVISION
   - FAIL (with ADR needed) → BLOCKED_PENDING_ADR
   - Gate 6 without human approval → BLOCKED_PENDING_HUMAN

2. If Council verdict available: incorporate into rationale

3. Write rationale with:
   - Summary of what was validated
   - Specific evidence for the decision
   - Reference to any ADRs or human approvals involved

4. Compose `required_actions` list:
   - Each action is specific and actionable
   - Owner is named for each action
   - Blocked gates specify exactly what must be resolved

5. Format as Gate_Decision using `templates/Gate_Decision.md`

6. Return `state_ledger_update` with gate_history entry

## Quality Gate
- Rationale must cite specific evidence — "all criteria met" alone is invalid
- APPROVED gate must have zero unresolved blocker criteria
- BLOCKED status must name the exact blocking condition
- `required_actions` must not be empty for any non-APPROVED status

## Failure Modes
- Gate 6 APPROVED without `human_approval_obtained = true` → hard block, override not allowed
- All CRITICAL risks unmitigated → cannot issue APPROVED
- `validation_table` missing → cannot issue any status except PENDING_REVIEW

## RAG Authorized
- `factory_architecture` — gate criteria and status code definitions
- `project_state` — State Ledger and gate history
- `golden_model` — tech stack rules for ADR detection

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `01-bibliografia/`, `00-contexto/`, or global build documents at runtime.

It may use only:

- its local files (`skill.md`, schemas, checklist, examples)
- `Agente00_TechLead/knowledge/`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
