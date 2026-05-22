"""
Validate that each skill inside every agent's skills/ folder contains the 6 required files.

Required per skill:
  skill.md, input.schema.json, output.schema.json, checklist.md
  examples/good_output.md, examples/bad_output.md

Also checks that skill.md contains a '## Knowledge Access Policy' section.
"""
import os
import sys
from pathlib import Path

FACTORY_ROOT = Path(os.environ.get("FACTORY_ROOT", Path(__file__).parent.parent.parent))

REQUIRED_SKILL_FILES = [
    "skill.md",
    "input.schema.json",
    "output.schema.json",
    "checklist.md",
]

REQUIRED_EXAMPLES = ["examples/good_output.md", "examples/bad_output.md"]

KNOWLEDGE_POLICY_MARKER = "## Knowledge Access Policy"


def validate_skill(skill_dir: Path) -> list[str]:
    errors = []
    for f in REQUIRED_SKILL_FILES:
        if not (skill_dir / f).is_file():
            errors.append(f"    MISSING: {f}")
    for f in REQUIRED_EXAMPLES:
        if not (skill_dir / f).is_file():
            errors.append(f"    MISSING: {f}")
    skill_md = skill_dir / "skill.md"
    if skill_md.is_file():
        content = skill_md.read_text(encoding="utf-8-sig")
        if KNOWLEDGE_POLICY_MARKER not in content:
            errors.append(f"    skill.md missing section: {KNOWLEDGE_POLICY_MARKER!r}")
    return errors


def main() -> int:
    agents = sorted(p for p in FACTORY_ROOT.iterdir() if p.is_dir() and p.name.startswith("Agente"))

    all_errors: dict[str, list[str]] = {}
    total_skills = 0

    for agent in agents:
        skills_dir = agent / "skills"
        if not skills_dir.is_dir():
            continue
        skills = sorted(p for p in skills_dir.iterdir() if p.is_dir())
        for skill in skills:
            total_skills += 1
            errs = validate_skill(skill)
            if errs:
                key = f"{agent.name}/{skill.name}"
                all_errors[key] = errs

    failed = len(all_errors)
    passed = total_skills - failed

    print(f"validate_skill_structure: {total_skills} skills checked, {passed} OK, {failed} failed")
    for skill_key, errs in all_errors.items():
        print(f"\n  {skill_key}:")
        for e in errs:
            print(e)

    return 1 if all_errors else 0


if __name__ == "__main__":
    sys.exit(main())
