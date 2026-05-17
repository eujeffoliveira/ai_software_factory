# qa-reporting-skill — Bad Output Example

## Bad: Missing sections, vague rationale

```json
{
  "qa_report_id": null,
  "gate_decision": "APPROVED",
  "report_complete": false,
  "sections_complete": 2,
  "next_agent": "Agente07_DevSecOps"
}
```

Rationale provided: "Tests pass and the code looks good."

## Why This Is BAD
1. `qa_report_id: null` — no report ID, untrackable
2. `report_complete: false` with `sections_complete: 2` — only 2 of 8 sections filled
3. APPROVED issued with incomplete evidence — FM-09 (missing mandatory sections)
4. "Tests pass and the code looks good" — not evidence, not a rationale
5. No specific numbers, no AC-NNN coverage, no API contract results
6. `gate_ready: true` should NOT be set when report is incomplete

## What Should Happen
Do not issue APPROVED until all 8 sections are complete. An incomplete report with a gate decision is worse than a delayed report — the decision has no credibility without evidence.
