# Progress Reporting Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

## Output (WRONG)

```json
{
  "success": true,
  "health_status": "GREEN",
  "report": "Everything is going well. The project is on track and the team is doing great work. We expect to finish soon.",
  "key_metrics": {
    "gates_approved": 5
  }
}
```

## Violations

- `health_status = GREEN` despite the State Ledger having an open CRITICAL risk (RISK-003) and a blocking open question — this is optimism bias, a hard violation
- `report` is 3 vague sentences — provides no actionable information for stakeholders
- Report contains no milestone status, no specific timeline, no decision required, no blockers named
- `key_metrics` missing most required fields: `gates_total`, `current_phase`, risk counts by severity, open questions counts, `pending_human_approvals`, `approved_artifacts`
- `blocking_items` field absent — stakeholders have no visibility into what is blocked
- "The team is doing great work" — subjective, not measurable
- "We expect to finish soon" — not a date, not linked to any milestone

## What Should Have Happened

- Compute `health_status` from State Ledger: open CRITICAL risk → RED (not GREEN)
- Write a report that names specific milestones and their status
- Include a "Decision Needed" section for blocking open questions
- Populate all `key_metrics` fields from the actual State Ledger data
- Return `blocking_items` with all blocking risks and questions
- For EXECUTIVE report: plain language but still factual — report the RED status
- "We expect to finish soon" should be a specific date tied to a specific condition
