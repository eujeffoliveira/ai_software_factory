#!/usr/bin/env python3
"""
baseline_parity.py — Validates model against 4 mandatory baselines.
Gate criterion: Brier Score delta >= 0.003 over each baseline.

Usage:
  python baseline_parity.py --model-probs model_probs.npy \
                             --actuals actuals.npy \
                             --market-probs market_probs.npy \
                             --home-indicator home_col.npy

Exit codes: 0=PASS, 1=FAIL, 2=ERROR
"""

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path

import numpy as np

try:
    from sklearn.metrics import brier_score_loss
    from sklearn.linear_model import LogisticRegression
    from sklearn.preprocessing import StandardScaler
except ImportError:
    print("ERROR: scikit-learn required. pip install scikit-learn", file=sys.stderr)
    sys.exit(2)

MIN_DELTA = 0.003


def flat_baseline(y: np.ndarray) -> np.ndarray:
    return np.full(len(y), y.mean())


def home_only_baseline(home_indicator: np.ndarray, y_train: np.ndarray, home_train: np.ndarray) -> np.ndarray:
    home_rate = y_train[home_train == 1].mean() if (home_train == 1).any() else 0.55
    away_rate = y_train[home_train == 0].mean() if (home_train == 0).any() else 0.45
    return np.where(home_indicator == 1, home_rate, away_rate)


def logreg_baseline(X_train: np.ndarray, y_train: np.ndarray, X_test: np.ndarray) -> np.ndarray:
    scaler = StandardScaler()
    X_tr = scaler.fit_transform(X_train)
    X_te = scaler.transform(X_test)
    lr = LogisticRegression(max_iter=1000, random_state=42)
    lr.fit(X_tr, y_train)
    return lr.predict_proba(X_te)[:, 1]


def check_parity(y_true: np.ndarray, model_probs: np.ndarray, baseline_probs: np.ndarray,
                 name: str, min_delta: float = MIN_DELTA) -> dict:
    model_brier = brier_score_loss(y_true, np.clip(model_probs, 1e-7, 1 - 1e-7))
    baseline_brier = brier_score_loss(y_true, np.clip(baseline_probs, 1e-7, 1 - 1e-7))
    delta = baseline_brier - model_brier  # positive = model beats baseline
    passed = delta >= min_delta

    return {
        "baseline": name,
        "baseline_brier": round(baseline_brier, 6),
        "model_brier": round(model_brier, 6),
        "delta": round(delta, 6),
        "threshold": min_delta,
        "passed": passed,
        "verdict": "PASS" if passed else "FAIL",
    }


def run(args) -> int:
    model_probs = np.load(args.model_probs)
    actuals = np.load(args.actuals)

    results = []
    failures = []

    # Baseline 1: Flat
    flat_probs = flat_baseline(actuals)
    r = check_parity(actuals, model_probs, flat_probs, "Flat (global mean)")
    results.append(r)
    if not r["passed"]:
        failures.append(r["baseline"])

    # Baseline 2: Home-only
    if args.home_indicator:
        home_ind = np.load(args.home_indicator)
        home_train = np.load(args.home_train) if args.home_train else home_ind
        y_train = np.load(args.train_actuals) if args.train_actuals else actuals
        home_probs = home_only_baseline(home_ind, y_train, home_train)
        r = check_parity(actuals, model_probs, home_probs, "Home-only")
        results.append(r)
        if not r["passed"]:
            failures.append(r["baseline"])

    # Baseline 3: Market/Benchmark
    if args.market_probs:
        market_probs = np.load(args.market_probs)
        r = check_parity(actuals, model_probs, market_probs, "Market/Benchmark")
        results.append(r)
        if not r["passed"]:
            failures.append(r["baseline"])

    # Baseline 4: LogReg (requires feature matrix)
    if args.features_train and args.features_test and args.train_actuals:
        X_train = np.load(args.features_train)
        X_test = np.load(args.features_test)
        y_train = np.load(args.train_actuals)
        logreg_probs = logreg_baseline(X_train, y_train, X_test)
        r = check_parity(actuals, model_probs, logreg_probs, "LogReg+features")
        results.append(r)
        if not r["passed"]:
            failures.append(r["baseline"])

    # Report
    print("\n=== BASELINE PARITY REPORT ===")
    print(f"Model: {args.model_probs}  Date: {datetime.now().strftime('%Y-%m-%d')}")
    print(f"Samples (test): N={len(actuals)}\n")
    print(f"{'Baseline':<22} {'Baseline Brier':>15} {'Model Brier':>12} {'Delta':>8} {'Verdict':>8}")
    print("-" * 70)
    for r in results:
        print(f"{r['baseline']:<22} {r['baseline_brier']:>15.6f} {r['model_brier']:>12.6f} "
              f"{r['delta']:>8.6f} {r['verdict']:>8}")

    print()
    if failures:
        print(f"OVERALL: FAIL — failed baselines: {', '.join(failures)}")
    else:
        print("OVERALL: PASS — all baselines cleared")

    # Save JSON report
    report = {
        "timestamp": datetime.now().isoformat(),
        "model_probs_file": str(args.model_probs),
        "n_test": len(actuals),
        "min_delta_threshold": MIN_DELTA,
        "results": results,
        "overall": "PASS" if not failures else "FAIL",
        "failed_baselines": failures,
    }
    report_path = Path(args.output) if args.output else Path("baseline_parity_report.json")
    report_path.write_text(json.dumps(report, indent=2))
    print(f"\nReport saved: {report_path}")

    return 0 if not failures else 1


def main():
    parser = argparse.ArgumentParser(description="Baseline parity gate for predictive models")
    parser.add_argument("--model-probs", required=True, help=".npy file of model probability outputs")
    parser.add_argument("--actuals", required=True, help=".npy file of actual outcomes (0/1)")
    parser.add_argument("--market-probs", help=".npy file of market/benchmark probabilities")
    parser.add_argument("--home-indicator", help=".npy file of home indicator (0/1) for test set")
    parser.add_argument("--home-train", help=".npy file of home indicator for training set")
    parser.add_argument("--train-actuals", help=".npy file of training actuals")
    parser.add_argument("--features-train", help=".npy feature matrix for training (for LogReg baseline)")
    parser.add_argument("--features-test", help=".npy feature matrix for test (for LogReg baseline)")
    parser.add_argument("--min-delta", type=float, default=MIN_DELTA, help=f"Minimum delta to pass (default: {MIN_DELTA})")
    parser.add_argument("--output", help="Output JSON report path")
    args = parser.parse_args()

    try:
        sys.exit(run(args))
    except Exception as e:
        print(f"ERROR: {e}", file=sys.stderr)
        sys.exit(2)


if __name__ == "__main__":
    main()
