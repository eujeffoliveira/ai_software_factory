#!/usr/bin/env python3
"""Smoke test for the knowledge MCP server protocol handshake and tools."""

from __future__ import annotations

import argparse
import asyncio
import os
import sys
from pathlib import Path

from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client


EXPECTED_TOOLS = {
    "health_check",
    "knowledge_stats",
    "search_knowledge",
    "search_with_filters",
    "get_full_document",
    "get_context",
}


async def list_tool_names(factory_root: Path) -> set[str]:
    server_path = factory_root / "tools" / "mcp-knowledge-search" / "server.py"
    db_path = factory_root / "knowledge.db"
    env = os.environ.copy()
    env["KNOWLEDGE_DB"] = str(db_path)

    params = StdioServerParameters(
        command=sys.executable,
        args=[str(server_path)],
        cwd=str(factory_root),
        env=env,
    )

    async with stdio_client(params) as (read_stream, write_stream):
        async with ClientSession(read_stream, write_stream) as session:
            await session.initialize()
            result = await session.list_tools()
            return {tool.name for tool in result.tools}


async def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--factory-root",
        default=os.environ.get("FACTORY_ROOT", "."),
        help="Path to the ai_software_factory repository root.",
    )
    args = parser.parse_args()

    factory_root = Path(args.factory_root).resolve()
    names = await list_tool_names(factory_root)
    missing = sorted(EXPECTED_TOOLS - names)

    if missing:
        print(f"ERROR: missing MCP tools: {', '.join(missing)}", file=sys.stderr)
        print(f"TOOLS: {', '.join(sorted(names))}")
        return 1

    print(f"TOOLS: {', '.join(sorted(names))}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(asyncio.run(main()))
    except Exception as exc:
        print(f"ERROR: MCP list_tools failed: {exc}", file=sys.stderr)
        raise SystemExit(1)
