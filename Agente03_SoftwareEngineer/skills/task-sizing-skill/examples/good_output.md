# Good Output — Task Sizing Skill

## 5 tasks properly sized

```json
{
  "tasks": [
    {
      "task_id": "TASK-001",
      "estimated_complexity": "S",
      "estimated_loc": 25,
      "context_window_risk": "none",
      "sizing_rationale": "DB migration for single table, 8 columns. ~25 SQL LOC. Single file."
    },
    {
      "task_id": "TASK-002",
      "estimated_complexity": "S",
      "estimated_loc": 40,
      "context_window_risk": "none",
      "sizing_rationale": "Prisma model definition for single entity, 8 fields + 1 relation. ~40 LOC."
    },
    {
      "task_id": "TASK-003",
      "estimated_complexity": "M",
      "estimated_loc": 90,
      "context_window_risk": "low",
      "sizing_rationale": "Server Action: Zod schema (20 LOC) + auth check (10 LOC) + DAL call (15 LOC) + audit log (10 LOC) + error handling (20 LOC) + types (15 LOC) = ~90 LOC."
    },
    {
      "task_id": "TASK-004",
      "estimated_complexity": "M",
      "estimated_loc": 75,
      "context_window_risk": "low",
      "sizing_rationale": "Route Handler: GET with pagination and status filter. Zod query schema + handler logic. ~75 LOC."
    },
    {
      "task_id": "TASK-005",
      "estimated_complexity": "S",
      "estimated_loc": 45,
      "context_window_risk": "none",
      "sizing_rationale": "Prisma model update — adding 2 fields and 1 index to existing model. ~45 LOC diff."
    }
  ],
  "total_plan_complexity": "M",
  "xl_tasks_count": 0,
  "l_tasks_count": 0,
  "warnings": []
}
```

## Why This is Good

- All tasks S or M — xl_tasks_count: 0
- No L tasks — no context_summary required
- Sizing rationale is specific (not just "seems medium")
- total_plan_complexity M is accurate for the overall plan
