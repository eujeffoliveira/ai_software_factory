# Bad Example: Sync Strategy

> **Why this is incorrect:** This sync strategy has multiple violations that cause production failures. Each violation is annotated.

---

## Sync Strategy: payment-reconciliation (INCORRECT VERSION)

**Job:** payment-reconciliation
**Schedule:** Every night

---

### Implementation Plan ❌

```typescript
// ❌ WRONG: This is what the spec tells Agente04 to implement

export async function GET(req: Request) {
  // ❌ VIOLATION FM-05: Missing guardCron() — no cron secret validation
  // Any HTTP request to this endpoint will trigger the job
  
  try {
    // ❌ VIOLATION FM-04: External API called inside Prisma transaction
    await prisma.$transaction(async (tx) => {
      const transactions = await paymentGatewayClient.listTransactions()  // external call inside tx!
      
      for (const txn of transactions) {
        // ❌ VIOLATION FM-01: create() without upsert — not idempotent
        await tx.payment.create({
          data: {
            amount: txn.amount,
            currency: txn.currency,
            status: txn.status,
            // ❌ externalId not stored — no idempotency key
          }
        })
      }
    })
    
    // ❌ VIOLATION FM-05: syncLog only on success path
    await syncLog({ job: "payment-reconciliation", status: "success" })
    return NextResponse.json({ ok: true })
    
  } catch (error) {
    // ❌ syncLog NEVER called on error — failures are invisible
    console.log("Error:", error.message)  // ❌ also: error.message exposed
    return NextResponse.json({ error: error.message }, { status: 500 })
    // ❌ error.message exposed to HTTP response — information disclosure
  }
}
```

---

### Violations Annotated

**VIOLATION 1: No guardCron() — FM-07 (Missing Error Handling)**

```typescript
// ❌ WRONG: No secret validation
export async function GET(req: Request) {
  // Missing: guardCron(req)
```

**Impact:** Anyone who discovers the endpoint URL can trigger the reconciliation job arbitrarily, bypassing cron scheduling. An attacker or misconfigured system could trigger thousands of reconciliation runs, exhausting rate limits and database connections.

**Correct:**
```typescript
export async function GET(req: Request) {
  guardCron(req)  // FIRST CALL — validates Vercel CRON_SECRET header
```

---

**VIOLATION 2: External call inside Prisma transaction — FM-04**

```typescript
// ❌ WRONG: HTTP call inside $transaction()
await prisma.$transaction(async (tx) => {
  const transactions = await paymentGatewayClient.listTransactions()  // external HTTP call
  // ... tx operations ...
})
```

**Impact:** The database connection is held open for the entire duration of the external HTTP call (potentially 10–30 seconds). With 10 concurrent cron executions (Vercel can run multiple instances), all 10 DB connections are exhausted. The system becomes unresponsive. This is a production deadlock.

**Correct:**
```typescript
// External call BEFORE the transaction
const transactions = await paymentGatewayClient.listTransactions()
const validated = transactions.map(txn => PaymentSchema.parse(txn))  // Zod validation

await prisma.$transaction(async (tx) => {
  // Only DB operations inside the transaction
  for (const txn of validated) {
    await tx.payment.upsert({ where: { externalId: txn.id }, create: {...}, update: {...} })
  }
})
```

---

**VIOLATION 3: create() without upsert — FM-01 (Non-Idempotent Sync)**

```typescript
// ❌ WRONG: create — duplicates on retry
await tx.payment.create({ data: { amount: txn.amount, ... } })
// externalId not stored — cannot detect duplicates
```

**Impact:** Vercel Cron retries on timeout. The job runs twice. 1,000 transactions become 2,000 payment records. Financial reports double-count revenue. The billing team investigates for days before the root cause is found.

**Correct:**
```typescript
await tx.payment.upsert({
  where: { externalTransactionId: txn.transaction_id },
  create: { externalTransactionId: txn.transaction_id, amount: txn.amount, ... },
  update: { amount: txn.amount, status: txn.status, syncedAt: new Date() }
})
```

---

**VIOLATION 4: syncLog only on success path — FM-05**

```typescript
// ❌ WRONG: syncLog only in try block — never called on failure
try {
  // ... job logic ...
  await syncLog({ job: "payment-reconciliation", status: "success" })
} catch (error) {
  // syncLog never called — failure is invisible to operators
  console.log("Error:", error.message)
}
```

**Impact:** When the payment gateway is down and reconciliation fails at 01:00 AM, no `sync_log` entry is written. The monitoring dashboard shows... nothing. Operators don't know if the job failed or just didn't run. By the time the issue is discovered at 09:00 AM, 8 hours of payment data is missing.

**Correct:**
```typescript
try { ... }
catch (error) { errorMsg = error.message }
finally {
  await syncLog({ job: "payment-reconciliation", status: errorMsg ? "error" : "success", ... })
}
```

---

**VIOLATION 5: No pagination — offset or missing**

*(Spec does not mention pagination at all)*

**Impact:** `paymentGatewayClient.listTransactions()` returns the first page (typically 100 records). The remaining 4,900 daily transactions are never processed. Revenue reconciliation is 98% incomplete. This bug is invisible without a record count check.

**Correct:** Cursor-based pagination with `settled_after` cursor, batch loop until `has_more = false`.

---

**VIOLATION 6: Error details in HTTP response**

```typescript
return NextResponse.json({ error: error.message }, { status: 500 })
// ❌ Exposes internal error details to any HTTP client that queries the cron endpoint
```

**Impact:** Error messages may contain DB schema details, API endpoints, or internal IDs. Security vulnerability (information disclosure). Agente07_DevSecOps will flag this as a HIGH finding in Gate 5.

---

## Summary of Violations

| Violation | Impact | Gate |
|-----------|--------|------|
| No `guardCron()` | Anyone can trigger the job | Gate 3.5: RETURNED |
| External call in `$transaction` | DB deadlock under concurrent load | Gate 3.5: BLOCKED |
| `create()` without upsert | Duplicate payment records | Gate 3.5: BLOCKED |
| `syncLog` only on success | Silent production failures | Gate 3.5: BLOCKED |
| No pagination | Only first 100 records ever processed | Gate 3.5: BLOCKED |
| Error details in response | Information disclosure | Gate 5 finding |

**This spec would block Gate 3.5 immediately on submission.**
