# Skill: idempotent-sync-design-skill

## Purpose

Design the idempotency mechanism for a specific sync operation, selecting and documenting the appropriate strategy (upsert key, idempotency key table, cursor state, event deduplication). This skill is a prerequisite sub-step of `sync-strategy-skill`.

## When to Use

Invoke for every sync operation before it is specified in `Sync_Strategy.md`. This skill produces the idempotency design that `sync-strategy-skill` incorporates. Gate 3.5 blocks if any sync operation lacks a documented idempotency strategy.

## Inputs

| Input | Source | Required |
|-------|--------|----------|
| `sync_operation_description` | Integration_Spec.md or Architecture.md | Yes |
| `external_id_field` | External API documentation | Yes |
| `operation_type` | Integration requirement | Yes — cron/webhook/event |
| `has_side_effects` | Integration analysis | Yes — e.g., sends email, charges payment |
| `estimated_volume` | Integration_Requirements.md | Yes |

## Outputs

| Output | Description |
|--------|-------------|
| Idempotency strategy document | Strategy selection with rationale |
| Idempotency key definition | Field name, source, computation method |
| Prisma upsert spec | `where` clause configuration |
| Test scenarios | Idempotency validation scenarios for Agente06_QaEngineer |

## Constraints

- Default mechanism: upsert with external ID (covers most sync operations)
- Idempotency key table required when: operation has irreversible side effects (payment, email, SMS)
- Cursor state is supplementary (doesn't replace upsert — both used together for batch sync)
- Event deduplication required for webhook handlers
- The idempotency key must be derived from external data — never from internal generated IDs
- Test scenarios must include: "run twice with same input → same result"

## Step-by-Step Execution

1. **Classify the operation type:** Record sync (create/update records) vs. action trigger (payment, email, notification).

2. **Identify external ID:** Confirm the external system's unique identifier for the entity being synced. This is always the primary idempotency key candidate.

3. **Select mechanism:**
   - **Record sync (no side effects):** Use upsert with external ID as `where` clause.
   - **Action trigger (with irreversible side effects):** Use idempotency key table + upsert.
   - **Batch with cursor:** Use cursor state for pagination + upsert for each record.
   - **Webhook event:** Use event ID deduplication + upsert for entity update.

4. **Define idempotency key:** Specify the field name, its source, and the computation method (direct copy, hash of multiple fields).

5. **Define Prisma upsert clause:** `{ where: { [externalIdField]: record.[externalId] }, create: {...}, update: {...} }`.

6. **Define processed-events table (if needed):** For operations with side effects, define: `{ key, result, processedAt }`.

7. **Define cursor storage (if batch):** Cursor field, storage table, update timing (after successful commit).

8. **Produce test scenarios:**
   - Scenario 1: Run operation once → verify expected result
   - Scenario 2: Run same operation twice → verify same DB state (no duplicates)
   - Scenario 3: Simulate failure mid-run → verify re-run completes correctly

9. **Run `sync_idempotency_checklist.md`.**

## Knowledge Access Policy

At runtime, this skill reads from:
- `Agente10_DataIntegrationEngineer/knowledge/` (principles P1; heuristics H1, H3, H5; decision rules DR003, DR006, DR010; cards Card001, Card002, Card006)
- `Agente10_DataIntegrationEngineer/checklists/sync_idempotency_checklist.md`
- Project input artifacts: Integration_Spec.md, external API documentation

**Blocked at runtime:** `context/`, `lib/`, `*.pdf`, any other agent's folder.
