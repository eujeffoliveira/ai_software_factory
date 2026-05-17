# qa-reporting-skill — Good Output Example

## All evaluation steps completed with good results

## Output
```json
{
  "qa_report_id": "QA-003-C1",
  "gate_decision": "APPROVED",
  "report_complete": true,
  "sections_complete": 8,
  "next_agent": "Agente07_DevSecOps"
}
```

Gate decision rationale: "All 6 acceptance criteria have passing tests (AV-003-C1). Vitest: 18/18 passing. Playwright: 4/4 passing. Coverage: 87% (>80% threshold). All 3 API endpoints fully validated. No CRITICAL or HIGH bugs. 2 LOW cosmetic items tracked. Accessibility: 2/2 primary flows passed."

All 8 sections populated with specific evidence. Handoff Package produced with `gate_ready: true`.
