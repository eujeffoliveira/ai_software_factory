# Receita: Criar um Pipeline de Dados

## Objetivo

Criar um pipeline de ingestão, transformação e carga de dados usando o arquétipo `data_pipeline` da fábrica, com as camadas raw/bronze/silver/gold, validação de schema com Pandera, e estratégia de carga incremental. O resultado é um pipeline robusto, idempotente e com governança de qualidade de dados.

## Quando usar

- Ingestão de dados de múltiplas fontes heterogêneas (bancos, arquivos, APIs)
- Transformação e limpeza de dados para análise ou data warehouse
- Volume de dados que justifica Polars e DuckDB em vez de pandas em memória
- Pipeline que roda recorrentemente (diário, horário) com necessidade de reprocessamento

> Use `automation_script` se o processamento for simples (uma fonte, uma transformação, um output).
> Use `data_pipeline` quando há múltiplas fontes, múltiplas camadas de transformação,
> ou necessidade de validação de schema e linhagem de dados.

## Agentes envolvidos

| Agente | Papel nesta receita |
|--------|---------------------|
| `@techlead` | Classificação Gate A0, aprovação de gates |
| `@dataengineer` | Design do pipeline: camadas, estratégia incremental, governança, runbook |
| `@architect` | Contratos de integração: schemas de entrada por fonte, schema de saída |
| `@devbackend` | Implementação: ingestão paralela, transformações Polars, carga incremental |
| `@qa` | Validação: idempotência, Pandera detecta dados inválidos, cobertura pytest |
| `@devsecops` | (opcional) Revisão de secrets de conexão, PII nos dados, acesso ao data warehouse |

## Fluxo de execução

### Etapa 1 — Classificação do arquétipo (Gate A0)

```
@techlead Classifique o arquétipo: pipeline de dados de vendas que ingere
de 3 fontes (PostgreSQL de produção, bucket S3 com arquivos Parquet, REST API
de um ERP externo), transforma e carrega incrementalmente em BigQuery.
Roda diariamente às 2h via cron. Volume esperado: ~500k linhas/dia.
```

Resultado esperado: `A0_APPROVED` com arquétipo `data_pipeline` e referência
ao Golden Model `standards/golden-model-data-pipeline.md`.

---

### Etapa 2 — Design do pipeline (Gate 2)

```
@dataengineer Projete o pipeline de dados de vendas seguindo o Golden Model
data_pipeline (Polars + DuckDB + Pandera):

1. Arquitetura em camadas:
   - raw/bronze: ingestão sem transformação (preservar dados originais)
   - silver: limpeza, normalização, joins entre fontes
   - gold: agregações para consumo analítico (tabelas de fato e dimensão)

2. Estratégia de carga:
   - PostgreSQL: incremental por updated_at (watermark)
   - S3/Parquet: incremental por data de modificação do arquivo
   - API ERP: paginação + incremental por data de última sincronização

3. Validação com Pandera:
   - Schema por camada (bronze, silver, gold) com tipos e constraints
   - Comportamento em caso de dados inválidos: quarentena (não falhar o pipeline todo)

4. Idempotência: reprocessar o mesmo dia não duplica dados no BigQuery

5. Logging de qualidade:
   - Linhas ingeridas, linhas rejeitadas (com motivo), linhas carregadas
   - Alertas se taxa de rejeição > 5%

6. Rollback: como desfazer uma carga com erro? (DELETE WHERE date = ? no BigQuery)
```

---

### Etapa 3 — Contratos de integração (paralelo ao Gate 2)

```
@architect Defina os contratos de integração para o pipeline de vendas:

Para cada fonte de dados, especifique:

Fonte 1 — PostgreSQL (tabela orders):
- Schema de entrada: colunas esperadas, tipos, constraints (nullable?)
- Chave de watermark: orders.updated_at
- Tratamento de nulos: order.discount pode ser null → substituir por 0
- Dados PII: customer_email → hash SHA-256 na camada silver (nunca na gold)

Fonte 2 — S3 (arquivos Parquet de itens de pedido):
- Schema do Parquet: o que é garantido vs. o que é "best effort"
- Tratamento de arquivos corrompidos: logar e pular (não falhar o pipeline)
- Deduplicação: arquivos podem ter registros duplicados → deduplica por order_item_id

Fonte 3 — API ERP (dados de clientes):
- Endpoint de paginação e autenticação (OAuth2 client credentials)
- Schema de resposta: mapear campos da API para o schema interno
- Rate limiting: máximo 100 req/min → implementar throttle

Schema de saída (BigQuery gold layer):
- fact_sales: grain = 1 linha por item de pedido
- dim_customer: grain = 1 linha por cliente
- dim_product: grain = 1 linha por produto
```

---

### Etapa 4 — Planejamento (Gate 3)

```
@engineer Decomponha o pipeline de vendas em tasks implementáveis:

TASK-001: Setup do projeto (uv, pyproject.toml, estrutura de diretórios)
TASK-002: Schemas Pydantic v2 para config (conexões, credenciais via BaseSettings)
TASK-003: Schemas Pandera para cada camada (bronze, silver, gold)
TASK-004: Conector PostgreSQL (incremental por watermark, salvar em Parquet local)
TASK-005: Leitor S3/Parquet (list objects por data, deduplicação)
TASK-006: Cliente API ERP (OAuth2, paginação, throttle, tenacity para retries)
TASK-007: Transformações silver (Polars: joins, normalização, hash de PII)
TASK-008: Agregações gold (Polars + DuckDB: fatos e dimensões)
TASK-009: Carregador BigQuery (incremental com merge, não append simples)
TASK-010: Orquestrador principal (execução paralela das fontes, watermarks)
TASK-011: Logging de qualidade e alertas (taxa de rejeição, SLA de latência)
TASK-012: Testes pytest (unitários para transformações, integração com mocks)
TASK-013: Runbook operacional (como reprocessar, como fazer rollback)

Identifique dependências entre tasks e estime story points.
```

---

### Etapa 5 — Implementação (desenvolvimento)

```
@devbackend Implemente o pipeline de dados de vendas seguindo o design aprovado:

Estrutura do projeto (uv):
  src/sales_pipeline/
    __init__.py
    config.py          # Conexões e credenciais via Pydantic BaseSettings
    schemas/
      bronze.py        # Pandera schemas para dados brutos
      silver.py        # Pandera schemas para dados limpos
      gold.py          # Pandera schemas para dados analíticos
    connectors/
      postgres.py      # Conector incremental por watermark
      s3_parquet.py    # Leitor S3 com deduplicação
      erp_api.py       # Cliente OAuth2 com throttle e retry
    transforms/
      silver.py        # Transformações Polars (joins, normalizações)
      gold.py          # Agregações com DuckDB
    loaders/
      bigquery.py      # Carga incremental com merge
    quality.py         # Logging de qualidade de dados e alertas
    pipeline.py        # Orquestrador: executa fontes em paralelo

Requisitos obrigatórios:
- Ingestão das 3 fontes em paralelo (concurrent.futures ou asyncio)
- Validação Pandera após cada camada — dados inválidos → quarentena (arquivo
  separado), pipeline continua
- Idempotência: watermarks persistidos em arquivo JSON local
- --dry-run: simula todo o fluxo sem carregar no BigQuery
- --reprocess-date YYYY-MM-DD: reprocessa um dia específico
- Logging estruturado: linhas_ingeridas, linhas_rejeitadas, linhas_carregadas
  por fonte e por camada
```

```
@devbackend Implemente a lógica de merge incremental no BigQuery:

O merge deve ser atômico: usar transação BigQuery (merge INTO ... USING ...
ON ... WHEN MATCHED THEN UPDATE WHEN NOT MATCHED THEN INSERT).

Não usar INSERT INTO ... SELECT ... — causa duplicatas se o pipeline falhar
no meio. O merge é idempotente por design.

Para a tabela fact_sales: chave de merge = (order_id, order_item_id, source_date)
Para dim_customer: chave = customer_id (SCD Type 1 — overwrite)
```

---

### Etapa 6 — Validação de qualidade (Gate 4)

```
@qa Valide o pipeline de dados de vendas:

Testes unitários (pytest):
1. transforms/silver.py: normalização de preço nulo → 0.0
2. transforms/silver.py: hash de customer_email é consistente (mesma entrada = mesmo hash)
3. transforms/gold.py: agregação total_revenue por order_id está correta
4. quality.py: taxa de rejeição > 5% → alerta é disparado (log WARNING)
5. loaders/bigquery.py: merge com rows iguais (rodar 2x) → nenhuma duplicata

Testes de integração (pytest + mocks):
6. Fluxo completo com PostgreSQL mockado + S3 mockado + ERP mockado
   → BigQuery mock recebe o schema correto sem duplicatas
7. Fonte com dados inválidos (violação de Pandera) → pipeline continua,
   arquivo de quarentena criado, métrica de rejeição incrementada
8. API ERP retorna 429 (rate limit) → tenacity faz retry após backoff

Validação de idempotência:
9. Rodar o pipeline 2 vezes para a mesma data → BigQuery tem o mesmo número
   de linhas (não duplicou)
10. --dry-run → nenhuma escrita no BigQuery, nenhum arquivo de quarentena criado

Cobertura mínima: 80% das linhas de src/
```

---

### Etapa 7 — Governança de dados

```
@dataengineer Implemente as regras de governança do pipeline:

1. Linhagem de dados: para cada tabela gold, registrar:
   - Fontes de origem (PostgreSQL/S3/API)
   - Transformações aplicadas (versão do código, timestamp)
   - Watermarks usados nesta execução

2. SLA de latência: alertar se o pipeline levar mais de 2 horas para completar

3. Qualidade de dados: criar tabela pipeline_quality_log no BigQuery com:
   - execution_date, source, rows_ingested, rows_rejected, rejection_reason_summary,
     duration_seconds, status (success/partial/failed)

4. Rollback documentado no Runbook:
   - Como identificar uma carga incorreta (via pipeline_quality_log)
   - Como reverter: DELETE FROM fact_sales WHERE source_date = DATE '2026-05-22'
   - Como reprocessar após rollback: price-pipeline run --reprocess-date 2026-05-22

5. Retenção: dados raw/bronze em S3 (30 dias), silver local (7 dias),
   gold no BigQuery (particionado por date, retenção 2 anos via partition expiry)
```

## Artefatos esperados

- `Architecture.md` — design do pipeline, camadas, estratégia incremental
- `Integration_Plan.md` — contratos por fonte, schemas de entrada e saída
- `Execution_Plan.md` — backlog de tasks com estimativas
- `src/sales_pipeline/` — código-fonte completo com todos os módulos
- `tests/` — testes pytest unitários e de integração com cobertura ≥ 80%
- Schemas Pandera (bronze, silver, gold)
- `Runbook.md` — como executar, reprocessar, fazer rollback, diagnosticar falhas
- `Security_Audit.md` — se `@devsecops` for envolvido (PII, credenciais de banco)

## Gates envolvidos

| Gate | Responsável | Critério de aprovação |
|------|-------------|----------------------|
| A0 | `@techlead` | Arquétipo classificado como `data_pipeline` |
| 2 | `@techlead` + `@architect` | Design aprovado; contratos de integração definidos |
| 3 | `@techlead` + `@engineer` | Execution Plan aprovado |
| 4 | `@qa` | pytest passa; cobertura ≥ 80%; idempotência verificada |
| 5 | `@devsecops` | PII tratado; secrets em env vars; conexões de banco sem credenciais root |

## Comandos de validação

```powershell
# Saúde da fábrica
.\doctor.ps1

# Verificar MCP Knowledge Search
.\test-mcp.ps1
```

```bash
# Setup do ambiente
uv sync

# Executar testes com cobertura
uv run pytest --cov=src/sales_pipeline --cov-report=term-missing --cov-fail-under=80

# Testar dry-run completo (sem tocar no BigQuery)
uv run sales-pipeline run --dry-run --date 2026-05-22

# Testar reprocessamento de data específica
uv run sales-pipeline run --reprocess-date 2026-05-21

# Verificar dependências vulneráveis
uv audit

# Validar schemas Pandera manualmente
uv run python -c "from sales_pipeline.schemas.bronze import BronzeSalesSchema; print('OK')"
```

```powershell
# Verificar que agente tem knowledge sobre data_pipeline
# (em sessão Claude Code):
# @dataengineer search_knowledge("data_pipeline Golden Model")
# @dataengineer search_knowledge("Polars DuckDB Pandera")
# @qa search_knowledge("pytest idempotência pipeline")
```

## Próximos passos

Após Gate 5 aprovado:

1. **Orquestrador**: para pipelines com dependências complexas entre tasks, avaliar Prefect ou Airflow (adiciona complexidade — justificar com volume e dependências reais)
2. **Testes de dados**: além de pytest, considerar Great Expectations para validação de dados em produção (complementa o Pandera que valida em dev/test)
3. **Monitoramento de drift**: se o schema da fonte mudar sem aviso (common em APIs externas), o Pandera vai quarentenar dados — configurar alerta para quando a taxa de quarentena subir
4. **Escala**: se o volume crescer para dezenas de milhões de linhas, avaliar Spark via PySpark ou migrar para dbt + warehouse nativo
5. **Documentação de dados**: adicionar descrições de campos e linhagem no catálogo de dados da organização (se houver DataHub, Amundsen ou similar)
