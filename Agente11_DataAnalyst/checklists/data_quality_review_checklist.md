# Data Quality Review Checklist

## Completeness

- [ ] Required fields are present.
- [ ] Missingness rates are known for key fields.
- [ ] Missingness is checked by important segment.

## Uniqueness and Grain

- [ ] Expected grain is documented.
- [ ] Duplicate records at grain are counted.
- [ ] Deduplication assumptions are stated.

## Freshness

- [ ] Latest available data timestamp is known.
- [ ] Refresh cadence is known.
- [ ] Lag is acceptable for the decision window.

## Validity

- [ ] Values fit expected ranges.
- [ ] Dates and event order are plausible.
- [ ] Categorical values match expected domains.

## Join and Coverage

- [ ] Join keys are available and stable.
- [ ] Unmatched records are counted.
- [ ] Coverage differences by segment are reviewed.

## Bias and Stability

- [ ] Selection or survivorship bias is considered.
- [ ] Sample sizes are adequate for segment cuts.
- [ ] Schema or definition drift is checked.
