# Bad Output — Dependency Graph Skill

## Scenario: Graph with circular dependency

**Graph (broken):**

TASK-A depends on TASK-C
TASK-B depends on TASK-A
TASK-C depends on TASK-B
→ TASK-A → TASK-B → TASK-C → TASK-A (CYCLE!)

**DFS result:** has_cycles = TRUE

**What happens:**
- Kahn's algorithm: TASK-A, TASK-B, TASK-C all have in-degree > 0 after initialization
- None can ever be added to the processing queue
- Topological sort cannot complete
- Implementation is impossible — no valid starting point exists

**Correct Response from the Skill:**

```json
{
  "graph_id": "graph-broken",
  "has_cycles": true,
  "topological_order": [],
  "critical_path": [],
  "cycle_details": ["TASK-A", "TASK-B", "TASK-C", "TASK-A"],
  "edges": [
    { "from_task": "TASK-A", "to_task": "TASK-B", "dependency_type": "sequential" },
    { "from_task": "TASK-B", "to_task": "TASK-C", "dependency_type": "sequential" },
    { "from_task": "TASK-C", "to_task": "TASK-A", "dependency_type": "sequential" }
  ]
}
```

**Gate 3 verdict:** BLOCKED_AMBIGUOUS_DEPENDENCY

**Wrong response (BAD):** Producing a topological_order that ignores the cycle and pretending has_cycles is false. This would cause the plan to reach dev agents in an invalid state, causing implementation failures.
