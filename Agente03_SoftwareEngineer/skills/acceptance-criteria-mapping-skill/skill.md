# Skill: acceptance-criteria-mapping-skill
## Agente03 Software Engineer / Task Planner

---

## Purpose

Maps every PRD acceptance criterion to at least one task, ensuring full traceability from requirements to implementation. Ensures every task has at least one testable acceptance criterion. Produces a coverage matrix as proof of completeness.

---

## When to Use

- During task definition, after initial decomposition (Step 6 of execution-plan-generation-skill)
- Before finalizing Execution_Plan.json
- After any task is added or removed (to re-verify coverage)

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| prd_acceptance_criteria | Yes | Array of PRD criteria with criterion_id, description, story_id |
| tasks | Yes | Array of tasks with task_id, title, type |

Schema: `input.schema.json`

---

## Outputs

| Output | Description |
|--------|-------------|
| tasks_with_criteria | Task list with acceptance_criteria[] populated |
| coverage_matrix | Mapping of each PRD criterion to covering task IDs |
| uncovered_criteria | Criteria with no covering task (must be empty at Gate 3) |

Schema: `output.schema.json`

---

## Procedure

1. **Enumerate all PRD acceptance criteria.** Read PRD.md acceptance criteria section. Extract criterion_id, description, story_id for each.

2. **Map each criterion to tasks.** For each PRD criterion:
   - Identify which component implements it
   - Identify which task within that component is the primary implementer
   - Assign the criterion to that task

3. **Write testable task-level criteria.** PRD criteria are often feature-level ("user can create a task"). Task-level criteria should be more specific ("function validates title length with Zod, returns error on title < 3 chars").

4. **Assign verification_method.** For each criterion: unit-test, integration-test, e2e-test, or manual-review.

5. **Build coverage_matrix.** Map each PRD criterion_id to covering task_id(s).

6. **Check for uncovered criteria.** Any PRD criterion with no covering task → must add task or escalate.

7. **Check each task has ≥1 criterion.** Any task with empty acceptance_criteria → derive criteria from component behavior in Architecture.md.

---

## Quality Gate Reference

Gate 3 blocks if `uncovered_criteria` is non-empty. Every PRD criterion must be covered.

---

## Knowledge Access Policy

At runtime, this skill accesses only:
- `Agente03_SoftwareEngineer/knowledge/principles.md` — P4 (traceability from requirements)
- `Agente03_SoftwareEngineer/knowledge/decision_rules.md` — DR003
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` — Card006 (task traceability)
- `Agente03_SoftwareEngineer/context_view.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any external source.
