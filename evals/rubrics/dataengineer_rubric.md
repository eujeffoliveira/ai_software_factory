# Rubric — Data Integration Engineer (@dataengineer / Agente10)

## Scoring Guide

0 = Absent or completely wrong — the dimension is not addressed or the answer is incorrect
1 = Partial — present but incomplete, missing key elements, or partially wrong
2 = Correct but missing nuance — technically accurate but lacks depth, specificity, or edge case handling
3 = Excellent — complete, accurate, contextually appropriate, and demonstrates mastery of the rule

---

## Dimensions

### 1. Pipeline Archetype Stack Selection
**Weight:** HIGH

**Score 3:** Correctly selects the data_pipeline archetype and its Golden Model stack: Polars (not pandas) for dataframe operations, DuckDB (not SQLite or PostgreSQL) for SQL-like file transformations, Pandera for schema validation, Parquet as the output format for analytical workloads, and pytest for tests. Justifies Polars over pandas by citing memory efficiency and performance for the given data volume. Does not use pandas for any transformation step.

**Score 2:** Polars and DuckDB selected. Pandera present. But one legacy component slips in (e.g., pandas for a single small operation, or SQLite instead of DuckDB for an intermediate step) without an explicit ADR justification.

**Score 1:** Polars mentioned but pandas also used without justification. Or DuckDB absent — SQL operations done in Python instead. Shows awareness of the modern stack but does not apply it consistently.

**Score 0:** pandas recommended as the primary transformation library for a large-volume pipeline. SQLAlchemy present. Polars/DuckDB absent. Wrong stack for the archetype.

---

### 2. Data Quality Checks with Pandera
**Weight:** HIGH

**Score 3:** Pandera schemas are defined for every major data model (raw input, transformed output). Schemas include: column presence checks, type validation, null checks for required fields, value range checks where domain knowledge is available, and referential integrity checks. Validation happens at the boundary between pipeline stages (after ingestion, before output write). Validation failures are captured in a data quality report — not silently ignored.

**Score 2:** Pandera schemas defined and applied. Null and type checks present. But value range checks and referential integrity checks absent. Or validation failures are logged but not reported in a structured output.

**Score 1:** Pandera mentioned and imported. Basic type checking present. But schema is incomplete (missing null checks, missing required fields). Or validation is only applied to a subset of the pipeline stages.

**Score 0:** No data validation. Or validation done via ad-hoc Python assertions (not Pandera). Or Pandera present but schemas are empty/placeholder.

---

### 3. Idempotency in Pipelines
**Weight:** HIGH

**Score 3:** Pipeline design ensures that running the same pipeline twice on the same input produces the same output without side effects (no duplicate records, no partial overwrites). Output writes use atomic patterns (write to temp file then rename, or partition-based overwrite). Process tracking or checkpointing ensures a failed run can resume without re-processing already completed stages.

**Score 2:** Idempotency addressed. Atomic write pattern used. But no resume/checkpoint mechanism — a failed run requires full restart.

**Score 1:** Idempotency mentioned as a concern. But implementation does not ensure it — e.g., appends to output file on each run (creating duplicates) without deduplication logic.

**Score 0:** Idempotency not mentioned. Output overwrites happen naively (e.g., INSERT without conflict handling). Running twice creates duplicate data.

---

### 4. Bronze/Silver/Gold Pattern
**Weight:** MEDIUM

**Score 3:** Pipeline stages are structured using the medallion architecture: Bronze (raw ingestion — data as-is from source, no transformation, append-only), Silver (validated and cleansed data — Pandera schema applied, business rules enforced, deduplication), Gold (aggregated or joined data optimized for reporting or downstream consumers). Each layer is stored separately. Lineage is traceable from gold back to bronze.

**Score 2:** Three stages present and named. Bronze is raw, silver is cleaned, gold is aggregated. But lineage is not explicitly maintained, or one stage boundary is blurred (e.g., transformation logic mixed into the bronze stage).

**Score 1:** Multi-stage pipeline present but not named as bronze/silver/gold. Or two stages (raw + processed) instead of three. Shows awareness of staged processing without applying the pattern explicitly.

**Score 0:** Single-stage pipeline (ingest and transform in one step). No separation between raw data and transformed data. Reprocessing requires re-ingesting from source.

---

### 5. Error Handling and Observability
**Weight:** MEDIUM

**Score 3:** Pipeline produces a structured run report: start time, end time, records ingested, records validated, records rejected (with reasons), records written. Failures at each stage are caught and do not crash the whole pipeline — partial failures are logged with specific row/field identification. Dead-letter storage for rejected records (not silent discard). structlog used for structured JSON logging.

**Score 2:** Run report produced. Failed records logged. But dead-letter storage absent (rejected records discarded or only counted). Or structlog not used — logging is print statements or standard Python logging without structure.

**Score 1:** Errors are caught and the pipeline does not crash on bad data. But no structured run report. Logging is print statements. No record of which records failed.

**Score 0:** Unhandled exceptions crash the pipeline on first bad record. Or errors are silently swallowed. No visibility into what happened during the run.

---

## Aggregate Score Interpretation

**Maximum score:** 15 (5 dimensions x 3)

| Total Score | Interpretation |
|-------------|----------------|
| 14–15 | Excellent — pipeline design is production-ready for large-scale data processing |
| 11–13 | Good — minor gaps; pipeline is sound but may need refinement for edge cases |
| 7–10 | Acceptable — notable gaps; at least one HIGH dimension needs revision before deployment |
| 4–6 | Poor — fundamental pipeline design issues; likely to fail at scale or produce incorrect data |
| 0–3 | Failing — pipeline is not fit for production; incorrect stack selection or no data quality |

**Critical failures (override the score):** A score of 0 on Idempotency means the pipeline creates duplicate data on re-run — this is a data correctness failure that corrupts downstream analytics. A score of 0 on Stack Selection (pandas for high-volume pipeline) means the pipeline will fail at scale due to memory exhaustion before it produces any data quality issues. Both should trigger re-evaluation regardless of aggregate.
