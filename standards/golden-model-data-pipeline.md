# Golden Model — Data Pipeline (`data_pipeline`)

**Archetype:** `data_pipeline`
**Applies to:** ETL/ELT, transformação de dados, processamento batch em escala, analytics, ingestão de dados, jobs de dados com linhagem e qualidade.
**Default language:** Python 3.12+
**Status:** Initial version — expand as projects mature.

---

## Stack Obrigatória

| Camada | Tecnologia |
|--------|-----------|
| Linguagem | Python 3.12+ |
| Gerenciador | uv ou Poetry |
| Processamento tabular | Polars (preferido) ou Pandas |
| Banco analítico local | DuckDB |
| Banco operacional | PostgreSQL |
| Validação de schema | Pydantic v2 + Pandera (para DataFrames) |
| Orquestração simples | Typer CLI + cron / task scheduler |
| Orquestração avançada | Prefect ou Dagster (via ADR) |
| Logs | structlog (JSON) |
| Testes | pytest + pytest-dataframe |
| Lint/format | ruff |

---

## Regras Obrigatórias

1. **Checkpoints e idempotência** — Pipelines devem registrar progresso e retomar de onde pararam. Reprocessamento completo nunca deve duplicar dados.
2. **Validação de schema em cada etapa** — Validar schema de entrada antes de processar, validar schema de saída antes de gravar.
3. **Lineage simples documentada** — Documentar origem, transformações e destino de cada campo.
4. **Logs estruturados por partição/lote** — Incluir `run_id`, `batch_id`, `source`, `destination`, `row_count`, `status`.
5. **Qualidade de dados mensurável** — Definir thresholds de completude, unicidade e validade. Falhar explicitamente quando abaixo do threshold.
6. **Sem escrita direta sem validação** — Nunca gravar em destino sem validar schema e qualidade do lote.
7. **Documentação de origem/destino** — Todo campo mapeado deve ter origem e destino documentados.

---

## Antipadrões Críticos

- Pipeline sem checkpoint — falha no meio = reprocessar do zero
- Gravar no destino antes de validar qualidade
- Ausência de lineage — impossível rastrear origem de dado errado
- Pipeline não idempotente — reprocessamento duplica dados
- Usar Pandas para volumes > 1 GB sem justificativa (use Polars)
- Ausência de testes com dados de exemplo

---

## Artefatos Obrigatórios

- `Pipeline_Design.md` — arquitetura do pipeline, origem, destino, transformações
- `Data_Quality_Rules.md` — thresholds e validações
- `Lineage_Map.md` — mapeamento campo-a-campo
- `Runbook.md` — como executar, monitorar, reprocessar
- `Test_Plan.md` — dados de exemplo, cenários de erro, idempotência
