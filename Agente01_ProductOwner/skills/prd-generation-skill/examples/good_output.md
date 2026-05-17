# PRD Generation Skill — Good Output Example

_GOOD EXAMPLE — PRD for a "Employee Portal" SaaS system, generated with all sections complete._

---

## Output JSON

```json
{
  "prd_path": "project/PRD.md",
  "prd_version": "1.0",
  "validation_result": "PASS",
  "section_status": {
    "summary": "COMPLETE",
    "business_problem": "COMPLETE",
    "objectives": "COMPLETE",
    "non_objectives": "COMPLETE",
    "target_users": "COMPLETE",
    "user_stories": "COMPLETE",
    "acceptance_criteria": "COMPLETE",
    "functional_requirements": "COMPLETE",
    "non_functional_requirements": "COMPLETE",
    "business_rules": "COMPLETE",
    "data_requirements": "COMPLETE",
    "product_risks": "COMPLETE",
    "assumptions": "COMPLETE",
    "open_questions": "COMPLETE",
    "handoff_status": "COMPLETE"
  },
  "issues_found": [],
  "technology_contamination_detected": false
}
```

## PRD.md (Key Sections Shown)

### Section 6 — User Stories (excerpt showing quality)

| ID | Title | User Story | Priority |
|---|---|---|---|
| US-001 | Submit Leave Request | As an employee, I want to submit a leave request with dates and type, so that HR processes my request without requiring paper forms | MUST |
| US-002 | Approve or Reject Leave | As an HR manager, I want to approve or reject pending leave requests with a comment, so that employees receive decisions promptly and have context for rejections | MUST |

### Section 9.1 — Performance NFR (showing measurable metric)

- **NFR-PERF-001:** P95 response time for the leave request submission form ≤ 1.5 seconds under 300 concurrent employees during peak hours (Monday mornings 08:00–10:00).

### Section 10 — Business Rules (showing traceable source)

| ID | Description | Source | Status |
|---|---|---|---|
| BR-001 | Employees may not submit leave requests for dates that fall within an already approved leave period. | HR Policy Document v2.3, Section 4.1 | Confirmed |

## Why This is Good

- All 15 sections have status COMPLETE
- validation_result is PASS — quality checklist passed
- issues_found is empty
- technology_contamination_detected is false — no technology decisions leaked into the PRD
- User stories have the 3-part format with a real benefit
- NFR has P95 threshold, not just "should be fast"
- Business rule has a specific source document and section number
