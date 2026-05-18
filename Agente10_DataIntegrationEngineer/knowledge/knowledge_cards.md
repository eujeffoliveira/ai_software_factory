# Agente10_DataIntegrationEngineer — Knowledge Cards

> Reusable concept cards for integration design. Each card explains a key concept, its relevance, and how to apply it in the Golden Model context.

---

## Card 001 — Idempotency Key Pattern

**Concept:** An idempotency key is a unique token that represents a specific operation. Before executing the operation, check if the key has been processed before. If yes, return the stored result without re-executing. If no, execute and store the result keyed by the idempotency key.

**Why it matters:** At-least-once delivery guarantees mean any operation can execute multiple times. Without idempotency protection, retries create duplicates — duplicate payments, duplicate records, duplicate emails.

**In the Golden Model:**
```
// Prisma upsert (primary mechanism)
await prisma.contact.upsert({
  where: { externalId: crmContact.id },
  create: { externalId: crmContact.id, ...data },
  update: { ...data, updatedAt: new Date() }
})

// Idempotency key table (for operations with side effects)
const key = createHash('sha256').update(`${eventId}:${eventType}`).digest('hex')
const existing = await prisma.processedEvent.findUnique({ where: { key } })
if (existing) return existing.result
const result = await executeOperation()
await prisma.processedEvent.create({ data: { key, result, processedAt: new Date() } })
```

**Source:** Designing Data-Intensive Applications (Kleppmann) — Ch. 11; Enterprise Integration Patterns (Hohpe & Woolf) — Idempotent Receiver

---

## Card 002 — At-Least-Once vs Exactly-Once Delivery

**Concept:**
- **At-least-once:** The message system guarantees delivery, but may deliver duplicates. Consumer must handle duplicates.
- **Exactly-once:** The message system guarantees each message is delivered exactly once. Expensive to implement — requires distributed transactions or idempotency protocols at both producer and consumer.

**Why it matters:** "Exactly-once" is a marketing term in most distributed systems — achieving it requires significant infrastructure cost. At-least-once with idempotent consumers is the pragmatic standard for 95% of integrations.

**Decision rule:** Default to at-least-once with idempotent consumers (P1). Only require exactly-once when the business cost of duplication is provably catastrophic (e.g., payment charges). In that case, use the payment provider's native idempotency key system, not a home-built exactly-once mechanism.

**Source:** Building Event-Driven Microservices (Bellemare) — Ch. 3; Designing Data-Intensive Applications (Kleppmann) — Ch. 11

---

## Card 003 — ETL vs ELT

**Concept:**
- **ETL (Extract-Transform-Load):** Data is extracted from the source, transformed in a processing layer, then loaded into the target.
- **ELT (Extract-Load-Transform):** Data is extracted and loaded raw into the target, then transformed within the target using its native compute.

**When to use ETL:** Target schema is defined and rigid (Prisma PostgreSQL). Transformations are complex or require TypeScript logic. Data must be cleaned before persisting.

**When to use ELT:** Target is a columnar analytics warehouse (BigQuery, Snowflake) with native transformation compute (SQL, dbt). Raw data preservation is required for future use. Transformations may evolve independently of ingestion.

**In the Golden Model:** ETL is the default for the operational database. Cron jobs extract from external API, transform in TypeScript, load via Prisma upsert.

**Source:** Fundamentals of Data Engineering (Reis & Housley) — Ch. 8

---

## Card 004 — Change Data Capture (CDC)

**Concept:** CDC is a technique for capturing changes (insert, update, delete) at the database level by reading the database's write-ahead log (WAL), rather than polling for changed records.

**Why it matters:** Polling for "changed records" requires a `updated_at` timestamp and misses hard deletes. CDC captures every change event, including deletes, and delivers them in order with minimal database load.

**In the Golden Model:** CDC is available via Supabase Realtime (PostgreSQL logical replication). For external systems that expose a CDC-like API (Salesforce Streaming API, Stripe webhooks), treat the event stream as CDC. For systems without CDC, use cursor-based polling on `updated_at`.

**When to use:** Near-real-time sync requirements. Systems where records can be deleted (not soft-deleted) and deletions must propagate. High-volume data where polling is expensive.

**Source:** Designing Data-Intensive Applications (Kleppmann) — Ch. 11: Change Data Capture; Fundamentals of Data Engineering (Reis & Housley)

---

## Card 005 — Webhook Security: HMAC Signature Verification

**Concept:** Webhook providers send a signature in the request header, computed as `HMAC-SHA256(request_body, shared_secret)`. The receiver recomputes the signature and compares it to the header value. If they match, the request is authentic.

**Why it matters:** Without signature verification, any party on the internet can send fake webhook events to your endpoint. An unverified webhook processing a `payment.failed` event with `amount: 0` could bypass payment checks.

**In the Golden Model:**
```typescript
// lib/integrations/[service].webhook-verify.ts
const expectedSignature = createHmac('sha256', env.SERVICE_WEBHOOK_SECRET)
  .update(rawBody)
  .digest('hex')
const receivedSignature = request.headers.get('X-Webhook-Signature')
if (!timingSafeEqual(Buffer.from(expectedSignature), Buffer.from(receivedSignature))) {
  return new Response('Unauthorized', { status: 401 })
}
```

**Key rules:** Use `crypto.timingSafeEqual` — not string equality — to prevent timing attacks. Validate against the raw request body bytes, not parsed JSON. Reject events with missing or invalid signatures immediately.

**Source:** Building Event-Driven Microservices (Bellemare) — Ch. 4; Agente07_DevSecOps security requirements

---

## Card 006 — Cursor-Based Pagination

**Concept:** Instead of fetching records by page number (`?page=2`), cursor-based pagination fetches records "after" a specific cursor value — typically the `updated_at` timestamp or the `id` of the last seen record.

**Why it matters:** Offset pagination is broken in dynamic datasets. If 100 new records are inserted between fetching page 1 and page 2, page 2 shifts by 100 records, causing page 2 to return previously fetched records and skip others.

**In the Golden Model:**
```
// Sync state table
sync_cursors: { job_name, external_system, cursor_value, updated_at }

// Fetch pattern
const cursor = await getSyncCursor('contact-sync', 'crm-system')
const records = await crmClient.listContacts({ since: cursor, limit: 100 })
await processRecords(records)
await updateSyncCursor('contact-sync', 'crm-system', max(records.map(r => r.updatedAt)))
```

**Rule:** Update the cursor only after successful commit. If the job fails mid-run, the cursor stays at the last committed position — the next run resumes from there.

**Source:** Designing Data-Intensive Applications (Kleppmann) — Ch. 11; H3; DR006

---

## Card 007 — LGPD Legal Bases

**Concept:** Under LGPD (Lei 13.709/2018, Art. 7), personal data processing requires one of these legal bases:

| Code | Legal Basis | Typical Use |
|------|-------------|-------------|
| `CONSENT` | Explicit, specific, informed consent | Marketing, optional features |
| `CONTRACT` | Necessary for a contract with the data subject | User account, service delivery |
| `LEGAL_OBLIGATION` | Required by Brazilian law | Tax records, regulatory compliance |
| `VITAL_INTERESTS` | Protect life or physical safety | Emergency scenarios |
| `PUBLIC_INTEREST` | Public health, research, statistics | Analytics, research partnerships |
| `LEGITIMATE_INTEREST` | Legitimate interest (with proportionality test) | Fraud prevention, security |

**Why it matters:** Processing personal data without a documented legal basis is an LGPD violation subject to fines up to 2% of revenue (capped at R$50M per violation).

**Key rule for integrations:** `CONSENT` must be specific to the integration purpose. "We got consent to use the service" does not cover "we sync your data to our CRM partner." Separate consent per processing purpose.

**Sensitive data (Art. 11):** Requires explicit consent or specific legal obligation. No other basis applies.

**Source:** LGPD Lei 13.709/2018; P2; DR004; DR005

---

## Card 008 — Data Mesh: Domain Data Ownership

**Concept:** In a data mesh architecture, each domain team owns and operates its data as a product. Data pipelines are not centralized ETL infrastructure — they are owned by the domain that produces the data.

**Relevance for Agente10:** Even without a full data mesh implementation, the ownership principle applies to integration design: each integration spec must declare which system is the authoritative source for each data field. This prevents the "shared mutable state" problem where multiple systems claim to own the same field.

**Applied principle:** The Field Ownership Table in Data_Mapping.md is the integration-level application of data mesh domain ownership. It answers: for each field, who is the single source of truth?

**Source:** Data Mesh (Dehghani) — Ch. 4: Domain Data Ownership; P3

---

## Card 009 — API Versioning Strategies

**Concept:** External APIs evolve over time. Common versioning strategies:

| Strategy | Example | Stability |
|----------|---------|-----------|
| **URL versioning** | `/api/v2/contacts` | High — version is explicit |
| **Header versioning** | `Accept: application/vnd.api.v2+json` | Medium — easy to miss |
| **Query parameter** | `?version=2` | Low — often overridden |
| **No versioning** | Changes are "backward compatible" | Unreliable — depends on trust |

**In the Golden Model:** Prefer URL versioning. Pin the version in the client base URL (`${env.SERVICE_BASE_URL}/v2/`). When the provider releases a new version, require an ADR before updating.

**Forward compatibility rule (P7):** Integration must not break when the API adds new fields. Use Zod `.passthrough()` to allow unknown fields. Integration should break loudly (at startup or validation time) when the API removes required fields.

**Source:** P7; Fundamentals of Data Engineering (Reis & Housley); DR018

---

## Card 010 — Conflict Resolution Strategies

**Concept:** In bidirectional sync, both systems may update the same record simultaneously. Common resolution strategies:

| Strategy | How | Use When |
|----------|-----|----------|
| **External wins** | Always accept external system's value | External is authoritative master data (CRM, ERP) |
| **Internal wins** | Never overwrite with external value | Internal is computed or enriched field |
| **Last write wins** | Compare `updated_at`, most recent wins | Both systems can legitimately update the field |
| **Merge** | Field-by-field merge with specific rules | Complex entities with partial ownership per attribute |
| **Manual resolution** | Flag conflict for human review | Financial data, critical fields where automatic resolution is risky |

**Decision heuristic (H14):** Master data (names, codes, catalog) → External wins. Derived data (scores, flags, internal state) → Internal wins. State fields (status, lifecycle) → explicit policy required.

**Source:** Data Mesh (Dehghani); Enterprise Integration Patterns (Hohpe & Woolf); DR008

---

## Card 011 — Exponential Backoff with Jitter

**Concept:** When an external API call fails, retrying immediately often fails again (the error condition persists). Exponential backoff increases the wait time between retries exponentially. Jitter adds randomness to prevent synchronized retries ("thundering herd").

**Formula:** `delay = min(cap, base * 2^attempt) + random(0, jitter)`

| Attempt | Base | Cap | Jitter | Example Delay |
|---------|------|-----|--------|---------------|
| 1 | 1000ms | 30000ms | 500ms | 1000–1500ms |
| 2 | 1000ms | 30000ms | 500ms | 2000–2500ms |
| 3 | 1000ms | 30000ms | 500ms | 4000–4500ms |
| Max | — | 30000ms | 500ms | 30000–30500ms |

**In integration specs:** Specify `retry: { max_attempts: 3, base_delay_ms: 1000, max_delay_ms: 30000, jitter_ms: 500 }` for each external API client.

**Source:** Building Event-Driven Microservices (Bellemare) — Ch. 7; H7

---

## Card 012 — Dead Letter Channel Pattern

**Concept:** A dead letter channel receives messages that could not be processed successfully after exhausting retries. Instead of silently discarding failed messages, they are placed in a queue or table where they can be inspected, debugged, and replayed.

**In the Golden Model:**
```
Table: integration_quarantine {
  id              UUID PRIMARY KEY
  job_name        TEXT NOT NULL
  external_system TEXT NOT NULL
  external_id     TEXT
  raw_payload     JSONB
  error_message   TEXT
  failed_at       TIMESTAMPTZ
  retry_count     INT DEFAULT 0
  resolved_at     TIMESTAMPTZ
  resolution_note TEXT
}
```

**Alert rule:** When `COUNT(*) WHERE resolved_at IS NULL AND failed_at > now() - interval '1 hour' > threshold`, trigger an alert.

**Source:** Enterprise Integration Patterns (Hohpe & Woolf) — Dead Letter Channel; H9; DR017

---

## Card 013 — Circuit Breaker Pattern

**Concept:** A circuit breaker monitors external API calls. When failures exceed a threshold, the circuit "opens" and stops sending requests to the external system. After a cooldown period, it enters "half-open" state to test if the system has recovered.

**States:**
- **Closed (normal):** Requests pass through. Failures are counted.
- **Open (degraded):** Requests are rejected immediately (fail fast). No calls to external system.
- **Half-open (testing):** One request is allowed through. If it succeeds, circuit closes. If it fails, circuit reopens.

**Default configuration for Golden Model specs:**
```
circuit_breaker: {
  failure_threshold: 5,       // failures in window before opening
  window_seconds: 60,         // rolling window duration
  open_duration_seconds: 30,  // how long circuit stays open
  half_open_requests: 1       // test requests in half-open state
}
```

**Source:** Designing Data-Intensive Applications (Kleppmann) — Ch. 8; H8

---

## Card 014 — sync_log Schema

**Concept:** Every automated sync job must record its execution in `sync_log`. This is not optional — it is the observability contract between the integration and the operations team.

**Fields:**
```typescript
type SyncLogEntry = {
  job: string          // Kebab-case job identifier: "crm-contact-sync"
  executedAt: Date     // UTC timestamp when the job started
  durationMs: number   // Wall-clock execution time in milliseconds
  status: 'success' | 'error' | 'partial'
  counts: {
    processed: number  // Total records examined
    created: number    // Records inserted (new)
    updated: number    // Records modified (existing)
    skipped: number    // Records unchanged or deduped
    errors: number     // Records that failed processing
  }
  errorMsg?: string    // Error message if status is 'error' or 'partial'
}
```

**`status: 'partial'`:** Use when the job processed some records but encountered errors on others. `counts.errors > 0 AND counts.processed > counts.errors` → partial.

**Placement in spec:** Must specify `finally { syncLog(...) }` — not just in success or error branches. The log records execution even when the job fails catastrophically.

**Source:** P5; FM-05; Agente04_DevBackend P6; DR013

---

## Card 015 — PII Classification Framework

**Concept:** Not all personal data carries the same risk. Classification determines the legal requirements and technical protections required.

| Level | Definition | Examples | LGPD Basis Options |
|-------|-----------|---------|-------------------|
| **SENSITIVE** | Reveals origin, religion, politics, health, biometrics, sex life, criminal record | Health data, religious affiliation, CPF with health context | Explicit consent or legal obligation only |
| **PERSONAL** | Identifies a natural person directly or indirectly | Name, email, phone, CPF, CNPJ (individual), address, IP, location | All 6 LGPD bases |
| **PSEUDONYMIZED** | Cannot identify a person without additional data | Hashed user ID, tokenized credit card | Lower risk; still LGPD subject if re-identifiable |
| **ANONYMOUS** | Cannot identify a person even with additional data | Aggregated statistics, non-identifiable metadata | LGPD does not apply |

**Application:** Run PII classification on every field in Data_Mapping.md before producing Sync_Strategy.md. Classification drives legal basis requirements and technical controls (encryption, masking, retention).

**Source:** LGPD Art. 5 (Personal Data definition), Art. 11 (Sensitive Data); P2; DR004; DR005

---

## Card 016 — Data Quality Dimensions

**Concept:** Six standard dimensions for assessing incoming data quality, each measurable and actionable:

| Dimension | Question | Check |
|-----------|---------|-------|
| **Completeness** | Are required fields present? | `z.string().min(1)`, null checks |
| **Accuracy** | Are values correct format/domain? | Regex, enum validation, range checks |
| **Consistency** | Are values consistent across records? | Cross-record integrity checks |
| **Timeliness** | Is data fresh enough? | `updated_at` staleness threshold |
| **Uniqueness** | Are records deduplicated? | Deduplication key check |
| **Validity** | Do values satisfy business rules? | Domain-specific validators |

**Record disposition policy:**

| Result | Disposition | Action |
|--------|-------------|--------|
| All checks pass | ACCEPT | Upsert |
| Non-critical field invalid | ACCEPT_WITH_FLAG | Upsert with quality flag, alert |
| Critical field invalid | QUARANTINE | Move to `integration_quarantine`, alert |
| Identity field missing | REJECT | Log error, count in `counts.errors`, discard |
| Duplicate detected | SKIP | Count in `counts.skipped`, do not insert |

**Source:** Fundamentals of Data Engineering (Reis & Housley) — Ch. 8; Data Mesh (Dehghani) — Ch. 5; P8
