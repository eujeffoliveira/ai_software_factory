# Risk Register Management Skill — Checklist

## Before Operation
- [ ] Identify operation: ADD / UPDATE / CLOSE / SUMMARIZE
- [ ] Load current risks from State Ledger
- [ ] For ADD: check for duplicate descriptions before assigning new ID

## ADD Operation
- [ ] RISK-ID assigned sequentially (RISK-{NNN}, zero-padded)
- [ ] Severity set: CRITICAL / HIGH / MEDIUM / LOW
- [ ] Likelihood set: HIGH / MEDIUM / LOW
- [ ] Category from approved list (9 categories)
- [ ] Status set to OPEN
- [ ] Mitigation documented if severity is HIGH or CRITICAL
- [ ] If CRITICAL + no mitigation: `escalation_required = true`
- [ ] Owner identified

## UPDATE Operation
- [ ] Risk exists (valid RISK-ID found in register)
- [ ] Only specified fields changed — no unintended overwrites
- [ ] `updated_at` set to current timestamp
- [ ] If severity upgraded to CRITICAL: re-evaluate escalation requirement

## CLOSE Operation
- [ ] Risk can be closed: mitigation confirmed, or accepted with human approval
- [ ] Status set to CLOSED (not deleted)
- [ ] `closed_at` timestamp set
- [ ] CRITICAL ACCEPTED risks: human approval document referenced

## SUMMARIZE Operation
- [ ] Grouped by severity: CRITICAL first, then HIGH, MEDIUM, LOW
- [ ] CRITICAL/HIGH without mitigation flagged explicitly
- [ ] Count by status included
- [ ] Open CRITICAL risks highlighted as gate blockers

## Output Validation
- [ ] `escalation_required` correctly set based on CRITICAL risk status
- [ ] `state_ledger_update` payload ready to apply
- [ ] `updated_risks` contains all risks (not just new/changed ones)

## Runtime Knowledge Policy
- [ ] Skill does not depend on raw PDFs, raw books, `01-bibliografia/`, or `00-contexto/` at runtime.
