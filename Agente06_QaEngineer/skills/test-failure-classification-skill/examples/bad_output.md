# test-failure-classification-skill — Bad Output Example

## Input: auth bypass found in code review (same as good example)

## Bad Classification
```json
{
  "critical": 0,
  "high": 0,
  "medium": 1,
  "low": 0,
  "gate_impact": "RETURNED_FOR_REVISION",
  "escalation_required": false,
  "bug_reports_produced": 0
}
```

Rationale provided: "The auth check seems to be handled elsewhere, so downgrading to MEDIUM."

## Why This Is BAD
1. Auth bypass is definitionally CRITICAL — it cannot be downgraded by "seems to be handled elsewhere"
2. "Seems to be handled elsewhere" is a speculation, not evidence — must verify with tests
3. `escalation_required: false` for an auth bypass — this is a critical security issue
4. No bug report produced for what is actually a CRITICAL finding
5. RETURNED_FOR_REVISION instead of BLOCKED_CRITICAL_RISK allows the vulnerability to proceed

## Correct Behavior
Apply the severity matrix strictly. Auth bypass = CRITICAL, no exceptions, no "seems like." Escalate immediately, issue BLOCKED_CRITICAL_RISK, produce BUG-NNN.
