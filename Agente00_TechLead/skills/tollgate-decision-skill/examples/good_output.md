# Tollgate Decision Skill — Good Output Example

_GOOD EXAMPLE — Gate 2 APPROVED_WITH_ADR with full rationale._

## Output

```json
{
  "success": true,
  "status_code": "APPROVED_WITH_ADR",
  "gate_decision": {
    "gate": 2,
    "phase": "architecture",
    "status": "APPROVED_WITH_ADR",
    "decided_by": "Agente00_TechLead",
    "timestamp": "2026-05-17T15:00:00Z",
    "validation_results": [
      { "criterion": "Architecture_Document.md present", "status": "PASS", "evidence": "42-page document submitted covering all 8 epics" },
      { "criterion": "API_Contract.json present", "status": "PASS", "evidence": "OpenAPI 3.1 spec with 24 endpoints" },
      { "criterion": "DB_Schema present", "status": "PASS", "evidence": "Prisma schema v7 with 9 models and RLS annotations" },
      { "criterion": "No middleware.ts usage", "status": "PASS", "evidence": "proxy.ts used for auth redirect — confirmed in section 4.3" },
      { "criterion": "Golden Model stack compliance", "status": "PASS_WITH_ADR", "evidence": "Redis used for session caching — deviation from Golden Model which mandates stateless. ADR-001 submitted." }
    ],
    "rationale": "Architecture fully validated against Gate 2 criteria. All mandatory artifacts present (Architecture Document, API Contract, DB Schema with Prisma 7). Golden Model proxy.ts pattern correctly applied. One deviation detected: Redis session caching introduced for performance reasons. ADR-001 submitted with full justification and Council endorsement. Gate approved contingent on ADR-001 formal approval.",
    "required_actions": [
      "ADR-001 (Redis session caching) must receive formal written approval before implementation begins",
      "Agente04_SoftwareDeveloper must be briefed on ADR-001 constraints before any session layer code is written"
    ],
    "adr_status": "ADR-001 submitted, pending formal approval",
    "next_agent": "Agente03_TechLead"
  },
  "state_ledger_update": {
    "gate_history_entry": {
      "gate": 2,
      "status": "APPROVED_WITH_ADR",
      "approved_by": "Agente00_TechLead",
      "timestamp": "2026-05-17T15:00:00Z",
      "adr_reference": "ADR-001"
    }
  }
}
```

## Why This is Good

- Status code is specific (`APPROVED_WITH_ADR`) — not a generic APPROVED
- Validation results include ALL criteria with evidence
- Rationale explains why ADR was needed, not just that it was detected
- `required_actions` are specific with named owners and conditions
- `next_agent` is a valid agent ID
- `state_ledger_update` includes ADR reference for traceability
