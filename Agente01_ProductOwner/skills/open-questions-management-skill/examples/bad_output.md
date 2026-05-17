# Open Questions Management Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

---

## Output JSON (WRONG)

```json
{
  "artifact_path": "project/Open_Questions.md",
  "blocking_count": 0,
  "escalation_required": false,
  "duplicates_merged": [],
  "new_entries": [
    {
      "id": "Q1",
      "question": "SMS?",
      "impact": "Affects stuff",
      "criticality": "LOW",
      "owner": "TBD",
      "deadline": null,
      "status": "Open"
    },
    {
      "id": "Q2",
      "question": "What about the cancellation rule exceptions?",
      "impact": "Could change things",
      "criticality": "LOW",
      "owner": "TBD",
      "deadline": null,
      "status": "Open"
    },
    {
      "id": "Q3",
      "question": "Performance?",
      "impact": "NFRs",
      "criticality": "MEDIUM",
      "owner": "Tech Lead",
      "deadline": null,
      "status": "Open"
    }
  ]
}
```

<!-- PROBLEMA 1: IDs "Q1", "Q2", "Q3" do not follow OQ-NNN convention. Must be OQ-001, OQ-002, etc.
     PROBLEMA 2: Q1 question "SMS?" is not a question — it is a single word. A question must be answerable. "Should the system send SMS notifications in v1, or is email-only sufficient?" is a question.
     PROBLEMA 3: Q2 impact "Could change things" is not an impact description. It provides zero information about which artifact changes or what decision is blocked.
     PROBLEMA 4: Q2 criticality is LOW, but if cancellation rule exceptions exist they would require a new story and revisions to BR-001 and AC-003 — this should be BLOCKING.
     PROBLEMA 5: All owners are "TBD" — no path to resolution. A question without an owner will stay open indefinitely.
     PROBLEMA 6: blocking_count = 0 and escalation_required = false — but Q2 (cancellation exception) is actually a BLOCKING question that determines whether BR-001 is finalized. The blocking assessment is wrong.
     PROBLEMA 7: Q3 question "Performance?" is not answerable. "Should the P95 response time for the booking page be ≤ 1s or ≤ 2s given the expected 100 concurrent users?" is a question.
     PROBLEMA 8: Q3 owner is "Tech Lead" — the Tech Lead does not set business requirements. Performance expectations should come from the Business Owner or Operations Manager based on user expectations. -->
