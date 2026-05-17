# Agente04_DevBackend — Decision Heuristics

> Distilled from build-time bibliography. Use these as fast decision shortcuts at runtime. When in doubt, apply the matching heuristic before escalating.

---

## H1 — If a Server Action is > 50 lines, it's doing too much

**Action:** Extract the business logic body into a service function in `features/[domain]/[domain].service.ts`. The Server Action should call the service function, not contain the logic itself.

**Exception:** None. A large Server Action is a design smell regardless of how complex the domain is.

---

## H2 — If a Route Handler touches the database, it violates the thin handler principle

**Action:** Extract the DB logic to a `features/` service function. Delegate from the route handler instead of querying inline.

**Signal:** Any `prisma.*` or `dal.*` import in `app/api/*/route.ts` is a violation.

---

## H3 — If you need to call process.env outside lib/env.ts, stop and centralize it

**Action:** Add the env var to the Zod schema in `lib/env.ts`. Export it from `env`. Replace the direct access with `env.VAR_NAME`.

**Why:** Centralizing env vars means: (1) startup-time validation, (2) TypeScript types, (3) auditable list of all env var usage.

---

## H4 — If a job could produce duplicates on retry, add an upsert or existence check before creating

**Action:** Replace `dal.create(data)` with `dal.upsert({ where: { externalId }, create: data, update: data })` where `externalId` is a stable key from the source system.

**Why:** Vercel Cron retries on failure. A job that ran to 60% completion before failing will restart from the beginning on retry.

---

## H5 — If an external API call is inside $transaction, move it outside

**Action:** Restructure as: (1) validate, (2) DB transaction, (3) on success, call external API.

**Why:** Prisma transactions hold DB connections. An external API call can take 5-10 seconds, holding the connection. If the external call fails, the DB transaction already committed — inconsistency.

---

## H6 — If you're concatenating a string to build a query, stop

**Action:** Replace with Prisma parameterized API (`where: { field: value }`). If raw SQL is unavoidable, use `Prisma.sql` template tag (not bare template literal).

**Why:** String concatenation in queries is SQL injection. No exceptions, no "but this value is validated" — use the parameterized API.

---

## H7 — If error.message reaches the API response, a bad actor now knows your internal structure

**Action:** Wrap in a generic message. Log internally with full context.

**Pattern:** `catch(error) { console.error("[fn]:", { error }); throw new Error("Generic message") }`

**Why:** Error messages from Prisma reveal table names, constraint names, and connection details. Error messages from `zod` reveal field names and validation rules. Generic messages reveal nothing.

---

## H8 — If audit_log is missing from a "delete" operation, the operation is not auditable

**Action:** Add `await auditLog({ action: "ENTITY_DELETED", entityType, entityId, ... })` after the successful delete.

**Why:** Data deletion without an audit trail makes support investigations impossible and creates compliance risk.

---

## H9 — If sync_log is missing from a cron route, the job is unmonitorable

**Action:** Add `syncLog(...)` in the `finally` block.

**Why:** Without sync_log, the operations team has no visibility into whether the job ran, how long it took, or whether it failed.

---

## H10 — If guardCron() is not the first line in a cron route, it's not protected

**Action:** Move `guardCron(req)` to be the absolute first statement in the function body. No code before it.

**Why:** guardCron validates the Vercel Cron secret before executing any job logic. If any code runs before guardCron, that code is reachable without the secret — a protected job becomes an open HTTP endpoint.

---

## H11 — If a Vitest file mocks more than 5 modules, the function under test has too many dependencies

**Action:** Consider refactoring the function to reduce its dependencies before adding more mocks.

**Why:** Many mocks indicate high coupling. The test is essentially testing glue code, not domain logic.

---

## H12 — If a Route Handler has more than 2 await calls, it's not thin

**Action:** The first `await` is auth. The second `await` is delegation to service. If there's a third, logic has leaked into the route — extract it.

**Exception:** The `catch` block's `console.error` call doesn't count. A third `await` for a body parse followed immediately by delegation is borderline acceptable if the handler stays under 30 lines.
