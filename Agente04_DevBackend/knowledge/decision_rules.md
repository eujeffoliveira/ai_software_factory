# Agente04_DevBackend — Decision Rules

> Distilled from build-time bibliography and reference architecture. These are the binding if-then rules that govern implementation decisions at runtime.

---

## DR001 — Zod validation is mandatory at all input boundaries

**Rule:** IF user input arrives at any backend function without Zod validation THEN add validation before use — no exceptions.

**Applies to:** Server Action inputs, Route Handler query params and body, env vars, external API responses, webhook payloads.

**Exception:** None. A type assertion is not validation.

---

## DR002 — Business logic belongs in features/, not route.ts

**Rule:** IF route.ts contains business logic beyond auth+parse+delegate THEN extract to `features/[domain]/[domain].service.ts` — route handlers must stay thin.

**Thin handler definition:** auth check + request parsing + delegation + response. Maximum ~30 lines.

---

## DR003 — audit_log is required for all mutations on user data

**Rule:** IF a Server Action creates, updates, or deletes data on behalf of a human user THEN add `auditLog()` call after success — no exceptions.

**Exception:** Read-only operations (findMany, count) do not require audit_log.

---

## DR004 — guardCron() must be first in every cron route

**Rule:** IF a cron route exists THEN `guardCron(req)` must be the absolute first call in the handler function — no code before it.

**Why this is a rule:** Any code before guardCron is reachable without the cron secret.

---

## DR005 — syncLog() must be in finally for every cron route

**Rule:** IF a cron route exists THEN `syncLog()` must be in the `finally` block — records execution even on failure.

**Why this is a rule:** Job failures not recorded in sync_log are invisible to operators and monitoring.

---

## DR006 — All env vars must be accessed via lib/env.ts

**Rule:** IF `process.env` is accessed outside `lib/env.ts` THEN centralize it — scattered env access is a maintenance and security risk.

**Enforcement:** Zero occurrences of `process.env.VAR_NAME` outside `lib/env.ts`.

---

## DR007 — Cron jobs must use upsert for record creation

**Rule:** IF a job function uses `prisma.entity.create()` THEN replace with `prisma.entity.upsert({ where: { externalId } ... })` — jobs must be idempotent.

**Why this is a rule:** Vercel Cron retries on failure. Non-idempotent jobs create duplicates.

---

## DR008 — External API calls must not be inside Prisma transactions

**Rule:** IF an external API call is inside `prisma.$transaction` THEN move it outside — transactions must not contain I/O.

**Correct structure:** Validate → DB transaction → (on success) → external API call.

---

## DR009 — Internal errors must never reach API responses

**Rule:** IF `error.message` or `error.stack` is returned in an API response THEN wrap in a generic message — never expose internals.

**Correct form:** `catch(error) { console.error("[location]:", { error }); return/throw generic }`

---

## DR010 — Tests are required for every Server Action and Route Handler

**Rule:** IF a Server Action or Route Handler is implemented THEN a corresponding test file must be created — tests are required.

**Minimum:** 4 test cases: unauthenticated, invalid input, success path, error path.

**Gate 4 impact:** Missing tests → `BLOCKED_MISSING_TESTS` from QA Engineer.

---

## DR011 — Unauthenticated requests must be rejected immediately

**Rule:** IF `auth()` returns null and the operation is not explicitly marked as public THEN return 401/throw Unauthorized immediately — no further code executes.

**Exception:** Explicitly public endpoints (health check, OAuth callbacks) documented in API contract.

---

## DR012 — Resource ownership must be verified for all mutations

**Rule:** IF a resource is fetched and mutated without ownership check THEN add `if (resource.userId !== session.user.id)` check — IDOR prevention.

**Return value:** 404 if resource not found (don't confirm existence), 403 if not owned.

---

## DR013 — Raw SQL must use Prisma.sql template tag

**Rule:** IF `prisma.$queryRaw` is used with string interpolation THEN replace with `Prisma.sql` template tag — SQL injection prevention.

**Pattern:** `` prisma.$queryRaw(Prisma.sql`SELECT * WHERE id = ${id}`) ``

**Never:** `` prisma.$queryRaw(`SELECT * WHERE id = ${id}`) `` (bare template literal is not parameterized)

---

## DR014 — New npm packages require Tech Lead approval

**Rule:** IF a new npm package is needed THEN escalate to `Agente00_TechLead` — no adding packages without approval.

**Why this is a rule:** Unreviewed dependencies introduce supply chain risk, license issues, and bundle size increases.
