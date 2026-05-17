# State Ledger Management Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

## Input

```json
{
  "operation": "UPDATE",
  "update_type": "gate_decision",
  "current_ledger": { "...": "current state ledger object" },
  "update_payload": {
    "gate": 1,
    "status": "APPROVED"
  }
}
```

## Output (WRONG)

```json
{
  "success": true,
  "updated_ledger": {
    "project_name": "Enterprise Client Portal",
    "current_phase": "requirements",
    "next_agent": "",
    "updated_at": "2026-05-17T10:00:00Z",
    "approved_artifacts": {},
    "gate_history": []
  }
}
```

## Violations

- `current_phase` NOT advanced — still "requirements" after Gate 1 APPROVED (should be "architecture")
- `next_agent` is empty string — INCONSISTENCY, must name specific next agent
- `updated_at` unchanged from before — indicates state ledger was not actually updated
- `approved_artifacts.prd` not set to `true` — inconsistent with Gate 1 approval
- `gate_history` still empty — gate decision was not recorded
- `inconsistencies` field absent — post-update consistency check was skipped
- Gate decision payload missing `rationale` — accepted without validation
- `next_action` field absent — operator has no guidance on what to do next

## What Should Have Happened

- Validate that `rationale` was present before accepting the payload
- Set `current_phase = "architecture"`
- Set `next_agent = "Agente02_SoftwareArchitect"`
- Set `approved_artifacts.prd = true`
- Append full entry to `gate_history` with timestamp and rationale
- Run DETECT_INCONSISTENCY and return `inconsistencies: []`
- Set `next_action` to specific routing instruction
