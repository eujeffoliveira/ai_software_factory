# Skill: api-ingestion-skill

## Purpose

Assess an external REST or GraphQL API and produce `External_API_Assessment.md` — specifying the client design for `lib/integrations/[service].client.ts`, including Zod schema requirements, authentication configuration, rate limit strategy, and resilience patterns.

## When to Use

Invoke as the FIRST skill for any new external API integration. This skill's output feeds into `data-mapping-skill` (response schema) and `sync-strategy-skill` (rate limits, reliability profile). One invocation per external system.

## Inputs

| Input | Source | Required |
|-------|--------|----------|
| `external_api_documentation` | Provider docs | Yes |
| `integration_id` | Integration_Spec.md | Yes |
| `integration_requirements` | Integration_Requirements.md | Yes |
| `latency_requirement` | Architecture.md | Yes |

## Outputs

| Output | Description |
|--------|-------------|
| `External_API_Assessment.md` | Complete API assessment with client spec |
| Client file specification | `lib/integrations/[service].client.ts` interface |
| Zod schema requirements | Response shape schemas with `.passthrough()` |
| Resilience config | Retry, circuit breaker, timeout parameters |
| Environment variables list | Env var names to add to `lib/env.ts` |

## Constraints

- Client file path must follow: `lib/integrations/[service].client.ts`
- All credentials must reference `env.VARIABLE_NAME` — never literal values
- Timeout must be specified — no unlimited HTTP calls
- Zod schema must be defined for every external API response shape
- `.passthrough()` is the default — `.strict()` only for pinned, versioned, stable APIs
- API version must be pinned in the client base URL
- Out-of-scope capabilities must be documented (not silently ignored)
- Webhook endpoints require signature verification specification

## Step-by-Step Execution

1. **Review API documentation:** Extract: base URL structure, authentication method, available endpoints, response schemas, rate limits, error codes, webhook support.

2. **Assess API maturity:** Classify stability (STABLE/BETA/ALPHA/UNDOCUMENTED), versioning strategy, documentation quality, forward compatibility risk.

3. **Design authentication:** Identify method, env var names, token expiration, refresh mechanism.

4. **Assess rate limits:** Document limits per minute/hour/day, `Retry-After` support, rate limit headers.

5. **Assess reliability:** Document SLA, latency, webhook delivery guarantee.

6. **Design client interface:** List public methods with HTTP method, endpoint, parameters, return type. Apply DR020 — escalate if new infrastructure is required. **New infrastructure** means anything beyond creating `lib/integrations/[service].client.ts`: examples include a new Prisma model or database table, a message queue (Redis, RabbitMQ), a new Vercel environment variable namespace for a different deployment, or a third-party managed service account. Does NOT include: adding a new method to an existing client file, adding env vars for the new API key, or defining new Zod schemas.

7. **Define Zod schemas:** For each response shape, define minimum required fields and use `.passthrough()`. Apply H4 (one schema per shape, not per endpoint).

8. **Design resilience patterns:** Retry (H7), circuit breaker (H8, Card013), dead letter (H9, DR017), rate limit monitoring (DR015).

9. **Webhook security (if applicable):** Specify HMAC verification, timing-safe comparison, timestamp check, event deduplication (Card005, DR016).

10. **Document out-of-scope capabilities:** List API features discovered but not in requirements.

11. **Run `external_api_checklist.md`:** Verify all items before marking output complete.

## Knowledge Access Policy

At runtime, this skill reads from:
- `Agente10_DataIntegrationEngineer/knowledge/` (principles P4, P6, P7, P10; heuristics H4, H7, H8, H9, H12; decision rules DR012, DR015, DR016, DR018, DR020; cards Card005, Card009, Card011, Card013)
- `Agente10_DataIntegrationEngineer/templates/External_API_Assessment.md`
- `Agente10_DataIntegrationEngineer/checklists/external_api_checklist.md`
- Project input artifacts: external API documentation, Integration_Requirements.md

**Blocked at runtime:** `context/`, `lib/`, `*.pdf`, any other agent's folder.
