# Example Request — MCP Server

**Arquétipo:** `mcp_server`
**Golden Model:** MCP Server (Python + FastMCP)

---

## Como usar com Claude Code

```
@techlead Quero criar um servidor MCP que exponha ferramentas para busca
em documentos internos da empresa armazenados no SharePoint.

Ferramentas necessárias:
- search_documents(query, folder?) → lista de resultados relevantes
- get_document(doc_id) → conteúdo completo do documento
- list_folders() → estrutura de pastas disponíveis

Classifique como mcp_server e inicie o planejamento.
```

```
@engineer Planeje a implementação do MCP server de documentos internos.
Stack: Python 3.12, FastMCP, httpx (Microsoft Graph API), Pydantic v2, pytest.
Inclua: schema de cada tool, autenticação OAuth2 via Microsoft Graph, rate limiting.
```

```
@devsecops Revise o MCP server de documentos para:
- Acesso ao SharePoint com permissões mínimas (apenas leitura)
- Prevenção de path traversal nas tools de leitura
- Tokens Microsoft Graph: rotação, escopo mínimo
- Tools não expõem conteúdo de pastas sem permissão
```

```
@qa Valide o MCP server:
- Cada tool testada com pytest (happy path + input inválido)
- Schema Pydantic de input/output de cada tool
- Mock da Microsoft Graph API com respx
- Tool de busca retorna resultados relevantes com dados de exemplo
```
