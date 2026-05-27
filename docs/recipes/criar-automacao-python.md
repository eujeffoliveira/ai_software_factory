# Receita: Criar uma Automação Python

## Objetivo

Criar um script de automação Python do zero usando o arquétipo `automation_script` da fábrica, seguindo o Golden Model com uv + Typer + Pydantic v2 + structlog + pytest. O resultado é um executável robusto, idempotente, com dry-run, logging estruturado e cobertura de testes adequada.

## Quando usar

- Script que processa arquivos, consulta APIs externas ou gera relatórios
- Automação que roda via cron ou agendador (GitHub Actions, Vercel Cron, Task Scheduler)
- ETL leve que não justifica um pipeline completo (use `criar-pipeline-dados.md` para isso)
- Ferramenta de linha de comando interna para a equipe

> **Não use esta receita** para aplicações web com interface de usuário, APIs HTTP com múltiplos endpoints ou pipelines de dados de grande volume.

## Agentes envolvidos

| Agente | Papel nesta receita |
|--------|---------------------|
| `@techlead` | Classificação Gate A0, aprovação dos gates |
| `@po` | Definição dos requisitos: inputs, processamento, outputs, critérios de idempotência |
| `@architect` | Design da automação: estrutura de projeto, schemas Pydantic, estratégia de retries |
| `@engineer` | Decomposição em tasks implementáveis com estimativas |
| `@devbackend` | Implementação do script, cliente de API, gerador de saída |
| `@qa` | Testes pytest, validação de idempotência, dry-run, cobertura |
| `@devsecops` | Revisão de secrets, .gitignore, dados sensíveis em logs |

## Fluxo de execução

### Etapa 1 — Classificação do arquétipo (Gate A0)

```
@techlead Classifique o arquétipo: script Python que lê uma planilha Excel
com dados de produtos, consulta uma API de cotação de moedas e gera um
relatório CSV diário com os preços atualizados. Executado via cron às 6h.
```

Resultado esperado: `A0_APPROVED` com arquétipo `automation_script` e
referência ao Golden Model `standards/golden-model-python-automation.md`.

Se o resultado for `A0_AMBIGUOUS` (ex: parece pipeline de dados), peça ao
`@techlead` para desambiguar com base no volume e complexidade das
transformações.

---

### Etapa 2 — Requisitos (Gate 1)

```
@po Defina os requisitos da automação de atualização de preços:

Inputs:
- Arquivo Excel: products.xlsx (colunas: SKU, nome, preço_base, moeda_origem)
- Variável de ambiente: EXCHANGE_API_KEY (API de cotação)
- Parâmetro CLI: --date (padrão: hoje) para reprocessamento histórico

Processamento:
- Ler planilha Excel
- Para cada moeda única, consultar taxa de câmbio atual (ou da --date)
- Calcular preço_brl = preço_base * taxa
- Retry automático em falha de API (até 3 tentativas, backoff exponencial)

Outputs:
- prices_YYYY-MM-DD.csv na pasta /output
- Log estruturado de cada execução em /logs

Critérios de idempotência:
- Rodar duas vezes com a mesma --date produz o mesmo CSV (sem duplicatas)
- Se o arquivo de saída já existe para a data, sobrescrever (não acumular)

Tratamento de erros:
- API indisponível após 3 retries: logar erro e sair com código 1
- Linha inválida na planilha: logar warning e continuar (não falhar tudo)
- EXCHANGE_API_KEY ausente: falhar com mensagem clara antes de processar

Alertas:
- Se taxa de câmbio variar mais de 10% em relação ao dia anterior: logar WARNING
```

Resultado esperado: documento de requisitos com inputs/outputs/critérios de
aceite detalhados.

---

### Etapa 3 — Design da automação (Gate 2)

```
@architect Projete a automação de atualização de preços seguindo o Golden
Model automation_script:

1. Estrutura de projeto com uv (pyproject.toml, não requirements.txt)
2. CLI Typer com comandos: run (execução principal) e validate (só valida inputs)
3. Schemas Pydantic v2: ProductRow (row da planilha), ExchangeRate (resposta da API),
   PriceRow (linha do CSV de saída), AppConfig (variáveis de ambiente via BaseSettings)
4. Cliente HTTP para API de cotação com httpx + tenacity (retry + backoff)
5. Logging estruturado com structlog: campos obrigatórios em cada linha
   (timestamp, event, sku_count, date, duration_ms)
6. Estratégia de idempotência: escrever em arquivo temporário, renomear atomicamente
7. Modo --dry-run: executa toda a lógica mas não escreve o arquivo de saída

Entregue: diagrama de módulos (texto), schemas Pydantic completos,
interface pública de cada módulo.
```

Resultado esperado: `Architecture.md` da automação com estrutura de diretórios,
schemas Pydantic e diagrama de fluxo.

---

### Etapa 4 — Planejamento (Gate 3)

```
@engineer Decomponha a automação em tasks implementáveis:

TASK-001: Setup do projeto uv (pyproject.toml, .python-version, estrutura de pastas)
TASK-002: Schemas Pydantic v2 (ProductRow, ExchangeRate, PriceRow, AppConfig)
TASK-003: Leitor de planilha Excel com openpyxl (validação e skip de linhas inválidas)
TASK-004: Cliente HTTP para API de cotação (httpx + tenacity, mock para testes)
TASK-005: Lógica de cálculo de preços (transformação pura, sem I/O — fácil de testar)
TASK-006: Escritor de CSV com idempotência (arquivo temporário + rename atômico)
TASK-007: CLI Typer (comandos run e validate, --dry-run, --date)
TASK-008: Logging estruturado com structlog (configuração e campos obrigatórios)
TASK-009: Testes pytest (unitários para transformação, integração com mock da API)
TASK-010: Dockerfile e configuração de cron (crontab ou GitHub Actions)

Estime em story points e identifique dependências entre tasks.
```

---

### Etapa 5 — Implementação (desenvolvimento)

```
@devbackend Implemente a automação de atualização de preços seguindo o design
aprovado. Requisitos obrigatórios:

Estrutura (uv):
  src/price_updater/
    __init__.py
    cli.py          # Typer app
    config.py       # AppConfig (BaseSettings, lê de .env)
    models.py       # Schemas Pydantic v2
    reader.py       # Leitura e validação do Excel
    exchange.py     # Cliente da API de cotação (httpx + tenacity)
    calculator.py   # Transformação pura: calcula preços
    writer.py       # Escreve CSV com idempotência
    logger.py       # Configuração structlog

CLI (Typer):
  price-updater run --date 2026-05-22 --dry-run
  price-updater validate --file products.xlsx

Variáveis de ambiente (nunca hardcoded):
  EXCHANGE_API_KEY, OUTPUT_DIR, LOG_DIR, LOG_LEVEL

Logging obrigatório em cada execução:
  {"event": "run_started", "date": "...", "dry_run": false}
  {"event": "excel_loaded", "row_count": 150, "invalid_rows": 2}
  {"event": "exchange_fetched", "currencies": ["USD","EUR"], "duration_ms": 340}
  {"event": "prices_calculated", "sku_count": 148}
  {"event": "csv_written", "path": "...", "dry_run": false}
  {"event": "run_completed", "duration_ms": 1200, "exit_code": 0}
```

```
@devbackend Implemente o cliente da API de cotação em exchange.py:
- Use httpx para requisições síncronas
- Tenacity: max_attempts=3, wait=exponential(multiplier=1, min=2, max=10)
- Em caso de falha após 3 tentativas: raise ExchangeAPIError com mensagem clara
- Timeout de 10 segundos por requisição
- Logar cada tentativa e cada falha de retry
```

---

### Etapa 6 — Testes e qualidade (Gate 4)

```
@qa Valide a automação de atualização de preços:

Testes unitários (pytest):
1. calculator.py: calcular_preco(preco_base=100, taxa=5.2) == 520.0
2. calculator.py: preco nulo → retorna None e loga warning (não levanta exceção)
3. writer.py: idempotência — chamar 2x com mesmos dados → arquivo idêntico
4. writer.py: dry-run=True → nenhum arquivo criado em disco

Testes de integração (pytest + respx para mock HTTP):
5. exchange.py: resposta 200 com taxa válida → ExchangeRate correto
6. exchange.py: 3 falhas 503 consecutivas → ExchangeAPIError levantado
7. exchange.py: timeout → ExchangeAPIError levantado após 3 tentativas
8. Fluxo completo: Excel válido + API mockada → CSV correto em output/

Validações adicionais:
- Cobertura pytest: mínimo 80% das linhas de src/
- Dry-run não cria nenhum arquivo: verificar que output/ está vazio após execução
- Variável de ambiente ausente: saída com código 1 e mensagem clara (não stack trace)
```

```
@qa Execute os testes e gere o relatório de cobertura:
pytest --cov=src/price_updater --cov-report=term-missing --cov-fail-under=80
```

---

### Etapa 7 — Auditoria de segurança (Gate 5)

```
@devsecops Revise a automação de atualização de preços:

1. Secrets: EXCHANGE_API_KEY está apenas em variável de ambiente?
   Verificar: nenhum print/log que exiba o valor da API key
2. .gitignore: .env, .env.*, output/, logs/ estão listados?
3. Logs: structlog não está logando dados sensíveis (chave de API, preços antes
   de aprovação, dados pessoais de clientes)
4. Testes: nenhuma chave de API real nos arquivos de teste (usar fixture mockada)
5. Dependências: uv audit (ou pip audit) sem vulnerabilidades HIGH/CRITICAL
6. Permissões de arquivo: output/ e logs/ com permissões restritas (não 777)
```

---

### Etapa 8 — Configuração de execução recorrente

```
@devops Configure a execução recorrente da automação:

Opção A (GitHub Actions — recomendado para projetos no GitHub):
- Workflow: .github/workflows/price-updater.yml
- Schedule: cron "0 6 * * 1-5" (segunda a sexta às 6h UTC)
- Secrets configurados no repositório GitHub (EXCHANGE_API_KEY)
- Upload do CSV gerado como artifact do workflow
- Notificação em caso de falha (email ou Slack webhook)

Opção B (Vercel Cron — se já usa Vercel):
- Rota Next.js que chama o script Python como subprocess
- Configurar CRON_SECRET para proteger o endpoint

Inclua: exemplo de pyproject.toml com entry point "price-updater = price_updater.cli:app"
```

## Artefatos esperados

- `pyproject.toml` — dependências, entry points, configuração pytest e coverage
- `src/price_updater/` — código-fonte completo com todos os módulos
- `.env.example` — variáveis de ambiente documentadas (sem valores reais)
- `.gitignore` — .env, output/, logs/, __pycache__, .venv
- `tests/` — testes unitários e de integração com cobertura ≥ 80%
- `Architecture.md` — design da automação, schemas, diagrama de fluxo
- `Execution_Plan.md` — backlog de tasks com estimativas
- `Security_Audit.md` — checklist de segurança preenchido
- `.github/workflows/price-updater.yml` — workflow de execução recorrente

## Gates envolvidos

| Gate | Responsável | Critério de aprovação |
|------|-------------|----------------------|
| A0 | `@techlead` | Arquétipo classificado como `automation_script` |
| 1 | `@techlead` + `@po` | Requisitos com idempotência e tratamento de erros definidos |
| 2 | `@techlead` + `@architect` | Design aprovado com schemas Pydantic e estrutura uv |
| 3 | `@techlead` + `@engineer` | Execution Plan aprovado |
| 4 | `@qa` | pytest passa; cobertura ≥ 80%; idempotência verificada; dry-run funciona |
| 5 | `@devsecops` | Secrets apenas em env vars; sem dados sensíveis em logs; audit limpo |

## Comandos de validação

```powershell
# Verificar saúde da fábrica
.\doctor.ps1

# Verificar que o MCP tem conteúdo sobre automation_script
.\test-mcp.ps1

# Verificar que templates de automação estão acessíveis via MCP
# (execute em sessão Claude Code)
# @architect search_knowledge("automation_script Golden Model")
# @architect search_knowledge("Typer Pydantic structlog")
# @qa search_knowledge("pytest idempotência")
```

```bash
# Dentro do projeto, após implementação:
# Setup do ambiente uv
uv sync

# Executar testes com cobertura
uv run pytest --cov=src --cov-report=term-missing --cov-fail-under=80

# Testar dry-run (nenhum arquivo deve ser criado)
uv run price-updater run --dry-run --date 2026-05-22

# Testar sem API key (deve falhar com mensagem clara)
# Remova temporariamente EXCHANGE_API_KEY do .env e rode:
uv run price-updater run --date 2026-05-22

# Verificar vulnerabilidades nas dependências
uv audit  # ou: pip audit
```

## Templates disponíveis

Esta receita pode usar os templates em `templates/automation/` e os checklists
em `checklists/automation/`. Para acessá-los via MCP:

```
@architect get_full_document("templates/automation/pyproject_template.md")
@devbackend get_full_document("checklists/automation/idempotency_checklist.md")
@devsecops get_full_document("checklists/automation/secrets_checklist.md")
```

## Próximos passos

Após Gate 5 aprovado:

1. **Observabilidade**: adicionar métricas de execução (duration_ms, row_count) em um dashboard simples (Grafana Cloud free tier ou Datadog)
2. **Alertas**: configurar notificação em Slack/email quando exit_code != 0
3. **Reprocessamento**: documentar como re-rodar para uma data específica com `--date`
4. **Escalabilidade**: se o volume crescer, avaliar migração para arquétipo `data_pipeline` (receita `criar-pipeline-dados.md`)
5. **Versionamento de schema**: se o Excel mudar de formato, adicionar versão ao AppConfig e migração de schema Pydantic
