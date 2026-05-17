# Decision Rules — Agente03 Software Engineer / Task Planner
## Version: 1.0.0 | Distilled from build-time sources

Decision rules are if-then rules that must be applied mechanically. Unlike heuristics, these are not judgment calls — they are binding.

---

## DR001 — XL Task Blocking Rule

**Rule:** IF `estimated_complexity == "XL"` THEN split the task into 2+ atomic tasks — never submit an XL task to Gate 3.

**When applied:** During task-sizing-skill execution and at Gate 3 validation.

**Consequence of violation:** Gate 3 returns RETURNED_FOR_REVISION with xl_tasks_count > 0.

---

## DR002 — Circular Dependency Block

**Rule:** IF `dependency-graph-skill` detects `has_cycles == true` THEN block the plan immediately and escalate to Tech Lead — never suppress the cycle or produce a topological order for a cyclic graph.

**When applied:** During dependency-graph-skill execution.

**Consequence of violation:** Invalid implementation order reaches dev agents; builds fail.

---

## DR003 — Uncovered PRD Criterion Handling

**Rule:** IF any PRD acceptance criterion has no covering task in the coverage_matrix THEN either add a task to cover it OR escalate to Tech Lead if coverage requires new architecture — never submit with uncovered criteria.

**When applied:** During acceptance-criteria-mapping-skill execution.

**Consequence of violation:** Gate 3 blocks on uncovered criteria.

---

## DR004 — file_path Required on All Tasks

**Rule:** IF a task has `file_path == null` or `file_path == ""` THEN reject the task — every task must specify exactly which file it creates or modifies.

**When applied:** During task atomicity checks.

**Consequence of violation:** Dev agent cannot know which file to create; implementation is blocked.

---

## DR005 — No Invented Endpoints

**Rule:** IF a task references an API endpoint not present in `API_Contract.json` THEN escalate to Agente02 via Tech Lead — never invent endpoint schemas.

**When applied:** When defining backend tasks for Route Handlers.

**Consequence of violation:** Architecture violation; dev agent implements non-approved API surface.

---

## DR006 — No Invented Schema

**Rule:** IF a task requires a database table, column, or model not in the approved DB schema THEN block the task and escalate to the Software Architect via Tech Lead — never create schema without approval.

**When applied:** When defining database tasks.

**Consequence of violation:** Unapproved database changes; migration conflicts; data integrity risks.

---

## DR007 — Zod Validation at User Input Boundaries

**Rule:** IF a task processes user-submitted data (form input, API request body, query params used in business logic) THEN `input_validation_required: true` AND `zod_schema_name` must be specified — no exceptions.

**When applied:** During security requirements assignment for backend tasks.

**Consequence of violation:** Unvalidated input reaches business logic; injection and data integrity vulnerabilities.

---

## DR008 — Audit Log for Sensitive Data Mutations

**Rule:** IF a task creates, updates, or deletes data that affects users, permissions, financials, or security settings THEN `audit_log_required: true` AND `audit_event_type` must be specified — no exceptions.

**When applied:** During security requirements assignment.

**Consequence of violation:** Non-auditable mutations; compliance and forensic analysis gaps.

---

## DR009 — Topological Order Enforcement

**Rule:** IF the proposed implementation order for a plan conflicts with the topological sort from `dependency-graph-skill` THEN reject the order and recompute — never allow implementation to proceed in an order that violates the dependency graph.

**When applied:** During implementation-sequencing-skill execution.

**Consequence of violation:** Dev agents implement tasks before their dependencies are complete; compilation failures and runtime errors.

---

## DR010 — PRD/Architecture Conflict Escalation

**Rule:** IF Architecture.md and PRD.md conflict in a way that affects task definition THEN escalate to Tech Lead immediately — never resolve the conflict unilaterally by choosing one source over the other.

**When applied:** During implementation readiness check and at any point during planning where a conflict is discovered.

**Consequence of violation:** Plan is built on an inconsistent foundation; Gate 3 will fail; rework at architecture level.

---

## DR011 — L Task Context Summary

**Rule:** IF a task has `estimated_complexity == "L"` THEN add a `context_summary` field of ≤ 200 words explaining what exists, what to build, key patterns, and what NOT to do — do not block, but annotate.

**When applied:** During task-sizing-skill and context-window-risk-analysis-skill.

**Consequence of not applying:** Dev agent receives an L task with no guiding context; higher risk of incorrect implementation or context exhaustion.

---

## DR012 — guardCron() First Call

**Rule:** IF a task implements a Vercel Cron handler THEN `cron_guard_required: true` in security_requirements AND the task's security_notes must specify that `guardCron()` is the first call in the handler body — no exceptions.

**When applied:** During security requirements assignment for infrastructure/cron tasks.

**Consequence of violation:** Cron handler runs without idempotency or authentication protection; duplicate side effects; security exposure.

---

## DR013 — Migration Execution Method

**Rule:** IF a task creates or applies a database migration THEN the task must specify `prisma migrate deploy` as the execution method in staging and production environments — NEVER `prisma db push`.

**When applied:** When defining database migration tasks.

**Consequence of violation:** `prisma db push` can silently drop data; unapproved schema changes in production.

---

## DR014 — Frontend Data Fetching Method

**Rule:** IF a task implements a frontend component that fetches data THEN specify the correct data fetching method in order of preference:
1. Server Component (direct data fetch — preferred)
2. Server Action (when mutation or form submission is involved)
3. SWR (for polling/real-time only — not default data fetching)

**When applied:** When defining frontend tasks that read data.

**Consequence of violation:** Client-side data fetching when Server Component would suffice; waterfall requests; unnecessary JavaScript bundle size.

---

## DR015 — Class Diagram to DB Tasks

**Rule:** IF Architecture.md includes a class diagram THEN extract all domain entities and create corresponding DB tasks (migration + Prisma model) before any application-layer tasks.

**When applied:** At the start of Execution_Plan.json construction, when Architecture.md is received with a class diagram.

**Consequence of violation:** Application-layer tasks are planned without their data layer dependencies; runtime errors when models are not present in the schema.

---

## DR016 — Sequence Diagram Dependency Derivation

**Rule:** IF Architecture.md includes a sequence diagram THEN derive `depends_on[]` for each task from the sequence diagram message order — do not invent dependencies not shown in the diagram.

**When applied:** During dependency-graph-skill execution when a sequence diagram is present in Architecture.md.

**Consequence of violation:** Fabricated dependencies produce incorrect ordering or missing real dependencies produce implementation failures.

---

## DR017 — Use Case Actor Coverage

**Rule:** IF a use case actor in Architecture.md has no corresponding task in the Execution_Plan THEN the plan is incomplete — every actor generates ≥1 task.

**When applied:** During acceptance-criteria-mapping-skill and at Gate 3 validation.

**Consequence of violation:** Entry points for system actors are missing; the delivered system will not handle all required interactions.

---

## DR018 — AND in Task Titles Signals Low Cohesion

**Rule:** IF a task title contains the word "and" connecting two distinct actions THEN split the task — AND in task titles signals low cohesion.

**When applied:** During task atomicity checks and task-sizing-skill execution.

**Consequence of violation:** Low-cohesion tasks cannot be cleanly tracked, tested, or handed off; they frequently exceed complexity budget.
