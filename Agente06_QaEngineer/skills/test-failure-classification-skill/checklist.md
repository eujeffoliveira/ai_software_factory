# test-failure-classification-skill — Execution Checklist

## For Each Failure or Defect

- [ ] Applied CRITICAL check first (auth bypass, SQL injection, data loss, secrets exposed)
- [ ] Applied HIGH check (feature broken, user blocked, primary flow accessibility violation)
- [ ] Applied MEDIUM check (degraded UX, secondary flow issue, workaround available)
- [ ] Applied LOW check (cosmetic only)
- [ ] Classification assigned — no "maybe" or "unclear" outputs

## CRITICAL Findings

- [ ] Escalation to Tech Lead triggered immediately (do not wait for full report)
- [ ] Bug report (BUG-NNN) produced with full reproduction steps
- [ ] Security escalation to Agente07 triggered (if auth bypass or security vulnerability)

## HIGH Findings

- [ ] Bug report (BUG-NNN) produced for each HIGH bug
- [ ] Gate impact determined: BLOCKED_QA_FAILURE

## Gate Impact Determination

- [ ] Any CRITICAL → gate_impact: BLOCKED_CRITICAL_RISK
- [ ] Any HIGH (no CRITICAL) → gate_impact: BLOCKED_QA_FAILURE
- [ ] Only MEDIUM/LOW → gate_impact: RETURNED_FOR_REVISION
- [ ] No failures → gate_impact: NONE

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md` Section 8 (Bug Severity Matrix), `knowledge/decision_rules.md` (DR008, DR011, DR012), `checklists/failure_severity_checklist.md`, `templates/Bug_Report.md`.  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
