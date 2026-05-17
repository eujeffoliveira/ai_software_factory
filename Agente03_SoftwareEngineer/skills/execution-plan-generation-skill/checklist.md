# Execution Plan Generation Skill — Checklist
## Agente03 Software Engineer / Task Planner

---

## Pre-Execution Checks

- [ ] Architecture.md is present and has a version number
- [ ] PRD.md is present and has acceptance criteria with IDs
- [ ] API_Contract.json is present and defines all endpoints
- [ ] DB schema is present (SQL or Prisma) and covers all tables
- [ ] Architecture_Decisions.md is present with ACCEPTED ADRs
- [ ] Gate 2 status is APPROVED (confirmed in Agente02 handoff package)
- [ ] PRD and Architecture.md are consistent — no conflicts found

---

## During Execution Checks

- [ ] Every architectural component from Architecture.md is mapped to at least 1 task
- [ ] Every API endpoint from API_Contract.json is covered by at least 1 task
- [ ] Every DB table from the schema is covered by both: a migration task AND a model task
- [ ] All tasks have a `file_path` — no nulls or empty strings
- [ ] `atomic-task-decomposition-skill` has been run for all multi-file components
- [ ] `task-sizing-skill` has been run — no XL tasks remain
- [ ] `acceptance-criteria-mapping-skill` has been run — no uncovered PRD criteria
- [ ] Security requirements applied per DR007–DR012 for all relevant tasks
- [ ] Test requirements assigned to all tasks
- [ ] `dependency-graph-skill` has been run — `has_cycles: false`
- [ ] `context-window-risk-analysis-skill` has been run — no CRITICAL risks
- [ ] `implementation-sequencing-skill` has produced Implementation_Sequence.md

---

## Post-Execution Checks

- [ ] Execution_Plan.json validates against `schemas/execution_plan.schema.json`
- [ ] All tasks in plan validate against `schemas/task.schema.json`
- [ ] `critical_path` array is populated (minItems: 1)
- [ ] `gate_status` is set to one of the 6 valid codes
- [ ] Task_Backlog.md has been produced
- [ ] Dependency_Graph.md has been produced with Mermaid chart
- [ ] Task_Handoff_Packages.md has been produced
- [ ] Handoff package JSON matches `handoff_schema.json`

---

## Runtime Knowledge Policy

This skill reads only from:
- `Agente03_SoftwareEngineer/knowledge/` (principles.md, heuristics.md, decision_rules.md, knowledge_cards.md)
- `Agente03_SoftwareEngineer/context_view.md`
- `Agente03_SoftwareEngineer/schemas/`
- Other skills in `Agente03_SoftwareEngineer/skills/`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any external source.
