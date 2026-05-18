# Bad Output: sync-strategy-skill

See `examples/bad_sync_strategy.md` for the full example.

Key violations in bad output:
- guardCron() missing (anyone can trigger the job)
- syncLog() only on success path (failures invisible)
- External call inside Prisma transaction (DB deadlock risk)
- create() without upsert (duplicate records on retry)
- No pagination (only first page of records processed)
- Error details in HTTP response (information disclosure)
