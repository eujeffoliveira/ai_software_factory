"""
Tests for server.py tool functions.
Sets KNOWLEDGE_DB env var to point at the test fixture DB before importing server.
"""
import importlib
import json
import os
import sys
from pathlib import Path

import pytest

MCP_DIR = str(Path(__file__).parent.parent)
sys.path.insert(0, MCP_DIR)


def _load_server(db_path: str):
    """Import server module with KNOWLEDGE_DB pointing at test DB."""
    os.environ["KNOWLEDGE_DB"] = db_path
    # Re-import to pick up new env var (server reads it at module level)
    import server as srv
    importlib.reload(srv)
    return srv


class TestHealthCheck:
    def test_ok_status(self, db_path):
        srv = _load_server(db_path)
        raw = srv.health_check()
        result = json.loads(raw)
        assert result["status"] == "ok"
        assert result["db_exists"] is True
        assert result["total_documents"] == 3
        assert "tools_available" in result

    def test_missing_db_returns_error(self, missing_db_path):
        srv = _load_server(missing_db_path)
        raw = srv.health_check()
        result = json.loads(raw)
        assert result["status"] == "error"
        assert result["db_exists"] is False
        assert "fix" in result
        # No raw traceback in the response
        assert "Traceback" not in raw

    def test_empty_db_reports_zero(self, empty_db_path):
        srv = _load_server(empty_db_path)
        raw = srv.health_check()
        result = json.loads(raw)
        assert result["status"] == "ok"
        assert result["total_documents"] == 0


class TestSearchKnowledge:
    def test_returns_json(self, db_path):
        srv = _load_server(db_path)
        raw = srv.search_knowledge("Tech Lead")
        result = json.loads(raw)
        assert "total" in result
        assert "documents" in result

    def test_finds_known_term(self, db_path):
        srv = _load_server(db_path)
        raw = srv.search_knowledge("MCP-first")
        result = json.loads(raw)
        assert result["total"] >= 1

    def test_no_results_for_garbage(self, db_path):
        srv = _load_server(db_path)
        raw = srv.search_knowledge("xyzzy_nonexistent_99")
        result = json.loads(raw)
        assert result["total"] == 0
        assert result["documents"] == []

    def test_content_truncated_to_300(self, db_path):
        srv = _load_server(db_path)
        raw = srv.search_knowledge("Tech Lead")
        result = json.loads(raw)
        for doc in result["documents"]:
            assert len(doc.get("content", "")) <= 303  # 300 + "..."


class TestSearchWithFilters:
    def test_category_filter(self, db_path):
        srv = _load_server(db_path)
        raw = srv.search_with_filters("Next.js", filters='{"category": "markdown"}')
        result = json.loads(raw)
        assert "documents" in result

    def test_invalid_json_filters_raises(self, db_path):
        srv = _load_server(db_path)
        with pytest.raises(Exception):
            srv.search_with_filters("query", filters="not_valid_json")

    def test_empty_filters(self, db_path):
        srv = _load_server(db_path)
        raw = srv.search_with_filters("Tech Lead", filters="{}")
        result = json.loads(raw)
        assert "documents" in result


class TestGetFullDocument:
    def test_existing_doc(self, db_path):
        srv = _load_server(db_path)
        raw = srv.get_full_document("md:docs/AGENTS.md")
        result = json.loads(raw)
        assert result["id"] == "md:docs/AGENTS.md"

    def test_nonexistent_doc_returns_error_json(self, db_path):
        srv = _load_server(db_path)
        raw = srv.get_full_document("md:does/not/exist.md")
        result = json.loads(raw)
        assert "error" in result
        # Should not raise or return raw traceback
        assert "Traceback" not in raw


class TestGetContext:
    def test_existing_doc_returns_structure(self, db_path):
        srv = _load_server(db_path)
        raw = srv.get_context("md:docs/AGENTS.md")
        result = json.loads(raw)
        assert "documento" in result or "error" not in result

    def test_nonexistent_doc_returns_error_json(self, db_path):
        srv = _load_server(db_path)
        raw = srv.get_context("md:does/not/exist.md")
        result = json.loads(raw)
        assert "error" in result


class TestKnowledgeStats:
    def test_returns_stats(self, db_path):
        srv = _load_server(db_path)
        raw = srv.knowledge_stats()
        result = json.loads(raw)
        assert "total_documents" in result
        assert result["total_documents"] == 3

    def test_empty_db(self, empty_db_path):
        srv = _load_server(empty_db_path)
        raw = srv.knowledge_stats()
        result = json.loads(raw)
        assert result["total_documents"] == 0
