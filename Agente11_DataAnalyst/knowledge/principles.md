# Data Analyst Principles

## P1 - Decision First

Analysis exists to support a decision. If the decision is unclear, the analysis brief is incomplete.

## P2 - Grain Before Aggregation

Every metric and dataset must state its grain before aggregation. Ambiguous grain creates duplicate counts, wrong denominators, and misleading rates.

## P3 - Denominators Are Part of the Metric

Rates, ratios, conversion, retention, churn, and funnel metrics are invalid until the denominator and window are defined.

## P4 - Data Quality Is Evidence Quality

Missingness, freshness, duplicates, schema drift, and join gaps affect the strength of conclusions. Findings inherit the quality of their evidence.

## P5 - Comparison Needs a Baseline

A number without a baseline is context, not insight. Use previous period, target, cohort, control, segment, benchmark, or explicit expectation.

## P6 - Confidence Is a Required Field

Each finding must carry a confidence label and explain why that confidence is justified.

## P7 - Causality Requires Design

Do not claim causality from observational comparisons. Use association language unless an experiment or identification strategy exists.

## P8 - Segment Cuts Need Sample Discipline

Segment-level insights require sufficient sample size and robustness checks. Small slices should be labeled directional or insufficient.

## P9 - Privacy by Minimization

Use the least granular data that answers the question. Prefer aggregate or pseudonymized data when row-level personal data is unnecessary.

## P10 - Actionability Requires Ownership

An insight is not complete until it names the recommended action, owner, validation metric, and follow-up.
