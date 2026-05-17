# Skill: dependency-graph-skill
## Agente03 Software Engineer / Task Planner

---

## Purpose

Maps the dependencies between all tasks, validates that the dependency graph is acyclic, computes the topological sort, identifies parallel tracks, and determines the critical path. Produces the Dependency_Graph.md artifact.

---

## When to Use

- After the complete task list is defined (all tasks from all components)
- Before writing Execution_Plan.json
- When validating a revised plan after a gate return

---

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| tasks | Yes | Array of task objects, each with task_id and depends_on[] |

Schema: `input.schema.json`

---

## Outputs

| Output | Description |
|--------|-------------|
| graph_id | Unique graph identifier |
| edges[] | Directed edges with dependency_type |
| topological_order[] | Safe implementation order |
| parallel_tracks[] | Groups of tasks that can run concurrently |
| critical_path[] | Longest dependency chain |
| has_cycles | Boolean — must be false for valid plan |
| mermaid_source | Mermaid flowchart source code |

Schema: `output.schema.json`

---

## Procedure

1. **Build adjacency list.** For each task with `depends_on: [TASK-X, TASK-Y]`, create directed edges: TASK-X→current, TASK-Y→current.

2. **Detect cycles (DFS).** Run Depth-First Search. Track:
   - `visited[]` — fully processed nodes
   - `rec_stack[]` — nodes in the current recursion stack
   - If a node in `rec_stack` is visited again → back edge → cycle detected

3. **If cycle detected:** Set `has_cycles: true`. Identify the cycle (list the tasks involved). Block the plan. Escalate to Tech Lead per DR002. Do not produce a topological order.

4. **Compute topological sort (Kahn's algorithm):**
   - Compute in-degree for each node
   - Add all nodes with in-degree 0 to queue
   - Process queue: dequeue node, add to order, decrement in-degree of neighbors
   - If queue empties before all nodes processed → cycle (confirms Step 2 result)

5. **Identify parallel tracks.**
   - For each node, compute its set of transitive dependencies
   - Two nodes are in the same parallel track if neither is in the other's transitive dependency set
   - Group into parallel track arrays

6. **Identify critical path.**
   - Assign complexity weights: S=1, M=2, L=3
   - For each node, compute longest path from any root to that node (dynamic programming)
   - Trace back from the node with the highest path weight to find the critical path

7. **Generate Mermaid source.** Produce flowchart TD with:
   - Nodes labeled: `TASK-NNN["TASK-NNN\nTitle\n[type / complexity]"]`
   - Edges labeled with dependency_type
   - Critical path nodes styled with stroke-width:3px
   - Node types color-coded

---

## Quality Gate Reference

Gate 3 requires `has_cycles: false`. The topological order in the output must match what is used in Implementation_Sequence.md.

---

## Knowledge Access Policy

At runtime, this skill accesses only:
- `Agente03_SoftwareEngineer/knowledge/principles.md` — P3, P5
- `Agente03_SoftwareEngineer/knowledge/decision_rules.md` — DR002, DR009
- `Agente03_SoftwareEngineer/knowledge/knowledge_cards.md` — Card002 (dependency graph), Card004 (critical path)
- `Agente03_SoftwareEngineer/context_view.md`
- `Agente03_SoftwareEngineer/checklists/dependency_checklist.md`

**Never reads at runtime:** `context/`, `lib/`, `*.pdf`, any external source.
