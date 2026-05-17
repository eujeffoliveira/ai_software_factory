# SQL Safety Checklist

**When to run:** Before every Gate 4 submission for any file that touches the database.  
**Run by:** Agente04_DevBackend using `sql-safety-review-skill`.  
**If any CRITICAL or HIGH finding:** Block Gate 4 submission — fix first.

---

## String Concatenation in Queries

- [ ] No `+` string concatenation in any Prisma query call
- [ ] No template literal interpolation in `prisma.$queryRaw()` — e.g., no `` prisma.$queryRaw(`SELECT * WHERE id = ${userId}`) ``
- [ ] No template literal interpolation in `prisma.$executeRaw()` — e.g., no `` prisma.$executeRaw(`UPDATE tasks SET ...${value}`) ``
- [ ] Search for pattern: `queryRaw\`` or `executeRaw\`` — any backtick after raw = potential injection

## Prisma Parameterized API Usage

- [ ] All find operations use Prisma `where` object — not manual SQL strings
  - Correct: `prisma.task.findMany({ where: { userId, status } })`
  - Wrong: `prisma.$queryRaw("SELECT * FROM tasks WHERE user_id = " + userId)`
- [ ] All updates use Prisma `data` object — not manual SET clauses
- [ ] All creates use Prisma `data` object — not manual INSERT

## If $queryRaw is Unavoidable (Rare Edge Cases)

- [ ] `Prisma.sql` template tag used — not bare string interpolation
  - Correct: `` prisma.$queryRaw(Prisma.sql`SELECT * FROM tasks WHERE id = ${id}`) ``
  - Wrong: `` prisma.$queryRaw(`SELECT * FROM tasks WHERE id = ${id}`) ``
- [ ] User input validated with Zod BEFORE reaching the `$queryRaw` call
- [ ] Only scalar values (string, number, boolean) interpolated — never raw SQL fragments

## Input Validation Before DB Reach

- [ ] Every query parameter sourced from user input is Zod-validated before the DAL call
- [ ] No unvalidated `req.query`, `req.params`, or `req.body` fields reach a DB operation
- [ ] Type coercion done in Zod schema (e.g., `z.coerce.number()`) — not manually in DAL

## Query Performance (Secondary — Not a Security Block)

- [ ] No `SELECT *` in performance-critical queries — use Prisma `select` for large tables
- [ ] No N+1 queries — no DAL call inside a loop iterating over query results
- [ ] Pagination applied to all list queries — no unbounded `findMany()` without `take`

## Output Review

After running `sql-safety-review-skill`, verify:
- [ ] `risk_level` is LOW (HIGH or CRITICAL blocks submission)
- [ ] `sql_injection_safe: true`
- [ ] `uses_only_parameterized: true`
- [ ] All findings resolved

---

## Risk Level Definitions

| Level | Meaning | Gate 4 Action |
|-------|---------|---------------|
| CRITICAL | SQL injection possible with user input | Block — fix immediately |
| HIGH | Unsafe raw SQL without Prisma.sql tag | Block — fix immediately |
| MEDIUM | Potential N+1 or performance risk | Document and fix if time allows |
| LOW | Minor style or performance note | Document, no block |

---

## Runtime Knowledge Policy

This checklist is part of the agent's local runtime knowledge.  
Do NOT consult `context/`, `lib/`, or global architecture documents.  
All required patterns are in `context_view.md §6`, `knowledge/decision_rules.md` (DR013), and `knowledge/heuristics.md` (H6).
