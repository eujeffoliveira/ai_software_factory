# qa-review-skill — Bad Output Example

## Input
- Evaluation cycle: 1
- Backend handoff available, frontend handoff available

## Bad Skill Execution

Skipped acceptance-criteria-validation-skill because "the criteria seem clear."
Skipped api-contract-test-skill because "the endpoints are documented."
Vitest tests reviewed briefly — "looks fine."
Playwright tests not reviewed — "E2E tests are optional."
Accessibility not tested — "no time."
No test-failure-classification-skill invoked — "no tests failed."

## Bad Output

```json
{
  "gate_decision": "APPROVED",
  "qa_report_id": null,
  "skills_invoked": [],
  "escalation_triggered": false
}
```

## Why This Is BAD

1. Skills were skipped — every step in the procedure is mandatory, not optional
2. "Seems clear" and "looks fine" are subjective assessments, not QA evidence
3. No QA Report produced (`qa_report_id: null`) — FM-09 (missing mandatory artifact)
4. APPROVED issued without any of the required checks — this is not a valid gate decision
5. No skills invoked = no evaluation performed = gate decision has zero credibility
6. An auth bypass vulnerability in the implementation would pass this "review"
