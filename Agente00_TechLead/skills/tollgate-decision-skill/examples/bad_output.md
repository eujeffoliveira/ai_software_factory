# Tollgate Decision Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

## Output (WRONG)

```json
{
  "success": true,
  "status_code": "OK",
  "gate_decision": {
    "gate": 2,
    "status": "OK",
    "rationale": "Architecture looks good. Proceeding.",
    "required_actions": [],
    "next_agent": ""
  }
}
```

## Violations

- `status_code = "OK"` — not a valid status code; must be one of the 21 defined codes (e.g., APPROVED)
- `rationale` is 4 words — does not cite any specific evidence or validation results
- `validation_results` absent — the decision has no traceable basis
- `required_actions` is empty — even an APPROVED decision should confirm next steps; for any other status this is mandatory
- `next_agent` is empty string — hard violation, gate decision is unroutable
- `phase` field absent — required in gate_decision object
- `decided_by` and `timestamp` absent — decision is not auditable
- `adr_status` absent — cannot determine if Golden Path was checked
- `state_ledger_update` absent — gate history will not be recorded

## What Should Have Happened

- Use valid status code: "APPROVED" (if all criteria pass) or appropriate blocked/returned status
- Include full `validation_results` array with per-criterion evidence
- Write rationale citing specific document sections and metrics
- Set `next_agent` to valid agent ID: "Agente03_TechLead"
- Include `decided_by`, `timestamp`, `phase` for auditability
- Return `state_ledger_update` with complete gate_history entry
