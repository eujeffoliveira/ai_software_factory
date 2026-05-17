# Atomic Task Decomposition Skill — Checklist
## Agente03 Software Engineer / Task Planner

---

## Pre-Execution

- [ ] Component name and description from Architecture.md are available
- [ ] Files affected list is complete (all files the component touches)
- [ ] PRD acceptance criteria for this component are identified
- [ ] Initial complexity estimate has been assessed

---

## During Execution

- [ ] All single-responsibility units within the component have been identified
- [ ] Each responsibility has been mapped to exactly one file
- [ ] No file appears in more than one task (unless the file is being created in one task and modified in a later task — which requires a data dependency)

---

## Output Checks — Per Task

For each task produced:

- [ ] Task has exactly ONE `file_path`
- [ ] Task has a single responsibility (describable in ≤ 8 words)
- [ ] Task is independently testable (can be unit or integration tested without the full app)
- [ ] Task's `estimated_complexity` is S or M (not L or XL)
- [ ] Task has at least one acceptance criterion derived from the parent component's criteria
- [ ] Task's `depends_on[]` relationships within the decomposed set are correctly declared

---

## Output Checks — Overall

- [ ] All input `acceptance_criteria` are covered by at least one output task (`coverage_confirmed: true`)
- [ ] No XL tasks in the output (`xl_eliminated: true`)
- [ ] `decomposition_rationale` explains the split decisions
- [ ] `parent_component` is set correctly

---

## Escalation Check

- [ ] If ANY component cannot be decomposed into atomic tasks without changing the architecture: STOP and escalate to Tech Lead before continuing
- [ ] The decomposition does not invent new architectural components not in Architecture.md

---

## Runtime Knowledge Policy

This skill reads only from:
- `Agente03_SoftwareEngineer/knowledge/principles.md` (P1 atomicity)
- `Agente03_SoftwareEngineer/knowledge/heuristics.md` (H1, H6)
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` (Card001)
- `Agente03_SoftwareEngineer/context_view.md` (complexity thresholds, file structure)
- `Agente03_SoftwareEngineer/checklists/task_atomicity_checklist.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`
