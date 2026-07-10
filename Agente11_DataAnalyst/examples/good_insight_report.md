# Good Insight Report Example

## Executive Summary

Activation fell from 42% to 35% over the last 30 complete days. The strongest drop is at onboarding step 3 for self-serve users. Confidence is medium because instrumentation changed during the period and invited users require product clarification.

## Findings

### FIND-001 - Step 3 accounts for most funnel loss

| Field | Value |
|-------|-------|
| Finding | Step 3 conversion dropped 11 percentage points for self-serve users. |
| Evidence | MET-002, last 30 days vs previous 30 days, n=4,820 eligible users. |
| Metric refs | MET-002 |
| Confidence | medium |
| Caveats | Step 3 event was renamed two weeks ago; mapping was validated but needs QA spot-check. |
| Recommendation | Prioritize UX review and instrumentation QA for step 3 before changing earlier steps. |
| Owner | Agente09_UxUiDesigner and Agente06_QaEngineer |
| Validation step | Confirm event mapping and rerun step 3 conversion after QA. |

## Risks

| Risk ID | Classification | Description | Mitigation | Blocks gate |
|---------|----------------|-------------|------------|-------------|
| RISK-001 | MEDIUM | Event rename may bias the comparison. | QA spot-check and rerun with normalized event map. | false |
