# Task Sizing Skill — Checklist
## Agente03 Software Engineer / Task Planner

---

## Pre-Execution

- [ ] All tasks in the plan have a file_path (required to estimate file count)
- [ ] All tasks have a type (used for LOC heuristics)

---

## During Execution

- [ ] LOC estimate applied using type-based heuristics from context_view.md
- [ ] File count assessed per task (should be 1; >3 triggers XL)
- [ ] Dependency depth counted (depends_on chain length)
- [ ] Complexity grade assigned to each task (S/M/L/XL)

---

## Output Checks

- [ ] `xl_tasks_count` calculated and matches actual count of XL tasks in output
- [ ] All XL tasks have `split_recommendation` in their sizing output
- [ ] All L tasks have a warning entry in `warnings[]` with mitigation
- [ ] `total_plan_complexity` reflects the aggregate of all task complexities

---

## Gate Check

- [ ] `xl_tasks_count` = 0 (Gate 3 requires this)
- [ ] If xl_tasks_count > 0: plan is flagged as NOT gate_ready; split required per DR001

---

## Runtime Knowledge Policy

This skill reads only from:
- `Agente03_SoftwareEngineer/knowledge/principles.md` (P2)
- `Agente03_SoftwareEngineer/knowledge/decision_rules.md` (DR001, DR011)
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` (Card003)
- `Agente03_SoftwareEngineer/context_view.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`
