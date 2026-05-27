# nextjs-server-action-skill

## Purpose

Implements a Server Action following the Golden Path pattern. Server Actions are the primary mechanism for mutations in Next.js 16 App Router — they run on the server, can be called from both Server and Client Components, and are the only place where sensitive operations should be performed on behalf of a user.

## When to Use

- Any mutation operation triggered from a Server Component or Client Component: create, update, delete, approve, reject, archive, transfer
- When the operation requires authentication and belongs to a feature domain
- When the task type is `server-action` in the atomic task block
- When `API_Contract.json` documents the operation as a Server Action (not a Route Handler)

Do NOT use this skill for:
- Read-only data fetching (use Server Components or Server Actions for reads when needed)
- REST endpoints consumed by external clients (use `nextjs-route-handler-skill`)
- Cron jobs (use `cron-job-implementation-skill`)

## Inputs

| Input | Source | Required |
|-------|--------|---------|
| `action_name` | Atomic task spec — `function_signatures` | Yes |
| `file_path` | Atomic task spec — `file_path` (must be `features/*/actions/*.ts`) | Yes |
| `input_fields` | API contract or task spec — field definitions | Yes |
| `return_type` | Atomic task spec or API contract — response schema | Yes |
| `auth_required` | Security requirements in task spec | Yes |
| `audit_event_type` | Task spec security requirements | Yes (for mutations) |
| `dal_reference` | `lib/db/[model].dal.ts` for the relevant model | Yes (if DB involved) |

## Outputs

- TypeScript file at `features/[domain]/actions/[actionName].ts`
- Module-level Zod schema for input validation
- Exported async function with typed parameters and return type
- `auditLog()` call after successful DB operation (for CREATE/UPDATE/DELETE)

## Procedure

1. **Write `"use server"` directive** — first line, required for Server Actions
2. **Import dependencies** — `auth` from `@/lib/auth`, `z` from `zod`, DAL, `auditLog`, and `env` if needed
3. **Define Zod schema at module level** — `const [ActionName]Schema = z.object({ ... })` with constraints from API contract
4. **Infer TypeScript type** — `type [ActionName]Input = z.infer<typeof [ActionName]Schema>`
5. **Export async function** — typed `rawInput: unknown`, typed return `Promise<ReturnType>`

   Structure: steps 6–7 are **OUTSIDE** try/catch (auth and parse errors must propagate directly). Steps 8–10 are **INSIDE** try/catch (business logic errors are caught and re-thrown as generic messages).

6. **Auth check first (OUTSIDE try/catch)** — `const session = await auth(); if (!session?.user?.id) throw new Error("Unauthorized")`
7. **Parse input (OUTSIDE try/catch)** — `const input = [ActionName]Schema.parse(rawInput)` — throws ZodError on invalid; callers receive structured validation errors
8. **Authorization check (INSIDE try/catch, if needed)** — fetch resource, verify `resource.userId === session.user.id`, throw "Forbidden" if not
9. **Business logic via DAL (INSIDE try/catch)** — call DAL function — NEVER call `prisma` directly
10. **Call `auditLog()` (INSIDE try/catch)** — AFTER success, actorId/actorEmail from session
11. **Return result** with TypeScript return type
12. **catch block** — log internal error details, throw generic message to caller (never expose raw error.message)

## Quality Gate

Before marking the skill complete, verify `checklists/nextjs-server-action-skill/checklist.md`.

Gate 4 checks for this skill output:
- `backend_quality_checklist.md` — code structure, validation, auth, security, logging, tests
- `authz_checklist.md` — auth check first, resource ownership, session-sourced IDs
- `audit_log_checklist.md` — called after success, PAST_TENSE_VERB, session IDs

## Failure Modes

| Mode | Symptom | Fix |
|------|---------|-----|
| FM-01 | Logic in route.ts because this action was added there instead | Move to `features/[domain]/actions/` |
| FM-02 | Raw `req.json()` or `input as Type` instead of Zod | Add module-level schema, call `.parse()` |
| FM-03 | `await auth()` missing or called after parsing | Move auth check to first line |
| FM-07 | No `auditLog()` for CREATE/UPDATE/DELETE | Add after successful DB operation |
| FM-10 | `error.message` thrown to caller without wrapping | Catch internally, throw generic |

## RAG Collections Permitted

These collection names refer to pre-distilled content available in `Agente04_DevBackend/knowledge/` — they are not runtime reads of external sources. The Knowledge Access Policy applies.

- `backend_engineering` → distilled into `knowledge/principles.md` and `knowledge/knowledge_cards.md`
- `nodejs_patterns` → distilled into `knowledge/knowledge_cards.md`
- `clean_code` → distilled into `knowledge/heuristics.md`

## Architecture Compliance

This skill's output must comply with:
- File location: `features/[domain]/actions/[actionName].ts` — no other location is valid
- First line: `"use server"` — required directive
- Auth check: `await auth()` as first statement in function body
- Data access: through DAL only — no `import { prisma }` allowed in this file
- `auditLog()` required for all mutations on user data

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:
- its local files (`skill.md`, schemas, checklist, examples)
- `Agente04_DevBackend/knowledge/`
- `Agente04_DevBackend/context_view.md`
- project artifacts provided as input (atomic task, API contract, Prisma schema)

Any theoretical knowledge required by this skill must be pre-distilled during build-time in `knowledge/`.
