# Good Example: Sync Strategy

> **Why this is correct:** Complete sync strategy for a payment gateway reconciliation job. Idempotency, cursor pagination, sync_log in finally block, error handling, and dead letter disposition all specified.

---

## Sync Strategy: payment-reconciliation (CORRECT VERSION)

**Strategy ID:** SYNC-PAY-001
**Integration ID:** INT-PAY-001
**Job name:** `payment-reconciliation`
**Trigger:** Cron — every day at 01:00 UTC

---

### Trigger Configuration ✓

```
Route file:    app/api/cron/payment-reconciliation/route.ts
Job file:      lib/jobs/payment-reconciliation.ts
Cron:          0 1 * * *  (daily at 01:00 UTC)
Vercel config: { "path": "/api/cron/payment-reconciliation", "schedule": "0 1 * * *" }
guardCron():   FIRST call in route handler — validates CRON_SECRET header
```

**Why correct:** Route file and job file paths follow Golden Model. `guardCron()` explicitly specified as first call. Vercel Cron configuration provided so Agente03 can create the `vercel.json` task.

---

### Idempotency Design ✓

```
Mechanism:         upsert_external_id
Idempotency key:   externalTransactionId
Source:            payment_gateway_api.transaction_id
Prisma:            externalTransactionId String @unique on Payment model
Upsert clause:     { where: { externalTransactionId: txn.transaction_id } }
```

**Why correct:** Payment transactions are particularly dangerous if duplicated (double-counting revenue). The external `transaction_id` is the stable idempotency key. Any re-run of the job upserts — never creates duplicates.

**Idempotency test scenario (Agente06_QaEngineer validation requirement):**
Run the reconciliation job twice with the same batch of 10 transactions. After both runs, `COUNT(Payment WHERE externalTransactionId IN (...))` must equal 10, not 20.

---

### Cursor-Based Pagination ✓

**Why correct:** Payments accumulate over time. Volume can reach 5,000+ records per day. Cursor pagination prevents offset-skipping issues.

```
Cursor field:    settlement_date (external) / settledAt (internal)
Cursor storage:  sync_cursors table
               { jobName: "payment-reconciliation",
                 externalSystem: "payment-gateway",
                 cursorValue: "2026-05-16T00:00:00.000Z",
                 updatedAt: ... }
Batch size:      100 transactions per API call

Cursor flow:
  1. Read cursor:  SELECT cursorValue FROM sync_cursors WHERE jobName = 'payment-reconciliation'
  2. Fetch:        GET /v2/transactions?settled_after={cursor}&limit=100&sort=settlement_date:asc
  3. Upsert batch: prisma.payment.upsert() for each transaction
  4. Commit cursor: UPDATE sync_cursors SET cursorValue = max(batch.settlement_date) WHERE ...
  5. If has_more:  GOTO step 2
  6. If !has_more: DONE

Cursor update timing: Update ONLY after successful DB commit of the batch.
On failure: Cursor stays at last committed position. Next run resumes from there.
```

---

### Sync Log ✓

```typescript
// Specification — syncLog in finally block:
const start = Date.now()
let errorMsg: string | undefined
const counts = { processed: 0, created: 0, updated: 0, skipped: 0, errors: 0 }
try {
  const result = await paymentReconciliation.run()
  Object.assign(counts, result.counts)
} catch (error) {
  errorMsg = error instanceof Error ? error.message : "Job failure"
  counts.errors++
} finally {
  // syncLog in FINALLY — runs on success AND failure
  await syncLog({
    job: "payment-reconciliation",
    executedAt: startTime,
    durationMs: Date.now() - start,
    status: errorMsg ? "error" : counts.errors > 0 ? "partial" : "success",
    counts: {
      processed: counts.processed,    // transactions fetched from API
      created: counts.created,        // new payment records
      updated: counts.updated,        // existing payment records updated
      skipped: counts.skipped,        // unchanged payments
      errors: counts.errors           // failed records (quarantined or rejected)
    },
    errorMsg
  })
}
```

**Why correct:** `syncLog()` is in `finally` — it ALWAYS runs. If the payment gateway is down and the job fails after 3 retries, operators still see a `sync_log` entry with `status: "error"` and the error message.

---

### Error Handling ✓

```
Per-record failure:
  → Zod validation fails: QUARANTINE to integration_quarantine, counts.errors++, continue
  → Prisma upsert fails: Log error with externalTransactionId, counts.errors++, continue
  → Never abort entire job for single record failure

External API failures:
  → HTTP 401: STOP job immediately. Set status=error. syncLog. Alert ops team.
               (Credential issue — no point retrying)
  → HTTP 429: Parse Retry-After header. Wait. Retry. (Never fixed-interval retry)
  → HTTP 500-503: Retry 3 times with exponential backoff (1s, 2s, 4s + jitter).
                  After 3 failures: exit with status=error.
  → Timeout (10s): Retry once. Then exit with status=error.

Alert triggers:
  → 3 consecutive daily runs with status=error → page on-call
  → counts.errors > 50 in a single run → notify ops team
```

**Why correct:** Error handling is per-record for validation errors (one bad transaction doesn't stop 4,999 others from processing) and per-batch for external API failures (401 means stop immediately — retrying won't help). Alert thresholds defined.

---

### Dead Letter ✓

```
Records exhausting retries → integration_quarantine table:
{
  id:              UUID (auto)
  job_name:        "payment-reconciliation"
  external_system: "payment-gateway"
  external_id:     transaction_id from external API
  raw_payload:     JSONB of the original API response (NOTE: exclude PAN/card data — PCI scope)
  error_message:   validation or processing error description
  failed_at:       timestamp
  retry_count:     0 (manually replayed)
  resolved_at:     null until operator resolves
}

Alert: Notify ops when quarantine count > 5 within a single run
```

**Why this is correct:** Dead letters go to a queryable table, not just a log entry. Operators can inspect the raw payload, fix the issue, and replay. The PCI note is important — card data must not be stored in the quarantine table.
