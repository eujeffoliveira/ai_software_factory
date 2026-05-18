# Good Output: idempotent-sync-design-skill

**Operation:** CRM contact sync (batch cron)
**Mechanism:** upsert_external_id

**Idempotency key:**
- Field: `externalId`
- Source: `crm_api_response.id` (stable, always present)
- Prisma constraint: `externalId String @unique`

**Upsert clause:**
```
where: { externalId: crmContact.id }
create: { externalId: crmContact.id, email: ..., ... }
update: { email: ..., syncedAt: new Date() }
```

**Test scenarios:**
1. Run sync with 10 contacts → DB has 10 Contact rows ✓
2. Run same sync again → DB still has 10 rows (no duplicates) ✓
3. Simulate failure after 5 contacts → run again → DB has 10 rows (5 updated + 5 inserted, no duplicates) ✓
