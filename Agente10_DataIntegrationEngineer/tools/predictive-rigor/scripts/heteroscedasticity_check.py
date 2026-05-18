#!/usr/bin/env python3
"""
heteroscedasticity_check.py — Tests for heteroscedasticity in model residuals across time.
Uses Breusch-Pagan and White tests; also checks residual autocorrelation.

Usage:
  python heteroscedasticity_check.py --residuals residuals.npy [--timestamps timestamps.npy]

Exit codes: 0=PASS (p > 0.05), 1=WARN (0.01 < p <= 0.05), 2=FAIL (p <= 0.01)
"""

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path

import numpy as np

try:
    from statsmodels.stats.diagnostic import het_breuschpagan, het_white
    from statsmodels.stats.stattools import durbin_watson
    import statsmodels.api as sm
    HAS_STATSMODELS = True
except ImportError:
    HAS_STATSMODELS = False

try:
    from scipy import stats
    HAS_SCIPY = True
except ImportError:
    HAS_SCIPY = False


def manual_breusch_pagan(residuals: np.ndarray, X: np.ndarray) -> tuple[float, float]:
    """Simple Breusch-Pagan test without statsmodels."""
    n = len(residuals)
    sq_resid = residuals ** 2
    X_with_const = sm_like_add_constant(X)
    # OLS of squared residuals on X
    beta = np.linalg.lstsq(X_with_const, sq_resid, rcond=None)[0]
    fitted = X_with_const @ beta
    ss_res = np.sum((sq_resid - fitted) ** 2)
    ss_tot = np.sum((sq_resid - sq_resid.mean()) ** 2)
    r2 = 1 - ss_res / ss_tot if ss_tot > 0 else 0
    lm_stat = n * r2
    p_value = 1 - stats.chi2.cdf(lm_stat, df=X.shape[1]) if HAS_SCIPY else None
    return lm_stat, p_value


def sm_like_add_constant(X: np.ndarray) -> np.ndarray:
    return np.column_stack([np.ones(len(X)), X])


def autocorrelation_check(residuals: np.ndarray) -> dict:
    dw = durbin_watson(residuals) if HAS_STATSMODELS else None
    # Manual lag-1 autocorrelation
    if len(residuals) > 1:
        corr = np.corrcoef(residuals[:-1], residuals[1:])[0, 1]
    else:
        corr = 0.0
    return {
        "durbin_watson": round(dw, 4) if dw is not None else None,
        "lag1_autocorr": round(float(corr), 4),
        "dw_status": "PASS" if dw is not None and 1.5 < dw < 2.5 else ("WARN" if dw is not None else "UNKNOWN"),
    }


def run(args) -> int:
    residuals = np.load(args.residuals)
    timestamps = np.load(args.timestamps) if args.timestamps else np.arange(len(residuals))

    print("\n=== HETEROSCEDASTICITY CHECK ===")
    print(f"N residuals: {len(residuals)}  Date: {datetime.now().strftime('%Y-%m-%d')}\n")

    results = {}
    max_exit_code = 0

    # Use timestamps as the explanatory variable
    X = timestamps.reshape(-1, 1).astype(float)

    if HAS_STATSMODELS:
        X_const = sm.add_constant(X)
        bp_lm, bp_p, _, _ = het_breuschpagan(residuals, X_const)
        results["breusch_pagan"] = {
            "lm_stat": round(float(bp_lm), 4),
            "p_value": round(float(bp_p), 6),
            "verdict": "FAIL" if bp_p <= 0.01 else ("WARN" if bp_p <= 0.05 else "PASS"),
        }
        print(f"Breusch-Pagan LM: {bp_lm:.4f}  p={bp_p:.6f}  → {results['breusch_pagan']['verdict']}")

        try:
            white_lm, white_p, _, _ = het_white(residuals, X_const)
            results["white_test"] = {
                "lm_stat": round(float(white_lm), 4),
                "p_value": round(float(white_p), 6),
                "verdict": "FAIL" if white_p <= 0.01 else ("WARN" if white_p <= 0.05 else "PASS"),
            }
            print(f"White Test   LM: {white_lm:.4f}  p={white_p:.6f}  → {results['white_test']['verdict']}")
        except Exception:
            pass
    elif HAS_SCIPY:
        lm_stat, p_value = manual_breusch_pagan(residuals, X)
        results["breusch_pagan_manual"] = {
            "lm_stat": round(float(lm_stat), 4) if lm_stat else None,
            "p_value": round(float(p_value), 6) if p_value else None,
            "verdict": "FAIL" if (p_value and p_value <= 0.01) else ("WARN" if (p_value and p_value <= 0.05) else "PASS"),
        }
        v = results["breusch_pagan_manual"]["verdict"]
        print(f"BP (manual): stat={lm_stat:.4f}  p={p_value:.6f}  → {v}")
    else:
        print("WARNING: statsmodels and scipy not available. Install for full tests.")

    # Autocorrelation check
    ac = autocorrelation_check(residuals)
    results["autocorrelation"] = ac
    print(f"Lag-1 autocorr: {ac['lag1_autocorr']:.4f}  Durbin-Watson: {ac['durbin_watson']}  → {ac['dw_status']}")

    # Epoch-wise variance check (split into 5 epochs)
    if len(residuals) >= 50:
        n_epochs = 5
        epoch_size = len(residuals) // n_epochs
        variances = [np.var(residuals[i * epoch_size:(i + 1) * epoch_size]) for i in range(n_epochs)]
        cv = np.std(variances) / np.mean(variances) if np.mean(variances) > 0 else 0
        epoch_verdict = "PASS" if cv < 0.30 else ("WARN" if cv < 0.50 else "FAIL")
        results["epoch_variance"] = {
            "variances": [round(v, 6) for v in variances],
            "coefficient_of_variation": round(float(cv), 4),
            "verdict": epoch_verdict,
        }
        print(f"Epoch variance CV: {cv:.4f}  → {epoch_verdict}")

    # Overall verdict
    verdicts = [r.get("verdict", "PASS") for r in results.values() if isinstance(r, dict)]
    if "FAIL" in verdicts:
        overall = "FAIL"
        max_exit_code = 2
    elif "WARN" in verdicts:
        overall = "WARN"
        max_exit_code = 1
    else:
        overall = "PASS"
        max_exit_code = 0

    print(f"\nOVERALL: {overall}")

    report = {
        "timestamp": datetime.now().isoformat(),
        "n_residuals": len(residuals),
        "results": results,
        "overall": overall,
    }
    out = Path(args.output) if args.output else Path("heteroscedasticity_report.json")
    out.write_text(json.dumps(report, indent=2))
    print(f"Report saved: {out}")

    return max_exit_code


def main():
    parser = argparse.ArgumentParser(description="Heteroscedasticity and autocorrelation check for model residuals")
    parser.add_argument("--residuals", required=True, help=".npy file of model residuals (y_true - y_pred)")
    parser.add_argument("--timestamps", help=".npy file of timestamps (numeric) for ordered residuals")
    parser.add_argument("--output", help="Output JSON report path")
    sys.exit(run(parser.parse_args()))


if __name__ == "__main__":
    main()
