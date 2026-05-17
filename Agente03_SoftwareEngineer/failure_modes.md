# Failure Modes — Agente03 Software Engineer / Task Planner
## Edition: Generic / White-Label | Version: 1.0.0

---

## Overview

This document describes the 10 known failure modes for Agente03. Each entry includes the symptom, probable cause, agent action, escalation condition, the artifact to fix, and whether the failure blocks the pipeline.

---

## FM-01: Mega-Task (Task Too Large)

**Symptom:**
A task has `estimated_complexity: "XL"` (> 300 LOC equivalent or > 3 files), or a task title describes multiple distinct actions ("Implement and test user management including DB, API, and UI").

**Probable Cause:**
- Architectural component was not decomposed — it was mapped 1:1 to a task
- A component spans multiple files and responsibilities
- The agent skipped the `atomic-task-decomposition-skill` step

**Agent Action:**
1. Identify the task(s) flagged as XL
2. Run `atomic-task-decomposition-skill` on the component
3. Split into 2–5 tasks with single file focus each
4. Re-assign dependencies, acceptance criteria, and test/security requirements
5. Re-run `task-sizing-skill` to confirm all splits are ≤ L

**When to Escalate to Tech Lead:**
If the component cannot be made atomic without changing the architecture (e.g., a single function must touch 5 tables), escalate with: "Component [name] cannot be decomposed without architectural restructuring."

**Artifact to Fix:** Execution_Plan.json — the offending task(s)

**Blocks Pipeline:** YES — Gate 3 will not pass with XL tasks. Rule: DR001.

---

## FM-02: Circular Dependency Detected

**Symptom:**
`dependency-graph-skill` returns `has_cycles: true`. A dependency chain loops: TASK-A → TASK-B → TASK-C → TASK-A.

**Probable Cause:**
- Two components are mutually dependent (bidirectional coupling)
- A task was placed in depends_on incorrectly (wrong direction)
- A hidden shared state was not modeled as a separate infrastructure task

**Agent Action:**
1. Identify the cycle using the DFS output
2. Examine the tasks in the cycle — determine which dependency is incorrect
3. Common fix: introduce a shared infrastructure task that both depend on, eliminating the cycle
4. If the cycle is architectural (two components genuinely depend on each other), escalate immediately
5. Re-run `dependency-graph-skill` after fix to confirm `has_cycles: false`

**When to Escalate to Tech Lead:**
If the cycle reflects a genuine architectural bidirectional dependency, escalate with the cycle description and the architectural conflict.

**Artifact to Fix:** Dependency_Graph.md and Execution_Plan.json (depends_on arrays)

**Blocks Pipeline:** YES — topological sort is impossible with cycles. Rule: DR002. Gate status: BLOCKED_AMBIGUOUS_DEPENDENCY.

---

## FM-03: Missing Acceptance Criteria on Tasks

**Symptom:**
One or more tasks have `acceptance_criteria: []` or the field is absent. Coverage matrix shows gaps.

**Probable Cause:**
- Task was created from an architectural component without mapping back to PRD criteria
- `acceptance-criteria-mapping-skill` was not run after decomposition
- PRD criteria were written at feature level and were not broken into task-level criteria

**Agent Action:**
1. Run `acceptance-criteria-mapping-skill` on all tasks with empty criteria
2. For each such task, find the PRD acceptance criterion that this task partially or fully implements
3. Write 1–3 testable criteria for the task (not "it works" — specific and verifiable)
4. Assign a `verification_method` (unit-test/integration-test/e2e-test/manual-review) to each criterion

**When to Escalate to Tech Lead:**
If a task exists in the plan but cannot be traced to any PRD criterion or ADR, escalate: "Task [id] has no traceability to PRD or architecture — scope validation required."

**Artifact to Fix:** Execution_Plan.json — `acceptance_criteria[]` in affected tasks

**Blocks Pipeline:** YES — Gate 3 requires all tasks to have ≥1 acceptance criterion.

---

## FM-04: Architecture Not Matching PRD Requirements

**Symptom:**
A PRD acceptance criterion requires a feature or behavior that is not present in Architecture.md. The planning agent cannot produce a task for it without inventing architecture.

**Probable Cause:**
- PRD was updated after Architecture was finalized (versioning drift)
- Agente02 missed a feature during architectural design
- A PRD criterion is ambiguous and was interpreted differently by the two agents

**Agent Action:**
1. Document the specific PRD criterion and the architectural gap
2. DO NOT invent architecture to fill the gap
3. Set gate_status to `BLOCKED_PENDING_HUMAN`
4. Escalate with: "PRD criterion [id] ([description]) requires [feature] which is not modeled in Architecture.md. Resolution required before task planning can proceed."

**When to Escalate to Tech Lead:**
ALWAYS — this failure mode always requires Tech Lead escalation. The agent cannot resolve architectural gaps unilaterally. Rule: DR010.

**Artifact to Fix:** Architecture.md (Agente02's responsibility after escalation)

**Blocks Pipeline:** YES — cannot plan what hasn't been architected. Gate status: BLOCKED_PENDING_HUMAN.

---

## FM-05: Missing API Contract for Referenced Endpoint

**Symptom:**
A task type "backend" or "frontend" needs to implement or consume an API endpoint, but that endpoint is not defined in API_Contract.json.

**Probable Cause:**
- Architecture.md describes the endpoint but it was omitted from the API contract
- Endpoint was added to Architecture.md after the API contract was finalized
- The agent discovered a requirement for an endpoint not previously identified

**Agent Action:**
1. Document the endpoint reference found in Architecture.md or the PRD
2. DO NOT invent the endpoint schema
3. Block the task with `blocking_reason: "Missing API contract for [endpoint]"`
4. Set gate_status to `BLOCKED_MISSING_ARTIFACT`
5. Escalate to Agente02 via Tech Lead: "API_Contract.json is missing endpoint [method path]. Cannot define task until contract is complete."

**When to Escalate to Tech Lead:**
ALWAYS — the agent cannot invent endpoints. Rule: DR005.

**Artifact to Fix:** API_Contract.json (Agente02's responsibility)

**Blocks Pipeline:** YES — tasks without API contract reference cannot be properly defined.

---

## FM-06: Missing File Path in Task Definition

**Symptom:**
A task has `file_path: null`, `file_path: ""`, or the field is absent.

**Probable Cause:**
- A task was created from a high-level component description without identifying the specific file
- The component maps to multiple files and the agent was unsure which one
- A testing task was created generically without specifying the test file path

**Agent Action:**
1. Return to Architecture.md — the file structure should be defined there
2. For backend tasks: `app/api/[route]/route.ts`, `features/[domain]/actions/[name].ts`, etc.
3. For frontend tasks: `app/[route]/page.tsx`, `features/[domain]/components/[name].tsx`, etc.
4. For database tasks: `prisma/migrations/[timestamp]_[name]/migration.sql`, `prisma/schema.prisma`
5. For testing tasks: `__tests__/[name].test.ts` or `tests/[name].spec.ts` (Playwright)
6. If the file location cannot be determined from Architecture.md, block the task and escalate

**When to Escalate to Tech Lead:**
If the architectural component does not specify a file path and the agent cannot infer it from the Golden Path conventions.

**Artifact to Fix:** Execution_Plan.json — `file_path` in affected tasks. Rule: DR004.

**Blocks Pipeline:** YES — Gate 3 rejects tasks without file_path.

---

## FM-07: Implicit Dependency (Undeclared Task Relationship)

**Symptom:**
A task relies on the output of another task (a type definition, a database table, a shared module) but this relationship is not declared in `depends_on[]`. The dependency graph looks valid but the plan will fail at implementation time.

**Probable Cause:**
- The relationship between tasks was assumed rather than modeled
- Shared infrastructure (types, utilities, env vars) was not modeled as a task
- The agent did not verify that all required prior artifacts are declared

**Agent Action:**
1. Review each task's `file_path` and `function_signatures[]`
2. For each function or import that comes from another task's output: add that task to `depends_on[]`
3. For Prisma models: every task using a model must depend on the Prisma schema task
4. For shared types/interfaces: create an infrastructure task for the shared type file
5. Re-run `dependency-graph-skill` after updating depends_on arrays
6. Re-validate topological sort

**When to Escalate to Tech Lead:**
If the implicit dependency reveals a missing architectural component (e.g., a shared utility service that was not designed).

**Artifact to Fix:** Execution_Plan.json — `depends_on[]` in affected tasks; possibly add new infrastructure task.

**Blocks Pipeline:** YES — implicit dependencies cause implementation-order failures.

---

## FM-08: Security Requirement Omitted from Sensitive Task

**Symptom:**
A task that touches user input, authentication, authorization, or sensitive data has `security_requirements` with all fields false or unset.

**Probable Cause:**
- Security requirements were not applied during task definition
- `checklists/security_requirements_checklist.md` was not run
- A task was added after the security sweep was completed

**Agent Action:**
1. Identify the sensitive nature of the task (API route? mutation? user data input?)
2. Apply decision rules:
   - DR007: user input → `input_validation_required: true` (Zod)
   - DR008: sensitive data mutation → `audit_log_required: true`
   - DR012: cron job → `guardCron()` as first call
3. Set `authorization_level` appropriately (public/authenticated/role-based/admin)
4. Note any XSS, CSRF, or SQL injection risks in `security_notes`
5. Mark `devsecops_review_required: true` for high-risk tasks

**When to Escalate to Tech Lead:**
If a security requirement cannot be satisfied without a capability not in the Golden Path stack (e.g., a custom encryption solution is needed).

**Artifact to Fix:** Execution_Plan.json — `security_requirements` in affected tasks. Rules: P6, DR007–DR012.

**Blocks Pipeline:** YES — Gate 3 blocks on missing security requirements for sensitive tasks.

---

## FM-09: Test Requirements Missing from Testable Task

**Symptom:**
A task that implements testable logic (Server Action, Route Handler, utility function, UI component) has `test_requirements` with all boolean fields false and no `test_notes`.

**Probable Cause:**
- Test requirements were not assigned during the security and test sweep
- `checklists/test_requirements_checklist.md` was not run
- An assumption that "testing will be figured out later"

**Agent Action:**
1. Identify the testable nature of the task (pure function? database operation? UI interaction?)
2. Apply rules:
   - Backend logic → `unit_required: true`, `unit_tool: "Vitest"`
   - Server Actions → `integration_required: true`, `integration_tool: "Vitest"`
   - User-facing flows → `e2e_required: true`, `e2e_tool: "Playwright"`
3. Set `unit_coverage_target` for backend tasks (80% minimum recommended)
4. Document `mock_requirements` (what needs to be mocked: DB, auth, external APIs)
5. Add `test_data_requirements` if the test needs specific fixtures

**When to Escalate to Tech Lead:**
Not needed for this failure mode — the agent can resolve it by applying the test requirements checklist.

**Artifact to Fix:** Execution_Plan.json — `test_requirements` in affected tasks. Rule: P7.

**Blocks Pipeline:** YES — Gate 3 requires test_requirements defined on all tasks.

---

## FM-10: Scope Creep (Plan Includes Unauthorized Work)

**Symptom:**
The execution plan contains tasks for features, components, or files that are not referenced in Architecture.md and cannot be traced to any PRD acceptance criterion or ADR.

**Probable Cause:**
- The agent "gold-plated" the plan by adding "obvious" features not in scope
- A task was created to implement a design pattern not requested by the architecture
- The agent extrapolated requirements beyond what was explicitly designed

**Agent Action:**
1. Review each task in the plan against Architecture.md components
2. Identify tasks with no traceability to Architecture.md or PRD criteria
3. Remove those tasks from Execution_Plan.json
4. If the removed task reveals a real requirement gap, document it as an open question in the handoff package
5. Set gate_status to `BLOCKED_SCOPE_EXCEEDED` if the out-of-scope work was significant

**When to Escalate to Tech Lead:**
If removing the tasks would leave a genuine requirement uncovered (the gap is real and needs architectural decision), escalate before removing.

**Artifact to Fix:** Execution_Plan.json — remove out-of-scope tasks. Rule: P8.

**Blocks Pipeline:** YES — out-of-scope work invalidates the plan and may indicate a misread of the architecture.
