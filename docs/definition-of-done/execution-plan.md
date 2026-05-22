# Definition of Done — Execution_Plan.json

## Overview

The Execution Plan is the bridge between architecture decisions and implementation work. It breaks down the architecture into a sequence of atomic, independently testable tasks that any developer agent can pick up and execute without needing to make design decisions. A poorly decomposed plan creates blocked tasks, integration surprises, and untestable code. A well-decomposed plan is a recipe that can be followed step by step.

## Owner Agent

- **Primary:** `@engineer` (Agente03_SoftwareEngineer)
- **Gate:** Gate 3 — Execution Plan Review

## Required Fields / Sections

### Plan Metadata
- [ ] `plan_id` — unique identifier for this plan
- [ ] `version` — semantic version, incremented on each approved revision
- [ ] `created_at` — ISO 8601 timestamp
- [ ] `project_archetype` — matches the value in the approved Architecture.md
- [ ] `source_architecture_version` — version of Architecture.md this plan was derived from
- [ ] `total_tasks` — count of tasks in the plan
- [ ] `estimated_total_hours` — sum of all task estimates

### Task Atomicity
- [ ] Every task has exactly one deliverable (one file created or one function implemented)
- [ ] No task has more than one primary responsibility
- [ ] Every task can be implemented and verified independently of other tasks (except declared dependencies)
- [ ] No task estimate exceeds 4 hours — tasks larger than 4 hours must be split
- [ ] Tasks are not described as phases ("implement the auth module") but as concrete actions ("implement `createSession` Server Action in `features/auth/actions/createSession.ts`")

### Task Fields (per task)
- [ ] `task_id` — unique, sequential identifier (`TASK-001`, `TASK-002`, ...)
- [ ] `title` — concise, action-oriented title (verb + noun, e.g., "Implement taskDal.findManyByUser")
- [ ] `type` — one of: `server_action`, `route_handler`, `dal`, `schema`, `component`, `service`, `test`, `migration`, `cron`, `integration_client`, `config`
- [ ] `file_path` — exact file path where the implementation goes
- [ ] `function_signatures` — typed function signatures for every function to be implemented
- [ ] `acceptance_criteria` — list of verifiable conditions the implementation must satisfy
- [ ] `security_requirements` — explicit security checks required (auth, authorization, input validation)
- [ ] `estimated_hours` — numeric estimate, 0.5–4.0
- [ ] `dependencies` — list of `task_id` values that must complete before this task starts (empty array if none)

### Task Independence and Testability
- [ ] Every task has at least one acceptance criterion that is verifiable without running the full application
- [ ] Test tasks (type `test`) are paired with implementation tasks — every Server Action and Route Handler has a corresponding test task
- [ ] No task's acceptance criteria require the completion of a future task not listed in its `dependencies`
- [ ] Data tasks (DAL, migration) precede the feature tasks that depend on them in the implementation order

### Dependency Map
- [ ] `dependencies` fields form a valid directed acyclic graph (DAG) — no circular dependencies
- [ ] The critical path is identified (the longest chain of dependent tasks)
- [ ] Parallelizable task groups are identified — tasks with no dependencies on each other can run concurrently
- [ ] Infrastructure/config tasks (env setup, migration) are listed before all feature tasks that depend on them

### Implementation Order
- [ ] `implementation_order` field lists task IDs in the recommended execution sequence
- [ ] Implementation order respects all declared dependencies
- [ ] Migrations appear before tasks that read from or write to the affected tables
- [ ] Schema (Zod) tasks appear before Server Action and Route Handler tasks that use those schemas
- [ ] DAL tasks appear before Server Action and service tasks that call them

### Test Plan (per task)
- [ ] Every Server Action task has a corresponding test task with minimum 4 test cases specified: unauthenticated, invalid input, success path, error path
- [ ] Every Route Handler task has a corresponding test task with the same 4 minimum cases
- [ ] E2E test tasks reference specific Playwright test scenarios mapped to user stories from the PRD
- [ ] Test tasks explicitly list what to mock (auth, DAL, external clients)

### Handoff Package
- [ ] `required_next_agent` set to `"Agente04_DevBackend"` (and/or `"Agente05_DevFrontend"` as applicable)
- [ ] `gate_ready` set to `true`
- [ ] `total_tasks`, `estimated_total_hours`, `critical_path` populated
- [ ] `parallelizable_groups` populated
- [ ] `open_questions` confirms no blocking items

## Acceptance Criteria

| Criterion | How to verify |
|-----------|---------------|
| All tasks are atomic | Read each task; if the title contains "and" or the file_path is a directory rather than a file, it is not atomic |
| No task exceeds 4 hours | Check `estimated_hours` for every task; reject any value > 4 |
| Every task has function signatures | Check `function_signatures` field; it must be non-empty for implementation tasks |
| Dependency graph is acyclic | Trace all dependency chains; any cycle is an immediate failure |
| Test tasks paired with implementation tasks | For every `server_action` or `route_handler` task, a `test` task must exist referencing it |
| Implementation order is valid | Walk the `implementation_order` list; each task's dependencies must appear earlier in the list |
| Security requirements stated per task | Read `security_requirements` for each task involving user input; reject if empty |
| Migrations precede dependent feature tasks | Find all `migration` tasks; verify no feature task that queries the migrated table appears before it |

## Related Gates

- **Prerequisite:** Gate 2 approved (Architecture.md and API_Contract.json must be approved)
- **This gate:** Gate 3 — Execution Plan Review (evaluated by Agente00_TechLead)
- **Unblocks:** Gate 4 — QA Review (Agente04_DevBackend and Agente05_DevFrontend consume individual tasks)

## Gate 3 Status Codes

| Code | Meaning |
|------|---------|
| `APPROVED` | Execution plan meets all criteria; pipeline advances to implementation |
| `RETURNED_FOR_REVISION` | Tasks are too coarse, missing fields, or have dependency issues |
| `BLOCKED_MISSING_TEST_PLAN` | Test tasks or test case specifications are absent |

## Failure Examples

- **FAIL:** A task titled "Implement authentication" has `file_path: "features/auth/"` (a directory) and `estimated_hours: 16`. This is a phase description, not an atomic task.
- **FAIL:** `TASK-015` depends on `TASK-020`, and `TASK-020` depends on `TASK-015`. This is a circular dependency — the plan cannot be executed.
- **FAIL:** `TASK-007` implements a Server Action but there is no corresponding test task anywhere in the plan. Gate 3 cannot be approved without a test plan.
- **FAIL:** `function_signatures` for `TASK-012` is empty. The Dev Backend cannot implement the task without knowing the expected function signature.
- **FAIL:** A `route_handler` task has `security_requirements: []`. The Tech Lead cannot verify that auth checks will be implemented.
- **FAIL:** The implementation order places a feature task that inserts into the `tasks` table before the `create_tasks_table` migration task.

## When to Block

Return `BLOCKED_MISSING_TEST_PLAN` when:
- Any Server Action or Route Handler task has no corresponding test task
- Test tasks exist but specify fewer than 4 test cases per function

Return `RETURNED_FOR_REVISION` when:
- Any task has `estimated_hours > 4`
- Any task's `file_path` is a directory rather than a specific file
- The dependency graph contains a cycle
- Any implementation task has empty `function_signatures`
- The implementation order violates any declared dependency

Issue `APPROVED` only when every checkbox in this document is checked, the dependency graph is validated as acyclic, and every implementation task has a paired test task.
