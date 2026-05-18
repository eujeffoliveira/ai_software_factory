# Skill: etl-planning-skill

## Purpose

Plan a full Extract-Transform-Load pipeline for bulk data migration or initial data load scenarios, including extraction strategy, transformation pipeline, load order, idempotency, rollback plan, and performance estimates.

## When to Use

Invoke when an integration requires one-time or periodic bulk data migration: initial data load from a legacy system, historical data import, or a full dataset refresh that processes the entire external dataset rather than incremental changes. Do NOT use for incremental sync — use `sync-strategy-skill` instead.

**Key distinction:** ETL is for bulk/migration scenarios. Sync Strategy is for ongoing incremental sync.

## Inputs

| Input | Source | Required |
|-------|--------|----------|
| `data_mapping` | Output of `data-mapping-skill` | Yes |
| `source_data_profile` | External API docs or data export spec | Yes |
| `target_model` | Prisma schema | Yes |
| `estimated_total_records` | Integration_Requirements.md | Yes |
| `rollback_required` | Architecture.md migration policy | Yes |

## Outputs

| Output | Description |
|--------|-------------|
| ETL plan section | Embedded in `Integration_Spec.md` |
| Extraction strategy | Batch size, API pagination, rate limit budget |
| Transformation pipeline | TypeScript transformation function signatures |
| Load order | Respects Prisma referential integrity (parents before children) |
| Rollback plan | How to undo the migration if it fails |
| Performance estimate | Duration and API call budget |

## Constraints

- ETL pattern is always appropriate for the Golden Model operational database (PostgreSQL/Prisma)
- ELT pattern is only appropriate for analytics warehouses — never for operational DB
- Idempotency is mandatory: ETL jobs must be re-runnable without data corruption
- Load order must respect foreign key constraints (parent records before child records)
- Rollback plan must exist before ETL execution begins
- Personal data in migration must have LGPD assessment before the ETL runs

## Step-by-Step Execution

1. **Profile the source dataset:** Estimate total record count, data format (JSON API, CSV, database export), pagination available, estimated extraction time.

2. **Define extraction strategy:** API pagination plan (cursor or offset), batch size, estimated API calls, rate limit budget, extraction job file path (`lib/jobs/[name]-etl.ts`).

3. **Define transformation pipeline:** For each entity, define TypeScript transformation function signatures. Document transformation rules (from Data_Mapping.md). Specify validation step (Zod).

4. **Define load order:** List entities in load order, respecting referential integrity. Parents (no foreign keys) load before children (have foreign keys to parents).

5. **Define idempotency for bulk load:** Use upsert with externalId. The ETL job must be re-runnable — if it fails halfway and is restarted, it resumes from where it left off without duplicating already-loaded records.

6. **Define progress tracking:** ETL jobs processing millions of records need progress checkpointing. Define how progress is tracked (cursor per entity, count of processed records).

7. **Define rollback plan:** Document how to undo the migration: soft delete flag, backup table, or truncate + re-run strategy.

8. **Estimate performance:** Total records / batch size × API call duration = estimated duration. Verify within Vercel function timeout limits (10 min max for Pro plan).

9. **Define monitoring:** sync_log entries per batch. Alert on failure. Progress log during run.

## Knowledge Access Policy

At runtime, this skill reads from:
- `Agente10_DataIntegrationEngineer/knowledge/` (principles P1, P5, P8; heuristics H11, H13; decision rules DR003, DR006, DR014)
- `Agente10_DataIntegrationEngineer/templates/Integration_Spec.md` (ETL section)
- Project input artifacts: Data_Mapping.md, Prisma schema, Integration_Requirements.md

**Blocked at runtime:** `context/`, `lib/`, `*.pdf`, any other agent's folder.
