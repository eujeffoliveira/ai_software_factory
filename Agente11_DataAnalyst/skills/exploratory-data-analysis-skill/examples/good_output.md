# Good Output

## Data Quality Summary

| Check | Status | Notes |
|-------|--------|-------|
| Grain | pass | One row per onboarding event. |
| Missingness | caveat | 3.1% of events have missing source; concentrated in partner channel. |
| Freshness | pass | Data refreshed daily; latest complete day available. |
| Duplicates | pass | Duplicate event IDs below 0.1%. |
| Join coverage | caveat | 96% of events join to users. |

## Findings

| Finding ID | Observation | Confidence |
|------------|-------------|------------|
| FIND-001 | Step 3 has the largest conversion drop, but event rename caveat remains. | medium |

## EDA Conclusion

ready_with_caveats
