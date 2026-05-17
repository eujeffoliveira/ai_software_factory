# Skill: implementation-sequencing-skill
## Agente03 Software Engineer / Task Planner

---

## Purpose

Produces the final ordered implementation sequence by grouping topologically-sorted tasks into phases and annotating which tasks can run in parallel. Ensures the development team always builds in the correct order: infrastructure before logic before UI before tests.

---

## When to Use

- After `dependency-graph-skill` has validated the graph (has_cycles: false)
- After all tasks are sized (no XL tasks)
- As the final planning step before serializing Execution_Plan.json

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| topological_order | Yes | Ordered array of task IDs from dependency-graph-skill |
| parallel_tracks | Yes | Groups of task IDs that can run concurrently |
| tasks | Yes | Full task objects with type and complexity |

Schema: `input.schema.json`

---

## Outputs

| Output | Description |
|--------|-------------|
| phases[] | Implementation phases (1–4) with task groupings and parallelism |
| estimated_total_sessions | Total dev sessions (rough estimate) |
| critical_path_sessions | Sessions on the critical path |

Schema: `output.schema.json`

---

## Phase Rules (Mandatory)

**Phase 1 — Infrastructure**
- Types: `database`, `infrastructure`, `config`
- Examples: DB migrations, Prisma schema, `lib/env.ts`, `proxy.ts`, guardCron setup
- Rule: ALL Phase 1 tasks must complete before any Phase 2 task starts

**Phase 2 — Backend Core**
- Types: `backend`, `security`
- Examples: Server Actions, Route Handlers, NextAuth config, DAL functions, Zod schemas
- Rule: May start only after relevant Phase 1 dependencies are complete

**Phase 3 — Frontend**
- Types: `frontend`
- Examples: Server Components, Client Components, pages
- Rule: May start only after relevant Phase 2 (Server Actions) dependencies are complete

**Phase 4 — Testing & Integration**
- Types: `testing`
- Examples: Vitest unit tests, Vitest integration tests, Playwright E2E
- Rule: May start as soon as the tested task is complete (can run in parallel with Phase 3)
- Note: Unit tests can be co-located with Phase 2 development (TDD) if the team chooses

---

## Parallelism Rules

- Two tasks in the same phase can run in parallel if neither is in the other's `depends_on[]` (directly or transitively)
- Parallelism annotations in the sequence must match the `parallel_tracks[]` from dependency-graph-skill

---

## Quality Gate Reference

Sequence must align with the topological sort from dependency-graph-skill. Any implementation order that violates the topological sort is invalid and blocks Gate 3.

---

## Knowledge Access Policy

At runtime, this skill accesses only:
- `Agente03_SoftwareEngineer/knowledge/principles.md` — P5 (order follows dependency graph)
- `Agente03_SoftwareEngineer/knowledge/heuristics.md` — H2 (start with infrastructure)
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` — Card005 (execution phase model)
- `Agente03_SoftwareEngineer/context_view.md` — Golden Path stack phase rules

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any external source.
