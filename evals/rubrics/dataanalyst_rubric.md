# Rubric - Data Analyst (@dataanalyst / Agente11)

## Scoring Guide

0 = Absent or completely wrong
1 = Partial, incomplete, or risky
2 = Correct but missing nuance
3 = Excellent and decision-ready

---

## Dimensions

### 1. Question Framing

**Score 3:** Clearly identifies the decision supported, business question, population, exclusions, time window, comparison baseline, required confidence, assumptions, and blocking open questions.

**Score 2:** Most framing fields present, but one important field is vague.

**Score 1:** Mentions a question but lacks decision, comparison, or scope.

**Score 0:** Starts with charts or conclusions without framing the question.

### 2. Metric Definition

**Score 3:** Defines metrics with owner, grain, numerator, denominator, filters, exclusions, source fields, refresh cadence, validation rules, and caveats.

**Score 2:** Grain and denominator are present, but validation rules or caveats are thin.

**Score 1:** Metrics are named but not fully defined.

**Score 0:** Uses metrics without definitions.

### 3. Data Quality and Bias

**Score 3:** Reviews missingness, duplicates, freshness, outliers, join coverage, sample size, and bias risks, and ties caveats to confidence.

**Score 2:** Reviews common quality checks but misses one material risk.

**Score 1:** Mentions data quality generically.

**Score 0:** Ignores data quality.

### 4. Causality and Confidence

**Score 3:** Avoids unsupported causal claims, labels confidence for each finding, and recommends experiment or identification strategy when causality is requested.

**Score 2:** Avoids causal overclaiming but confidence labels lack explanation.

**Score 1:** Uses cautious language inconsistently.

**Score 0:** Claims causality from observational data.

### 5. Actionable Insight Handoff

**Score 3:** Produces findings with evidence, caveats, recommendations, owner, validation step, risks, and required next agent.

**Score 2:** Findings and recommendations are clear but ownership or validation is incomplete.

**Score 1:** Findings are descriptive without next actions.

**Score 0:** Provides generic advice disconnected from evidence.

## Aggregate Score Interpretation

**Maximum score:** 15

| Total Score | Interpretation |
|-------------|----------------|
| 14-15 | Excellent - decision-ready analytical handoff |
| 11-13 | Good - minor caveats remain |
| 7-10 | Acceptable - needs revision before high-impact decisions |
| 4-6 | Poor - likely to mislead stakeholders |
| 0-3 | Failing - unsafe analytical output |

**Critical failures:** A score of 0 on Metric Definition or Causality and Confidence should block Analysis Review regardless of aggregate score.
