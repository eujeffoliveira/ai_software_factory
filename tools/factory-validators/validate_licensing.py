"""
Validate that licensing files exist and contain expected content markers.

Checks:
  - LICENSE exists and mentions 'Apache License' and 'Version 2.0'
  - LICENSE-DOCS exists and mentions 'Creative Commons'
  - NOTICE exists and mentions 'Apache License' and 'Creative Commons'
  - CONTRIBUTING.md exists and mentions both 'Apache' and 'CC BY'
  - VERSION exists and contains a semver-like string
"""
import os
import re
import sys
from pathlib import Path

FACTORY_ROOT = Path(os.environ.get("FACTORY_ROOT", Path(__file__).parent.parent.parent))

CHECKS = [
    ("LICENSE", ["Apache License", "Version 2.0"]),
    ("LICENSE-DOCS", ["Creative Commons"]),
    ("NOTICE", ["Apache License", "Creative Commons"]),
    ("CONTRIBUTING.md", ["Apache", "CC BY"]),
    ("VERSION", []),
]

SEMVER_RE = re.compile(r"^\d+\.\d+\.\d+")


def validate_licensing() -> list[str]:
    errors = []
    for filename, markers in CHECKS:
        path = FACTORY_ROOT / filename
        if not path.is_file():
            errors.append(f"  MISSING: {filename}")
            continue
        content = path.read_text(encoding="utf-8-sig")
        for marker in markers:
            if marker not in content:
                errors.append(f"  {filename}: missing expected text {marker!r}")
        if filename == "VERSION":
            first_line = content.strip().splitlines()[0] if content.strip() else ""
            if not SEMVER_RE.match(first_line):
                errors.append(f"  VERSION: first line {first_line!r} is not a valid semver")
    return errors


def main() -> int:
    errors = validate_licensing()
    total = len(CHECKS)
    failed = len([e for e in errors if "MISSING" in e or "missing" in e])
    passed = total - len([e for e in errors if e.strip()])

    print(f"validate_licensing: {total} files checked")
    if not errors:
        print("  All licensing files present and valid")
    else:
        for e in errors:
            print(e)

    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
