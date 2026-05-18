# Data Quality Checklist: [External System] → [Internal Model]

> **Checklist ID:** DQ-[SYSTEM]-[NNN]
> **Integration ID:** INT-[SYSTEM]-[NNN]
> **External system:** [system-name]
> **Internal model:** [PrismaModelName]
> **Produced by:** Agente10_DataIntegrationEngineer
> **Version:** 1.0.0

---

## 1. Quality Objectives

| Dimension | Target | Check Method |
|-----------|--------|-------------|
| Completeness | ≥ [N]% required fields present | Required field null check |
| Accuracy | All enums valid, all formats correct | Zod enum/format validation |
| Timeliness | Records no older than [N] hours | `updated_at` freshness check |
| Uniqueness | No duplicate `externalId` | Deduplication key check |
| Validity | All business rules satisfied | Domain-specific validation |

---

## 2. Field-Level Validation Rules

### 2.1 Critical Fields (failure → QUARANTINE)

| Field | Validation Rule | Zod Expression | Failure Disposition |
|-------|----------------|----------------|---------------------|
| `id` | Non-empty string, min 1 char | `z.string().min(1)` | REJECT — no ID = cannot identify record |
| `[email]` | Valid email format | `z.string().email()` | QUARANTINE |
| `[status]` | One of: active, inactive, pending | `z.enum(["active","inactive","pending"])` | QUARANTINE |
| `[amount]` | Positive number | `z.number().positive()` | QUARANTINE |
| `updated_at` | Valid ISO8601 datetime | `z.string().datetime()` | QUARANTINE |

### 2.2 Non-Critical Fields (failure → ACCEPT_WITH_FLAG)

| Field | Validation Rule | Zod Expression | Default on Failure |
|-------|----------------|----------------|-------------------|
| `[optional_field]` | String or null | `z.string().nullable().optional()` | `null` |
| `[phone]` | Valid phone format (loose) | `z.string().regex(/^\+?[0-9\s-]{7,}$/).optional()` | `null` |
| `[description]` | String, any length | `z.string().optional()` | `""` |

### 2.3 Identity Field (missing → REJECT immediately)

| Field | Rule | Action on Failure |
|-------|------|------------------|
| `id` | Non-empty string | REJECT — log error, count in `counts.errors`, skip record |

---

## 3. Record Disposition Policy

```
Record received from external API:
  ↓
Step 1: Validate identity field (`id`)
  → Missing or empty → REJECT
  ↓
Step 2: Check for duplicate (is `externalId` already in DB?)
  → Duplicate found → SKIP (count in counts.skipped)
  ↓
Step 3: Validate critical fields
  → Any critical field fails → QUARANTINE (integration_quarantine table)
  ↓
Step 4: Validate non-critical fields
  → Non-critical failures → ACCEPT_WITH_FLAG (upsert with quality_flags note)
  ↓
Step 5: Upsert to database
  → ACCEPT (count in counts.created or counts.updated)
```

| Scenario | Disposition | Counts Field | Action |
|----------|-------------|-------------|--------|
| All validations pass | ACCEPT | `created` or `updated` | Upsert to DB |
| Only non-critical fails | ACCEPT_WITH_FLAG | `created` or `updated` | Upsert with `qualityFlags` annotation |
| Any critical field fails | QUARANTINE | `errors` | Move to `integration_quarantine` |
| Identity field missing | REJECT | `errors` | Log and discard |
| Duplicate detected | SKIP | `skipped` | Log deduplication event |

---

## 4. Deduplication

| Field | Value |
|-------|-------|
| Deduplication key | `externalId` (mapped from `external.id`) |
| Deduplication scope | All-time (not windowed) |
| Mechanism | Prisma upsert with `@unique` constraint on `externalId` |
| Soft delete handling | [If external deletes a record: how do we detect and handle it?] |

---

## 5. Timeliness Check

| Field | Value |
|-------|-------|
| Freshness field | `updated_at` (external) |
| Maximum age | [N] hours |
| Action on stale records | ACCEPT_WITH_FLAG — annotate with `isStale: true` in quality flags |

```typescript
// Specification for freshness check:
const maxAgeMs = [N] * 60 * 60 * 1000  // [N] hours in ms
const recordAge = Date.now() - new Date(record.updated_at).getTime()
if (recordAge > maxAgeMs) {
  quality_flags.push('STALE_RECORD')
}
```

---

## 6. Data Quality Metrics in sync_log

The sync_log `counts` object must include these quality metrics:

```typescript
counts: {
  processed: number,     // total records received from external API
  created: number,       // new records inserted
  updated: number,       // existing records updated
  skipped: number,       // duplicates skipped
  errors: number         // quarantined + rejected
}
```

Optional quality annotations (log separately, not in sync_log):
- `quarantined_count`: records moved to `integration_quarantine`
- `rejected_count`: records rejected (missing identity field)
- `flagged_count`: records accepted with quality flags

---

## 7. Quarantine Table Schema

Records that fail critical validations are moved to `integration_quarantine`:

```
Table: integration_quarantine {
  id              UUID        PRIMARY KEY DEFAULT gen_random_uuid()
  job_name        TEXT        NOT NULL
  external_system TEXT        NOT NULL
  external_id     TEXT                    -- null if identity field missing
  raw_payload     JSONB       NOT NULL    -- original external record
  error_message   TEXT        NOT NULL    -- which validation failed and why
  failed_at       TIMESTAMPTZ NOT NULL DEFAULT now()
  retry_count     INT         NOT NULL DEFAULT 0
  resolved_at     TIMESTAMPTZ             -- null until manually resolved
  resolution_note TEXT                    -- operator notes on resolution
}
```

---

## 8. Alert Thresholds

| Condition | Threshold | Alert Action |
|-----------|-----------|-------------|
| Errors in a single run | > [N] records | Notify ops team |
| Error rate in a single run | > [N]% of processed | Notify ops team |
| Quarantine backlog | > [N] unresolved records | Escalate to tech lead |
| Consecutive job failures | > [N] runs | Page on-call |

---

## 9. Quality Checklist (pre-Gate 3.5)

- [ ] Identity field (`id`) validated as non-empty — REJECT on failure
- [ ] All critical fields have validation rules with Zod expressions
- [ ] All non-critical fields have validation rules with disposition and default
- [ ] Deduplication key defined and mapped to `@unique` Prisma field
- [ ] Record disposition policy covers all 5 scenarios (accept, accept-with-flag, quarantine, reject, skip)
- [ ] `integration_quarantine` table schema defined
- [ ] Quality metrics mapped to `sync_log.counts` fields
- [ ] Alert thresholds defined
- [ ] Stale record detection configured (if timeliness is required)

---

*Produced by Agente10_DataIntegrationEngineer using templates/Data_Quality_Checklist.md*
