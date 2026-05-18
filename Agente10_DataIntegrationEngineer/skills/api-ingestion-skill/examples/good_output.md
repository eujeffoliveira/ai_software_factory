# Good Output: api-ingestion-skill

A correct External_API_Assessment.md includes:

**Client path:** `lib/integrations/crm-platform.client.ts` ✓

**Auth with env vars:**
```
env.CRM_BASE_URL, env.CRM_API_KEY  (no literal values)
```

**Rate limits analyzed:**
1,000 req/min → sync job consumes ~50 calls → 5% of limit → safe ✓

**Zod schema with .passthrough():**
```typescript
const CrmContactSchema = z.object({
  id: z.string().min(1),
  email: z.string().email(),
  ...
}).passthrough()  // forward compatibility ✓
```

**Resilience complete:**
- Timeout: 10,000ms
- Retry: 3 attempts, exponential backoff with jitter
- Circuit breaker: 5 failures / 60s window
- Dead letter: integration_quarantine table

**Webhook security specified:**
HMAC-SHA256 with `crypto.timingSafeEqual()`, timestamp check (reject > 5min old), event ID deduplication
