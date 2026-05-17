# Skill: task-sizing-skill
## Agente03 Software Engineer / Task Planner

---

## Purpose

Estimates the implementation complexity of each task in terms of LOC equivalent, file count, and dependency depth. Flags tasks that would exceed a dev agent's context window budget. Produces per-task complexity grades and plan-level risk assessment.

---

## When to Use

- After initial task definition and before finalizing dependencies
- When re-evaluating a decomposed task set
- Whenever a task is suspected of being too large
- As part of the `execution-plan-generation-skill` workflow (Step 4 and Step 5)

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| tasks | Yes | Array of task objects with file_path and function_signatures |

Schema: `input.schema.json`

---

## Outputs

| Output | Description |
|--------|-------------|
| tasks[] | Task list annotated with complexity and context_window_risk |
| total_plan_complexity | Overall plan complexity grade |
| xl_tasks_count | Count of XL tasks (must be 0 for Gate 3) |
| warnings[] | List of L tasks with mitigation notes |

Schema: `output.schema.json`

---

## Sizing Criteria

| Grade | LOC Equivalent | File Count | Dependency Depth | Context Risk | Action |
|-------|---------------|------------|-----------------|--------------|--------|
| S | ≤ 50 | 1 | ≤ 2 | none | Proceed |
| M | 50–150 | 1–2 | ≤ 4 | low | Proceed |
| L | 150–300 | 2–3 | ≤ 6 | medium | Flag + add context_summary |
| XL | > 300 | > 3 | > 6 | critical | BLOCK — must split |

**LOC Equivalent Heuristics (for estimation without counting):**

| Task Type | Typical Range |
|-----------|--------------|
| DB migration (simple table) | 10–30 LOC → S |
| Prisma model (5–10 fields) | 20–50 LOC → S |
| Server Action (CRUD, with Zod) | 60–120 LOC → M |
| Route Handler (GET with pagination) | 60–100 LOC → M |
| Server Component (data fetch + render) | 50–100 LOC → M |
| Client Component (form with validation) | 80–150 LOC → M |
| NextAuth config | 100–200 LOC → M/L |
| Vitest unit test file | 80–200 LOC → M/L |
| Playwright E2E spec | 60–150 LOC → M |

---

## Procedure

1. For each task, gather: file_path, function_signatures count, type, depends_on length.
2. Estimate LOC based on type heuristics above.
3. Count files (usually 1 per task; if function_signatures span multiple files, that's a red flag).
4. Count dependency depth (length of depends_on chain).
5. Assign complexity grade.
6. For L tasks: write a warning with suggested mitigation.
7. For XL tasks: generate a split recommendation.
8. Calculate xl_tasks_count. If > 0, gate_ready must be false.

---

## Quality Gate Reference

Gate 3 blocks on any XL task. L tasks generate warnings but do not block (they require `context_summary` annotation).

---

## Knowledge Access Policy

At runtime, this skill accesses only:
- `Agente03_SoftwareEngineer/knowledge/principles.md` — P2 (context window as resource)
- `Agente03_SoftwareEngineer/knowledge/decision_rules.md` — DR001, DR011
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` — Card003 (context window budget)
- `Agente03_SoftwareEngineer/context_view.md` — complexity thresholds

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any external source.
