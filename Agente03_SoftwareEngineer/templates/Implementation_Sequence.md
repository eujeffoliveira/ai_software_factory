# Implementation Sequence
## Project: [Project Name]
## Plan ID: [plan-id]
## Total Estimated Sessions: [N]
## Critical Path Sessions: [N]

---

## Overview

The implementation sequence follows the topological sort of the dependency graph, grouped into 4 phases. Tasks within a phase that have no mutual dependencies can be executed in parallel.

```
Phase 1: Infrastructure  ──► Phase 2: Backend Core  ──► Phase 3: Frontend  ──► Phase 4: Testing & Integration
DB migrations                 Server Actions              Server Components        Vitest unit tests
Prisma schema                 Route Handlers              Client Components        Vitest integration tests
lib/env.ts                    NextAuth config             Pages                    Playwright E2E tests
proxy.ts                      DAL functions               UI forms
guardCron setup               Zod schemas
```

---

## Phase 1 — Infrastructure

**Objective:** Establish the data layer and infrastructure foundation. All subsequent phases depend on Phase 1.

**Rule:** No Phase 2+ task may start until all Phase 1 tasks are complete (or confirmed not needed by a Phase 2 task).

| Task ID | Title | Type | Complexity | Dependencies | Parallel With |
|---------|-------|------|-----------|--------------|--------------|
| TASK-001 | [Create [entity] migration] | database | S | — | TASK-00N (if independent) |
| TASK-002 | [Define [Entity] Prisma model] | database | S | TASK-001 | — |
| TASK-00N | [Setup lib/env.ts] | config | S | — | TASK-001 |
| TASK-00N | [Setup proxy.ts] | infrastructure | S | — | TASK-001 |

**Phase 1 Completion Criteria:**
- [ ] All database migrations have been applied (`prisma migrate deploy` succeeded)
- [ ] Prisma schema models are defined and `prisma generate` succeeds
- [ ] `lib/env.ts` is configured with all required environment variables
- [ ] TypeScript compilation succeeds

**Parallelization Notes:**
- TASK-001 and any infrastructure config tasks that do not depend on the DB can run in parallel
- TASK-002 must follow TASK-001 (requires migration to be applied first)

---

## Phase 2 — Backend Core

**Objective:** Implement all server-side business logic, data access, and API surface.

**Start Condition:** All Phase 1 tasks complete.

| Task ID | Title | Type | Complexity | Dependencies | Parallel With |
|---------|-------|------|-----------|--------------|--------------|
| TASK-003 | [Implement create[Entity] Server Action] | backend | M | TASK-001, TASK-002 | TASK-004 |
| TASK-004 | [Implement GET /api/[entity] Route Handler] | backend | M | TASK-002 | TASK-003 |
| TASK-00N | [Configure NextAuth v5] | security | M | TASK-00N (env) | TASK-003, TASK-004 |

**Phase 2 Completion Criteria:**
- [ ] All Server Actions implemented and passing unit tests
- [ ] All Route Handlers implemented and responding correctly
- [ ] NextAuth configured and authentication flow verified
- [ ] All backend Zod schemas defined and validated
- [ ] audit_log entries are being written for all mutations

**Parallelization Notes:**
- Server Actions and Route Handlers that share only the Prisma model (not each other) can run in parallel
- NextAuth configuration can run in parallel with Server Action implementation if env vars are available

---

## Phase 3 — Frontend

**Objective:** Implement all UI components, pages, and client-side interactions.

**Start Condition:** Phase 2 tasks that this phase depends on must be complete (at minimum: relevant Server Actions and Route Handlers).

| Task ID | Title | Type | Complexity | Dependencies | Parallel With |
|---------|-------|------|-----------|--------------|--------------|
| TASK-005 | [[Entity]List Server Component] | frontend | M | TASK-003 | TASK-007 (testing) |
| TASK-006 | [[Entity]Form Client Component] | frontend | S | TASK-005 | TASK-007 (testing) |
| TASK-00N | [[Entity] page.tsx] | frontend | S | TASK-005, TASK-006 | — |

**Phase 3 Completion Criteria:**
- [ ] All Server Components render correctly with real data
- [ ] All Client Components handle user interactions correctly
- [ ] All pages are accessible via correct URL routes
- [ ] UI adheres to Tailwind CSS v4 conventions
- [ ] Data fetching uses correct method (Server Component > Server Action > SWR)

**Parallelization Notes:**
- Frontend tasks can begin as soon as their specific Server Action dependency is complete
- A frontend developer can start TASK-005 while backend developer completes TASK-004

---

## Phase 4 — Testing & Integration

**Objective:** Implement all automated tests and perform integration verification.

**Start Condition:** The tasks each test depends on must be complete.

| Task ID | Title | Type | Complexity | Tests | Tool | Dependencies |
|---------|-------|------|-----------|-------|------|--------------|
| TASK-007 | [Vitest unit tests for [entity] actions] | testing | M | unit + integration | Vitest | TASK-003, TASK-004 |
| TASK-008 | [Playwright E2E: [entity] creation flow] | testing | M | E2E | Playwright | TASK-005, TASK-006 |

**Phase 4 Completion Criteria:**
- [ ] All unit tests passing (coverage targets met)
- [ ] All integration tests passing (against real test database)
- [ ] All E2E tests passing (against dev/staging environment)
- [ ] No test-only code leaked into production files
- [ ] Test coverage report generated

**Parallelization Notes:**
- TASK-007 and TASK-008 can run in parallel as they depend on different parts of the application
- Unit tests for backend components can be written during Phase 2 as development progresses (co-located development recommended)

---

## Full Implementation Order (Topological Sort)

```
TASK-001 → TASK-002 → TASK-003 → TASK-004 → TASK-005 → TASK-006 → TASK-007 → TASK-008
```

With parallelism:
```
TASK-001
   ↓
TASK-002
   ↓           ↓
TASK-003    TASK-004  (parallel)
   ↓           
TASK-005
   ↓
TASK-006
   ↓           ↓
TASK-007    TASK-008  (parallel)
```

---

## Session Estimates

| Phase | Tasks | Estimated Sessions |
|-------|-------|-------------------|
| Phase 1: Infrastructure | [N] | [N] |
| Phase 2: Backend Core | [N] | [N] |
| Phase 3: Frontend | [N] | [N] |
| Phase 4: Testing | [N] | [N] |
| **Total (sequential)** | **[N]** | **[N]** |
| **Total (with parallelism)** | **[N]** | **[N]** |

---

## Notes

- Parallelism estimates assume two dev agents (backend + frontend) working simultaneously
- Session counts assume each M-complexity task requires 1 dev session
- L-complexity tasks may require 2 sessions — annotated in individual task definitions
- Replace all `[entity]`, `[Entity]`, `[title]`, and `[N]` placeholders with actual values
