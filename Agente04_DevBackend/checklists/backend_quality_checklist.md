# Backend Quality Checklist

**When to run:** Before every Gate 4 submission.  
**Run by:** Agente04_DevBackend (self-review).  
**If any item fails:** Fix before submitting. Do not set `gate_ready: true` with unchecked items.

---

## Code Structure

- [ ] No business logic in any `route.ts` file — handlers contain only auth + parse + delegate + respond
- [ ] All route handlers are ≤ 30 lines per HTTP method
- [ ] Business logic lives in `features/[domain]/` — Server Actions or `[domain].service.ts`
- [ ] All DAL functions are in `lib/db/[model].dal.ts` — one DAL file per Prisma model
- [ ] No direct `prisma.*` calls in `features/` or `app/api/` — only in `lib/db/`

## Validation

- [ ] Zod schema present at every input boundary (Server Actions, Route Handlers body, query params)
- [ ] Schemas defined at module level — not inline inside function bodies
- [ ] `.parse()` used in Server Actions (throws on invalid)
- [ ] `.safeParse()` used in Route Handlers (returns structured 400 response)
- [ ] All env vars accessed via `lib/env.ts` — zero occurrences of `process.env.*` outside `lib/env.ts`
- [ ] External API responses validated with Zod after `response.json()`

## Authentication and Authorization

- [ ] `await auth()` is the FIRST call in every Server Action (before parsing or any logic)
- [ ] `await auth()` is the FIRST call in every Route Handler (before any other code)
- [ ] Session null check immediately follows `await auth()` — throw/return immediately on null
- [ ] Resource ownership verified before mutations: `resource.userId === session.user.id`
- [ ] 401 returned/thrown for unauthenticated requests
- [ ] 403 returned/thrown for authenticated but unauthorized requests

## Security

- [ ] No `process.env.*` anywhere except `lib/env.ts`
- [ ] No raw SQL string concatenation anywhere (no `"SELECT * WHERE id = " + userId`)
- [ ] No template literal SQL interpolation (no `` Prisma.$queryRaw(`...${userId}...`) ``)
- [ ] No `error.message` in API response bodies
- [ ] No `error.stack` in API response bodies
- [ ] Generic error messages returned to clients on 500 errors

## Structured Logging

- [ ] `auditLog()` called after every Server Action that creates, updates, or deletes user data
- [ ] `actorId` sourced from `session.user.id` (never from input/request body)
- [ ] `actorEmail` sourced from `session.user.email` (never from input/request body)
- [ ] Audit action verbs in PAST_TENSE_VERB format (e.g., TASK_CREATED, not CREATE_TASK)
- [ ] `syncLog()` in `finally` block of every cron route
- [ ] `guardCron(req)` is the absolute first call in every cron route handler
- [ ] All `console.error` calls use structured object context — no string concatenation

## Tests

- [ ] Test file created for every Server Action implemented in this task
- [ ] Test file created for every Route Handler implemented in this task
- [ ] Null session test present in every test file
- [ ] Invalid input test present (empty string, missing required field, wrong type)
- [ ] Success path test present (valid input, returns expected result)
- [ ] Error path test present (DAL/service throws, generic error returned)

## Migrations

- [ ] `prisma migrate dev --name [descriptive-name]` used for all schema changes
- [ ] Migration files are committed (not gitignored)
- [ ] `prisma db push` was NOT used

## Cron Jobs (only if this task includes cron routes)

- [ ] `export const dynamic = "force-dynamic"` present in cron route file
- [ ] `guardCron(req)` is the first statement in the handler function
- [ ] Job function uses `upsert` or existence check — not bare `create`
- [ ] `syncLog()` is in `finally` block
- [ ] `vercel.json` cron entry added or noted for addition

## Handoff Package

- [ ] `Backend_Implementation_Report.md` completed with all sections
- [ ] Self-review checklist in report reflects actual state
- [ ] `gate_ready: true` only when all above items are confirmed
- [ ] No `blocking: true` open questions unresolved in Handoff Package

---

## Runtime Knowledge Policy

This checklist and all items within it are part of the agent's local runtime knowledge.  
Do NOT consult `context/`, `lib/`, raw PDFs, or global architecture documents to resolve checklist items.  
All required patterns are available in `context_view.md`, `templates/`, and `knowledge/`.
