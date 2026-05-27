"""
Validate that every agent's prompt.md declares the knowledge access policy
and build-time/runtime isolation rule.

The MCP tool call block is injected by install.ps1 into ~/.claude/agents/ files,
not into the raw prompt.md. This validator checks the raw prompt.md for the
policy language that MUST be present regardless of install state.

Checks:
  - 'knowledge/' directory reference (runtime knowledge source)
  - Build-time/runtime isolation language
  - Knowledge distillation policy section
"""
import os
import sys
from pathlib import Path

FACTORY_ROOT = Path(os.environ.get("FACTORY_ROOT", Path(__file__).parent.parent.parent))

REQUIRED_MARKERS = [
    ("knowledge/ dir reference", ["knowledge/", "conhecimento/"]),
    ("runtime isolation rule", [
        "blocked_runtime_sources",
        "allowed_runtime_sources",
        "runtime_access_policy",
        "Blocked at runtime",
        "Runtime isolation",
        "Runtime Context Rule",
        "Build-Time Knowledge Distillation Policy",
        "blocked at runtime",
        "build-time",
        "build_time",
    ]),
]


def validate_prompt(agent_dir: Path) -> list[str]:
    errors = []
    prompt_path = agent_dir / "prompt.md"
    if not prompt_path.is_file():
        errors.append("  MISSING prompt.md")
        return errors

    content = prompt_path.read_text(encoding="utf-8-sig")
    for label, candidates in REQUIRED_MARKERS:
        if not any(c in content for c in candidates):
            errors.append(f"  prompt.md missing {label} (expected one of: {candidates})")
    return errors


def main() -> int:
    agents = sorted(p for p in FACTORY_ROOT.iterdir() if p.is_dir() and p.name.startswith("Agente"))
    if not agents:
        print("ERROR: No AgenteXX directories found")
        return 1

    all_errors: dict[str, list[str]] = {}
    for agent in agents:
        errs = validate_prompt(agent)
        if errs:
            all_errors[agent.name] = errs

    total = len(agents)
    failed = len(all_errors)
    passed = total - failed

    print(f"validate_prompt_mcp_policy: {total} agents checked, {passed} OK, {failed} failed")
    for agent_name, errs in all_errors.items():
        print(f"\n  {agent_name}:")
        for e in errs:
            print(e)

    return 1 if all_errors else 0


if __name__ == "__main__":
    sys.exit(main())
