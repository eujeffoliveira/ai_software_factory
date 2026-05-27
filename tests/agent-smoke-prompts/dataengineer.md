# Smoke Test — @dataengineer

## Purpose

Verify the Data Integration Engineer correctly identifies the data_pipeline archetype, uses the Polars+DuckDB+Pandera stack, implements quality checks, and follows bronze/silver/gold patterns.

---

## Smoke Test 1 — Archetype Stack Selection

**Prompt:**
```
@dataengineer preciso criar um pipeline que ingere dados de 3 APIs externas, normaliza, valida e salva num data warehouse. Qual stack você recomenda?
```

**Expected behavior:**
- Polars for data manipulation (not pandas for production pipelines)
- DuckDB for analytical queries
- Pandera for data schema validation
- Bronze/silver/gold layers
- Idempotency: incremental load with deduplication
- structlog for pipeline logging
- tenacity for API retry

**Pass signals:** Polars + DuckDB + Pandera mentioned, bronze/silver/gold
**Fail signals:** pandas as primary recommendation, no schema validation, no idempotency

---

## Smoke Test 2 — Data Quality Checks

**Prompt:**
```
@dataengineer um pipeline carregou 10.000 registros mas 500 têm CPF inválido e 200 têm data_nascimento nula. Como você trata isso?
```

**Expected behavior:**
- Pandera schema with CPF validation rule
- Null handling policy: reject or quarantine
- Error report: invalid records logged separately
- Pipeline does NOT proceed if error rate > threshold
- Quarantine partition in silver layer for invalid records

**Pass signals:** Pandera validation, quarantine strategy, error threshold
**Fail signals:** Silently drops bad records, no validation schema

---

## Smoke Test 3 — Bronze/Silver/Gold Pattern

**Prompt:**
```
@dataengineer explique como você estruturaria um data lake em 3 camadas para um pipeline de vendas.
```

**Expected behavior:**
- Bronze: raw ingestion, immutable, timestamped, no transformation
- Silver: cleaned, typed, deduplicated, validated with Pandera
- Gold: business aggregates, optimized for queries (DuckDB), materialized views

**Pass signals:** All 3 layers described with correct characteristics
**Fail signals:** Only 1-2 layers, or layers described incorrectly

---

## Notes

The data_pipeline golden model is at `standards/golden-model-data-pipeline.md`. The agent should reference it via MCP search if asked about specific implementation details.
