# Tollgate Decision Skill — Checklist

## Before Issuing Decision
- [ ] Validation table received and complete
- [ ] All blocker criteria evaluated (not skipped)
- [ ] CRITICAL risks checked — all must have mitigation or escalation
- [ ] Gate 6: `human_approval_obtained = true` confirmed before APPROVED
- [ ] Council verdict incorporated if applicable

## Status Code Determination
- [ ] APPROVED: zero FAIL criteria, zero unresolved blockers
- [ ] APPROVED_WITH_CONDITIONS: only non-blocker criteria failed, conditions documented
- [ ] RETURNED_FOR_REVISION: at least one blocker criterion FAILED
- [ ] BLOCKED_PENDING_ADR: Golden Path deviation without approved ADR
- [ ] BLOCKED_PENDING_HUMAN: human decision required per escalation policy

## Rationale Quality
- [ ] Rationale cites specific evidence (document sections, metric values)
- [ ] Rationale explains the decision, not just restates the status
- [ ] Council verdict referenced if it influenced the decision
- [ ] ADR reference included if ADR is involved

## Required Actions
- [ ] Not empty for any non-APPROVED status
- [ ] Each action is specific and actionable
- [ ] Owner named for each action where applicable
- [ ] Timeline or condition specified where relevant

## Output Completeness
- [ ] `gate_decision` object has all required fields
- [ ] `next_agent` is a valid agent ID (not empty)
- [ ] `state_ledger_update` gate_history entry ready to append
- [ ] `status_code` matches the decision narrative

## Runtime Knowledge Policy
- [ ] Skill does not depend on raw PDFs, raw books, `01-bibliografia/`, or `00-contexto/` at runtime.
