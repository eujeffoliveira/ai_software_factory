# Fabric Data Engineering Checklist

## Workload Selection

- [ ] Dataflow Gen2, pipeline, notebook/Spark, KQL/Eventhouse, T-SQL/Warehouse, Eventstream, or Activator selected with rationale.
- [ ] Storage target selected: lakehouse, warehouse, Eventhouse, semantic model, shortcut, or mirrored source.
- [ ] Source ownership, latency, and access assumptions documented.

## Load and Transformation

- [ ] Load pattern selected: full, incremental, streaming, or hybrid.
- [ ] Cursor, watermark, checkpoint, or idempotency key defined.
- [ ] Duplicate, missing, late-arriving, and malformed data rules defined.
- [ ] Batch size, partitioning, retry, timeout, and failure disposition defined.
- [ ] Bronze/silver/gold contracts defined when medallion architecture is used.
- [ ] Delta table behavior and schema evolution assumptions documented.

## Orchestration

- [ ] Schedule, trigger, or event-based orchestration documented.
- [ ] Pipeline/notebook parameters and dynamic expressions documented.
- [ ] Dependencies and recovery/resume behavior documented.
- [ ] Audit and run logs specified.

## Monitoring and Optimization

- [ ] Monitoring covers ingestion, transformation, semantic refresh, and relevant Fabric items.
- [ ] Alerts cover failed runs, stale data, reject-rate spikes, stream lag, and SLA breaches.
- [ ] Optimization target identified: lakehouse table, pipeline, warehouse, Eventstream/Eventhouse, Spark, or query performance.

## Security and Lifecycle

- [ ] Workspace, item, row, column, object, folder/file, masking, labels, and OneLake security reviewed.
- [ ] Deployment pipeline or version control specified when lifecycle management matters.
- [ ] Downstream dependencies and rollback plan documented.
