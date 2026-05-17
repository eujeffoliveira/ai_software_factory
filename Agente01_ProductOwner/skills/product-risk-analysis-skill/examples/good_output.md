# Product Risk Analysis Skill — Good Output Example

_GOOD EXAMPLE — 4 product-level risks with different categories and appropriate mitigations._

---

## Output JSON

```json
{
  "artifact_path": "project/Product_Risks.md",
  "critical_count": 1,
  "technical_risks_excluded": [],
  "risks": [
    {
      "id": "PRISK-001",
      "description": "Risk that clients do not adopt self-service booking because the booking flow has more than 3 steps, leading to continued reliance on phone booking and failure to achieve OBJ-02 (60% reduction in inbound calls).",
      "category": "user",
      "impact": "HIGH",
      "probability": "HIGH",
      "mitigation": "Conduct moderated usability test with 5 representative clients before the development phase begins. If the flow requires more than 3 steps, redesign the UX before proceeding to development. Success criterion: 4 of 5 test participants complete booking without assistance.",
      "contingency": "If usability test fails and redesign is not possible within constraints, reduce the scope to the minimum viable booking flow and defer advanced options to Phase 2.",
      "owner": "Product Owner",
      "status": "Open"
    },
    {
      "id": "PRISK-002",
      "description": "Risk that email confirmation notifications land in spam filters for a significant portion of clients, leading to missed confirmations, unexpected no-shows, and client trust erosion.",
      "category": "integration",
      "impact": "MEDIUM",
      "probability": "HIGH",
      "mitigation": "Validate email deliverability rates using a reputable transactional email service during QA. Measure inbox delivery rate with a test sample before launch. Target: >95% inbox delivery rate.",
      "contingency": "Activate SMS notifications (Phase 2 feature) earlier if email deliverability falls below 90% during launch monitoring.",
      "owner": "Tech Lead",
      "status": "Open"
    },
    {
      "id": "PRISK-003",
      "description": "Risk that double-booking occurs under high-concurrency conditions if the slot reservation mechanism does not handle race conditions, damaging client trust and increasing support burden.",
      "category": "data",
      "impact": "HIGH",
      "probability": "MEDIUM",
      "mitigation": "Document as a design constraint in handoff notes for the Architect: slot reservation must use an atomic reservation pattern. Validate with a concurrency acceptance test (AC-001-02) during QA.",
      "contingency": "If concurrency test fails after development, implement a queue-based booking confirmation model as a fallback before launch.",
      "owner": "Tech Lead",
      "status": "Open"
    },
    {
      "id": "PRISK-004",
      "description": "Risk that stakeholder scope requests expand beyond the defined boundary after development begins, as features like payment processing and SMS notifications were discussed and may be expected by users.",
      "category": "scope",
      "impact": "MEDIUM",
      "probability": "MEDIUM",
      "mitigation": "Ensure Scope_Boundary.md is formally reviewed and signed off by the Business Owner and Operations Manager at Gate 1. Include the out-of-scope rationale in the launch communication to stakeholders.",
      "contingency": null,
      "owner": "Product Owner",
      "status": "Open"
    }
  ]
}
```

## Why This is Good

- All 4 risks are product-level: user adoption, integration (email), data integrity, scope management
- PRISK-001 and PRISK-003 are HIGH impact with concrete, actionable mitigations
- PRISK-001 mitigation is specific: "5 representative clients", "4 of 5 succeed without assistance"
- critical_count = 1 (PRISK-001 is HIGH×HIGH)
- technical_risks_excluded is empty — no technical risks were included in product risks
- PRISK-003 correctly routes the implementation concern to the Architect via the mitigation note
