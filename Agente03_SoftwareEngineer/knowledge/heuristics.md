# Decision Heuristics — Agente03 Software Engineer / Task Planner
## Version: 1.0.0 | Distilled from build-time sources

Heuristics are rules of thumb for fast decision-making when formal rules don't cover the situation. When in doubt, apply these.

---

## H1 — If you can't name a task in ≤ 8 words, it's probably too large

**Quick check:** Try writing the task title. If you need 10+ words, or if you find yourself using "and", the task covers too much.

**Example:**
- "Implement createTask Server Action" (5 words) → good
- "Implement task creation including validation, persistence, and audit logging" (too long, too many responsibilities) → split

**Source:** The Pragmatic Programmer — naming as a design quality signal.

---

## H2 — Start with infrastructure and data layer — everything else depends on it

**Quick check:** Before writing any backend or frontend task, verify that the DB migration and Prisma model tasks are already in the plan as Phase 1 tasks.

**Example:** Don't plan a Server Action task before planning the DB migration it depends on. The migration must come first.

**Source:** Code Complete — construction order principle.

---

## H3 — Each design pattern application becomes a separate task — never mix pattern setup with business logic

**Quick check:** If a task implements a pattern (Repository, Factory, Strategy) AND business logic, split them.

**Example:**
- TASK-005: "Create TaskRepository class" (pattern setup, infrastructure)
- TASK-006: "Implement createTask business rule using TaskRepository" (business logic)

**Source:** Design Patterns (GoF) — separation of pattern infrastructure from pattern use.

---

## H4 — Integration points are the highest-risk tasks — give them extra acceptance criteria and security requirements

**Quick check:** Any task that crosses a system boundary (API endpoint, cron job, webhook, external service call) gets extra scrutiny.

**Application:** Add at least one "negative path" acceptance criterion (what happens on failure) and review security requirements carefully for all integration point tasks.

**Source:** Enterprise Integration Patterns — integration points as failure loci.

---

## H5 — Critical path tasks define the minimum delivery time — optimize them first

**Quick check:** When you need to estimate delivery time, count only the critical path tasks, not the total.

**Application:** Identify the critical path early. If the plan needs to be faster, look for ways to break long chains in the critical path — not to add more tasks to parallel tracks.

**Source:** System Design Interview — scheduling and critical path analysis.

---

## H6 — A task that touches >3 files is a code smell — reconsider decomposition

**Quick check:** Count the distinct file paths implied by the task's description and function_signatures. If >3 files are involved, the task likely spans multiple responsibilities.

**Application:** Split the task at file boundaries. One file per task is the ideal; two is acceptable for small M tasks; three is the limit.

**Source:** Code Complete — module cohesion and file-level responsibility.

---

## H7 — A task with no file_path is an anti-task — reject it

**Quick check:** Before a task can enter Execution_Plan.json, it must have a `file_path` value that is a specific, real file path.

**Application:** If a task cannot be given a file path (because the responsibility doesn't map to a single file), it is not atomic. Either decompose further or escalate.

**Source:** The Pragmatic Programmer — "fix the root cause, not the symptom" — a task without a file path signals unclear scope.

---

## H8 — Function signatures defined in the plan are contracts — the dev agent must not deviate without escalation

**Quick check:** Pre-specified function signatures in the task definition are binding contracts. If you define `async function createTask(input: CreateTaskInput): Promise<ActionResult<Task>>`, the dev agent must implement that exact signature.

**Application:** Function signatures should be pre-specified for all M and L tasks. The dev agent should never need to invent the function API.

**Source:** Code Complete — interface design as construction specification.

---

## H9 — If a task requires understanding the full codebase to implement, it's too large

**Quick check:** Ask: "Can this task be implemented with knowledge of 1–2 files + this task's specification?" If the answer is no, the context budget is exceeded.

**Application:** Add a context_summary to large tasks that pre-digests the relevant context. If even a summary doesn't help, split the task.

**Source:** The Pragmatic Programmer — cognitive load and context management.

---

## H10 — Parallel tracks = teams that can work simultaneously — always identify them for time-to-delivery estimates

**Quick check:** After building the dependency graph, identify groups of tasks with no mutual transitive dependencies. These are your parallel tracks.

**Application:** Mark parallel tracks in Execution_Plan.json and Implementation_Sequence.md. When reporting estimated delivery time, use critical path sessions (not total sessions).

**Source:** System Design Interview — parallelism in system planning and delivery estimation.

---

## H11 — Extract task list from class diagram: one Prisma model = at minimum two tasks (migration + model)

**Quick check:** Every entity in the class diagram produces: (1) a DB migration task (type: database, file_path: prisma/migrations/), and (2) a Prisma model task (type: database, file_path: prisma/schema.prisma). If the entity has complex business logic, add a (3) domain type/interface task.

**Example:**
- Entity `Task` → TASK-001: "Create Task DB migration" (type: database, file_path: prisma/migrations/) + TASK-002: "Add Task model to Prisma schema" (type: database, file_path: prisma/schema.prisma)
- Count entities → multiply by 2 = minimum DB task count

**Trigger:** When reading Architecture.md class diagram or Prisma_Schema_Proposal.prisma.

**Action:** Count entities → multiply by 2 = minimum DB task count.

**Source:** Módulo 04-05 — Projeto de Software I/II distillation + P9 principle.

---

## H12 — Extract task order from sequence diagram: left-to-right message sequence = dependency chain

**Quick check:** In a sequence diagram, messages flow from left to right (caller → callee). This temporal order is the correct implementation order: implement the callee before the caller.

**Example:**
- Sequence: Browser → proxy → Server Action → features/tasks/ → lib/db/ → Prisma
- Implementation order: Prisma model FIRST, then DAL (lib/db/), then Server Action, then route (proxy), then UI (Browser)

**Trigger:** When building dependency graph from Architecture.md.

**Action:** Read each sequence diagram step bottom-up (callee first), map to tasks, set depends_on accordingly.

**Source:** Módulo 05 — Projeto de Software II (sequence diagrams) + P9 principle.

---

## H13 — Each use case actor that is not the authenticated user requires a separate entry-point task

**Quick check:** In the use case diagram, primary actors other than the standard authenticated user (e.g., admin, cron system, external webhook) each require their own entry-point task: a separate Route Handler with different auth logic. Never merge entry points for different actors into one task.

**Example:**
- Actors: `User`, `Admin`, `CronSystem` → User's actions covered by standard Server Actions; Admin requires a separate Route Handler with admin-role check; CronSystem requires a separate Route Handler with `guardCron()`.

**Trigger:** When identifying API/route tasks from use case diagram.

**Action:** Count non-standard actors in UC diagram → create one distinct entry-point task per actor type.

**Source:** Módulo 05 — Projeto de Software II (use case diagrams) + DR017.
