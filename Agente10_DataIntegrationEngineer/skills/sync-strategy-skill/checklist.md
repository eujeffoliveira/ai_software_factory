# sync-strategy-skill Checklist

## Pre-Execution
- [ ] data-mapping-skill output available (Data_Mapping.md)
- [ ] idempotent-sync-design-skill output available
- [ ] Trigger type confirmed (DR001/DR002)
- [ ] Estimated volume documented

## Execution
- [ ] File paths specified (cron route + job logic)
- [ ] guardCron() specified as FIRST call
- [ ] Idempotency design incorporated from idempotent-sync-design-skill
- [ ] Cursor-based pagination specified if volume > 1,000 records
- [ ] Cursor update timing: AFTER successful DB commit (not before)
- [ ] syncLog() in finally block — not just success/error branches
- [ ] All syncLog() fields defined (job, executedAt, durationMs, status, counts, errorMsg)
- [ ] Error handling per-record (isolate failures, continue)
- [ ] Error handling for external API (retry, circuit breaker, rate limit)
- [ ] Dead letter disposition defined
- [ ] Conflict resolution specified for bidirectional syncs
- [ ] Vercel Cron configuration entry produced

## Runtime Knowledge Policy
- [ ] Knowledge sourced from Agente10_DataIntegrationEngineer/knowledge/ only
- [ ] context/ and lib/ not accessed

## Post-Execution
- [ ] sync_idempotency_checklist.md fully checked
- [ ] external_call_in_transaction = false in output
- [ ] sync_log_in_finally = true in output
- [ ] Sync_Strategy.md ready for Gate 3.5
