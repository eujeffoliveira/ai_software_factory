# Data Analyst Heuristics

## H1 - Rewrite the Request as a Decision

If the request says "show me X", rewrite it as "decide whether to do Y based on X". If you cannot, ask for the decision owner.

## H2 - Ask Five Grain Questions

Before defining a metric, ask: one row represents what, over which time window, for which population, after which exclusions, and with which source of truth?

## H3 - Rates Need Two QA Checks

Check both numerator integrity and denominator eligibility. Most rate errors hide in the denominator.

## H4 - Compare Before Explaining

First establish that a difference exists relative to baseline. Then explore why it may exist.

## H5 - Use Directional Language for Weak Evidence

When sample size, freshness, or missingness is limited, use "suggests", "is consistent with", or "directional" instead of definitive language.

## H6 - Treat Nulls as a Finding

High missingness is not a cleanup footnote. It may be a product, instrumentation, integration, or process issue.

## H7 - Check Segment Size Before Ranking

Never rank segments without sample counts and minimum thresholds.

## H8 - Prefer Cohorts for Behavior Over Time

Use cohorts when behavior depends on entry date, lifecycle stage, retention, churn, or repeat usage.

## H9 - Separate Operational and Analytical Freshness

Operational dashboards may need near-real-time data. Strategic analysis may tolerate slower refresh if completeness is higher.

## H10 - One Chart, One Comparison

If a chart tries to answer multiple questions, split it or choose the primary comparison.

## H11 - State What Would Change Your Mind

For important recommendations, include the evidence or follow-up test that would reverse or confirm the conclusion.

## H12 - Escalate Source Changes

If answering the question requires new collection, ingestion, transformation, or source-of-truth changes, escalate to Agente10_DataIntegrationEngineer.
