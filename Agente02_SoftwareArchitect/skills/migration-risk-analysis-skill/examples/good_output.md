# Good Output — migration-risk-analysis-skill

## Scenario

Iteration 2 schema change: add `bio` nullable text column to `users`, rename `title` to `job_title` in `jobs` (via shadow column approach), and drop the `legacy_notes` column from `job_applications` (unused since v1 migration, data confirmed obsolete by product team).

## Migration Risk Analysis

### Step-by-step classification

| Step | Change | Risk Level | Data Loss on Rollback | Maintenance Window |
|------|--------|------------|----------------------|-------------------|
| 1 | Add nullable `bio` column to `users` | REVERSIBLE | No | No |
| 2 | Add shadow `job_title` column to `jobs` | REVERSIBLE | No | No |
| 3 | Backfill `job_title` from `title` | COMPATIBLE | No | No (background job) |
| 4 | Add NOT NULL constraint to `job_title` | COMPATIBLE | No | No (after backfill complete) |
| 5 | Drop `title` column from `jobs` | DESTRUCTIVE | Yes (if rollback after step 5) | Yes |
| 6 | Drop `legacy_notes` column from `job_applications` | DESTRUCTIVE | Yes | Yes |

**Overall risk level: DESTRUCTIVE** (steps 5 and 6)

### Risk Register entries

```
RISK-011 | Migration: Add nullable bio column to users | REVERSIBLE | Rollback: ALTER TABLE users DROP COLUMN bio; | No data loss
RISK-012 | Migration: Rename jobs.title to job_title via shadow column | COMPATIBLE | Rollback: new migration to reverse backfill + DROP job_title | No data loss if rolled back before step 5
RISK-013 | Migration: DROP jobs.title column | DESTRUCTIVE | Rollback: restore from backup taken before migration | Data loss if backup not taken
RISK-014 | Migration: DROP job_applications.legacy_notes | DESTRUCTIVE | Rollback: restore from backup | Data loss confirmed acceptable — product team sign-off obtained
```

### Phased plan for DESTRUCTIVE steps (steps 5 and 6)

**Phase 1 — Application change (deploy first)**
- Deploy application code that writes `job_title` instead of `title`
- Confirm all read paths use `job_title` — verified via code search
- `legacy_notes` field removed from all application code
- Monitor: 1 full deployment cycle (≥ 24h) with zero error rate on `job_title` reads

**Phase 2 — Monitor**
- Watch `audit_log` for any remaining reads from `title` or `legacy_notes` columns
- Confirm in staging first; if zero errors for 48h, proceed to Phase 3

**Phase 3 — Destructive migration (maintenance window)**
- Confirm: `pg_dump` backup taken and verified restorable
- Run: `prisma migrate deploy` — applies migration that drops `title` and `legacy_notes`
- Command: `npx prisma migrate deploy` (NOT `prisma db push`)
- Post-migration: run smoke tests from Playwright suite

### Deployment_Strategy.md entry appended

```markdown
## Migration M002 — Schema Cleanup

**Overall risk: DESTRUCTIVE**  
**Zero-downtime eligible: No (steps 5-6 require maintenance window)**  
**Migration command: `prisma migrate deploy`**  
**Phased plan: required (see RISK-013, RISK-014)**
```

## Why this is a good output

- Each of the 6 changes classified individually — not lumped into one category
- Overall level correctly derived as DESTRUCTIVE (highest individual classification)
- Three-phase plan written for DESTRUCTIVE steps with specific timing and verification criteria
- Rollback plan for each step — including exact SQL for REVERSIBLE and backup requirement for DESTRUCTIVE
- `migration_command_valid: true` — `prisma migrate deploy` stated, NOT `prisma db push`
- RISK-NNN entries follow format and are appended to Risk_Register.md
