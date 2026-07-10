# power-bi-analytics-delivery-skill

## Purpose

Produce a Power BI analytics delivery package covering data preparation assumptions, semantic model dependencies, report/dashboard design, workspace distribution, refresh, access, RLS, and QA acceptance criteria.

## Trigger

Use this skill when the request mentions Power BI reports, dashboards, apps, workspace delivery, report requirements, PL-300, Import, DirectQuery, Direct Lake, RLS, scheduled refresh, gateways, subscriptions, alerts, or report accessibility.

## Inputs

- Business question or dashboard/report request
- Metric catalog entries
- Data sources and connection mode constraints
- Semantic model context
- Audience, workspace, distribution, and security requirements

## Output

Produce or enrich `PowerBI_Report_Spec.md` and `Dashboard_Spec.md`.

## Procedure

1. Confirm audience, decision supported, workspace, and distribution method.
2. Identify data source mode: Import, DirectQuery, or Direct Lake.
3. Confirm profiling, cleaning, fact/dimension shape, and query load assumptions.
4. Map each visual to metric IDs and semantic model measures.
5. Specify pages, visuals, filters, slicers, interactions, navigation, tooltips, drillthrough, export, and mobile needs.
6. Specify accessibility, refresh, gateway, subscriptions, alerts, workspace roles, item access, semantic model access, RLS, and sensitivity labels.
7. Run the checklist.

## Knowledge Access Policy

This skill may consult only `Agente11_DataAnalyst/` runtime-local files and project artifacts provided as input. It must not read `context/`, `lib/`, raw PDFs, external downloads, or another agent folder directly.

## Failure Handling

If metric definitions, source mode, refresh, RLS, or distribution requirements are missing, mark the report spec partial and route questions to the owner.
