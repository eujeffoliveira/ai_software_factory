# Deployment Strategy Checklist

_Run before finalizing Deployment_Strategy.md._

---

## Environments

- [ ] All 4 environments defined: local, preview, staging, production
- [ ] Platform for each environment is specified (Vercel for staging and production)
- [ ] Secret isolation confirmed: each environment has independent secrets
- [ ] No mention of shared secrets between staging and production

## Migration Policy

- [ ] Source of truth is stated: Prisma schema + Prisma migrations
- [ ] Staging migration command: `prisma migrate deploy` ✅
- [ ] Production migration command: `prisma migrate deploy` ✅
- [ ] Prohibited commands listed: `prisma db push` (staging/prod), `prisma migrate dev` (real DB)
- [ ] Every pending migration is listed with risk classification
- [ ] Destructive migrations have phased execution plans
- [ ] Destructive migrations are flagged for human approval

## CI/CD Pipeline

- [ ] All mandatory CI steps listed: typecheck, lint, test, build
- [ ] Migration step included for staging/production deploys
- [ ] Build failure blocks deploy

## Cron Jobs

- [ ] All Vercel Cron jobs listed with schedule and endpoint
- [ ] guardCron() listed for every cron route
- [ ] Idempotency confirmed for all jobs
- [ ] sync_log write specified for all jobs
- [ ] vercel.json cron configuration format shown

## Rollback Plan

- [ ] Trigger conditions are defined (specific observable failure signals)
- [ ] Rollback steps are numbered and actionable
- [ ] Responsible person or role is identified
- [ ] Maximum decision time is specified
- [ ] Database impact is addressed: reversible / compatible / irreversible / destructive classification
- [ ] Post-rollback validation checklist is present
- [ ] Communication plan is present

## Healthcheck

- [ ] /api/health endpoint is in the deployment strategy
- [ ] Post-deploy smoke test includes healthcheck
- [ ] APM observation window is defined for critical deploys (≥15 minutes)

## Gate 6 Pre-conditions

- [ ] Rollback plan satisfies Gate 6 requirement
- [ ] Human approval requirement for production deploy is documented
- [ ] Destructive migrations are explicitly flagged for human approval before Gate 6
