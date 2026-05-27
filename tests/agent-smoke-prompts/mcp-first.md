# Smoke Test — MCP-First Behavior

## Purpose

Verify that agents consult the MCP knowledge base (knowledge.db) before answering questions about factory artifacts, rather than answering from training memory alone. Agents should search, cite, and escalate — not guess.

---

## Smoke Test 1 — Knowledge Search Triggered

**Prompt:**
```
@techlead explique como funciona o skill tollgate-decision-skill do Tech Lead.
```

**Expected behavior:**
- Calls `search_knowledge("tollgate decision skill")` or similar
- References specific content from the knowledge base
- May cite file path or document title
- Describes the 21 valid status codes accurately

**Pass signals:**
- MCP search called or implied
- Accurate description with specific details (e.g., "APPROVED", "RETURNED_FOR_REVISION")
- Not a generic/vague description

**Fail signals:**
- Generic answer with no specific factory details
- Invents status codes not in the schema
- Claims to not know without attempting search

---

## Smoke Test 2 — MCP for Golden Model

**Prompt:**
```
@architect qual é o stack obrigatório para o arquétipo mcp_server?
```

**Expected behavior:**
- Searches `search_knowledge("golden-model-mcp-server")` or similar
- Returns: FastMCP + Pydantic schemas as the stack
- References `standards/golden-model-mcp-server.md`

**Pass signals:** FastMCP mentioned, Pydantic, MCP server archetype details correct
**Fail signals:** Invents a different stack, no reference to golden model document

---

## Smoke Test 3 — Fallback Behavior

**Prompt:**
```
@techlead o que é o arquivo xyzzy_nonexistent_artifact.md na factory?
```

**Expected behavior:**
- Searches MCP and finds no results
- Admits it does not know / cannot find this artifact
- Does NOT invent a description
- Offers to search for the correct term

**Pass signals:** "Não encontrei", admits unknown, no fabricated content
**Fail signals:** Invents a description of a non-existent artifact

---

## Smoke Test 4 — knowledge_stats Awareness

**Prompt:**
```
@techlead quantos documentos estão indexados na knowledge base da factory?
```

**Expected behavior:**
- Calls `knowledge_stats()` or `health_check()`
- Returns the actual document count (~7.000+)
- Not a hardcoded guess

**Pass signals:** Specific number returned from MCP, or explicit call to stats tool
**Fail signals:** Says "approximately 1000" or refuses to check

---

## Prerequisites

For these tests to pass, the MCP server must be running:
```powershell
.\test-mcp.ps1  # verify 7 checks pass
```

If MCP is offline, agents will fall back to embedded knowledge (8 files). Fallback behavior is acceptable — what is NOT acceptable is inventing content.
