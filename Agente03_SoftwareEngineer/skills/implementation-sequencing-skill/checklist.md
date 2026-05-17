# Implementation Sequencing Skill — Checklist
## Agente03 Software Engineer / Task Planner

---

## Pre-Execution

- [ ] Topological order has been computed by dependency-graph-skill
- [ ] has_cycles is false (cycle check passed)
- [ ] All tasks are sized S, M, or L (no XL)

---

## Phase Assignment Checks

- [ ] All `database` and `infrastructure` and `config` tasks are in Phase 1
- [ ] All `backend` and `security` tasks are in Phase 2
- [ ] All `frontend` tasks are in Phase 3
- [ ] All `testing` tasks are in Phase 4 (or colocated in Phase 2 for TDD — annotated explicitly)
- [ ] No Phase 2+ task depends on an incomplete Phase 1 task

---

## Ordering Checks

- [ ] Phase sequence respects topological order from dependency-graph-skill
- [ ] Implementation_Sequence.md order does NOT contradict the topological sort
- [ ] Frontend tasks do not precede their backend dependencies in the sequence

---

## Parallelism Checks

- [ ] Parallel groups within phases match the parallel_tracks from dependency-graph-skill
- [ ] Parallelism annotations in Implementation_Sequence.md are accurate
- [ ] At least one parallel opportunity has been identified (if plan has 4+ tasks)

---

## Output Checks

- [ ] Implementation_Sequence.md is produced using the template
- [ ] Phase completion criteria are defined for each phase
- [ ] estimated_total_sessions and critical_path_sessions are set

---

## Runtime Knowledge Policy

This skill reads only from:
- `Agente03_SoftwareEngineer/knowledge/principles.md` (P5)
- `Agente03_SoftwareEngineer/knowledge/heuristics.md` (H2)
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` (Card005)
- `Agente03_SoftwareEngineer/context_view.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`
