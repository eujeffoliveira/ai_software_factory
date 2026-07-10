# Good Output

## Power BI Report Spec Summary

Audience: Sales leadership. Decision: identify which channels need intervention this month.

Source mode: Import for curated gold table; DirectQuery not required because daily refresh is sufficient.

Pages:

- Executive overview: revenue, conversion, churn, and target variance.
- Channel performance: conversion by channel, funnel step drop-off, and campaign attribution caveats.
- Retention: cohort retention with D7/D30 windows.

Governance:

- RLS by sales region using security groups.
- Sensitivity label: Confidential.
- App distribution to leadership workspace audience.

QA:

- Measures reconcile with `Metric_Catalog.md`.
- RLS tested with one user per region.
- Refresh succeeds before 07:00 local time.
- Empty and stale-data states render clearly.
