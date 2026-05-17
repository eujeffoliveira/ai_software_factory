# Dependency Graph
## Project: [Project Name]
## Graph ID: [graph-id]
## Plan ID: [plan-id]
## Generated: [ISO 8601 timestamp]

---

## Summary

| Metric | Value |
|--------|-------|
| Total Nodes | [N] |
| Total Edges | [N] |
| Has Cycles | false |
| Critical Path Length | [N] tasks |
| Parallel Tracks | [N] |
| Topological Order Valid | true |

---

## Dependency Graph (Mermaid)

```mermaid
flowchart TD
    TASK001["TASK-001\nCreate [entity] migration\n[database/S]"]
    TASK002["TASK-002\nDefine [Entity] Prisma model\n[database/S]"]
    TASK003["TASK-003\nImplement create[Entity] Server Action\n[backend/M]"]
    TASK004["TASK-004\nImplement GET /api/[entity] Route Handler\n[backend/M]"]
    TASK005["TASK-005\n[Entity]List Server Component\n[frontend/M]"]
    TASK006["TASK-006\n[Entity]Form Client Component\n[frontend/S]"]
    TASK007["TASK-007\nVitest unit tests for [entity] actions\n[testing/M]"]
    TASK008["TASK-008\nPlaywright E2E: [entity] creation flow\n[testing/M]"]

    TASK001 -->|"data"| TASK002
    TASK002 -->|"data"| TASK003
    TASK002 -->|"data"| TASK004
    TASK003 -->|"sequential"| TASK005
    TASK003 -->|"sequential"| TASK007
    TASK004 -->|"sequential"| TASK007
    TASK005 -->|"sequential"| TASK006
    TASK005 -->|"sequential"| TASK008
    TASK006 -->|"sequential"| TASK008

    classDef infrastructure fill:#e8f5e9,stroke:#388e3c
    classDef backend fill:#e3f2fd,stroke:#1976d2
    classDef frontend fill:#fce4ec,stroke:#c62828
    classDef testing fill:#fff8e1,stroke:#f57f17
    classDef critical stroke:#d32f2f,stroke-width:3px

    class TASK001,TASK002 infrastructure
    class TASK003,TASK004 backend
    class TASK005,TASK006 frontend
    class TASK007,TASK008 testing
    class TASK001,TASK002,TASK003,TASK005,TASK008 critical
```

---

## Task Dependency Table

| Task ID | Task Title | Type | Depends On | Dependency Type | Can Run In Parallel With |
|---------|-----------|------|------------|----------------|--------------------------|
| TASK-001 | [title] | database | — | — | — |
| TASK-002 | [title] | database | TASK-001 | data | — |
| TASK-003 | [title] | backend | TASK-002 | data | — |
| TASK-004 | [title] | backend | TASK-002 | data | TASK-003 |
| TASK-005 | [title] | frontend | TASK-003 | sequential | TASK-004, TASK-007 |
| TASK-006 | [title] | frontend | TASK-005 | file | TASK-007 |
| TASK-007 | [title] | testing | TASK-003, TASK-004 | sequential | TASK-005, TASK-006 |
| TASK-008 | [title] | testing | TASK-005, TASK-006 | sequential | TASK-007 |

---

## Parallel Tracks

| Track Name | Tasks | Start Condition |
|-----------|-------|----------------|
| Backend Track | TASK-003, TASK-004 | After TASK-002 complete |
| Frontend Track | TASK-005, TASK-006 | After TASK-003 complete |
| Testing Track | TASK-007, TASK-008 | TASK-007 after TASK-003+004; TASK-008 after TASK-005+006 |

---

## Critical Path

```
TASK-001 → TASK-002 → TASK-003 → TASK-005 → TASK-008
```

**Critical Path Details:**

| # | Task ID | Title | Complexity | Cumulative Weight |
|---|---------|-------|-----------|-----------------|
| 1 | TASK-001 | [title] | S | 1 |
| 2 | TASK-002 | [title] | S | 2 |
| 3 | TASK-003 | [title] | M | 4 |
| 4 | TASK-005 | [title] | M | 6 |
| 5 | TASK-008 | [title] | M | 8 |

---

## Topological Order (Implementation Order)

```
TASK-001, TASK-002, TASK-003, TASK-004, TASK-005, TASK-006, TASK-007, TASK-008
```

---

## Notes

- TASK-003 and TASK-004 can be developed in parallel after TASK-002 is complete
- Testing tasks should be started as soon as their dependencies are available — do not defer to end
- Replace all `[entity]`, `[Entity]`, and `[title]` placeholders with actual values
