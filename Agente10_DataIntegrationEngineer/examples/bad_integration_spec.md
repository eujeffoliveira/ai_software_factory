# Bad Example: Integration Specification

> **Why this is incorrect:** This example demonstrates multiple Gate 3.5-blocking violations. Each violation is annotated with the failure mode it triggers and the corrective action.

---

## Integration Specification: crm-platform (INCORRECT VERSION)

> **Integration ID:** INT-CRM-001 (bad version)

### 1. Overview

This integration syncs contacts from our CRM. We'll set it up as a daily cron job.

### 2. Sync Design ❌

**VIOLATION: FM-01 — Non-Idempotent Sync**
**Gate 3.5 status: BLOCKED_MISSING_IDEMPOTENCY**

```typescript
// ❌ WRONG: create() without existence check — not idempotent
await prisma.contact.create({
  data: {
    email: crmContact.email,
    name: crmContact.full_name,
  }
})
```

**Why this is wrong:** If the Vercel cron job retries (which it will on timeout), this creates a duplicate contact. In production, a single network hiccup causes double records. The correct pattern is `upsert` with `externalId`.

**Also missing:** No idempotency key field identified. No `externalId` field in the create block. No documentation of what the external system's unique ID is.

### 3. LGPD / Privacy ❌

**VIOLATION: FM-02 — PII Without Legal Basis**
**Gate 3.5 status: BLOCKED_LGPD_VIOLATION**

The integration syncs `email`, `full_name`, and `phone`. *(No LGPD assessment produced. No legal basis documented. No DPA status noted.)*

**Why this is wrong:** Under LGPD Art. 7, processing personal data requires a documented legal basis. "We sync contacts from the CRM" is not a legal basis. This blocks Gate 3.5 immediately and requires escalation to Agente00_TechLead.

### 4. Sync Log ❌

**VIOLATION: FM-05 — Missing sync_log**
**Gate 3.5 status: BLOCKED_MISSING_SYNC_LOG**

```typescript
// ❌ WRONG: syncLog only on success path — missing from finally
try {
  const result = await crmContactSync.run()
  await syncLog({ job: "crm-sync", status: "success", counts: result.counts })
} catch (error) {
  console.error("Sync failed:", error)
  // ❌ syncLog never called on error — production failures are invisible
}
```

**Why this is wrong:** When the sync job fails (which it will, eventually), there is no `sync_log` entry. Operators see nothing in the monitoring dashboard. They cannot distinguish "job failed" from "job never ran." The correct pattern is `finally { syncLog(...) }`.

### 5. External API Response Handling ❌

**VIOLATION: FM-03 — Missing Zod on External Response**
**Gate 3.5 status: BLOCKED_MISSING_ZOD**

```typescript
// ❌ WRONG: type assertion instead of validation
const contacts = await response.json() as CrmContactListResponse
// Using contacts.data without any validation
```

**Why this is wrong:** `as CrmContactListResponse` is a lie to TypeScript. It does not validate anything at runtime. If the CRM API returns `null` for `email` (because they changed a field to nullable), the code crashes at `contact.email.toLowerCase()` — far from where the real bug is. The correct pattern is `CrmContactListSchema.parse(await response.json())`.

### 6. Authentication ❌

**VIOLATION: FM-06 — Hardcoded Credentials**
**Gate 3.5 status: BLOCKED_CREDENTIAL_VIOLATION**

```typescript
// ❌ WRONG: literal API key in integration spec
const headers = {
  Authorization: "Bearer sk-crm-prod-key-a1b2c3d4e5f6g7h8"
}
```

**Why this is wrong:** API key exposed in a spec document that is committed to version control. Now the secret is in git history forever, even after deletion. It cannot be rotated without updating the spec. Use `env.CRM_API_KEY` from `lib/env.ts`.

### 7. Transaction Violation ❌

**VIOLATION: FM-04 — Sync Inside Prisma Transaction**
**Gate 3.5 status: BLOCKED_TRANSACTION_VIOLATION**

```typescript
// ❌ WRONG: external API called inside a Prisma transaction
await prisma.$transaction(async (tx) => {
  const crmContacts = await crmPlatformClient.listContacts()  // external call!
  await tx.contact.createMany({ data: crmContacts.map(transform) })
})
```

**Why this is wrong:** The Prisma transaction holds a database connection open for its entire duration. The external API call can take 5–30 seconds. With a connection pool of 10, 10 simultaneous calls would exhaust the entire pool. Deadlocks ensue. Correct pattern: call external API first (outside transaction), then open transaction to persist results.

---

## Summary of Violations

| Violation | Failure Mode | Gate 3.5 Status Code |
|-----------|-------------|---------------------|
| `create()` without upsert | FM-01 | `BLOCKED_MISSING_IDEMPOTENCY` |
| PII without legal basis | FM-02 | `BLOCKED_LGPD_VIOLATION` |
| No Zod on external response | FM-03 | `BLOCKED_MISSING_ZOD` |
| External call inside transaction | FM-04 | `BLOCKED_TRANSACTION_VIOLATION` |
| syncLog only on success path | FM-05 | `BLOCKED_MISSING_SYNC_LOG` |
| Literal API key in spec | FM-06 | `BLOCKED_CREDENTIAL_VIOLATION` |

**This spec would not advance past Gate 3.5 under any circumstance. All 6 blocking criteria are triggered.**
