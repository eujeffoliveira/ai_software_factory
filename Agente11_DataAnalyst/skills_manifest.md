# Agente11_DataAnalyst Skills Manifest

## Overview

Agente11 uses seven runtime-local skills to turn questions into metrics, evidence, insights, Power BI/Fabric analytics specifications, and implementation-ready dashboard specifications.

## Skills

| Skill | Purpose | Primary Output |
|-------|---------|----------------|
| `analysis-question-framing-skill` | Convert an ambiguous business request into a scoped analysis brief | `Analysis_Brief.md` |
| `metric-definition-skill` | Define KPI, ratio, funnel, cohort, and operational metrics as contracts | `Metric_Catalog.md` |
| `exploratory-data-analysis-skill` | Review dataset structure, data quality, distributions, and limitations | `Exploratory_Analysis_Report.md` |
| `insight-reporting-skill` | Convert evidence into decision-ready insights and recommendations | `Insight_Report.md` |
| `power-bi-analytics-delivery-skill` | Specify Power BI reports, dashboards, workspace delivery, refresh, RLS, and QA criteria | `PowerBI_Report_Spec.md` |
| `semantic-modeling-dax-skill` | Specify semantic models, DAX measures, storage mode, relationships, scale, and security | `Semantic_Model_Spec.md` |
| `fabric-analytics-engineering-skill` | Frame Fabric analytics assets, semantic model scale, governance, lifecycle, and AI readiness | Fabric analytics decision section |

## Skill Routing

- Use `analysis-question-framing-skill` first unless the request already contains a complete analysis brief.
- Use `metric-definition-skill` before any dashboard or insight that mentions KPIs, rates, ratios, cohorts, funnels, retention, churn, revenue, or conversion.
- Use `exploratory-data-analysis-skill` when any dataset, schema, profile, sample, query result, or data quality issue is in scope.
- Use `insight-reporting-skill` after metrics and evidence are clear enough to support a recommendation.
- Use `power-bi-analytics-delivery-skill` when PL-300, Power BI reports, dashboards, apps, workspaces, refresh, gateways, RLS, subscriptions, or alerts are in scope.
- Use `semantic-modeling-dax-skill` when DAX, semantic model design, star schema, Direct Lake, composite models, calculation groups, incremental refresh, or XMLA/PBIP lifecycle are in scope.
- Use `fabric-analytics-engineering-skill` when DP-600, Fabric analytics, lakehouse/warehouse/Eventhouse selection, OneLake, KQL/SQL/DAX, governance, Purview, Fabric IQ, ontology, or AI-ready semantic layers are in scope.

## Runtime Isolation

Skills may only consult `Agente11_DataAnalyst/` runtime-local files and project artifacts supplied as input. They must not read `context/`, `lib/`, raw PDFs, or another agent folder directly.

## Required Cross-Agent Escalations

- Route pipeline or source-of-truth changes to Agente10_DataIntegrationEngineer through Agente00_TechLead.
- Route dashboard UI implementation to Agente05_DevFrontend.
- Route test cases for analytical correctness to Agente06_QaEngineer.
- Route privacy or sensitive-data uncertainty to Agente07_DevSecOps.
