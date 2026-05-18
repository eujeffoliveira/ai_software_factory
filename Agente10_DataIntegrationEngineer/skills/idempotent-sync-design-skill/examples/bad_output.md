# Bad Output: idempotent-sync-design-skill

**Operation:** CRM contact sync

**Design (WRONG):**
"We'll insert contacts from the CRM using `createMany()`. If there are duplicates, we'll handle them later."

**Violations:**
- `createMany()` is specified — not idempotent (FM-01)
- No external ID field identified or stored
- "Handle duplicates later" is not an idempotency strategy
- No test scenarios produced
- No upsert where clause defined

**What happens in production:**
The cron job runs at 02:00 AM. Vercel times out at 02:02 AM and retries. The second run creates 1,000 duplicate contacts. The database now has 2,000 contacts. Marketing sends every email twice. Customers complain.
