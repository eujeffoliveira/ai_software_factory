# test-failure-classification-skill — Good Output Example

## Input: auth bypass found in code review

## Classification Result
```json
{
  "critical": 1,
  "high": 0,
  "medium": 1,
  "low": 2,
  "gate_impact": "BLOCKED_CRITICAL_RISK",
  "escalation_required": true,
  "bug_reports_produced": 1
}
```

Rationale:
- BUG-001 (CRITICAL): createTask executes without auth check — unauthenticated callers can create tasks for any userId. Escalated to Tech Lead immediately.
- BUG-002 (MEDIUM): Error message for empty title says "An error occurred" instead of "Title is required" — unhelpful but does not block the user.
- BUG-003 (LOW): Cancel button font weight inconsistent with design system
- BUG-004 (LOW): Placeholder text truncated in Safari
