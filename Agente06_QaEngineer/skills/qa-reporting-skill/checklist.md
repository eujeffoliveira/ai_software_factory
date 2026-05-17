# qa-reporting-skill — Execution Checklist

## Report Completeness

- [ ] Section 1: Gate Decision — status code + rationale with evidence
- [ ] Section 2: Test Summary — Vitest numbers + Playwright numbers + coverage %
- [ ] Section 3: Acceptance Criteria Coverage — all AC-NNN with PASSED/FAILED/NO_TEST
- [ ] Section 4: API Contract Validation — all endpoints with check results
- [ ] Section 5: Accessibility Regression — all primary flows with check results
- [ ] Section 6: Bug List — all CRITICAL/HIGH/MEDIUM/LOW bugs with details
- [ ] Section 7: Regression Analysis — present if cycle > 1, omitted for cycle 1
- [ ] Section 8: Sign-off Checklist — all items checked/unchecked

## Gate Decision Quality

- [ ] Status code from authorized list (6 valid codes)
- [ ] Rationale cites specific numbers (test counts, coverage %, bug IDs)
- [ ] No vague language ("tests pass", "looks good", "seems correct")
- [ ] Decision is evidence-based — every claim has a data point

## Handoff Package

- [ ] Handoff Package JSON produced conforming to handoff_schema.json
- [ ] `gate_ready: true` only when gate_decision is APPROVED
- [ ] `required_next_agent` set correctly (Agente07 if APPROVED, Dev agents if BLOCKED)

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md` Section 7 (Gate 4 Decision Matrix) and Section 11 (QA Report Sections), `quality_gate.md`, `templates/QA_Report.md`, `handoff_schema.json`.  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
