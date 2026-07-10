# microsoft-fabric-data-engineering-skill

## Purpose

Design Microsoft Fabric data engineering specs for ingestion, transformation, orchestration, lakehouse, warehouse, Eventstream/Eventhouse, security, monitoring, and optimization.

## Trigger

Use this skill when the request mentions DP-700, Microsoft Fabric data engineering, Dataflow Gen2, pipelines, notebooks, Spark, PySpark, lakehouse, Delta Lake, medallion architecture, OneLake shortcuts, mirroring, Eventstream, Eventhouse, KQL, Fabric warehouse, CI/CD, audit logs, or Fabric monitoring.

## Inputs

- Integration or data pipeline requirement
- Source systems and target Fabric items
- Volume, latency, freshness, SLA, and security needs
- Batch, incremental, or streaming constraints

## Output

Produce or enrich `Fabric_Data_Engineering_Spec.md`, `Integration_Spec.md`, `Sync_Strategy.md`, and `Data_Quality_Checklist.md`.

## Procedure

1. Select the Fabric workload: Dataflow Gen2, pipeline, notebook/Spark, KQL/Eventhouse, T-SQL/Warehouse, Eventstream, or Activator.
2. Select storage and serving targets: lakehouse, warehouse, Eventhouse, semantic model, shortcut, or mirror.
3. Define load pattern: full, incremental, streaming, or hybrid.
4. Define cursor/watermark/checkpoint, idempotency, late-arriving data, duplicate handling, retry, timeout, and failure disposition.
5. Define bronze/silver/gold contracts when medallion architecture applies.
6. Define orchestration: trigger, schedule, dependencies, parameters, expressions, recovery, and audit logs.
7. Define monitoring, alerts, troubleshooting by item type, and optimization target.
8. Define security and lifecycle: workspace, item, row/column/object/file, masking, labels, OneLake security, version control, deployment pipeline, dependencies, rollback.

## Knowledge Access Policy

This skill may consult only `Agente10_DataIntegrationEngineer/` runtime-local files and project artifacts provided as input. It must not read `context/`, `lib/`, raw PDFs, external downloads, or another agent folder directly.

## Failure Handling

If workload selection, idempotency, monitoring, or security is unclear, block Gate 3.5 until the Fabric engineering spec is completed.
