# acceptance-criteria-validation-skill — Good Output Example

## Input: 3 acceptance criteria from PRD

```
AC-001: Given authenticated user, When submits valid task form, Then task created AND audit log recorded AND success response returned
AC-002: Given authenticated user, When submits empty form, Then validation error shown
AC-003: Given unauthenticated user, When calls createTask action, Then 401 returned
```

## Output

```json
{
  "report_id": "AV-003-C1",
  "total": 3,
  "passed": 3,
  "failed": 0,
  "no_test": 0,
  "ambiguous": 0,
  "escalation_required": false,
  "blocked_status": "NONE"
}
```

## Validation Table

| Criterion | Then Clause | Test File | Test Name | Status |
|-----------|-------------|-----------|-----------|--------|
| AC-001 | Task created | `createTask.test.ts` | `creates task when authenticated user submits valid data` | PASSED |
| AC-001 | Audit log recorded | `createTask.test.ts` | `creates task when authenticated user submits valid data` | PASSED |
| AC-002 | Validation error shown | `create-task.spec.ts` | `shows validation error when form submitted empty` | PASSED |
| AC-003 | 401 returned | `createTask.test.ts` | `returns Unauthorized when user is not authenticated` | PASSED |
