# qa-review-skill — Good Output Example

## Input
- Evaluation cycle: 1
- All inputs available: backend + frontend handoff packages (gate_ready: true), API contract, PRD with 6 AC-NNN criteria, 18 Vitest tests, 4 Playwright tests, coverage report (87%)

## Skill Execution

Skills invoked in sequence:
1. acceptance-criteria-validation-skill → all 6 AC-NNN mapped, 10 Then clauses, 10/10 PASSED
2. api-contract-test-skill → 3 endpoints, all 3 FULLY_VALIDATED
3. Vitest test review → 18/18 passing, 87% line coverage (meets 80% threshold), auth paths 100%
4. Playwright test review → 4/4 passing, accessible selectors (getByRole/getByLabel only)
5. accessibility-regression-skill → 2 flows tested, 2/2 PASSED
6. test-failure-classification-skill → no failures found
7. regression-analysis-skill → skipped (cycle 1)
8. qa-reporting-skill → QA_Report.md produced (QA-003-C1)

## Output

```json
{
  "gate_decision": "APPROVED",
  "qa_report_id": "QA-003-C1",
  "skills_invoked": [
    "acceptance-criteria-validation-skill",
    "api-contract-test-skill",
    "accessibility-regression-skill",
    "qa-reporting-skill"
  ],
  "escalation_triggered": false
}
```
