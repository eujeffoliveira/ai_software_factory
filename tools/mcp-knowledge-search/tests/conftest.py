"""
Shared fixtures for MCP Knowledge Search tests.
Builds a minimal in-memory (or temp-file) SQLite DB so tests run without knowledge.db.
"""
import json
import os
import sqlite3
import sys
import tempfile
from datetime import datetime, timezone
from pathlib import Path

import pytest

# Make database module importable from tests/
sys.path.insert(0, str(Path(__file__).parent.parent))
from database import create_schema, insert_documents, rebuild_fts

SAMPLE_DOCS = [
    {
        "id": "md:docs/AGENTS.md",
        "source": "docs/AGENTS.md",
        "category": "markdown",
        "title": "Agentes — Referência Completa",
        "content": "O Tech Lead orquestra todos os agentes via gates de qualidade. MCP-first policy.",
        "metadata": {"group_id": "docs/AGENTS.md", "sort_key": "0"},
        "indexed_at": datetime.now(timezone.utc).isoformat(),
    },
    {
        "id": "md:docs/GOLDEN_MODELS.md",
        "source": "docs/GOLDEN_MODELS.md",
        "category": "markdown",
        "title": "Golden Models",
        "content": "web_app archetype uses Next.js 16 + React 19 + Tailwind + Supabase + Prisma.",
        "metadata": {"group_id": "docs/GOLDEN_MODELS.md", "sort_key": "0"},
        "indexed_at": datetime.now(timezone.utc).isoformat(),
    },
    {
        "id": "md:Agente00_TechLead/knowledge/principles.md",
        "source": "Agente00_TechLead/knowledge/principles.md",
        "category": "markdown",
        "title": "TechLead Principles",
        "content": "P1: Never skip gates. P2: MCP-first before answering about factory artifacts.",
        "metadata": {"group_id": "Agente00_TechLead/knowledge/principles.md", "sort_key": "0"},
        "indexed_at": datetime.now(timezone.utc).isoformat(),
    },
]


@pytest.fixture
def db_path(tmp_path):
    """Temporary SQLite DB with schema + sample documents."""
    path = str(tmp_path / "test_knowledge.db")
    conn = sqlite3.connect(path)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA journal_mode=WAL")
    create_schema(conn)
    insert_documents(conn, SAMPLE_DOCS)
    rebuild_fts(conn)
    conn.close()
    return path


@pytest.fixture
def empty_db_path(tmp_path):
    """DB with schema but zero documents."""
    path = str(tmp_path / "empty_knowledge.db")
    conn = sqlite3.connect(path)
    conn.row_factory = sqlite3.Row
    create_schema(conn)
    conn.close()
    return path


@pytest.fixture
def missing_db_path(tmp_path):
    """Path that does not exist."""
    return str(tmp_path / "nonexistent.db")
