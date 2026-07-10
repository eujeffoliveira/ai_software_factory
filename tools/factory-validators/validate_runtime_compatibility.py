"""
Validate multi-runtime compatibility wiring for Claude Code and Codex.

This is a static repository check. It does not require the Claude or Codex CLIs
to be installed and does not inspect user-local generated files.
"""
import os
import re
import sys
from pathlib import Path

FACTORY_ROOT = Path(os.environ.get("FACTORY_ROOT", Path(__file__).parent.parent.parent))

AGENT_NAMES = [
    "techlead",
    "po",
    "architect",
    "engineer",
    "devbackend",
    "devfrontend",
    "qa",
    "devsecops",
    "devops",
    "uxui",
    "dataengineer",
    "dataanalyst",
]


def read_text(rel: str) -> str:
    path = FACTORY_ROOT / rel
    if not path.is_file():
        return ""
    return path.read_text(encoding="utf-8-sig")


def require_contains(rel: str, markers: list[str], errors: list[str]) -> None:
    content = read_text(rel)
    if not content:
        errors.append(f"  MISSING file: {rel}")
        return
    for marker in markers:
        if marker not in content:
            errors.append(f"  {rel} missing marker: {marker}")


def main() -> int:
    errors: list[str] = []

    agent_dirs = sorted(p for p in FACTORY_ROOT.iterdir() if p.is_dir() and p.name.startswith("Agente"))
    expected_agent_count = len(AGENT_NAMES)
    if len(agent_dirs) != expected_agent_count:
        errors.append(f"  Expected {expected_agent_count} AgenteXX directories, found {len(agent_dirs)}")
    for agent_dir in agent_dirs:
        if not (agent_dir / "prompt.md").is_file():
            errors.append(f"  {agent_dir.name} missing prompt.md")

    require_contains(
        "CLAUDE.md",
        ["Claude Code", "~/.claude/agents/", "~/.claude.json", "MCP Knowledge Search"],
        errors,
    )
    require_contains(
        "AGENTS.md",
        ["Codex", ".codex/config.toml", "~/.codex/agents/", "MCP-first"],
        errors,
    )

    require_contains(
        "install.ps1",
        [
            "$CLAUDE_AGENTS_DIR",
            "$CODEX_AGENTS_DIR",
            "developer_instructions",
            "[mcp_servers.knowledge]",
        ],
        errors,
    )

    install_text = read_text("install.ps1")
    for name in AGENT_NAMES:
        if not re.search(rf'Name\s*=\s*"{re.escape(name)}"', install_text):
            errors.append(f"  install.ps1 missing agent mapping: {name}")

    require_contains(
        "doctor.ps1",
        [
            "Claude Code — Agentes",
            "Codex — Custom Agents",
            "mcp_servers.knowledge",
            "mcpServers.knowledge",
        ],
        errors,
    )
    require_contains(
        "link-mcp.ps1",
        [".mcp.json", ".codex", "[mcp_servers.knowledge]"],
        errors,
    )
    require_contains(
        ".gitignore",
        ["knowledge.db", ".mcp.json", ".codex/"],
        errors,
    )
    require_contains(
        "docs/CLIENT_COMPATIBILITY.md",
        ["Claude Code", "Codex", "MCP"],
        errors,
    )
    require_contains(
        "docs/CODEX.md",
        ["Codex", "custom agents", ".codex/config.toml", "MCP"],
        errors,
    )

    retired_runtime_markers = {
        "install.ps1": ["Roo Code", "roo/.roomodes", "link-roo.ps1", "mcp_settings.json"],
        "doctor.ps1": ["Roo Code", "roo/.roomodes", "link-roo.ps1", "mcp_settings.json"],
        "README.md": ["Roo Code", "Cline", "link-roo.ps1", ".roomodes"],
        "docs/CLIENT_COMPATIBILITY.md": ["Roo Code", "Cline", "link-roo.ps1", ".roomodes"],
        "docs/INSTALLATION.md": ["Roo Code", "Cline", "link-roo.ps1", ".roomodes"],
    }
    for rel, markers in retired_runtime_markers.items():
        content = read_text(rel)
        for marker in markers:
            if marker in content:
                errors.append(f"  {rel} contains retired Roo/Cline marker: {marker}")

    total_checks = expected_agent_count + len(AGENT_NAMES)
    failed = len(errors)
    passed = total_checks - failed if failed <= total_checks else 0
    print(f"validate_runtime_compatibility: {total_checks} checks, {passed} OK, {failed} failed")
    for error in errors:
        print(error)
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
