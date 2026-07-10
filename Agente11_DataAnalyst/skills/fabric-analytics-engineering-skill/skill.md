# fabric-analytics-engineering-skill

## Purpose

Frame Fabric analytics engineering decisions for lakehouse, warehouse, Eventhouse, OneLake, semantic models, governance, lifecycle, and AI-ready analytical layers.

## Trigger

Use this skill when the request mentions DP-600, Fabric Analytics, lakehouse vs warehouse vs Eventhouse, OneLake, KQL, SQL, DAX, Direct Lake, semantic model scale, Fabric IQ, ontology, Purview, PBIP, XMLA, or deployment pipelines.

## Inputs

- Analytics requirement
- Data source and serving expectations
- Metric and semantic model needs
- Governance, access, and lifecycle requirements

## Output

Produce a Fabric analytics decision section for `Analysis_Brief.md`, `Semantic_Model_Spec.md`, or `Dashboard_Spec.md`, and route implementation items to Agente10 when needed.

## Procedure

1. Classify the analytical asset: lakehouse, warehouse, Eventhouse, semantic model, report, ontology, or governed reusable asset.
2. Choose transformation/query surface: Dataflow Gen2, notebook/Spark, T-SQL, KQL, or DAX.
3. Define semantic model storage mode, scale, Direct Lake behavior, and refresh.
4. Define security and governance: workspace, item, row, column, object, file, sensitivity labels, Purview, endorsement, and impact analysis.
5. Define lifecycle: PBIP, version control, deployment pipeline, XMLA, templates, shared models, downstream dependencies.
6. Define AI readiness: semantic clarity, business terms, relationships, descriptions, and ontology needs.
7. Route data engineering implementation to Agente10.

## Knowledge Access Policy

This skill may consult only `Agente11_DataAnalyst/` runtime-local files and project artifacts provided as input. It must not read `context/`, `lib/`, raw PDFs, external downloads, or another agent folder directly.

## Failure Handling

If the request requires ingestion, orchestration, lakehouse/warehouse creation, or monitoring, produce analytical requirements and route implementation to Agente10.
