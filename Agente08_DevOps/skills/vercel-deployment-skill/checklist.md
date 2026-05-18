# vercel-deployment-skill Checklist

## Pre-Execution
- [ ] `staging_deployment_url` is accessible (not 404)
- [ ] `target_commit_sha` is a valid git SHA
- [ ] Deployment platform is Vercel (if not → return ADR_REQUIRED immediately)

## Execution
- [ ] `vercel.json` read (if present) — cron paths extracted
- [ ] All `app/api/cron/*/route.ts` files located
- [ ] Each cron handler checked: `guardCron(request)` is the FIRST call
- [ ] Each cron handler checked: `syncLog()` called in `finally` block
- [ ] No secrets in `vercel.json` (env vars referenced by name only)
- [ ] Deployment steps produced (Steps 1–10 for Deployment_Plan.md)

## Post-Execution
- [ ] All cron routes with missing `guardCron()` listed as blocking issues
- [ ] `status` field set correctly
- [ ] Cron inventory complete with all routes and their schedule

## Runtime Knowledge Policy
Read from `Agente08_DevOps/` only. Context: `context_view.md` Section 2. Cards: 002, 007. Rules: DR009, DR014.
