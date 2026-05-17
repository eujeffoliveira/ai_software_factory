# acceptance-criteria-validation-skill — Bad Output Example

## Bad Input (Ambiguous Criteria)

```
AC-001: The task feature should work correctly and handle all cases properly.
```

## Bad Output: Tried to Test Anyway

```json
{
  "report_id": "AV-003-C1",
  "total": 1,
  "passed": 1,
  "failed": 0,
  "no_test": 0,
  "ambiguous": 0,
  "blocked_status": "NONE"
}
```

## Why This Is BAD

1. AC-001 is unmistakably ambiguous — "should work correctly" has no measurable outcome
2. The skill claimed it as PASSED — impossible if it's untestable
3. The skill invented a test mapping against an ambiguous criterion
4. This creates false confidence — the "validation" is meaningless

## Correct Behavior

```json
{
  "report_id": "AV-003-C1",
  "total": 1,
  "passed": 0,
  "failed": 0,
  "no_test": 0,
  "ambiguous": 1,
  "escalation_required": true,
  "blocked_status": "BLOCKED_MISSING_ACCEPTANCE_CRITERIA"
}
```

Escalate to Agente01_ProductOwner via Tech Lead.  
Do NOT test against "should work correctly."  
Gate 4: `BLOCKED_MISSING_ACCEPTANCE_CRITERIA`
