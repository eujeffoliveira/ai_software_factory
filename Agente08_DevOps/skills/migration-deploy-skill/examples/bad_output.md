# Bad Output — migration-deploy-skill

**Execution Readiness:** READY ❌ WRONG — destructive migration without sign-off

**Migration 1:** `20260515_drop_users_email_column`
- Destructive: YES (DROP COLUMN)
- Human sign-off required: NO ❌ WRONG — destructive migrations always require sign-off
- Forward-fix rollback: not prepared ❌ WRONG — must be prepared before proceeding
- Risk: LOW ❌ WRONG — DROP COLUMN is CRITICAL risk (data loss)

**WHAT IS WRONG:**
- DROP COLUMN is CRITICAL risk (permanent data loss), not LOW
- Human sign-off is required for all CRITICAL/HIGH risk migrations (DR004)
- Forward-fix migration is mandatory for destructive operations
- `READY` without sign-off on a destructive migration = data loss risk in production
