# Cron Idempotency Checklist

**When to run:** For every cron job implementation.  
**Purpose:** Ensure jobs are safe to retry — running twice must produce the same result as running once.

---

## Route Protection

- [ ] `guardCron(req)` is the ABSOLUTE FIRST statement in the handler function body
- [ ] No variable declarations before `guardCron(req)`
- [ ] No logging calls before `guardCron(req)`
- [ ] No import-time code before `guardCron(req)` runs
- [ ] `export const dynamic = "force-dynamic"` present in the route file

## Idempotency Mechanism

For jobs that CREATE records:
- [ ] `prisma.model.upsert()` used instead of `prisma.model.create()` (via DAL)
- [ ] The `where` clause in `upsert` uses a stable unique key from the source data (e.g., `externalId`) — not a generated UUID
- [ ] OR: existence check performed before create: `const existing = await dal.findByExternalId(id); if (!existing) await dal.create(...)`

For jobs that UPDATE records:
- [ ] Update is idempotent — applying the same update twice produces the same result
- [ ] No counter increments without idempotency (e.g., `processedCount++` on every run would be wrong)

For jobs that DELETE records:
- [ ] Soft delete (set `deletedAt`, `archivedAt`) preferred over hard delete
- [ ] Hard delete only when the record no longer existing is a valid final state
- [ ] Check for existence before delete — no error if already deleted

## External API Calls

- [ ] External API calls are NOT inside `prisma.$transaction` blocks
- [ ] If the external API is called, its idempotency behavior is understood and documented
- [ ] For non-idempotent external APIs (e.g., send email once): track `sentAt` timestamp and skip if already sent

## Retry Safety

- [ ] Job can be safely interrupted mid-way and restarted without corruption
- [ ] Records partially processed in a failed run will be re-processed correctly
- [ ] No state written to memory (would be lost on restart) — all state in DB

## Testing Idempotency

- [ ] Job tested by running it twice on the same data
- [ ] Second run produces zero creates (all records already exist)
- [ ] Second run produces zero errors
- [ ] DB record count matches expected count after both runs

---

## Idempotency Strategy Comparison

| Strategy | When to Use | Implementation |
|----------|-------------|----------------|
| `upsert` | Job syncs records from external source | `dal.upsert({ where: { externalId }, create, update })` |
| Existence check | Simple create-if-not-exists | `if (!await dal.findByExternalId(id)) await dal.create(...)` |
| Version flag | Job should run at most once per time period | `if (record.syncedAt === today) skip` |
| External deduplication | External API supports idempotency keys | Pass `Idempotency-Key: job-name-YYYY-MM-DD` header |

---

## Runtime Knowledge Policy

This checklist is part of the agent's local runtime knowledge.  
Do NOT consult `context/`, `lib/`, or global architecture documents.  
All required patterns are in `context_view.md §5`, `knowledge/decision_rules.md` (DR004, DR007), and `knowledge/knowledge_cards.md` (Card 003, Card 009).
