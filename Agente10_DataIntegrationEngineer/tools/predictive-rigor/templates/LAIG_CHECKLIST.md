# Look-Ahead Inspection Gate (LAIG) Checklist

**Purpose:** Systematically identify features or data transformations that use future information unavailable at prediction time.
**When to run:** Before any model training. Required by PFC (Section 4).

**Pipeline:** `___________`
**Date:** `___________`
**Inspector:** `___________`

---

## Feature Inventory Table

Complete for every feature in the model.

| # | Feature Name | Source Table/API | Timestamp Column | Available At | Look-Ahead Risk | Verdict |
|---|-------------|-----------------|-----------------|--------------|-----------------|---------|
| 1 | | | | prediction_time / T+1 / T+N | LOW / MED / HIGH | PASS / FAIL |
| 2 | | | | | | |
| 3 | | | | | | |

**"Available At"** must be strictly BEFORE the prediction timestamp for PASS.

---

## 8 Common FAIL Patterns

### FAIL-01: Direct Future Leakage
Using the target variable itself (or a direct proxy) as a feature.

```python
# BAD — result used as feature
df['home_won_last_3'] = df.groupby('home_team')['result'].shift(-1).rolling(3).mean()
# GOOD — shift forward, not backward
df['home_won_last_3'] = df.groupby('home_team')['result'].shift(1).rolling(3).mean()
```

Check: Does any feature use `.shift(-N)` or negative time offsets? → **FAIL**

---

### FAIL-02: Aggregation Window Crossing Prediction Time
Rolling statistics that include data from after the prediction point.

```python
# BAD — window crosses prediction point
df['rolling_avg'] = df['metric'].rolling(window=10, center=True).mean()
# GOOD — expanding window into past only
df['rolling_avg'] = df['metric'].rolling(window=10).mean().shift(1)
```

Check: Any `center=True` in rolling operations? Any unshifted rolling aggregates? → **FAIL**

---

### FAIL-03: Target Encoding with Full Dataset
Computing target statistics using validation/test data.

```python
# BAD — uses full dataset mean
mean_encoding = df.groupby('category')['target'].mean()
# GOOD — compute on training fold only, apply to all
```

Check: Is target encoding computed on the full dataset rather than training only? → **FAIL**

---

### FAIL-04: Normalization with Future Statistics
Scaling or normalizing with statistics computed on full dataset.

```python
# BAD — scaler fit on all data
scaler = StandardScaler().fit(X)
# GOOD — fit on training only
scaler = StandardScaler().fit(X_train)
```

Check: Is `fit_transform` called on X (all data) rather than X_train? → **FAIL**

---

### FAIL-05: Time-Based Train/Test Split Error
Random split instead of temporal split for time-series data.

```python
# BAD — random split ignores time
X_train, X_test = train_test_split(X, random_state=42)
# GOOD — temporal split
cutoff = int(len(X) * 0.8)
X_train, X_test = X[:cutoff], X[cutoff:]
```

Check: Is `train_test_split` used on temporal data without time-aware splitting? → **FAIL**

---

### FAIL-06: External Data with Future Timestamps
Joining external datasets (odds, weather, market data) that may contain post-event information.

Check: Are external joins filtered to `external.timestamp < prediction_timestamp`? → **FAIL** if not

---

### FAIL-07: Cumulative Statistics Without Lag
Cumulative sums or counts that include the current event.

```python
# BAD — includes current row
df['cumsum'] = df.groupby('team')['goals'].cumsum()
# GOOD — excludes current row
df['cumsum'] = df.groupby('team')['goals'].cumsum().shift(1)
```

Check: Any cumulative operation without `.shift(1)` applied? → **FAIL**

---

### FAIL-08: Model Selection Bias
Choosing hyperparameters or feature sets based on test set performance.

Check: Was the test set ever used to make model selection decisions? → **FAIL**

---

## Summary Gate

| Pattern | Status | Affected Features |
|---------|--------|-------------------|
| FAIL-01: Direct Future Leakage | PASS / FAIL | |
| FAIL-02: Aggregation Window Crossing | PASS / FAIL | |
| FAIL-03: Target Encoding | PASS / FAIL | |
| FAIL-04: Normalization Statistics | PASS / FAIL | |
| FAIL-05: Train/Test Split | PASS / FAIL | |
| FAIL-06: External Data Timestamps | PASS / FAIL | |
| FAIL-07: Cumulative Without Lag | PASS / FAIL | |
| FAIL-08: Model Selection Bias | PASS / FAIL | |

**Overall LAIG Verdict:** PASS / FAIL

A single FAIL blocks model training until resolved and re-inspected.

---

## Inspector Sign-Off

**Inspector:** ___________  **Date:** ___________
**Reviewer:** ___________  **Date:** ___________
