# idempotent-sync-design-skill Checklist

## Pre-Execution
- [ ] External ID field confirmed as stable and present in all records
- [ ] Operation type classified (cron batch / webhook / event)
- [ ] Side effects identified (payment, email, SMS → requires idempotency key table)

## Execution
- [ ] Mechanism selected from approved list
- [ ] Idempotency key field documented (name + source)
- [ ] Upsert where clause specified
- [ ] Processed-events table defined (if side effects present)
- [ ] Cursor storage defined (if batch sync with > 1,000 records)
- [ ] Cursor update timing: after successful DB commit (not before)
- [ ] 3 test scenarios produced (once, twice, failure+resume)

## Runtime Knowledge Policy
- [ ] Knowledge from Agente10_DataIntegrationEngineer/knowledge/ only
- [ ] context/ and lib/ not accessed

## Post-Execution
- [ ] sync_idempotency_checklist.md fully checked
- [ ] Output ready for sync-strategy-skill incorporation
- [ ] No create() without upsert in spec
