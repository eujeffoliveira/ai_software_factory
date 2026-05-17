# Bad Output — Task Sizing Skill

## 1 XL task that exhausts context

```json
{
  "tasks": [
    {
      "task_id": "TASK-001",
      "estimated_complexity": "XL",
      "estimated_loc": 450,
      "context_window_risk": "critical",
      "sizing_rationale": "Implements full authentication system: DB migration, Prisma model, NextAuth config, login page, session hook, middleware, E2E tests — all in one task."
    }
  ],
  "total_plan_complexity": "L",
  "xl_tasks_count": 1,
  "warnings": [
    {
      "task_id": "TASK-001",
      "severity": "BLOCKING",
      "message": "Task TASK-001 is XL (450 LOC equivalent, 7 files). This BLOCKS Gate 3.",
      "mitigation": "Split into at minimum 5 tasks: DB migration, Prisma model, NextAuth config, login page, E2E tests."
    }
  ]
}
```

## Problems

- `xl_tasks_count: 1` — Gate 3 blocks immediately
- `estimated_loc: 450` — exceeds the 300 LOC XL threshold by 50%
- Single task touches 7 files — violates atomicity (one file per task)
- Even if marked as 'L' instead of 'XL', 450 LOC would be misrepresented

## Required Action

DR001: Split TASK-001 into 5–7 atomic tasks before Gate 3 submission.
The plan cannot proceed with xl_tasks_count > 0.
