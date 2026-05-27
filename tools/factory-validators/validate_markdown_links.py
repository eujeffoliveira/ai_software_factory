"""
Validate internal markdown links in docs/ and root .md files.

Checks that links like [text](path) or [text](path#anchor) point to files
that actually exist. Skips external links (http/https/mailto), anchor-only
links (#section), and code fences.

Scans: docs/**/*.md, root *.md (README, CONTRIBUTING, etc.)
"""
import os
import re
import sys
from pathlib import Path
from urllib.parse import unquote

FACTORY_ROOT = Path(os.environ.get("FACTORY_ROOT", Path(__file__).parent.parent.parent))

LINK_RE = re.compile(r"\[(?:[^\]]*)\]\(([^)]+)\)")
CODE_FENCE_RE = re.compile(r"```.*?```", re.DOTALL)
INLINE_CODE_RE = re.compile(r"`[^`]+`")

SCAN_DIRS = ["docs"]
ROOT_GLOB = "*.md"

SKIP_PREFIXES = ("http://", "https://", "mailto:", "#", "ftp://")


def extract_links(content: str) -> list[str]:
    cleaned = CODE_FENCE_RE.sub("", content)
    cleaned = INLINE_CODE_RE.sub("", cleaned)
    return LINK_RE.findall(cleaned)


def resolve_link(link: str, source_file: Path) -> Path | None:
    target = link.split("#")[0].strip()
    if not target:
        return None
    target = unquote(target)
    if target.startswith("/"):
        return FACTORY_ROOT / target.lstrip("/")
    return (source_file.parent / target).resolve()


def validate_file(md_file: Path) -> list[str]:
    errors = []
    try:
        content = md_file.read_text(encoding="utf-8-sig")
    except Exception as e:
        return [f"  Cannot read file: {e}"]

    for link in extract_links(content):
        if any(link.startswith(p) for p in SKIP_PREFIXES):
            continue
        target = resolve_link(link, md_file)
        if target is None:
            continue
        if not target.exists():
            rel_source = md_file.relative_to(FACTORY_ROOT)
            errors.append(f"  broken link [{link!r}] -> {target} (does not exist)")

    return errors


def collect_files() -> list[Path]:
    files: list[Path] = []
    for d in SCAN_DIRS:
        scan_dir = FACTORY_ROOT / d
        if scan_dir.is_dir():
            files.extend(scan_dir.rglob("*.md"))
    files.extend(FACTORY_ROOT.glob(ROOT_GLOB))
    return sorted(set(files))


def main() -> int:
    files = collect_files()
    all_errors: dict[str, list[str]] = {}

    for f in files:
        errs = validate_file(f)
        if errs:
            all_errors[str(f.relative_to(FACTORY_ROOT))] = errs

    total = len(files)
    failed = len(all_errors)
    passed = total - failed

    print(f"validate_markdown_links: {total} files checked, {passed} OK, {failed} with broken links")
    for rel, errs in all_errors.items():
        print(f"\n  {rel}:")
        for e in errs:
            print(e)

    return 1 if all_errors else 0


if __name__ == "__main__":
    sys.exit(main())
