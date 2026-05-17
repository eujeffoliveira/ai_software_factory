# Good Output — Context Window Risk Analysis Skill

## Plan with LOW risk — 8 tasks, no XL, 1 L with mitigation

```json
{
  "plan_id": "plan-taskflow-saas-v1",
  "risk_level": "LOW",
  "xl_tasks": [],
  "l_tasks_flagged": [
    {
      "task_id": "TASK-007",
      "has_context_summary": true,
      "mitigation_applied": true,
      "recommendation": "L task has context_summary. No action required."
    }
  ],
  "risk_factors": [
    { "task_id": "TASK-001", "risk_score": 0, "task_risk_level": "none", "factors": [], "recommendation": "No action needed." },
    { "task_id": "TASK-002", "risk_score": 0, "task_risk_level": "none", "factors": [], "recommendation": "No action needed." },
    { "task_id": "TASK-003", "risk_score": 1, "task_risk_level": "low", "factors": [{"factor": "M task with 5 function_signatures", "score": 1}], "recommendation": "Low risk. Pre-specified signatures reduce ambiguity." },
    { "task_id": "TASK-004", "risk_score": 0, "task_risk_level": "none", "factors": [], "recommendation": "No action needed." },
    { "task_id": "TASK-005", "risk_score": 0, "task_risk_level": "none", "factors": [], "recommendation": "No action needed." },
    { "task_id": "TASK-006", "risk_score": 0, "task_risk_level": "none", "factors": [], "recommendation": "No action needed." },
    { "task_id": "TASK-007", "risk_score": 3, "task_risk_level": "medium", "factors": [{"factor": "L complexity", "score": 2}, {"factor": "context_summary present", "score": -1}], "recommendation": "Medium risk mitigated by context_summary. No further action needed." },
    { "task_id": "TASK-008", "risk_score": 1, "task_risk_level": "low", "factors": [{"factor": "E2E test with complex mock setup", "score": 1}], "recommendation": "Low risk. Mock requirements clearly documented." }
  ],
  "overall_recommendation": "Plan is ready for Gate 3. 1 L task (TASK-007) has context_summary applied. All other tasks are S or M. No XL tasks detected.",
  "gate_ready": true
}
```

**Why this is good:**
- xl_tasks is empty — Gate 3 won't block
- The one L task (TASK-007) has a context_summary — risk mitigated
- gate_ready: true is correctly set
- risk_level LOW is accurate given the task profile
