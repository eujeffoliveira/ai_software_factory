# external-integration-client-skill

## Purpose

Implements a typed client for a third-party external API. All credentials come from `lib/env.ts`, responses are validated with Zod, timeouts are configured, and the client is never called inside a Prisma transaction.

## When to Use

- Any task that integrates with a third-party API (email, payment, data provider, etc.)
- When a new `lib/integrations/[service].client.ts` needs to be created

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `service_name` | Task spec | Yes |
| `auth_method` | API documentation | Yes |
| `base_url_env_var` | Task spec (env var key) | Yes |
| `endpoints` | API documentation | Yes |

## Outputs

- TypeScript file at `lib/integrations/[service].client.ts`
- Named const export with typed methods
- Zod response schemas
- Typed error classes

## Procedure

1. Define Zod response schemas for each endpoint
2. Define typed error classes (`[Service]ApiError`, `[Service]RateLimitError`)
3. Export named const client object with method per endpoint
4. Use `env.[SERVICE]_API_KEY` from `lib/env.ts` — never process.env
5. Add `AbortSignal.timeout(TIMEOUT_MS)` to every fetch call. `TIMEOUT_MS` must be declared as a module-level constant (default: `10_000`); override via env var if the API contract specifies a different SLA
6. Check the response content type before parsing: if `Content-Type` is `application/json` (or variant), call `response.json()`; if the response body is empty (status 204 or `Content-Length: 0`), return `null` or a typed empty result; for any other content type, throw `[Service]ApiError` with the raw status and a `"unexpected_content_type"` code
7. Validate the parsed JSON body with `Schema.parse(body)` — only after step 6 confirms JSON
8. Never call inside `prisma.$transaction`

## Quality Gate

Gate 4 checks: `checklists/backend_quality_checklist.md`

## Failure Modes

- FM-04: Hardcoded API key — use `lib/env.ts`
- No timeout — requests hang
- No response Zod validation — runtime type errors
- FM-11: Called inside transaction — blocks DB connection

## RAG Collections Permitted

- `backend_engineering`
- `api_design`
- `nodejs_patterns`

## Architecture Compliance

- File MUST be in `lib/integrations/[service].client.ts`
- Credentials MUST come from `lib/env.ts`
- Responses MUST be validated with Zod
- MUST NOT be called inside `prisma.$transaction`

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime. It may use only its local files, `Agente04_DevBackend/knowledge/`, `Agente04_DevBackend/context_view.md`, and project input artifacts.
