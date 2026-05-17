# Requirements Quality Review Skill — Bad Output Example

_BAD EXAMPLE — Superficial review that approves everything without verifying. Do not use as a model._

---

## Output JSON (WRONG)

```json
{
  "overall_status": "READY_FOR_GATE_1",
  "pass_count": 10,
  "fail_count": 0,
  "section_results": [
    { "section": "Document Structure", "status": "PASS", "items_passed": 1, "items_failed": 0, "notes": "Document looks complete" },
    { "section": "Business Problem", "status": "PASS", "items_passed": 1, "items_failed": 0, "notes": "Problem is described" },
    { "section": "User Stories", "status": "PASS", "items_passed": 1, "items_failed": 0, "notes": "Stories present" },
    { "section": "Acceptance Criteria", "status": "PASS", "items_passed": 1, "items_failed": 0, "notes": "Criteria written" },
    { "section": "NFRs", "status": "PASS", "items_passed": 1, "items_failed": 0, "notes": "NFRs included" },
    { "section": "Scope", "status": "PASS", "items_passed": 1, "items_failed": 0, "notes": "Scope defined" },
    { "section": "Business Rules", "status": "PASS", "items_passed": 1, "items_failed": 0, "notes": "Rules listed" },
    { "section": "Data", "status": "PASS", "items_passed": 1, "items_failed": 0, "notes": "Data mentioned" },
    { "section": "Risks and Questions", "status": "PASS", "items_passed": 1, "items_failed": 0, "notes": "Questions registered" },
    { "section": "Handoff Readiness", "status": "PASS", "items_passed": 1, "items_failed": 0, "notes": "Handoff ready" }
  ],
  "issues_requiring_correction": [],
  "technology_contamination": []
}
```

<!-- PROBLEMA 1: Each section shows items_passed: 1 — the prd_quality_checklist.md has 30+ items. 1 item per section means at most 10 items were checked total. The other 20+ items were silently skipped.
     PROBLEMA 2: Notes are boilerplate: "Document looks complete", "Problem is described", "NFRs included". These are not evidence — they are restatements that could apply to any document regardless of quality.
     PROBLEMA 3: "NFRs included" passes the NFR section — but does it verify that all 10 categories are present? That each has a measurable metric? That none says "the system should be fast"? None of this was checked.
     PROBLEMA 4: overall_status = READY_FOR_GATE_1 with 0 failures on a document that could have vague NFRs, missing negative scenarios, untraceable business rules, and missing scope boundary. The review provided no value.
     PROBLEMA 5: technology_contamination = [] — this cannot be confirmed if the PRD sections were not actually read for technology terms. It may be correct, but it was not verified.
     PROBLEMA 6: issues_requiring_correction = [] — a PRD with zero issues before Gate 1 review is extremely rare. This is a red flag for a superficial review, not a quality indicator.
     
     CONSEQUENCE: The Tech Lead will receive a handoff claiming Gate 1 readiness. Upon review, the Tech Lead may find NFRs without metrics, acceptance criteria with vague language, and missing sections — causing a NEEDS_MORE_REQUIREMENTS decision that could have been caught in self-review. -->
