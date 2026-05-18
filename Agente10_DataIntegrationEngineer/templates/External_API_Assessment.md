# External API Assessment: [External System Name]

> **Assessment ID:** API-[SYSTEM]-[NNN]
> **Integration ID:** INT-[SYSTEM]-[NNN]
> **External system:** [system-name]
> **Assessment date:** YYYY-MM-DD
> **Produced by:** Agente10_DataIntegrationEngineer
> **Version:** 1.0.0

---

## 1. API Profile

| Field | Value |
|-------|-------|
| Provider | [Organization name — use generic placeholder in white-label edition] |
| API type | REST / GraphQL / SOAP / gRPC |
| API version targeted | v[N] |
| Base URL env var | `env.[SYSTEM]_BASE_URL` |
| Documentation quality | EXCELLENT / GOOD / PARTIAL / POOR / NONE |
| Versioning strategy | URL versioning (`/v2/`) / Header versioning / None |
| Changelog available | Yes / No |
| Status page | Yes: [url] / No |
| Forward compatibility risk | LOW / MEDIUM / HIGH |

---

## 2. Authentication Assessment

| Field | Value |
|-------|-------|
| Authentication method | API Key / OAuth 2.0 Client Credentials / Bearer Token / HMAC |
| Security rating | HIGH / MEDIUM / LOW |
| Token expiration | [duration] / Never |
| Refresh mechanism | Automatic / Manual / Not applicable |

**Required environment variables (add to `lib/env.ts`):**

```typescript
[SYSTEM]_BASE_URL: z.string().url(),
[SYSTEM]_API_KEY: z.string().min(1),
[SYSTEM]_API_VERSION: z.string().default("v2"),
```

**Security assessment notes:**
[Describe the security quality of the auth method. API keys are less secure than OAuth. If the API supports only API keys, note the risk and recommend rotation policy.]

---

## 3. Rate Limits

| Limit Type | Value | Source |
|-----------|-------|--------|
| Requests per minute | [N] | API documentation |
| Requests per hour | [N] | API documentation |
| Requests per day | [N] | API documentation |
| Burst limit | [N] | API documentation / untested |
| Rate limit headers | `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset` | Response headers |
| `Retry-After` header | Returned on HTTP 429 | API documentation |

**Sync consumption analysis:**

| Sync Job | Calls/Run | Calls/Day (at schedule) | % of Daily Limit |
|----------|-----------|------------------------|------------------|
| `[system]-[entity]-sync` (batch sync) | ~[N] | ~[N] | ~[N]% |
| `[system]-webhook` (real-time) | ~[N] | ~[N] | ~[N]% |
| **Total** | — | ~[N] | **~[N]%** |

**Conclusion:** [Within limits / Approaching limits / Exceeds limits — with recommendation]

---

## 4. Reliability Profile

| Metric | Value |
|--------|-------|
| Documented SLA | [N]% uptime / Undocumented |
| Known downtime windows | None documented / [description] |
| Typical latency | p50: [N]ms, p99: [N]ms / Unknown |
| Supports webhooks | Yes / No |
| Webhook delivery guarantee | At-least-once / Best-effort / Unknown |
| Webhook retry policy | [N] retries over [N] hours / Unknown |
| Historical incidents | [Describe known issues or "no public information"] |

---

## 5. Client Specification

**File path:** `lib/integrations/[system-name].client.ts`

### 5.1 Client Configuration

```typescript
// Configuration spec for Agente04_DevBackend:
const CLIENT_CONFIG = {
  baseUrl: env.[SYSTEM]_BASE_URL,
  apiKey: env.[SYSTEM]_API_KEY,
  timeout: 10_000,           // AbortSignal.timeout(10_000)
  version: "v2"              // pinned API version
}
```

### 5.2 Public Interface

| Method | HTTP | Endpoint | Parameters | Returns | Notes |
|--------|------|----------|-----------|---------|-------|
| `list[Entity]s(cursor, limit)` | GET | `/v[N]/[entities]` | `since: string, limit: number` | `[Entity]ListResponse` | Cursor pagination |
| `get[Entity](id)` | GET | `/v[N]/[entities]/{id}` | `id: string` | `[Entity]Response` | Single record fetch |
| `create[Entity](data)` | POST | `/v[N]/[entities]` | `[Entity]CreateInput` | `[Entity]Response` | Outbound only |
| `update[Entity](id, data)` | PUT/PATCH | `/v[N]/[entities]/{id}` | `id: string, [Entity]UpdateInput` | `[Entity]Response` | Outbound only |

### 5.3 Never Call Inside Prisma Transaction

External API methods must never be called inside a `prisma.$transaction()` block. Always:
1. Call external API (outside any transaction)
2. Validate response with Zod
3. Open transaction → persist data → close transaction

---

## 6. Zod Schema Requirements

### 6.1 [Entity] Schema

```typescript
// lib/integrations/[system-name].schemas.ts

export const [Entity]Schema = z.object({
  id: z.string().min(1),                          // external ID — required
  [field_1]: z.[type](),                          // [description]
  [field_2]: z.string().datetime(),               // ISO8601 datetime
  [optional_field]: z.[type]().nullable().optional(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
}).passthrough()    // allow unknown fields — forward compatibility

export type [Entity] = z.infer<typeof [Entity]Schema>
```

### 6.2 List Response Schema

```typescript
export const [Entity]ListSchema = z.object({
  data: z.array([Entity]Schema),
  next_cursor: z.string().nullable(),    // null when no more pages
  has_more: z.boolean(),
  total_count: z.number().optional(),    // may not be present
}).passthrough()
```

### 6.3 Schema Notes

- Use `.passthrough()` by default — do not reject records with unknown fields
- Minimum required fields listed above are the contract minimum — the schema will not break if the API adds new optional fields
- If the API removes a required field, the schema will throw a validation error — this is the desired behavior (fail fast, log always — P10)

---

## 7. Resilience Patterns Recommended

Based on this API assessment, the following resilience patterns are recommended:

### 7.1 Retry Configuration

```typescript
// Specification:
retry: {
  max_attempts: 3,
  backoff: "exponential_with_jitter",
  base_delay_ms: 1_000,
  max_delay_ms: 30_000,
  jitter_ms: 500,
  retry_on: [408, 429, 500, 502, 503, 504]  // HTTP statuses that trigger retry
}
```

### 7.2 Circuit Breaker

```typescript
// Specification:
circuit_breaker: {
  enabled: true,
  failure_threshold: 5,         // open circuit after 5 failures
  window_seconds: 60,           // within a 60-second window
  open_duration_seconds: 30,    // stay open for 30 seconds
  half_open_requests: 1         // test with 1 request before closing
}
```

### 7.3 Dead Letter

Failed records → `integration_quarantine` table after exhausting retries.

### 7.4 Rate Limit Monitoring

Parse `X-RateLimit-Remaining` header. If remaining < 10% of limit, log warning and slow down batch processing.

---

## 8. Webhook Configuration (if applicable)

| Field | Value |
|-------|-------|
| Endpoint | `app/api/webhooks/[system]/route.ts` |
| Supported event types | `[entity].created`, `[entity].updated`, `[entity].deleted` |
| Signature algorithm | HMAC-SHA256 |
| Signature header | `X-[System]-Signature` |
| Signature secret env var | `env.[SYSTEM]_WEBHOOK_SECRET` |
| Timestamp header | `X-[System]-Timestamp` (for replay protection) |
| Replay window | Reject events older than 5 minutes |

**Security requirements:**
1. Verify signature using `crypto.timingSafeEqual()` — not string equality
2. Reject events with missing or invalid signature (HTTP 401)
3. Return HTTP 200 before processing (to prevent provider retry storms)
4. Check timestamp header — reject events older than 5 minutes
5. Deduplicate using event ID (idempotency key from header)

---

## 9. Out-of-Scope Capabilities

The following capabilities were discovered during API assessment but are NOT in scope for this integration. Documented here for future reference:

| Capability | API Endpoint | Why Out of Scope |
|-----------|-------------|-----------------|
| [capability] | [endpoint] | Not in Integration_Requirements.md §[ref] |
| [capability] | [endpoint] | Requires additional legal assessment |

---

## 10. Risks Identified

*See `Data_Risks.md` for full risk detail.*

| Risk ID | Type | Classification | Summary |
|---------|------|---------------|---------|
| RISK-[N] | EXTERNAL_API_RELIABILITY | MEDIUM | API has no documented SLA |
| RISK-[N] | SECURITY | LOW | API key auth — rotation policy needed |

---

*Produced by Agente10_DataIntegrationEngineer using templates/External_API_Assessment.md*
