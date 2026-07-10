# Analysis Review Checklist

## Framing

- [ ] Decision supported is explicit.
- [ ] Business question is answerable with available or requested data.
- [ ] Population, exclusions, and time window are stated.
- [ ] Comparison baseline is stated.
- [ ] Required confidence level is stated.

## Metrics

- [ ] Every metric appears in `Metric_Catalog.md`.
- [ ] Every metric has owner and grain.
- [ ] Every rate or ratio has numerator and denominator.
- [ ] Funnel metrics define step order and conversion windows.
- [ ] Cohort metrics define cohort entry and observation window.

## Data Quality

- [ ] Missingness reviewed for key fields.
- [ ] Duplicates reviewed at the analysis grain.
- [ ] Freshness reviewed against the decision window.
- [ ] Outliers and impossible values reviewed.
- [ ] Join coverage and segment sample sizes reviewed.

## Insight Rigor

- [ ] Each finding has a confidence label.
- [ ] Recommendations cite evidence and metric IDs.
- [ ] No causal claim is made without design.
- [ ] Limitations and caveats are visible.
- [ ] Open questions are marked blocking or non-blocking.

## Handoff

- [ ] Required next agent is named.
- [ ] Dashboard specs are complete when relevant.
- [ ] QA acceptance criteria exist for analytical outputs.
- [ ] Privacy notes are complete.
- [ ] `gate_ready` reflects the checklist result.
