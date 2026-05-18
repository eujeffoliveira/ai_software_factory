# Bad Output: api-ingestion-skill

Violations in a bad External_API_Assessment.md:

**Hardcoded credential (FM-06):**
```
Authorization: Bearer sk-crm-prod-a1b2c3  // literal API key in spec
```

**No Zod schema (FM-03):**
"Response is a JSON array of contact objects" — no schema defined. Agente04 will use type assertions.

**No timeout:**
Client spec has no timeout configured. External API hanging indefinitely holds a serverless function slot.

**Webhook without signature verification:**
Webhook endpoint specified but no HMAC verification. Any internet client can send fake events.

**Wrong client path:**
`services/crm-service.ts` instead of `lib/integrations/crm-platform.client.ts` — violates Golden Model isolation convention.

**Out-of-scope endpoints included:**
Assessment added the CRM's `POST /contacts` endpoint (for creating new contacts) even though only read operations are in scope. FM-10 scope creep — Agente03 will create tasks for functionality not required.
