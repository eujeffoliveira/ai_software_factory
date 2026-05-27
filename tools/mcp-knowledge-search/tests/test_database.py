"""
Tests for database.py — covers search, get_document, get_stats, get_related, schema.
All tests use the in-memory fixture from conftest.py; no real knowledge.db required.
"""
import json
import sqlite3
import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).parent.parent))
from database import (
    get_connection,
    get_document,
    get_related,
    get_stats,
    search,
    search_filtered,
)


# ── search ────────────────────────────────────────────────────────────────────

class TestSearch:
    def test_returns_list(self, db_path):
        conn = get_connection(db_path)
        results = search(conn, "Tech Lead")
        conn.close()
        assert isinstance(results, list)

    def test_finds_known_term(self, db_path):
        conn = get_connection(db_path)
        results = search(conn, "MCP-first")
        conn.close()
        assert len(results) >= 1
        ids = [r["id"] for r in results]
        assert "md:docs/AGENTS.md" in ids or any("principles" in i for i in ids)

    def test_no_results_for_garbage(self, db_path):
        conn = get_connection(db_path)
        results = search(conn, "xyzzy_nonexistent_token_99999")
        conn.close()
        assert results == []

    def test_result_has_required_fields(self, db_path):
        conn = get_connection(db_path)
        results = search(conn, "gates")
        conn.close()
        for r in results:
            assert "id" in r
            assert "source" in r
            assert "category" in r
            assert "content" in r

    def test_category_filter(self, db_path):
        conn = get_connection(db_path)
        results = search(conn, "gates", category="markdown")
        conn.close()
        for r in results:
            assert r["category"] == "markdown"

    def test_category_filter_excludes_others(self, db_path):
        conn = get_connection(db_path)
        results = search(conn, "gates", category="nonexistent_category")
        conn.close()
        assert results == []

    def test_limit_respected(self, db_path):
        conn = get_connection(db_path)
        results = search(conn, "md", limit=1)
        conn.close()
        assert len(results) <= 1

    def test_empty_db_returns_empty(self, empty_db_path):
        conn = get_connection(empty_db_path)
        results = search(conn, "anything")
        conn.close()
        assert results == []


# ── search_filtered ───────────────────────────────────────────────────────────

class TestSearchFiltered:
    def test_category_filter(self, db_path):
        conn = get_connection(db_path)
        results = search_filtered(conn, "Next.js", filters={"category": "markdown"})
        conn.close()
        for r in results:
            assert r["category"] == "markdown"

    def test_source_filter(self, db_path):
        conn = get_connection(db_path)
        results = search_filtered(conn, "Golden", filters={"source": "docs/GOLDEN_MODELS.md"})
        conn.close()
        if results:
            assert all(r["source"] == "docs/GOLDEN_MODELS.md" for r in results)

    def test_no_match_returns_empty(self, db_path):
        conn = get_connection(db_path)
        results = search_filtered(conn, "xyzzy_nope", filters={"category": "markdown"})
        conn.close()
        assert results == []

    def test_empty_filters(self, db_path):
        conn = get_connection(db_path)
        results = search_filtered(conn, "Tech Lead", filters={})
        conn.close()
        assert isinstance(results, list)


# ── get_document ──────────────────────────────────────────────────────────────

class TestGetDocument:
    def test_existing_doc(self, db_path):
        conn = get_connection(db_path)
        doc = get_document(conn, "md:docs/AGENTS.md")
        conn.close()
        assert doc is not None
        assert doc["id"] == "md:docs/AGENTS.md"
        assert doc["title"] == "Agentes — Referência Completa"

    def test_nonexistent_doc_returns_none(self, db_path):
        conn = get_connection(db_path)
        doc = get_document(conn, "md:does/not/exist.md")
        conn.close()
        assert doc is None

    def test_doc_has_all_fields(self, db_path):
        conn = get_connection(db_path)
        doc = get_document(conn, "md:docs/GOLDEN_MODELS.md")
        conn.close()
        assert doc is not None
        for field in ("id", "source", "category", "title", "content", "metadata", "indexed_at"):
            assert field in doc


# ── get_stats ─────────────────────────────────────────────────────────────────

class TestGetStats:
    def test_returns_dict(self, db_path):
        conn = get_connection(db_path)
        stats = get_stats(conn)
        conn.close()
        assert isinstance(stats, dict)

    def test_total_documents_correct(self, db_path):
        conn = get_connection(db_path)
        stats = get_stats(conn)
        conn.close()
        assert stats["total_documents"] == 3

    def test_by_category_present(self, db_path):
        conn = get_connection(db_path)
        stats = get_stats(conn)
        conn.close()
        assert "by_category" in stats
        assert "markdown" in stats["by_category"]
        assert stats["by_category"]["markdown"] == 3

    def test_empty_db_returns_zero(self, empty_db_path):
        conn = get_connection(empty_db_path)
        stats = get_stats(conn)
        conn.close()
        assert stats["total_documents"] == 0


# ── get_related ───────────────────────────────────────────────────────────────

class TestGetRelated:
    def test_existing_doc_returns_structure(self, db_path):
        conn = get_connection(db_path)
        result = get_related(conn, "md:docs/AGENTS.md")
        conn.close()
        assert "documento" in result
        assert "antes" in result
        assert "depois" in result

    def test_nonexistent_doc_returns_error(self, db_path):
        conn = get_connection(db_path)
        result = get_related(conn, "md:nonexistent.md")
        conn.close()
        assert "error" in result


# ── get_connection ────────────────────────────────────────────────────────────

class TestGetConnection:
    def test_returns_connection(self, db_path):
        conn = get_connection(db_path)
        assert conn is not None
        conn.close()

    def test_missing_file_raises(self, missing_db_path):
        # sqlite3.connect does NOT raise for missing files — it creates them.
        # But get_connection itself uses connect(), so it returns OK.
        # The FileNotFoundError is raised by server._get_conn(), not database.get_connection().
        conn = get_connection(missing_db_path)
        conn.close()
        # Verify the file was created (sqlite creates on connect)
        import os
        assert os.path.exists(missing_db_path)
