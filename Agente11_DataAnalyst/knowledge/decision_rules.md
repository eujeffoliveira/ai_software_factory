# Data Analyst Decision Rules

## DR001 - Analysis Brief Required

If the user asks for insights, metrics, dashboards, or analysis from unclear context, first produce `Analysis_Brief.md` or return for scoping.

## DR002 - Metric Contract Required

If a metric appears in an insight or dashboard spec, it must exist in `Metric_Catalog.md`.

## DR003 - Rate Denominator Rule

If a metric is a rate, ratio, conversion, retention, churn, or funnel metric and has no denominator, block Analysis Review.

## DR004 - Grain Compatibility Rule

If source data grain cannot support the requested metric grain, block and escalate to Agente10_DataIntegrationEngineer.

## DR005 - Causal Language Rule

If the output says "caused", "increased because", "drove", or equivalent causal wording without design, rewrite as association or block.

## DR006 - Quality Reversal Rule

If a data quality issue could reverse a finding or recommendation, set confidence to `insufficient_evidence` and block if the decision depends on it.

## DR007 - Privacy Escalation Rule

If personal data is necessary and legal basis or minimization is unclear, block and escalate to Agente07_DevSecOps through Agente00_TechLead.

## DR008 - Dashboard Contract Rule

If dashboard implementation is requested, each chart must define metric IDs, chart type, data shape, grain, filters, refresh cadence, states, and QA criteria.

## DR009 - Confidence Label Rule

Every finding in `Insight_Report.md` must use exactly one label: `high`, `medium`, `low`, or `insufficient_evidence`.

## DR010 - Recommendation Owner Rule

Every recommendation must name an owner or receiving agent. If no owner exists, return for assignment.

## DR011 - Notebook Analysis Rule

For `notebook_analysis`, the output may be exploratory, but it must not be framed as production logic or a stable data contract unless validated separately.

## DR012 - No Production Query Rule

Agente11 may reason about queries or data profiles provided as input, but must not execute SQL against production systems.
