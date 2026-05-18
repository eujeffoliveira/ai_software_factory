# Adversarial Review Template

**Model/Pipeline:** `___________`
**Review Date:** `___________`
**Reviewer:** `___________`
**Review Type:** [ ] Pre-Deploy [ ] Post-Incident [ ] Scheduled

---

## Section 1: Claim Under Review

Describe exactly what is being claimed about this model or pipeline:

```
Claim: "The model achieves [metric] on [dataset] under [conditions]."
```

Primary claim:
Supporting claims (list all):

---

## Section 2: Data Integrity Audit

| Check | Status | Evidence |
|-------|--------|----------|
| No target leakage in features | PASS / FAIL / UNKNOWN | |
| Train/test split is temporally correct | PASS / FAIL / UNKNOWN | |
| No future data used in training | PASS / FAIL / UNKNOWN | |
| Feature engineering uses only past-available data | PASS / FAIL / UNKNOWN | |
| Validation set is independent of training | PASS / FAIL / UNKNOWN | |

Data integrity verdict: **PASS / FAIL / CONDITIONAL**

---

## Section 3: Baseline Comparison

Reference `BASELINE_PARITY.md` for required baselines.

| Baseline | Score | Model Score | Delta | Gate |
|----------|-------|-------------|-------|------|
| Flat (mean) | | | | Brier delta >= 0.003 |
| Home-only | | | | |
| Pinnacle/market | | | | |
| LogReg+odds | | | | |

Baseline parity verdict: **PASS / FAIL / CONDITIONAL**

---

## Section 4: Statistical Validity

| Check | Result | Threshold |
|-------|--------|-----------|
| Sample size (power >= 0.8) | n = ___ | See power_calc.py |
| Confidence interval (95%) | [___, ___] | Not crossing 0 |
| Heteroscedasticity check | p = ___ | p > 0.05 |
| Multiple comparisons correction | Bonferroni/FDR applied | Required if >3 metrics |
| Temporal stability (no drift) | Pass/Fail | CV < 15% across epochs |

Statistical validity verdict: **PASS / FAIL / CONDITIONAL**

---

## Section 5: Look-Ahead Bias Scan

Reference `LAIG_CHECKLIST.md` for full scan procedure.

Identified look-ahead risks:

| Feature | Risk Level | Reasoning | Mitigation |
|---------|-----------|-----------|------------|
| | HIGH / MED / LOW | | |

Look-ahead verdict: **PASS / FAIL / CONDITIONAL**

---

## Section 6: Independence Audit

Reference `INDEPENDENCE_AUDIT.md`.

| Layer | Independence Status | Notes |
|-------|---------------------|-------|
| Data sources | INDEPENDENT / CORRELATED | |
| Feature engineering | INDEPENDENT / CORRELATED | |
| Model ensembles | INDEPENDENT / CORRELATED | |
| Validation sets | INDEPENDENT / CORRELATED | |

Independence verdict: **PASS / FAIL / CONDITIONAL**

---

## Section 7: Final Sign-Off

**Overall Verdict:** [ ] APPROVE [ ] REFUSE [ ] CONDITIONAL

Conditional approval requirements (if applicable):
1.
2.

**Reviewer signature:** ___________
**Date:** ___________

> APPROVE = model may proceed to production
> REFUSE = model must not be deployed; return to development
> CONDITIONAL = model may proceed only after listed conditions are met and re-reviewed
