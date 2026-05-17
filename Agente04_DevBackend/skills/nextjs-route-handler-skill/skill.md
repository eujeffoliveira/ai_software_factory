# nextjs-route-handler-skill

## Purpose

Implements a thin Route Handler at `app/api/[resource]/route.ts`. Route Handlers are the Next.js App Router equivalent of REST API endpoints — they handle HTTP requests from external clients, webhooks, and non-Next.js consumers. They must remain thin: authenticate, parse, delegate, respond. No business logic.

## When to Use

- External webhooks that need HTTP endpoints (Stripe, GitHub, etc.)
- REST APIs consumed by mobile apps or third-party clients
- Public endpoints (health check, OAuth callbacks)
- When `API_Contract.json` documents the operation as a Route Handler (not a Server Action)

Do NOT use this skill for:
- Mutations from Next.js Client/Server Components (use `nextjs-server-action-skill`)
- Cron job routes (use `cron-job-implementation-skill`)
- Business logic — delegate to `features/[domain]/[domain].service.ts`

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `route_path` | API contract — path field | Yes |
| `http_method` | API contract — method | Yes |
| `auth_required` | API contract — security | Yes |
| `delegates_to` | Task spec — which service/action to call | Yes |
| `request_body_schema` | API contract — requestBody | Conditional (POST/PUT/PATCH) |
| `query_params_schema` | API contract — parameters | Conditional (GET with filters) |

## Outputs

- TypeScript file at `app/api/[resource]/route.ts`
- Maximum ~30 lines per HTTP method handler
- Delegates to `features/[domain]/[domain].service.ts`

## Procedure

1. **Define Zod schemas at module level** — one for query params, one for request body (if applicable)
2. **Export named function** — `GET`, `POST`, `PUT`, `PATCH`, or `DELETE` matching `http_method`
3. **Auth check first** — `const session = await auth(); if (!session) return 401`
4. **Parse and validate** — `.safeParse()` for params/body; return 400 if invalid
5. **Delegate** — `await service.method({ userId: session.user.id, ...params })`
6. **Return response** — `NextResponse.json(result)` with appropriate status code
7. **Error handler** — `catch(error) { console.error(...); return 500 with generic message }`
8. **Verify ≤ 30 lines** — if longer, extract logic to service

## Quality Gate

Gate 4 checks for this skill output:
- `backend_quality_checklist.md` — thin handler, auth first, no business logic
- `authz_checklist.md` — 401 for null session, resource ownership in service layer

## Failure Modes

| Mode | Symptom | Fix |
|------|---------|-----|
| FM-01 | Route.ts > 30 lines with inline DB logic | Extract to features/ service |
| FM-02 | Raw `req.json()` without Zod | Add safeParse with 400 on failure |
| FM-03 | No `await auth()` at start | Add auth check as first statement |
| FM-10 | `error.message` in 500 response | Return `{ error: "Internal server error" }` |

## RAG Collections Permitted

- `backend_engineering` (route handler patterns)
- `api_design` (REST conventions, status codes)

## Architecture Compliance

- File MUST be in `app/api/[resource]/route.ts`
- MUST NOT import `prisma` directly
- MUST NOT import DAL directly — delegates to `features/` service
- MUST stay ≤ 30 lines per handler
- Business logic belongs in `features/` — NOT here

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:
- its local files (`skill.md`, schemas, checklist, examples)
- `Agente04_DevBackend/knowledge/`
- `Agente04_DevBackend/context_view.md`
- project artifacts provided as input
