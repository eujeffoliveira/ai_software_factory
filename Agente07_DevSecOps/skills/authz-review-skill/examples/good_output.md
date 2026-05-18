# Good Output — Authz Review Skill

**PASS — 3 routes reviewed:**
- `features/tasks/actions/create-task.action.ts` — auth() line 3, guard line 4, userId from session line 8 ✅
- `features/tasks/actions/delete-task.action.ts` — auth() line 3, guard line 4, Prisma `where: { id: taskId, userId: session.user.id }` line 14 ✅
- `app/api/cron/mark-overdue/route.ts` — guardCron() line 7 (FIRST), no userId concern (system operation) ✅

All 3 routes pass auth/authz checks.
