# metric-definition-skill

## Purpose

Define metrics as stable contracts that can be used in analysis, dashboards, QA, and implementation handoffs.

## Trigger

Use this skill whenever a KPI, rate, ratio, funnel, cohort, retention, churn, revenue, adoption, engagement, or operational metric is requested or referenced.

## Inputs

- Metric names or candidate metrics
- Business decision or question
- Data source fields
- Population and time window
- Existing definitions, if any

## Output

Produce `Metric_Catalog.md` entries with owner, decision supported, grain, numerator, denominator, filters, exclusions, source fields, refresh cadence, validation rules, caveats, and status.

## Procedure

1. Classify each metric: count, rate, ratio, funnel, cohort, financial, operational, or derived.
2. Define the grain before defining aggregation.
3. For rates and ratios, define numerator and denominator.
4. For funnels, define event order, eligibility, and step windows.
5. For cohorts, define entry event and observation window.
6. Link source fields.
7. Add validation rules and caveats.
8. Mark incomplete metrics as `partial` or `blocked`.

## Knowledge Access Policy

This skill may consult only `Agente11_DataAnalyst/` runtime-local files and project artifacts provided as input. It must not read `context/`, `lib/`, raw PDFs, or another agent folder directly.

## Failure Handling

If a metric lacks owner, grain, source fields, or denominator where required, mark it blocked instead of treating it as ready.
