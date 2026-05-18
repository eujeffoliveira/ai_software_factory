# Integration Specification: [External System Name]

> **Integration ID:** INT-[SYSTEM]-[NNN]
> **Version:** 1.0.0
> **Status:** Draft | In Review | Approved
> **Produced by:** Agente10_DataIntegrationEngineer
> **Gate 3.5 submission date:** YYYY-MM-DD
> **Consumes:** Architecture.md §[section], Integration_Requirements.md §[section]
> **Consumed by:** Agente03_SoftwareEngineer, Agente04_DevBackend

---

## 1. Integration Overview

### 1.1 Purpose

[Describe the business purpose of this integration in 2–4 sentences. What problem does it solve? What data flows and why?]

### 1.2 External System Profile

| Field | Value |
|-------|-------|
| System name | [system-name] |
| System type | ERP / CRM / Payment Gateway / External API / Other |
| Provider | [Organization or software product name — use generic placeholder in white-label edition] |
| API documentation | [URL or reference — use `[provider-docs-url]` placeholder] |
| API version | v[N] |
| Environment | Production / Sandbox / Both |
| SLA / Uptime | [documented SLA or "undocumented"] |
| Data direction | Inbound / Outbound / Bidirectional |

### 1.3 Integration Topology

| Field | Value |
|-------|-------|
| Primary topology | Webhook / Polling / Event-Driven / Hybrid / ETL Batch |
| Fallback topology | [if hybrid: e.g., "daily cron reconciliation"] |
| Trigger | [cron expression / webhook event / on-demand] |
| Latency requirement | Real-time (< 1min) / Near-real-time (< 15min) / Batch (hourly/daily) |

**Rationale for topology choice:** [Explain why this topology was selected based on the provider's capabilities and the latency requirement.]

---

## 2. Authentication and Security

### 2.1 Authentication Method

| Field | Value |
|-------|-------|
| Method | API Key / OAuth 2.0 Client Credentials / Bearer Token / HMAC |
| Credential env var | `env.[SYSTEM]_API_KEY` (from `lib/env.ts`) |
| Token refresh | Yes / No / Not applicable |
| Token TTL | [duration or "not applicable"] |

### 2.2 Webhook Security (if applicable)

| Field | Value |
|-------|-------|
| Signature algorithm | HMAC-SHA256 / Provider-specific |
| Signature header | `X-[Provider]-Signature` |
| Secret env var | `env.[SYSTEM]_WEBHOOK_SECRET` |
| Reject on invalid signature | HTTP 401 — mandatory |

### 2.3 Environment Variables Required

Add to `lib/env.ts`:
```typescript
[SYSTEM]_BASE_URL: z.string().url()
[SYSTEM]_API_KEY: z.string().min(1)
[SYSTEM]_WEBHOOK_SECRET: z.string().min(32)  // if webhook
```

---

## 3. Client File Specification

**File path:** `lib/integrations/[system-name].client.ts`

### 3.1 Public Methods

| Method | HTTP | Endpoint | Purpose |
|--------|------|----------|---------|
| `list[Entity]s(params)` | GET | `/v[N]/[entities]` | Fetch paginated list since cursor |
| `get[Entity](id)` | GET | `/v[N]/[entities]/{id}` | Fetch single entity by external ID |
| `[create/update][Entity](data)` | POST/PUT | `/v[N]/[entities]` | Write back to external system |

### 3.2 Client Configuration

```typescript
// Specify these values — Agente04_DevBackend implements the client
timeout_ms: 10_000             // AbortSignal.timeout(10_000)
max_retries: 3
backoff: "exponential_with_jitter"  // base: 1000ms, cap: 30000ms, jitter: 500ms
circuit_breaker: {
  failure_threshold: 5,
  window_seconds: 60,
  open_duration_seconds: 30
}
```

### 3.3 Zod Schema Requirements

**Response schemas must be defined at module level:**

```typescript
// [Entity] response schema — minimum required fields:
const [Entity]Schema = z.object({
  id: z.string().min(1),           // external ID — idempotency key
  [field_1]: z.[type](),
  [field_2]: z.[type](),
  updated_at: z.string().datetime(),
}).passthrough()                   // allow unknown fields — forward compatibility

// List response wrapper schema:
const [Entity]ListSchema = z.object({
  data: z.array([Entity]Schema),
  next_cursor: z.string().nullable(),
  has_more: z.boolean(),
}).passthrough()
```

---

## 4. Data Mapping

> Full field-by-field mapping documented in `Data_Mapping.md` (MAP-[SYSTEM]-001).

### 4.1 Key Field Mapping Summary

| External Field | Internal Field | Type | Transformation | PII |
|---------------|----------------|------|----------------|-----|
| `id` | `externalId` | string → String | DIRECT | NOT_PII |
| `[external_field]` | `[internalField]` | [ext_type] → [Prisma type] | [type] | [level] |
| `created_at` | `createdAt` | ISO8601 string → DateTime | TYPE_COERCION | NOT_PII |

### 4.2 Idempotency Key

| Field | Value |
|-------|-------|
| External ID field | `id` (from external API) |
| Internal field | `externalId` (Prisma `String @unique`) |
| Upsert clause | `{ where: { externalId: record.id }, create: {...}, update: {...} }` |

---

## 5. Sync Jobs

> Full sync strategy documented in `Sync_Strategy.md` (SYNC-[SYSTEM]-001).

### 5.1 Job Summary

| Job Name | Trigger | Schedule | Estimated Volume |
|----------|---------|----------|-----------------|
| `[system]-[entity]-sync` | Cron | `[cron_expression]` | ~[N] records/run |
| `[system]-webhook-handler` | Webhook | On event | Real-time |

### 5.2 Cron Route

**File:** `app/api/cron/[system]-[entity]-sync/route.ts`

```typescript
// Pattern specification for Agente04_DevBackend:
// 1. guardCron(req)                        — MUST be first call
// 2. start = Date.now()
// 3. counts = { processed: 0, created: 0, updated: 0, skipped: 0, errors: 0 }
// 4. try { result = await [jobName].run(); counts = result.counts }
// 5. catch { counts.errors++; errorMsg = error.message }
// 6. finally { syncLog({ job: '[system]-[entity]-sync', executedAt, durationMs, status, counts, errorMsg }) }
```

**Vercel Cron configuration (vercel.json):**
```json
{ "path": "/api/cron/[system]-[entity]-sync", "schedule": "[cron_expression]" }
```

### 5.3 Sync Log Fields

```typescript
syncLog({
  job: "[system]-[entity]-sync",
  executedAt: new Date(),
  durationMs: Date.now() - start,
  status: "success" | "error" | "partial",
  counts: {
    processed: number,   // total records fetched from external API
    created: number,     // new records upserted
    updated: number,     // existing records updated
    skipped: number,     // unchanged records
    errors: number       // records that failed processing
  },
  errorMsg: string | undefined
})
```

---

## 6. LGPD / Data Privacy

> Full LGPD assessment in `Data_Risks.md` (RISKS-[PROJ]-001).

### 6.1 Personal Data Inventory

| Field | PII Level | Legal Basis | Retention |
|-------|-----------|-------------|-----------|
| `email` | PERSONAL | CONTRACT | [N] years |
| `[field]` | [level] | [basis] | [period] |

### 6.2 Data Flow Privacy Controls

- [ ] Fields transmitted over TLS 1.2+
- [ ] PII fields excluded from `console.log()` and `sync_log.errorMsg`
- [ ] Data Processing Agreement (DPA) status: [signed / pending / not required]
- [ ] Data subject rights impact: [description of how deletion requests are handled]

---

## 7. Data Quality

> Full quality checklist in `Data_Quality_Checklist.md` (DQ-[SYSTEM]-001).

### 7.1 Critical Field Validation

| Field | Rule | Disposition on Failure |
|-------|------|----------------------|
| `id` | non-empty string | REJECT |
| `[field]` | [rule] | [disposition] |

### 7.2 Record Disposition Policy

| Result | Action |
|--------|--------|
| All critical validations pass | ACCEPT — proceed to upsert |
| Critical field invalid | QUARANTINE — `integration_quarantine` table |
| Duplicate detected | SKIP — count in `counts.skipped` |
| Non-critical field invalid | ACCEPT_WITH_FLAG — log quality issue |

---

## 8. Error Handling

### 8.1 External API Errors

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| 401 | Invalid credentials | Alert ops — credential rotation required |
| 429 | Rate limit exceeded | Honor `Retry-After` header, backoff |
| 500–503 | External service error | Retry with exponential backoff (3 attempts) |
| Other 4xx | Client error | Log, count in errors, continue to next record |

### 8.2 Dead Letter Policy

Records exhausting all retries → `integration_quarantine` table.
Alert when quarantine count > [N] within a single run.

---

## 9. Open Questions

| # | Question | Directed To | Blocking |
|---|----------|------------|---------|
| 1 | [Question text] | [Agent or role] | Yes / No |

---

## 10. Artifacts Produced

| Artifact | Status |
|----------|--------|
| `Integration_Spec.md` | Draft |
| `Data_Mapping.md` (MAP-[SYSTEM]-001) | Draft |
| `Sync_Strategy.md` (SYNC-[SYSTEM]-001) | Draft |
| `Data_Quality_Checklist.md` (DQ-[SYSTEM]-001) | Draft |
| `Data_Risks.md` (RISKS-[PROJ]-001) | Draft |
| `External_API_Assessment.md` (API-[SYSTEM]-001) | Draft |

---

*Produced by Agente10_DataIntegrationEngineer using templates/Integration_Spec.md*
