#!/usr/bin/env python3
"""Standalone MCP health validator. Usage: python test_health.py [--db path]

Checks:
  1. DB path exists
  2. SQLite opens without error
  3. Table 'documents' exists
  4. Document count > 0
  5. FTS test query works

Exit code: 0 success, 1 failure
"""
import argparse
import os
import sqlite3
import sys


def ok(msg: str) -> None:
    print(f"[OK]    {msg}")


def error(msg: str, fix: str = "") -> None:
    print(f"[ERROR] {msg}")
    if fix:
        print(f"        Fix: {fix}")


def run_checks(db_path: str) -> bool:
    all_ok = True

    # Check 1 — DB path exists
    if os.path.exists(db_path):
        ok(f"DB exists: {db_path}")
    else:
        error(
            f"DB not found: {db_path}",
            r"Run .\update-knowledge.ps1 or .\install.ps1 from FACTORY_ROOT",
        )
        return False  # remaining checks require the file

    # Check 2 — SQLite opens
    conn = None
    try:
        conn = sqlite3.connect(db_path)
        conn.execute("SELECT 1")
        ok("SQLite opens without error")
    except Exception as exc:
        error(f"SQLite failed to open: {exc}", r"Run .\update-knowledge.ps1 to rebuild the DB")
        all_ok = False
        return all_ok
    finally:
        if conn:
            conn.close()

    # Check 3 — Table 'documents' exists
    try:
        conn = sqlite3.connect(db_path)
        cur = conn.execute(
            "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='documents'"
        )
        table_exists = cur.fetchone()[0] > 0
        conn.close()
        if table_exists:
            ok("Table 'documents' exists")
        else:
            error(
                "Table 'documents' not found",
                r"Run .\update-knowledge.ps1 or .\install.ps1 from FACTORY_ROOT",
            )
            all_ok = False
            return all_ok
    except Exception as exc:
        error(f"Failed to check table: {exc}")
        all_ok = False
        return all_ok

    # Check 4 — Document count > 0
    try:
        conn = sqlite3.connect(db_path)
        cur = conn.execute("SELECT COUNT(*) FROM documents")
        count = cur.fetchone()[0]
        conn.close()
        if count > 0:
            ok(f"Document count: {count}")
        else:
            error(
                "documents table is empty",
                r"Run .\update-knowledge.ps1 to reindex knowledge",
            )
            all_ok = False
    except Exception as exc:
        error(f"Failed to count documents: {exc}")
        all_ok = False

    # Check 5 — FTS test query works
    try:
        conn = sqlite3.connect(db_path)
        # FTS virtual table is fts_docs (not documents) — content table is documents
        cur = conn.execute(
            "SELECT COUNT(*) FROM fts_docs WHERE fts_docs MATCH 'skill OR agent OR knowledge'"
        )
        fts_count = cur.fetchone()[0]
        conn.close()
        ok(f"FTS query works ({fts_count} matches for test query)")
    except Exception as exc:
        error(
            f"FTS query failed: {exc}",
            r"Run .\update-knowledge.ps1 to rebuild the DB",
        )
        all_ok = False

    return all_ok


def main() -> int:
    parser = argparse.ArgumentParser(description="Standalone MCP health validator")
    parser.add_argument(
        "--db",
        default=os.environ.get("KNOWLEDGE_DB", "knowledge.db"),
        help="Path to knowledge.db (default: KNOWLEDGE_DB env var or knowledge.db)",
    )
    args = parser.parse_args()

    # Resolve relative to FACTORY_ROOT if not absolute
    db_path = args.db
    if not os.path.isabs(db_path):
        factory_root = os.environ.get("FACTORY_ROOT", "")
        if factory_root:
            candidate = os.path.join(factory_root, db_path)
            if os.path.exists(candidate):
                db_path = candidate

    print(f"\nMCP Knowledge Health Check")
    print(f"DB: {db_path}\n")

    success = run_checks(db_path)

    print()
    if success:
        print("[OK] All checks passed — MCP knowledge server is ready")
        return 0
    else:
        print("[ERROR] One or more checks failed — MCP may not work correctly")
        print("        Run: .\\install.ps1  or  .\\update-knowledge.ps1")
        return 1


if __name__ == "__main__":
    sys.exit(main())
