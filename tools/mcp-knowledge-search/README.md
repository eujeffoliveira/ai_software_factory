# MCP Knowledge Search

Servidor MCP local de busca full-text usando SQLite FTS5. Permite que qualquer agente da fábrica busque documentação, specs, ADRs e outros artefatos via linguagem natural.

**Migrado de:** [a-gusman-claude/mcp/knowledge-search](https://github.com/eujeffoliveira/a-gusman-claude/tree/main/mcp/knowledge-search)

## Como funciona

1. **Ingestão**: `ingest.py` lê arquivos do projeto e indexa no SQLite com FTS5
2. **Servidor MCP**: `server.py` expõe 5 ferramentas de busca via protocolo MCP
3. **Agentes**: Agente00 e Agente01 usam o servidor para buscar contexto em runtime

## Setup rápido

```bash
# Instalar dependências
pip install -r requirements.txt

# Criar knowledge-config.json no projeto (ver exemplo abaixo)
# Rodar ingestão
python tools/mcp-knowledge-search/ingest.py --config <projeto>/knowledge-config.json

# Iniciar servidor (ou configurar via .mcp.json)
python tools/mcp-knowledge-search/server.py
```

## Exemplo knowledge-config.json

```json
{
  "base_dir": "/path/to/project",
  "db_path": "knowledge.db",
  "sources": [
    {
      "type": "markdown",
      "paths": ["**/*.md"],
      "recursive": true,
      "split_by_heading": true
    }
  ]
}
```

## Configuração no .mcp.json

```json
{
  "mcpServers": {
    "knowledge": {
      "command": "python",
      "args": ["<repo>/tools/mcp-knowledge-search/server.py"],
      "env": {
        "KNOWLEDGE_DB": "<project>/knowledge.db"
      }
    }
  }
}
```

## Ferramentas disponíveis

| Ferramenta | Descrição |
|-----------|-----------|
| `search_knowledge` | Busca full-text com filtro por categoria |
| `search_with_filters` | Busca com filtros em campos do metadata |
| `get_full_document` | Retorna documento completo por ID |
| `get_context` | Retorna documentos adjacentes do mesmo grupo |
| `knowledge_stats` | Estatísticas da base de conhecimento |

## Adaptadores

| Adaptador | Descrição |
|-----------|-----------|
| `markdown` | Indexa arquivos `.md` recursivamente, divide por heading |
| `json_docs` | Indexa arquivos JSON com mapeamento configurável |
| `dossier` | Extrai mensagens, eventos, contratos de pipelines estruturados |
