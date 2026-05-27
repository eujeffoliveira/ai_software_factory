"""
Knowledge Search — SQLite FTS5 Database Layer (Generic)
Schema unico `documents` que funciona com qualquer projeto.
Filtros estruturados via json_extract() no campo metadata.

Migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/mcp/knowledge-search
"""
import sqlite3
import json
from typing import Optional


def get_connection(db_path: str) -> sqlite3.Connection:
    conn = sqlite3.connect(db_path)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA journal_mode=WAL")
    return conn


def create_schema(conn: sqlite3.Connection) -> None:
    conn.executescript("""
        CREATE TABLE IF NOT EXISTS documents (
            id TEXT PRIMARY KEY,
            source TEXT NOT NULL,
            category TEXT NOT NULL,
            title TEXT,
            content TEXT NOT NULL,
            metadata TEXT,
            indexed_at TEXT NOT NULL
        );

        CREATE VIRTUAL TABLE IF NOT EXISTS fts_docs USING fts5(
            id UNINDEXED,
            category,
            title,
            content,
            content=documents,
            content_rowid=rowid,
            tokenize='unicode61 remove_diacritics 2'
        );

        CREATE INDEX IF NOT EXISTS idx_doc_source ON documents(source);
        CREATE INDEX IF NOT EXISTS idx_doc_category ON documents(category);

        CREATE TABLE IF NOT EXISTS metadata (
            key TEXT PRIMARY KEY,
            value TEXT
        );
    """)
    conn.commit()


def rebuild_fts(conn: sqlite3.Connection) -> None:
    conn.execute("INSERT INTO fts_docs(fts_docs) VALUES('rebuild')")
    conn.commit()


def insert_documents(conn: sqlite3.Connection, docs: list[dict]) -> int:
    count = 0
    for doc in docs:
        conn.execute("""
            INSERT OR REPLACE INTO documents (id, source, category, title, content, metadata, indexed_at)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (
            doc["id"],
            doc["source"],
            doc["category"],
            doc.get("title", ""),
            doc["content"],
            json.dumps(doc.get("metadata", {}), ensure_ascii=False) if isinstance(doc.get("metadata"), dict) else doc.get("metadata", "{}"),
            doc["indexed_at"],
        ))
        count += 1
        if count % 500 == 0:
            conn.commit()
    conn.commit()
    return count


def _fts5_escape(query: str) -> str:
    """Wrap a user query as an FTS5 phrase to avoid operator interpretation.

    Hyphens (-), dots (.), and other punctuation are FTS5 operators or
    token separators. Wrapping in double quotes makes FTS5 treat the string
    as a phrase, preventing OperationalError on terms like 'MCP-first' or
    'Next.js'. Inner double quotes are escaped by doubling them.
    """
    return '"' + query.replace('"', '""') + '"'


def search(
    conn: sqlite3.Connection,
    query: str,
    category: Optional[str] = None,
    source: Optional[str] = None,
    limit: int = 20
) -> list[dict]:
    params: list = [_fts5_escape(query)]
    clauses = []

    if category:
        clauses.append("d.category = ?")
        params.append(category)
    if source:
        clauses.append("d.source = ?")
        params.append(source)

    extra = ""
    if clauses:
        extra = " AND " + " AND ".join(clauses)

    params.append(limit)
    rows = conn.execute(f"""
        SELECT d.id, d.source, d.category, d.title, d.content, d.metadata, rank
        FROM fts_docs fts
        JOIN documents d ON d.rowid = fts.rowid
        WHERE fts_docs MATCH ?
        {extra}
        ORDER BY rank
        LIMIT ?
    """, params).fetchall()
    return [dict(r) for r in rows]


def search_filtered(
    conn: sqlite3.Connection,
    query: str,
    filters: Optional[dict] = None,
    limit: int = 20
) -> list[dict]:
    """Busca com filtros em campos do metadata via json_extract.

    filters: {"campo": "valor", "campo__gte": "2025-01-01", "campo__lte": "2025-12-31"}
    """
    params: list = [_fts5_escape(query)]
    clauses = []

    if filters:
        for key, value in filters.items():
            if key in ("category", "source"):
                clauses.append(f"d.{key} = ?")
                params.append(value)
                continue

            if "__gte" in key:
                field = key.replace("__gte", "")
                clauses.append(f"json_extract(d.metadata, '$.{field}') >= ?")
                params.append(value)
            elif "__lte" in key:
                field = key.replace("__lte", "")
                clauses.append(f"json_extract(d.metadata, '$.{field}') <= ?")
                params.append(value)
            elif "__eq" in key:
                field = key.replace("__eq", "")
                clauses.append(f"json_extract(d.metadata, '$.{field}') = ?")
                params.append(value)
            else:
                clauses.append(f"json_extract(d.metadata, '$.{key}') LIKE ?")
                params.append(f"%{value}%")

    extra = ""
    if clauses:
        extra = " AND " + " AND ".join(clauses)

    params.append(limit)
    rows = conn.execute(f"""
        SELECT d.id, d.source, d.category, d.title, d.content, d.metadata, rank
        FROM fts_docs fts
        JOIN documents d ON d.rowid = fts.rowid
        WHERE fts_docs MATCH ?
        {extra}
        ORDER BY rank
        LIMIT ?
    """, params).fetchall()
    return [dict(r) for r in rows]


def get_document(conn: sqlite3.Connection, doc_id: str) -> Optional[dict]:
    row = conn.execute("SELECT * FROM documents WHERE id = ?", (doc_id,)).fetchone()
    return dict(row) if row else None


def get_related(
    conn: sqlite3.Connection,
    doc_id: str,
    window: int = 5
) -> dict:
    doc = get_document(conn, doc_id)
    if not doc:
        return {"error": f"Documento {doc_id} nao encontrado"}

    meta = json.loads(doc["metadata"]) if isinstance(doc["metadata"], str) else doc.get("metadata", {})
    group_key = meta.get("group_id", doc["category"])

    all_docs = conn.execute("""
        SELECT id, title, content, metadata
        FROM documents
        WHERE category = ? AND json_extract(metadata, '$.group_id') = ?
        ORDER BY json_extract(metadata, '$.sort_key'), id
    """, (doc["category"], group_key)).fetchall()

    if not all_docs:
        all_docs = conn.execute("""
            SELECT id, title, content, metadata
            FROM documents
            WHERE category = ? AND source = ?
            ORDER BY id
            LIMIT ?
        """, (doc["category"], doc["source"], window * 3)).fetchall()

    all_list = [dict(r) for r in all_docs]
    idx = next((i for i, d in enumerate(all_list) if d["id"] == doc_id), -1)

    if idx == -1:
        return {"documento": doc, "antes": [], "depois": []}

    before = all_list[max(0, idx - window):idx]
    after = all_list[idx + 1:idx + 1 + window]

    return {
        "documento": doc,
        "antes": before,
        "depois": after,
        "group_id": group_key,
    }


def get_stats(conn: sqlite3.Connection) -> dict:
    total = conn.execute("SELECT COUNT(*) as cnt FROM documents").fetchone()["cnt"]

    by_category = conn.execute(
        "SELECT category, COUNT(*) as cnt FROM documents GROUP BY category ORDER BY cnt DESC"
    ).fetchall()

    by_source = conn.execute(
        "SELECT source, COUNT(*) as cnt FROM documents GROUP BY source ORDER BY cnt DESC"
    ).fetchall()

    meta = conn.execute("SELECT * FROM metadata").fetchall()

    return {
        "total_documents": total,
        "by_category": {r["category"]: r["cnt"] for r in by_category},
        "by_source": {r["source"]: r["cnt"] for r in by_source},
        "metadata": {r["key"]: r["value"] for r in meta},
    }
