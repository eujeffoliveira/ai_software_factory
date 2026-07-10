# Good Analysis Brief Example

## Decision Supported

Decide whether the onboarding flow needs a product intervention before the next sprint.

## Business Question

Where do new users abandon onboarding, and which segment should be prioritized first?

## Scope

| Field | Value |
|-------|-------|
| Population | Users who signed up in the last 30 days |
| Exclusions | Internal test accounts, deleted accounts, users without signup timestamp |
| Time window | Last 30 complete days |
| Comparison baseline | Previous 30 complete days |
| Required confidence | Medium for prioritization, high before shipping a paid experiment |

## Available Data

| Source | Grain | Refresh cadence | Known caveats |
|--------|-------|-----------------|---------------|
| onboarding_events | One row per user event | Daily | Step 3 event was renamed two weeks ago |

## Candidate Metrics

| Metric ID | Name | Why needed | Definition status |
|-----------|------|------------|-------------------|
| MET-001 | Signup to activation conversion | Primary onboarding outcome | complete |
| MET-002 | Step-level funnel conversion | Locate drop-off | draft |

## Open Questions

| Question | Directed to | Blocking |
|----------|-------------|----------|
| Should invited users be excluded from self-serve funnel analysis? | Agente01_ProductOwner | true |
