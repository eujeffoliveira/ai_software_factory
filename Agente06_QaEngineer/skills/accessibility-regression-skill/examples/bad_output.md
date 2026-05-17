# accessibility-regression-skill — Bad Output Example

## Claim: accessibility is fine

```json
{
  "flows_tested": 0,
  "flows_passed": 0,
  "flows_failed": 0,
  "violations": []
}
```

## Why This Is BAD
1. `flows_tested: 0` — nothing was actually tested
2. `violations: []` on zero tested flows is meaningless — absence of violations requires actual testing
3. "No violations found" when no tests were run is false confidence

## What was actually missed
- Create Task button has no `aria-label` (just an icon, screen reader says nothing)
- Error messages use `.error-text` CSS class, not `role="alert"` (errors silent to screen readers)
- Tab order skips the file upload input entirely

## Correct Behavior
Run the accessibility checklist for each primary flow. If tests don't exist, note them as NOT_TESTED and flag as a gap. Never report 0 violations without having run the checks.
