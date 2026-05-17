# Bad Output — Implementation Sequencing Skill

## Frontend task before its backend dependency — broken sequence

**Bad sequence produced:**

Phase 1:
- TASK-005: Implement TaskList Server Component (frontend — WRONG, should be Phase 3)
- TASK-006: Implement TaskForm Client Component (frontend — WRONG, should be Phase 3)

Phase 2:
- TASK-001: Create tasks migration
- TASK-002: Define Task Prisma model

Phase 3:
- TASK-003: Implement createTask Server Action

## Problems

1. **Frontend tasks before infrastructure** — TASK-005 and TASK-006 are placed in Phase 1, before the DB migration and Prisma model even exist. The Server Component cannot call a Server Action that hasn't been created yet.

2. **Rule violation:** H2 — start with infrastructure and data layer. Everything else depends on it.

3. **Topological sort violated:** If TASK-005 depends on TASK-003 (Server Action), and TASK-003 depends on TASK-002 (Prisma model), then TASK-005 MUST come after TASK-002. Placing TASK-005 in Phase 1 violates the topological order.

4. **What would happen at runtime:** Agente05 would start implementing TaskList Server Component. The Server Action doesn't exist. TypeScript compilation fails. Work is wasted. The dev agent is blocked waiting for TASK-003 to complete.

## Correct Sequence

```
Phase 1: TASK-001, TASK-002 (Infrastructure)
Phase 2: TASK-003, TASK-004 (Backend, parallel)
Phase 3: TASK-005, TASK-006 (Frontend, sequential)
Phase 4: TASK-007, TASK-008 (Testing)
```
