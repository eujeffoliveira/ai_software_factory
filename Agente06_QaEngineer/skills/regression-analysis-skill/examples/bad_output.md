# regression-analysis-skill — Bad Output Example

## Resubmission: BUG-001 code fix present, no regression test

## Bad Output
```json
{
  "report_id": "REG-003-C2",
  "verdict": "ALL_FIXED_WITH_REGRESSION_TESTS",
  "fixed_with_test": 1,
  "fixed_no_test": 0,
  "not_fixed": 0,
  "new_bugs": 0
}
```

## Why This Is BAD
1. The fix is present but NO regression test was committed
2. The skill incorrectly classified this as `ALL_FIXED_WITH_REGRESSION_TESTS`
3. The verdict should be `PARTIAL_FIX_MISSING_TESTS`

## Correct Output
```json
{
  "verdict": "PARTIAL_FIX_MISSING_TESTS",
  "fixed_with_test": 0,
  "fixed_no_test": 1,
  "not_fixed": 0,
  "new_bugs": 0
}
```
Gate 4: `RETURNED_FOR_REVISION` — add regression test for BUG-001, then resubmit.
