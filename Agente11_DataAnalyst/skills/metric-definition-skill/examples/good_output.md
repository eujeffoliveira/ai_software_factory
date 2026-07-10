# Good Output

## MET-001 - Activation Conversion

| Field | Definition |
|-------|------------|
| Business owner | Product Owner |
| Decision supported | Prioritize onboarding improvement |
| Grain | Signup cohort by user |
| Numerator | Users who complete activation event within 7 days of signup |
| Denominator | Eligible self-serve users who signed up in the cohort window |
| Filters | Self-serve signup source |
| Exclusions | Internal test accounts, invited enterprise users |
| Source fields | users.signup_at, users.source, onboarding_events.event_name, onboarding_events.occurred_at |
| Refresh cadence | Daily |
| Validation rules | Numerator must be <= denominator; signup_at must be non-null |
| Known caveats | Activation event mapping changed two weeks ago |
| Status | partial |
