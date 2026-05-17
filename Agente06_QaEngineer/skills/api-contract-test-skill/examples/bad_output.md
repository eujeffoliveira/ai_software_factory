# api-contract-test-skill — Bad Output Example

## API Contract has 3 endpoints, only 1 has tests

## Bad Output
```json
{
  "report_id": "ACV-003-C1",
  "total_endpoints": 3,
  "fully_validated": 1,
  "partially_validated": 0,
  "not_validated": 2,
  "blocked_status": "NONE"
}
```

## Why This Is BAD
1. Two endpoints have NO tests — `blocked_status` should be `BLOCKED_MISSING_TESTS`, not `NONE`
2. NOT_VALIDATED endpoints are a gate blocker — not acceptable

## Correct Output
```json
{
  "total_endpoints": 3,
  "fully_validated": 1,
  "partially_validated": 0,
  "not_validated": 2,
  "blocked_status": "BLOCKED_MISSING_TESTS"
}
```
Gate 4: `BLOCKED_MISSING_TESTS` — tests required for GET /api/tasks and PATCH /api/tasks/:id.
