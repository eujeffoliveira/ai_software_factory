# Microsoft Fabric Analytics DP-600 Distilled Knowledge

Source: local Microsoft Learn study package collected on 2026-07-08 for DP-600.

## Scope

DP-600 maps to Fabric Analytics Engineering. It bridges Agente11_DataAnalyst and Agente10_DataIntegrationEngineer when a solution uses Fabric lakehouses, warehouses, Eventhouse, OneLake, semantic models, Direct Lake, DAX, SQL, KQL, governance, and AI-ready semantic layers.

## Capability Areas

| Area | Weight | Runtime meaning |
|------|--------|-----------------|
| Maintain an analytics solution | 25-30% | Workspace/item security, RLS/CLS/OLS/file permissions, sensitivity labels, endorsement, lifecycle, version control, PBIP, deployment pipelines, impact analysis, XMLA, reusable assets. |
| Prepare data | 45-50% | Connections, OneLake catalog, Real-Time hub, lakehouse/warehouse/Eventhouse choice, Dataflows Gen2, notebooks, T-SQL, SQL, KQL, DAX, star schema, joins, aggregation, dedupe, null handling, type conversion. |
| Implement and manage semantic models | 25-30% | Storage mode, star schema, bridge and many-to-many relationships, DAX variables/iterators/filtering/windows/info functions, calculation groups, dynamic format strings, field parameters, large models, composite models, Direct Lake, incremental refresh. |

## Storage Decision Rules

- Lakehouse: use for open data lake patterns, Delta tables, Spark/notebook transformations, medallion architecture, and broad downstream consumption.
- Warehouse: use for relational serving, T-SQL workloads, dimensional modeling, stored procedures/views/functions, and SQL-first analytics.
- Eventhouse/KQL: use for real-time, high-volume event/time-series exploration and KQL-based analytics.
- Semantic model: use as the governed analytical contract for report consumption, not as a dumping ground for unresolved data modeling.

## Transformation Decision Rules

- Dataflows Gen2: good for low-code transformation, repeatable preparation, and analyst-friendly ETL.
- Notebooks/Spark: good for complex transformations, scalable file/lakehouse processing, and code-controlled pipelines.
- T-SQL: good for warehouse-native transformations, views, stored procedures, and dimensional SQL logic.
- KQL: good for real-time/event analytics and time-series query patterns.
- DAX: good for model-time analytical calculations and measures, not for upstream data cleansing.

## Semantic Model Scale Rules

- Choose storage mode explicitly: Import, DirectQuery, Direct Lake, composite, or large model format.
- Direct Lake requires attention to fallback behavior and refresh semantics.
- Star schema remains the default for clarity and performance.
- Many-to-many and bridge relationships require explicit business justification and tests.
- Enterprise-scale models require performance work on DAX, visuals, relationships, storage settings, and incremental refresh.

## Governance and Lifecycle Rules

- Use workspace and item access separately; do not assume workspace access equals model or data access.
- Document downstream dependencies before changing lakehouses, warehouses, dataflows, or semantic models.
- Use PBIP and deployment pipelines when lifecycle/versioning matters.
- Use XMLA endpoint for advanced semantic model deployment/management when supported.
- Treat sensitivity labels, endorsements, and Purview governance as delivery requirements, not afterthoughts.

## AI-Ready Analytics Rules

- Prepare semantic layers for AI by making model names, descriptions, relationships, measures, and business terms unambiguous.
- Fabric IQ and ontology work requires a shared vocabulary of entities, relationships, and meanings.
- AI readiness depends on semantic clarity and governed data access; it is not solved by adding Copilot alone.

## Cross-Agent Routing

- Route ingestion, orchestration, lakehouse/warehouse/Eventhouse implementation, and monitoring to Agente10.
- Route metric definitions, semantic model requirements, DAX logic, insight confidence, and dashboard specs to Agente11.
- Route access control, sensitivity labels, and critical data governance risk to Agente07 through Agente00.
