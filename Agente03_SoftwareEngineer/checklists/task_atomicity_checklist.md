# Task Atomicity Checklist
## Agente03 Software Engineer / Task Planner
## Version: 1.0.0

Run this checklist on every task before including it in Execution_Plan.json.
A task fails this checklist if ANY item is unchecked.

---

## Pre-Check: Task Identity

- [ ] Task has a unique `task_id` in TASK-NNN format
- [ ] Task title is present and non-empty

---

## Atomicity Checks

### 1. Single Responsibility
- [ ] The task does exactly ONE thing (one verb + one object)
- [ ] The task title can be described in ≤ 8 words
- [ ] The task does not contain multiple responsibilities (e.g., "create AND validate" = two tasks)

_Failure: Split into separate tasks, one per responsibility._

### 2. Single File Focus
- [ ] The task has exactly ONE `file_path`
- [ ] `file_path` is not null, empty, or a directory
- [ ] `file_path` is a specific file (e.g., `features/tasks/actions/createTask.ts`), not a glob
- [ ] The task does not describe creating or modifying more than one file

_Failure: Add a second task for the second file. Rule: DR004._

### 3. Bounded Size (≤ 200 LOC Equivalent)
- [ ] `estimated_complexity` is S, M, or L (XL is rejected)
- [ ] If complexity is L (150–300 LOC), a `context_summary` is present (max 200 words)
- [ ] The function_signatures count is ≤ 5 (more suggests the task is too large)
- [ ] The task does not require implementing an entire subsystem in one session

_Failure for XL: Split immediately. DR001 blocks XL tasks at Gate 3._

### 4. Single-Session Completable
- [ ] The task can realistically be completed by one dev agent in one context window
- [ ] The task does not require understanding the entire codebase to implement
- [ ] The task does not require architectural decisions to be made during implementation

_Failure: Reduce scope or split into multiple sessions (multiple tasks)._

### 5. Testable in Isolation
- [ ] The task output can be tested without deploying the full application
- [ ] `test_requirements` is defined and at least one test type is specified
- [ ] The acceptance criteria include at least one verifiable behavioral assertion

_Failure: Add test requirements; rewrite acceptance criteria to be testable._

### 6. Well-Defined Output
- [ ] `acceptance_criteria` contains at least 1 item
- [ ] Each criterion is specific and verifiable (not "it works")
- [ ] At least one criterion specifies a verification method (unit-test, integration-test, e2e-test, manual-review)

_Failure: Rewrite vague criteria. Add task-level AC from PRD or Architecture.md._

### 7. No Hidden Dependencies
- [ ] All tasks this task depends on are listed in `depends_on[]`
- [ ] No imports or references in function_signatures require output from an unlisted task
- [ ] The Prisma model dependency is declared if this task uses a Prisma model
- [ ] Environment variables used in this task are available via lib/env.ts (declared as infrastructure)

_Failure: Add missing tasks to depends_on[]. Rule: P3._

### 8. Exact, Verb-Based Title
- [ ] Title starts with an action verb (Create, Implement, Define, Configure, Write, Add, Setup)
- [ ] Title names the specific artifact (not "the backend" or "the feature")
- [ ] Title does not use vague words: "handle", "do", "manage", "stuff"

_Failure: Rewrite title. Example: "Implement createTask Server Action" not "Do the task backend"._

---

## Post-Check: Complete Task Object

Verify the task object has all required fields:

- [ ] `task_id` — TASK-NNN format
- [ ] `title` — ≤ 80 chars
- [ ] `description` — ≥ 20 chars
- [ ] `type` — one of: backend/frontend/database/infrastructure/testing/security/config
- [ ] `layer` — present
- [ ] `file_path` — present and specific
- [ ] `depends_on` — array (may be empty for first tasks)
- [ ] `acceptance_criteria` — array with ≥ 1 item
- [ ] `test_requirements` — object with unit_required, integration_required, e2e_required
- [ ] `security_requirements` — object with auth_required, authorization_check, input_validation_required, audit_log_required
- [ ] `estimated_complexity` — S, M, or L
- [ ] `status` — "pending"

---

## Result

- **PASS:** All items checked → Task is atomic and ready for Execution_Plan.json
- **FAIL:** One or more items unchecked → Document which items failed and fix before proceeding

_A task that fails this checklist may NOT be included in a plan submitted to Gate 3._
