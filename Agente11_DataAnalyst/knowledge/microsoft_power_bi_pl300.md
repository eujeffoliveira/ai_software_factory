# Microsoft Power BI PL-300 Distilled Knowledge

Source: local Microsoft Learn study package collected on 2026-07-08 for PL-300.

## Scope

PL-300 maps to the Data Analyst role when the work involves Power BI data preparation, semantic modeling, DAX measures, report design, workspace distribution, dashboards, refresh, and row-level security.

## Exam-Derived Capability Areas

| Area | Weight | Runtime meaning for Agente11 |
|------|--------|------------------------------|
| Prepare data | 25-30% | Connect to sources, choose Import/DirectQuery/Direct Lake, profile data, clean nulls and unexpected values, transform columns, merge/append, create fact and dimension tables, configure query load. |
| Model data | 25-30% | Configure tables/columns, relationships, filter direction, role-playing dimensions, date table, DAX measures, time intelligence, semi-additive measures, calculated columns/tables, calculation groups, and performance tuning. |
| Visualize and analyze | 25-30% | Select appropriate visuals, format reports, theme, conditional formatting, slicers, filters, mobile reports, accessibility, narrative visuals, AI visuals, anomaly detection, clustering, forecasting, and reference lines. |
| Manage and secure | 15-20% | Workspaces, apps, publishing, dashboards, distribution method, subscriptions, alerts, endorsement/certification, gateways, scheduled refresh, item access, semantic model access, row-level security, and sensitivity labels. |

## Data Preparation Rules

- Choose the connection mode deliberately: Import for performance and modeling flexibility, DirectQuery for near-source query requirements, Direct Lake when Fabric/OneLake semantics are appropriate.
- Profile before transforming. Review column statistics, data properties, nulls, unexpected values, and import errors before modeling.
- Distinguish reference vs duplicate queries. Reference preserves upstream dependency; duplicate creates an independent query branch.
- Build facts and dimensions explicitly. Relationships need appropriate keys, cardinality, and cross-filter direction.
- Configure query load. Disable load for staging/helper queries that should not appear in the semantic model.

## Semantic Model Rules

- Prefer a star schema for analytical clarity and performance.
- Create a common date table when time intelligence is needed.
- Use measures for aggregations that respond to filter context; use calculated columns only when row-level materialization is required.
- Validate relationships, cardinality, and filter direction before debugging DAX.
- Optimize by removing unnecessary rows/columns, reducing granularity, and identifying slow measures, relationships, and visuals.

## DAX Rules

- Treat `CALCULATE` as context transition and filter-modification machinery. Never use it casually.
- For time intelligence, define a proper date table and explicit time window.
- Semi-additive measures require business-specific aggregation across time, such as end-of-period balance rather than simple sum.
- Calculation groups are for reusable measure transformations, not for hiding unclear metric definitions.

## Report and Dashboard Rules

- A report spec must state audience, decision, visual inventory, filters, interactions, navigation, tooltip behavior, export settings, mobile behavior, accessibility requirements, and refresh expectations.
- Use visuals to answer a question, not to decorate a page.
- Configure interactions intentionally; default cross-filtering can mislead when visuals have different grains.
- Accessibility is part of delivery: contrast, alt text, keyboard navigation, meaningful titles, and screen-reader-friendly labels.
- Dashboards, subscriptions, alerts, and apps are distribution choices. Choose them based on audience and operational cadence.

## Security and Governance Rules

- Workspace roles, item-level access, semantic model permissions, and RLS are separate controls.
- RLS must be tested with representative users or security groups.
- Sensitivity labels communicate data handling expectations and must match the data classification.
- Scheduled refresh and gateway requirements must be documented before treating a report as operational.

## Handoff Outputs

When PL-300 knowledge applies, Agente11 should produce or enrich:

- `Metric_Catalog.md`
- `Dashboard_Spec.md`
- `PowerBI_Report_Spec.md`
- `Semantic_Model_Spec.md`
- QA acceptance criteria for measures, RLS, refresh, and visual states
