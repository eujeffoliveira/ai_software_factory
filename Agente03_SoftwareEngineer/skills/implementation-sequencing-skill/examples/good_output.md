# Good Output — Implementation Sequencing Skill

## 3-phase sequence for TaskFlow example

**Phase 1 — Infrastructure (2 tasks, sequential)**
- TASK-001: Create tasks table migration
- TASK-002: Define Task Prisma model
- Completion criteria: migration applied, prisma generate succeeds

**Phase 2 — Backend Core (2 tasks, parallel)**
- TASK-003: Implement createTask Server Action
- TASK-004: Implement GET /api/tasks Route Handler
- Parallel: TASK-003 and TASK-004 can run simultaneously (both depend only on TASK-002)
- Completion criteria: Server Actions return correct responses, Route Handlers pass integration tests

**Phase 3 — Frontend + Testing (parallel across types)**
- Phase 3A (frontend): TASK-005 (TaskList Server Component) → TASK-006 (TaskForm Client Component)
- Phase 3B (testing, starts when TASK-003+004 done): TASK-007 (Vitest tests) — runs parallel to Phase 3A
- Phase 3C (E2E, starts when Phase 3A done): TASK-008 (Playwright E2E)

**estimated_total_sessions:** 8 (one per task, sequential)
**critical_path_sessions:** 6 (with backend/frontend parallelism)

**Why this is good:**
- Infrastructure always Phase 1
- Backend in Phase 2 before frontend (correct order)
- Parallelism correctly identified and annotated
- No frontend task placed before its backend dependency
