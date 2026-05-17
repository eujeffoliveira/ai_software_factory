# Acceptance Criteria Mapping Skill — Checklist
## Agente03 Software Engineer / Task Planner

---

## Pre-Execution

- [ ] All PRD acceptance criteria from PRD.md have been enumerated with unique IDs
- [ ] Task list is complete (all tasks defined before mapping)

---

## Mapping Checks

- [ ] Every PRD acceptance criterion appears in the coverage_matrix
- [ ] Every PRD acceptance criterion is covered by at least 1 task_id in coverage_matrix
- [ ] `uncovered_criteria` is empty (all criteria covered)
- [ ] Every task has at least 1 acceptance criterion in acceptance_criteria[]

---

## Quality Checks

- [ ] Each acceptance criterion is specific and testable (not "it works")
- [ ] Each criterion has an implied or explicit verification_method
- [ ] No duplicate criteria across multiple tasks (unless different verification layers are genuinely needed)
- [ ] Criteria for backend tasks are unit/integration testable
- [ ] Criteria for frontend tasks include observable UI behaviors

---

## Escalation Check

- [ ] If any PRD criterion cannot be covered by any existing task AND cannot be covered without new architecture: escalate to Tech Lead
- [ ] DR003: uncovered_criteria must be empty before Gate 3

---

## Runtime Knowledge Policy

This skill reads only from:
- `Agente03_SoftwareEngineer/knowledge/principles.md` (P4)
- `Agente03_SoftwareEngineer/knowledge/decision_rules.md` (DR003)
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` (Card006)
- `Agente03_SoftwareEngineer/context_view.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`
