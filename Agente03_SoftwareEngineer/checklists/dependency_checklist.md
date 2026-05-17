# Dependency Checklist
## Agente03 Software Engineer / Task Planner
## Version: 1.0.0

Run this checklist after building the full dependency graph and before writing Execution_Plan.json.
A dependency graph fails this checklist if ANY item is unchecked.

---

## Pre-Check: Graph Construction

- [ ] Adjacency list has been built from all `depends_on[]` arrays in the task list
- [ ] Every task in the plan has been included as a node in the graph
- [ ] Graph construction is complete (no tasks omitted)

---

## Dependency Declarations

### 1. All Dependencies Declared
- [ ] Every task that uses the output of another task has that task in `depends_on[]`
- [ ] Prisma model usage → depends on the Prisma schema task
- [ ] Server Action usage in a Server Component → Server Component depends on the Server Action task
- [ ] Shared type or interface imports → task depends on the task that defines that file
- [ ] Environment variable usage → task depends on the lib/env.ts config task (if not already present)

_Failure: Add missing depends_on entries. Rule: P3 — dependencies are explicit contracts._

### 2. No Circular Dependencies
- [ ] DFS cycle detection has been run on the full graph
- [ ] `has_cycles` result is `false`
- [ ] No task appears in its own transitive dependency chain

_Failure: Identify the cycle (A→B→C→A), determine which dependency is incorrect, break the cycle. If the cycle is architectural, escalate to Tech Lead. Rule: DR002._

### 3. Topological Sort is Valid
- [ ] Topological sort has been computed (Kahn's algorithm or DFS post-order)
- [ ] Every task appears exactly once in the topological order
- [ ] For every edge (A→B), A appears before B in the topological order
- [ ] The topological order has been recorded in `topological_order[]`

_Failure: Re-run topological sort. If sort fails, cycles are still present._

### 4. Each Dependency is Explicit (Not Implied)
- [ ] No two tasks are implicitly sequenced "because that's how it's usually done"
- [ ] Ordering assumptions are backed by actual output/input relationships
- [ ] If Task B runs after Task A purely out of habit (not necessity), document whether the dependency is real

_Failure: Remove spurious dependencies that are not based on actual data/file/sequential relationships._

### 5. No Task Depends on a Non-Existent Task
- [ ] Every entry in every `depends_on[]` array references a `task_id` that exists in the plan
- [ ] No orphaned references (e.g., depends_on: ["TASK-010"] when TASK-010 does not exist)
- [ ] All task IDs in depends_on follow TASK-NNN format

_Failure: Remove orphaned references or add the missing tasks. Rule: DR004 (all referenced tasks must exist)._

### 6. Dependency Type is Specified
- [ ] Each edge has a `dependency_type`: `sequential`, `data`, or `file`
- [ ] `sequential` — task B cannot start until task A is fully complete
- [ ] `data` — task B uses data models, types, or structures produced by task A
- [ ] `file` — task B imports or reads a file created by task A

_Failure: Assign dependency_type to each edge in dependency_graph.json._

---

## Graph Properties

### 7. Parallel Tracks Identified
- [ ] Groups of tasks with no mutual transitive dependencies have been identified
- [ ] Parallel tracks are documented in `parallel_tracks[]` in the plan and in Dependency_Graph.md
- [ ] At least one parallel track has been identified (if the plan has ≥ 4 tasks)

_Advisory (not blocking): If no parallel tracks exist in a plan with 6+ tasks, reconsider dependency structure._

### 8. Critical Path Computed
- [ ] Critical path (longest dependency chain by complexity weight) has been identified
- [ ] Critical path is recorded in `critical_path[]` in Execution_Plan.json
- [ ] Critical path length is documented in the handoff package

_Advisory: Critical path determines minimum delivery time. Report it accurately._

### 9. Mermaid Source Generated
- [ ] `mermaid_source` has been generated for Dependency_Graph.md
- [ ] All tasks appear as nodes in the Mermaid chart
- [ ] All dependency edges appear as arrows with labeled types
- [ ] Critical path nodes are styled differently (e.g., stroke-width:3px)
- [ ] Task types are color-coded (infrastructure/backend/frontend/testing)

_Advisory: Visual graph enables Tech Lead to spot issues quickly._

---

## Post-Check: Graph Artifact

- [ ] `dependency_graph.schema.json` validation passes for the produced graph object
- [ ] `has_cycles: false` is explicitly set in the graph object
- [ ] `topological_order` array is populated and matches graph structure
- [ ] Dependency_Graph.md file is produced using the template

---

## Result

- **PASS:** All items checked → Dependency graph is valid; proceed to implementation-sequencing-skill
- **FAIL:** One or more items unchecked → Fix the dependency issue before proceeding

_A plan with dependency failures may NOT be submitted to Gate 3._
