# Data Mapping: [External System] ↔ [Internal Model]

> **Mapping ID:** MAP-[SYSTEM]-[NNN]
> **Integration ID:** INT-[SYSTEM]-[NNN]
> **External system:** [system-name]
> **Internal Prisma model:** [ModelName]
> **Data direction:** Inbound / Outbound / Bidirectional
> **Produced by:** Agente10_DataIntegrationEngineer
> **Version:** 1.0.0

---

## 1. Overview

**External entity:** `[ExternalEntityName]` (from [system-name] API `/v[N]/[endpoint]`)
**Internal entity:** `[ModelName]` (Prisma model in `prisma/schema.prisma`)

Brief description of what this mapping covers and why these entities correspond.

---

## 2. Source → Target Mapping (Inbound)

*External system fields → Internal Prisma model fields*

| External Field | Type (External) | Internal Field | Type (Prisma) | Transform Type | Transformation / Notes | Nullable | PII Level | Req. Source |
|---------------|----------------|----------------|---------------|----------------|----------------------|----------|-----------|-------------|
| `id` | string | `externalId` | String @unique | DIRECT | Primary idempotency key | No | NOT_PII | INT-REQ-001 |
| `[ext_field_1]` | [ext_type] | `[internalField1]` | [PrismaType] | DIRECT | — | [Yes/No] | [level] | [req_id] |
| `[ext_field_2]` | [ext_type] | `[internalField2]` | [PrismaType] | TYPE_COERCION | `new Date(value)` | [Yes/No] | [level] | [req_id] |
| `[ext_field_3]` | string: "active"\|"inactive" | `[status]` | Status (enum) | LOOKUP | See §3 Enum Map | No | NOT_PII | [req_id] |
| `[ext_computed_1]` | string, string | `[fullName]` | String | COMPUTED | `"${first} ${last}"` | [Yes/No] | PERSONAL | [req_id] |
| `[ext_optional]` | string? | `[internalField]` | String? | DEFAULTED | `value ?? ""` | Yes | [level] | [req_id] |
| `[ext_internal_field]` | any | *(dropped)* | — | DROPPED | Internal debug field — not synced | — | — | — |
| `created_at` | ISO8601 string | `createdAt` | DateTime | TYPE_COERCION | `new Date(value)` | No | NOT_PII | — |
| `updated_at` | ISO8601 string | `updatedAt` | DateTime | TYPE_COERCION | `new Date(value)` | No | NOT_PII | — |

**Transformation types:**
- `DIRECT` — field copied as-is (type matches)
- `TYPE_COERCION` — value is converted to a different type (formula required)
- `COMPUTED` — value derived from multiple source fields (formula required)
- `LOOKUP` — value mapped via an enum or lookup table (see §3)
- `DEFAULTED` — value uses a default when source is null/absent (default documented)
- `DROPPED` — field explicitly excluded (reason required)

---

## 3. Target → Source Mapping (Outbound)

*Internal Prisma model fields → External system fields*
*(Required for bidirectional integrations — mark as N/A if inbound only)*

| Internal Field | Type (Prisma) | External Field | Type (External) | Transform | Notes |
|----------------|---------------|---------------|----------------|-----------|-------|
| `externalId` | String | *(used as path param)* | — | — | Used in `PUT /v[N]/[entities]/{externalId}` |
| `[internalField1]` | [PrismaType] | `[ext_field_1]` | [ext_type] | [type] | [notes] |
| `[internalField2]` | DateTime | `[ext_field_2]` | ISO8601 string | TYPE_COERCION | `.toISOString()` |
| `[internalOnlyField]` | [type] | *(not sent)* | — | DROPPED | Internal field — not exposed to external system |

---

## 4. Enum / Lookup Maps

### 4.1 [ExternalField] → [InternalField] Status Map

| External Value | Internal Value (Prisma Enum) |
|---------------|------------------------------|
| `"active"` | `Status.ACTIVE` |
| `"inactive"` | `Status.INACTIVE` |
| `"pending"` | `Status.PENDING` |
| `"unknown"` | `Status.UNKNOWN` (if undefined — use default) |

**Fallback for unmapped values:** QUARANTINE record with error "Unknown status value: {value}"

---

## 5. Field Ownership Table

*Required for bidirectional integrations. Declares the authoritative system for each field.*

| Internal Field | Owner | Conflict Resolution | Conflict Detection | Notes |
|----------------|-------|--------------------|--------------------|-------|
| `externalId` | EXTERNAL | EXTERNAL_WINS | — | Identity field — always from external |
| `[field_1]` | EXTERNAL | EXTERNAL_WINS | `updated_at` comparison | External CRM is source of truth for contact data |
| `[field_2]` | INTERNAL | INTERNAL_WINS | — | Internal enrichment — external cannot overwrite |
| `[field_3]` | COMPUTED | INTERNAL_WINS | — | Computed field — regenerated on each sync |
| `[status]` | EXTERNAL | EXTERNAL_WINS | `updated_at` comparison | External system drives status transitions |

**Conflict detection mechanism:** Compare `external.updated_at` with `internal.updatedAt`. If external is more recent: apply EXTERNAL_WINS fields. If internal is more recent: apply INTERNAL_WINS fields.

---

## 6. Dropped Fields

External fields explicitly excluded from the integration scope:

| External Field | Reason for Exclusion |
|---------------|---------------------|
| `[ext_debug_field]` | Internal debugging field — not business data |
| `[ext_deprecated_field]` | Deprecated in API v2 — always null |
| `[ext_pii_field]` | PII field without legal basis — excluded from scope (RISK-001) |

---

## 7. Data Lineage

Every internal field has exactly one documented source:

| Internal Field | Source Type | Source Detail |
|----------------|-------------|---------------|
| `externalId` | DIRECT | `external.id` |
| `createdAt` | DIRECT | `external.created_at` (coerced to Date) |
| `[computedField]` | COMPUTED | `"${external.firstName} ${external.lastName}"` |
| `syncedAt` | SYSTEM_GENERATED | Set to `new Date()` at upsert time |
| `qualityFlags` | SYSTEM_GENERATED | Set by data quality validation step |

---

## 8. Zod Schema Requirements

The integration client must validate all inbound data using this schema before any field is accessed:

```typescript
// lib/integrations/[system-name].schemas.ts
import { z } from "zod"

export const [ExternalEntity]Schema = z.object({
  id: z.string().min(1),
  [ext_field_1]: z.[type](),
  [ext_field_2]: z.string().datetime(),   // validated as ISO8601
  [ext_field_3]: z.enum(["active", "inactive", "pending"]),
  [optional_field]: z.string().nullable().optional(),
  created_at: z.string().datetime(),
  updated_at: z.string().datetime(),
}).passthrough()   // allow unknown fields — forward compatibility

export const [ExternalEntity]ListSchema = z.object({
  data: z.array([ExternalEntity]Schema),
  next_cursor: z.string().nullable(),
  has_more: z.boolean(),
}).passthrough()
```

---

*Produced by Agente10_DataIntegrationEngineer using templates/Data_Mapping.md*
