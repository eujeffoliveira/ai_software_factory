# Independence Audit Template

**Purpose:** Multi-layer verification that training and evaluation data are truly independent. Data leakage through indirect paths is as damaging as direct leakage.

**Pipeline:** `___________`
**Audit Date:** `___________`
**Auditor:** `___________`

---

## Layer 1: Data Source Independence

Verify that training and test data come from independent sources or time periods.

| Data Source | Used In Train | Used In Test | Independence Method | Status |
|-------------|--------------|-------------|---------------------|--------|
| | YES / NO | YES / NO | temporal / fold / source | PASS / FAIL |

**Rule:** The same observation must never appear in both train and test sets. If a source appears in both, it must be partitioned by time or another strict criterion.

Data source lineage check:
```
Train sources: ___________
Test sources:  ___________
Overlap:       NONE / [describe overlap]
```

---

## Layer 2: Feature Engineering Independence

Verify that feature engineering pipelines do not leak test information into training.

| Transformation | Fit Set | Apply Set | Status |
|---------------|---------|-----------|--------|
| StandardScaler | train only | train + test | PASS / FAIL |
| Target encoding | train fold only | all | PASS / FAIL |
| PCA | train only | all | PASS / FAIL |
| Imputation | train statistics | all | PASS / FAIL |
| Vocabulary (NLP) | train only | all | PASS / FAIL |
| Custom: ___ | | | PASS / FAIL |

---

## Layer 3: Model Ensemble Independence

If using ensemble methods, verify that component models are trained independently.

| Component Model | Training Data | Validation Data | Notes |
|----------------|--------------|----------------|-------|
| Model A | | | |
| Model B | | | |
| Stacking meta-learner | Held-out OOF predictions | | |

**Rule:** The meta-learner in a stacking ensemble must be trained on out-of-fold (OOF) predictions, never on predictions that were used to train the base models.

---

## Layer 4: Hyperparameter Tuning Independence

Verify that hyperparameter search does not leak test performance.

| Tuning Method | Data Used | Test Set Seen? | Status |
|--------------|-----------|----------------|--------|
| Grid search | | YES / NO | PASS / FAIL |
| Random search | | YES / NO | PASS / FAIL |
| Bayesian optimization | | YES / NO | PASS / FAIL |

**Rule:** Test set performance must NEVER be used to select hyperparameters. Use validation set or cross-validation only.

---

## Layer 5: Temporal Consistency

For time-series data, verify strict temporal ordering across all layers.

```
Timeline verification:
  Training period:   [YYYY-MM-DD] to [YYYY-MM-DD]
  Validation period: [YYYY-MM-DD] to [YYYY-MM-DD]
  Test period:       [YYYY-MM-DD] to [YYYY-MM-DD]
  Production start:  [YYYY-MM-DD]

Rule: training < validation < test < production (no overlap)
Status: PASS / FAIL
```

Earliest test timestamp: ___________
Latest training timestamp: ___________
Gap (must be >= 0): ___________

---

## Layer 6: External Data Lineage

For each external data source, trace its lineage to confirm independence.

| External Source | Join Key | Temporal Filter Applied | Future Data Risk | Status |
|----------------|---------|------------------------|-----------------|--------|
| | | YES / NO | LOW / MED / HIGH | PASS / FAIL |

---

## Correlation Check (Statistical Validation)

Run this check between training and test feature distributions. Significant correlation in labels between train and test is expected; in residuals it is not.

```python
# independence_audit.py runs this automatically
# Expected: feature means should differ between train/test (different time periods)
# Red flag: model residuals correlate with test timestamps
```

| Check | Result | Threshold | Status |
|-------|--------|-----------|--------|
| Residual autocorrelation (Durbin-Watson) | | 1.5 < DW < 2.5 | PASS / FAIL |
| Feature distribution shift (KS test) | p = ___ | p > 0.05 acceptable | INFO |
| Label distribution shift | ___ vs ___ | Document difference | INFO |

---

## Independence Audit Summary

| Layer | Verdict | Critical Issues |
|-------|---------|-----------------|
| L1: Data sources | PASS / FAIL | |
| L2: Feature engineering | PASS / FAIL | |
| L3: Ensemble | PASS / FAIL / N/A | |
| L4: Hyperparameter tuning | PASS / FAIL | |
| L5: Temporal consistency | PASS / FAIL | |
| L6: External data | PASS / FAIL / N/A | |

**Overall Independence Verdict:** PASS / FAIL

---

## Auditor Sign-Off

**Auditor:** ___________  **Date:** ___________
**Second Reviewer:** ___________  **Date:** ___________
