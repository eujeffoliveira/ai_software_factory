# Sync Strategy: [Job Name]

> **Strategy ID:** SYNC-[SYSTEM]-[NNN]
> **Integration ID:** INT-[SYSTEM]-[NNN]
> **Job name:** [system]-[entity]-sync
> **Trigger:** Cron / Webhook / Event / Manual
> **Produced by:** Agente10_DataIntegrationEngineer
> **Version:** 1.0.0

---

## 1. Sync Overview

| Field | Value |
|-------|-------|
| Job name | `[system]-[entity]-sync` |
| External system | [system-name] |
| Internal model | [PrismaModelName] |
| Trigger type | Cron / Webhook |
| Sync direction | Inbound / Outbound / Bidirectional |
| Estimated volume | ~[N] records per run |
| Latency requirement | Real-time / Near-real-time / Batch |

**Purpose:** [1–2 sentences describing what this sync job does and why it is needed.]

---

## 2. Trigger Configuration

### 2.1 Cron Configuration

| Field | Value |
|-------|-------|
| Cron expression | `[0 2 * * *]` |
| Plain language | Every day at 02:00 UTC |
| Route file | `app/api/cron/[system]-[entity]-sync/route.ts` |
| Job logic file | `lib/jobs/[system]-[entity]-sync.ts` |
| Vercel Cron entry | `{ "path": "/api/cron/[system]-[entity]-sync", "schedule": "[expression]" }` |

**guardCron():** Must be the FIRST call in the route handler. Validates the `CRON_SECRET` Vercel header. If validation fails, return HTTP 401 immediately.

### 2.2 Webhook Configuration (if applicable)

| Field | Value |
|-------|-------|
| Endpoint | `app/api/webhooks/[system]/route.ts` |
| Event types handled | `[entity].created`, `[entity].updated`, `[entity].deleted` |
| Signature verification | HMAC-SHA256 with `env.[SYSTEM]_WEBHOOK_SECRET` |
| Response timing | Return HTTP 200 before processing (prevent provider timeout) |
| Processing | Async — enqueue event for background processing |

---

## 3. Idempotency Design

### 3.1 Strategy Selection

**Mechanism:** Upsert with external ID (primary mechanism for record sync)

**Rationale:** The external system provides a stable unique identifier (`id`) for each entity. Using this as the upsert key ensures that re-running the sync produces identical results. No additional idempotency table is needed for this use case.

### 3.2 Idempotency Key

| Field | Value |
|-------|-------|
| Key field name | `externalId` |
| Source | `external.id` (from API response) |
| Internal storage | Prisma field: `externalId String @unique` |
| Upsert clause | `{ where: { externalId: record.id } }` |

### 3.3 Upsert Pattern

```typescript
// Specification for Agente04_DevBackend — implement as Prisma upsert:
await prisma.[modelName].upsert({
  where: { externalId: externalRecord.id },
  create: {
    externalId: externalRecord.id,
    [field1]: transformedField1,
    [field2]: transformedField2,
    syncedAt: new Date(),
  },
  update: {
    [field1]: transformedField1,
    [field2]: transformedField2,
    syncedAt: new Date(),
  }
})
```

### 3.4 Event Idempotency (for webhook handler)

For webhook events, use event ID deduplication:

```typescript
// Specification:
const idempotencyKey = createHash('sha256')
  .update(`${eventId}:${eventType}`)
  .digest('hex')
const existing = await prisma.processedEvent.findUnique({ where: { key: idempotencyKey } })
if (existing) return { skipped: true }
// ... process event ...
await prisma.processedEvent.create({ data: { key: idempotencyKey, processedAt: new Date() } })
```

---

## 4. Cursor-Based Pagination

*(Skip this section if estimated volume < 1,000 records per run)*

### 4.1 Pagination Strategy

| Field | Value |
|-------|-------|
| Cursor field | `updated_at` (external) / `updatedAt` (internal) |
| Cursor storage | `sync_cursors` table: `{ jobName, externalSystem, cursorValue, updatedAt }` |
| Batch size | 100 records per API call |
| Direction | Forward only (ascending `updated_at`) |

### 4.2 Cursor Flow

```
1. Read cursor: GET sync_cursors WHERE jobName = '[job-name]' AND externalSystem = '[system]'
2. Fetch batch: GET /v[N]/[entities]?since=<cursor>&limit=100
3. Process batch: upsert each record
4. Commit cursor: UPDATE sync_cursors SET cursorValue = max(batch.updated_at) WHERE ...
5. If has_more: GOTO step 2 with new cursor
6. If no more: DONE
```

**Cursor update timing:** Update cursor ONLY after successful database commit of the batch. On failure, the cursor stays at the last successfully committed position — the next run resumes from there.

---

## 5. Conflict Resolution

*(Required for bidirectional sync — mark N/A if inbound only)*

| Field | Owner | Strategy | Detection |
|-------|-------|----------|-----------|
| `[field_1]` | EXTERNAL | EXTERNAL_WINS | `updated_at` comparison |
| `[field_2]` | INTERNAL | INTERNAL_WINS | — |
| `[field_3]` | COMPUTED | — | Recalculated each sync |

**Resolution algorithm:**
1. Compare `external.updated_at` with `internal.updatedAt`
2. For EXTERNAL_WINS fields: always use external value
3. For INTERNAL_WINS fields: keep internal value, ignore external
4. For LAST_WRITE_WINS fields: use the value from the most recently updated system

---

## 6. Sync Log

**MANDATORY: `syncLog()` must be called in the `finally` block of the cron route handler.**

```typescript
// Specification for the syncLog() call:
await syncLog({
  job: "[system]-[entity]-sync",
  executedAt: startTime,             // timestamp when the job started
  durationMs: Date.now() - start,    // wall-clock duration
  status: errorMsg ? "error" : counters.errors > 0 ? "partial" : "success",
  counts: {
    processed: counters.processed,   // total records fetched from external API
    created: counters.created,       // new records created (via upsert)
    updated: counters.updated,       // existing records updated (via upsert)
    skipped: counters.skipped,       // unchanged records (same data)
    errors: counters.errors          // records that failed processing
  },
  errorMsg: errorMsg ?? undefined    // error message when status is error or partial
})
```

**Status determination:**
- `"success"`: job completed, `counts.errors === 0`
- `"partial"`: job completed, `counts.errors > 0` but `counts.processed > counts.errors`
- `"error"`: job threw an unhandled exception

---

## 7. Error Handling

### 7.1 Per-Record Error Handling

```
For each record:
  1. Try: validate → transform → upsert
  2. On Zod validation failure: QUARANTINE record, counts.errors++, continue
  3. On Prisma error: log error with externalId, counts.errors++, continue
  4. On critical failure (all records failing): throw to exit job with error status
```

**Never terminate the entire job for a single record failure.** Isolate failures, count them, continue processing.

### 7.2 External API Error Handling

| Condition | Action |
|-----------|--------|
| HTTP 401 | Log CRITICAL, set status=error, syncLog, alert ops |
| HTTP 429 | Parse Retry-After header, wait, retry |
| HTTP 500–503 | Retry with exponential backoff (3 attempts) |
| Timeout | Retry once with same cursor position |
| Network error | Retry once, then fail with status=error |

### 7.3 Dead Letter

Records exhausting retries → `integration_quarantine` table:
```
{ id, job_name: '[job-name]', external_system: '[system]', external_id, raw_payload, error_message, failed_at, retry_count }
```
Alert when quarantine count > [N] within this run.

---

## 8. Performance Estimates

| Metric | Estimate |
|--------|----------|
| Records per run | ~[N] |
| API calls per run | ~[N] (at batch size 100) |
| Estimated duration | ~[N] seconds |
| Rate limit consumption | ~[N]% of [M] requests/hour limit |
| DB upsert operations | ~[N] |

---

*Produced by Agente10_DataIntegrationEngineer using templates/Sync_Strategy.md*
