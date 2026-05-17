# Task Handoff Package
## Task: [TASK-NNN] — [Title]
## Recipient: [Agente04_DevBackend / Agente05_DevFrontend]
## From: Agente03_SoftwareEngineer
## Plan ID: [plan-id]

---

## Task Context

**What this task does:**
[1-2 sentence summary of what the dev agent must implement]

**Why it exists:**
[Which PRD acceptance criterion or architectural decision requires this task]

**What has been completed before this task:**
| Prerequisite Task | What It Produced |
|-------------------|-----------------|
| TASK-XXX | [e.g., "tasks table in PostgreSQL with all columns"] |
| TASK-YYY | [e.g., "Task Prisma model in schema.prisma"] |

**What must NOT be done in this task:**
- [Constraint 1 — e.g., "Do not modify the Prisma schema — that is TASK-002's responsibility"]
- [Constraint 2 — e.g., "Do not implement the UI — that is TASK-005"]
- [Constraint 3 — e.g., "Do not invent new API endpoints — follow API_Contract.json exactly"]

---

## File to Create/Modify

```
[exact/relative/path/to/file.ts]
```

This task touches **exactly one file**. Do not create or modify other files.

---

## Architecture References

| Section | Relevance |
|---------|-----------|
| [Architecture.md § Section Name] | [Why this section applies to this task] |
| [Architecture.md § Section Name] | [Why this section applies to this task] |

---

## API Contract Reference

_Applies when this task implements or consumes an API endpoint._

```
[METHOD] [/path/to/endpoint]

Request:
[request schema summary]

Response (success):
[response schema summary]

Response (error):
[error schema summary]
```

Full contract: `API_Contract.json#/paths/[path]`

---

## DB Schema Reference

_Applies when this task reads from or writes to the database._

**Tables/Models used:**
- `[table_name]` — [fields this task reads or writes]
- `[table_name]` — [fields this task reads or writes]

Full schema: `prisma/schema.prisma` or `DB_Schema.sql`

---

## Function Signatures (Pre-Specified)

The dev agent must implement these exact signatures. Do not change signatures without escalating to Tech Lead.

```typescript
[function signature 1]
[function signature 2]
[type definitions]
```

---

## Acceptance Criteria

All criteria must be verifiably true before this task is marked complete.

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]
- [ ] [Criterion 4]

---

## Test Requirements

**Unit Tests (Vitest):**
- Required: [true/false]
- Test file: `[test file path]`
- Coverage target: [N]%
- Mock: [what to mock]

**Integration Tests (Vitest):**
- Required: [true/false]
- Test file: `[test file path]`
- Setup: [database/auth setup needed]

**E2E Tests (Playwright):**
- Required: [true/false]
- Test file: `[spec file path]`
- Flow: [user flow description]

---

## Security Requirements

| Requirement | Required | Details |
|------------|---------|---------|
| Authentication | [true/false] | [Auth method — NextAuth getServerSession] |
| Authorization | [true/false] | Level: [public/authenticated/role-based/admin] |
| Input validation (Zod) | [true/false] | Schema: `[ZodSchemaName]` |
| Audit log | [true/false] | Event: `[event.type]` |
| guardCron() | [true/false] | Must be first call in handler |
| DevSecOps review | [true/false] | |

**Security notes:** [Specific guidance]

---

## Golden Path Reminders

Based on the task type `[type]`, these Golden Path rules apply:

**For `backend` tasks:**
- [ ] Use `lib/env.ts` for all environment variables — never `process.env`
- [ ] Validate all user inputs with Zod at function entry
- [ ] Write to `audit_log` before returning from mutations
- [ ] Use NextAuth `getServerSession` for authentication checks
- [ ] Use Prisma 7 with PrismaPg adapter for all database operations

**For `frontend` tasks:**
- [ ] Server Components are the default — use Client Components only when interactivity is required
- [ ] Data fetching order: Server Component first, then Server Action, then SWR (polling only)
- [ ] Never use `middleware.ts` — use `proxy.ts` if request interception is needed

**For `database` tasks:**
- [ ] Use `prisma migrate deploy` in staging/production — never `prisma db push`
- [ ] Use `prisma migrate dev` only in local development

**For `infrastructure` / cron tasks:**
- [ ] `guardCron()` must be the first call in every cron handler

---

## Definition of Done (for this task)

This task is complete when ALL of the following are true:

- [ ] File created/modified at exact path specified
- [ ] Function signatures match pre-specified contracts
- [ ] All acceptance criteria verified
- [ ] Unit tests written and passing (if required)
- [ ] Integration tests written and passing (if required)
- [ ] E2E tests written and passing (if required)
- [ ] Security requirements satisfied
- [ ] Golden Path constraints complied with
- [ ] No new files created outside the specified file_path
- [ ] No new endpoints or schema changes introduced
- [ ] TypeScript compiles without errors
