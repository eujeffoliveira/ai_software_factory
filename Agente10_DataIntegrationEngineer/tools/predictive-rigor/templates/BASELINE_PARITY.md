# Baseline Parity Gate

**Purpose:** Every model must beat all 4 mandatory baselines before being considered valid.
**Gate criterion:** Brier Score delta must be >= 0.003 over each baseline.

---

## The 4 Mandatory Baselines

### Baseline 1: Flat (Global Mean)
The simplest possible model — predicts the training set mean for all observations.

```python
# baseline_1_flat.py
import numpy as np

def flat_baseline(y_train, y_test):
    mean_prob = np.mean(y_train)
    predictions = np.full(len(y_test), mean_prob)
    return predictions
```

**Interpretation:** If your model cannot beat a single number, it has learned nothing.

---

### Baseline 2: Home-Only (Domain-Simple)
A single-feature model using the most predictive domain signal. In sports prediction this is home advantage; in other domains, substitute the most obvious single predictor.

```python
# baseline_2_home.py
def home_only_baseline(X_test, home_feature_col):
    home_win_rate = 0.55  # calibrate from training data
    predictions = np.where(X_test[home_feature_col] == 1, home_win_rate, 1 - home_win_rate)
    return predictions
```

**Interpretation:** If your model cannot beat a one-variable rule, feature engineering is insufficient.

---

### Baseline 3: Market/Benchmark (Pinnacle or External)
Use market odds, expert consensus, or the best published benchmark for your domain.

```python
# baseline_3_market.py
def market_baseline(X_test, market_prob_col):
    return X_test[market_prob_col].values
```

**Interpretation:** The market/benchmark represents aggregated domain knowledge. This is the hardest baseline to beat and the most informative.

---

### Baseline 4: LogReg + Key Features
A logistic regression trained on 3-5 of the most obvious features. Establishes minimum ML baseline.

```python
# baseline_4_logreg.py
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler

def logreg_baseline(X_train, y_train, X_test, key_features):
    scaler = StandardScaler()
    X_tr = scaler.fit_transform(X_train[key_features])
    X_te = scaler.transform(X_test[key_features])
    lr = LogisticRegression(max_iter=1000)
    lr.fit(X_tr, y_train)
    return lr.predict_proba(X_te)[:, 1]
```

**Interpretation:** If your complex model cannot beat a simple logistic regression, complexity is unjustified.

---

## Brier Score Gate

```python
from sklearn.metrics import brier_score_loss

def check_baseline_parity(y_test, model_probs, baseline_probs, baseline_name, min_delta=0.003):
    model_brier = brier_score_loss(y_test, model_probs)
    baseline_brier = brier_score_loss(y_test, baseline_probs)
    delta = baseline_brier - model_brier  # positive = model is better
    
    passed = delta >= min_delta
    print(f"{baseline_name}: baseline={baseline_brier:.4f}, model={model_brier:.4f}, delta={delta:.4f} → {'PASS' if passed else 'FAIL'}")
    return passed, delta
```

**GATE:** All 4 baselines must PASS. A single FAIL blocks deployment.

---

## Reporting Template

```
BASELINE PARITY REPORT
Model: ___________  Date: ___________  Dataset: ___________

| Baseline         | Baseline Brier | Model Brier | Delta  | Gate   |
|------------------|---------------|-------------|--------|--------|
| Flat (mean)      |               |             |        | PASS/FAIL |
| Home-only        |               |             |        | PASS/FAIL |
| Pinnacle/Market  |               |             |        | PASS/FAIL |
| LogReg+features  |               |             |        | PASS/FAIL |

Overall: PASS / FAIL
```

---

## Common Failure Modes

| Failure | Root Cause | Fix |
|---------|-----------|-----|
| Fails Flat baseline | Model learns noise | Increase regularization, reduce features |
| Beats Flat but fails Market | Not enough signal | Add market features or accept model limits |
| Passes market on train, fails on test | Overfitting | Cross-validate properly, add epochs |
| Delta barely positive | Marginal model | Not production-worthy; continue development |
