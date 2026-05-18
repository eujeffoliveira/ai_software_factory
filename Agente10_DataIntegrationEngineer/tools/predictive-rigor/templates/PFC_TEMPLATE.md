# Pre-registered Falsification Contract (PFC)

> **CRITICAL:** This document MUST be committed to version control BEFORE any analysis begins.
> Post-hoc registration is invalid. The git commit timestamp is the proof of pre-registration.

**Contract ID:** `PFC-YYYY-MM-DD-NNN`
**Created:** `YYYY-MM-DD`
**Analysis Start Date:** `YYYY-MM-DD` (must be >= Created date)
**Author:** `___________`
**Reviewer:** `___________`

---

## Section 1: Hypothesis Statement

State the primary hypothesis in falsifiable form:

```
H1: [Specific, measurable claim about model/data/relationship]
H0 (null): [The opposite — what would disprove H1]
```

Primary hypothesis:
Null hypothesis:

---

## Section 2: Success Criteria (Pre-defined)

These criteria are fixed at registration. They CANNOT be changed after analysis begins.

| Criterion | Metric | Threshold | Direction |
|-----------|--------|-----------|-----------|
| Primary | | | >= / <= |
| Secondary 1 | | | >= / <= |
| Secondary 2 | | | >= / <= |

**Minimum acceptable performance** (MAS): ___________
**Target performance** (TP): ___________

---

## Section 3: Dataset Specification

| Property | Value |
|----------|-------|
| Dataset name | |
| Date range | YYYY-MM-DD to YYYY-MM-DD |
| Sample size (N) | |
| Train split | N = ___ (___%) |
| Validation split | N = ___ (___%) |
| Test split | N = ___ (___%) |
| Split method | temporal / random / stratified |
| Data version/hash | |

---

## Section 4: Feature Inventory

List ALL features that will be used. Features not listed here CANNOT be added mid-analysis.

| Feature Name | Type | Source | Look-ahead Risk | Approved |
|-------------|------|--------|-----------------|---------|
| | | | LOW / MED / HIGH | YES / NO |

---

## Section 5: Model Specification

| Property | Value |
|----------|-------|
| Model type | |
| Framework/library | |
| Hyperparameter grid (if tuning) | |
| Regularization strategy | |
| Cross-validation folds | |
| Seed | |

---

## Section 6: Baseline Requirements

All 4 baselines from `BASELINE_PARITY.md` must be computed. Pre-declare expected performance:

| Baseline | Expected Brier | Acceptable Delta |
|----------|---------------|-----------------|
| Flat | | >= 0.003 |
| Home-only | | >= 0.003 |
| Market | | >= 0.003 |
| LogReg | | >= 0.003 |

---

## Section 7: Statistical Power

Calculated using `power_calc.py`:

- Expected effect size: ___________
- Required N for 80% power: ___________
- Actual N (test set): ___________
- Power achieved: ___________

---

## Section 8: Stopping Rules

Define in advance under what conditions the analysis will be stopped:

- Stop if: [e.g., "model fails >2 baselines in cross-validation"]
- Stop if: [e.g., "look-ahead detected in >3 features"]
- Stop if: [e.g., "heteroscedasticity p < 0.01 in 3+ epochs"]

---

## Section 9: Allowed Post-Hoc Analyses

The following exploratory analyses are permitted after the primary analysis (but must be labeled as exploratory):

- [ ] Subgroup analysis by: ___________
- [ ] Feature importance: ___________
- [ ] Error analysis: ___________
- [ ] Other: ___________

Any finding from these analyses requires a NEW PFC to be pre-registered before confirmation.

---

## Section 10: Data Exclusion Rules

Specify pre-defined criteria for excluding observations:

- Exclude if: ___________
- Exclude if: ___________

Total expected exclusions: ___% of data

---

## Section 11: Multiple Comparisons

Number of primary comparisons: ___
Correction method: [ ] Bonferroni [ ] FDR/Benjamini-Hochberg [ ] None (single comparison)
Adjusted alpha level: ___

---

## Section 12: Conflict of Interest

- [ ] No conflicts declared
- [ ] Conflicts: ___________

---

## Section 13: Sign-Off (Pre-Registration)

By signing below, all parties agree that this contract is fixed and the analysis will proceed exactly as specified. Deviations must be documented in a separate deviation log.

**Author:** ___________ **Date:** ___________
**Reviewer:** ___________ **Date:** ___________

**Git commit hash (auto-populated):** ___________

---

## Deviation Log

If any deviation from this contract occurs during analysis, document it here:

| Date | Deviation | Reason | Approved By |
|------|-----------|--------|-------------|
| | | | |
