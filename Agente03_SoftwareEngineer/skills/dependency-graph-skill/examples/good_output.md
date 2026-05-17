# Good Output — Dependency Graph Skill

## Scenario: 6-task plan with valid acyclic graph

**graph_id:** graph-taskflow-v1
**has_cycles:** false
**topological_order:** [TASK-001, TASK-002, TASK-003, TASK-004, TASK-005, TASK-006]
**critical_path:** [TASK-001, TASK-002, TASK-003, TASK-005]
**parallel_tracks:** [[TASK-003, TASK-004], [TASK-005, TASK-006]]

**edges:**
- TASK-001 → TASK-002 (data)
- TASK-002 → TASK-003 (data)
- TASK-002 → TASK-004 (data)
- TASK-003 → TASK-005 (sequential)
- TASK-004 → TASK-006 (sequential)

**Mermaid source:**
```mermaid
flowchart TD
    T001["TASK-001\nDB Migration\n[database/S]"]
    T002["TASK-002\nPrisma Model\n[database/S]"]
    T003["TASK-003\nServer Action\n[backend/M]"]
    T004["TASK-004\nRoute Handler\n[backend/M]"]
    T005["TASK-005\nServer Component\n[frontend/M]"]
    T006["TASK-006\nVitest Tests\n[testing/M]"]
    T001 -->|"data"| T002
    T002 -->|"data"| T003
    T002 -->|"data"| T004
    T003 -->|"sequential"| T005
    T004 -->|"sequential"| T006
    classDef critical stroke:#d32f2f,stroke-width:3px
    class T001,T002,T003,T005 critical
```

**Why this is good:**
- has_cycles: false (DFS found no back edges)
- Topological order is valid (TASK-001 before TASK-002, etc.)
- Parallel tracks correctly identified: TASK-003 and TASK-004 share only TASK-002 as dependency, no mutual dependency
- Critical path computed: TASK-001 (S=1) + TASK-002 (S=1) + TASK-003 (M=2) + TASK-005 (M=2) = weight 6
