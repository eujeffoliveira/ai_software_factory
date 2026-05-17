# BDD Acceptance Criteria Skill — Good Output Example

_GOOD EXAMPLE — Criteria for 2 stories with full scenario coverage and concrete metrics._

---

## Output JSON (Excerpt)

```json
{
  "artifact_path": "project/Acceptance_Criteria.md",
  "bdd_checklist_passed": true,
  "vague_terms_found": [],
  "coverage_summary": {
    "US-001": { "HP": 1, "EC": 1, "NS": 1 },
    "US-002": { "HP": 1, "EC": 0, "NS": 1 }
  },
  "criteria": [
    {
      "id": "AC-001-01",
      "story_id": "US-001",
      "scenario_type": "HP",
      "given": "an employee is logged in and has no pending leave request for the selected dates",
      "when": "the employee submits a leave request with a valid start date, end date, and leave type",
      "then": "the system creates a leave request with status 'Pending Approval' and displays a confirmation: 'Your leave request has been submitted.'",
      "acceptance_metric": "Confirmation displayed within 1 second of submission"
    },
    {
      "id": "AC-001-02",
      "story_id": "US-001",
      "scenario_type": "EC",
      "given": "an employee submits a leave request for a period that includes a public holiday",
      "when": "the employee submits the request",
      "then": "the system creates the leave request and displays: 'Note: Your selected dates include 1 public holiday. Leave days will be recalculated accordingly.'",
      "acceptance_metric": "N/A"
    },
    {
      "id": "AC-001-03",
      "story_id": "US-001",
      "scenario_type": "NS",
      "given": "an employee already has an approved leave request for 2026-06-01 to 2026-06-05",
      "when": "the employee attempts to submit a new leave request that overlaps with those dates",
      "then": "the system rejects the submission and displays: 'You already have an approved leave request for this period. Overlapping requests are not allowed.'",
      "acceptance_metric": "N/A"
    }
  ]
}
```

## Why This is Good

- Given/When/Then format strictly maintained for all 3 scenarios
- HP scenario has a concrete time metric: "within 1 second"
- EC scenario tests a real business edge case (public holidays) — not a random condition
- NS scenario tests the specific business rule (BR-001: no overlapping leave) with the exact error message
- vague_terms_found is empty — no forbidden terms in any criteria
- bdd_checklist_passed is true
- coverage_summary accurately reflects scenario distribution
