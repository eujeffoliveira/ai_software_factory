# Migration Deploy Plan
## Target Environment: [staging | production]
## Prepared at: [ISO-8601 timestamp]

> **Allowed command:** `npx prisma migrate deploy`
> **Forbidden command:** `npx prisma db push` — NEVER use in staging or production

---

## Current Migration State

- Last migration applied to target DB: `[20XXXXXX_migration_name]`
- Pending migration count: [N]

---

## Pending Migrations (in application order)

### Migration 1: `[filename]`

**Operations:**
```sql
[Preview of the SQL operations in this migration]
```

**Risk assessment:**

| Criterion | Assessment |
|-----------|-----------|
| Is destructive (DROP/TRUNCATE/narrowing ALTER) | [ ] YES / [ ] NO |
| Is backward-compatible with current codebase | [ ] YES / [ ] NO |
| Estimated duration | [X] seconds (on table with ~[N] rows) |
| Risk level | [LOW / MEDIUM / HIGH / CRITICAL] |
| Human sign-off required | [ ] YES / [ ] NO |

**If destructive:**
> [ ] Human sign-off obtained from: [name], at: [timestamp]
> Forward-fix rollback: [What the rollback migration would do]

---

## Migration Safety Checklist

- [ ] All migration files are committed to source control
- [ ] `prisma migrate status` on staging confirms these are the only pending migrations
- [ ] No `DROP TABLE` without confirmed data backup or data migration plan
- [ ] No `DROP COLUMN` without deprecation period (column was unused in current codebase)
- [ ] No `ALTER COLUMN` that narrows the data type without data validation
- [ ] All migrations with > 1M row table impact assessed for duration
- [ ] Long-running migrations (> 30s) have an online migration strategy or maintenance window
- [ ] Forward-fix rollback migration prepared for all destructive operations
- [ ] `prisma migrate deploy` (not `prisma db push`) confirmed as execution command
- [ ] Human sign-off obtained for all CRITICAL and HIGH risk migrations

---

## Rollback Strategy

**Strategy type:** Forward-fix migration (always — no backward migrations)

**Forward-fix migrations prepared:**

| Original Migration | Forward-Fix Migration | Description |
|-------------------|----------------------|-------------|
| [filename] | [forward_fix_filename] | [What the fix does — e.g., "Re-adds the status column"] |

_If no destructive migrations: "No forward-fix migrations needed — no destructive operations in this release."_

---

## Execution Plan

**Pre-execution:** Verify `prisma migrate status` shows expected pending migrations and no others.

**Execution command:**
```bash
npx prisma migrate deploy
```

**Post-execution verification:**
```bash
npx prisma migrate status
# Expected: all migrations shown as "Applied"
```

**Expected duration:** ~[X] seconds total

**If migration fails:**
1. Do NOT retry automatically — investigate error first
2. Check Vercel function logs or DB logs for specific error
3. Assess: is the migration partially applied? (Some ALTER TABLE operations are transactional; others are not in PostgreSQL)
4. Escalate to Tech Lead with specific error message and migration state
5. Do NOT deploy application code until migration state is known

---

## Execution Readiness

| Check | Status |
|-------|--------|
| All migrations committed to source control | [ ] YES / [ ] NO |
| All high-risk migrations have human sign-off | [ ] YES / [ ] NO / [ ] N/A |
| Forward-fix migrations prepared | [ ] YES / [ ] NO / [ ] N/A |
| `prisma migrate status` confirms expected pending count | [ ] YES / [ ] NO |

**Execution readiness:** [ ] **READY** / [ ] **BLOCKED** — [reason]
