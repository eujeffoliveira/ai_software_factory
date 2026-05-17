# Agente04_DevBackend — Operating Principles

> Distilled from build-time bibliography and reference architecture. These principles govern every implementation decision made at runtime. Do not consult raw sources at runtime.

---

## P1 — Thin Route Handlers, Rich Features

**Source:** Clean Code (Robert C. Martin) — Single Responsibility Principle applied to web handlers

Route Handlers validate authorization, parse the request, delegate to `features/`, and return the response. Never more. Business logic in `route.ts` is a coupling violation that makes testing impossible and creates hidden dependencies between the HTTP layer and the domain layer.

**Applied rule:** Route.ts ≤ 30 lines per method. Logic beyond auth+parse+delegate goes in `features/[domain]/[domain].service.ts`.

**Violation signature:** `route.ts` with database calls, multiple prisma queries, or conditional business decisions.  
**Correct form:** `return NextResponse.json(await taskService.list({ userId: session.user.id, ...params }))`

---

## P2 — Zod at Every Boundary

**Source:** Architecture Patterns with Python (Percival & Gregory) — Ports and Adapters

Every entry point into the system is a port, and every port needs an adapter that validates incoming data. User input, environment variables, external API responses, and webhook payloads all cross the trust boundary. Validate before use. A type assertion (`as Type`) is not validation — it is a lie to the compiler.

**Applied rule:** `const data = Schema.parse(rawInput)` before any use of external data. Env vars in `lib/env.ts` with Zod.

**Violation signature:** `const data = await req.json() as InputType`  
**Correct form:** `const data = InputSchema.safeParse(await req.json())`

---

## P3 — Authentication First, Always

**Source:** Reference Architecture — Security §1

The first operation in any Server Action or Route Handler is the auth check. Not the second. Not after parsing. The first. An unauthenticated request that reaches business logic is an authorization bypass — regardless of how the business logic handles it internally.

**Applied rule:** `const session = await auth()` followed by `if (!session?.user?.id) { throw/return 401 }` as lines 1-2 of the function body.

**Violation signature:** Auth check after variable declarations, input parsing, or any other code.  
**Correct form:** Auth check is literally the first two lines executed.

---

## P4 — Authorization is Resource-Level, Not Session-Level

**Source:** Reference Architecture — Security §2 (IDOR Prevention)

Authentication answers "who are you?" Authorization answers "are you allowed to do THIS to THIS specific record?" A user authenticated in the system may not be authorized to modify another user's record. Both checks are mandatory for all mutations.

**Applied rule:** After auth check, fetch resource, verify `resource.userId === session.user.id`. Return 404 if not found (don't confirm existence), 403 if not owned.

**Violation signature:** Checking `if (!session)` but not checking `if (resource.userId !== session.user.id)`.  
**Correct form:** Both checks performed before any mutation.

---

## P5 — DAL Abstracts the Database

**Source:** Architecture Patterns with Python (Percival & Gregory) — Repository Pattern

All database operations go through the DAL (`lib/db/[model].dal.ts`). Features, Server Actions, and Route Handlers never call `prisma` directly. This abstraction makes the code testable (mock the DAL, not Prisma) and refactorable (change Prisma configuration in one place).

**Applied rule:** `import { taskDal } from "@/lib/db/task.dal"` in features — never `import { prisma } from "@/lib/db/prisma"`.

**Violation signature:** `import { prisma } from "@/lib/db/prisma"` in any file outside `lib/db/`.  
**Correct form:** Features import only named DAL objects.

---

## P6 — Audit What Humans Do, Log What Machines Do

**Source:** Reference Architecture — Logging Policy

Human-triggered state changes → `audit_log` (immutable history of "who did what to what and when"). Machine-triggered operations → `sync_log` (operational record of job execution, performance, and counts). Never swap them. Never skip `audit_log` for "minor" human actions — the definition of "minor" changes when a data dispute arises.

**Applied rule:** Every Server Action with CREATE/UPDATE/DELETE calls `auditLog()` after success. Every cron route calls `syncLog()` in `finally`.

**Violation signature:** Server Action modifies data without `auditLog()`. Cron route has no `syncLog()`.

---

## P7 — Idempotency Makes Jobs Safe

**Source:** Microservices Patterns (Chris Richardson) — Idempotent Consumer

A cron job that runs twice must produce the same result as one that runs once. Upsert instead of insert. Check existence before creating. Store processed IDs. Jobs without idempotency guarantee will create duplicates in production — Vercel Cron retries on failure.

**Applied rule:** Any job that creates records uses `prisma.model.upsert({ where: { externalId }, ... })` not `prisma.model.create(...)`.

**Violation signature:** `dal.create()` called in a job function without an existence check.  
**Correct form:** `dal.upsertByExternalId(externalId, createData, updateData)`.

---

## P8 — Errors Belong to Operators, Not Users

**Source:** Clean Code (Robert C. Martin) — Error Handling

Internal errors contain context (stack trace, userId, operation name, DB details) that helps operators debug. Users receive a generic message that doesn't reveal system internals or confirm attack vectors. Pattern: `catch(error) { console.error("[location]:", { error, ...context }); throw new Error("Generic message") }`.

**Applied rule:** `error.message` and `error.stack` never appear in API response bodies. Structured log to console, generic message to caller.

**Violation signature:** `return NextResponse.json({ error: error.message })`  
**Correct form:** `console.error("[location]:", { error }); return NextResponse.json({ error: "Internal server error" })`

---

## P9 — Environment Variables Are Configuration, Not Magic

**Source:** Clean Code (Robert C. Martin) — Configuration isolation

All env vars are validated and exported from `lib/env.ts` using Zod. No scattered `process.env.X` throughout the codebase. A misconfigured env var is caught at startup, not at 2am when a cron job fails silently because `process.env.EXTERNAL_API_KEY` is undefined.

**Applied rule:** `import { env } from "@/lib/env"` everywhere. Zero occurrences of `process.env.X` outside `lib/env.ts`.

**Violation signature:** `process.env.SOME_VAR` in integration client or cron job.  
**Correct form:** Add to `lib/env.ts` Zod schema, then `env.SOME_VAR`.

---

## P10 — Tests Are Not Optional for Backend Code

**Source:** Test-Driven Development by Example (Beck) — via Architecture Patterns with Python

Every Server Action and Route Handler has tests. Auth failure test. Invalid input test. Success path test. Error path test. If it's not tested, it's not done. "I'll add tests later" means "I won't add tests." The Definition of Done requires tests before Gate 4 submission.

**Applied rule:** Every task that implements a Server Action or Route Handler includes a corresponding `.test.ts` file with minimum 4 test cases.

**Violation signature:** Implementation file exists but no `.test.ts` file.  
**Gate 4 result:** `BLOCKED_MISSING_TESTS`
