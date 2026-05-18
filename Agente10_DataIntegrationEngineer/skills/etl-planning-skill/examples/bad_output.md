# Bad Output: etl-planning-skill

Violations in a bad ETL plan:

**Wrong load order (FK violations):**
Loads Contacts before Companies — Prisma throws FK constraint errors because `companyId` references non-existent Company records.

**Not idempotent:**
Uses `createMany()` without upsert — re-running after partial failure creates duplicates for all already-processed records.

**No rollback plan:**
"We'll back up before we run it." No documented procedure. When the migration fails at record 30,000 of 50,000, there's no plan for what to do.

**Performance not checked:**
500,000 records / 10 per batch = 50,000 API calls. At 200ms each: 10,000 seconds = 2.7 hours. Vercel Pro function timeout: 10 minutes. The migration cannot complete in a single function execution — requires chunked execution not planned for.

**ELT applied to operational DB (wrong pattern):**
Plan says "load raw data into staging table, transform with SQL." This is ELT — appropriate for analytics warehouses, not for the Prisma operational database. DR014: ETL for operational DB.
