# ADR Governance Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

## Output (WRONG)

```json
{
  "success": true,
  "adr_id": "adr-1",
  "gate_block_required": false,
  "resolution_path": ["Write an ADR"],
  "adr_request": {
    "status": "APPROVED",
    "decision_required": "Use Redis"
  }
}
```

## Violations

- `adr_id = "adr-1"` — invalid format; must be `ADR-001` (uppercase, 3-digit zero-padded)
- `gate_block_required = false` — technology-level deviation always blocks the gate; this is a hard rule
- `adr_request.status = "APPROVED"` — an ADR cannot be self-approved at creation; must start as "PROPOSED"
- `resolution_path` has a single vague step — "Write an ADR" — not a specific ordered path
- `council_required` field absent — technology deviation requires Council, this was not flagged
- `human_approval_required` field absent — cannot determine if required
- `state_ledger_update` absent — ADR will not be tracked in State Ledger
- `deviation_identified` field absent from adr_request — the deviation is not described
- `golden_path_violated` field absent — the specific rule violated is not named

## What Should Have Happened

- Format ADR ID as `ADR-001` (uppercase, sequential, zero-padded)
- Set `gate_block_required = true` for any technology deviation
- Set `adr_request.status = "PROPOSED"` — only Tech Lead approval changes this to APPROVED
- Write ordered resolution path with ≥ 4 specific steps
- Set `council_required = true` for technology deviations
- Include full `state_ledger_update` payload to append to ADR array
- Populate all required fields: `deviation_identified`, `golden_path_violated`, `decision_required`
