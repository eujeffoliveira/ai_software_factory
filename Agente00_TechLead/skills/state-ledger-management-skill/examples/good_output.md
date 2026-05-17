# State Ledger Management Skill — Good Output Example

_GOOD EXAMPLE — UPDATE operation: registering a gate decision and phase change._

## Input

```json
{
  "operation": "UPDATE",
  "update_type": "gate_decision",
  "current_ledger": { "...": "current state ledger object" },
  "update_payload": {
    "gate": 1,
    "status": "APPROVED",
    "approved_by": "Agente00_TechLead",
    "rationale": "PRD validated against all Gate 1 criteria. BDD acceptance criteria present for all 8 epics. Non-functional requirements specified with measurable thresholds. All 4 required artifacts present and validated."
  }
}
```

## Output

```json
{
  "success": true,
  "updated_ledger": {
    "project_name": "Enterprise Client Portal",
    "project_id": "proj-ecp-2026",
    "current_phase": "architecture",
    "current_agent": "Agente00_TechLead",
    "next_agent": "Agente02_SoftwareArchitect",
    "updated_at": "2026-05-17T14:30:00Z",
    "approved_artifacts": {
      "prd": true,
      "architecture_document": false,
      "execution_plan": false,
      "test_plan": false,
      "security_review": false,
      "deploy_plan": false,
      "post_deploy_validation": false
    },
    "gate_history": [
      {
        "gate": 1,
        "status": "APPROVED",
        "approved_by": "Agente00_TechLead",
        "timestamp": "2026-05-17T14:30:00Z",
        "rationale": "PRD validated against all Gate 1 criteria. BDD acceptance criteria present for all 8 epics. Non-functional requirements specified with measurable thresholds. All 4 required artifacts present and validated."
      }
    ],
    "next_action": "Route to Agente02_SoftwareArchitect with Gate 1 APPROVED briefing and PRD artifact"
  },
  "inconsistencies": []
}
```

## Why This is Good

- `success: true` — operation confirmed
- `updated_at` is set to current timestamp
- `current_phase` advanced to "architecture" after Gate 1 approval
- `next_agent` is set to specific agent ID
- `approved_artifacts.prd` set to `true` — consistent with gate history
- `gate_history` entry added with all required fields
- `next_action` is specific and actionable
- `inconsistencies` is empty — post-update consistency check passed
