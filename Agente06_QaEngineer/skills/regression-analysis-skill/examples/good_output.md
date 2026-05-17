# regression-analysis-skill — Good Output Example

## Previous cycle had BUG-001 (CRITICAL: auth bypass) and BUG-002 (HIGH: validation missing)

## Resubmission includes:
- Auth check added to createTask.ts (line 3-4)
- Zod validation added to updateTask.ts
- Regression test for BUG-001: `"does not create task for unauthenticated caller — regression for BUG-001"`
- Regression test for BUG-002: `"returns validation error for missing title — regression for BUG-002"`

## Output
```json
{
  "report_id": "REG-003-C2",
  "verdict": "ALL_FIXED_WITH_REGRESSION_TESTS",
  "fixed_with_test": 2,
  "fixed_no_test": 0,
  "not_fixed": 0,
  "new_bugs": 0
}
```

Full evaluation proceeds. Both fixes verified. Regression tests confirmed meaningful.
