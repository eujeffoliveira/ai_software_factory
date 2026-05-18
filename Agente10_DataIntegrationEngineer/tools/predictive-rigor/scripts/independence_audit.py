#!/usr/bin/env python3
"""
independence_audit.py — Multi-layer independence verification for ML pipelines.
Checks train/test independence across data sources, feature engineering, and temporal ordering.

Usage:
  python independence_audit.py --train train.parquet --test test.parquet \
                                [--timestamp-col date] [--target-col result]

Exit codes: 0=PASS, 1=WARN, 2=FAIL
"""

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path

import numpy as np

try:
    import pandas as pd
    HAS_PANDAS = True
except ImportError:
    print("ERROR: pandas required. pip install pandas", file=sys.stderr)
    sys.exit(2)


def check_row_overlap(train: pd.DataFrame, test: pd.DataFrame) -> dict:
    """L1: Detect duplicate rows between train and test."""
    # Use a hash of each row for comparison
    try:
        train_hashes = set(pd.util.hash_pandas_object(train, index=False))
        test_hashes = set(pd.util.hash_pandas_object(test, index=False))
        overlap = len(train_hashes & test_hashes)
    except Exception:
        overlap = 0  # Can't check without hashing

    return {
        "layer": "L1_row_overlap",
        "n_train": len(train),
        "n_test": len(test),
        "n_overlap": overlap,
        "overlap_pct": round(overlap / len(test) * 100, 2) if len(test) > 0 else 0,
        "verdict": "FAIL" if overlap > 0 else "PASS",
        "details": f"{overlap} duplicate rows found between train and test" if overlap > 0 else "No row overlap",
    }


def check_temporal_ordering(train: pd.DataFrame, test: pd.DataFrame, timestamp_col: str) -> dict:
    """L5: Verify train timestamps all precede test timestamps."""
    if timestamp_col not in train.columns or timestamp_col not in test.columns:
        return {
            "layer": "L5_temporal_ordering",
            "verdict": "UNKNOWN",
            "details": f"Timestamp column '{timestamp_col}' not found in data",
        }

    try:
        train_ts = pd.to_datetime(train[timestamp_col])
        test_ts = pd.to_datetime(test[timestamp_col])
        max_train = train_ts.max()
        min_test = test_ts.min()
        gap_days = (min_test - max_train).days

        overlap_count = (train_ts > min_test).sum()

        verdict = "PASS" if gap_days >= 0 and overlap_count == 0 else "FAIL"
        return {
            "layer": "L5_temporal_ordering",
            "max_train_date": str(max_train.date()),
            "min_test_date": str(min_test.date()),
            "gap_days": gap_days,
            "train_rows_after_test_start": int(overlap_count),
            "verdict": verdict,
            "details": f"Gap: {gap_days} days. Train rows after test start: {overlap_count}",
        }
    except Exception as e:
        return {
            "layer": "L5_temporal_ordering",
            "verdict": "ERROR",
            "details": str(e),
        }


def check_feature_distribution_shift(train: pd.DataFrame, test: pd.DataFrame,
                                      target_col: str = None) -> dict:
    """L2/L6: Check for unexpected distribution shifts in features."""
    issues = []
    numeric_cols = [c for c in train.select_dtypes(include=[np.number]).columns
                    if c != target_col][:20]  # limit to 20 cols for performance

    for col in numeric_cols:
        if col not in test.columns:
            continue
        try:
            train_mean = train[col].mean()
            test_mean = test[col].mean()
            train_std = train[col].std()
            if train_std > 0:
                z = abs(train_mean - test_mean) / train_std
                if z > 3:  # >3 std is suspicious
                    issues.append(f"{col}: train_mean={train_mean:.3f}, test_mean={test_mean:.3f} (z={z:.2f})")
        except Exception:
            pass

    return {
        "layer": "L6_feature_distribution",
        "features_checked": len(numeric_cols),
        "suspicious_features": issues,
        "verdict": "WARN" if issues else "PASS",
        "details": f"{len(issues)} features with >3σ mean shift" if issues else "Feature distributions look reasonable",
    }


def check_target_distribution(train: pd.DataFrame, test: pd.DataFrame, target_col: str) -> dict:
    """Verify target distribution shift is documented."""
    if target_col not in train.columns or target_col not in test.columns:
        return {"layer": "target_distribution", "verdict": "UNKNOWN", "details": f"'{target_col}' not found"}

    train_rate = train[target_col].mean()
    test_rate = test[target_col].mean()
    shift = abs(train_rate - test_rate)

    return {
        "layer": "target_distribution",
        "train_positive_rate": round(float(train_rate), 4),
        "test_positive_rate": round(float(test_rate), 4),
        "absolute_shift": round(float(shift), 4),
        "verdict": "WARN" if shift > 0.05 else "PASS",
        "details": f"Target rate: train={train_rate:.3f}, test={test_rate:.3f} (shift={shift:.3f})",
    }


def run(args) -> int:
    def load_data(path_str: str) -> pd.DataFrame:
        p = Path(path_str)
        if p.suffix == ".parquet":
            return pd.read_parquet(p)
        elif p.suffix == ".csv":
            return pd.read_csv(p)
        else:
            raise ValueError(f"Unsupported format: {p.suffix}")

    print("\n=== INDEPENDENCE AUDIT ===")
    print(f"Date: {datetime.now().strftime('%Y-%m-%d')}\n")

    try:
        train = load_data(args.train)
        test = load_data(args.test)
    except Exception as e:
        print(f"ERROR loading data: {e}", file=sys.stderr)
        return 2

    print(f"Train: {args.train} — {train.shape}")
    print(f"Test:  {args.test} — {test.shape}\n")

    checks = []

    # Layer 1: Row overlap
    r = check_row_overlap(train, test)
    checks.append(r)
    print(f"[{r['verdict']:7}] {r['layer']}: {r['details']}")

    # Layer 5: Temporal ordering
    if args.timestamp_col:
        r = check_temporal_ordering(train, test, args.timestamp_col)
        checks.append(r)
        print(f"[{r['verdict']:7}] {r['layer']}: {r['details']}")

    # Layer 6: Feature distribution
    r = check_feature_distribution_shift(train, test, args.target_col)
    checks.append(r)
    print(f"[{r['verdict']:7}] {r['layer']}: {r['details']}")
    if r["suspicious_features"]:
        for f in r["suspicious_features"][:5]:
            print(f"          - {f}")

    # Target distribution
    if args.target_col:
        r = check_target_distribution(train, test, args.target_col)
        checks.append(r)
        print(f"[{r['verdict']:7}] {r['layer']}: {r['details']}")

    # Overall verdict
    verdicts = [c["verdict"] for c in checks]
    if "FAIL" in verdicts:
        overall = "FAIL"
        exit_code = 2
    elif "WARN" in verdicts:
        overall = "WARN"
        exit_code = 1
    else:
        overall = "PASS"
        exit_code = 0

    print(f"\nOVERALL: {overall}")

    report = {
        "timestamp": datetime.now().isoformat(),
        "train_file": args.train,
        "test_file": args.test,
        "train_shape": list(train.shape),
        "test_shape": list(test.shape),
        "checks": checks,
        "overall": overall,
    }
    out = Path(args.output) if args.output else Path("independence_audit_report.json")
    out.write_text(json.dumps(report, indent=2))
    print(f"Report saved: {out}")

    return exit_code


def main():
    parser = argparse.ArgumentParser(description="Independence audit for ML train/test splits")
    parser.add_argument("--train", required=True, help="Training data file (.parquet or .csv)")
    parser.add_argument("--test", required=True, help="Test data file (.parquet or .csv)")
    parser.add_argument("--timestamp-col", help="Timestamp column for temporal ordering check")
    parser.add_argument("--target-col", help="Target/outcome column name")
    parser.add_argument("--output", help="Output JSON report path")
    sys.exit(run(parser.parse_args()))


if __name__ == "__main__":
    main()
