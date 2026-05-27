"""
Validate that each AgenteXX directory contains all required files and folders.

Required top-level items per agent:
  Files: prompt.md, agent_config.json, context_view.md, rag_manifest.json,
         skills_manifest.md, quality_gate.md, handoff_schema.json, failure_modes.md
  Folders: knowledge/, checklists/, schemas/, templates/, examples/, skills/

Required files inside knowledge/:
  principles.md, heuristics.md, decision_rules.md, knowledge_cards.md, source_map.json
"""
import json
import os
import sys
from pathlib import Path

FACTORY_ROOT = Path(os.environ.get("FACTORY_ROOT", Path(__file__).parent.parent.parent))

REQUIRED_FILES = [
    "prompt.md",
    "agent_config.json",
    "context_view.md",
    "rag_manifest.json",
    "skills_manifest.md",
    "quality_gate.md",
    "handoff_schema.json",
    "failure_modes.md",
]

REQUIRED_DIRS = ["knowledge", "checklists", "schemas", "templates", "examples", "skills"]

REQUIRED_KNOWLEDGE = [
    "principles.md",
    "heuristics.md",
    "decision_rules.md",
    "knowledge_cards.md",
    "source_map.json",
]


def validate_agent(agent_dir: Path) -> list[str]:
    errors = []
    for f in REQUIRED_FILES:
        if not (agent_dir / f).is_file():
            errors.append(f"  MISSING file: {f}")
    for d in REQUIRED_DIRS:
        if not (agent_dir / d).is_dir():
            errors.append(f"  MISSING dir:  {d}/")
    knowledge = agent_dir / "knowledge"
    if knowledge.is_dir():
        for f in REQUIRED_KNOWLEDGE:
            if not (knowledge / f).is_file():
                errors.append(f"  MISSING knowledge/{f}")
    return errors


def main() -> int:
    agents = sorted(p for p in FACTORY_ROOT.iterdir() if p.is_dir() and p.name.startswith("Agente"))
    if not agents:
        print("ERROR: No AgenteXX directories found under", FACTORY_ROOT)
        return 1

    all_errors: dict[str, list[str]] = {}
    for agent in agents:
        errs = validate_agent(agent)
        if errs:
            all_errors[agent.name] = errs

    total = len(agents)
    failed = len(all_errors)
    passed = total - failed

    print(f"validate_agent_structure: {total} agents checked, {passed} OK, {failed} failed")
    for agent_name, errs in all_errors.items():
        print(f"\n  {agent_name}:")
        for e in errs:
            print(e)

    return 1 if all_errors else 0


if __name__ == "__main__":
    sys.exit(main())
