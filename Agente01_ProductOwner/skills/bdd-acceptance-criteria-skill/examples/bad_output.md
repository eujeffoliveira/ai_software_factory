# BDD Acceptance Criteria Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

---

## Output JSON (WRONG)

```json
{
  "artifact_path": "project/Acceptance_Criteria.md",
  "bdd_checklist_passed": true,
  "vague_terms_found": [],
  "coverage_summary": {
    "US-001": { "HP": 1, "EC": 0, "NS": 0 }
  },
  "criteria": [
    {
      "id": "AC1",
      "story_id": "US-001",
      "scenario_type": "HP",
      "given": "the user is logged in",
      "when": "the user submits the form",
      "then": "the system works correctly and the request is processed quickly",
      "acceptance_metric": "N/A"
    }
  ]
}
```

<!-- PROBLEMA 1: Criterion ID "AC1" does not follow AC-NNN-NN convention. Must be AC-001-01.
     PROBLEMA 2: "the system works correctly" in the Then clause — "correctly" is a forbidden vague term. Correctly according to what standard? This is not testable.
     PROBLEMA 3: "processed quickly" — "quickly" is a forbidden vague term. No metric provided. acceptance_metric is N/A but a processing action implies a timing expectation.
     PROBLEMA 4: coverage_summary shows only HP:1, EC:0, NS:0 for US-001. No edge case and no negative scenario. For a MUST story, at least one NS is required.
     PROBLEMA 5: bdd_checklist_passed = true despite obvious vague terms and missing scenario coverage — the checklist was not run.
     PROBLEMA 6: vague_terms_found = [] despite "correctly" and "quickly" appearing in the criteria — the vague term detection was not performed.
     PROBLEMA 7: Given clause "the user is logged in" is too thin — it does not establish relevant system state (what data exists, what is the user's context?) needed to run the test.
     PROBLEMA 8: When clause "submits the form" does not specify which form or what inputs — a test cannot be written without knowing what data the user provides. -->
