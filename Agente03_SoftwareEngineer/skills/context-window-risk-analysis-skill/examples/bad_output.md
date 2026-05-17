# Bad Output — Context Window Risk Analysis Skill

## Plan with CRITICAL risk — 2 XL tasks, missing file paths

```json
{
  "plan_id": "plan-broken",
  "risk_level": "CRITICAL",
  "xl_tasks": ["TASK-001", "TASK-002"],
  "l_tasks_flagged": [],
  "risk_factors": [
    {
      "task_id": "TASK-001",
      "risk_score": 10,
      "task_risk_level": "critical",
      "factors": [
        {"factor": "XL complexity", "score": 4},
        {"factor": "file_path missing", "score": 3},
        {"factor": "no function_signatures on XL task", "score": 1},
        {"factor": "depends_on chain length 7", "score": 2}
      ],
      "recommendation": "BLOCKING: Split TASK-001 into 4-5 atomic tasks. Add file_path. Add function_signatures."
    },
    {
      "task_id": "TASK-002",
      "risk_score": 8,
      "task_risk_level": "critical",
      "factors": [
        {"factor": "XL complexity", "score": 4},
        {"factor": "file_path missing", "score": 3},
        {"factor": "no function_signatures on XL task", "score": 1}
      ],
      "recommendation": "BLOCKING: Split TASK-002. Add file_path."
    }
  ],
  "overall_recommendation": "CRITICAL risk — 2 XL tasks with missing file paths. Gate 3 is BLOCKED. Both tasks must be split before resubmission. See recommendations per task.",
  "gate_ready": false
}
```

## What This Means for the Plan

- `gate_ready: false` — plan cannot be submitted to Gate 3
- `risk_level: CRITICAL` — highest possible risk level
- `xl_tasks: ["TASK-001", "TASK-002"]` — Gate 3 blocks on xl_tasks_count > 0 (DR001)
- Missing file_paths compound the risk — dev agents have no target file

## Resolution Required

1. Split TASK-001 into atomic tasks (each S or M)
2. Split TASK-002 into atomic tasks (each S or M)
3. Add `file_path` to every new task
4. Re-run context-window-risk-analysis-skill
5. Verify `xl_tasks: []` and `gate_ready: true` before Gate 3 submission
