# Agente11_DataAnalyst - Analysis Review

## Gate Overview

| Field | Value |
|-------|-------|
| Gate name | Analysis Review |
| Gate type | Conditional pre-decision review |
| Data Analyst role | Owner and evaluator |
| Submitters | Human, Agente00_TechLead, Agente01_ProductOwner, or Agente10_DataIntegrationEngineer |
| Can be overridden by Tech Lead | NO |
| Activates when | A product, implementation, dashboard, or business decision will rely on analytical output |
| Output if APPROVED | Analysis Handoff Package to the next owner |
| Output if BLOCKED | Block notice and missing evidence list to Agente00_TechLead |
| Output if RETURNED | Return package with question, metric, data, or privacy gaps |

> Analysis Review is not a numbered SDLC gate. It is a conditional safety check before using analysis outputs as evidence for product, implementation, or business decisions.

## Objective

Validate that analysis artifacts are decision-ready:

1. The decision and question are explicit.
2. Metrics have stable definitions.
3. The data grain supports the question.
4. Data quality risks are known and non-blocking.
5. Findings have confidence labels.
6. Recommendations are tied to evidence.
7. Privacy and LGPD caveats are handled.
8. No unsupported causal claim remains.

## Entry Criteria

| # | Entry Criterion | If Missing |
|---|----------------|------------|
| 1 | Business question or decision context | RETURNED_MISSING_QUESTION |
| 2 | Available data sources or explicit absence | RETURNED_MISSING_DATA_CONTEXT |
| 3 | Metric owner or requested decision owner | RETURNED_MISSING_OWNER |
| 4 | Known population and time window | RETURNED_FOR_SCOPING |
| 5 | Personal data status declared or unknown flagged | RETURNED_PRIVACY_UNCLEAR |

## Blocking Criteria

### BK-01: Undefined Metric

**Condition:** A metric is used without grain, owner, numerator, denominator, filters, or exclusions.

**Status:** `BLOCKED_UNDEFINED_METRIC`

**Resolution:** Invoke `metric-definition-skill` and update `Metric_Catalog.md`.

### BK-02: Unsupported Causal Claim

**Condition:** The analysis claims an action caused an outcome without experiment design or identification strategy.

**Status:** `BLOCKED_UNSUPPORTED_CAUSALITY`

**Resolution:** Reword as association/hypothesis or provide a valid causal design.

### BK-03: Data Quality Can Reverse Conclusion

**Condition:** Missingness, duplication, freshness, join coverage, or bias risk can materially change the finding.

**Status:** `BLOCKED_DATA_QUALITY_RISK`

**Resolution:** Resolve data quality, narrow scope, lower confidence to insufficient evidence, or escalate.

### BK-04: Personal Data Without Privacy Caveat

**Condition:** Personal or sensitive data is used without legal basis, minimization, or privacy caveats.

**Status:** `BLOCKED_PRIVACY_RISK`

**Resolution:** Add privacy notes, aggregate/pseudonymize, or escalate to Agente07_DevSecOps.

### BK-05: Dashboard Spec Lacks Data Contract

**Condition:** Dashboard request lacks chart data shape, grain, filters, states, or acceptance criteria.

**Status:** `BLOCKED_DASHBOARD_CONTRACT`

**Resolution:** Complete `Dashboard_Spec.md`.

### BK-06: Evidence Not Traceable

**Condition:** An insight or recommendation cannot be traced to metrics, source fields, or assumptions.

**Status:** `BLOCKED_UNTRACEABLE_INSIGHT`

**Resolution:** Link insight to metric IDs and evidence.

## Evaluation Checklist

### Section A: Framing

- [ ] Decision supported is explicit.
- [ ] Business question is answerable.
- [ ] Population and exclusions are stated.
- [ ] Time window and comparison baseline are stated.
- [ ] Required confidence level is stated.

### Section B: Metrics

- [ ] Every metric has owner, grain, numerator, denominator, filters, and exclusions.
- [ ] Rates and ratios have denominators.
- [ ] Funnel metrics define event order and window.
- [ ] Cohort metrics define cohort entry and observation period.
- [ ] Source fields are traceable.

### Section C: Data Quality

- [ ] Missingness reviewed.
- [ ] Duplicate risk reviewed at the analysis grain.
- [ ] Freshness reviewed.
- [ ] Outliers and impossible values reviewed.
- [ ] Bias and sample-size limitations stated.

### Section D: Insight Rigor

- [ ] Each finding has a confidence label.
- [ ] Recommendations cite evidence.
- [ ] Causal claims have valid design or are removed.
- [ ] Limitations are visible, not buried.
- [ ] Open questions are marked blocking or non-blocking.

### Section E: Handoff

- [ ] All produced artifacts are listed.
- [ ] Required next agent is selected.
- [ ] Dashboard specs include states and data contract when applicable.
- [ ] QA acceptance criteria exist for analytical outputs.
- [ ] `gate_ready` is true only when no blocking criteria remain.

## Status Codes

| Status Code | Meaning |
|-------------|---------|
| `APPROVED` | All sections pass and no blocking criteria remain |
| `APPROVED_WITH_CONDITIONS` | Minor non-blocking caveats remain |
| `BLOCKED_UNDEFINED_METRIC` | BK-01 triggered |
| `BLOCKED_UNSUPPORTED_CAUSALITY` | BK-02 triggered |
| `BLOCKED_DATA_QUALITY_RISK` | BK-03 triggered |
| `BLOCKED_PRIVACY_RISK` | BK-04 triggered |
| `BLOCKED_DASHBOARD_CONTRACT` | BK-05 triggered |
| `BLOCKED_UNTRACEABLE_INSIGHT` | BK-06 triggered |
| `RETURNED_MISSING_QUESTION` | Business question is missing |
| `RETURNED_MISSING_DATA_CONTEXT` | Data context is missing |
| `RETURNED_FOR_SCOPING` | Population, time window, or comparison is unclear |

## Output

When approved, produce the Analysis Handoff Package defined in `handoff_schema.json`.
