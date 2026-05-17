# Open Questions Management Skill — Good Output Example

_GOOD EXAMPLE — 4 well-classified OQs added with varying criticality, one BLOCKING requiring escalation._

---

## Output JSON

```json
{
  "artifact_path": "project/Open_Questions.md",
  "blocking_count": 1,
  "escalation_required": true,
  "duplicates_merged": [],
  "new_entries": [
    {
      "id": "OQ-001",
      "question": "Can business administrators override the 24-hour cancellation window for individual clients, or is BR-001 strictly enforced without exceptions?",
      "impact": "If exceptions exist: BR-001 must be updated, a new story (US-NNN) is needed for administrator exception processing, and AC-003-02 must add a scenario for the exception flow. If no exceptions, AC-003 is final and BR-001 is confirmed as-is.",
      "criticality": "BLOCKING",
      "owner": "Business Owner",
      "deadline": "2026-05-20",
      "status": "Open"
    },
    {
      "id": "OQ-002",
      "question": "Should the system send SMS notifications to clients in addition to email for booking confirmations and cancellations, or is email-only sufficient for v1?",
      "impact": "If SMS required: Scope_Boundary.md must be updated, a third-party messaging integration becomes in-scope, and NFR-SEC and NFR-PERF must cover SMS delivery SLAs. If email-only confirmed, no change to current artifacts.",
      "criticality": "HIGH",
      "owner": "Operations Manager",
      "deadline": "2026-05-24",
      "status": "Open"
    },
    {
      "id": "OQ-003",
      "question": "Is there a maximum number of appointments a single client can book within a rolling 30-day window?",
      "impact": "If a limit exists: a new BR-NNN is created and AC-001 must include a negative scenario for exceeding the limit. If no limit, no change to current artifacts.",
      "criticality": "MEDIUM",
      "owner": "Business Owner",
      "deadline": null,
      "status": "Open"
    },
    {
      "id": "OQ-004",
      "question": "Should the system send automated reminder notifications to clients before their appointment? If yes, at what interval (24 hours before, 1 hour before, or both)?",
      "impact": "If reminders are required: a new story is needed, adding scope to the notification feature. If not required, explicitly documented as out-of-scope in Scope_Boundary.md. Current 5 stories are not affected.",
      "criticality": "LOW",
      "owner": "Operations Manager",
      "deadline": null,
      "status": "Open"
    }
  ]
}
```

## Why This is Good

- OQ-001 is BLOCKING with a specific deadline (2026-05-20) because it prevents finalization of BR-001 and AC-003
- OQ-002 is HIGH because it affects scope and NFRs meaningfully but does not prevent current stories from being specified
- OQ-003 is MEDIUM — it may add a rule and a negative scenario, but current stories are not blocked
- OQ-004 is LOW — does not affect any existing artifact at all
- Every impact description names the specific artifacts that change
- escalation_required is true because OQ-001 is BLOCKING — it will be surfaced in the Tech Lead communication
- No "TBD" owners — each has a specific role
