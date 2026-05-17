# State Ledger Management Skill — Checklist

## Before Operation
- [ ] Identify correct operation (CREATE / UPDATE / VALIDATE / SUMMARIZE / DETECT_INCONSISTENCY)
- [ ] Load current State Ledger if operation is not CREATE

## After CREATE
- [ ] All required fields populated
- [ ] Arrays initialized as empty
- [ ] Timestamps set correctly
- [ ] `next_action` is specific

## After UPDATE
- [ ] `updated_at` set to current timestamp
- [ ] Only intended fields changed
- [ ] No data loss from previous state
- [ ] DETECT_INCONSISTENCY run after update

## After VALIDATE
- [ ] All fields checked
- [ ] Inconsistencies reported explicitly
- [ ] Valid report returned

## After SUMMARIZE
- [ ] Phase and agent reported
- [ ] Blocking open questions highlighted
- [ ] CRITICAL/HIGH risks highlighted
- [ ] Pending human approvals highlighted
- [ ] Next action stated

## Runtime Knowledge Policy
- [ ] Skill does not depend on raw PDFs, raw books, `01-bibliografia/`, or `00-contexto/` at runtime.
