# Fabric Data Engineering Spec

## Solution Context

| Field | Value |
|-------|-------|
| Business purpose | |
| Fabric workspace/domain | |
| Source systems | |
| Target items | |
| SLA | |

## Workload Selection

| Workload | Use | Rationale |
|----------|-----|-----------|
| Dataflow Gen2 / Pipeline / Notebook / KQL / T-SQL / Eventstream / Activator | | |

## Load Pattern

| Field | Value |
|-------|-------|
| Pattern | full / incremental / streaming / hybrid |
| Cursor/watermark/checkpoint | |
| Idempotency strategy | |
| Late-arriving data policy | |
| Duplicate policy | |
| Failure disposition | retry / quarantine / dead-letter / block |

## Data Layers

| Layer | Contract | Storage | Quality rules |
|-------|----------|---------|---------------|
| Bronze | raw lineage-preserving | | |
| Silver | cleaned typed deduplicated | | |
| Gold | business-ready analytics | | |

## Orchestration

- Trigger:
- Schedule:
- Parameters:
- Dependencies:
- Retry/timeout:
- Recovery/resume:

## Monitoring and Optimization

- Run log:
- Alerts:
- Item-specific error handling:
- Optimization targets:

## Security and Lifecycle

- Workspace/item access:
- OneLake security:
- Row/column/object/file controls:
- Sensitivity labels:
- Audit logs:
- Deployment/versioning:
- Rollback:
