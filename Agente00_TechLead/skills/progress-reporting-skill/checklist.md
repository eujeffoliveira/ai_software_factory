# Progress Reporting Skill — Checklist

## Before Report Generation
- [ ] Report type identified: EXECUTIVE / TECHNICAL / GATE_TRANSITION / INCIDENT
- [ ] Audience identified: affects language and detail level
- [ ] State Ledger loaded — complete and current
- [ ] Do NOT generate from memory — read all fields from the ledger

## Health Status Computation
- [ ] Check for open CRITICAL risks with no mitigation → RED if any
- [ ] Check for any BLOCKED gate → RED if any
- [ ] Check for HIGH risks with no mitigation → YELLOW if any
- [ ] Check for pending human approvals → YELLOW (or RED if gate blocked)
- [ ] If none of the above → GREEN
- [ ] Health status reflects actual state — no optimism bias

## Key Metrics Accuracy
- [ ] Gates approved count sourced from `gate_history` — not assumed
- [ ] Risk counts by severity from `risks` array
- [ ] Open questions: total vs. blocking count from `open_questions`
- [ ] Pending human approvals count from `human_approvals_required`
- [ ] Approved artifacts count from `approved_artifacts` object

## Report Content by Type
- [ ] EXECUTIVE: plain language, no agent IDs or stack-specific terms
- [ ] TECHNICAL: all gates, per-criterion validation, ADR status, all risks
- [ ] GATE_TRANSITION: gate number, before/after status, next agent
- [ ] INCIDENT: what failed (first), impact, current state, next steps

## Output Validation
- [ ] `blocking_items` sorted by severity (CRITICAL first)
- [ ] `health_status` consistent with `blocking_items` (cannot be GREEN with open CRITICAL risk)
- [ ] Report text matches key_metrics (no contradictions)
- [ ] No TODO placeholders left in report

## Runtime Knowledge Policy
- [ ] Skill does not depend on raw PDFs, raw books, `lib/`, or `context/` at runtime.
