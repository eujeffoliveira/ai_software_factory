# Power BI Report Spec

## Report Purpose

| Field | Value |
|-------|-------|
| Audience | |
| Decision supported | |
| Workspace | |
| Distribution method | |
| Refresh cadence | |

## Data and Model

| Field | Value |
|-------|-------|
| Source mode | Import / DirectQuery / Direct Lake |
| Source systems | |
| Semantic model | |
| Date table | |
| RLS required | yes/no |
| Sensitivity label | |

## Metrics

| Metric ID | Measure name | DAX owner | Grain | Notes |
|-----------|--------------|-----------|-------|-------|
| MET-001 | | | | |

## Pages and Visuals

| Page | Visual | Question answered | Metric IDs | Filters/interactions |
|------|--------|-------------------|------------|----------------------|
| | | | | |

## Usability and Accessibility

- Mobile layout:
- Navigation:
- Tooltip/drillthrough:
- Export behavior:
- Accessibility notes:

## Governance and Operations

- Workspace roles:
- Item access:
- Semantic model permissions:
- Refresh/gateway requirements:
- Subscriptions/alerts:

## QA Acceptance Criteria

- [ ] Measures reconcile with `Metric_Catalog.md`.
- [ ] RLS tested with representative users/groups.
- [ ] Refresh succeeds within SLA.
- [ ] Report states render correctly for empty/stale/error data.
- [ ] Accessibility checks pass.
