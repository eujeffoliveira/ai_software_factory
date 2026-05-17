# Dependency Graph Skill — Checklist
## Agente03 Software Engineer / Task Planner

---

## Pre-Execution

- [ ] Complete task list (all tasks from all components) is available
- [ ] All tasks have task_id in TASK-NNN format
- [ ] All depends_on entries have been reviewed for plausibility

---

## Cycle Detection

- [ ] DFS has been run on the full adjacency list
- [ ] Result is `has_cycles: false`
- [ ] No back edges detected in DFS traversal
- [ ] If `has_cycles: true` was detected: cycle documented and plan BLOCKED before proceeding

---

## Topological Sort

- [ ] Kahn's algorithm (or DFS post-order) has been applied
- [ ] All task_ids appear exactly once in topological_order[]
- [ ] For every edge A→B, A appears before B in topological_order[]
- [ ] Topological order has been recorded in the plan

---

## Dependency Declarations

- [ ] Every entry in every depends_on[] references an existing task_id
- [ ] No orphaned task_id references (all referenced IDs exist in the task list)
- [ ] Each edge has a dependency_type assigned (sequential/data/file)

---

## Parallel Tracks and Critical Path

- [ ] Parallel tracks identified (tasks with no mutual transitive dependencies)
- [ ] Critical path computed (longest path by complexity weight)
- [ ] Both are recorded in the plan and in Dependency_Graph.md

---

## Mermaid Output

- [ ] All tasks appear as labeled nodes in mermaid_source
- [ ] All dependency edges appear as arrows with dependency_type labels
- [ ] Critical path nodes have distinct styling (stroke-width:3px)
- [ ] Task types are color-coded (infrastructure/backend/frontend/testing)

---

## Runtime Knowledge Policy

This skill reads only from:
- `Agente03_SoftwareEngineer/knowledge/principles.md` (P3, P5)
- `Agente03_SoftwareEngineer/knowledge/decision_rules.md` (DR002, DR009)
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` (Card002, Card004)
- `Agente03_SoftwareEngineer/context_view.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`
