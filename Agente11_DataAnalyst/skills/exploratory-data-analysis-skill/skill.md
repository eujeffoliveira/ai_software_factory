# exploratory-data-analysis-skill

## Purpose

Review dataset structure, quality, distributions, segments, and limitations before producing insights or dashboard contracts.

## Trigger

Use this skill when raw data, sample rows, data profiles, query results, schemas, event tables, or data quality concerns are available or requested.

## Inputs

- Dataset profile, sample, schema, or query result
- Metric catalog entries
- Data dictionary
- Known pipeline caveats
- Business question and scope

## Output

Produce `Exploratory_Analysis_Report.md` or an EDA plan when data is not available.

## Procedure

1. Confirm dataset grain and period covered.
2. Review completeness, duplicates, freshness, validity, join coverage, and sample size.
3. Summarize distributions and important segment cuts.
4. Identify anomalies and bias risks.
5. Decide whether data is ready, ready with caveats, or blocked.
6. Run `checklist.md`.

## Knowledge Access Policy

This skill may consult only `Agente11_DataAnalyst/` runtime-local files and project artifacts provided as input. It must not read `context/`, `lib/`, raw PDFs, or another agent folder directly.

## Failure Handling

If the dataset grain, period, or quality profile is missing, produce an EDA plan and mark evidence as not evaluated.
