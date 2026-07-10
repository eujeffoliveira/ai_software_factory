# Good Output

## Fabric Analytics Decisions

Asset decisions:

- Lakehouse is the curated storage for Delta tables.
- Warehouse is used for SQL-serving dimensional marts.
- Semantic model is the governed contract for reports.

Semantic model:

- Direct Lake preferred; fallback behavior must be tested.
- Star schema required for sales analytics.
- Incremental refresh required for historical partitions.

Governance:

- Workspace and item access separated.
- RLS and sensitivity labels required.
- Downstream impact analysis required before changes to gold tables.

Routing:

- Agente10 owns lakehouse/warehouse implementation.
- Agente11 owns semantic model requirements and metric definitions.
