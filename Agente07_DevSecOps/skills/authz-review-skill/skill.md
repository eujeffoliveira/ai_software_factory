# Skill: authz-review-skill

## Purpose

Validate authentication and authorization patterns in all Server Actions, Route Handlers, and Cron Route Handlers. Checks for: auth() as first operation, session guard, resource ownership (IDOR prevention), and userId source from session only.

## When to Use

Every Gate 5 evaluation — mandatory. All protected routes must be verified.

## Inputs

- All Server Action files (`features/*/actions/*.ts`)
- All Route Handler files (`app/api/**/route.ts`)
- All Cron Route Handler files (`app/api/cron/**/route.ts`)
- `lib/auth.ts` — to understand the auth() function contract

## Outputs

- Auth/authz review report: PASS or FAIL per route
- CRITICAL findings (SEC-NNN) for missing auth checks, IDOR, userId from request

## Constraints

- Check auth() position — it must be FIRST, not just present
- Verify session guard halts execution (returns or throws) — not just logs
- Verify ownership in every Prisma query on user-owned data (not just a general check)
- Check that userId is sourced from session in EVERY assignment, not just the first one

## Steps

1. List all Server Actions, Route Handlers, and Cron Routes in scope
2. For each: verify auth() is first operation, session guard returns/throws, input schema excludes identity fields
3. For each Prisma query on user-owned data: verify `userId: session.user.id` in where clause
4. Search for userId/actorId assignments — verify all source from session
5. Verify guardCron() is first call in all cron routes
6. Produce per-route table and findings

## Knowledge Access Policy

At runtime, reads from:
- `Agente07_DevSecOps/knowledge/decision_rules.md` → DR002, DR010, DR011
- `Agente07_DevSecOps/knowledge/knowledge_cards.md` → Card 003 (IDOR), Card 012 (auth pattern), Card 011 (guardCron)
- `Agente07_DevSecOps/knowledge/heuristics.md` → H1, H2, H3
- `Agente07_DevSecOps/checklists/authz_checklist.md`

Do NOT access `context/` or `lib/` at runtime.
