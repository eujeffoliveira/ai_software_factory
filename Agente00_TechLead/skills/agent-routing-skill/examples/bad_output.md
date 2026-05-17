# Agent Routing Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

## Input

```json
{
  "current_phase": "requirements",
  "gate_status": "APPROVED",
  "gate_number": 1
}
```

## Output (WRONG)

```json
{
  "success": true,
  "next_agent": "architect",
  "routing_rationale": "Gate passed, move to next step",
  "agent_briefing": {
    "task": "Design the system",
    "constraints": []
  }
}
```

## Violations

- `next_agent` is "architect" — not a valid agent ID from the approved roster (should be "Agente02_SoftwareArchitect")
- `routing_rationale` is vague — does not cite routing table or any reasoning
- Briefing is missing required fields: `target_agent`, `inputs`, `expected_outputs`, `golden_model_reminders`, `adrs_in_scope`, `gate_target`, `escalation_policy`
- `constraints` is empty — no Golden Model rules communicated to the receiving agent
- `state_ledger_update` is absent — State Ledger will not be updated with new agent and phase
- `current_phase` not advanced from "requirements" to "architecture"

## What Should Have Happened

- Look up routing table: Gate 1 APPROVED → `Agente02_SoftwareArchitect`
- Write specific routing rationale citing the gate and routing rule
- Compose complete briefing with all required fields
- Include Golden Model constraints for architecture phase
- Return `state_ledger_update` to advance phase and set next agent
