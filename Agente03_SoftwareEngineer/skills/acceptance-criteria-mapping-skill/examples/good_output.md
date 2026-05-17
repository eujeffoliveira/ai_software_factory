# Good Output — Acceptance Criteria Mapping Skill

## 4 PRD criteria mapped to 4 tasks — all covered

**coverage_matrix:**

| PRD Criterion | Description | Covered by |
|--------------|-------------|-----------|
| AC-001 | User can create a new task with title, status, and priority | TASK-003 (Server Action), TASK-006 (TaskForm) |
| AC-002 | Created task appears in user's task list | TASK-005 (TaskList) |
| AC-003 | Unauthenticated users cannot create tasks | TASK-003 (auth check in Server Action) |
| AC-004 | Task creation is recorded in audit log | TASK-003 (audit_log write) |

**uncovered_criteria:** [] (empty — all covered)

**Sample task with criteria — TASK-003:**
```json
{
  "task_id": "TASK-003",
  "acceptance_criteria": [
    "Function validates title (min 3, max 255 chars) with Zod CreateTaskSchema",
    "Function returns created Task object with all fields on success",
    "Unauthenticated calls (session = null) return { error: 'UNAUTHORIZED' }",
    "Function writes audit_log entry with event type 'task.created' and correct user_id"
  ]
}
```

**Why this is good:**
- All 4 PRD criteria mapped to specific tasks
- uncovered_criteria is empty — Gate 3 coverage check passes
- Criteria are specific and testable (not "it works")
- Criteria trace back to the PRD with criterion IDs
