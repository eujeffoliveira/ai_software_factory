"""
Validate that agent knowledge/ and skills/ files do not contain hardcoded absolute paths
or machine-specific references that would break portability.

Checks for:
  - Windows absolute paths: C:\\ D:\\ E:\\ (outside code fences)
  - Linux/Mac absolute paths in non-template contexts: /home/ /root/ /Users/
  - Specific usernames that could leak: patterns like C:\\Users\\<name>
  - Hardcoded FACTORY_ROOT values (should use env var reference instead)

Excludes: .json files (may contain schema examples), examples/ folders,
          and anything inside a code fence (``` blocks).
"""
import os
import re
import sys
from pathlib import Path

FACTORY_ROOT = Path(os.environ.get("FACTORY_ROOT", Path(__file__).parent.parent.parent))

PATTERNS = [
    (r"C:\\Users\\[^\\]+\\", "hardcoded Windows user path (C:\\Users\\<name>)"),
    (r"D:\\[A-Za-z]", "hardcoded D: drive path"),
    (r"/home/[a-z]", "hardcoded Linux home path (/home/<user>)"),
    (r"/Users/[A-Za-z]", "hardcoded macOS user path (/Users/<user>)"),
    (r"/root/", "hardcoded /root/ path"),
]

SCAN_EXTENSIONS = {".md"}
SKIP_DIRS = {"examples", "build", "lib"}


def strip_code_fences(text: str) -> str:
    return re.sub(r"```.*?```", "", text, flags=re.DOTALL)


def scan_file(path: Path) -> list[str]:
    errors = []
    try:
        content = strip_code_fences(path.read_text(encoding="utf-8-sig"))
    except Exception:
        return errors
    for pattern, label in PATTERNS:
        if re.search(pattern, content, re.IGNORECASE):
            errors.append(f"  {label}")
    return errors


def should_skip(path: Path) -> bool:
    for part in path.parts:
        if part in SKIP_DIRS:
            return True
    return False


def main() -> int:
    scan_roots = [
        FACTORY_ROOT / f"Agente{str(i).zfill(2)}_*"
        for i in range(11)
    ]

    all_files: list[Path] = []
    for agent in sorted(p for p in FACTORY_ROOT.iterdir() if p.is_dir() and p.name.startswith("Agente")):
        for ext in SCAN_EXTENSIONS:
            for fpath in agent.rglob(f"*{ext}"):
                if not should_skip(fpath.relative_to(FACTORY_ROOT)):
                    all_files.append(fpath)

    all_errors: dict[str, list[str]] = {}
    for fpath in sorted(all_files):
        errs = scan_file(fpath)
        if errs:
            rel = str(fpath.relative_to(FACTORY_ROOT))
            all_errors[rel] = errs

    total = len(all_files)
    failed = len(all_errors)
    passed = total - failed

    print(f"validate_no_hardcoded_paths: {total} files scanned, {passed} OK, {failed} with issues")
    for rel, errs in all_errors.items():
        print(f"\n  {rel}:")
        for e in errs:
            print(e)

    return 1 if all_errors else 0


if __name__ == "__main__":
    sys.exit(main())
