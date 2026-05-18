#!/usr/bin/env python3
"""
goalpost_lock.py — Locks evaluation metrics to prevent goalpost shifting.
Reads a locked metrics contract and checks if results satisfy the pre-registered criteria.

Usage:
  python goalpost_lock.py --pfc pfc_contract.json --results current_results.json

Exit codes: 0=PASS (meets pre-registered criteria), 1=FAIL, 2=ERROR
"""

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path


ALLOWED_METRICS = {"brier_score", "accuracy", "auc_roc", "log_loss", "f1", "precision", "recall", "mse", "rmse", "mae"}


def compare_metric(name: str, actual: float, threshold: float, direction: str) -> dict:
    if direction == ">=":
        passed = actual >= threshold
    elif direction == "<=":
        passed = actual <= threshold
    elif direction == ">":
        passed = actual > threshold
    elif direction == "<":
        passed = actual < threshold
    elif direction == "==":
        passed = abs(actual - threshold) < 1e-9
    else:
        return {"metric": name, "actual": actual, "threshold": threshold,
                "direction": direction, "passed": False, "error": f"Unknown direction: {direction}"}

    return {
        "metric": name,
        "actual": round(actual, 6),
        "threshold": threshold,
        "direction": direction,
        "passed": passed,
        "verdict": "PASS" if passed else "FAIL",
    }


def run(args) -> int:
    pfc_path = Path(args.pfc)
    results_path = Path(args.results)

    if not pfc_path.exists():
        print(f"ERROR: PFC contract not found: {pfc_path}", file=sys.stderr)
        return 2
    if not results_path.exists():
        print(f"ERROR: Results file not found: {results_path}", file=sys.stderr)
        return 2

    pfc = json.loads(pfc_path.read_text())
    results = json.loads(results_path.read_text())

    print("\n=== GOALPOST LOCK CHECK ===")
    print(f"PFC: {pfc_path.name}  Date: {datetime.now().strftime('%Y-%m-%d')}\n")

    # Validate PFC has required fields
    if "success_criteria" not in pfc:
        print("ERROR: PFC missing 'success_criteria' field", file=sys.stderr)
        return 2

    criteria = pfc["success_criteria"]
    if not isinstance(criteria, list):
        print("ERROR: 'success_criteria' must be a list", file=sys.stderr)
        return 2

    checks = []
    failures = []
    warnings = []

    print(f"{'Metric':<25} {'Threshold':>12} {'Actual':>12} {'Direction':>10} {'Verdict':>8}")
    print("-" * 75)

    for criterion in criteria:
        metric = criterion.get("metric")
        threshold = criterion.get("threshold")
        direction = criterion.get("direction", "<=")
        is_primary = criterion.get("primary", False)

        if metric is None or threshold is None:
            print(f"  WARN: Malformed criterion: {criterion}")
            continue

        actual = results.get(metric)
        if actual is None:
            print(f"  {'MISSING':<25} — Results do not contain metric '{metric}'")
            warnings.append(f"Missing metric: {metric}")
            continue

        check = compare_metric(metric, actual, threshold, direction)
        check["primary"] = is_primary
        checks.append(check)

        label = metric + (" [P]" if is_primary else "")
        print(f"  {label:<25} {threshold:>12.6f} {actual:>12.6f} {direction:>10} {check['verdict']:>8}")

        if not check["passed"]:
            if is_primary:
                failures.append(f"{metric} (primary): {actual:.6f} not {direction} {threshold}")
            else:
                warnings.append(f"{metric}: {actual:.6f} not {direction} {threshold}")

    print()

    # Check for any metric that was NOT in the PFC (potential goalpost shift)
    locked_metrics = {c.get("metric") for c in criteria if c.get("metric")}
    extra_metrics = [k for k in results if k not in locked_metrics and k not in ("timestamp", "model", "notes")]
    if extra_metrics:
        print(f"WARN: Results contain metrics not in PFC (exploratory only): {extra_metrics}")
        print("      These cannot be used to claim model success.\n")
        warnings.extend([f"Extra metric (exploratory): {m}" for m in extra_metrics])

    # Final verdict
    if failures:
        overall = "FAIL"
        print(f"OVERALL: FAIL")
        print(f"  Failed primary criteria: {'; '.join(failures)}")
        exit_code = 1
    else:
        overall = "PASS"
        print(f"OVERALL: PASS — all pre-registered criteria met")
        exit_code = 0

    if warnings:
        print(f"\nWarnings:")
        for w in warnings:
            print(f"  - {w}")

    report = {
        "timestamp": datetime.now().isoformat(),
        "pfc_file": str(pfc_path),
        "results_file": str(results_path),
        "checks": checks,
        "failures": failures,
        "warnings": warnings,
        "extra_metrics_exploratory": extra_metrics,
        "overall": overall,
    }
    out = Path(args.output) if args.output else Path("goalpost_lock_report.json")
    out.write_text(json.dumps(report, indent=2))
    print(f"\nReport saved: {out}")

    return exit_code


def main():
    parser = argparse.ArgumentParser(description="Goalpost lock — validate results against pre-registered PFC criteria")
    parser.add_argument("--pfc", required=True, help="Pre-registered Falsification Contract JSON")
    parser.add_argument("--results", required=True, help="Current model results JSON {metric: value}")
    parser.add_argument("--output", help="Output JSON report path")
    sys.exit(run(parser.parse_args()))


if __name__ == "__main__":
    main()
