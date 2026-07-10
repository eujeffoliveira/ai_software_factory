# Data Analyst Knowledge Cards

## Card 001 - Analysis Brief Minimum

Use this when a request is vague. Capture: decision, question, population, time window, comparison, metrics, data sources, assumptions, limitations, confidence needed, and open questions.

## Card 002 - Metric Contract

A metric contract contains owner, purpose, grain, numerator, denominator, filters, exclusions, source fields, refresh cadence, validation rules, and caveats.

## Card 003 - Confidence Labels

`high` means stable and robust. `medium` means useful with caveats. `low` means directional. `insufficient_evidence` means the data cannot support the claim.

## Card 004 - Data Quality Triage

Check missingness, duplicates, freshness, outliers, schema drift, join coverage, sample size, and selection bias before insight reporting.

## Card 005 - Funnel Analysis

Define event order, eligible population, step windows, deduplication rule, conversion denominator at each step, and instrumentation gaps.

## Card 006 - Cohort Analysis

Define cohort entry, observation period, metric window, censoring, retention denominator, and whether cohorts are comparable.

## Card 007 - Causal Claims

Causal language requires experiment, natural experiment, regression discontinuity, difference-in-differences, instrumental variable, or another explicit identification strategy.

## Card 008 - Dashboard Chart Contract

Each chart needs chart type, metric IDs, data shape, grain, filters, refresh cadence, loading/empty/error/populated states, and accessibility notes.

## Card 009 - Privacy-Minimized Analysis

Prefer aggregate tables, cohort IDs, pseudonymous identifiers, or sampled profiles. Do not expose direct identifiers unless necessary and approved.

## Card 010 - Insight Pattern

Use: finding, evidence, confidence, caveat, recommendation, owner, validation step.
