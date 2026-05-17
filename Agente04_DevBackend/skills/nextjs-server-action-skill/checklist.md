# nextjs-server-action-skill — Execution Checklist

Run this checklist after producing a Server Action file before marking the skill as complete.

---

## Pre-Execution

- [ ] `action_name` is specified and follows camelCase convention
- [ ] `file_path` is inside `features/*/actions/` — not in route.ts or root
- [ ] `input_fields` list is available from task spec or API contract
- [ ] `return_type` is specified from task spec or API contract
- [ ] DAL file exists for the relevant Prisma model (or will be created first)

## Implementation Checks

- [ ] `"use server"` is the first line of the file
- [ ] Zod schema defined at MODULE LEVEL — before the function body
- [ ] Schema variable name follows `[ActionName]Schema` convention
- [ ] Type inferred with `z.infer<typeof [ActionName]Schema>` — not written manually
- [ ] All field constraints match API contract (min/max lengths, enums, required/optional)
- [ ] Function parameter is typed as `unknown`: `rawInput: unknown`
- [ ] Function return type declared: `Promise<ReturnType>`

## Auth and Authorization

- [ ] `const session = await auth()` is the FIRST statement in the function body
- [ ] Null/undefined check immediately after: `if (!session?.user?.id) throw new Error("Unauthorized")`
- [ ] If resource ownership required: resource fetched, `resource.userId === session.user.id` verified
- [ ] `userId` assigned from `session.user.id` — never from `input`

## Input Validation

- [ ] `.parse()` called (not `.safeParse()`) — Server Actions throw on invalid
- [ ] `.parse()` is before any business logic
- [ ] ZodError will propagate to the outer catch block

## Data Access

- [ ] DAL imported from `@/lib/db/[model].dal` — not `@/lib/db/prisma`
- [ ] No `prisma.*` calls anywhere in this file
- [ ] DAL method called with correctly typed arguments

## Audit Log

- [ ] `auditLog()` called inside `try` block, AFTER successful DB operation
- [ ] `actorId: session.user.id` — from session
- [ ] `actorEmail: session.user.email ?? ""` — from session
- [ ] `action` is PAST_TENSE_VERB in SCREAMING_SNAKE_CASE
- [ ] `entityType` matches Prisma model name
- [ ] `entityId` is the created/updated/deleted record's ID
- [ ] `metadata` contains relevant context (no passwords, tokens, PII beyond what's audited by policy)

## Error Handling

- [ ] `try/catch` wraps the business logic (not the auth check or Zod parse)
- [ ] `catch` block logs with context: `console.error("[actionName] failed:", { error, userId, ... })`
- [ ] `catch` block throws generic: `throw new Error("Operation failed. Please try again.")`
- [ ] Raw `error` or `error.message` is NOT thrown to the caller

## Runtime Knowledge Policy

This skill's checklist must be run using only:
- This checklist file
- `Agente04_DevBackend/context_view.md §3` (Server Action Pattern)
- `Agente04_DevBackend/knowledge/` (principles.md, heuristics.md, decision_rules.md)
- `Agente04_DevBackend/examples/good_server_action.ts` (reference implementation)

Do NOT consult `context/`, `lib/`, or any PDF at runtime.
