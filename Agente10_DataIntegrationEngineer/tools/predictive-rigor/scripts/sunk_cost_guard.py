#!/usr/bin/env python3
"""
sunk_cost_guard.py — Guards against sunk cost bias in iterative model development.
Evaluates whether continued investment in a model is statistically justified.

Usage:
  python sunk_cost_guard.py --history metrics_history.json [--min-epochs 5]

Exit codes: 0=CONTINUE, 1=WARN (plateau), 2=STOP (regression or no progress)
"""

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path


def compute_trend(values: list[float]) -> dict:
    """Compute linear trend slope over recent values."""
    n = len(values)
    if n < 2:
        return {"slope": 0, "trend": "FLAT", "r2": 0}
    x = list(range(n))
    x_mean = sum(x) / n
    y_mean = sum(values) / n
    ssxy = sum((xi - x_mean) * (yi - y_mean) for xi, yi in zip(x, values))
    ssx = sum((xi - x_mean) ** 2 for xi in x)
    slope = ssxy / ssx if ssx > 0 else 0
    y_pred = [y_mean + slope * (xi - x_mean) for xi in x]
    ss_res = sum((yi - yp) ** 2 for yi, yp in zip(values, y_pred))
    ss_tot = sum((yi - y_mean) ** 2 for yi in values)
    r2 = 1 - ss_res / ss_tot if ss_tot > 0 else 1

    if slope > 0.0001:
        trend = "IMPROVING"
    elif slope < -0.0001:
        trend = "REGRESSING"
    else:
        trend = "FLAT"

    return {"slope": round(slope, 6), "trend": trend, "r2": round(r2, 4)}


def run(args) -> int:
    history_path = Path(args.history)
    if not history_path.exists():
        print(f"ERROR: {history_path} not found", file=sys.stderr)
        return 2

    history = json.loads(history_path.read_text())
    # history format: list of {"epoch": N, "brier": float, "notes": str, ...}

    if not isinstance(history, list):
        print("ERROR: history file must be a JSON array of epoch records", file=sys.stderr)
        return 2

    epochs = sorted(history, key=lambda x: x.get("epoch", 0))
    n = len(epochs)

    print("\n=== SUNK COST GUARD ===")
    print(f"Epochs logged: {n}  Date: {datetime.now().strftime('%Y-%m-%d')}\n")

    if n < args.min_epochs:
        print(f"INSUFFICIENT DATA: Need at least {args.min_epochs} epochs (have {n}).")
        print("VERDICT: CONTINUE (collecting baseline)")
        return 0

    # Extract Brier scores
    briers = [e.get("brier") for e in epochs if e.get("brier") is not None]
    if not briers:
        print("ERROR: No 'brier' field found in history records", file=sys.stderr)
        return 2

    best = min(briers)
    latest = briers[-1]
    best_epoch = briers.index(best) + 1
    latest_epoch = len(briers)

    # Trend analysis
    recent_n = min(5, len(briers))
    recent_briers = briers[-recent_n:]
    trend = compute_trend(recent_briers)

    print(f"{'Epoch':>6} {'Brier':>10} {'Delta from best':>16}")
    print("-" * 35)
    for i, b in enumerate(briers):
        marker = " ← best" if b == best else ""
        delta = b - best
        print(f"{i+1:>6} {b:>10.6f} {delta:>+16.6f}{marker}")

    print(f"\nBest:    {best:.6f} (epoch {best_epoch})")
    print(f"Latest:  {latest:.6f} (epoch {latest_epoch})")
    print(f"Epochs since best: {latest_epoch - best_epoch}")
    print(f"Recent trend ({recent_n} epochs): {trend['trend']} (slope={trend['slope']:+.6f})")

    # Decision logic
    epochs_since_best = latest_epoch - best_epoch
    degradation = latest - best

    if trend["trend"] == "REGRESSING" and degradation > 0.01:
        verdict = "STOP"
        reason = f"Model is regressing: +{degradation:.4f} Brier over best. Active degradation."
        exit_code = 2
    elif epochs_since_best >= args.patience:
        verdict = "STOP"
        reason = f"No improvement in {epochs_since_best} epochs (patience={args.patience}). Plateau confirmed."
        exit_code = 2
    elif trend["trend"] == "FLAT" and epochs_since_best >= (args.patience // 2):
        verdict = "WARN"
        reason = f"Flat trend for {recent_n} epochs. Consider pivot."
        exit_code = 1
    else:
        verdict = "CONTINUE"
        reason = f"Model still improving (trend={trend['trend']}, epochs since best={epochs_since_best})."
        exit_code = 0

    print(f"\nVERDICT: {verdict}")
    print(f"Reason:  {reason}")

    if verdict in ["WARN", "STOP"]:
        print("\n--- Sunk Cost Analysis ---")
        print(f"Epochs invested so far: {n}")
        print("Do not let past investment justify continued work on a plateau model.")
        print("Ask: 'Would I START this model today, knowing what I know now?'")
        print("If NO: pivot or stop. If YES: document why and continue for max 2 more epochs.")

    report = {
        "timestamp": datetime.now().isoformat(),
        "n_epochs": n,
        "best_brier": best,
        "best_epoch": best_epoch,
        "latest_brier": latest,
        "latest_epoch": latest_epoch,
        "epochs_since_best": epochs_since_best,
        "trend": trend,
        "verdict": verdict,
        "reason": reason,
    }
    out = Path(args.output) if args.output else Path("sunk_cost_report.json")
    out.write_text(json.dumps(report, indent=2))
    print(f"\nReport saved: {out}")

    return exit_code


def main():
    parser = argparse.ArgumentParser(description="Sunk cost guard for iterative model development")
    parser.add_argument("--history", required=True,
                        help="JSON file with epoch metrics history [{epoch, brier, ...}]")
    parser.add_argument("--min-epochs", type=int, default=5,
                        help="Minimum epochs before evaluation (default: 5)")
    parser.add_argument("--patience", type=int, default=8,
                        help="Max epochs without improvement before STOP (default: 8)")
    parser.add_argument("--output", help="Output JSON report path")
    sys.exit(run(parser.parse_args()))


if __name__ == "__main__":
    main()
