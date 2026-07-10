# Microsoft Fabric Data Engineering DP-700 Distilled Knowledge

Source: local Microsoft Learn study package collected on 2026-07-08 for DP-700.

## Scope

DP-700 maps to data engineering in Microsoft Fabric: workspace configuration, OneLake, Spark, lakehouse, Delta Lake, Dataflows Gen2, pipelines, Eventstream, Eventhouse/KQL, warehouse, CI/CD, monitoring, security, and performance optimization.

## Capability Areas

| Area | Weight | Runtime meaning for Agente10 |
|------|--------|------------------------------|
| Implement and manage an analytics solution | 30-35% | Workspace/Spark/domain/OneLake/Airflow settings, lifecycle, version control, database projects, deployment pipelines, security, governance, audit logs, OneLake security, orchestration. |
| Ingest and transform data | 30-35% | Full and incremental loads, batch and streaming patterns, dimensional load prep, storage choice, Dataflows Gen2, notebooks, KQL, T-SQL, OneLake shortcuts, mirroring, PySpark/SQL/KQL transformations, duplicates, missing data, late-arriving data, window functions. |
| Monitor and optimize | 30-35% | Monitor ingestion, transformation, semantic refresh, alerts, pipeline/Dataflow/notebook/Eventhouse/Eventstream/T-SQL/shortcut errors, optimize lakehouse tables, pipelines, warehouse, Eventstreams/Eventhouses, Spark, and query performance. |

## Fabric Workload Selection

- Dataflow Gen2: low-code ingestion/transformation, repeatable mapping, analyst-maintainable transformations.
- Pipeline: orchestration, movement, scheduling, dependencies, parameters, expressions, triggers, and cross-step coordination.
- Notebook/Spark: complex code transformations, scalable file processing, Delta table operations, and medallion processing.
- KQL/Eventhouse: real-time/event/time-series workloads and fast exploratory operational analytics.
- T-SQL/Warehouse: relational modeling, SQL-based load, dimensional serving, and warehouse query workloads.
- Eventstream: streaming ingestion/routing before real-time processing or activation.
- Activator: event-driven detection and action when business conditions occur.

## Load Pattern Rules

- Full load is acceptable for small, replaceable, or snapshot-friendly datasets.
- Incremental load is required when volume, latency, API limits, or history preservation make full reload unsafe.
- Streaming load requires explicit event-time, late-arriving-data, windowing, ordering, and deduplication strategy.
- Every Fabric load design must define idempotency, checkpoint/cursor/watermark, retry behavior, and failure disposition.

## Lakehouse and Delta Rules

- Use Delta tables for transactional reliability, schema evolution awareness, and optimized lakehouse querying.
- Use medallion architecture when raw, cleansed, and business-ready layers need separate contracts:
  - Bronze: raw, append-oriented, lineage-preserving.
  - Silver: cleaned, typed, deduplicated, validated.
  - Gold: business aggregates/dimensional outputs for analytics.
- OneLake shortcuts are references, not ownership transfer. Document source ownership, access, latency, and failure assumptions.

## Warehouse Rules

- Use Fabric warehouse when SQL-first dimensional modeling, T-SQL transformation, or relational serving is central.
- Monitor and optimize warehouse load, query performance, and security separately from lakehouse paths.
- Secure warehouses with workspace/item permissions plus row/column/object-level controls where applicable.

## Real-Time Rules

- Choose Eventstream for routing and processing event streams.
- Choose Eventhouse/KQL for event analytics and time-series querying.
- Use native tables vs shortcuts based on latency, ownership, query acceleration, and governance.
- Window functions and late-arriving data rules are part of the contract, not optional implementation details.

## Monitoring and Optimization Rules

- Monitor ingestion, transformation, semantic refresh, and each Fabric item type.
- Configure alerts for stale data, failed runs, unusual reject rates, queue/stream lag, and threshold breaches.
- Troubleshoot by item type: pipeline, Dataflow Gen2, notebook, Eventhouse, Eventstream, T-SQL, or OneLake shortcut.
- Optimize lakehouse tables, pipelines, warehouses, Eventstreams/Eventhouses, Spark jobs, and query patterns according to bottleneck evidence.

## Security and Lifecycle Rules

- Configure workspace, item, row, column, object, folder/file, masking, label, and OneLake security explicitly.
- Use audit logs for traceability.
- Use version control and deployment pipelines for managed Fabric lifecycle.
- Before deployment, document downstream dependencies and rollback strategy.
