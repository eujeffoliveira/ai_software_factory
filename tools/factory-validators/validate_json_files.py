"""
Validate that all .json files in the repository are valid JSON.

Scans: AgenteXX_*/, standards/, tools/, .github/, root *.json
Skips: lib/ (gitignored books), build/
Handles UTF-8 BOM (utf-8-sig encoding).
"""
import json
import os
import sys
from pathlib import Path

FACTORY_ROOT = Path(os.environ.get("FACTORY_ROOT", Path(__file__).parent.parent.parent))

SKIP_DIRS = {"lib", "node_modules", ".git"}

SCAN_ROOTS = [
    lambda r: [p for p in r.iterdir() if p.is_dir() and p.name.startswith("Agente")],
    lambda r: [r / "standards"] if (r / "standards").is_dir() else [],
    lambda r: [r / "tools"] if (r / "tools").is_dir() else [],
    lambda r: [r / ".github"] if (r / ".github").is_dir() else [],
]


def collect_json_files() -> list[Path]:
    files: list[Path] = []
    for rule in SCAN_ROOTS:
        for root_dir in rule(FACTORY_ROOT):
            for p in root_dir.rglob("*.json"):
                parts = set(p.relative_to(FACTORY_ROOT).parts)
                if not parts.intersection(SKIP_DIRS):
                    files.append(p)
    # Also root-level JSON files
    for p in FACTORY_ROOT.glob("*.json"):
        files.append(p)
    return sorted(set(files))


def validate_json(path: Path) -> str | None:
    try:
        json.loads(path.read_text(encoding="utf-8-sig"))
        return None
    except json.JSONDecodeError as e:
        return str(e)


def main() -> int:
    files = collect_json_files()
    errors: dict[str, str] = {}

    for f in files:
        err = validate_json(f)
        if err:
            errors[str(f.relative_to(FACTORY_ROOT))] = err

    total = len(files)
    failed = len(errors)
    passed = total - failed

    print(f"validate_json_files: {total} JSON files checked, {passed} valid, {failed} invalid")
    for rel, msg in errors.items():
        print(f"\n  {rel}:")
        print(f"    {msg}")

    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
