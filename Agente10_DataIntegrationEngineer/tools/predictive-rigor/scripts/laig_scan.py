#!/usr/bin/env python3
"""
laig_scan.py — Automated Look-Ahead Inspection Gate scanner.
Scans a pandas DataFrame or numpy arrays for common look-ahead bias patterns.

Usage:
  python laig_scan.py --data features.parquet --target-col result \
                      --timestamp-col match_date [--train-cutoff 2024-01-01]

Exit codes: 0=PASS, 1=WARN, 2=FAIL
"""

import argparse
import json
import sys
import warnings
from datetime import datetime
from pathlib import Path

import numpy as np

try:
    import pandas as pd
    HAS_PANDAS = True
except ImportError:
    HAS_PANDAS = False
    print("ERROR: pandas required. pip install pandas", file=sys.stderr)
    sys.exit(2)


def check_negative_shifts(df: pd.DataFrame, target_col: str) -> list[dict]:
    """FAIL-01: Detect features derived with negative shift (future values)."""
    issues = []
    for col in df.columns:
        if col == target_col:
            continue
        # Check if column correlates with future target (shifted backward)
        if len(df) > 10:
            future_target = df[target_col].shift(-1)
            with warnings.catch_warnings():
                warnings.simplefilter("ignore")
                try:
                    corr = df[col].corr(future_target)
                    if abs(corr) > 0.6:
                        issues.append({
                            "feature": col,
                            "pattern": "FAIL-01",
                            "description": f"High correlation with future target (corr={corr:.3f})",
                            "severity": "HIGH",
                        })
                except Exception:
                    pass
    return issues


def check_rolling_center(df: pd.DataFrame, source_code: str = "") -> list[dict]:
    """FAIL-02: Detect center=True in rolling operations from source code."""
    issues = []
    if "center=True" in source_code:
        issues.append({
            "feature": "PIPELINE",
            "pattern": "FAIL-02",
            "description": "Found 'center=True' in rolling operation — includes future data",
            "severity": "HIGH",
        })
    return issues


def check_train_test_temporal(df: pd.DataFrame, timestamp_col: str, train_cutoff: str = None) -> list[dict]:
    """FAIL-05: Verify temporal ordering of train/test split."""
    issues = []
    if timestamp_col not in df.columns:
        return issues

    try:
        ts = pd.to_datetime(df[timestamp_col])
        if ts.is_monotonic_increasing is False:
            issues.append({
                "feature": timestamp_col,
                "pattern": "FAIL-05",
                "description": "Timestamps not monotonically increasing — data may not be sorted by time",
                "severity": "MEDIUM",
            })
        if train_cutoff:
            cutoff = pd.Timestamp(train_cutoff)
            n_before = (ts <= cutoff).sum()
            n_after = (ts > cutoff).sum()
            if n_before == 0:
                issues.append({
                    "feature": timestamp_col,
                    "pattern": "FAIL-05",
                    "description": f"No data before cutoff {train_cutoff} — check split correctness",
                    "severity": "HIGH",
                })
            if n_after == 0:
                issues.append({
                    "feature": timestamp_col,
                    "pattern": "FAIL-05",
                    "description": f"No data after cutoff {train_cutoff} — test set is empty",
                    "severity": "HIGH",
                })
    except Exception as e:
        issues.append({
            "feature": timestamp_col,
            "pattern": "FAIL-05",
            "description": f"Could not parse timestamps: {e}",
            "severity": "MEDIUM",
        })
    return issues


def check_cumsum_without_lag(df: pd.DataFrame, target_col: str) -> list[dict]:
    """FAIL-07: Detect cumulative statistics that may include current row."""
    issues = []
    for col in df.columns:
        if col == target_col:
            continue
        if df[col].dtype in [np.float64, np.float32, np.int64, np.int32]:
            # Check if column looks like a cumulative stat (monotonically increasing within groups)
            if df[col].is_monotonic_increasing and len(df) > 5:
                issues.append({
                    "feature": col,
                    "pattern": "FAIL-07",
                    "description": "Column appears to be cumulative and monotonically increasing — verify shift(1) was applied",
                    "severity": "LOW",
                })
    return issues


def check_target_correlation_suspicious(df: pd.DataFrame, target_col: str) -> list[dict]:
    """FAIL-03/FAIL-08: Detect suspiciously high correlation with target."""
    issues = []
    if target_col not in df.columns:
        return issues

    for col in df.columns:
        if col == target_col:
            continue
        try:
            with warnings.catch_warnings():
                warnings.simplefilter("ignore")
                corr = df[col].corr(df[target_col])
                if abs(corr) > 0.95:
                    issues.append({
                        "feature": col,
                        "pattern": "FAIL-03/FAIL-08",
                        "description": f"Suspiciously high correlation with target ({corr:.4f}) — possible target leakage",
                        "severity": "HIGH",
                    })
        except Exception:
            pass
    return issues


def run(args) -> int:
    path = Path(args.data)
    if path.suffix == ".parquet":
        df = pd.read_parquet(path)
    elif path.suffix == ".csv":
        df = pd.read_csv(path)
    else:
        print(f"ERROR: Unsupported format {path.suffix}. Use .parquet or .csv", file=sys.stderr)
        return 2

    print("\n=== LOOK-AHEAD INSPECTION GATE (LAIG) ===")
    print(f"Data: {path.name}  Shape: {df.shape}  Date: {datetime.now().strftime('%Y-%m-%d')}\n")

    all_issues = []
    source_code = Path(args.source_code).read_text() if args.source_code and Path(args.source_code).exists() else ""

    all_issues += check_negative_shifts(df, args.target_col)
    all_issues += check_rolling_center(df, source_code)
    if args.timestamp_col:
        all_issues += check_train_test_temporal(df, args.timestamp_col, args.train_cutoff)
    all_issues += check_cumsum_without_lag(df, args.target_col)
    all_issues += check_target_correlation_suspicious(df, args.target_col)

    # Report
    highs = [i for i in all_issues if i["severity"] == "HIGH"]
    meds = [i for i in all_issues if i["severity"] == "MEDIUM"]
    lows = [i for i in all_issues if i["severity"] == "LOW"]

    if all_issues:
        for issue in sorted(all_issues, key=lambda x: {"HIGH": 0, "MEDIUM": 1, "LOW": 2}[x["severity"]]):
            print(f"  [{issue['severity']:6}] {issue['pattern']} | {issue['feature']}: {issue['description']}")
    else:
        print("  No look-ahead issues detected.")

    print(f"\nSummary: {len(highs)} HIGH, {len(meds)} MEDIUM, {len(lows)} LOW")

    if highs:
        overall = "FAIL"
        exit_code = 2
    elif meds:
        overall = "WARN"
        exit_code = 1
    else:
        overall = "PASS"
        exit_code = 0

    print(f"OVERALL: {overall}")

    report = {
        "timestamp": datetime.now().isoformat(),
        "data_file": str(path),
        "shape": list(df.shape),
        "issues": all_issues,
        "summary": {"HIGH": len(highs), "MEDIUM": len(meds), "LOW": len(lows)},
        "overall": overall,
    }
    out = Path(args.output) if args.output else Path("laig_report.json")
    out.write_text(json.dumps(report, indent=2))
    print(f"Report saved: {out}")

    return exit_code


def main():
    parser = argparse.ArgumentParser(description="Look-Ahead Inspection Gate automated scanner")
    parser.add_argument("--data", required=True, help="Input data file (.parquet or .csv)")
    parser.add_argument("--target-col", required=True, help="Name of the target/outcome column")
    parser.add_argument("--timestamp-col", help="Name of the timestamp column")
    parser.add_argument("--train-cutoff", help="Training cutoff date (YYYY-MM-DD)")
    parser.add_argument("--source-code", help="Path to pipeline source code (for center=True detection)")
    parser.add_argument("--output", help="Output JSON report path")
    sys.exit(run(parser.parse_args()))


if __name__ == "__main__":
    main()
