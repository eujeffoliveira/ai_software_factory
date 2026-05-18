# External API Assessment Checklist

> Run for every external API before designing the integration. Invoke via api-ingestion-skill.

## Pre-Execution: Documentation Review

- [ ] External API documentation URL or file available
- [ ] API type identified: REST / GraphQL / SOAP / gRPC
- [ ] API version to target identified
- [ ] Available endpoints reviewed — list compiled

## API Maturity Assessment

- [ ] API stability classification: STABLE / BETA / ALPHA / UNDOCUMENTED
- [ ] Versioning strategy assessed: URL / Header / Query param / None
- [ ] Changelog or release notes availability noted
- [ ] Forward compatibility risk assessed: LOW / MEDIUM / HIGH
- [ ] Status page URL documented (if available)

## Authentication Assessment

- [ ] Authentication method identified: API Key / OAuth 2.0 / Bearer Token / HMAC / Basic Auth
- [ ] Security rating assigned: HIGH / MEDIUM / LOW
- [ ] Token expiration period documented
- [ ] Token refresh mechanism documented
- [ ] All required environment variable names listed (not values — names only)
- [ ] All env var names follow convention: `[SYSTEM]_API_KEY`, `[SYSTEM]_BASE_URL`

## Rate Limits Assessment

- [ ] Rate limits documented (requests/minute, requests/hour, requests/day)
- [ ] `Retry-After` header support confirmed or noted as absent
- [ ] Rate limit response headers documented (`X-RateLimit-*`)
- [ ] Daily API call consumption estimated for all planned sync jobs
- [ ] Consumption vs. limit ratio calculated and documented
- [ ] If consumption > 80% of limit: rate limit monitoring and throttling specified

## Reliability Assessment

- [ ] SLA documented (uptime guarantee, if any)
- [ ] Known downtime windows documented
- [ ] Typical response latency documented (p50, p99) or marked as unknown
- [ ] Webhook support: Yes / No — if Yes, delivery guarantee documented
- [ ] Historical reliability notes added (known incidents, SLA history)

## Client Specification

- [ ] Client file path specified: `lib/integrations/[system-name].client.ts`
- [ ] All required public methods documented with HTTP method, endpoint, parameters, return type
- [ ] Timeout value specified: default 10,000ms
- [ ] Client reads credentials from `env.[SYSTEM]_*` — no hardcoded values
- [ ] API version pinned in base URL: `${env.[SYSTEM]_BASE_URL}/v[N]/`
- [ ] "Never call inside Prisma transaction" rule documented

## Zod Schema Requirements

- [ ] Zod schema defined for every response shape from this API
- [ ] Minimum required fields listed per schema
- [ ] `.passthrough()` specified — not `.strict()` (unless API is pinned and stable)
- [ ] Optional fields use `.nullable().optional()`
- [ ] DateTime fields use `z.string().datetime()`
- [ ] Enum fields use `z.enum([...])` with all valid values listed

## Resilience Patterns

- [ ] Retry configuration specified: max_attempts, backoff_strategy, base_delay_ms, max_delay_ms
- [ ] Circuit breaker configuration specified: failure_threshold, window_seconds, open_duration_seconds
- [ ] HTTP error handling table specified for: 401, 429, 500, 502, 503, 504, network errors
- [ ] Dead letter mechanism specified for records exhausting retries
- [ ] Rate limit header parsing specified (honor `Retry-After` on HTTP 429)

## Webhook Configuration (if applicable)

- [ ] Endpoint path specified: `app/api/webhooks/[system]/route.ts`
- [ ] Supported event types listed
- [ ] Signature algorithm documented: HMAC-SHA256 / Provider-specific
- [ ] Signature header name documented
- [ ] Signature secret env var name documented
- [ ] `timingSafeEqual` comparison specified (not string equality)
- [ ] HTTP 200 before processing specified (prevent provider timeout)
- [ ] Replay protection: timestamp header check or event ID deduplication

## Out-of-Scope Capabilities

- [ ] Any API capabilities discovered but NOT in requirements documented in "Out-of-Scope" section
- [ ] Rationale for exclusion documented

## Post-Execution: Output Ready

- [ ] `External_API_Assessment.md` produced using `templates/External_API_Assessment.md`
- [ ] Risk entries added to `Data_Risks.md` for: undocumented SLA, auth security level, rate limit exposure
- [ ] Ready to pass to data-mapping-skill

## Runtime Knowledge Policy

At runtime, this checklist is consulted from `Agente10_DataIntegrationEngineer/checklists/`. The agent reads only from its own folder and project input artifacts. `context/` and `lib/` are blocked at runtime.
