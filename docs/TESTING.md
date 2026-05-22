# Testes — AI Software Factory

## Suites de teste disponíveis

| Suite | Ferramenta | Escopo | Como executar |
|-------|-----------|--------|--------------|
| MCP pytest | pytest | 39 testes: database.py + server.py (6 ferramentas) | `python -m pytest tools/mcp-knowledge-search/tests/ -v` |
| Factory Validators | Python | 10 validadores: estrutura, JSON, licenças, links | `python tools/factory-validators/run_all.py` |
| Diagnóstico de instalação | PowerShell | 14 categorias do ambiente instalado | `.\doctor.ps1` |
| MCP health check | PowerShell | 7 verificações do servidor MCP | `.\test-mcp.ps1` |
| CI automático | GitHub Actions | Todos os itens acima, em push/PR | `.github/workflows/validate-factory.yml` |

---

## MCP pytest suite

Testa o servidor MCP Knowledge Search sem exigir `knowledge.db` real — usa fixtures SQLite em memória.

**Pré-requisito:**

```powershell
pip install fastmcp pytest
```

**Executar:**

```powershell
cd C:\Projetos\Pessoal\ai_software_factory
python -m pytest tools/mcp-knowledge-search/tests/ -v
```

**39 testes em 6 classes:**

| Classe | Testes | O que verifica |
|--------|--------|---------------|
| `TestSearch` | 8 | busca FTS5, filtros, limit, DB vazio |
| `TestSearchFiltered` | 4 | filtros category/source, sem resultado, filtros vazios |
| `TestGetDocument` | 3 | doc existente, não existente retorna None, campos |
| `TestGetStats` | 4 | total correto, by_category, DB vazio |
| `TestGetRelated` | 2 | estrutura retornada, erro para doc inexistente |
| `TestGetConnection` | 2 | retorna conexão, arquivo ausente |
| `TestHealthCheck` | 3 | ok/db ausente/db vazio |
| `TestSearchKnowledge` | 4 | JSON, termo conhecido, sem resultado, truncamento 300 |
| `TestSearchWithFilters` | 3 | category filter, JSON inválido lança, filtros vazios |
| `TestGetFullDocument` | 2 | existente, inexistente retorna JSON de erro (sem traceback) |
| `TestGetContext` | 2 | estrutura existente, erro para inexistente |
| `TestKnowledgeStats` | 2 | retorna stats, DB vazio |

**Fixtures (`conftest.py`):**

| Fixture | Conteúdo |
|---------|---------|
| `db_path` | SQLite temporário com schema + 3 documentos de amostra |
| `empty_db_path` | SQLite com schema, zero documentos |
| `missing_db_path` | Caminho que não existe |

---

## Factory Validators

10 scripts Python que validam a estrutura e consistência da factory sem precisar de instalação.

**Executar todos:**

```powershell
python tools/factory-validators/run_all.py
```

**Executar individualmente:**

```powershell
python tools/factory-validators/validate_agent_structure.py
```

**Validadores disponíveis:**

| Validador | O que verifica |
|-----------|---------------|
| `validate_governance_files` | 24 arquivos de governança e documentação obrigatórios |
| `validate_licensing` | LICENSE (Apache-2.0), LICENSE-DOCS (CC BY 4.0), NOTICE, CONTRIBUTING, VERSION |
| `validate_json_files` | Todos os 325+ arquivos `.json` são JSON válido (inclui BOM UTF-8) |
| `validate_agent_structure` | 11 agentes com 8 arquivos + 6 pastas + 5 arquivos em knowledge/ |
| `validate_skill_structure` | 97 skills com 6 arquivos obrigatórios + seção Knowledge Access Policy |
| `validate_source_maps` | source_map.json de cada agente: JSON válido, agent_id, lista de fontes |
| `validate_golden_models` | 8 golden models + project-classification.md em standards/ |
| `validate_prompt_mcp_policy` | prompt.md de cada agente contém knowledge/ e regra de isolamento runtime |
| `validate_no_hardcoded_paths` | Nenhum caminho absoluto de máquina em arquivos .md de agentes |
| `validate_markdown_links` | Links internos em docs/ e raiz apontam para arquivos existentes |

**Opção fail-fast:**

```powershell
python tools/factory-validators/run_all.py --fail-fast
```

---

## doctor.ps1

Execute do diretório raiz da factory:

```powershell
.\doctor.ps1
```

O script verifica 14 categorias do ambiente instalado:

| # | Categoria | O que verifica |
|---|-----------|----------------|
| 1 | FACTORY_ROOT | Variável de ambiente definida e aponta para diretório existente |
| 2 | Python | Interpretador Python 3.x disponível no PATH |
| 3 | Dependências MCP | Pacote `mcp` instalado no Python detectado |
| 4 | Arquivos de agente | 11 arquivos em `~/.claude/agents/` com conteúdo válido |
| 5 | knowledge.db | Banco existe em `tools/mcp-knowledge-search/knowledge.db` |
| 6 | Tamanho do banco | knowledge.db tem tamanho razoável (não vazio ou corrompido) |
| 7 | ~/.claude.json | Entrada `mcpServers.knowledge` presente na raiz |
| 8 | mcp_settings.json | Configuração global Roo Code presente (se instalado) |
| 9 | .mcp.json | Arquivo de configuração local existe na raiz da factory |
| 10 | roo/.roomodes | Arquivo de modos Roo Code gerado |
| 11 | roo/.clinerules | Arquivo de regras Cline gerado |
| 12 | Scripts auxiliares | `update-knowledge.ps1`, `link-mcp.ps1`, `link-roo.ps1` existem |
| 13 | Factory manifest | `knowledge-config.json` existe e contém versão |
| 14 | Paths de agente | Nenhum arquivo de agente tem FACTORY_ROOT obsoleto |

**Códigos de saída:** `0` = OK ou WARN, `1` = pelo menos um ERROR

**Interpretação:** `OK` = passou, `WARN` = opcional ausente (ex: Roo Code não instalado), `ERROR` = falha crítica — executar `.\install.ps1`

---

## test-mcp.ps1

```powershell
.\test-mcp.ps1
```

7 verificações focadas no servidor MCP:

| # | Verificação | Critério de sucesso |
|---|-------------|---------------------|
| 1 | FACTORY_ROOT definido | Variável de ambiente existe e diretório é válido |
| 2 | server.py existe | `tools/mcp-knowledge-search/server.py` presente |
| 3 | knowledge.db existe | Banco em `tools/mcp-knowledge-search/knowledge.db` |
| 4 | FTS query funciona | Query de teste retorna ao menos 1 resultado |
| 5 | Pacote mcp instalado | `import mcp` não levanta ImportError |
| 6 | Tool listing funciona | Servidor responde corretamente à listagem de ferramentas |
| 7 | Document count > 0 | Banco contém documentos indexados |

**Códigos de saída:** `0` = todos passaram, `1` = um ou mais falharam

---

## Teste manual de agentes

Após a instalação, verifique que os agentes funcionam:

**Verificação básica:**

```
@techlead quais gates você aplicaria a um projeto de API REST simples?
```

Esperado: responde com conhecimento sobre os gates sem precisar de arquivos locais.

**Verificação do MCP:**

```
@techlead search_knowledge("tollgate decision skill")
```

Esperado: retorna resultados do `knowledge.db` com trechos de artefatos da factory.

**Verificação de classificação:**

```
@techlead classifique o arquétipo: script Python que sincroniza dados de um ERP para um banco local, rodando todo dia às 2h
```

Esperado: retorna JSON com `project_type: "automation_script"`.

**Verificação do Roo Code** (após `link-roo.ps1` em um projeto): abrir VS Code, verificar 11 modos com emojis, selecionar "🏗️ Tech Lead" e fazer uma pergunta.

---

## Sequência recomendada pós-instalação

```powershell
# 1. Diagnóstico do ambiente
.\doctor.ps1

# 2. Validação do MCP
.\test-mcp.ps1

# 3. Validadores de estrutura (sem instalação)
python tools/factory-validators/run_all.py

# 4. Suite pytest (requer pip install fastmcp pytest)
python -m pytest tools/mcp-knowledge-search/tests/ -v

# 5. Teste manual no Claude Code
claude
# @techlead health_check()
```

---

## CI — GitHub Actions

O workflow `.github/workflows/validate-factory.yml` roda automaticamente em push e PR para `main`:

- **python-tests**: executa os 39 testes pytest em Python 3.11 e 3.12
- **factory-validators**: executa os 10 validadores de estrutura

Para contribuir com novos testes, veja `CONTRIBUTING.md`.
