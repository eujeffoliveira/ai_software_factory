# ADR Governance Skill — Good Output Example

_GOOD EXAMPLE — Technology deviation detected: Redis instead of stateless JWT._

## Output

```json
{
  "success": true,
  "adr_id": "ADR-001",
  "adr_request": {
    "id": "ADR-001",
    "date": "2026-05-17",
    "status": "PROPOSED",
    "deviation_identified": "Architecture document proposes Redis (Upstash) for session storage",
    "golden_path_violated": "Golden Model mandates stateless-first approach; server-side session state is not in the default stack",
    "decision_required": "Approve or reject use of Redis/Upstash for session management in place of stateless JWT",
    "gate_blocked": true
  },
  "gate_block_required": true,
  "human_approval_required": false,
  "council_required": true,
  "resolution_path": [
    "1. Tech Lead activates Council deliberation on Redis vs. stateless JWT (council-mediation-skill)",
    "2. Agente02_SoftwareArchitect writes full ADR-001 with context, decision, consequences, and 2+ alternatives",
    "3. Tech Lead reviews ADR-001 content — all required sections must be populated",
    "4. Tech Lead formally approves ADR-001 if Council endorses",
    "5. Gate 2 unblocked — State Ledger updated: ADR-001 status → APPROVED"
  ],
  "state_ledger_update": {
    "adrs": [
      {
        "id": "ADR-001",
        "title": "Redis session caching deviation from stateless Golden Model",
        "status": "PROPOSED",
        "submitted_by": "Agente02_SoftwareArchitect",
        "date": "2026-05-17",
        "gate_blocked": 2
      }
    ]
  }
}
```

## Why This is Good

- `adr_id` is correctly formatted: `ADR-001`
- `gate_block_required = true` — mandatory for technology-level deviation
- `council_required = true` — correctly identified as technology deviation
- `resolution_path` is ordered, specific, and names which skill to invoke
- `state_ledger_update` ready to append to ADR array
- `human_approval_required = false` — correctly identified as non-irreversible
