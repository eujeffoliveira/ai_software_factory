# Context Window Risk Analysis Skill — Checklist
## Agente03 Software Engineer / Task Planner

---

## Pre-Execution

- [ ] Full Execution_Plan.json is available for analysis
- [ ] task-sizing-skill has already been run (complexity grades are set)

---

## XL Task Check

- [ ] Every task has been checked for XL complexity
- [ ] `xl_tasks` array in output is empty (xl_tasks_count = 0)
- [ ] If any XL task found: plan is flagged as NOT gate_ready before anything else

---

## L Task Check

- [ ] All tasks with estimated_complexity == "L" are listed in `l_tasks_flagged`
- [ ] Each L task has been checked for `context_summary` field
- [ ] L tasks without context_summary have `mitigation_applied: false` and a recommendation

---

## Per-Task Risk Scoring

- [ ] Risk factors evaluated for every task in the plan
- [ ] Scores assigned correctly per the risk scoring table in skill.md
- [ ] Tasks with risk_score ≥ 5 (HIGH or CRITICAL) have explicit recommendations

---

## Plan-Level Assessment

- [ ] `risk_level` reflects the highest individual task risk level
- [ ] `gate_ready` is false if risk_level is CRITICAL or xl_tasks is non-empty
- [ ] `overall_recommendation` is specific (not just "fix issues")

---

## Mitigation Verification

- [ ] All tasks with missing file_path have been flagged (risk factor +3)
- [ ] All L tasks without context_summary have been flagged (+1)
- [ ] All M+ tasks without function_signatures have been flagged (+1)

---

## Runtime Knowledge Policy

This skill reads only from:
- `Agente03_SoftwareEngineer/knowledge/principles.md` (P2)
- `Agente03_SoftwareEngineer/knowledge/decision_rules.md` (DR001, DR011)
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` (Card003)
- `Agente03_SoftwareEngineer/context_view.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`
