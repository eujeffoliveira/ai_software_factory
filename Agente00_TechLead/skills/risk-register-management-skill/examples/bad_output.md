# Risk Register Management Skill — Bad Output Example

_BAD EXAMPLE — Multiple violations. Do not use as a model._

## Output (WRONG)

```json
{
  "success": true,
  "risk_id": "risk3",
  "updated_risks": [
    {
      "id": "risk3",
      "description": "Security issue",
      "severity": "bad",
      "status": "maybe"
    }
  ],
  "escalation_required": false
}
```

## Violations

- `risk_id = "risk3"` — invalid format; must be `RISK-003` (uppercase, zero-padded)
- `severity = "bad"` — not a valid severity enum; must be CRITICAL / HIGH / MEDIUM / LOW
- `status = "maybe"` — not a valid status enum; must be OPEN / MITIGATED / ESCALATED / ACCEPTED / CLOSED
- `description = "Security issue"` — too vague; must describe the specific risk in enough detail to act on
- `likelihood` field absent — required
- `category` field absent — required (must be one of 9 approved categories)
- `mitigation` field absent — required when severity is HIGH or CRITICAL
- `owner` field absent — who is responsible for this risk?
- `reported_by` and `reported_at` absent — risk is not traceable
- Previous risks (RISK-001, RISK-002) removed from `updated_risks` — data loss
- `escalation_required = false` — cannot be determined without knowing severity; if severity was CRITICAL, this is wrong

## What Should Have Happened

- Format RISK-ID as `RISK-003` (uppercase, zero-padded)
- Use valid severity from enum: CRITICAL / HIGH / MEDIUM / LOW
- Use valid status: OPEN
- Write specific description: name the exact security scenario
- Set likelihood: HIGH / MEDIUM / LOW
- Set category: SECURITY (from approved 9-category list)
- Document specific mitigation if severity is HIGH or CRITICAL
- Set `escalation_required = true` if CRITICAL + no mitigation
- Retain ALL existing risks in `updated_risks` — never drop previous entries
