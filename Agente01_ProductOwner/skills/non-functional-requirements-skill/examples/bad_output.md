# Non-Functional Requirements Skill — Bad Output Example

_BAD EXAMPLE — Vague NFRs and missing categories. Do not use as a model._

---

## Output JSON (WRONG)

```json
{
  "artifact_path": "project/Non_Functional_Requirements.md",
  "nfr_checklist_passed": true,
  "vague_nfrs_found": [],
  "categories_complete": {
    "performance": true, "security": true, "privacy": false, "availability": false,
    "observability": false, "auditability": false, "accessibility": false,
    "maintainability": false, "scalability": false, "data_retention": false
  },
  "nfr_entries": [
    {
      "id": "NFR-001",
      "category": "performance",
      "description": "The system should be fast",
      "metric": "Response times should be acceptable",
      "priority": "MUST",
      "acceptance_criterion": "QA should verify performance"
    },
    {
      "id": "NFR-002",
      "category": "security",
      "description": "The system must be secure",
      "metric": "All security best practices must be followed",
      "priority": "MUST",
      "acceptance_criterion": "Developer review"
    }
  ]
}
```

<!-- PROBLEMA 1: NFR ID "NFR-001" does not follow the required convention NFR-[CATEGORY]-NNN. Must be NFR-PERF-001.
     PROBLEMA 2: NFR-PERF metric: "Response times should be acceptable" — no percentile, no threshold, no load condition. "Acceptable" is not measurable.
     PROBLEMA 3: NFR-SEC metric: "All security best practices must be followed" — not a metric. Which practices? What is the measurable outcome?
     PROBLEMA 4: 8 of 10 categories_complete values are false — privacy, availability, observability, auditability, accessibility, maintainability, scalability, data_retention are all missing.
     PROBLEMA 5: nfr_checklist_passed = true despite 8 missing categories — the checklist was not run.
     PROBLEMA 6: vague_nfrs_found = [] despite both NFRs being obviously vague — vague term detection was not performed.
     PROBLEMA 7: acceptance_criterion for NFR-002 is "Developer review" — not an acceptance criterion. A criterion must be a verifiable test or check, not an assignment.
     
     CONSEQUENCE: These NFRs will be rejected at Gate 1. "Fast", "acceptable", "secure", and "best practices" are explicitly forbidden vague terms. The 8 missing categories mean the Architect has no guidance on availability target, privacy requirements, data retention policy, or scalability ceiling. The Architect must either guess or halt and request clarification. -->
