# Skill: sync-strategy-skill

## Purpose

Design the complete synchronization strategy for a data flow, producing `Sync_Strategy.md`. Defines the trigger mechanism, idempotency design, cursor pagination, conflict resolution, sync_log specification, error handling, and dead letter disposition.

## When to Use

Invoke when an integration requires automated, recurring data transfer between systems (cron job, webhook handler, event consumer). Invoke after `data-mapping-skill` and `idempotent-sync-design-skill` have been completed for the same integration.

## Inputs

| Input | Source | Required |
|-------|--------|----------|
| `data_mapping` | Output of `data-mapping-skill` | Yes |
| `idempotency_design` | Output of `idempotent-sync-design-skill` | Yes |
| `integration_spec` | `Integration_Spec.md` (topology, trigger type) | Yes |
| `latency_requirement` | Architecture.md | Yes |
| `estimated_volume` | Integration_Requirements.md | Yes |

## Outputs

| Output | Description |
|--------|-------------|
| `Sync_Strategy.md` | Complete sync job design document |
| Vercel Cron config | Entry for `vercel.json` crons array |
| sync_log field spec | `syncLog()` call specification |

## Constraints

- `guardCron()` must be specified as FIRST call in cron route handlers
- `syncLog()` must be specified in a `finally` block — not just success path
- External API calls must NOT be specified inside Prisma `$transaction()` blocks
- Cursor-based pagination required for all syncs with estimated volume > 1,000 records per run
- Cursor update must be specified AFTER successful DB commit — never before
- Batch size default: 100 records (adjust based on rate limits and payload size)
- Conflict resolution policy required for bidirectional syncs
- Dead letter mechanism required for all sync jobs

## Step-by-Step Execution

1. **Determine trigger type:** Use DR001/DR002 — webhook if available and latency requires it; polling if not.

2. **Define cron schedule:** Convert latency requirement to a cron expression. Near-real-time → `*/15 * * * *`; daily batch → `0 2 * * *`.

3. **Specify file paths:** Route file at `app/api/cron/[job-name]/route.ts`; job logic at `lib/jobs/[job-name].ts`.

4. **Specify idempotency:** Incorporate the idempotency design from `idempotent-sync-design-skill` output.

5. **Design pagination:** If volume > 1,000 records — specify cursor field, cursor storage, batch size, and loop condition.

6. **Design conflict resolution:** For bidirectional syncs — incorporate field ownership from `data-mapping-skill` output.

7. **Specify sync_log:** Define `syncLog()` call with all required fields. Explicitly state `finally` block placement.

8. **Design error handling:** Per-record error handling (isolate failures, continue), external API error handling (retry, circuit breaker), and dead letter disposition.

9. **Estimate performance:** Records/run, API calls/run, estimated duration, rate limit consumption.

10. **Run `sync_idempotency_checklist.md`:** Verify all items before marking output complete.

## Knowledge Access Policy

At runtime, this skill reads from:
- `Agente10_DataIntegrationEngineer/knowledge/` (principles P1, P5, P6, P10; heuristics H2, H3, H7, H8, H9, H11; decision rules DR001–DR003, DR006, DR007, DR013, DR015, DR017)
- `Agente10_DataIntegrationEngineer/templates/Sync_Strategy.md`
- `Agente10_DataIntegrationEngineer/checklists/sync_idempotency_checklist.md`
- `Agente10_DataIntegrationEngineer/examples/good_sync_strategy.md`
- Project input artifacts: Integration_Spec.md, Data_Mapping.md output

**Blocked at runtime:** `context/`, `lib/`, `*.pdf`, any other agent's folder.
