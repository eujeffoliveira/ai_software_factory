# cron-job-implementation-skill — Execution Checklist

---

## Route File

- [ ] `export const dynamic = "force-dynamic"` present
- [ ] `guardCron(req)` is the FIRST statement in handler body
- [ ] No code before `guardCron(req)` — not even variable declarations
- [ ] `startedAt = Date.now()` captured BEFORE try block
- [ ] `syncLog()` is in `finally` block — NOT only in try
- [ ] Return `Response.json({ ok: status !== "error" })`

## Job Function

- [ ] Job function is in `lib/jobs/[job-name].ts`
- [ ] Job returns `{ counts: { processed, created, updated, failed } }`
- [ ] Job uses `upsert` or existence check — NOT bare `create`
- [ ] No external API calls inside `prisma.$transaction`

## Idempotency

- [ ] Running job twice on same data produces same result
- [ ] No duplicate records created on retry

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md §5`, `templates/Cron_Route_Template.ts`, `knowledge/decision_rules.md` (DR004, DR005, DR007).  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
