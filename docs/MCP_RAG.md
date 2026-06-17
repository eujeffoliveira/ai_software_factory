# MCP Knowledge Search — Guia Técnico

## O que é o knowledge.db

`knowledge.db` é um banco SQLite com extensão FTS5 (Full-Text Search 5) que indexa toda a factory: skills, schemas, templates, exemplos, checklists, playbooks e documentação dos agentes. São aproximadamente 7.000 documentos indexados.

O banco é criado pelo script `tools/mcp-knowledge-search/ingest.py` durante a execução de `install.ps1` e atualizado de forma incremental por `update-knowledge.ps1` (reindexação apenas dos arquivos `.md` mais novos que o banco).

## Como o servidor MCP funciona

O servidor MCP (`tools/mcp-knowledge-search/server.py`) é um processo **stdio** baseado em FastMCP. Ele é iniciado **sob demanda** por Claude Code ou Codex quando um agente realiza a primeira chamada de ferramenta — não precisa estar rodando em background.

Fluxo de uma chamada:

```
Agente no runtime
  → chama search_knowledge("termo")
    → cliente inicia server.py via stdio (se não estiver ativo)
      → server.py executa query FTS5 em knowledge.db
        → retorna resultados JSON
```

A configuração do servidor fica em:

- `~/.claude.json` — escopo global, nível raiz (`mcpServers.knowledge`) — usado pelo Claude Code
- `~/.codex/config.toml` — escopo global Codex (`mcp_servers.knowledge`)
- `.codex/config.toml` — escopo local Codex em projetos confiáveis
- `.mcp.json` — configuração local por projeto (criado por `link-mcp.ps1`)

## Política MCP-first

Todos os agentes consultam o MCP **antes** de responder sobre skills, schemas, templates ou checklists internos da factory. O MCP é a fonte primária de conhecimento profundo.

Se o MCP falhar, o agente **obrigatoriamente**:

1. Declara explicitamente que o MCP falhou
2. Indica que está usando fallback via leitura direta de arquivos
3. Recomenda executar `.\test-mcp.ps1`
4. **Nunca usa fallback silencioso** — respostas sem declaração de falha implicam que o MCP estava disponível

## Ferramentas disponíveis (6)

| Ferramenta | Assinatura | Descrição |
|------------|-----------|-----------|
| `health_check` | `health_check()` | Verifica conectividade e estado do banco. Retorna status, contagem de documentos e versão. |
| `knowledge_stats` | `knowledge_stats()` | Estatísticas do banco: total de documentos, categorias indexadas, data do último ingest. |
| `search_knowledge` | `search_knowledge("termo")` | Busca full-text em todos os documentos indexados. Retorna até 10 resultados com trecho e score. |
| `search_with_filters` | `search_with_filters("termo", filters="{}")` | Busca com filtros por categoria, agente ou tipo de artefato (JSON). |
| `get_full_document` | `get_full_document("doc_id")` | Recupera o documento completo pelo ID retornado em uma busca anterior. |
| `get_context` | `get_context("doc_id")` | Recupera seções adjacentes do mesmo arquivo para contexto adicional. |

### Exemplos de uso

```
# Busca básica
search_knowledge("tollgate decision skill")

# Busca com filtro por agente
search_with_filters("user story", filters='{"agent": "Agente01"}')

# Recuperar documento completo
get_full_document("agente01_skills_user-story-generation_skill")

# Verificar saúde
health_check()
```

## Verificar no Claude Code

Em uma sessão do Claude Code, verifique se o servidor está conectado:

```
/mcp
```

O servidor `knowledge` deve aparecer com status `connected`. Se não aparecer, execute `.\install.ps1`.

Para testar a funcionalidade diretamente:

```
@techlead health_check()
```

## Verificar no Codex

Após `.\install.ps1`, o Codex recebe a entrada `knowledge` em
`~/.codex/config.toml`. No repositório da factory também existe uma configuração
local gerada em `.codex/config.toml`.

Em uma sessão Codex, use `/mcp` quando disponível e confirme que `knowledge`
aparece conectado.

Para ativar o MCP em outro projeto:

```powershell
cd C:\meu-projeto
& "$env:FACTORY_ROOT\link-mcp.ps1"
```

Esse comando cria dois arquivos no projeto alvo:

- `.mcp.json` para clientes que usam o formato `mcpServers`
- `.codex/config.toml` para Codex, usando o formato `mcp_servers`

## test-mcp.ps1

Execute do diretório da factory:

```powershell
.\test-mcp.ps1
```

O script executa 7 verificações em sequência:

| # | Verificação | O que checa |
|---|-------------|-------------|
| 1 | FACTORY_ROOT | Variável de ambiente definida e aponta para diretório válido |
| 2 | server.py | Arquivo `tools/mcp-knowledge-search/server.py` existe |
| 3 | knowledge.db | Banco de dados existe na raiz da factory |
| 4 | FTS query | Executa query de teste e retorna ao menos 1 resultado |
| 5 | mcp package | Pacote `mcp` instalado no Python atual |
| 6 | Tool listing | Servidor responde à listagem de ferramentas via protocolo MCP |
| 7 | Document count | Banco contém mais de 0 documentos indexados |

Códigos de saída: `0` = todos passaram, `1` = um ou mais falharam.

## Logs

O servidor registra eventos em:

```
tools/mcp-knowledge-search/logs/mcp-knowledge.log
```

Formato: uma linha JSON por evento, com campos `timestamp`, `event`, `duration_ms`, `status`. Útil para diagnóstico de lentidão ou erros de query.

Exemplo de linha de log:

```json
{"timestamp": "2026-05-22T14:23:01Z", "event": "search", "query": "tollgate", "duration_ms": 12, "status": "ok", "results": 8}
```

## Solução de problemas

| Problema | Solução |
|----------|---------|
| Servidor não aparece em `/mcp` | Execute `.\install.ps1` — reconfigura `~/.claude.json`, `~/.codex/config.toml` e `.mcp.json` |
| `knowledge.db` não existe | Execute `.\update-knowledge.ps1` para criar o banco |
| Python não encontrado | Instale Python 3.x e adicione ao PATH; depois `.\install.ps1` |
| Dependências MCP faltando | Execute `.\install.ps1 -ForceDeps` |
| Agente usa fallback sem avisar | Execute `.\test-mcp.ps1` para identificar a falha |
| Banco corrompido | `Remove-Item tools/mcp-knowledge-search/knowledge.db -Force; .\update-knowledge.ps1` |
| Erro FTS "no such column: documents" | Bug corrigido: use a tabela `fts_docs`, não `documents` — atualize `server.py` |
| Servidor demora para responder | Verifique o log; banco pode precisar de reindexação — `.\update-knowledge.ps1` |

## Quando reindexar

Execute `.\update-knowledge.ps1` após editar qualquer `.md` em:

- `Agente*/knowledge/`
- `Agente*/skills/`
- `Agente*/templates/`
- `Agente*/examples/`
- `Agente*/checklists/`
- `bibliography/playbooks/`
- `standards/`
- `templates/automation/`
- `checklists/automation/`
- `examples/requests/`

Execute `.\install.ps1` após editar o `prompt.md` de qualquer agente — o instalador propaga o conteúdo completo para `~/.claude/agents/` e `~/.codex/agents/`.

## O que é indexado

O `ingest.py` percorre os seguintes diretórios e indexa todos os arquivos `.md`:

```
skills/          → skill.md, checklist.md, exemplos
schemas/         → apenas arquivos .json com $schema válido (metadados)
templates/       → todos os .md de templates
examples/        → good_*.md e bad_*.md
checklists/      → todos os .md de checklists
knowledge/       → principles, heuristics, decision_rules, knowledge_cards
bibliography/    → playbooks/
standards/       → golden models, project-classification
```

Cada documento recebe um `doc_id` único derivado do caminho relativo, normalizado para lookup consistente.
