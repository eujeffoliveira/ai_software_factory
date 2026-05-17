# Bad Task Example
## "Do the backend stuff"

> This example demonstrates a deeply flawed task. Every problem is annotated inline.
> This task would be REJECTED at Gate 3 with RETURNED_FOR_REVISION.

---

## The Bad Task (Raw)

```
Task: Do the backend stuff
Type: backend
Complexity: L
file_path: (not set)
depends_on: []
acceptance_criteria: []
test_requirements: {}
security_requirements: {}
```

---

## Problem-by-Problem Analysis

### Problem 1: No Task ID
**What's wrong:** Task has no `task_id`. It cannot be referenced in `depends_on[]` by other tasks, cannot be tracked, cannot appear in the dependency graph.

**What was needed:** `"task_id": "TASK-003"` — unique, TASK-NNN format.

---

### Problem 2: Vague, Multi-Responsibility Title
**What's wrong:** "Do the backend stuff" violates every naming rule:
- Does not start with an action verb applied to a specific artifact
- "stuff" is the clearest possible anti-pattern — it signals undefined scope
- Cannot be described in ≤ 8 specific words
- Could mean anything from "write a Route Handler" to "implement the entire data layer"

**What was needed:** "Implement createTask Server Action" — specific verb, specific artifact.

---

### Problem 3: No file_path
**What's wrong:** `file_path` is null/empty. The dev agent has no idea which file to create or edit. They will have to guess, search the codebase, or ask for clarification — none of which is possible in an automated pipeline.

**Rule violated:** DR004 — every task must specify exactly which file it touches.

**What was needed:** `"file_path": "features/tasks/actions/createTask.ts"`

---

### Problem 4: No depends_on (Implicit Dependencies)
**What's wrong:** `depends_on: []` — the task has no declared dependencies. But "the backend stuff" almost certainly requires:
- A database migration (TASK-001)
- A Prisma model (TASK-002)
- Possibly an auth configuration

Without declaring these, the dependency graph is invalid. The dev agent might try to implement a Server Action before the Prisma model exists, causing compilation failures.

**Rule violated:** P3 — dependencies are explicit contracts, not assumptions. FM-07.

**What was needed:** `"depends_on": ["TASK-001", "TASK-002"]`

---

### Problem 5: No Acceptance Criteria
**What's wrong:** `acceptance_criteria: []` — there is no definition of done for this task. The dev agent cannot know when the task is complete. The Tech Lead cannot verify the output.

**Rule violated:** P4 — every task must trace to a PRD acceptance criterion.

**What was needed:** Specific, testable criteria:
- "Function validates input with Zod CreateTaskSchema"
- "Function returns created task on success"
- "Function returns UNAUTHORIZED for unauthenticated calls"
- "Function writes audit_log entry with event 'task.created'"

---

### Problem 6: No Test Requirements
**What's wrong:** `test_requirements: {}` — test requirements are completely absent. The dev agent will either not write tests (relying on someone else to "add tests later") or will write tests without knowing the coverage target, the test tools to use, or what to mock.

**Rule violated:** P7 — tests are tasks, not afterthoughts.

**What was needed:**
```json
{
  "unit_required": true,
  "unit_tool": "Vitest",
  "unit_coverage_target": 85,
  "integration_required": true,
  "integration_tool": "Vitest",
  "e2e_required": false,
  "mock_requirements": ["Prisma client", "NextAuth getServerSession"]
}
```

---

### Problem 7: No Security Requirements
**What's wrong:** `security_requirements: {}` — for a task described as "backend stuff", there are almost certainly security requirements: authentication checks, input validation with Zod, and audit logging for data mutations. None are specified.

**Rules violated:** P6, DR007, DR008.

**What was needed:**
```json
{
  "auth_required": true,
  "authorization_level": "authenticated",
  "input_validation_required": true,
  "zod_schema_name": "CreateTaskSchema",
  "audit_log_required": true,
  "audit_event_type": "task.created"
}
```

---

### Problem 8: Incorrect Complexity Estimate
**What's wrong:** Marked as `L` (150–300 LOC). But "Do the backend stuff" for an entire task management system is clearly XL (>300 LOC, multiple files). The agent either underestimated, or knew it was XL and marked it L to avoid the XL blocking rule — neither is acceptable.

**Rule violated:** DR001 — XL tasks cannot proceed to Gate 3.

**What was needed:** Either:
- Properly estimate as XL and split into 5–8 atomic tasks, OR
- Scope the task to truly be M (one Server Action, one file)

---

## Gate 3 Verdict

**Status: RETURNED_FOR_REVISION**

**Blocking conditions:**
1. Missing `task_id`
2. Missing `file_path` (DR004)
3. Missing `acceptance_criteria` (P4)
4. Missing `test_requirements` (P7)
5. Incomplete `security_requirements` (P6, DR007, DR008)
6. Missing `depends_on` — implicit dependencies (P3, FM-07)
7. Title does not describe an atomic, single-responsibility action
8. Complexity is L but actual scope is XL — must split (DR001)

**Resolution required:** This pseudo-task must be discarded and replaced with 5–8 properly decomposed atomic tasks following the patterns shown in `examples/good_task.md` and `examples/good_execution_plan.json`.
