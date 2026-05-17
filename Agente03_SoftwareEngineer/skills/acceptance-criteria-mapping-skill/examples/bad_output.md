# Bad Output — Acceptance Criteria Mapping Skill

## Tasks with no criteria, and 2 uncovered PRD requirements

**coverage_matrix (incomplete):**

| PRD Criterion | Description | Covered by |
|--------------|-------------|-----------|
| AC-001 | User can create a new task | TASK-001 (DB migration — wrong!) |
| AC-002 | Created task appears in user's task list | (none) |
| AC-003 | Unauthenticated users cannot create tasks | (none) |
| AC-004 | Task creation recorded in audit log | (none) |

**uncovered_criteria:**
```json
[
  { "criterion_id": "AC-002", "description": "Created task appears in task list", "reason": "No task maps to rendering the task list" },
  { "criterion_id": "AC-003", "description": "Unauthenticated users cannot create tasks", "reason": "No task implements auth check" },
  { "criterion_id": "AC-004", "description": "Audit log recorded", "reason": "No task implements audit logging" }
]
```

**Sample bad task:**
```json
{
  "task_id": "TASK-001",
  "acceptance_criteria": []
}
```

## Problems

1. **AC-002, AC-003, AC-004 are uncovered** — Gate 3 blocks on uncovered_criteria
2. **AC-001 mapped to DB migration task** — wrong! The migration creates the table but doesn't implement task creation. The Server Action task is responsible for AC-001.
3. **TASK-001 has no acceptance criteria** — every task needs at least 1 criterion
4. Tasks exist for the DB migration and Prisma model, but tasks for the Server Action, Server Component, and auth logic are missing from the plan

## Gate 3 Verdict

RETURNED_FOR_REVISION — uncovered_criteria is non-empty (AC-002, AC-003, AC-004 uncovered).

Resolution: Add tasks to cover AC-002 (TaskList component), AC-003 (auth check in Server Action), AC-004 (audit_log in Server Action). Add acceptance_criteria to all tasks.
