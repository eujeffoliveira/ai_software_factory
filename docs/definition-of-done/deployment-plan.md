# Definition of Done — Deployment_Plan.md

## Overview

The Deployment Plan is the authoritative record of how the system moves from a tested artifact to a running production service. It specifies the CI/CD pipeline configuration, the rollback procedure, environment variable management, monitoring and alerting setup, and the explicit human approval gate that must occur before any production deployment proceeds. No deployment happens without a documented rollback plan and an explicit human sign-off.

## Owner Agent

- **Primary:** `@devops` (Agente08_DevOps)
- **Gate:** Gate 6 — Deploy Review

## Required Fields / Sections

### Deployment Pipeline (CI/CD)
- [ ] CI/CD platform is identified (e.g., GitHub Actions, Vercel CI)
- [ ] Pipeline configuration file is committed to the repository (e.g., `.github/workflows/deploy.yml`)
- [ ] Pipeline stages are defined in order: lint → test → build → deploy-staging → (human approval) → deploy-production
- [ ] Every stage has a defined pass/fail condition
- [ ] Test stage runs the full test suite (unit + integration) before any deployment proceeds
- [ ] Build artifacts are reproducible — same source produces same artifact
- [ ] Staging deployment is automatic on merge to main; production deployment requires the human approval gate
- [ ] Pipeline execution time is measured and documented (to set expectations for the team)

### Human Approval Gate
- [ ] An explicit human approval step is defined in the pipeline before production deployment
- [ ] The approval step cannot be bypassed by a pipeline re-run or force-push
- [ ] Approval responsibility is assigned to a named role (e.g., Tech Lead, Release Manager)
- [ ] The approval request includes: artifact version, staging test results summary, rollback plan reference
- [ ] A deployment without human approval is treated as an incident

### Environment Variable Management
- [ ] All environment variables are documented with: name, description, required/optional, environment (dev/staging/production)
- [ ] No secrets are stored in the repository or CI/CD pipeline logs
- [ ] Secrets management platform is specified (e.g., Vercel Environment Variables, AWS Secrets Manager)
- [ ] The `lib/env.ts` Zod schema validates all required variables at application startup
- [ ] Procedure for rotating a secret is documented (rotation does not require redeployment if possible)
- [ ] Staging and production environments use separate secret values — no shared secrets across environments
- [ ] New environment variables added in this deployment are documented and provisioned in all target environments before deployment

### Rollback Plan
- [ ] Rollback procedure is documented step by step
- [ ] Rollback is achievable within a defined time target (e.g., < 15 minutes)
- [ ] Database migration rollback procedure is documented (down migrations or compensating migration)
- [ ] The rollback procedure has been tested in staging — not just written
- [ ] Rollback decision criteria are defined: what metrics or errors trigger a rollback
- [ ] Person responsible for executing a rollback is identified by role
- [ ] Post-rollback verification steps are documented

### Staging Validation
- [ ] Deployment to staging is verified before the production gate opens
- [ ] Staging environment uses production-equivalent configuration (not mocked services)
- [ ] Smoke tests run automatically after staging deployment
- [ ] Smoke test results are attached to the deployment approval request
- [ ] Staging has been running the new version for a defined minimum period before production approval is granted (e.g., 30 minutes)

### Monitoring and Alerting
- [ ] Application performance monitoring (APM) is configured for production
- [ ] Error rate alert is defined: threshold, notification channel, on-call owner
- [ ] Response time alert is defined: threshold matches PRD NFRs, notification channel
- [ ] Availability check (uptime monitoring) is configured
- [ ] Database connection pool alert is defined if applicable
- [ ] Cron job failure alert is configured for each scheduled job
- [ ] Alert runbook reference is included (links to the operational Runbook.md)
- [ ] All alerts are tested in staging before the production deployment gate

### Database Migration Plan
- [ ] All schema changes are covered by committed migration files (`prisma/migrations/`)
- [ ] `prisma db push` is not used in any environment — only `prisma migrate deploy`
- [ ] Migration execution is part of the deployment pipeline (runs automatically before the application starts)
- [ ] Destructive migrations (column drops, table drops) use a phased approach:
  - Phase 1: deploy code that handles both old and new schema
  - Phase 2: run migration that adds new structure
  - Phase 3: backfill data
  - Phase 4: deploy code that uses only new structure
  - Phase 5: run migration that removes old structure
- [ ] Estimated migration duration is documented for any migration on a large table (> 100,000 rows)
- [ ] Long-running migrations are tested on a production-sized dataset in staging

### Handoff Package
- [ ] `required_next_agent` set to `"Agente00_TechLead"` (for final pipeline closure or next cycle)
- [ ] `gate_ready` set to `true`
- [ ] `pipeline_config_path` populated
- [ ] `rollback_plan_tested` set to `true`
- [ ] `staging_validation_passed` set to `true`
- [ ] `human_approval_required` set to `true`
- [ ] `monitoring_configured` set to `true`

## Acceptance Criteria

| Criterion | How to verify |
|-----------|---------------|
| CI/CD pipeline config committed | File exists at `.github/workflows/deploy.yml` or equivalent; stages are readable |
| Human approval step in pipeline | Read pipeline config; production deployment stage must have an approval job that cannot be bypassed |
| Rollback procedure documented | Rollback section exists with numbered steps; each step is specific and actionable |
| Rollback tested in staging | `rollback_plan_tested: true` in handoff package; staging test evidence attached |
| All env vars documented | Environment variables table exists; every variable in `lib/env.ts` Zod schema appears in the table |
| No secrets in repository | Secrets scan confirms no secrets in source; CI/CD logs do not print secret values |
| Monitoring alerts configured | Alert configuration file or dashboard screenshot attached; all defined thresholds are in place |
| Migration files committed | `prisma/migrations/` directory contains a migration file for every schema change in this release |
| Smoke tests pass on staging | Smoke test results attached; all tests pass |

## Related Gates

- **Prerequisite:** Gate 5 approved (Security_Audit.md must be approved before deployment planning)
- **This gate:** Gate 6 — Deploy Review (evaluated by Agente00_TechLead with mandatory human approval before production push)
- **Unblocks:** Gate 7 — Post-Deploy Monitoring (system runs in production; Agente08_DevOps monitors)

## Gate 6 Status Codes

| Code | Meaning |
|------|---------|
| `APPROVED` | Deployment plan meets all criteria; pipeline advances; production deployment awaits human approval |
| `RETURNED_FOR_REVISION` | Plan has gaps (missing rollback, untested migration, missing alerts) |
| `BLOCKED_NO_ROLLBACK_PLAN` | No rollback procedure exists; deployment cannot proceed without one |
| `BLOCKED_PENDING_HUMAN_APPROVAL` | Plan is approved but production deployment is waiting for explicit human sign-off |

## Failure Examples

- **FAIL:** The deployment plan does not include a rollback procedure. "We can redeploy the previous version" is not a rollback plan — the specific steps, commands, and database rollback procedure must be documented.
- **FAIL:** The CI/CD pipeline deploys directly to production on merge to main with no human approval step. This violates the mandatory human approval gate.
- **FAIL:** `DATABASE_URL` is committed to `.github/workflows/deploy.yml` as a plaintext value. This is a secrets exposure.
- **FAIL:** The migration adds a `NOT NULL` column to a table with 500,000 rows. The migration duration was not estimated and the migration was not tested on a production-sized dataset. This is a production risk.
- **FAIL:** Monitoring is described as "we use Vercel Analytics" with no alert thresholds defined. Monitoring that does not alert is not monitoring.
- **FAIL:** The rollback plan says "run the down migration" but no down migration has been written, and the migration type (additive) means a down migration would drop data.

## When to Block

Issue `BLOCKED_NO_ROLLBACK_PLAN` when the rollback procedure is absent, untested, or covers only the application layer without addressing database migration rollback.

Issue `BLOCKED_PENDING_HUMAN_APPROVAL` when the plan is technically complete but the human approval gate has not been satisfied — the pipeline is paused at this state until approval is received.

Return `RETURNED_FOR_REVISION` when:
- The CI/CD pipeline configuration is not committed to the repository
- Any required environment variable is missing from the documentation or has not been provisioned in the target environment
- Monitoring alerts have no defined thresholds or notification channels
- Smoke tests have not been run on staging
- A destructive migration does not follow the phased approach

Issue `APPROVED` (with pipeline pause at human approval gate) only when every checkbox is checked, the rollback has been tested in staging, and monitoring alerts are fully configured.
