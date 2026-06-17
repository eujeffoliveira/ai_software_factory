"""
Validate that all required governance and community files exist.

Governance files (root level):
  README.md, AGENTS.md, CLAUDE.md, LICENSE, LICENSE-DOCS, NOTICE, CONTRIBUTING.md,
  CODE_OF_CONDUCT.md, SECURITY.md, SUPPORT.md, CHANGELOG.md, VERSION

GitHub templates:
  .github/PULL_REQUEST_TEMPLATE.md
  .github/ISSUE_TEMPLATE/bug_report.yml
  .github/ISSUE_TEMPLATE/mcp_problem.yml
  .github/ISSUE_TEMPLATE/agent_behavior.yml
  .github/ISSUE_TEMPLATE/documentation.yml
  .github/ISSUE_TEMPLATE/feature_request.yml

Key docs:
  docs/INSTALLATION.md, docs/MCP_RAG.md, docs/ROO_CODE.md, docs/CODEX.md,
  docs/AGENTS.md, docs/AGENT_CAPABILITY_MATRIX.md, docs/GOLDEN_MODELS.md,
  docs/TESTING.md, docs/ADDING_KNOWLEDGE.md
"""
import os
import sys
from pathlib import Path

FACTORY_ROOT = Path(os.environ.get("FACTORY_ROOT", Path(__file__).parent.parent.parent))

REQUIRED = [
    # Root governance
    "README.md",
    "AGENTS.md",
    "CLAUDE.md",
    "LICENSE",
    "LICENSE-DOCS",
    "NOTICE",
    "CONTRIBUTING.md",
    "CODE_OF_CONDUCT.md",
    "SECURITY.md",
    "SUPPORT.md",
    "CHANGELOG.md",
    "VERSION",
    # GitHub templates
    ".github/PULL_REQUEST_TEMPLATE.md",
    ".github/ISSUE_TEMPLATE/bug_report.yml",
    ".github/ISSUE_TEMPLATE/mcp_problem.yml",
    ".github/ISSUE_TEMPLATE/agent_behavior.yml",
    ".github/ISSUE_TEMPLATE/documentation.yml",
    ".github/ISSUE_TEMPLATE/feature_request.yml",
    # Key docs
    "docs/INSTALLATION.md",
    "docs/MCP_RAG.md",
    "docs/ROO_CODE.md",
    "docs/CODEX.md",
    "docs/AGENTS.md",
    "docs/AGENT_CAPABILITY_MATRIX.md",
    "docs/GOLDEN_MODELS.md",
    "docs/TESTING.md",
    "docs/ADDING_KNOWLEDGE.md",
]


def main() -> int:
    missing = []
    for rel in REQUIRED:
        if not (FACTORY_ROOT / rel).is_file():
            missing.append(f"  MISSING: {rel}")

    total = len(REQUIRED)
    failed = len(missing)
    passed = total - failed

    print(f"validate_governance_files: {total} files checked, {passed} present, {failed} missing")
    for m in missing:
        print(m)

    return 1 if missing else 0


if __name__ == "__main__":
    sys.exit(main())
