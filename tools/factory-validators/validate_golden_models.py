"""
Validate that all 8 Golden Model files and the project-classification spec exist in standards/.

Also checks that each golden model file contains a recognizable archetype identifier.
"""
import os
import sys
from pathlib import Path

FACTORY_ROOT = Path(os.environ.get("FACTORY_ROOT", Path(__file__).parent.parent.parent))

EXPECTED_GOLDEN_MODELS = {
    "golden-model-web-app.md": "web_app",
    "golden-model-python-automation.md": "automation_script",
    "golden-model-data-pipeline.md": "data_pipeline",
    "golden-model-api-service.md": "api_service",
    "golden-model-cli-tool.md": "cli_tool",
    "golden-model-mcp-server.md": "mcp_server",
    "golden-model-integration-worker.md": "integration_worker",
    "golden-model-notebook-analysis.md": "notebook_analysis",
}

REQUIRED_EXTRA = ["project-classification.md"]


def main() -> int:
    standards = FACTORY_ROOT / "standards"
    errors = []

    if not standards.is_dir():
        print("ERROR: standards/ directory not found")
        return 1

    for filename, archetype in EXPECTED_GOLDEN_MODELS.items():
        path = standards / filename
        if not path.is_file():
            errors.append(f"  MISSING: standards/{filename}")
        else:
            content = path.read_text(encoding="utf-8-sig")
            if archetype not in content:
                errors.append(f"  standards/{filename} does not mention archetype {archetype!r}")

    for filename in REQUIRED_EXTRA:
        if not (standards / filename).is_file():
            errors.append(f"  MISSING: standards/{filename}")

    total = len(EXPECTED_GOLDEN_MODELS) + len(REQUIRED_EXTRA)
    failed = len(errors)
    passed = total - failed

    print(f"validate_golden_models: {total} files checked, {passed} OK, {failed} failed")
    for e in errors:
        print(e)

    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
