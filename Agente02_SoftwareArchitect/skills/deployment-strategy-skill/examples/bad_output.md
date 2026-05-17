# Bad Output — deployment-strategy-skill

## Scenario

Same job board SaaS. 1 cron job: nightly score sync.

## Produced Deployment_Strategy.md (problematic excerpt)

```
## Deployment

We deploy to Vercel. The database is on Supabase.

To update the database schema, run:
  npx prisma db push --accept-data-loss

For the cron job, add it to vercel.json:
  {
    "crons": [{ "path": "/api/cron/nightly-score-sync", "schedule": "0 2 * * *" }]
  }

Rollback: if something goes wrong, redeploy the previous version.

## Tests

Test in staging before deploying to production.
```

## Problems identified

| # | Problem | Rule violated |
|---|---------|--------------|
| 1 | `prisma db push --accept-data-loss` for database updates — this is explicitly forbidden in staging and production | Must use `prisma migrate deploy` for staging/prod; `prisma db push` is local only |
| 2 | `--accept-data-loss` flag used — this silently drops data without any safety check | DESTRUCTIVE by design; if used in prod it can cause irreversible data loss |
| 3 | No environment table — local, staging, and production not separately defined | Three environments required with distinct migration commands per environment |
| 4 | Cron job added to vercel.json but no `guardCron()` mentioned | Every cron route handler must call `guardCron(request)` — without it any external caller can trigger the job |
| 5 | No `CRON_SECRET` env var documented | `guardCron()` requires `CRON_SECRET` to be set per environment |
| 6 | Rollback: "redeploy the previous version" — vague and non-actionable | Rollback plan must specify: Vercel Instant Rollback, RTO (< 5 minutes), authorization, and database rollback procedure |
| 7 | No database rollback plan | Must include rollback SQL or reference to phased plan for the migration risk level |
| 8 | "Test in staging before deploying to production" is not a smoke test | Smoke tests must name specific endpoints and expected outcomes |
| 9 | No environment variables documented | All required env vars must be listed per environment with `lib/env.ts` validation confirmed |

## Gate result

`BLOCKED_PENDING_HUMAN` at Gate 6 — rollback plan is not actionable, and `prisma db push --accept-data-loss` in production is a critical violation that requires immediate revision. The Tech Lead cannot approve Gate 6 without:
1. An actionable rollback plan (Vercel Instant Rollback + database rollback procedure)
2. Migration command corrected to `prisma migrate deploy` for staging and production
3. `guardCron()` documented for the cron route handler
4. Specific post-deployment smoke tests defined

Skill must rerun with full Architecture.md and migration risk analysis as inputs.
