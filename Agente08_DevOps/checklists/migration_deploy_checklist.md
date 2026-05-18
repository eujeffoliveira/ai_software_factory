# Migration Deploy Checklist
## Pre-Deploy and Execution — migration-deploy-skill

Run this checklist for every deployment that includes database migrations.

---

## Section 1 — Pre-Deploy Assessment

- [ ] **Check migration status:** `npx prisma migrate status` on target environment
- [ ] **Record pending migration count:** [N] migrations pending
- [ ] **Record last applied migration:** [filename]
- [ ] **Confirm pending migrations are committed to source control**
- [ ] **Confirm `prisma db push` was NOT used in this environment** (check logs/history)

---

## Section 2 — Per-Migration Review

For each pending migration file:
- [ ] **Read `migration.sql`** — understand every SQL operation
- [ ] **Classify operations:**
  - `CREATE TABLE` — LOW risk
  - `ALTER TABLE ADD COLUMN` (nullable or with default) — LOW risk
  - `ALTER TABLE ADD COLUMN NOT NULL` (no default, non-empty table) — HIGH risk
  - `CREATE INDEX` — MEDIUM risk (locks table during index build; consider `CREATE INDEX CONCURRENTLY`)
  - `ALTER TABLE RENAME COLUMN` — HIGH risk (backward incompatibility)
  - `ALTER TABLE ALTER COLUMN TYPE` — HIGH risk (data type change; may truncate data)
  - `ALTER TABLE DROP COLUMN` — CRITICAL risk (data loss)
  - `DROP TABLE` — CRITICAL risk (data loss)
  - `TRUNCATE TABLE` — CRITICAL risk (data loss)
- [ ] **Assess backward compatibility:** Does the current codebase work with BOTH old and new schema?
- [ ] **Estimate duration:** Based on table row count and operation type
- [ ] **Flag if duration > 30 seconds:** Requires long-running migration strategy review

---

## Section 3 — Risk Signoff

For each CRITICAL or HIGH risk migration:
- [ ] **Document the specific risk:** What data is at risk and how much?
- [ ] **Prepare forward-fix migration:** Write the SQL that reverts the change
- [ ] **Obtain human sign-off:** Name + timestamp of human who approved
- [ ] **Verify forward-fix migration committed to source control**

For LOW risk migrations:
- [ ] **Document that no sign-off is required**

---

## Section 4 — Long-Running Migration Strategy

If any migration is estimated to take > 30 seconds on the target environment:

- [ ] **Estimate production duration:** Table size on production × duration-per-row estimate
- [ ] **Select strategy:**
  - **Option A:** Execute during low-traffic window (night, weekend)
  - **Option B:** Online migration strategy (add nullable column → backfill in batches → add constraint)
  - **Option C:** Maintenance window (if app can tolerate downtime)
- [ ] **Document selected strategy in `Migration_Deploy_Plan.md`**
- [ ] **Get human sign-off on the strategy**

---

## Section 5 — Pre-Execution Final Check

- [ ] **Migration files are correct versions** (no unexpected files pending)
- [ ] **All sign-offs are documented**
- [ ] **Forward-fix migrations are prepared and committed**
- [ ] **`Migration_Deploy_Plan.md` is complete**
- [ ] **Team is available during migration execution** (for quick response if issues arise)
- [ ] **Database backup is recent** (or backup taken before execution for HIGH/CRITICAL migrations)

---

## Section 6 — Execution

```bash
# On the target environment (staging or production):
npx prisma migrate deploy
```

During execution:
- [ ] **Monitor for errors** in real-time (Vercel logs or direct DB connection)
- [ ] **Do not interrupt** a running migration (partial application can cause inconsistent state)
- [ ] **Note start time:** [timestamp]
- [ ] **Note end time:** [timestamp]

---

## Section 7 — Post-Execution Verification

- [ ] **`npx prisma migrate status`** — all migrations show "Applied"
- [ ] **No error messages** in migration output
- [ ] **Application healthcheck returns 200** after migration
- [ ] **Spot-check affected tables** (if accessible): row counts, nullable columns, etc.
- [ ] **Document migration completion** in `Migration_Deploy_Plan.md`

---

## Section 8 — If Migration Fails

- [ ] **DO NOT retry automatically** — assess the error first
- [ ] **Record exact error message**
- [ ] **Determine migration state:** Was any SQL executed? Partially? Fully?
  - PostgreSQL migrations are transactional — DDL in a transaction either fully applies or fully rolls back
  - Some DDL (e.g., `CREATE INDEX CONCURRENTLY`) runs outside a transaction and may leave partial state
- [ ] **Escalate to Tech Lead** with: error message, migration filename, affected table, migration state
- [ ] **DO NOT deploy application code** until migration state is resolved

---

## Runtime Knowledge Policy

This checklist is consulted at runtime from `Agente08_DevOps/checklists/migration_deploy_checklist.md`. Migration rules are in `context_view.md` Section 5 and `knowledge/decision_rules.md` DR002, DR004, DR011. The only allowed migration command in staging and production is `prisma migrate deploy`. Do not access `context/` or `lib/` to complete this checklist.
