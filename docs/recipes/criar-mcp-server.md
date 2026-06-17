# Receita: Criar um MCP Server

## Objetivo

Criar um servidor MCP (Model Context Protocol) em Python com FastMCP que expõe ferramentas de acesso a dados ou funcionalidades para agentes de IA. O resultado é um servidor configurável via stdio, com schemas Pydantic validados, pronto para ser referenciado em `.mcp.json` de qualquer projeto.

## Quando usar

- Você precisa que agentes de IA acessem uma base de dados, API interna ou serviço específico
- Você quer expor capacidades de busca, geração de documentos ou consulta a sistemas legados para agentes Claude Code ou Codex
- Você está construindo uma extensão da própria fábrica (como o `tools/mcp-knowledge-search/` já existente)
- Você precisa de integração entre Claude Code e ferramentas proprietárias da sua organização

> O servidor MCP em `tools/mcp-knowledge-search/` é a implementação de referência desta receita
> — leia o código em `tools/mcp-knowledge-search/server.py` antes de começar.

## Agentes envolvidos

| Agente | Papel nesta receita |
|--------|---------------------|
| `@techlead` | Classificação Gate A0, aprovação de gates |
| `@architect` | Design das ferramentas: lista, schemas Pydantic, política de acesso |
| `@devbackend` | Implementação do servidor FastMCP com todas as ferramentas |
| `@devsecops` | Revisão de secrets, validação de inputs, logs sem dados sensíveis |
| `@qa` | Testes de todas as ferramentas: queries válidas, edge cases, fallbacks |

## Fluxo de execução

### Etapa 1 — Classificação do arquétipo (Gate A0)

```
@techlead Classifique o arquétipo: servidor Python com FastMCP que expõe
4 ferramentas de busca e recuperação de documentos em uma base de conhecimento
interna SQLite com FTS5. Comunicação via stdio. Sem interface web.
```

Resultado esperado: `A0_APPROVED` com arquétipo `mcp_server` e referência
ao Golden Model `standards/golden-model-mcp-server.md`.

---

### Etapa 2 — Design das ferramentas (Gate 2)

```
@architect Projete o MCP server para base de conhecimento interna. Entregue:

1. Lista completa de ferramentas (tool name, descrição, quando usar):
   - search_knowledge(query: str, limit: int = 10) → lista de documentos relevantes
   - get_full_document(doc_id: str) → documento completo por ID
   - get_context(doc_id: str) → seções adjacentes do mesmo arquivo
   - health_check() → status do banco, contagem de documentos, versão

2. Schemas Pydantic v2 para cada ferramenta:
   - Input schema: tipos, valores default, validações (ex: query não pode ser vazia)
   - Output schema: estrutura da resposta, campos opcionais vs. obrigatórios

3. Política de acesso:
   - O servidor roda localmente (stdio) — quem tem acesso ao processo tem acesso total
   - Não há autenticação por usuário — proteção é feita no nível do sistema operacional
   - Rate limiting: não necessário para uso local, mas documentar se for exposto via HTTP

4. Configuração:
   - Variáveis de ambiente necessárias: KNOWLEDGE_DB_PATH
   - Comportamento se o banco não existir: health_check retorna status "unavailable",
     as outras ferramentas retornam erro claro (não stack trace)

5. Estrutura de projeto (uv):
   src/knowledge_server/
     __init__.py
     server.py      # FastMCP app e definição das ferramentas
     database.py    # Conexão SQLite e queries FTS5
     models.py      # Schemas Pydantic v2
     config.py      # Configuração via BaseSettings
```

---

### Etapa 3 — Implementação (desenvolvimento)

```
@devbackend Implemente o servidor MCP de base de conhecimento com FastMCP:

server.py:
  from fastmcp import FastMCP
  from .models import SearchInput, SearchResult, DocumentResult, HealthResult
  from .database import KnowledgeDB

  mcp = FastMCP("knowledge-server")

  @mcp.tool()
  def search_knowledge(query: str, limit: int = 10) -> list[SearchResult]:
      """Busca full-text na base de conhecimento. Retorna documentos ordenados
      por relevância. Use para encontrar conteúdo sobre um tópico específico."""
      # validar: query não pode ser vazia
      # executar FTS5: SELECT doc_id, title, snippet FROM fts_docs WHERE fts_docs MATCH ?
      # retornar lista de SearchResult ou lista vazia (nunca levantar exceção para query inválida)

  @mcp.tool()
  def get_full_document(doc_id: str) -> DocumentResult | None:
      """Recupera o documento completo por ID. Retorna None se não encontrado."""
      # validar: doc_id não pode ser vazio
      # buscar na tabela documents
      # retornar None (não 404 — ferramentas MCP não têm código HTTP)

  @mcp.tool()
  def get_context(doc_id: str) -> list[DocumentResult]:
      """Recupera seções adjacentes do mesmo arquivo. Útil para contexto
      de um trecho encontrado por search_knowledge."""

  @mcp.tool()
  def health_check() -> HealthResult:
      """Verifica saúde do servidor: banco disponível, contagem de documentos.
      Use para diagnóstico — nunca para lógica de negócio."""

Requisitos obrigatórios:
- Todas as ferramentas aceitam e retornam schemas Pydantic v2 (não dicts raw)
- Erros são retornados como parte do schema de resposta (campo error: str | None)
  — ferramentas MCP nunca devem levantar exceções não tratadas
- Logging estruturado (structlog): uma linha por chamada de ferramenta com
  tool_name, input_size, result_count, duration_ms
- Entry point para stdio: if __name__ == "__main__": mcp.run(transport="stdio")
```

```
@devbackend Implemente database.py com as queries SQLite FTS5:

Cuidado com a query FTS5: a sintaxe correta é:
  SELECT doc_id, title, snippet(fts_docs, 2, '<b>', '</b>', '...', 20)
  FROM fts_docs
  WHERE fts_docs MATCH ?

NÃO use: FROM documents WHERE documents MATCH ?
(A tabela virtual FTS5 tem nome diferente da tabela principal)

Referência: ver o bug corrigido em tools/mcp-knowledge-search/test_health.py linha 101.

Implementar:
- search(query: str, limit: int) → list[dict]
- get_document(doc_id: str) → dict | None
- get_adjacent(doc_id: str) → list[dict]
- count_documents() → int
- is_available() → bool (não levanta exceção se banco ausente)
```

---

### Etapa 4 — Auditoria de segurança (Gate 5)

```
@devsecops Revise o servidor MCP de base de conhecimento:

1. SQL Injection nas queries FTS5:
   - A query do usuário é passada como parâmetro (?) ou concatenada na string SQL?
   - Uma query com caracteres especiais FTS5 (ex: "OR CRITICAL OR") pode causar
     comportamento inesperado? Testar e documentar o comportamento.
   - Teste: search_knowledge('"; DROP TABLE documents; --') deve retornar [] ou
     erro tratado, nunca executar DDL

2. Secrets e configuração:
   - KNOWLEDGE_DB_PATH está apenas em variável de ambiente?
   - O servidor não loga o caminho completo do banco (pode revelar estrutura de diretórios)
   - O .env está no .gitignore?

3. Dados sensíveis nos logs:
   - Os logs não incluem o conteúdo dos documentos retornados (apenas metadados)
   - Queries do usuário são logadas? Se sim, há risco de logar dados sensíveis?
   - Recomendação: logar hash da query ou primeiros 50 chars, não a query completa

4. Transporte stdio:
   - O servidor stdio não abre portas de rede — verifique que não há bind para 0.0.0.0
   - Se futuramente for exposto via HTTP, autenticação será necessária (documentar)

5. Dependências:
   uv audit para verificar vulnerabilidades em fastmcp, pydantic, structlog
```

---

### Etapa 5 — Testes (Gate 4)

```
@qa Implemente os testes para o servidor MCP de base de conhecimento.
Use o arquivo tools/mcp-knowledge-search/test_health.py como referência.

Testes unitários (pytest):
1. search_knowledge("conhecimento válido") → retorna lista com doc_id e title
2. search_knowledge("") → retorna [] ou SearchResult com error (nunca exceção)
3. search_knowledge("query muito longa" * 100) → tratada sem falhar
4. get_full_document("id_existente") → retorna DocumentResult com content
5. get_full_document("id_inexistente") → retorna None (não levanta exceção)
6. get_full_document("") → retorna None ou error no schema
7. health_check() → retorna HealthResult com status "ok" e document_count > 0
8. health_check() com banco ausente → retorna status "unavailable" (não exceção)

Testes de integração:
9. Criar banco SQLite temporário com fixtures, inserir 3 documentos,
   verificar que search encontra por palavra-chave
10. Verificar que get_context retorna documentos do mesmo arquivo
11. Verificar idempotência: chamar search 2x com mesma query retorna mesmos resultados

Testes de segurança (solicitados pelo @devsecops):
12. search_knowledge com caracteres especiais FTS5 → sem SQL injection
13. get_full_document com doc_id contendo path traversal ("../../../etc/passwd")
    → retorna None (não tenta abrir o arquivo)
```

---

### Etapa 6 — Configuração e integração

```
@devbackend Crie os arquivos de configuração para integração:

1. pyproject.toml com entry point:
   [project.scripts]
   knowledge-server = "knowledge_server.server:main"

   [tool.uv.scripts]
   serve = "python -m knowledge_server.server"

2. Template .mcp.json para projetos que usarão este servidor:
   {
     "mcpServers": {
       "knowledge": {
         "command": "uv",
         "args": ["run", "knowledge-server"],
         "cwd": "/caminho/para/knowledge-server",
         "env": {
           "KNOWLEDGE_DB_PATH": "/caminho/para/knowledge.db"
         }
       }
     }
   }

3. Script de verificação (test_health.py):
   - Conecta ao banco, verifica contagem de documentos
   - Executa uma query FTS5 de teste
   - Imprime relatório de saúde (igual ao padrão de tools/mcp-knowledge-search/)
   - Exit code 0 se OK, 1 se ERROR
```

---

### Etapa 7 — Validação de integração com Claude Code

Após configurar `.mcp.json`, teste as ferramentas em uma sessão Claude Code:

```
# Em sessão Claude Code no diretório do projeto:
# Verificar que o servidor está disponível
knowledge_stats()

# Testar busca
search_knowledge("termo de teste")

# Testar recuperação completa
get_full_document("algum_doc_id_retornado_pela_busca")

# Testar health check
health_check()
```

## Artefatos esperados

- `src/knowledge_server/` — código-fonte completo (server.py, database.py, models.py, config.py)
- `pyproject.toml` — dependências (fastmcp, pydantic, structlog) e entry points
- `.env.example` — variáveis de ambiente documentadas
- `tests/` — testes unitários e de integração com cobertura ≥ 80%
- `test_health.py` — script de diagnóstico standalone
- `.mcp.json.template` — template de configuração para projetos consumidores
- `Security_Audit.md` — checklist de segurança preenchido pelo `@devsecops`

## Gates envolvidos

| Gate | Responsável | Critério de aprovação |
|------|-------------|----------------------|
| A0 | `@techlead` | Arquétipo classificado como `mcp_server` |
| 2 | `@techlead` + `@architect` | Lista de ferramentas e schemas aprovados |
| 4 | `@qa` | pytest passa; health_check funciona; edge cases cobertos |
| 5 | `@devsecops` | Sem SQL injection; sem secrets hardcoded; logs sem dados sensíveis |

## Comandos de validação

```powershell
# Saúde da fábrica
.\doctor.ps1

# Verificar MCP Knowledge Search da fábrica (referência)
.\test-mcp.ps1
```

```bash
# Setup do ambiente
uv sync

# Executar testes com cobertura
uv run pytest --cov=src/knowledge_server --cov-report=term-missing --cov-fail-under=80

# Testar health do servidor
uv run python test_health.py

# Testar manualmente via stdio (simula Claude Code)
echo '{"method":"tools/list","id":1}' | uv run knowledge-server

# Verificar dependências vulneráveis
uv audit
```

```powershell
# Verificar knowledge do agente sobre MCP
# (em sessão Claude Code):
# @architect search_knowledge("FastMCP mcp_server Golden Model")
# @devbackend search_knowledge("FastMCP Pydantic stdio")
# @devsecops search_knowledge("MCP server security")
```

## Implementação de referência

O servidor MCP de busca de conhecimento desta própria fábrica é a implementação
de referência para esta receita:

- Código: `tools/mcp-knowledge-search/server.py`
- Script de saúde: `tools/mcp-knowledge-search/test_health.py`
- Configuração: `.mcp.json` (gerado pelo `install.ps1`, gitignored)
- Ingestão: `tools/mcp-knowledge-search/ingest.py`

Antes de implementar um novo servidor MCP, leia esses arquivos para entender
os padrões em uso.

## Próximos passos

Após Gate 5 aprovado:

1. **Indexação incremental**: se o banco de conhecimento cresce frequentemente, implementar ingest incremental (só reindexar arquivos modificados) — o padrão de `ingest.py` já faz isso por hash
2. **Caching de queries**: para buscas repetitivas, `functools.lru_cache` ou um cache em memória simples pode melhorar a latência
3. **Múltiplos projetos**: para ativar o servidor em outro projeto, use `link-mcp.ps1` como referência — crie um script análogo para o seu servidor
4. **Transporte HTTP**: se precisar expor o servidor para múltiplos clientes (não apenas stdio), FastMCP suporta `transport="http"` — mas adiciona necessidade de autenticação (Bearer token ou mTLS)
5. **Métricas**: adicionar contadores (queries por minuto, latência p99) ao health_check para monitoramento operacional
