# Testes — AI Software Factory

## Suites de teste disponíveis

| Suite | Ferramenta | Escopo | Como executar |
|-------|-----------|--------|--------------|
| MCP pytest | pytest | 39 testes: database.py + server.py (6 ferramentas) | `python -m pytest tools/mcp-knowledge-search/tests/ -v` |
| Factory Validators | Python | 11 validadores: estrutura, runtimes, JSON, licenças, links | `python tools/factory-validators/run_all.py` |
| Pester (PowerShell) | Pester v5 | Syntax + comportamento de install/doctor/uninstall/link | `Invoke-Pester tests/powershell/` |
| Smoke Prompts | Manual | 9 arquivos com prompts pré-escritos + pass/fail signals | Copiar prompt → Claude Code ou Codex |
| Eval Harness | PowerShell + humano | 7 casos semi-automatizados + 8 rubricas de pontuação | `.\evals\run-evals.ps1` |
| Diagnóstico de instalação | PowerShell | diagnóstico multi-runtime do ambiente instalado | `.\doctor.ps1` |
| MCP health check | PowerShell | 7 verificações do servidor MCP | `.\test-mcp.ps1` |
| CI automático | GitHub Actions | MCP pytest + factory validators, em push/PR | `.github/workflows/validate-factory.yml` |

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

11 scripts Python que validam a estrutura e consistência da factory sem precisar de instalação.

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
| `validate_agent_structure` | 12 agentes com 8 arquivos + 6 pastas + 5 arquivos em knowledge/ |
| `validate_skill_structure` | 97 skills com 6 arquivos obrigatórios + seção Knowledge Access Policy |
| `validate_source_maps` | source_map.json de cada agente: JSON válido, agent_id, lista de fontes |
| `validate_golden_models` | 8 golden models + project-classification.md em standards/ |
| `validate_prompt_mcp_policy` | prompt.md de cada agente contém knowledge/ e regra de isolamento runtime |
| `validate_runtime_compatibility` | wiring Claude/Codex, AGENTS.md, custom agents e MCP |
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

O script verifica as categorias principais do ambiente instalado:

| # | Categoria | O que verifica |
|---|-----------|----------------|
| 1 | FACTORY_ROOT | Variável de ambiente definida e aponta para diretório existente |
| 2 | Python | Interpretador Python 3.x disponível no PATH |
| 3 | Dependências MCP | Pacote `mcp` instalado no Python detectado |
| 4 | Claude Code | CLI detectável quando disponível |
| 5 | Codex | CLI/config detectável quando disponível |
| 6 | Agentes Claude | 12 arquivos em `~/.claude/agents/` com conteúdo válido |
| 7 | Custom agents Codex | 12 arquivos em `~/.codex/agents/` com conteúdo válido |
| 8 | Knowledge Database | `knowledge.db` existe na raiz da factory |
| 9 | MCP Health Check | Executa `test-mcp.ps1` |
| 10 | MCP Configuração | `~/.claude.json`, `~/.codex/config.toml`, `.mcp.json` e `.codex/config.toml` |
| 11 | Paths de agente | Nenhum arquivo de agente tem FACTORY_ROOT obsoleto |
| 12 | Scripts principais | `install`, `uninstall`, `doctor`, `test-mcp`, `link-mcp` |
| 13 | Permissões | Escrita em `~/.claude/agents/`, `~/.codex/agents/` e FACTORY_ROOT |
| 14 | Variáveis de ambiente | `FACTORY_ROOT` disponível |

**Códigos de saída:** `0` = OK ou WARN, `1` = pelo menos um ERROR

**Interpretação:** `OK` = passou, `WARN` = aviso não crítico, `ERROR` = falha crítica — executar `.\install.ps1`

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
| 3 | knowledge.db existe | Banco na raiz da factory |
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

# 5. Teste manual no Claude Code ou Codex
claude
# @techlead health_check()
```

---

## Pester tests (PowerShell)

Testa a sintaxe e o comportamento estrutural dos scripts PowerShell sem exigir instalação completa.

**Pré-requisito:**

```powershell
# Instalar Pester v5 (caso não tenha)
Install-Module -Name Pester -Force -SkipPublisherCheck
```

**Executar todos:**

```powershell
Invoke-Pester tests/powershell/ -Output Detailed
```

**Executar um arquivo específico:**

```powershell
Invoke-Pester tests/powershell/Install.Tests.ps1 -Output Detailed
```

**Arquivos disponíveis:**

| Arquivo | Script testado | O que verifica |
|---------|---------------|----------------|
| `Install.Tests.ps1` | `install.ps1` | Sintaxe AST, parâmetro `-ForceDeps`, array `$agents` com 12 entradas, arquivo VERSION, marcadores de idempotência |
| `Doctor.Tests.ps1` | `doctor.ps1` | Sintaxe AST, funções helper, categorias principais no conteúdo, exit code 0 ou 1 via child process |
| `Uninstall.Tests.ps1` | `uninstall.ps1` | Sintaxe AST, 4 parâmetros, modo `-WhatIf` não deleta arquivos (usa `$TestDrive`), segurança do marcador AUTO-GENERATED |
| `LinkMcp.Tests.ps1` | `link-mcp.ps1` | Sintaxe AST, exit 1 sem `FACTORY_ROOT`, exit 1 sem `.mcp.json`, cópia real para `$TestDrive` com backup |

**Técnicas usadas:**

- `$TestDrive` — diretório temporário por teste, limpo automaticamente pelo Pester
- Child process via `pwsh -NonInteractive -Command ...` — testa scripts com `exit` sem encerrar o runner
- Mock de `$env:USERPROFILE` / `$env:FACTORY_ROOT` — testa comportamento de caminhos sem tocar o ambiente real
- AST parse — valida sintaxe sem executar o script

---

## Smoke Prompts

Prompts pré-escritos com comportamento esperado e sinais de pass/fail. Não são automatizados — requerem uma sessão Claude Code ou Codex.

**Localização:** `tests/agent-smoke-prompts/`

**Arquivos disponíveis:**

| Arquivo | Agente principal | O que testa |
|---------|-----------------|------------|
| `techlead.md` | `@techlead` | Gate A0, enforcement de gate, trigger de ADR, atualização do State Ledger, escalação humana |
| `architect.md` | `@architect` | Golden Model (web_app), desvio com ADR, estratégia de segurança, arquétipo automation_script |
| `qa.md` | `@qa` | Geração de plano de testes, threshold 80% de cobertura, alinhamento BDD |
| `devsecops.md` | `@devsecops` | SQL injection → OWASP A03, Gate 5 incontornável, detecção de secrets, LGPD |
| `dataengineer.md` | `@dataengineer` | Stack Polars+DuckDB+Pandera, qualidade de dados, bronze/silver/gold |
| `dataanalyst.md` | `@dataanalyst` | Métricas, análise exploratória, confiança, caveats e dashboard specs |
| `automation-script-flow.md` | Todos | Fluxo completo Gate A0→3 para automation_script (regressão crítica: não deve retornar stack web_app) |
| `mcp-first.md` | Todos | MCP search acionado, citação de fonte, sem alucinação, comportamento de fallback |
| `web-app-flow.md` | Todos | Golden Model web_app, Gate A0→2, invariantes críticos (proxy.ts, prisma migrate) |
| `governance-licensing.md` | Todos | Licenciamento dual, política de secrets, copyright, Code of Conduct |

**Como executar:**

1. Abrir o arquivo de smoke test:
   ```powershell
   code tests/agent-smoke-prompts/techlead.md
   ```
2. Copiar o prompt da seção correspondente
3. Colar em uma sessão Claude Code com o agente indicado ou pedir ao Codex para usar o custom agent correspondente
4. Comparar a resposta com "Expected behavior" e "Pass signals"

**Testes de maior prioridade para regressão:**

1. `automation-script-flow.md` — previne misclassificação automation → web_app
2. `techlead.md` → Smoke Test 2 (enforcement de gate)
3. `devsecops.md` → Smoke Test 2 (Gate 5 incontornável)
4. `mcp-first.md` → Smoke Test 3 (sem alucinação)

---

## Eval Harness (evals/)

Casos semi-automatizados com verificação de `expected_contains`/`must_not_contain` e rubricas de pontuação 0–3 por dimensão.

**Estrutura:**

```
evals/
├── cases/          # 7 arquivos JSON com casos de teste
├── rubrics/        # 8 rubricas de pontuação em Markdown
├── run-evals.ps1   # Runner interativo (human-in-the-loop)
└── results/        # Resultados salvos (gitignored)
```

**Casos disponíveis:**

| Arquivo | Agente | Discriminador principal |
|---------|--------|------------------------|
| `web_app_architecture.json` | `@architect` | Stack Next.js 16, 15 termos esperados |
| `python_automation.json` | `@techlead` | Classificação automation_script, NOT web_app |
| `data_pipeline.json` | `@techlead` | Polars+DuckDB, NOT pandas+SQLAlchemy |
| `security_review.json` | `@devsecops` | SQL injection → OWASP A03 → BLOCKED |
| `mcp_first_behavior.json` | `@techlead` | MCP search acionado antes de responder |
| `project_archetype_classification.json` | `@techlead` | 3 descrições → arquétipo correto cada |
| `licensing_governance_awareness.json` | `@techlead` | Apache-2.0 (código) ≠ CC BY 4.0 (docs) |

**Rubricas disponíveis:**

| Rubrica | Agente | Dimensões | Pontuação máxima |
|---------|--------|-----------|-----------------|
| `techlead_rubric.md` | `@techlead` | Classificação, gates, State Ledger, ADR, riscos, MCP, escalação, delegação | 24 |
| `architect_rubric.md` | `@architect` | Golden Model, ADR, segurança, observabilidade, contrato de API, schema | 21 |
| `qa_rubric.md` | `@qa` | Cobertura, Vitest/Playwright, edge cases, BDD, performance | 15 |
| `devsecops_rubric.md` | `@devsecops` | OWASP Top 10, threat model, secrets, LGPD, bloqueio Gate 5 | 15 |
| `dataengineer_rubric.md` | `@dataengineer` | Arquétipo de pipeline, Pandera, idempotência, camadas bronze/silver/gold | 15 |
| `dataanalyst_rubric.md` | `@dataanalyst` | Definição de métricas, qualidade de dados, causalidade, confiança e recomendações | 15 |
| `automation_script_rubric.md` | Qualquer | Stack automation_script, dry-run, idempotência, retry, secrets | 18 |
| `mcp_first_rubric.md` | Todos | MCP search acionado, citação de fonte, sem alucinação, fallback | 15 |
| `governance_rubric.md` | Todos | Licenciamento dual, secrets, copyright, governança | 15 |

**Executar:**

```powershell
# Todos os casos (interativo)
.\evals\run-evals.ps1

# Caso específico
.\evals\run-evals.ps1 -CaseName python

# Com rubrica de pontuação
.\evals\run-evals.ps1 -CaseName security -RubricName devsecops_rubric

# Listar casos sem executar
.\evals\run-evals.ps1 -NonInteractive
```

Resultados são salvos em `evals/results/<timestamp>-results.json`.

**Fluxo human-in-the-loop:**

1. O runner exibe o prompt do caso
2. Você envia o prompt ao agente indicado em Claude Code
3. Cola a resposta completa no runner
4. O runner verifica automaticamente `expected_contains` e `must_not_contain`
5. Você aplica a rubrica para pontuação detalhada (opcional)
6. O resultado (PASS / PARTIAL / FAIL) é salvo com timestamp

**Critérios:**

| Resultado | Condição |
|-----------|----------|
| PASS | Todos os `expected_contains` presentes + nenhum `must_not_contain` |
| FAIL | Qualquer `must_not_contain` presente, ou omissões críticas |
| PARTIAL | Maioria dos `expected_contains` presente, sem recomendações erradas |

---

## CI — GitHub Actions

O workflow `.github/workflows/validate-factory.yml` roda automaticamente em push e PR para `main`:

- **python-tests**: executa os 39 testes pytest em Python 3.11 e 3.12
- **factory-validators**: executa a suíte de validadores de estrutura e compatibilidade

Smoke prompts e eval cases **não rodam em CI** — requerem uma sessão Claude Code ou Codex ao vivo.

Para contribuir com novos testes, veja `CONTRIBUTING.md`.
