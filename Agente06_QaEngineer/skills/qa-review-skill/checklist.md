# qa-review-skill — Execution Checklist

## Definition of Ready

- [ ] Backend Handoff Package received with `gate_ready: true`
- [ ] Frontend Handoff Package received with `gate_ready: true`
- [ ] `API_Contract.json` available
- [ ] PRD with AC-NNN in Given/When/Then format available
- [ ] Vitest test files submitted
- [ ] Coverage report available
- [ ] Playwright test files submitted

## Skill Execution Sequence

- [ ] Step 1: acceptance-criteria-validation-skill invoked
- [ ] Step 2: api-contract-test-skill invoked
- [ ] Step 3: Vitest test review completed
- [ ] Step 4: Playwright test review completed
- [ ] Step 5: accessibility-regression-skill invoked
- [ ] Step 6: test-failure-classification-skill invoked (if any failures)
- [ ] Step 7: regression-analysis-skill invoked (if cycle > 1)
- [ ] Step 8: qa-reporting-skill invoked (always last)

## Gate Decision Validation

- [ ] Gate decision is from the authorized list (6 valid codes)
- [ ] Decision rationale cites specific evidence
- [ ] CRITICAL findings have triggered Tech Lead escalation
- [ ] QA_Report.md produced with all 8 mandatory sections

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md`, `quality_gate.md`, `knowledge/decision_rules.md`, `checklists/qa_quality_checklist.md`.  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
