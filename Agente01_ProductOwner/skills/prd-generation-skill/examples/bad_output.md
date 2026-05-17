# PRD Generation Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

---

## Output JSON (WRONG)

```json
{
  "prd_path": "project/PRD.md",
  "prd_version": "1",
  "validation_result": "PASS",
  "section_status": {
    "summary": "COMPLETE",
    "business_problem": "COMPLETE",
    "objectives": "COMPLETE",
    "non_objectives": "MISSING",
    "target_users": "COMPLETE",
    "user_stories": "COMPLETE",
    "acceptance_criteria": "COMPLETE",
    "functional_requirements": "COMPLETE",
    "non_functional_requirements": "INCOMPLETE",
    "business_rules": "COMPLETE",
    "data_requirements": "MISSING",
    "product_risks": "MISSING",
    "assumptions": "MISSING",
    "open_questions": "MISSING",
    "handoff_status": "MISSING"
  },
  "issues_found": [],
  "technology_contamination_detected": false
}
```

<!-- PROBLEMA: validation_result is PASS despite 5 sections MISSING and 1 INCOMPLETE. This is a logical contradiction. If sections are missing, the result must be FAIL or PASS_WITH_CONDITIONS.
     PROBLEMA: issues_found is empty even though non_functional_requirements is INCOMPLETE and 5 sections are MISSING. The quality checklist was clearly not run.
     PROBLEMA: technology_contamination_detected is false — but if we examine the PRD below, a technology decision was embedded. The flag is wrong. -->

---

## PRD.md Problems (Key Sections)

### Section 9 — Non-Functional Requirements (INCOMPLETE)

"The system should be fast, secure, and easy to use."

<!-- PROBLEMA: This is not an NFR section — it is a single vague sentence. "Fast" has no metric. "Secure" identifies no security requirement. "Easy to use" is not testable. 7 of 10 required NFR categories are absent entirely. This section is INCOMPLETE but the output marked it as passing. -->

### Section 10 — Business Rules (with invented rule)

| ID | Description | Source | Status |
|---|---|---|---|
| BR-001 | Employees can only submit leave requests 2 weeks in advance. | Assumed | Confirmed |

<!-- PROBLEMA: Source is "Assumed" — not a traceable source. "Assumed" rules are not confirmed rules. This rule should be OQ-NNN until confirmed by a stakeholder. The status "Confirmed" is incorrect — a rule that was never confirmed by a stakeholder cannot be confirmed. -->

### Missing: Sections 4, 11, 12, 13, 14, 15

<!-- PROBLEMA: Non-objectives, data requirements, product risks, assumptions, open questions, and handoff status are all absent. A PRD missing 6 of 15 sections will be rejected at Gate 1. -->

---

## Violations Summary

1. `validation_result = PASS` despite 5 MISSING and 1 INCOMPLETE sections — quality check was not run
2. `issues_found` is empty — contradicts the visible section status failures
3. NFR section has no metrics — a single vague sentence was accepted
4. BR-001 source is "Assumed" — unconfirmed rules must become OQ-NNN, not confirmed rules
5. 6 of 15 required sections are missing entirely
6. No INVEST validation run on user stories (not shown but implicit from the incomplete process)
