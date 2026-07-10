# Agente11_DataAnalyst Failure Modes

## FM-01: Metric Without Grain or Denominator

**Symptom:** A rate, ratio, conversion, retention, churn, or funnel metric is used without a denominator, grain, or event window.

**Impact:** Stakeholders compare incompatible numbers and make invalid decisions.

**Prevention:** Run `metric-definition-skill` and require a full metric contract.

**Gate effect:** Blocks Analysis Review.

## FM-02: Unsupported Causal Claim

**Symptom:** The report says a feature, campaign, or action caused an outcome based only on observational comparison.

**Impact:** Product or business decisions are made from overclaimed evidence.

**Prevention:** Label as association or hypothesis unless experiment or identification strategy exists.

**Gate effect:** Blocks Analysis Review.

## FM-03: Hidden Data Quality Caveat

**Symptom:** Missingness, duplicates, stale data, join gaps, or outliers are absent from the insight narrative.

**Impact:** Findings appear stronger than the data supports.

**Prevention:** Run data quality review before insight reporting.

**Gate effect:** Blocks if the issue can reverse the conclusion.

## FM-04: Personal Data Without Privacy Minimization

**Symptom:** Row-level personal data appears in analysis when aggregates would answer the question.

**Impact:** LGPD and trust risk.

**Prevention:** Prefer aggregate, pseudonymized, or minimized data; document legal basis.

**Gate effect:** Blocks and escalates when legal basis is unclear.

## FM-05: Dashboard Without Data Contract

**Symptom:** Dashboard spec names charts but omits data shape, grain, filters, refresh cadence, or states.

**Impact:** Frontend and QA cannot implement or validate the dashboard reliably.

**Prevention:** Use `Dashboard_Spec.md` template and trace each chart to metrics.

**Gate effect:** Blocks dashboard handoff.

## FM-06: Segment Overinterpretation

**Symptom:** A small segment or noisy cohort is presented as a stable insight.

**Impact:** Decisions optimize for random variance.

**Prevention:** Include sample size, confidence label, and robustness checks by segment.

**Gate effect:** Blocks if recommendation depends on the weak segment.

## FM-07: Metric Drift Ignored

**Symptom:** Metric definition, source schema, or business process changed during the comparison window.

**Impact:** Before/after comparisons become invalid.

**Prevention:** Check source history, schema drift, and operational changes.

**Gate effect:** Blocks if drift invalidates the comparison.

## FM-08: Vanity Metric Recommendation

**Symptom:** Report optimizes for a number that does not connect to a decision, user outcome, or business objective.

**Impact:** Team spends effort improving a metric that does not matter.

**Prevention:** Require decision-supported metric mapping in `Analysis_Brief.md`.

**Gate effect:** Returned for reframing.

## FM-09: Confusing Correlation With Funnel Leakage

**Symptom:** Funnel drop-off is interpreted without checking instrumentation gaps or event ordering.

**Impact:** Product teams fix the wrong step.

**Prevention:** Validate event sequence, time window, and instrumentation completeness.

**Gate effect:** Blocks funnel recommendations until verified.

## FM-10: Recommendation Without Owner

**Symptom:** Insight ends with a generic recommendation and no accountable owner or validation step.

**Impact:** Findings do not turn into action or learning.

**Prevention:** Every recommendation includes owner, next action, and follow-up metric.

**Gate effect:** Approved only with conditions if non-critical; otherwise returned.
