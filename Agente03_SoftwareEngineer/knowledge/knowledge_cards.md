# Knowledge Cards — Agente03 Software Engineer / Task Planner
## Version: 1.0.0 | Distilled from build-time sources

Knowledge cards are reusable concept references. Use them to answer "how does X work in this context?" questions at planning time.

---

## Card 001 — Atomic Task

**Definition:** An atomic task is the smallest unit of implementable work that satisfies all of these properties simultaneously:

1. Single Responsibility — does exactly one thing
2. Single File Focus — creates or modifies exactly one file
3. Bounded Size — ≤ 200 LOC equivalent of new code (complexity S or M)
4. Single Session — completable by one dev agent in one context window
5. Testable in Isolation — can be verified without running the full application
6. Well-Defined Output — has at least one testable acceptance criterion
7. Explicit Dependencies — all prerequisites declared in `depends_on[]`
8. Named Action — title describes exactly one action in ≤ 8 words

**Golden Path Application:** In the Next.js 16 App Router stack, natural atomic boundaries are: one migration file, one Prisma model, one Server Action function, one Route Handler, one Server Component, one Client Component, one test file.

**Anti-patterns:** "Implement the whole feature", "Do the backend stuff", tasks with multiple files, tasks with empty `file_path`.

---

## Card 002 — Dependency Graph

**Definition:** A directed acyclic graph (DAG) where nodes are tasks and edges represent dependency relationships.

**Edge types:**
- `sequential` — Task B cannot start until Task A is complete
- `data` — Task B uses data models, types, or structures produced by Task A
- `file` — Task B imports or reads a file created by Task A

**Key properties:**
- Must be acyclic (has_cycles: false) — topological sort is impossible in cyclic graphs
- Topological sort gives the only valid implementation order
- Parallel tracks are groups of nodes with no mutual transitive dependencies
- Critical path is the longest dependency chain by complexity weight

**Why it matters:** The dependency graph is the implementation contract. Violating it causes tasks to be started before their dependencies are ready, resulting in compilation failures and wasted work.

---

## Card 003 — Context Window Budget

**Definition:** The context window budget is the maximum amount of information a dev agent can hold in working memory during one implementation session.

**Budget thresholds (LOC equivalent):**

| Grade | LOC | Files | Risk |
|-------|-----|-------|------|
| S | ≤ 50 | 1 | none |
| M | 50–150 | 1–2 | low |
| L | 150–300 | 2–3 | medium — add context_summary |
| XL | > 300 | > 3 | critical — BLOCK, must split |

**Why it matters:** AI dev agents are not humans — they cannot "stay focused" across a very large task. When a task exceeds the budget, the agent either truncates its output, makes architecture-level mistakes, or produces incomplete implementations. The task planner is the budget controller.

**Application:** Size every task. Keep tasks S or M. Add context_summary to L tasks. Never submit XL tasks.

---

## Card 004 — Critical Path

**Definition:** The critical path is the longest sequence of dependent tasks through the execution plan, measured by complexity weight. It represents the minimum time to deliver the plan if all other tasks run in parallel.

**Complexity weights:** S = 1, M = 2, L = 3

**How to compute:**
1. Assign weights to all nodes
2. For each node, compute: weight(node) + max(weight of all downstream paths)
3. The node with the highest sum value starts the critical path
4. Trace back to find the full path

**Why it matters for planning:**
- Critical path length = minimum sessions needed (with full parallelism)
- Total sessions needed = sum of all tasks (no parallelism)
- When the team needs to ship faster, optimize critical path tasks first
- Off-critical-path tasks can be delayed without impacting delivery date

---

## Card 005 — Execution Phase Model

**Definition:** The 4-phase implementation model that governs task ordering for the Golden Path stack.

| Phase | Name | Task Types | Rule |
|-------|------|-----------|------|
| 1 | Infrastructure | database, infrastructure, config | Must complete before Phase 2 starts |
| 2 | Backend Core | backend, security | May start after Phase 1; can parallelize within phase |
| 3 | Frontend | frontend | May start after relevant Phase 2 tasks complete |
| 4 | Testing & Integration | testing | Starts as soon as tested task completes; can run parallel to Phase 3 |

**Rationale:** The Golden Path stack has strict initialization order. Prisma requires the DB migration before the schema. Server Actions require the Prisma model before they can query. Server Components require Server Actions before they can render real data. E2E tests require working pages.

**Exception:** Unit tests (Vitest) can be co-located with Phase 2 development (TDD approach). If the team practices TDD, test tasks can move to Phase 2.

---

## Card 006 — Task Traceability

**Definition:** Task traceability is the chain that connects a line of code back to a business requirement.

**Traceability chain:**
```
Business Need (stakeholder requirement)
    ↓
PRD Acceptance Criterion (AC-NNN)
    ↓
Architectural Component (from Architecture.md)
    ↓
Atomic Task (TASK-NNN in Execution_Plan.json)
    ↓
Test (unit/integration/E2E verifying the criterion)
```

**Why it matters:** Every task in the plan must be traceable upward to a PRD criterion or ADR. Tasks with no traceability are either scope creep (remove) or reveal a gap in the architecture (escalate).

**Gate 3 enforcement:** The acceptance-criteria-mapping-skill builds the coverage_matrix, which is the formal proof of traceability. uncovered_criteria must be empty.

---

## Card 007 — Server Action vs Route Handler

**When to use Server Action:**
- Mutations triggered from Server Components or Client Components within the Next.js app
- Form submissions
- Any operation where the caller is within the Next.js application

**When to use Route Handler:**
- Webhooks from external services (Stripe, GitHub, etc.)
- Vercel Cron handlers (called by Vercel infrastructure, not the app)
- API endpoints consumed by external clients (mobile apps, third-party integrations)
- Public REST/JSON API surface

**Key difference:** Server Actions are type-safe, colocated with the app, and have built-in CSRF protection. Route Handlers are HTTP endpoints accessible from outside the Next.js process.

**Golden Path rule:** Use Server Actions for intra-app mutations. Use Route Handlers for external integration points only.

---

## Card 008 — Prisma Migration Rule

**Local development:**
- `prisma migrate dev` — generates migration files and applies them to local DB
- Safe to use; regenerates Prisma client automatically

**Staging and production:**
- `prisma migrate deploy` — applies pending migrations (does not generate new ones)
- Idempotent and safe for CI/CD pipelines

**Absolutely forbidden:**
- `prisma db push` — directly modifies the database schema without generating migration files
- Use of `prisma db push` in any environment beyond a prototype can silently drop columns or indexes
- DR013 enforces this rule

**Task planning application:** Every DB migration task must specify `prisma migrate deploy` in its execution notes and acceptance criteria.

---

## Card 009 — guardCron()

**Definition:** `guardCron()` is the first call in every Vercel Cron handler. It provides:
1. **Authentication** — verifies the request comes from Vercel's cron infrastructure (not arbitrary callers)
2. **Idempotency** — prevents duplicate execution if the cron fires more than once for the same schedule window
3. **Logging** — records the cron execution in `sync_log`

**Implementation pattern:**
```typescript
export async function GET(request: NextRequest) {
  await guardCron(request)  // MUST be first — throws if invalid
  // ... rest of handler
}
```

**Why it's first:** If `guardCron()` is not the first call, an unauthenticated caller could trigger the cron handler's side effects before authentication is checked.

**Task planning application:** Every task of type `infrastructure` or `backend` that implements a cron handler must have `cron_guard_required: true` in security_requirements. DR012 enforces this.

---

## Card 010 — Zod at System Boundaries

**Definition:** System boundaries are points where external data enters the application. In the Golden Path stack, these are:

- API Route Handler request bodies and query parameters
- Server Action input parameters
- Environment variable values (via `lib/env.ts`)
- Webhook payloads

**The rule:** All system boundaries must have a Zod schema that validates the incoming data before it touches business logic.

**Why:** Without Zod validation, malformed input propagates into Prisma queries, business logic, and responses. Zod provides:
- Runtime type safety (TypeScript types alone are compile-time only)
- Detailed error messages for invalid input
- Transformation (coerce strings to dates, etc.)
- Integration with the ActionResult error pattern

**Task planning application:** Any task that processes user input must have `input_validation_required: true` and `zod_schema_name` set. DR007 enforces this.

---

## Card 011 — Extracting Tasks from Architecture Diagrams

**Summary:** A systematic method to derive the Execution_Plan.json from Architecture.md UML artifacts.

1. **Class diagram → database tasks:** each entity = migration task (TASK-NNN type:database, file_path: prisma/migrations/) + Prisma model task (TASK-NNN+1 type:database, file_path: prisma/schema.prisma).
2. **Sequence diagram → dependency order:** callee tasks before caller tasks. Read the message sequence bottom-up (rightmost/deepest callee first) to determine depends_on[].
3. **Use case diagram → entry point tasks:** each actor-use case pair = one Route Handler or Server Action task; non-standard actors each require a distinct entry-point task.
4. **Component diagram → infrastructure tasks:** each external integration = configuration task.

**When to apply:** First step when processing Architecture.md — before writing any task.

**Operational rule:** No task in Execution_Plan.json should be written without a corresponding source in the architecture diagrams. Untraced tasks are scope creep.

**Rule connection:** P9, DR015, DR016, DR017, H11, H12, H13.

**Source:** Módulo 04-05 distillation + P9 principle.

---

## Card 012 — Cohesion and Coupling Applied to Task Planning

**Summary:** Cohesion (how related a task's responsibilities are) and coupling (how many other tasks depend on this task) are the two metrics for task quality.

| Metric | High (good) | Low (bad) |
|--------|------------|-----------|
| Cohesion | One file, one function, one acceptance criterion | Multiple files, multiple purposes, "and" in the title |
| Coupling (in) | depends_on[] ≤ 3 entries | depends_on[] > 3 entries |
| Coupling (out) | ≤ 3 other tasks reference this task | > 3 other tasks reference this task — bottleneck |

**Operational rule:** If a task has >5 other tasks depending on it (high coupling), it is a critical path bottleneck — flag it, simplify it, or split it to reduce downstream blocking.

**When to apply:** task-sizing-skill and atomic-task-decomposition-skill.

**Rule connection:** P10, DR018, H6, Card 004 (critical path).

**Source:** Módulo 04 — Análise Estruturada (cohesion/coupling) applied to task planning.
