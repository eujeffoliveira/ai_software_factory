# Model Retrospective Template

**Purpose:** Structured post-analysis reflection to capture lessons learned, validate pre-registered claims, and improve future models.
**When to run:** After each epoch/season/evaluation period. Required before closing a PFC.

**Model:** `___________`
**Epoch/Period:** `___________`
**Retrospective Date:** `___________`
**Author:** `___________`
**Participants:** `___________`

---

## Section 1: PFC Outcome Verification (Mandatory Q1)

Was the pre-registered hypothesis confirmed?

| Pre-registered Criterion | Threshold | Actual Result | Outcome |
|--------------------------|-----------|---------------|---------|
| Primary metric | | | CONFIRMED / REJECTED |
| Secondary 1 | | | CONFIRMED / REJECTED |
| Secondary 2 | | | CONFIRMED / REJECTED |

**Overall PFC outcome:** [ ] CONFIRMED [ ] REJECTED [ ] PARTIAL

If REJECTED: explain what was wrong with the hypothesis, not the data.

---

## Section 2: Baseline Parity Retrospective (Mandatory Q2)

| Baseline | Pre-registered Expected | Actual Delta | Assessment |
|----------|------------------------|--------------|------------|
| Flat | | | Above/Below expectation |
| Home-only | | | |
| Market | | | |
| LogReg | | | |

What did the baseline comparison reveal about the model's actual value-add?

---

## Section 3: Look-Ahead Post-Mortem (Mandatory Q3)

Were any look-ahead issues discovered AFTER the LAIG check?

| Issue Found | When Discovered | Impact on Results | Root Cause |
|-------------|----------------|------------------|------------|
| | | | |

If issues found: were results invalidated? If yes, document in deviation log and re-run.

---

## Section 4: Prediction Calibration

How well-calibrated were the probabilities?

| Probability Bucket | Predicted Rate | Actual Rate | Calibration Error |
|--------------------|---------------|-------------|-------------------|
| 0.0 - 0.2 | 0.1 | | |
| 0.2 - 0.4 | 0.3 | | |
| 0.4 - 0.6 | 0.5 | | |
| 0.6 - 0.8 | 0.7 | | |
| 0.8 - 1.0 | 0.9 | | |

Calibration assessment: GOOD / OVERCONFIDENT / UNDERCONFIDENT

---

## Section 5: Failure Analysis

Analyze the worst predictions (top 10% highest error):

| Case | Predicted | Actual | Error | Root Cause |
|------|-----------|--------|-------|-----------|
| | | | | |

Common failure themes:
1.
2.
3.

---

## Section 6: Feature Performance

| Feature | Expected Importance | Actual Importance | Direction | Surprise |
|---------|--------------------|--------------------|-----------|----------|
| | | | + / - | YES / NO |

Features to add in next epoch:
Features to remove:
Features to transform:

---

## Section 7: Process Improvements

| Issue | Root Cause | Action for Next Epoch | Owner | Due |
|-------|-----------|----------------------|-------|-----|
| | | | | |

---

## Section 8: Sunk Cost Check

Run `sunk_cost_guard.py` and document result:

```
Sunk cost check result: ___________
Decision: CONTINUE / PIVOT / STOP
Rationale: ___________
```

If PIVOT or STOP: document reasoning and get sign-off from team lead.

---

## Section 9: Next Epoch Pre-Registration

Based on this retrospective, the next PFC should address:

| Change | Type | Rationale |
|--------|------|-----------|
| | Feature / Model / Data / Metric | |

Is a new PFC required before next epoch? [ ] YES [ ] NO

---

## Sign-Off

**Author:** ___________  **Date:** ___________
**Team Lead:** ___________  **Date:** ___________

> Run `epoch_closure.py --retrospective [this-file]` to validate completeness before closing epoch.
