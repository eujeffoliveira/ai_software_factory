# Good Output: sync-strategy-skill

See `examples/good_sync_strategy.md` for the full example.

Key properties of correct output:
- guardCron() specified as first call
- syncLog() in finally block with all required fields
- Cursor-based pagination for large datasets
- Cursor updated only after successful DB commit
- Per-record error isolation (one failure doesn't stop the job)
- Dead letter disposition specified (integration_quarantine table)
- No external call inside Prisma transaction
