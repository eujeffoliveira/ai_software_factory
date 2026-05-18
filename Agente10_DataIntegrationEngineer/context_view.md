# Agente10_DataIntegrationEngineer — Context View

> **Build-time compiled context.** This file replaces `context/` at runtime. All content has been distilled from build-time reference materials. Do not access `context/` or `lib/` at runtime.

---

## 1. Integration Patterns Reference

### 1.1 Push vs Pull Topology

| Topology | Mechanism | When to Use | Latency |
|----------|-----------|-------------|---------|
| **Push (Webhook)** | External system sends events to your endpoint | Real-time requirements, provider supports webhooks, low volume | Near-real-time |
| **Pull (Polling)** | Your system queries external API on schedule | Provider has no webhook, high-volume batch, cost control | Minutes to hours |
| **Event-Driven** | Message queue / event bus mediates flow | Decoupling required, high throughput, fan-out consumers | Sub-second to seconds |
| **Hybrid** | Webhook triggers incremental sync, cron catches missed events | Reliability + real-time balance | Near-real-time with fallback |

**Decision rule:** Prefer webhooks when the provider supports them and volume is under 10k events/hour. Use polling for batch reconciliation and as webhook fallback. Use event queues when multiple consumers need the same event or when order guarantees matter.

### 1.2 ETL vs ELT Pattern

| Pattern | Transform Location | When to Use |
|---------|--------------------|-------------|
| **ETL** (Extract → Transform → Load) | Before loading into target | Target schema is rigid, transformations are complex, data cleansing required upstream |
| **ELT** (Extract → Load → Transform) | After loading raw into staging | Target is a data warehouse with compute (BigQuery, Snowflake), raw data preservation required |

In the Golden Model (Next.js + Prisma + PostgreSQL), ETL is the default pattern: extract from external API, transform in TypeScript job, load via Prisma upsert. ELT applies when a separate analytics layer exists.

### 1.3 Change Data Capture (CDC)

CDC captures database change events (insert/update/delete) at the log level rather than querying records. Useful when:
- Source system cannot expose a "last modified" timestamp
- Full-table polling is too expensive
- Near-real-time sync is required without webhook support

In the Golden Model, CDC is implemented via Supabase Realtime (PostgreSQL logical replication) or by polling a `updated_at` timestamp with cursor-based pagination.

---

## 2. Idempotency Strategies

### 2.1 Idempotency Key Pattern

Every sync operation receives or generates an idempotency key before execution. The key is stored in a processed-events table. Before executing, check if the key exists; if it does, skip and return the stored result.

```
idempotency_key = hash(external_id + event_type + event_timestamp)
if (processed_events.exists(idempotency_key)) return stored_result
execute_operation()
processed_events.insert(idempotency_key, result)
```

### 2.2 Upsert Pattern (Primary method in Golden Model)

Use `prisma.model.upsert({ where: { externalId }, create: {...}, update: {...} })` instead of insert. The `externalId` is the unique identifier from the external system. This is the primary idempotency mechanism for record sync.

**Rule:** Every sync job that creates records MUST use upsert, not create. Gate 3.5 blocks if any sync spec uses create without upsert.

### 2.3 Cursor-Based Pagination

For large datasets, never use offset-based pagination (breaks when records are inserted mid-sync). Use cursor-based pagination:

```
last_synced_at = sync_state.get(job_name)
records = external_api.list({ since: last_synced_at, limit: batch_size })
process(records)
sync_state.set(job_name, max(records.map(r => r.updated_at)))
```

The cursor is stored persistently. If the job fails mid-run, the next execution resumes from the last committed cursor.

### 2.4 At-Least-Once vs Exactly-Once

| Delivery | Guarantee | Implementation | Use When |
|----------|-----------|----------------|----------|
| **At-least-once** | Event delivered ≥1 times | Retry on failure, idempotent consumer | Default — easier to implement, safe when consumer is idempotent |
| **Exactly-once** | Event delivered exactly 1 time | Distributed transactions or idempotency keys | Required only when side effects (payments, emails) must not duplicate |

Default to at-least-once with idempotent consumers. Only require exactly-once when the business cost of duplication is high (financial transactions, notification emails).

---

## 3. Data Mapping Rules

### 3.1 Bidirectional Mapping Requirement

Every field mapping document must include both directions:
- **Source → Target:** What the external field means in our system
- **Target → Source:** What our internal field maps to when pushing back to the external system

Missing reverse mapping is a design gap — it becomes a bug when the integration needs to write back.

### 3.2 Transformation Types

| Type | Example | Rule |
|------|---------|------|
| **Direct** | `external.name` → `internal.name` | No transformation needed |
| **Type coercion** | `"2024-01-15"` (string) → `Date` | Always explicit, documented in mapping |
| **Computed** | `external.firstName + " " + external.lastName` → `internal.fullName` | Formula documented, reversibility noted |
| **Lookup** | `external.status_code` → `internal.status` via enum map | Enum map fully documented |
| **Dropped** | `external.internal_debug_field` | Explicitly documented as not synced |
| **Defaulted** | `external.optional_field ?? "default_value"` | Default value documented |

### 3.3 Field Ownership Table

For each field in a bidirectional sync, document ownership:

| Field | Owner System | Conflict Resolution |
|-------|-------------|---------------------|
| `email` | External CRM | External wins — CRM is source of truth |
| `internal_notes` | Our System | Internal wins — external cannot overwrite |
| `last_sync_at` | Our System | Computed field — never from external |

---

## 4. Sync Strategies

### 4.1 Sync Trigger Types

| Trigger | Implementation | Vercel Platform |
|---------|----------------|-----------------|
| **Scheduled (Cron)** | `app/api/cron/[job]/route.ts` with `guardCron()` | Vercel Cron (vercel.json schedule) |
| **Webhook** | `app/api/webhooks/[provider]/route.ts` | Vercel Function, signature verification required |
| **Manual** | Server Action triggered by user | On-demand, not automated |
| **Event-driven** | Message queue consumer | Requires queue infrastructure |

### 4.2 Cron Job Structure (Golden Model)

```typescript
// app/api/cron/[job-name]/route.ts
export async function GET(req: Request) {
  guardCron(req)               // MUST be first — validates Vercel secret
  const start = Date.now()
  const counts = { processed: 0, created: 0, updated: 0, errors: 0 }
  try {
    const result = await jobName.run()
    counts = result.counts
    await syncLog({ job: 'job-name', executedAt: new Date(), durationMs: Date.now() - start, status: 'success', counts })
    return NextResponse.json({ ok: true, counts })
  } catch (error) {
    await syncLog({ job: 'job-name', executedAt: new Date(), durationMs: Date.now() - start, status: 'error', counts, errorMsg: error.message })
    return NextResponse.json({ ok: false }, { status: 500 })
  }
}
```

### 4.3 Sync Log Schema

Every sync job must produce a `sync_log` entry with these fields:

| Field | Type | Description |
|-------|------|-------------|
| `job` | string | Job identifier (kebab-case) |
| `executedAt` | DateTime | UTC timestamp of execution start |
| `durationMs` | number | Wall-clock duration in milliseconds |
| `status` | enum | `success` \| `error` \| `partial` |
| `counts` | object | `{ processed, created, updated, skipped, errors }` |
| `errorMsg` | string? | Error message if status is error or partial |

---

## 5. LGPD Data Flow Requirements

### 5.1 LGPD Legal Bases (Art. 7, Lei 13.709/2018)

| Legal Basis | Code | When Valid |
|-------------|------|-----------|
| Consent | `CONSENT` | Data subject explicitly consented to this specific processing |
| Contract | `CONTRACT` | Processing necessary to fulfill a contract with the data subject |
| Legal obligation | `LEGAL_OBLIGATION` | Required by Brazilian law |
| Vital interests | `VITAL_INTERESTS` | Necessary to protect life |
| Public interest | `PUBLIC_INTEREST` | Research, statistics, public service |
| Legitimate interest | `LEGITIMATE_INTEREST` | Legitimate interest of controller, with proportionality test |

**Rule:** Every data flow involving personal data MUST document which legal basis applies. "Legitimate interest" requires a documented proportionality test. Missing legal basis → Gate 3.5 BLOCKED.

### 5.2 PII Classification Levels

| Level | Examples | Handling Requirements |
|-------|----------|----------------------|
| **SENSITIVE** | Health data, biometrics, ethnicity, religion, sexual orientation | Explicit consent only, no cross-system sync without DPA |
| **PERSONAL** | Name, email, CPF, phone, address | Legal basis required, retention limits apply |
| **PSEUDONYMIZED** | Hashed IDs, tokenized fields | Lower risk, but still requires legal basis if re-identifiable |
| **ANONYMOUS** | Aggregated statistics, non-identifiable | Not subject to LGPD |

### 5.3 Data Flow Documentation Requirements

For each personal data flow, document:
1. Fields involved and their PII classification level
2. Legal basis for the processing
3. Data retention period in each system
4. Cross-border transfer status (if applicable)
5. Data subject rights impact (how can data subjects exercise access/deletion rights?)
6. Data Processing Agreement (DPA) status with the external system

---

## 6. External API Client Patterns

### 6.1 Client Structure (Golden Model)

```typescript
// lib/integrations/[service].client.ts
import { env } from "@/lib/env"
import { z } from "zod"

const ServiceResponseSchema = z.object({ ... })

export const serviceClient = {
  async getResource(id: string) {
    const response = await fetch(`${env.SERVICE_BASE_URL}/resources/${id}`, {
      headers: { Authorization: `Bearer ${env.SERVICE_API_KEY}` },
      signal: AbortSignal.timeout(env.EXTERNAL_TIMEOUT_MS ?? 10000),
    })
    if (!response.ok) throw new Error(`Service API error: ${response.status}`)
    const raw = await response.json()
    return ServiceResponseSchema.parse(raw)   // Zod validation — required
  }
}
```

### 6.2 Resilience Patterns

| Pattern | Implementation | When Required |
|---------|----------------|---------------|
| **Timeout** | `AbortSignal.timeout(ms)` | Always — never unlimited |
| **Retry with backoff** | `fetchWithRetry(url, { retries: 3, backoff: 'exponential' })` | When API is known to have transient errors |
| **Circuit breaker** | Track consecutive failures, open circuit after threshold | When integration failure should stop traffic |
| **Rate limit handling** | Parse `X-RateLimit-*` headers, honor `Retry-After` | When API has documented rate limits |
| **Dead letter queue** | Move failed records to `integration_errors` table | When processing errors must not block the job |

### 6.3 Webhook Security Requirements

Every webhook endpoint must:
1. Verify the webhook signature using HMAC-SHA256 (or provider-specific method)
2. Reject requests with missing or invalid signatures with HTTP 401
3. Implement idempotency via the event ID in the payload header
4. Return HTTP 200 before processing (to avoid provider retry storms)
5. Process the event asynchronously or in a background job

---

## 7. Data Quality Framework

### 7.1 Quality Dimensions

| Dimension | What it Measures | Check Method |
|-----------|-----------------|--------------|
| **Completeness** | Required fields present | `z.string().min(1)`, null checks |
| **Accuracy** | Values are correct and valid | Format regex, enum validation |
| **Consistency** | Values consistent across systems | Cross-reference checks |
| **Timeliness** | Data is not stale | `updated_at` freshness check |
| **Uniqueness** | No duplicate records | Deduplication key check |
| **Validity** | Values conform to business rules | Domain-specific validators |

### 7.2 Record Disposition Policy

| Data Quality Result | Disposition | Action |
|--------------------|-------------|--------|
| All checks pass | **ACCEPT** | Proceed to upsert |
| Non-critical field invalid | **ACCEPT_WITH_FLAG** | Upsert with quality flag, alert |
| Critical field invalid | **QUARANTINE** | Move to `integration_quarantine` table, alert |
| Identity field missing | **REJECT** | Log and discard, do not insert |
| Duplicate detected | **SKIP** | Log deduplication event, skip |

---

## 8. Integration with Other Agents

### 8.1 Handoff from Agente02_SoftwareArchitect

Agente10 receives `Architecture.md` which defines the integration surface. Key items to extract:
- External system names and their roles
- Data flow directions
- Authentication mechanisms
- Estimated data volumes

### 8.2 Handoff to Agente03_SoftwareEngineer

`Integration_Spec.md` must be structured so Agente03 can extract atomic implementation tasks. Each integration section should correspond to one or more tasks with clear file paths and function signatures.

### 8.3 Handoff to Agente04_DevBackend

`Data_Mapping.md` and `Sync_Strategy.md` are consumed directly by Agente04 during implementation. Field names must match exactly the Prisma schema field names (camelCase) and the external API field names as documented.

### 8.4 Coordination with Agente07_DevSecOps

`Data_Risks.md` is shared with Agente07 for security review. LGPD risks flagged by Agente10 are validated by Agente07's security audit. Agente10 identifies the risk; Agente07 validates the remediation.

---

## 9. Anti-Patterns to Reject

| Anti-Pattern | Why Rejected | Correct Pattern |
|-------------|-------------|-----------------|
| `prisma.model.create()` in sync job | Not idempotent — duplicates on retry | `prisma.model.upsert()` with external ID |
| External API call inside `prisma.$transaction()` | Transaction held open, deadlock risk | Call external API before opening transaction |
| Hardcoded API key in client file | Secret exposure, not rotatable | `env.SERVICE_API_KEY` from `lib/env.ts` |
| `response.json() as SomeType` | Type assertion ≠ validation | `SomeSchema.parse(await response.json())` |
| Offset pagination (`?page=N`) | Breaks when records inserted mid-sync | Cursor pagination with `since=<timestamp>` |
| Sync job without `syncLog()` | Blind production job | `syncLog()` in `finally` block, always |
| PII in `console.log()` | LGPD violation, log exposure | Structured log with PII masked/excluded |
| Sync personal data without legal basis | LGPD Article 7 violation | Document legal basis or do not sync |
