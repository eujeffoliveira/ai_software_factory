# Skill: execution-plan-generation-skill
## Agente03 Software Engineer / Task Planner

---

## Purpose

Generates the complete `Execution_Plan.json` from an approved architecture package. This is the primary skill that orchestrates all other skills to produce the final plan artifact submitted to Gate 3.

---

## When to Use

- The architecture package from Agente02_SoftwareArchitect has Gate 2 status `APPROVED`
- All required inputs are present: Architecture.md, PRD.md, API_Contract.json, DB schema, Architecture_Decisions.md
- Triggered once per planning cycle; re-triggered when Gate 3 returns the plan for revision

---

## Inputs

| Input | Required | Source |
|-------|----------|--------|
| architecture_version | Yes | Architecture.md header |
| prd_version | Yes | PRD.md header |
| components | Yes | Architecture.md — list of all components |
| api_endpoints | Yes | API_Contract.json — all endpoint definitions |
| db_tables | Yes | DB schema — all tables/models |
| adrs | Yes | Architecture_Decisions.md — all ADRs |

Schema: `input.schema.json`

---

## Outputs

| Output | Format | Schema |
|--------|--------|--------|
| Execution_Plan.json | JSON | `schemas/execution_plan.schema.json` |
| plan_id | string | Generated UUID |
| tasks[] | Array | `schemas/task.schema.json` per item |
| critical_path[] | Array of TASK-NNN | — |
| gate_ready | boolean | true if all checks pass |

Schema: `output.schema.json`

---

## Procedure

1. **Read and validate all inputs.** Verify architecture_version, prd_version, components list, api_endpoints, db_tables, and adrs are all present and non-empty.

2. **Enumerate components.** From Architecture.md, list: all API routes, Server Actions, DB tables, Server Components, Client Components, cron jobs, configuration requirements.

3. **Decompose components to candidate tasks.** For each component, invoke `atomic-task-decomposition-skill`. Map each component to 1–N atomic tasks with `file_path`, `type`, and `layer`.

4. **Size all tasks.** Run `task-sizing-skill` on all candidate tasks. Any XL task: split immediately. Flag L tasks.

5. **Map acceptance criteria.** Run `acceptance-criteria-mapping-skill`. Ensure every PRD criterion is covered. Add task-level acceptance criteria.

6. **Assign security requirements.** For each task, evaluate per DR007–DR012:
   - User input → Zod validation (DR007)
   - Data mutation → audit_log (DR008)
   - Cron handler → guardCron() (DR012)
   - DB migration → prisma migrate deploy (DR013)
   - Frontend data fetching → correct method (DR014)

7. **Assign test requirements.** Vitest for unit/integration, Playwright for E2E. Coverage targets for backend tasks.

8. **Build dependency graph.** Run `dependency-graph-skill`. Detect cycles (must be 0). Compute topological sort. Identify parallel tracks and critical path.

9. **Run context window risk analysis.** Run `context-window-risk-analysis-skill`. Resolve any CRITICAL risks before continuing.

10. **Produce implementation sequence.** Run `implementation-sequencing-skill` to group tasks into 4 phases.

11. **Serialize Execution_Plan.json.** Write the full plan as JSON. Validate against `schemas/execution_plan.schema.json`.

12. **Set gate_status.** Evaluate all Gate 3 blocking conditions. Set to `APPROVED` if all pass, otherwise set the appropriate status code.

---

## Quality Gate Reference

Gate 3 — Execution Plan Review. All blocking conditions in `quality_gate.md` must be satisfied.

Key checks triggered by this skill:
- No XL tasks
- No circular dependencies
- All PRD criteria covered
- All tasks have file_path, acceptance_criteria, test_requirements, security_requirements

---

## Knowledge Access Policy

At runtime, this skill accesses only:
- `Agente03_SoftwareEngineer/knowledge/principles.md` — P1–P8
- `Agente03_SoftwareEngineer/knowledge/heuristics.md` — H1–H10
- `Agente03_SoftwareEngineer/knowledge/decision_rules.md` — DR001–DR014
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` — Card001–Card010
- `Agente03_SoftwareEngineer/context_view.md` — Golden Path stack, task schema
- `Agente03_SoftwareEngineer/schemas/` — for validation
- Other local skills in `Agente03_SoftwareEngineer/skills/`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any raw source file.
