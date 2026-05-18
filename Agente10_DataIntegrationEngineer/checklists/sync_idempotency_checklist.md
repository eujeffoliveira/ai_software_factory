# Sync Idempotency Checklist

> Run for every automated sync operation. Gate 3.5 blocks if any item is unchecked without justification.

## Pre-Execution: Idempotency Analysis

- [ ] Idempotency mechanism selected from approved list: upsert_external_id / idempotency_key_table / cursor_state / event_id_deduplication
- [ ] External system's unique identifier field identified and documented
- [ ] The external ID field is guaranteed to be present and stable (never changes for the same record)
- [ ] Idempotency key field name documented in `Sync_Strategy.md`

## Upsert Pattern (Primary Mechanism)

- [ ] All create operations in sync job specified as Prisma `upsert`, not `create`
- [ ] `where` clause uses `externalId` (or system-specific external ID field)
- [ ] `create` block includes `externalId` field
- [ ] `update` block updates `syncedAt: new Date()` to track last sync time
- [ ] Prisma schema has `@unique` constraint on `externalId` field
- [ ] No `prisma.model.create()` appears in any sync job specification

## Cursor State (When Volume > 1,000 Records)

- [ ] Cursor field identified (typically `updated_at` or sequential `id`)
- [ ] Cursor storage mechanism defined (`sync_cursors` table or equivalent)
- [ ] Cursor read step defined at start of each job run
- [ ] Cursor update step defined — update ONLY after successful DB commit of the batch
- [ ] Cursor is NOT updated before processing is confirmed successful
- [ ] Behavior on job failure documented: cursor stays at last committed position

## Event Idempotency (Webhook Handlers)

- [ ] Event ID field identified in the webhook payload (e.g., `event_id`, `X-Event-Id` header)
- [ ] Idempotency key computation documented: `hash(eventId + eventType)` or similar
- [ ] Processed events table defined or referenced (`processed_events` table)
- [ ] Lookup-before-process check specified: check if key exists before processing
- [ ] Insert-after-process step specified: insert key after successful processing

## sync_log: Observability

- [ ] `syncLog()` call specified in the sync spec with all required fields
- [ ] `syncLog()` placement: `finally` block — executes on success AND failure
- [ ] `job` field: kebab-case job identifier matching cron route path
- [ ] `executedAt`: UTC timestamp captured at job start
- [ ] `durationMs`: `Date.now() - start` captured in `finally`
- [ ] `status`: `"success"` | `"error"` | `"partial"` determined correctly
- [ ] `counts` object includes: `{ processed, created, updated, skipped, errors }`
- [ ] `errorMsg`: included when status is `"error"` or `"partial"`, `undefined` when `"success"`

## Anti-Patterns Confirmed Absent

- [ ] No `prisma.model.create()` in any sync job without upsert alternative
- [ ] No offset-based pagination (`?page=N`) in any sync that processes > 1,000 records
- [ ] No external API call inside a Prisma `$transaction()` block
- [ ] No sync spec with fixed-interval retry (exponential backoff specified instead)
- [ ] `syncLog()` not only on success path — confirmed in `finally` block

## Post-Execution: Review

- [ ] `Sync_Strategy.md` idempotency section complete
- [ ] `idempotency_coverage.covered` incremented in Handoff Package
- [ ] Confirmed: `idempotency_coverage.uncovered` = 0 for all sync operations
- [ ] Gate 3.5 idempotency check: PASS

## Runtime Knowledge Policy

At runtime, this checklist is consulted from `Agente10_DataIntegrationEngineer/checklists/`. The agent reads only from its own folder and project input artifacts. `context/` and `lib/` are blocked at runtime.
