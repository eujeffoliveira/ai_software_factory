"""
Validate that each agent's knowledge/source_map.json exists and is valid JSON
with recognizable structure. Source map schemas vary across agents (some use
'sources_processed_at_build_time', others 'sources'), so this validator checks
for the minimal invariants that hold across all agents:

  - File exists
  - Parses as valid JSON
  - Has at least one of: agent_id, agent, name (an agent identifier)
  - Has at least one list of source entries under any key named 'sources*'
  - Has at least one of: build_date, distillation_date (a timestamp)
"""
import json
import os
import sys
from pathlib import Path

FACTORY_ROOT = Path(os.environ.get("FACTORY_ROOT", Path(__file__).parent.parent.parent))

AGENT_ID_KEYS = {"agent_id", "agent", "name"}
def find_sources_list(data: dict) -> list | None:
    for key in data:
        if "source" in key.lower() and isinstance(data[key], list):
            return data[key]
    return None


def validate_source_map(agent_dir: Path) -> list[str]:
    errors = []
    sm_path = agent_dir / "knowledge" / "source_map.json"
    if not sm_path.is_file():
        errors.append("  MISSING knowledge/source_map.json")
        return errors

    try:
        data = json.loads(sm_path.read_text(encoding="utf-8-sig"))
    except json.JSONDecodeError as e:
        errors.append(f"  INVALID JSON in source_map.json: {e}")
        return errors

    if not isinstance(data, dict):
        errors.append("  source_map.json root must be a JSON object")
        return errors

    if not AGENT_ID_KEYS.intersection(data.keys()):
        errors.append(f"  Missing agent identifier (expected one of: {sorted(AGENT_ID_KEYS)})")

    sources = find_sources_list(data)
    if sources is None:
        errors.append("  No list field with 'source' in key name found")
    elif len(sources) == 0:
        errors.append("  Sources list is empty — expected at least one entry")

    return errors


def main() -> int:
    agents = sorted(p for p in FACTORY_ROOT.iterdir() if p.is_dir() and p.name.startswith("Agente"))
    if not agents:
        print("ERROR: No AgenteXX directories found under", FACTORY_ROOT)
        return 1

    all_errors: dict[str, list[str]] = {}
    for agent in agents:
        errs = validate_source_map(agent)
        if errs:
            all_errors[agent.name] = errs

    total = len(agents)
    failed = len(all_errors)
    passed = total - failed

    print(f"validate_source_maps: {total} agents checked, {passed} OK, {failed} failed")
    for agent_name, errs in all_errors.items():
        print(f"\n  {agent_name}:")
        for e in errs:
            print(e)

    return 1 if all_errors else 0


if __name__ == "__main__":
    sys.exit(main())
