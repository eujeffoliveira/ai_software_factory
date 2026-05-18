# Good Example: Integration Specification

> **Why this is correct:** This example demonstrates a complete, Gate 3.5-ready integration spec for a CRM contact sync. It satisfies all blocking criteria: idempotency strategy defined, LGPD legal basis documented, sync_log specified in `finally` block, Zod schema requirements stated, and no external call inside a Prisma transaction.

---

## Integration Specification: crm-platform

> **Integration ID:** INT-CRM-001
> **Version:** 1.0.0

### 1. Overview

The CRM contact sync pulls contact records from the organization's CRM platform into the internal `Contact` table. Contacts are the primary customer entity used for email notifications and account management. The sync runs nightly and uses cursor-based pagination for the full dataset, with a webhook handler for real-time updates.

### 2. Idempotency Strategy ✓

**Why correct:** Idempotency is explicitly designed before the sync spec. External ID field identified, upsert pattern specified.

```
Mechanism: upsert_external_id
Idempotency key field: externalId
Source field: crm_api_response.id
Prisma constraint: externalId String @unique

Upsert clause:
  where: { externalId: crmContact.id }
  create: { externalId: crmContact.id, email: crmContact.email, ... }
  update: { email: crmContact.email, ..., syncedAt: new Date() }
```

**Why this prevents duplicates:** If the cron job runs twice due to a Vercel retry, the second run calls `upsert` with the same `externalId`. The `update` block runs instead of `create`, producing no duplicate.

### 3. LGPD Assessment ✓

**Why correct:** Personal data identified, legal basis documented before any sync design.

| Field | PII Level | Legal Basis | Retention |
|-------|-----------|-------------|-----------|
| `email` | PERSONAL | CONTRACT | 5 years from contract end |
| `full_name` | PERSONAL | CONTRACT | 5 years from contract end |
| `phone` | PERSONAL | CONTRACT | 5 years from contract end |

Legal basis: `CONTRACT` — processing is necessary to perform the service contract with the data subject. The organization's DPO confirmed this basis on 2026-05-01.

DPA status: Signed with CRM platform provider.

### 4. Sync Log Specification ✓

**Why correct:** `syncLog()` is specified in a `finally` block with all required fields.

```typescript
// Specification for cron route — syncLog in finally block:
const start = Date.now()
let errorMsg: string | undefined
const counts = { processed: 0, created: 0, updated: 0, skipped: 0, errors: 0 }
try {
  const result = await crmContactSync.run()
  Object.assign(counts, result.counts)
} catch (error) {
  errorMsg = error instanceof Error ? error.message : "Unknown error"
  counts.errors++
} finally {
  await syncLog({
    job: "crm-contact-sync",
    executedAt: startTime,
    durationMs: Date.now() - start,
    status: errorMsg ? "error" : counts.errors > 0 ? "partial" : "success",
    counts,
    errorMsg
  })
}
```

**Why this is correct:** `syncLog()` is in `finally` — it runs whether the job succeeds or fails. This means operators always have a record of execution.

### 5. Zod Schema Requirements ✓

**Why correct:** Zod schema defined with minimum required fields and `.passthrough()`.

```typescript
export const CrmContactSchema = z.object({
  id: z.string().min(1),
  email: z.string().email(),
  full_name: z.string().min(1),
  phone: z.string().nullable().optional(),
  status: z.enum(["active", "inactive", "pending"]),
  updated_at: z.string().datetime(),
  created_at: z.string().datetime(),
}).passthrough()  // allow unknown fields — forward compatibility
```

**Why `.passthrough()` is correct:** The CRM API may add new fields in a minor version update. `.passthrough()` means our integration continues working when new fields appear. We do not use `.strict()` because the external API version is not pinned at the field level.

### 6. Client File Path ✓

**File:** `lib/integrations/crm-platform.client.ts`

External API calls are isolated to this file. Server Actions and cron job logic import `crmPlatformClient` — they never call `fetch()` directly. The client is never called inside a `prisma.$transaction()` block.

**Why correct:** Separation of concerns — external call isolation at `lib/integrations/`, not scattered through the codebase.

### 7. Error Handling ✓

```
On HTTP 429: Parse Retry-After header, wait, then retry (honor rate limit)
On HTTP 500–503: Retry with exponential backoff (3 attempts, base 1s, cap 30s, jitter 500ms)
On network error: Retry once, then fail with status=error and syncLog
On record validation failure: Quarantine record to integration_quarantine, continue to next record
On 3 consecutive job failures: Alert ops team
```

---

## What Makes This Example Correct

1. **Idempotency before sync:** The idempotency key is defined in step 2, before the sync schedule or batch config. Gate 3.5 blocks if this is missing.

2. **LGPD before mapping:** The personal data assessment is documented with specific legal basis and retention periods. The DPA status is stated.

3. **syncLog in finally:** The code spec explicitly shows `finally { syncLog(...) }`. This is the mandatory pattern — not just success/error branches.

4. **Zod with `.passthrough()`:** External schema uses `.passthrough()` for forward compatibility. Required fields are the minimum viable set.

5. **No literal credentials:** Auth spec uses `env.CRM_API_KEY` — never a literal value.

6. **Isolation boundary stated:** Client file path is `lib/integrations/crm-platform.client.ts` and the rule "never call inside transaction" is explicit.
