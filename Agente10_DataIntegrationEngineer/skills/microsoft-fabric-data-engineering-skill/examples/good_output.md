# Good Output

## Fabric Data Engineering Spec Summary

Workload selection:

- Pipeline orchestrates ingestion and dependencies.
- Notebook/Spark performs complex Delta transformations.
- Lakehouse stores bronze/silver/gold Delta tables.

Load pattern:

- Incremental load using source `updated_at` watermark.
- Idempotency via merge on source system ID plus effective timestamp.
- Late-arriving records are reprocessed for the last 3 days.

Monitoring:

- Alert on failed pipeline, stale watermark, reject rate above threshold, and Spark duration spike.

Security/lifecycle:

- Workspace and item access separated.
- OneLake security documented.
- Deployment pipeline and rollback plan required.
