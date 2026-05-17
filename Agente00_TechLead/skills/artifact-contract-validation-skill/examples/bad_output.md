# Artifact Contract Validation Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

## Input

```json
{
  "gate_number": 2,
  "handoff_package": {
    "artifact_produced": "Architecture_Document.md",
    "summary": "Architecture is ready.",
    "assumptions": [],
    "open_questions": [],
    "risks": [],
    "required_next_agent": "developer",
    "validation_checklist": []
  }
}
```

## Output (WRONG)

```json
{
  "success": true,
  "validation_result": "PASS",
  "validation_table": [
    { "criterion": "Architecture reviewed", "status": "PASS", "evidence": "Looks complete" }
  ],
  "issues_found": [],
  "adr_required": false,
  "recommended_gate_status": "APPROVED"
}
```

## Violations

- `validation_result = PASS` despite multiple handoff package failures (summary is 3 words, assumptions empty, risks empty, validation_checklist empty)
- `validation_table` has only 1 criterion — Gate 2 requires at minimum 7 criteria (document, API contract, DB schema, ADR register, Golden Model compliance, etc.)
- Evidence is "Looks complete" — not valid evidence; must cite specific document sections or measurable facts
- `required_next_agent = "developer"` — not a valid agent ID; should be "Agente04_SoftwareDeveloper" or similar
- `adr_required = false` — cannot be determined without actually checking for middleware.ts, `prisma db push` usage, etc.
- No API_Contract.json or DB_Schema checked — Gate 2 mandatory artifacts silently skipped
- `recommended_gate_status = APPROVED` — should be RETURNED_FOR_REVISION given the failures

## What Should Have Happened

- Reject handoff package immediately: `summary` is too short, `assumptions` and `risks` are empty
- Validate each Gate 2 criterion: Architecture_Document, API_Contract.json, DB_Schema, ADR_Register
- Check for Golden Path violations (middleware.ts, prisma db push)
- Flag `required_next_agent` as invalid agent ID
- Return `validation_result = FAIL`, `recommended_gate_status = RETURNED_FOR_REVISION`
