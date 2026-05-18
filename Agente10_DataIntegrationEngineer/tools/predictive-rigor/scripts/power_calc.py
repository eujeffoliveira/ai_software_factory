#!/usr/bin/env python3
"""
power_calc.py — Statistical power and sample size calculator for model evaluation.
Determines required sample size N for adequate statistical power.

Usage:
  python power_calc.py --effect-size 0.003 --alpha 0.05 --power 0.80
  python power_calc.py --actual-n 500 --effect-size 0.003 --alpha 0.05

Exit codes: 0=adequate power, 1=insufficient power
"""

import argparse
import json
import math
import sys
from datetime import datetime
from pathlib import Path


def z_from_p(p: float) -> float:
    """Inverse normal CDF approximation (Abramowitz and Stegun)."""
    if p <= 0 or p >= 1:
        raise ValueError(f"p must be in (0, 1), got {p}")
    # For p >= 0.5, work with 1-p
    flip = p < 0.5
    q = p if p < 0.5 else 1 - p
    t = math.sqrt(-2 * math.log(q))
    c = [2.515517, 0.802853, 0.010328]
    d = [1.432788, 0.189269, 0.001308]
    z = t - (c[0] + c[1] * t + c[2] * t**2) / (1 + d[0] * t + d[1] * t**2 + d[2] * t**3)
    return -z if flip else z


def required_n_brier(effect_size: float, alpha: float = 0.05, power: float = 0.80,
                     baseline_brier: float = 0.25) -> int:
    """
    Estimate N for detecting a Brier Score improvement of effect_size.
    Uses normal approximation for Brier Score variance.

    Brier score variance approximation: Var(BS) ≈ BS * (1-BS) / N
    """
    z_alpha = z_from_p(alpha / 2)  # two-tailed
    z_beta = z_from_p(1 - power)   # power

    # Variance of the Brier score difference under H1
    sigma_sq = 2 * baseline_brier * (1 - baseline_brier)
    n = sigma_sq * ((z_alpha + z_beta) ** 2) / (effect_size ** 2)
    return math.ceil(n)


def achieved_power(n: int, effect_size: float, alpha: float = 0.05,
                   baseline_brier: float = 0.25) -> float:
    """Compute achieved power given actual N."""
    z_alpha = z_from_p(alpha / 2)
    sigma_sq = 2 * baseline_brier * (1 - baseline_brier)
    sigma = math.sqrt(sigma_sq / n)
    if sigma == 0:
        return 1.0
    z_beta = effect_size / sigma - z_alpha
    # Power = Phi(z_beta) — approximate with logistic
    return 1 / (1 + math.exp(-1.7 * z_beta))


def run(args) -> int:
    effect_size = args.effect_size
    alpha = args.alpha
    target_power = args.power
    baseline_brier = args.baseline_brier

    print("\n=== STATISTICAL POWER CALCULATOR ===")
    print(f"Effect size (Brier delta): {effect_size}")
    print(f"Alpha (significance): {alpha}")
    print(f"Target power: {target_power}")
    print(f"Baseline Brier score: {baseline_brier}")
    print()

    n_required = required_n_brier(effect_size, alpha, target_power, baseline_brier)
    print(f"Required N for {target_power:.0%} power: {n_required}")

    results = {
        "effect_size": effect_size,
        "alpha": alpha,
        "target_power": target_power,
        "baseline_brier": baseline_brier,
        "n_required": n_required,
    }

    # Power curve
    print("\nPower curve:")
    print(f"{'N':>8} {'Power':>8}")
    for mult in [0.25, 0.5, 0.75, 1.0, 1.5, 2.0, 3.0]:
        n = int(n_required * mult)
        if n < 10:
            continue
        pwr = achieved_power(n, effect_size, alpha, baseline_brier)
        marker = " <-- target" if abs(mult - 1.0) < 0.01 else ""
        print(f"{n:>8} {pwr:>8.3f}{marker}")

    # If actual N provided, check adequacy
    exit_code = 0
    if args.actual_n:
        n = args.actual_n
        pwr = achieved_power(n, effect_size, alpha, baseline_brier)
        results["actual_n"] = n
        results["achieved_power"] = round(pwr, 4)
        print(f"\nActual N={n}: achieved power = {pwr:.3f}")
        if pwr >= target_power:
            print(f"VERDICT: ADEQUATE (power {pwr:.1%} >= target {target_power:.1%})")
        else:
            print(f"VERDICT: INSUFFICIENT (power {pwr:.1%} < target {target_power:.1%})")
            print(f"         Need {n_required - n} more observations to reach target power.")
            exit_code = 1
        results["verdict"] = "ADEQUATE" if pwr >= target_power else "INSUFFICIENT"

    out = Path(args.output) if args.output else Path("power_report.json")
    out.write_text(json.dumps({
        "timestamp": datetime.now().isoformat(),
        **results,
    }, indent=2))
    print(f"\nReport saved: {out}")

    return exit_code


def main():
    parser = argparse.ArgumentParser(description="Statistical power calculator for model evaluation")
    parser.add_argument("--effect-size", type=float, default=0.003,
                        help="Minimum detectable Brier score improvement (default: 0.003)")
    parser.add_argument("--alpha", type=float, default=0.05,
                        help="Significance level (default: 0.05)")
    parser.add_argument("--power", type=float, default=0.80,
                        help="Target statistical power (default: 0.80)")
    parser.add_argument("--baseline-brier", type=float, default=0.25,
                        help="Baseline Brier score for variance estimation (default: 0.25)")
    parser.add_argument("--actual-n", type=int,
                        help="Actual test set size to check power adequacy")
    parser.add_argument("--output", help="Output JSON report path")
    sys.exit(run(parser.parse_args()))


if __name__ == "__main__":
    main()
