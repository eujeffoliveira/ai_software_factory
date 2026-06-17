"""
Run all factory validators and report aggregate results.

Usage:
    python tools/factory-validators/run_all.py [--fail-fast]

Exit codes:
    0  all validators passed
    1  one or more validators failed
"""
import importlib.util
import os
import sys
import time
from pathlib import Path

VALIDATORS_DIR = Path(__file__).parent

VALIDATORS = [
    "validate_governance_files",
    "validate_licensing",
    "validate_json_files",
    "validate_agent_structure",
    "validate_skill_structure",
    "validate_source_maps",
    "validate_golden_models",
    "validate_prompt_mcp_policy",
    "validate_runtime_compatibility",
    "validate_no_hardcoded_paths",
    "validate_markdown_links",
]


def run_validator(name: str) -> tuple[int, str]:
    spec = importlib.util.spec_from_file_location(name, VALIDATORS_DIR / f"{name}.py")
    mod = importlib.util.module_from_spec(spec)

    import io
    from contextlib import redirect_stdout
    buf = io.StringIO()
    try:
        spec.loader.exec_module(mod)
        with redirect_stdout(buf):
            rc = mod.main()
    except SystemExit as e:
        rc = int(e.code) if e.code is not None else 0
    except Exception as e:
        rc = 1
        buf.write(f"  EXCEPTION: {e}\n")

    return rc, buf.getvalue()


def main() -> int:
    fail_fast = "--fail-fast" in sys.argv

    results: list[tuple[str, int, str]] = []
    overall = 0

    print("=" * 60)
    print("AI Software Factory — Validator Suite")
    print("=" * 60)
    start = time.monotonic()

    for name in VALIDATORS:
        t0 = time.monotonic()
        rc, output = run_validator(name)
        elapsed = time.monotonic() - t0
        results.append((name, rc, output))
        if rc != 0:
            overall = 1

        status = "PASS" if rc == 0 else "FAIL"
        first_line = output.strip().splitlines()[0] if output.strip() else name
        print(f"  [{status}] {first_line}  ({elapsed:.2f}s)")

        if rc != 0:
            for line in output.strip().splitlines()[1:]:
                print(f"        {line}")

        if fail_fast and rc != 0:
            print("\nStopped early due to --fail-fast")
            break

    elapsed_total = time.monotonic() - start
    passed = sum(1 for _, rc, _ in results if rc == 0)
    failed = sum(1 for _, rc, _ in results if rc != 0)

    print("=" * 60)
    print(f"Result: {passed} passed, {failed} failed — {elapsed_total:.2f}s total")
    if overall == 0:
        print("All validators PASSED.")
    else:
        print("Some validators FAILED. Fix the issues above and re-run.")
    print("=" * 60)

    return overall


if __name__ == "__main__":
    sys.exit(main())
