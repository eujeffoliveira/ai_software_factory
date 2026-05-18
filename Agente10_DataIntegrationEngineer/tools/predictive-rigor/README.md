# tools/predictive-rigor — Agente10_DataIntegrationEngineer

Statistical governance framework for predictive pipelines. Enforces scientific rigour, prevents look-ahead bias, and validates models against baselines before deployment.

## Directory Structure

```
predictive-rigor/
├── templates/                          # Governance documents (fill before analysis)
│   ├── PFC_TEMPLATE.md                 # Pre-registered Falsification Contract
│   ├── BASELINE_PARITY.md              # 4-baseline requirement spec
│   ├── LAIG_CHECKLIST.md               # Look-Ahead Inspection Gate checklist
│   ├── ADVERSARIAL_REVIEW_TEMPLATE.md  # Adversarial sign-off template
│   ├── INDEPENDENCE_AUDIT.md           # Independence verification template
│   └── RETROSPECTIVE_TEMPLATE.md       # Post-epoch retrospective template
└── scripts/                            # Automated checks
    ├── baseline_parity.py              # Gate: model must beat 4 baselines
    ├── heteroscedasticity_check.py     # Check residual heteroscedasticity
    ├── laig_scan.py                    # Automated look-ahead bias scanner
    ├── power_calc.py                   # Sample size and statistical power
    ├── sunk_cost_guard.py              # Plateau and regression detection
    ├── goalpost_lock.py                # Validate against pre-registered criteria
    ├── independence_audit.py           # Train/test independence verification
    └── pre_commit_governance.sh        # Git hook for governance pre-checks
```

## Governance Workflow

```
1. PFC_TEMPLATE.md    → Fill and commit BEFORE analysis
2. LAIG_CHECKLIST.md  → Check all features for look-ahead bias
3. laig_scan.py       → Automated scan of feature data
4. power_calc.py      → Verify sample size is adequate
5. [Build model]
6. baseline_parity.py → Must beat all 4 baselines (delta >= 0.003)
7. heteroscedasticity_check.py → Check residual structure
8. independence_audit.py → Verify train/test independence
9. goalpost_lock.py   → Validate against pre-registered PFC criteria
10. ADVERSARIAL_REVIEW_TEMPLATE.md → External sign-off
11. RETROSPECTIVE_TEMPLATE.md → Post-epoch lessons
```

## Quick Start

```bash
# Install dependencies
pip install scikit-learn statsmodels scipy pandas numpy

# Check sample size before building model
python scripts/power_calc.py --effect-size 0.003 --actual-n 500

# Scan features for look-ahead bias
python scripts/laig_scan.py --data features.parquet --target-col result --timestamp-col match_date

# Validate against baselines after training
python scripts/baseline_parity.py \
  --model-probs model_probs.npy \
  --actuals actuals.npy \
  --market-probs market_probs.npy

# Check for heteroscedasticity in residuals
python scripts/heteroscedasticity_check.py --residuals residuals.npy

# Verify train/test independence
python scripts/independence_audit.py --train train.parquet --test test.parquet --timestamp-col date

# Lock results against pre-registered criteria
python scripts/goalpost_lock.py --pfc pfc_contract.json --results model_results.json

# Install pre-commit hook
cp scripts/pre_commit_governance.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## Gate Criteria

| Gate | Tool | Pass Criterion |
|------|------|---------------|
| Baseline parity | `baseline_parity.py` | Brier delta >= 0.003 over ALL 4 baselines |
| Sample size | `power_calc.py` | Power >= 0.80 at effect_size=0.003 |
| Look-ahead | `laig_scan.py` | No HIGH severity issues |
| Independence | `independence_audit.py` | No row overlap; temporal gap >= 0 days |
| Heteroscedasticity | `heteroscedasticity_check.py` | p > 0.05 (Breusch-Pagan) |
| Goalpost | `goalpost_lock.py` | All primary PFC criteria met |

## Pre-registration Rule

**The PFC must be committed to git BEFORE any analysis begins.** The commit timestamp is proof of pre-registration. Post-hoc registration is invalid and invalidates the analysis.
