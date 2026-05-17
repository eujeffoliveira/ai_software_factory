# Agente04_DevBackend — Failure Modes

This document catalogs the 12 known failure modes for the Dev Backend agent. Each entry includes the failure mode ID, symptom (how to detect it), root cause, corrective action, and related checklist.

---

## FM-01: Business Logic in route.ts

**Symptom:** `app/api/[resource]/route.ts` is longer than 30 lines, contains database calls, conditional business decisions, or imports `prisma` directly.

**Root Cause:** Developer placed domain logic in the route handler instead of delegating to `features/[domain]/`. Often happens when "just adding one query" escalates into embedded business flow.

**Impact:** Untestable logic (route handlers are hard to unit test), coupling between HTTP layer and business layer, hidden bugs in edge cases, violates SRP.

**Corrective Action:**
1. Extract all logic after auth+parse to a service function in `features/[domain]/[domain].service.ts`
2. Replace inline logic in route.ts with a single `await service.method(params)` call
3. Verify route.ts is ≤ 30 lines after extraction
4. Add service function to test coverage

**Related Checklist:** `checklists/backend_quality_checklist.md` — item: "No business logic in any route.ts file"

---

## FM-02: Missing Zod Validation

**Symptom:** `const data = await req.json()` used directly without Zod schema, or `(req.body as SomeType)` type assertion used instead of validation.

**Root Cause:** Developer trusts the client to send valid data, or was in a hurry and used a type assertion as a shortcut.

**Impact:** Malformed data reaches business logic and DB layer. Runtime type errors at unexpected locations. Potential for SQL injection if unvalidated input reaches a query.

**Corrective Action:**
1. Define a Zod schema at module level: `const InputSchema = z.object({ ... })`
2. Replace raw `req.json()` usage: `const data = InputSchema.parse(await req.json())`
3. Or for Route Handlers: `const parsed = InputSchema.safeParse(...); if (!parsed.success) return 400`
4. Remove any `as Type` assertions that were substituting for validation

**Related Checklist:** `checklists/zod_validation_checklist.md`

---

## FM-03: Auth Check Missing

**Symptom:** No `const session = await auth()` call at the start of a Server Action or Route Handler. Or auth is called but the result is not checked before proceeding.

**Root Cause:** Developer assumed "this endpoint isn't sensitive" or forgot the check during rapid implementation.

**Impact:** Authorization bypass — any unauthenticated request can execute the operation. Potential data exposure, data corruption, or unauthorized mutations.

**Corrective Action:**
1. Add `const session = await auth()` as the FIRST statement
2. Add null check immediately after: `if (!session?.user?.id) { throw new Error("Unauthorized") }` (Server Actions) or `return NextResponse.json({ error: "Unauthorized" }, { status: 401 })` (Route Handlers)
3. Verify the check is BEFORE any input parsing or business logic
4. Add test case for null session

**Related Checklist:** `checklists/authz_checklist.md`

---

## FM-04: process.env Used Directly Outside lib/env.ts

**Symptom:** `process.env.SOME_VAR` appears in any file other than `lib/env.ts`.

**Root Cause:** Developer added a quick env var access without centralizing it. Common in integration clients and cron jobs.

**Impact:** Env var validation happens at runtime when first accessed (not at startup), making misconfiguration silent until the affected path executes. No TypeScript types for env vars. Scattered access makes auditing env vars impossible.

**Corrective Action:**
1. Add the env var to the Zod schema in `lib/env.ts`
2. Export it: `export const env = EnvSchema.parse(process.env)`
3. Replace `process.env.VAR_NAME` with `import { env } from "@/lib/env"; env.VAR_NAME`
4. Verify no remaining `process.env` references outside `lib/env.ts`

**Related Checklist:** `checklists/backend_quality_checklist.md` — item: "No process.env outside lib/env.ts"

---

## FM-05: Raw SQL String Concatenation

**Symptom:** Template literal or string `+` concatenation used to build a SQL query: `` `SELECT * FROM tasks WHERE id = '${userId}'` `` or `"SELECT * WHERE name = '" + name + "'"`.

**Root Cause:** Developer bypassed Prisma and used raw SQL, or used `prisma.$queryRaw` with template literal interpolation instead of `Prisma.sql`.

**Impact:** SQL injection vulnerability. Attacker can manipulate the query by injecting SQL metacharacters. CRITICAL security issue that blocks Gate 4.

**Corrective Action:**
1. Replace raw SQL with Prisma's parameterized methods: `prisma.model.findMany({ where: { id: userId } })`
2. If raw SQL is absolutely required (edge case), use `Prisma.sql` template tag: `` prisma.$queryRaw(Prisma.sql`SELECT * FROM tasks WHERE id = ${userId}`) ``
3. Never interpolate user-supplied values into SQL strings
4. Run `sql-safety-review-skill` on all DB-touching files

**Related Checklist:** `checklists/sql_safety_checklist.md`

---

## FM-06: prisma db push Used Instead of migrate dev

**Symptom:** Schema changes applied without a corresponding migration file in `prisma/migrations/`. No migration file was committed.

**Root Cause:** Developer ran `prisma db push` for convenience instead of `prisma migrate dev`.

**Impact:** Schema changes cannot be reliably applied in staging or production (where only `prisma migrate deploy` is run). Production may diverge from development. No migration history for rollbacks.

**Corrective Action:**
1. Run `prisma migrate dev --name [descriptive-name]` to create the proper migration file
2. Commit the generated migration file
3. Never run `prisma db push` in any environment
4. Note: `prisma migrate dev` is for development only; `prisma migrate deploy` is for staging/production

**Related Checklist:** `checklists/backend_quality_checklist.md` — item: "prisma migrate dev used (not prisma db push)"

---

## FM-07: Missing audit_log for Sensitive Action

**Symptom:** A Server Action creates, updates, or deletes user data but has no `auditLog()` call. Or `auditLog()` is called before the DB operation succeeds.

**Root Cause:** Developer considered the operation "minor" and skipped the audit entry. Or added audit_log at the top of the function before knowing if the operation succeeded.

**Impact:** Compliance risk — no audit trail for data changes. Unrecoverable if a data corruption bug occurs. `auditLog()` before operation records actions that never happened (if operation fails).

**Corrective Action:**
1. Add `await auditLog({ actorId, actorEmail, action, entityType, entityId, metadata })` AFTER the successful DB operation
2. If the operation fails (try/catch), the auditLog should NOT be called
3. Verify `actorId` and `actorEmail` come from `session` (not from `input`)
4. Verify `action` is in PAST_TENSE_VERB format

**Related Checklist:** `checklists/audit_log_checklist.md`

---

## FM-08: Missing sync_log for Cron Job

**Symptom:** A cron route handler exists but has no `syncLog()` call. Or `syncLog()` is called only in the success branch (missing when an error occurs).

**Root Cause:** Developer implemented the job logic but forgot the operational logging requirement. Or placed `syncLog()` in the `try` block instead of `finally`.

**Impact:** Job executions (especially failures) are invisible to operations team. Impossible to diagnose job health, frequency, or failure patterns without log entries.

**Corrective Action:**
1. Add `syncLog(...)` call in the `finally` block of the cron route
2. Capture `startedAt = Date.now()` before the try block
3. Track `status` as a variable updated to "error" in catch block
4. Ensure `syncLog` records both success and error executions

**Related Checklist:** `checklists/sync_log_checklist.md`

---

## FM-09: guardCron() Not First Call in Cron Route

**Symptom:** `guardCron(req)` appears after other code in the cron route handler, or is missing entirely.

**Root Cause:** Developer added setup code (logging, variable initialization) before the guard call, or forgot to include it at all.

**Impact:** Cron route is unprotected — any HTTP request can trigger the job. An attacker could trigger the job repeatedly, causing duplicate data, performance issues, or unintended state changes.

**Corrective Action:**
1. Move `guardCron(req)` to be the absolute first statement in the function body
2. No variable declarations, no imports, no logging before `guardCron(req)`
3. If guardCron is missing entirely, add it as first line and add `CRON_SECRET` to `lib/env.ts`
4. Verify `guardCron` properly validates the Vercel Cron secret

**Related Checklist:** `checklists/cron_idempotency_checklist.md` — item: "guardCron() is first call in handler"

---

## FM-10: Stack Trace Exposed to Client

**Symptom:** API response body contains `error.message`, `error.stack`, or internal error details. Example: `return NextResponse.json({ error: error.message })`.

**Root Cause:** Developer used `error.message` for convenience in the response, not realizing it exposes internal implementation details.

**Impact:** Information disclosure — attacker learns internal function names, file paths, dependency names, and database schema details from error messages. Confirms attack vectors.

**Corrective Action:**
1. Replace `{ error: error.message }` with `{ error: "Internal server error" }` in all Route Handlers
2. In Server Actions, replace `throw error` with `throw new Error("Operation failed. Please try again.")`
3. Log the full error internally: `console.error("[location] failed:", { error, ...context })`
4. Never pass `error`, `error.message`, or `error.stack` to the client

**Related Checklist:** `checklists/backend_quality_checklist.md` — item: "No stack traces in API responses"

---

## FM-11: External API Called Inside Prisma Transaction

**Symptom:** `await prisma.$transaction(async (tx) => { ... await externalApiClient.callMethod() ... })` — an HTTP call to an external service is inside the transaction callback.

**Root Cause:** Developer placed the external call inside the transaction for atomicity, but HTTP calls are not transactional.

**Impact:** If the external API call is slow or fails, the Prisma transaction is held open, holding DB connections and potentially timing out. If the external call succeeds but the DB transaction rolls back, the external action is not undone (inconsistency).

**Corrective Action:**
1. Move external API calls OUTSIDE the `prisma.$transaction` block
2. Restructure as: validate → DB transaction → (on success) → external API call
3. Handle the case where DB succeeds but external call fails (compensating action or retry queue)
4. For idempotency, use the external service's idempotency key header

**Related Checklist:** `checklists/backend_quality_checklist.md`

---

## FM-12: Non-Idempotent Cron Job

**Symptom:** Cron job uses `prisma.model.create()` or `insert` without checking if the record already exists. Running the job twice creates duplicate records.

**Root Cause:** Developer wrote the job logic as a linear "create all records" operation without considering Vercel Cron's retry behavior on failure.

**Impact:** Duplicate records in the database after any retry. Data integrity issues. Users see duplicate entries. Difficult to de-duplicate after the fact.

**Corrective Action:**
1. Replace `prisma.model.create(data)` with `prisma.model.upsert({ where: { uniqueKey }, create: data, update: data })`
2. Or add an existence check: `const existing = await dal.findByExternalId(id); if (!existing) await dal.create(...)`
3. Ensure the unique key used in `where` is derived from the source data (external ID), not a generated UUID
4. Test by running the job twice on the same data set and verifying no duplicates

**Related Checklist:** `checklists/cron_idempotency_checklist.md`
