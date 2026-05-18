# Good Output — OWASP Review Skill

**All 10 categories reviewed with evidence. Example of A01 (PASS) and A03 (FAIL):**

A01 PASS: "Reviewed updateTask.action.ts, getTask.action.ts, deleteTask.action.ts. auth() is first call in all 3 (lines 3, 3, 3). Session guard present (lines 4-6 each). Prisma queries include `userId: session.user.id` in where clauses (updateTask line 18, getTask line 12, deleteTask line 9). No userId from request body. guardCron() present in cron/update-overdue/route.ts line 7."

A03 FAIL — SEC-003: "Raw SQL found at lib/db/reporting.dal.ts:34: `prisma.$queryRawUnsafe(\`SELECT * FROM tasks WHERE title LIKE '%${searchTerm}%'\`)` — user input `searchTerm` interpolated into SQL string. DR003 applies. CRITICAL finding."
