# Good Example — Threat Model

> This is a realistic example of a HIGH-QUALITY threat model. Notice: trust boundaries clearly defined, all 6 STRIDE categories with specific threats, concrete mitigations mapped to code patterns, open threats explicitly listed.

---

# Threat Model

## Feature: User Task Management (Create, Read, Update, Delete Tasks)
## Date: 2026-05-17
## Produced by: Agente07_DevSecOps v1.0.0

---

## System Overview

The Task Management feature allows authenticated users to create, view, update, and delete their own tasks. Tasks belong to a single user (INTERNAL classification) and contain a title, description, due date, and status field. The feature is implemented as Server Actions (mutations) and Server Components (reads), with a cron job that automatically marks overdue tasks. Task data is INTERNAL classification; the user's identity (email) is CONFIDENTIAL.

---

## Trust Boundaries

| ID | Boundary | What Crosses It | Validation Required |
|----|----------|-----------------|-------------------|
| TB-01 | Browser → Next.js Server Action | User form input (task title, description, due date, status) | Zod schema: `CreateTaskSchema`, `UpdateTaskSchema` |
| TB-02 | Server Action → Prisma DAL | Validated, typed task data + session.user.id | Auth check + ownership scope in query |
| TB-03 | Prisma DAL → Supabase PostgreSQL | Parameterized SQL queries | Prisma automatic parameterization |
| TB-04 | Vercel Cron → Cron Route Handler | HTTP GET with Authorization header | guardCron() validates Authorization: Bearer <CRON_SECRET> |
| TB-05 | Cron Route Handler → Prisma DAL | System-generated update (no user input) | No user input crosses this boundary |

---

## Assets

| ID | Asset | Classification | Why Worth Protecting |
|----|-------|---------------|---------------------|
| A-01 | Task records (title, description) | INTERNAL | User-created content; unauthorized access is a privacy violation |
| A-02 | session.user.id | INTERNAL | The anchor of all access control; compromise enables IDOR attacks |
| A-03 | session.user.email | CONFIDENTIAL | PII — email address identifies the user |
| A-04 | Task.status update capability | INTERNAL | Unauthorized status updates could corrupt user's workflow data |
| A-05 | audit_log entries | INTERNAL | Tamper-evident record of sensitive operations; deletion enables repudiation |
| A-06 | CRON_SECRET | INTERNAL | Protects cron route from unauthorized invocation |

---

## Threat Analysis (STRIDE)

### S — Spoofing

| ID | Threat | Component | Likelihood | Impact | Mitigation | Status |
|----|--------|-----------|-----------|--------|------------|--------|
| S-01 | Attacker makes request to create/update/delete task without a valid session | Server Action: createTask, updateTask, deleteTask | HIGH (common attempt) | HIGH | `const session = await auth()` as FIRST operation in each Server Action; `if (!session) return { error: "Unauthorized" }` — stops execution immediately | IMPLEMENTED |
| S-02 | Attacker replays expired or invalid session token | NextAuth v5 session validation | MEDIUM | HIGH | NextAuth v5 handles session validation internally; sessions expire; database sessions invalidated on signout | IMPLEMENTED |
| S-03 | Attacker calls cron endpoint to trigger mass task status updates | Cron Route Handler | MEDIUM | HIGH | `guardCron(request)` validates `Authorization: Bearer CRON_SECRET` header; secret is from `lib/env.ts` and rotated per environment | IMPLEMENTED |

### T — Tampering

| ID | Threat | Component | Likelihood | Impact | Mitigation | Status |
|----|--------|-----------|-----------|--------|------------|--------|
| T-01 | SQL injection via task title or description fields | CreateTaskSchema, UpdateTaskSchema, Prisma DAL | LOW | CRITICAL | Prisma parameterized API: `prisma.task.create({ data: { title: parsed.title } })` — Prisma never interpolates user values into SQL strings | IMPLEMENTED |
| T-02 | User submits unexpected field types (type confusion attack) | CreateTaskSchema Zod | MEDIUM | MEDIUM | Strict Zod schema: `z.object({ title: z.string().min(1).max(200), dueDate: z.date().optional(), status: z.enum(["TODO","IN_PROGRESS","DONE"]) })` — `.strict()` rejects extra fields | IMPLEMENTED |
| T-03 | User modifies another user's task via crafted taskId | updateTask Server Action | MEDIUM | HIGH | Prisma query: `where: { id: parsed.taskId, userId: session.user.id }` — query returns null if userId doesn't match, preventing the update | IMPLEMENTED |
| T-04 | Cron job modifies tasks for users who have opted out | Cron job DAL query | LOW | MEDIUM | Cron query filters by `optOutCron: false` flag on user record; flag checked before any mutation | IMPLEMENTED |

### R — Repudiation

| ID | Threat | Component | Likelihood | Impact | Mitigation | Status |
|----|--------|-----------|-----------|--------|------------|--------|
| R-01 | User denies creating a task (false accusation or account compromise investigation) | audit_log | MEDIUM | MEDIUM | `audit_log.create({ actorId: session.user.id, actorEmail: session.user.email, action: "task.create", entityType: "Task", entityId: task.id })` on every task creation | IMPLEMENTED |
| R-02 | User denies deleting a task | audit_log | MEDIUM | HIGH | `audit_log.create({ action: "task.delete", entityId: taskId })` on every deletion; soft delete retains record for 30 days | IMPLEMENTED |
| R-03 | audit_log entries deleted to cover tracks | Prisma audit_log model | LOW | HIGH | No delete operation exists on audit_log; DB role has INSERT only on audit_log table; no Server Action exposes a delete mutation | IMPLEMENTED |

### I — Information Disclosure

| ID | Threat | Component | Likelihood | Impact | Mitigation | Status |
|----|--------|-----------|-----------|--------|------------|--------|
| I-01 | User A retrieves User B's tasks by guessing task IDs (IDOR) | getTask, getAllTasks Server Actions | HIGH (without mitigation) | HIGH | All task queries include `where: { userId: session.user.id }` — returns empty/null if task belongs to another user; 404 returned (not 403) | IMPLEMENTED |
| I-02 | Stack trace exposed in error response reveals Prisma query structure | catch blocks in Server Actions | MEDIUM | MEDIUM | All catch blocks: `return { error: "An internal error occurred" }`; error logged internally with `console.error("[sync]", { action: "task.create", error: String(error) })` | IMPLEMENTED |
| I-03 | PII leaked in audit_log metadata (task title may contain user's name) | audit_log metadata field | LOW | MEDIUM | metadata contains only `{ status: "created" }` — task title and content never logged; only structural metadata | IMPLEMENTED |
| I-04 | Task data exposed in error messages when task not found | getTask Server Action | LOW | LOW | Returns `{ error: "Not found" }` for both not-found and unauthorized cases — no information about whether the task exists | IMPLEMENTED |

### D — Denial of Service

| ID | Threat | Component | Likelihood | Impact | Mitigation | Status |
|----|--------|-----------|-----------|--------|------------|--------|
| D-01 | User creates thousands of tasks to exhaust database storage | createTask Server Action | MEDIUM | MEDIUM | `prisma.task.count({ where: { userId: session.user.id } })` checked before creation; users limited to 500 active tasks; error returned if limit exceeded | IMPLEMENTED |
| D-02 | Oversized task title or description exhausts server memory | CreateTaskSchema | MEDIUM | LOW | Zod: `title: z.string().max(200)`, `description: z.string().max(2000)` — Vercel request size limit also applies | IMPLEMENTED |
| D-03 | getAllTasks called without pagination returns unbounded result | getAllTasks Server Action | LOW (UI controlled) | MEDIUM | `prisma.task.findMany({ take: 50, skip: offset })` — pagination enforced in DAL; no unbounded query path | IMPLEMENTED |
| D-04 | Attacker floods cron endpoint without valid CRON_SECRET | Cron Route Handler | MEDIUM | LOW | guardCron() throws immediately for invalid header; no business logic executed; Vercel rate limits also apply | IMPLEMENTED |

### E — Elevation of Privilege

| ID | Threat | Component | Likelihood | Impact | Mitigation | Status |
|----|--------|-----------|-----------|--------|------------|--------|
| E-01 | User supplies another userId in request body to access that user's tasks | createTask, updateTask, deleteTask | HIGH (common attack) | CRITICAL | `userId` is NOT in the Zod input schema for any mutation; it is sourced exclusively from `session.user.id`; any client-supplied userId field is stripped by Zod `.strict()` | IMPLEMENTED |
| E-02 | User escalates from VIEWER to EDITOR role by sending a role field | CreateTaskSchema, UpdateTaskSchema | MEDIUM | HIGH | Role/permission fields are not in any input schema; roles are read from the database on every request, never from client input | IMPLEMENTED |
| E-03 | Compromised cron job runs with elevated DB permissions | Cron job → Prisma connection | LOW | HIGH | Cron job uses the same Prisma connection as the application; it does NOT have a separate elevated role; its mutations are scoped to the system operation only | IMPLEMENTED (limited blast radius) |

---

## Open Threats

| ID | Description | Risk Level | Disposition | Notes |
|----|-------------|-----------|-------------|-------|
| OT-01 | No rate limiting on createTask Server Action — authenticated user can create 500 tasks rapidly to hit the per-user limit and potentially degrade performance for shared infrastructure | MEDIUM | MITIGATING_CONTROL_PLANNED | Ticket created for rate limiting middleware (user-level, not IP-level) in next sprint. Per-user task limit (500) provides partial mitigation. |

---

## Threat Model Sign-off

- [x] All 6 STRIDE categories analyzed
- [x] All trust boundaries documented
- [x] All assets classified
- [x] All threats have a mitigation or open-threat disposition
- [x] No MISSING mitigations for HIGH/CRITICAL impact threats
- [x] Threat model reflects the current implementation (verified against source code)
