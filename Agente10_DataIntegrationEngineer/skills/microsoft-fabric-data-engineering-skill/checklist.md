# Microsoft Fabric Data Engineering Checklist

- [ ] Fabric workload selected with rationale.
- [ ] Storage/serving target selected with ownership assumptions.
- [ ] Full, incremental, streaming, or hybrid load pattern selected.
- [ ] Cursor, watermark, checkpoint, or idempotency key defined.
- [ ] Duplicate, missing, malformed, and late-arriving data policies defined.
- [ ] Retry, timeout, failure disposition, and recovery behavior defined.
- [ ] Bronze/silver/gold contracts defined when medallion architecture is used.
- [ ] Trigger, schedule, parameters, dynamic expressions, dependencies, and audit logs documented.
- [ ] Monitoring covers ingestion, transformation, semantic refresh, and Fabric item failures.
- [ ] Optimization target is identified from evidence.
- [ ] Workspace, item, OneLake, row/column/object/file, masking, labels, audit logs, deployment, and rollback are documented.
