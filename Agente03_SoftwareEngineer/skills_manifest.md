# Skills Manifest — Agente03 Software Engineer / Task Planner
## Edition: Generic / White-Label | Version: 1.0.0

---

## Index

| # | Skill | Purpose | Trigger | Gate Reference |
|---|-------|---------|---------|---------------|
| 1 | execution-plan-generation-skill | Generate Execution_Plan.json from architecture package | After Gate 2 APPROVED | Gate 3 |
| 2 | atomic-task-decomposition-skill | Break large components into atomic tasks | When component is L/XL or multi-file | Gate 3 |
| 3 | dependency-graph-skill | Map task dependencies, detect cycles, topological sort | After initial task list complete | Gate 3 |
| 4 | task-sizing-skill | Estimate complexity, flag context window risks | After decomposition, before finalizing plan | Gate 3 |
| 5 | acceptance-criteria-mapping-skill | Map PRD criteria to tasks, validate coverage | During task definition | Gate 3 |
| 6 | implementation-sequencing-skill | Produce ordered phases with parallelism annotation | After dependency graph validated | Gate 3 |
| 7 | context-window-risk-analysis-skill | Analyze full plan for context exhaustion risks | Final step before gate submission | Gate 3 |

---

## Skill 1: execution-plan-generation-skill

**Purpose:** Generates the complete `Execution_Plan.json` from an architecture package. This is the primary skill — it orchestrates all other skills to produce the final plan artifact.

**When to Use:**
- The main trigger: when Architecture.md, PRD.md, API_Contract.json, and DB schema are all present and Gate 2 is APPROVED
- Re-triggered when Gate 3 returns the plan for revision

**Inputs:**
- Architecture.md — component list, tech decisions, ADRs
- PRD.md — acceptance criteria, feature requirements
- API_Contract.json — endpoint definitions with request/response schemas
- DB schema (DB_Schema.sql or Prisma_Schema_Proposal.prisma)
- Architecture_Decisions.md — ADRs that constrain implementation

**Outputs:**
- Execution_Plan.json (primary)
- Also triggers: Task_Backlog.md, Dependency_Graph.md, Task_Handoff_Packages.md

**Procedure Summary:**
1. Enumerate all architectural components
2. Run atomic-task-decomposition-skill per component
3. Run task-sizing-skill on all candidate tasks
4. Run acceptance-criteria-mapping-skill
5. Assign security and test requirements per DR007–DR012
6. Run dependency-graph-skill
7. Run implementation-sequencing-skill
8. Run context-window-risk-analysis-skill
9. Serialize to JSON matching schemas/execution_plan.schema.json
10. Set gate_status and produce handoff package

**Failure Modes:**
- Missing required input → BLOCKED_MISSING_ARTIFACT
- XL tasks in plan → must split (DR001)
- Circular dependencies → block and escalate (DR002)
- Uncovered PRD criteria → add tasks or escalate (DR003)

**Quality Gate Reference:** Gate 3 — all blocking conditions in quality_gate.md

**RAG Collections Permitted:**
- pragmatic_programming (core)
- code_complete (core)
- architecture_reference_task_planner_view (normative)

---

## Skill 2: atomic-task-decomposition-skill

**Purpose:** Breaks a large architectural component or oversized candidate task into multiple atomic tasks, each with single responsibility, single file focus, and bounded context.

**When to Use:**
- A component maps to more than one file
- A candidate task is estimated L or XL
- A task title cannot be described in ≤ 8 words
- A task touches multiple distinct responsibilities (e.g., "create AND validate AND persist")

**Inputs:**
- Component description from Architecture.md
- File list for the component
- Acceptance criteria from PRD.md for the component
- Estimated total complexity

**Outputs:**
- Array of atomic Task objects
- `decomposition_rationale` explaining how the split was made
- `parent_component` reference back to Architecture.md

**Procedure Summary:**
1. Identify single-responsibility units within the component
2. Find natural file boundaries (one task per file)
3. Estimate size of each unit
4. Split any unit > 200 LOC equivalent
5. Verify each piece is independently testable
6. Assign task IDs and dependency relationships within the decomposed set

**Failure Modes:**
- Component cannot be split without changing the architecture → escalate to Tech Lead
- Decomposed tasks still exceed M complexity → deeper split required
- No natural file boundary exists → may indicate architectural problem

**Quality Gate Reference:** Feeds into Gate 3 atomicity requirement

**RAG Collections Permitted:**
- pragmatic_programming (single responsibility)
- code_complete (module cohesion)
- architecture_reference_task_planner_view (file structure rules)

---

## Skill 3: dependency-graph-skill

**Purpose:** Builds the directed dependency graph for all tasks, detects cycles, computes the topological sort, identifies parallel tracks, and determines the critical path.

**When to Use:**
- After the complete task list is defined
- Before writing Execution_Plan.json
- When validating a revised plan after a gate return

**Inputs:**
- Task list (array of tasks with `task_id` and `depends_on[]`)

**Outputs:**
- Dependency_Graph.md with Mermaid flowchart
- Validated topological order (array of task IDs)
- Parallel tracks (groups of tasks with no mutual transitive dependencies)
- Critical path (longest dependency chain)
- `has_cycles` flag (must be false for gate to pass)

**Procedure Summary:**
1. Build adjacency list from all `depends_on[]` arrays
2. Run DFS to detect cycles
3. If cycle found: identify the cycle, set `has_cycles: true`, block plan
4. Compute topological sort (Kahn's algorithm)
5. For each task, compute earliest start time
6. Identify tasks with no mutual dependencies (parallel tracks)
7. Identify the longest path through the graph (critical path)

**Failure Modes:**
- Circular dependency → BLOCKED_AMBIGUOUS_DEPENDENCY, escalate to Tech Lead (DR002)
- Task references non-existent task_id in depends_on → reject (validation error)
- Ambiguous dependency ordering with equal valid options → escalate (DR009)

**Quality Gate Reference:** Gate 3 requires has_cycles: false

**RAG Collections Permitted:**
- design_patterns (sequence and dependency patterns)
- architecture_reference_task_planner_view (sequencing rules)

---

## Skill 4: task-sizing-skill

**Purpose:** Estimates the implementation complexity of each task and flags tasks that would exceed a dev agent's context window budget.

**When to Use:**
- After initial task definition and before finalizing dependencies
- When re-evaluating a decomposed task set
- When a task is flagged as potentially too large

**Inputs:**
- Task list with `file_path` and `function_signatures[]` for each task

**Outputs:**
- Task list annotated with `estimated_complexity` (S/M/L/XL)
- `context_window_risk` per task (none/low/medium/high/critical)
- `total_plan_complexity` summary
- `xl_tasks_count` (must be 0 for gate to pass)
- `warnings` array for L tasks with mitigation notes

**Sizing Criteria:**

| Grade | LOC Equivalent | Files | Dependencies | Risk |
|-------|---------------|-------|-------------|------|
| S | ≤ 50 | 1 | ≤ 2 | None |
| M | 50–150 | 1–2 | ≤ 4 | Low |
| L | 150–300 | 2–3 | ≤ 6 | Medium — flag |
| XL | > 300 | > 3 | > 6 | Critical — BLOCK |

**Failure Modes:**
- XL task detected → must split before gate submission (DR001)
- L task with many function signatures → add context_summary (DR011)
- Sizing is impossible without knowing the existing codebase → estimate conservatively (M)

**Quality Gate Reference:** Gate 3 blocks on any XL task

**RAG Collections Permitted:**
- code_complete (estimation techniques)
- pragmatic_programming (context management)
- architecture_reference_task_planner_view (stack-specific sizing)

---

## Skill 5: acceptance-criteria-mapping-skill

**Purpose:** Ensures every PRD acceptance criterion is covered by at least one task, and every task has at least one testable acceptance criterion derived from the PRD or architectural specification.

**When to Use:**
- During task definition, after initial decomposition
- Before finalizing Execution_Plan.json
- When verifying completeness of the plan

**Inputs:**
- PRD acceptance criteria list (array of `{criterion_id, description, story_id}`)
- Task list (array of `{task_id, title, type}`)

**Outputs:**
- Task list with `acceptance_criteria[]` populated per task
- Coverage matrix (each PRD criterion mapped to covering task IDs)
- `uncovered_criteria` list (must be empty for gate to pass)

**Procedure Summary:**
1. Enumerate all acceptance criteria from PRD.md
2. For each criterion, identify the task(s) responsible for implementing it
3. Write testable criterion statement for the task (not just "it works")
4. Assign `verification_method` (unit-test/integration-test/e2e-test/manual-review)
5. Mark each criterion as `is_blocking: true/false`
6. Build coverage matrix
7. Verify `uncovered_criteria` is empty

**Failure Modes:**
- PRD criterion has no covering task → add task or escalate (DR003)
- Task has no acceptance criteria → reject task
- Criterion is not testable (too vague) → rewrite or escalate to Product Owner via Tech Lead

**Quality Gate Reference:** Gate 3 blocks if any PRD criterion is uncovered

**RAG Collections Permitted:**
- code_complete (requirements traceability)
- pragmatic_programming (DRY requirements)

---

## Skill 6: implementation-sequencing-skill

**Purpose:** Produces the final ordered implementation sequence, grouping tasks into phases and annotating which tasks can run in parallel. Ensures infrastructure is always Phase 1 and testing is always last.

**When to Use:**
- After dependency graph is validated (has_cycles: false)
- After all tasks are sized (no XL tasks)
- As the final planning step before producing Execution_Plan.json

**Inputs:**
- Validated topological order (from dependency-graph-skill)
- Parallel tracks (from dependency-graph-skill)
- Task list with complexity and type

**Outputs:**
- Implementation_Sequence.md with phase groupings
- Phases: Phase 1 Infrastructure, Phase 2 Backend Core, Phase 3 Frontend, Phase 4 Testing & Integration
- Parallelism annotations: which tracks can run concurrently within each phase
- `estimated_total_sessions` — rough estimate of dev agent sessions required
- `critical_path_sessions` — sessions on the critical path

**Phase Rules:**
- Phase 1: `database` and `infrastructure` tasks — all migrations, env setup, config, proxy.ts, guardCron setup
- Phase 2: `backend` and `security` tasks — Server Actions, Route Handlers, NextAuth config, DAL
- Phase 3: `frontend` tasks — Server Components, Client Components, pages
- Phase 4: `testing` tasks — unit tests, integration tests, E2E flows

**Failure Modes:**
- A frontend task is placed before its backend dependency → reorder to Phase 3 after backend
- A testing task is placed in Phase 1/2 → move to Phase 4 (except unit tests that can colocate with Phase 2)
- Circular dependency re-detected → block, re-run dependency-graph-skill

**Quality Gate Reference:** Sequence must align with topological sort from dependency-graph-skill

**RAG Collections Permitted:**
- code_complete (construction sequence)
- integration_patterns (integration point ordering)
- architecture_reference_task_planner_view (stack deployment order)

---

## Skill 7: context-window-risk-analysis-skill

**Purpose:** Performs a full-plan analysis of context window exhaustion risks. Produces a risk report with per-task risk scores, aggregated plan-level risk, and mitigation recommendations.

**When to Use:**
- After all tasks are defined and sized
- As the final validation step before Gate 3 submission
- When a task is suspected of having hidden complexity

**Inputs:**
- Full Execution_Plan.json (complete plan object)

**Outputs:**
- Risk level for the full plan (LOW/MEDIUM/HIGH/CRITICAL)
- Per-task risk factors and scores
- List of XL tasks (must be empty)
- List of L tasks with flags
- Mitigation recommendations per risky task
- `gate_ready` flag (false if risk_level is CRITICAL)

**Risk Factors (per task):**
- Complexity L or XL (+2 or +4 to risk score)
- More than 5 function signatures (+1)
- depends_on chain longer than 5 (+2)
- Vague or missing file_path (+3)
- No pre-specified function signatures on M+ task (+1)
- More than 3 files referenced in context (+2)

**Risk Score → Risk Level:**
- 0–2: LOW
- 3–4: MEDIUM
- 5–7: HIGH
- 8+: CRITICAL

**Mitigations:**
- Split task (for XL/L tasks)
- Pre-specify function signatures
- Add `context_summary` (max 200 words) to task
- Reduce scope and add second task
- Split file responsibility across two tasks

**Failure Modes:**
- CRITICAL risk level → plan cannot proceed to Gate 3
- XL task not caught by task-sizing-skill → block and escalate
- All tasks have vague file paths → plan needs full revision

**Quality Gate Reference:** Gate 3 blocks if risk_level is CRITICAL or xl_tasks > 0

**RAG Collections Permitted:**
- pragmatic_programming (context management, rubber duck principle)
- code_complete (estimation and cognitive load)
- architecture_reference_task_planner_view (dev agent capacity model)
