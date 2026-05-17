# Business Rules Extraction Skill — Good Output Example

_GOOD EXAMPLE — 3 business rules extracted: 2 confirmed with source, 1 pending with OQ._

---

## Output JSON

```json
{
  "artifact_path": "project/Business_Rules.md",
  "technical_decisions_found": [],
  "statements_without_rules": [
    "The system should look professional and be easy to navigate."
  ],
  "pending_rules": [
    {
      "proposed_description": "Staff members can only book appointments for services they are certified to provide.",
      "reason_for_pending": "This constraint was mentioned in passing by Operations Manager but not explicitly confirmed. The certification tracking system may not be in scope for v1.",
      "oq_id": "OQ-005"
    }
  ],
  "confirmed_rules": [
    {
      "id": "BR-001",
      "description": "Clients may cancel appointments without penalty only if the cancellation is submitted at least 24 hours before the scheduled start time. Late cancellations are rejected by the system.",
      "source": "Business Owner, Session 1, 2026-05-10 — verbatim: 'We don't allow cancellations less than 24 hours before the appointment. That's firm policy.'",
      "applies_to": ["US-003", "AC-003-02"],
      "exceptions": "None — Business Owner confirmed no exceptions for v1 (OQ-001 resolved 2026-05-15)"
    },
    {
      "id": "BR-002",
      "description": "Each staff member's individual working hours override the default business operating hours when both are defined. The booking interface uses individual hours when available.",
      "source": "Operations Manager, Session 1, 2026-05-10 — stated: 'Some staff work different hours than the business. We need to be able to set their hours individually.'",
      "applies_to": ["US-001", "US-004"],
      "exceptions": "None stated"
    }
  ]
}
```

## Why This is Good

- BR-001 source includes verbatim quote, role, and session date — fully traceable
- BR-001 exceptions explicitly state "None" and reference the OQ that resolved the question
- BR-002 source includes the paraphrased statement with enough context to trace back to Session 1
- The pending rule has a specific OQ-NNN (OQ-005) — it will not remain unresolved
- "The system should look professional" correctly identified as NOT a business rule (it is a UX aspiration) and placed in statements_without_rules
- technical_decisions_found is empty — no technical decisions were found masquerading as rules
