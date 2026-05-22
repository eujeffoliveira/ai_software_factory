"""
Knowledge Search — MCP Server (Generic)
Funciona com qualquer projeto que tenha knowledge-config.json + knowledge.db.

Config no .mcp.json:
{
  "mcpServers": {
    "knowledge": {
      "command": "python",
      "args": ["<repo>/tools/mcp-knowledge-search/server.py"],
      "env": { "KNOWLEDGE_DB": "<project>/knowledge.db" }
    }
  }
}

Migrado de: https://github.com/eujeffoliveira/a-gusman-claude/tree/main/mcp/knowledge-search
"""
import json
import os
import sys
import time
from datetime import datetime, timezone
from pathlib import Path

from mcp.server.fastmcp import FastMCP

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from database import get_connection, search, search_filtered, get_document, get_related, get_stats

DB_PATH = os.environ.get("KNOWLEDGE_DB", "knowledge.db")

mcp = FastMCP(
    "knowledge-search",
    instructions="Busca full-text em base de conhecimento local via SQLite FTS5"
)

# ─── Logging estruturado JSON ─────────────────────────────────────────────────

_LOG_DIR = Path(__file__).parent / "logs"
_LOG_FILE = _LOG_DIR / "mcp-knowledge.log"


def _log(event: str, **kwargs) -> None:
    """Escreve uma linha JSON no log. Nunca lanca excecao — falha silenciosa."""
    try:
        _LOG_DIR.mkdir(parents=True, exist_ok=True)
        entry = {
            "timestamp": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
            "event": event,
            **kwargs,
        }
        with _LOG_FILE.open("a", encoding="utf-8") as f:
            f.write(json.dumps(entry, ensure_ascii=False) + "\n")
    except Exception:
        pass  # logging nunca quebra o MCP


# ─── Helper de conexao ────────────────────────────────────────────────────────

def _get_conn():
    if not os.path.exists(DB_PATH):
        raise FileNotFoundError(f"DB nao encontrado: {DB_PATH}. Execute ingest.py primeiro.")
    return get_connection(DB_PATH)


# ─── Tools ────────────────────────────────────────────────────────────────────

@mcp.tool()
def health_check() -> str:
    """Valida a saude do servidor MCP: verifica DB, tabela FTS e conta documentos.

    Retorna JSON com status 'ok' ou 'error', caminho do DB, contagem de documentos
    e lista de tools disponiveis. Use para diagnosticar problemas de configuracao.
    """
    checked_at = datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")
    db_exists = os.path.exists(DB_PATH)

    tools_available = [
        "health_check",
        "knowledge_stats",
        "search_knowledge",
        "search_with_filters",
        "get_full_document",
        "get_context",
    ]

    if not db_exists:
        result = {
            "status": "error",
            "db_path": DB_PATH,
            "db_exists": False,
            "reason": "knowledge.db not found",
            "fix": r"Run .\update-knowledge.ps1 or .\install.ps1 from FACTORY_ROOT",
            "checked_at": checked_at,
        }
        _log("health_check", status="error", db_exists=False, reason="knowledge.db not found")
        return json.dumps(result, ensure_ascii=False, indent=2)

    try:
        conn = get_connection(DB_PATH)
        try:
            # Verificar se tabela FTS existe e contar documentos
            cur = conn.execute(
                "SELECT COUNT(*) FROM sqlite_master WHERE type='table' AND name='documents'"
            )
            table_exists = cur.fetchone()[0] > 0

            if not table_exists:
                result = {
                    "status": "error",
                    "db_path": DB_PATH,
                    "db_exists": True,
                    "reason": "Table 'documents' not found in database",
                    "fix": r"Run .\update-knowledge.ps1 or .\install.ps1 from FACTORY_ROOT",
                    "checked_at": checked_at,
                }
                _log("health_check", status="error", db_exists=True, reason="table_missing")
                return json.dumps(result, ensure_ascii=False, indent=2)

            cur = conn.execute("SELECT COUNT(*) FROM documents")
            total_documents = cur.fetchone()[0]
        finally:
            conn.close()

        result = {
            "status": "ok",
            "db_path": DB_PATH,
            "db_exists": True,
            "total_documents": total_documents,
            "tools_available": tools_available,
            "checked_at": checked_at,
            "recommendation": (
                "MCP ready. Use search_knowledge() for general queries "
                "or search_with_filters() for metadata-filtered queries."
            ),
        }
        _log("health_check", status="ok", db_exists=True, total_documents=total_documents)
        return json.dumps(result, ensure_ascii=False, indent=2)

    except Exception as exc:
        result = {
            "status": "error",
            "db_path": DB_PATH,
            "db_exists": db_exists,
            "reason": str(exc),
            "fix": r"Run .\update-knowledge.ps1 or .\install.ps1 from FACTORY_ROOT",
            "checked_at": checked_at,
        }
        _log("health_check", status="error", reason=str(exc))
        return json.dumps(result, ensure_ascii=False, indent=2)


@mcp.tool()
def search_knowledge(
    query: str,
    category: str = "",
    limit: int = 20
) -> str:
    """Busca full-text na base de conhecimento. Suporta operadores FTS5: AND, OR, NOT, "frase exata".

    Args:
        query: Texto para buscar
        category: Filtrar por categoria (ex: mensagem, contrato, evento, markdown, readme, adr, spec, problema, evidencia, pessoa)
        limit: Maximo de resultados (default 20)
    """
    t0 = time.monotonic()
    try:
        conn = _get_conn()
        try:
            results = search(conn, query, category=category or None, limit=limit)
            for r in results:
                if r.get("content") and len(r["content"]) > 300:
                    r["content"] = r["content"][:300] + "..."
            payload = json.dumps({"total": len(results), "documents": results}, ensure_ascii=False, indent=2)
            _log(
                "search_knowledge",
                query=query[:200],
                category=category or None,
                limit=limit,
                results_count=len(results),
                duration_ms=round((time.monotonic() - t0) * 1000),
                status="ok",
            )
            return payload
        finally:
            conn.close()
    except Exception as exc:
        _log(
            "search_knowledge",
            query=query[:200],
            status="error",
            reason=str(exc),
            duration_ms=round((time.monotonic() - t0) * 1000),
        )
        raise


@mcp.tool()
def search_with_filters(
    query: str,
    filters: str = "{}",
    limit: int = 20
) -> str:
    """Busca com filtros em campos do metadata via json_extract.

    Args:
        query: Texto para buscar
        filters: JSON string com filtros. Ex: {"category": "mensagem", "datetime_iso__gte": "2025-01-01"}
        limit: Maximo de resultados (default 20)
    """
    t0 = time.monotonic()
    try:
        conn = _get_conn()
        try:
            filter_dict = json.loads(filters) if filters else {}
            results = search_filtered(conn, query, filters=filter_dict, limit=limit)
            for r in results:
                if r.get("content") and len(r["content"]) > 300:
                    r["content"] = r["content"][:300] + "..."
            payload = json.dumps({"total": len(results), "documents": results}, ensure_ascii=False, indent=2)
            _log(
                "search_with_filters",
                query=query[:200],
                filters=filters[:200],
                limit=limit,
                results_count=len(results),
                duration_ms=round((time.monotonic() - t0) * 1000),
                status="ok",
            )
            return payload
        finally:
            conn.close()
    except Exception as exc:
        _log(
            "search_with_filters",
            query=query[:200],
            status="error",
            reason=str(exc),
            duration_ms=round((time.monotonic() - t0) * 1000),
        )
        raise


@mcp.tool()
def get_full_document(
    doc_id: str
) -> str:
    """Retorna o documento completo (sem truncar) dado seu ID.

    Args:
        doc_id: ID do documento (ex: md:docs/README.md)
    """
    t0 = time.monotonic()
    try:
        conn = _get_conn()
        try:
            doc = get_document(conn, doc_id)
            if not doc:
                _log(
                    "get_full_document",
                    doc_id=doc_id,
                    found=False,
                    duration_ms=round((time.monotonic() - t0) * 1000),
                    status="not_found",
                )
                return json.dumps({"error": f"Documento '{doc_id}' nao encontrado"})
            _log(
                "get_full_document",
                doc_id=doc_id,
                found=True,
                duration_ms=round((time.monotonic() - t0) * 1000),
                status="ok",
            )
            return json.dumps(doc, ensure_ascii=False, indent=2)
        finally:
            conn.close()
    except Exception as exc:
        _log(
            "get_full_document",
            doc_id=doc_id,
            status="error",
            reason=str(exc),
            duration_ms=round((time.monotonic() - t0) * 1000),
        )
        raise


@mcp.tool()
def get_context(
    doc_id: str,
    window: int = 5
) -> str:
    """Retorna documentos adjacentes do mesmo grupo (ex: secoes do mesmo arquivo).

    Args:
        doc_id: ID do documento central
        window: Quantos documentos antes/depois retornar (default 5)
    """
    t0 = time.monotonic()
    try:
        conn = _get_conn()
        try:
            result = get_related(conn, doc_id, window=window)
            for key in ("antes", "depois"):
                for r in result.get(key, []):
                    if r.get("content") and len(r["content"]) > 200:
                        r["content"] = r["content"][:200] + "..."
            antes_count = len(result.get("antes", []))
            depois_count = len(result.get("depois", []))
            _log(
                "get_context",
                doc_id=doc_id,
                window=window,
                results_count=antes_count + depois_count,
                duration_ms=round((time.monotonic() - t0) * 1000),
                status="ok",
            )
            return json.dumps(result, ensure_ascii=False, indent=2)
        finally:
            conn.close()
    except Exception as exc:
        _log(
            "get_context",
            doc_id=doc_id,
            status="error",
            reason=str(exc),
            duration_ms=round((time.monotonic() - t0) * 1000),
        )
        raise


@mcp.tool()
def knowledge_stats() -> str:
    """Estatisticas da base: total de documentos, contagem por categoria e source, data da ultima ingestao."""
    t0 = time.monotonic()
    try:
        conn = _get_conn()
        try:
            stats = get_stats(conn)
            _log(
                "knowledge_stats",
                total_documents=stats.get("total_documents", 0),
                duration_ms=round((time.monotonic() - t0) * 1000),
                status="ok",
            )
            return json.dumps(stats, ensure_ascii=False, indent=2)
        finally:
            conn.close()
    except Exception as exc:
        _log(
            "knowledge_stats",
            status="error",
            reason=str(exc),
            duration_ms=round((time.monotonic() - t0) * 1000),
        )
        raise


if __name__ == "__main__":
    _log("server_start", db_path=DB_PATH, db_exists=os.path.exists(DB_PATH))
    mcp.run(transport="stdio")
