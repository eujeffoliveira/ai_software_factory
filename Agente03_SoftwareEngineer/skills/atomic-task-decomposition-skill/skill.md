# Skill: atomic-task-decomposition-skill
## Agente03 Software Engineer / Task Planner

---

## Purpose

Breaks a large architectural component or oversized candidate task into multiple atomic tasks, each with single responsibility, single file focus, and bounded context. Prevents context window exhaustion by ensuring no task exceeds M complexity before reaching a dev agent.

---

## When to Use

- An architectural component maps to more than one file
- A candidate task is estimated L or XL
- A task title cannot be expressed in ≤ 8 words without vagueness
- A task contains multiple verbs ("create AND validate AND persist")
- Triggered by `execution-plan-generation-skill` during Step 4 (initial decomposition)

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| component_name | Yes | Name of the component from Architecture.md |
| component_description | Yes | What the component does |
| files_affected | Yes | List of files this component touches |
| acceptance_criteria | Yes | PRD criteria that this component must satisfy |
| estimated_total_complexity | Yes | Initial complexity estimate (usually L or XL) |

Schema: `input.schema.json`

---

## Outputs

| Output | Description |
|--------|-------------|
| tasks[] | Array of atomic Task objects (each S or M complexity) |
| decomposition_rationale | Explanation of how the split was made |
| parent_component | Reference back to Architecture.md component name |

Schema: `output.schema.json`

---

## Procedure

1. **Identify single-responsibility units.** Read the component description. List every distinct responsibility (e.g., "define schema", "implement action", "render component", "write tests"). Each responsibility becomes a candidate task.

2. **Find natural file boundaries.** Each task should create or modify exactly one file. Group responsibilities by file: DB migration → one task, Prisma model → one task, Server Action → one task.

3. **Estimate size of each unit.** Use the sizing table:
   - S: ≤ 50 LOC, 1 file → fine
   - M: 50–150 LOC, 1–2 files → fine
   - L: 150–300 LOC → flag for review
   - XL: > 300 LOC → must split further

4. **Split any unit > 200 LOC.** If a single file still exceeds 200 LOC equivalent, look for natural split points: input validation function → separate task, DAL layer → separate task from action.

5. **Verify each piece is independently testable.** Can this task be unit-tested in isolation? If not, it likely needs to be split further or a shared dependency task identified.

6. **Assign task IDs and derive dependencies.** Each decomposed task gets a TASK-NNN ID. Set up `depends_on[]` relationships between the decomposed tasks (e.g., Server Action task depends on Prisma model task).

7. **Derive acceptance criteria per task.** Map the parent component's acceptance criteria to the individual tasks. Each task must have at least 1 criterion.

---

## Decomposition Patterns

**Pattern: Feature component → Infrastructure + Logic + UI + Test**

A "User Profile" feature decomposes to:
1. DB migration task (TASK-001)
2. Prisma model task (TASK-002)
3. Server Action task (TASK-003)
4. Server Component task (TASK-004)
5. Client Component task (TASK-005, if interactivity needed)
6. Test task (TASK-006)

**Pattern: API endpoint → Route Handler + Zod Schema + DAL Function**

A "GET /api/items" endpoint decomposes to:
1. Zod query schema task (can merge with Route Handler if small)
2. Route Handler task
3. DAL query function task (if complex query logic)

---

## Quality Gate Reference

Feeds into Gate 3 atomicity requirement. Every task produced by this skill must pass `checklists/task_atomicity_checklist.md`.

---

## Knowledge Access Policy

At runtime, this skill accesses only:
- `Agente03_SoftwareEngineer/knowledge/principles.md` — P1 (atomicity first)
- `Agente03_SoftwareEngineer/knowledge/heuristics.md` — H1 (task naming), H6 (3-file limit)
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` — Card001 (atomic task definition)
- `Agente03_SoftwareEngineer/context_view.md` — Golden Path file structure conventions
- `Agente03_SoftwareEngineer/checklists/task_atomicity_checklist.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any external source.
