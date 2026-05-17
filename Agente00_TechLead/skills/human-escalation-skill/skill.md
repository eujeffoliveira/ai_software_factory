# Human Escalation Skill

## Purpose
Identify when a decision exceeds autonomous agent authority, compose a structured escalation request for the human operator, and halt pipeline execution until a response is received.

## When to Use (Mandatory — no exceptions)
- Production deployment approval (Gate 6)
- Any destructive migration (table drop, column removal, data deletion)
- CRITICAL security risk acceptance
- Scope change that increases total effort by more than 20%
- Change to authentication provider or authorization model
- Budget or contract decisions
- Any irreversible action not covered by an approved ADR
- Disagreement between agents that Council cannot resolve
- Retroactive ADR needed (deviation already in production)

## When to Use (Recommended)
- Competing HIGH severity risks with no clear mitigation
- External dependency failure (third-party API, vendor)
- Legal or compliance questions
- Timeline decisions affecting external stakeholders

## Inputs
- `escalation_reason` — specific trigger (from mandatory list above)
- `context` — project state, what decision is needed, what happens if delayed
- `urgency` — CRITICAL / HIGH / MEDIUM
- `options` — 2–4 options for the human to choose from, each with pros, cons, and risk
- `tech_lead_recommendation` — Tech Lead's recommendation with rationale
- `impact_of_delay` — what blocks if this is not decided
- `blocking_gate` — which gate or action is blocked

## Outputs
- `escalation_request` — complete Human_Escalation_Request following `templates/Human_Escalation_Request.md`
- `pipeline_halt` — always true (pipeline must halt until human responds)
- `state_ledger_update` — `human_approvals_required` entry to add

## Urgency Definitions

| Level | Meaning | Expected Response |
|-------|---------|-------------------|
| CRITICAL | Production incident or security breach risk | Immediate (< 1 hour) |
| HIGH | Gate blocked, sprint delayed | Same business day |
| MEDIUM | Decision needed before next phase | Within 2 business days |

## Procedure

1. Identify the mandatory or recommended trigger
2. Determine urgency based on impact and timeline
3. Compose 2–4 options — each option must have:
   - Clear label
   - Description of what this option means in practice
   - Pros (at least 2)
   - Cons (at least 1)
   - Risk level (LOW / MEDIUM / HIGH / CRITICAL)
4. State Tech Lead's recommendation — which option and why
5. Quantify impact of delay: which gate is blocked, what is the cost of waiting
6. Format using `templates/Human_Escalation_Request.md`
7. Update State Ledger: add to `human_approvals_required`
8. Halt pipeline — do not route to next agent until response received

## Human Response Processing

When human responds:
- Document the decision in State Ledger `decisions` array
- If approved: unblock gate, route to next agent
- If rejected: update State Ledger, notify current agent of new direction
- If modified: update all relevant artifacts and re-validate

## Quality Gate
Never escalate without a recommendation. The Tech Lead must have a position — "I don't know" is not a valid recommendation. If uncertain, the recommendation should be "defer until we can gather more information" with a specific information-gathering plan.

## Failure Modes
- Escalation sent without options → human cannot decide; re-send with options
- Pipeline continued without waiting for human response → CRITICAL failure mode
- Human response not documented in State Ledger → decision is untrackable

## RAG Authorized
- `factory_architecture` — escalation policy and triggers
- `project_state` — State Ledger, current risks, open decisions
- `golden_model` — tech stack rules relevant to the decision

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:

- its local files (`skill.md`, schemas, checklist, examples)
- `Agente00_TechLead/knowledge/` (especially `decision_rules.md` for escalation triggers)
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
