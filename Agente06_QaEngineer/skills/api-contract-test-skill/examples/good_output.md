# api-contract-test-skill — Good Output Example

## API Contract: 2 endpoints — POST /api/tasks, DELETE /api/tasks/:id

## Output
```json
{
  "report_id": "ACV-003-C1",
  "total_endpoints": 2,
  "fully_validated": 2,
  "partially_validated": 0,
  "not_validated": 0,
  "blocked_status": "NONE"
}
```

## Validation Detail

| Endpoint | Method | Status Code | Shape | 401 Auth | 400 Validation | Error Format | Overall |
|----------|--------|------------|-------|---------|----------------|--------------|---------|
| /api/tasks | POST | PASSED (201) | PASSED | PASSED | PASSED | PASSED | FULLY_VALIDATED |
| /api/tasks/:id | DELETE | PASSED (204) | PASSED | PASSED | N/A | PASSED | FULLY_VALIDATED |
