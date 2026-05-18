# Good Output: etl-planning-skill

A correct ETL plan includes:

**Load order respects FK constraints:**
```
1. Companies (no FK deps)
2. Contacts (FK: companyId → Company)
3. Deals (FK: contactId → Contact)
```

**Idempotent bulk load:**
Every entity uses upsert: `prisma.company.upsert({ where: { externalId }, ... })`
Re-running the ETL produces the same DB state — no duplicates.

**Rollback plan:**
Before migration: `CREATE TABLE companies_backup AS SELECT * FROM companies`
On failure: `TRUNCATE companies; INSERT INTO companies SELECT * FROM companies_backup`

**Performance within limits:**
50,000 contacts / 100 per batch = 500 API calls × 200ms avg = ~100 seconds ≈ 2 minutes ✓ (within 10-min Vercel timeout)

**Progress checkpointing:**
`sync_cursors` table tracks last processed externalId per entity type. ETL resumes from last checkpoint on failure.
