# Authz Review Skill — Execution Checklist

## Runtime Knowledge Policy
Read `Agente07_DevSecOps/checklists/authz_checklist.md` and `Agente07_DevSecOps/knowledge/knowledge_cards.md` (Card 003, Card 011, Card 012) before executing. Do NOT access `context/` or `lib/`.

## Route Identification
- [ ] All Server Actions listed
- [ ] All Route Handlers listed
- [ ] All Cron Route Handlers listed

## Per Server Action / Route Handler
- [ ] auth() is FIRST operation (not 3rd, not inside a try block — FIRST)
- [ ] Session guard returns/throws immediately if !session
- [ ] No DB calls or business logic before auth check
- [ ] userId NOT in Zod input schema
- [ ] userId sources from session.user.id exclusively

## Resource Authorization (IDOR check)
- [ ] Every Prisma findUnique on user-owned data has `userId: session.user.id` in where
- [ ] Every Prisma findFirst on user-owned data has `userId: session.user.id` in where
- [ ] Every Prisma update on user-owned data has `userId: session.user.id` in where
- [ ] Every Prisma delete on user-owned data has `userId: session.user.id` in where

## Cron Routes
- [ ] guardCron(request) is FIRST call in every cron handler
- [ ] guardCron validates Authorization header vs CRON_SECRET from lib/env.ts
- [ ] No business logic before guardCron()

## Output
- [ ] status: PASS only if all routes pass all checks
- [ ] status: FAIL if any route has a missing auth check, IDOR, or userId from request
- [ ] Every finding has decision_rule DR002 (missing auth), DR010 (IDOR), or DR011 (userId from request)
