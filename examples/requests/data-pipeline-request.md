# Example Request — Data Pipeline

**Arquétipo:** `data_pipeline`
**Golden Model:** Data Pipeline (Python 3.12+ + Polars + DuckDB)

---

## Como usar com Claude Code

```
@techlead Precisamos construir um pipeline de dados para consolidar as vendas
de 3 sistemas legados (ERP, e-commerce e marketplace) em um data warehouse
PostgreSQL para análise de BI.

Volume: ~500k registros/dia por fonte. Execução: nightly às 02:00.

Classifique como data_pipeline e inicie o fluxo.
```

```
@dataengineer Projete o pipeline de consolidação de vendas.
Fontes: ERP (API REST), e-commerce (PostgreSQL), marketplace (CSV via SFTP).
Destino: PostgreSQL (schema analytics).
Requisitos: idempotência, qualidade de dados, lineage documentada, checkpoints.
```

```
@engineer Gere o plano de execução técnica do pipeline de vendas.
Stack: Python 3.12, Polars, DuckDB (staging), PostgreSQL (destino), structlog, pytest.
Decomponha em tarefas: extração por fonte, normalização, validação de qualidade, carga.
```

```
@qa Valide o pipeline de dados:
- Schema de cada fonte validado com Pandera
- Idempotência: reprocessar uma data não duplica registros
- Qualidade: thresholds de completude e unicidade definidos
- Testes com dados de amostra representativos
```
