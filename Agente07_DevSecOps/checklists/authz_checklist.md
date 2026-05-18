# Authentication and Authorization Checklist

> Run this checklist on every Gate 5 evaluation. Missing auth check = CRITICAL finding, BLOCKED_AUTH_BYPASS.

## Runtime Knowledge Policy

Read from `Agente07_DevSecOps/knowledge/decision_rules.md` (DR002, DR010, DR011) and `Agente07_DevSecOps/knowledge/knowledge_cards.md` (Card 003, Card 012) before executing. Do NOT access `context/` or `lib/` at runtime.

---

## Step 1: Identify All Protected Routes

List all Server Actions, Route Handlers, and Cron Route Handlers in the reviewed feature:

| File Path | Type | Auth Required |
|-----------|------|--------------|
| [path] | Server Action / Route Handler / Cron Route | YES / NO |

---

## Step 2: Server Action Auth Check (for each Server Action)

For each Server Action (`features/*/actions/*.ts`, `app/actions/*.ts`):

- [ ] **auth() is FIRST operation**: `const session = await auth()` appears before any other logic
- [ ] **Session guard present**: `if (!session) return { error: "Unauthorized" }` immediately follows `auth()`
- [ ] **No business logic before auth**: No DB calls, service calls, or variable assignments before auth check
- [ ] **userId from session**: User identity sourced from `session.user.id`, NOT from function arguments
- [ ] **Input schema excludes identity fields**: Zod schema does NOT contain `userId`, `actorId`, `ownerId`, or similar

| Action File | auth() First | Session Guard | No Logic Before Auth | userId from Session | Identity Fields in Input |
|-------------|-------------|--------------|---------------------|---------------------|--------------------------|
| [file] | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ | ✅ None / ❌ Found |

---

## Step 3: Route Handler Auth Check (for each Route Handler)

For each Route Handler (`app/api/**/route.ts`):

- [ ] **auth() is FIRST operation**: `const session = await auth()` appears before any other logic
- [ ] **Session guard returns 401**: `if (!session) return new Response("Unauthorized", { status: 401 })`
- [ ] **No business logic before auth**: No DB calls, external API calls, or data processing before auth check
- [ ] **Correct HTTP verb handling**: POST/PUT/PATCH/DELETE routes all have auth; GET routes with sensitive data also have auth

| Route File | Method | auth() First | Returns 401 | No Logic Before Auth |
|------------|--------|-------------|-------------|---------------------|
| [file] | GET/POST/etc | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ |

---

## Step 4: Cron Route Handler Check (for each Cron Route)

For each Cron Route Handler (`app/api/cron/**/route.ts`):

- [ ] **guardCron() is FIRST operation**: `guardCron(request)` is the absolute first call in the handler
- [ ] **No business logic before guardCron()**: No DB calls or other logic before `guardCron()`
- [ ] **guardCron() validates the correct header**: Validates `Authorization: Bearer <CRON_SECRET>` from `lib/env.ts`
- [ ] **CRON_SECRET in lib/env.ts**: The cron secret is accessed via `lib/env.ts`, not `process.env`

| Cron Route File | guardCron() First | No Logic Before Guard | CRON_SECRET via env.ts |
|-----------------|------------------|----------------------|------------------------|
| [file] | ✅ / ❌ | ✅ / ❌ | ✅ / ❌ |

---

## Step 5: Resource-Level Authorization (IDOR Check)

For every Prisma query that retrieves, updates, or deletes user-owned data:

- [ ] **findUnique with ownership**: `where: { id: recordId, userId: session.user.id }`
- [ ] **findFirst with ownership**: `where: { id: recordId, userId: session.user.id }`
- [ ] **update with ownership**: `where: { id: recordId, userId: session.user.id }`
- [ ] **delete with ownership**: `where: { id: recordId, userId: session.user.id }`
- [ ] **No unscoped queries on user-owned data**: No `findUnique({ where: { id: recordId } })` without userId scope on user-owned tables

| Query Location | Operation | Ownership Check Present | Check Pattern |
|----------------|-----------|------------------------|---------------|
| [file:line] | findUnique/update/delete | ✅ YES / ❌ NO | `where: { id: X, userId: session.user.id }` |

---

## Step 6: userId Source Verification

- [ ] **Global search**: Search all reviewed files for `userId`, `actorId`, `ownerId`, `creatorId`, `authorId`
- [ ] **Each occurrence**: Verify each is assigned from `session.user.id` and NOT from:
  - `request.json()` — CRITICAL if found (DR011)
  - URL params (`params.userId`) — CRITICAL if found (DR011)
  - Query params (`searchParams.get('userId')`) — CRITICAL if found (DR011)
  - Request headers — CRITICAL if found (DR011)
  - Function arguments passed from client — CRITICAL if found (DR011)

| File | Variable | Source | Safe |
|------|----------|--------|------|
| [file:line] | userId | session.user.id / ❌ request.json() | ✅ / ❌ |

---

## Step 7: Fail-Secure Verification

- [ ] **Explicit session guard**: Execution stops immediately if `!session` — not just "eventually"
- [ ] **No fail-open patterns**: Auth check failure always results in denial, never in silent continuation
- [ ] **Error handling doesn't bypass auth**: `try/catch` blocks do not catch auth failures and continue

---

## Auth/Authz Summary

| Check | Routes Reviewed | Routes Passing | Routes Failing |
|-------|----------------|---------------|----------------|
| Server Action auth() first | [N] | [N] | [N] |
| Route Handler auth() first | [N] | [N] | [N] |
| Cron guardCron() first | [N] | [N] | [N] |
| Resource ownership check | [N queries] | [N] | [N] |
| userId from session only | [N occurrences] | [N] | [N] |

**Overall auth/authz status:** PASS / FAIL
**Findings:** [List any failures with SEC-NNN IDs]
