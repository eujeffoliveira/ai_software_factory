# Bad Example: Data Mapping

> **Why this is incorrect:** This mapping has multiple structural violations that would cause bugs in production. Each violation is annotated.

---

## Data Mapping: crm-platform ↔ Contact (INCORRECT VERSION)

---

### Source → Target (Inbound)

| External Field | Internal Field | Notes |
|---------------|----------------|-------|
| `id` | `id` | ❌ **VIOLATION:** Mapping external `id` to internal `id`. The internal `id` is our auto-generated primary key — it cannot be set from external data. The correct internal field is `externalId` (a separate `@unique` field). This will cause Prisma errors or silent overwrites of internal IDs. |
| `email` | `email` | *(no PII classification, no requirement source, no type info)* |
| `first_name` | `firstName` | ❌ **VIOLATION:** Only maps `first_name` to `firstName`. The `last_name` field is not mapped — it is silently dropped without documentation. The `fullName` field remains null, breaking any feature that displays the contact's full name. |
| `status` | `status` | ❌ **VIOLATION:** No transformation documented. The external API uses `"active"/"inactive"` but the Prisma schema uses `Status.ACTIVE/Status.INACTIVE` enum. No lookup map provided. Agente04_DevBackend will have to guess the transformation. |
| `updated_at` | `updatedAt` | *(no type coercion documented)* ❌ External field is an ISO8601 string. Internal is DateTime. TypeScript/Prisma will silently accept a string and store the wrong type, or throw a runtime error depending on the Prisma adapter. |
| *(all other fields)* | *(silently dropped)* | ❌ **VIOLATION:** No explicit handling for fields `phone`, `company_id`, `created_at`, or `internal_score`. No dropped fields section. Silently dropped fields are a design gap — what happens when the spec changes and `phone` is needed? |

---

### Target → Source (Outbound)

*(Not provided)*

❌ **VIOLATION: Missing reverse mapping.** The integration is bidirectional (data flows to the CRM on contact updates), but no outbound mapping is documented. Agente04_DevBackend has no spec for what to send when pushing contact updates to the CRM. This will be "figured out during implementation" — which means inconsistent, untested data going to the external system.

---

### Field Ownership

*(Not provided)*

❌ **VIOLATION: Missing field ownership table.** This is a bidirectional integration, but no field has a declared owner. What happens when the CRM updates `email` at the same moment our system updates it? Both sides think they're right. In production: one update silently overwrites the other. Whoever runs last wins — which is not a policy, it's chaos.

---

### PII Classification

*(Not provided)*

❌ **VIOLATION:** None of the fields are classified for PII level. `email` and any name fields are PERSONAL under LGPD. No legal basis documented. No LGPD risk assessment triggered. This integration syncs personal data without any privacy analysis — a direct LGPD violation that blocks Gate 3.5.

---

### Data Lineage

*(Not provided)*

❌ **VIOLATION: Missing data lineage.** There is no source documentation for any internal field. "Where does `fullName` come from?" has no answer in this mapping. When a bug occurs in production (wrong name displayed), there is no document to trace the source. Debugging takes hours instead of minutes.

---

## Summary of Violations

| Issue | Location | Impact |
|-------|----------|--------|
| `external.id → internal.id` | Source→Target row 1 | Overwrites internal PK — Prisma error or data corruption |
| `last_name` not mapped | Source→Target | `fullName` is null for all contacts — display bugs |
| `status` no transformation | Source→Target | TypeScript type error or wrong enum value in DB |
| `updated_at` type not documented | Source→Target | String stored where DateTime expected — runtime error |
| Silent drops (phone, company_id) | Source→Target | Missing data, unclear requirements |
| No reverse mapping | Outbound section | Agente04 has no spec for CRM updates |
| No field ownership table | — | Conflict corruption in bidirectional sync |
| No PII classification | — | LGPD violation — blocks Gate 3.5 |
| No data lineage | — | Impossible to debug production data issues |

**This mapping would produce broken implementations, data corruption, and a LGPD violation.**
