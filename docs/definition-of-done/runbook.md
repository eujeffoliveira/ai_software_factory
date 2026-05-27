# Definition of Done — Runbook.md (Operational Runbook)

## Overview

The Runbook is the operational reference document for a deployed system. It gives the on-call engineer everything needed to deploy, monitor, diagnose, and recover the system without needing to ask the original author. A runbook that omits rollback steps or failure scenarios is only useful when things are going well — which is exactly when it is not needed. A complete runbook is usable by someone who did not build the system.

## Owner Agent

- **Primary:** `@devops` (Agente08_DevOps)
- **Gate:** Gate 6 (produced alongside Deployment_Plan.md; reviewed before production deployment)

## Required Fields / Sections

### System Overview
- [ ] System name and version
- [ ] Architecture summary (1 paragraph: what the system does, its main components, and its external dependencies)
- [ ] Primary URL(s): production, staging, health check endpoint
- [ ] Deployment platform (e.g., Vercel, AWS, GCP) and region
- [ ] Repository URL and default branch
- [ ] Link to the latest approved Architecture.md

### On-Call Contacts
- [ ] Primary on-call role and notification channel (e.g., Slack `#alerts-prod`, PagerDuty)
- [ ] Escalation path: primary → secondary → tech lead (with names or role titles)
- [ ] External dependency contacts: each third-party service has a support URL or contact listed
- [ ] Timezone coverage noted if relevant
- [ ] Contact list is reviewed and updated with every release

### Deployment Procedure
- [ ] Prerequisites listed: required access, tools, and environment variables that must be set before deploying
- [ ] Step-by-step deployment commands, in order
- [ ] Expected output for each step (so the operator knows what success looks like)
- [ ] Database migration step is explicit — it comes before the application deployment step, not after
- [ ] Post-deployment verification steps listed (smoke tests, health check, key metrics to confirm)
- [ ] Estimated deployment duration documented
- [ ] Procedure has been tested — not just written

### Rollback Procedure
- [ ] Rollback decision criteria defined: which alerts or thresholds trigger a rollback decision
- [ ] Rollback is documented as numbered steps, not prose
- [ ] Rollback procedure includes: application rollback AND database migration rollback
- [ ] Database rollback procedure is specific: down migration command or compensating migration approach
- [ ] Rollback time target is stated (e.g., "rollback completes within 15 minutes of decision")
- [ ] Post-rollback verification steps listed
- [ ] Rollback procedure has been tested in staging

### Monitoring Checklist
- [ ] List of key metrics to check after every deployment (with expected normal ranges)
- [ ] Dashboard URL(s) for production monitoring
- [ ] Log query patterns for the most common investigation scenarios (e.g., "show all 500 errors in the last hour")
- [ ] Cron job execution check: how to verify each scheduled job ran successfully (sync_log query)
- [ ] Database connection pool status check documented
- [ ] External service health check documented (how to verify third-party APIs are reachable)

### Alert Response Procedures
Each alert that is configured must have a corresponding response procedure in this section.

For each alert:
- [ ] Alert name and trigger condition (metric, threshold, duration)
- [ ] Severity: P1 (immediate), P2 (respond within 1 hour), P3 (respond within 1 business day)
- [ ] First response steps (what to check immediately)
- [ ] Escalation trigger (when to page the next level)
- [ ] Resolution verification steps (how to confirm the alert is resolved)
- [ ] Post-incident requirement: P1 alerts require a post-mortem; P2 requires a root cause note

Required alerts that must have documented procedures:
- [ ] High error rate (5xx responses above threshold)
- [ ] Slow response time (p95 exceeding NFR threshold)
- [ ] Service unavailable / uptime check failure
- [ ] Database connection failure or pool exhaustion
- [ ] Cron job failure (if any cron jobs exist)
- [ ] Authentication service unavailable (if applicable)

### Common Failure Scenarios

Each scenario must have: symptom, probable cause, investigation steps, and remediation.

- [ ] **Application does not start after deployment:** symptoms described, probable causes listed (env var missing, migration failed, port conflict), diagnostic commands included
- [ ] **Database migration fails mid-deployment:** what state the DB is in, how to check, how to roll back or complete manually
- [ ] **Cron job not running:** how to check the last sync_log entry, what to look at in the deployment to confirm the job is registered
- [ ] **Third-party API returning errors:** how to distinguish a transient error from a service outage, how to check the external service status page, what to do if the outage is prolonged
- [ ] **Memory or CPU spike:** what metrics to look at, how to determine if it is a traffic spike vs. a leak, when to scale vs. investigate
- [ ] **Authentication failures in production:** how to check session configuration, how to confirm OAuth callback URLs are correct in the provider settings
- [ ] At least 2 additional scenarios specific to this system's known failure modes

### Known Limitations and Technical Debt
- [ ] Any known operational limitation is documented (e.g., "the sync job takes 8 minutes on the first run of the month")
- [ ] Any technical debt item that affects operations is noted with a ticket reference
- [ ] Workarounds for known issues are documented so operators do not re-discover them

### Maintenance Procedures
- [ ] Secret rotation procedure: step-by-step for rotating each secret without downtime
- [ ] Dependency update procedure: how to update dependencies and verify nothing broke
- [ ] Database backup verification: how to confirm backups are running and restorable
- [ ] Log retention and cleanup: how logs are retained and when they are purged

## Acceptance Criteria

| Criterion | How to verify |
|-----------|---------------|
| Deployment procedure is complete | Follow the steps from a clean state; the system must be running at the end without needing any undocumented step |
| Rollback procedure is complete | Follow the rollback steps after a deployment; system must return to previous version including database state |
| Every configured alert has a response procedure | List all alerts in monitoring config; confirm each has a named section in the runbook |
| At least 6 common failure scenarios documented | Count scenarios; must be >= 6, with investigation steps and remediation for each |
| On-call contacts are current | Verify with the named contacts that they are correct |
| Monitoring dashboard URL is accessible | Click the link; confirm it opens the correct dashboard |
| Rollback tested in staging | `rollback_plan_tested: true` confirmed in Deployment_Plan.md handoff package |
| No procedure requires undocumented knowledge | Have someone unfamiliar with the system attempt the deployment procedure; note any gaps |

## Related Gates

- **Produced at:** Gate 6 — Deploy Review (alongside Deployment_Plan.md)
- **Used during:** Gate 7 — Post-Deploy Monitoring and all ongoing operations
- **Owner:** Agente08_DevOps; updated by anyone who operates the system

## Failure Examples

- **FAIL:** The deployment procedure says "deploy using Vercel CLI" with no specific commands, no expected output, and no post-deployment verification steps. This is not a procedure — it is a gesture.
- **FAIL:** The rollback procedure says "redeploy the previous version." There is no mention of what to do about the database migration that ran during the failed deployment.
- **FAIL:** Three alerts are configured in the monitoring platform but only one has a response procedure in the runbook. The on-call engineer does not know what to do when the other two fire.
- **FAIL:** The on-call contact section lists an individual's personal email address with no fallback. If that person is unavailable, there is no escalation path.
- **FAIL:** The runbook was written at the time of initial deployment 6 months ago and has not been updated since. Two new cron jobs were added and are not mentioned.
- **FAIL:** The failure scenario for "third-party API returning errors" says "check the API." No diagnostic commands, no status page URL, no escalation path, no fallback procedure.

## When to Block

The Deployment Plan (and therefore Gate 6) should be blocked when:
- Rollback procedure is absent or has not been tested
- Any configured alert has no response procedure in the runbook
- The deployment procedure has not been executed successfully at least once (staging test)
- On-call contact information is absent or outdated

After production deployment, the runbook is considered incomplete if:
- A production incident reveals a failure scenario not covered in the runbook — the runbook must be updated before the next release
- An alert fires that has no response procedure — the procedure must be written before the alert is acknowledged as resolved
