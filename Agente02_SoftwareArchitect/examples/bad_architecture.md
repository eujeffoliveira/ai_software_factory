# Example: Bad Architecture — What to Avoid

_This example shows common architecture mistakes. Use it to understand what Gate 2 rejects._

---

# Architecture.md — TaskFlow SaaS [BAD EXAMPLE — DO NOT REPLICATE]

**Version:** 1.0  
**Golden Path Status:** NOT_ASSESSED

## ❌ Problem 1: Missing PRD Traceability

The architecture proposes a Redis cache, message queue with BullMQ, and a separate Node.js worker service — but the PRD only describes a CRUD task management application with no high-concurrency requirements.

**Why it fails:** Each component must justify its existence via a PRD requirement. Components without justification indicate over-engineering.

**Correct approach:** Use Vercel Cron + Next.js route for the digest job (Golden Path). Propose Redis/queue only if PRD specifies > 10,000 concurrent operations or response time < 50ms under high load.

---

## ❌ Problem 2: Middleware.ts in Next.js 16

```
// BAD
middleware.ts — session validation
```

**Why it fails:** Projects using Next.js 16 must use `proxy.ts`, not `middleware.ts`. This is a mandatory rule, not a preference.

**Correct approach:** Replace with `proxy.ts` following the Golden Path pattern.

---

## ❌ Problem 3: Deviating from Golden Path Without ADR

The architecture lists "MongoDB for task storage because it's more flexible."

**Why it fails:** MongoDB deviates from the Golden Path (PostgreSQL via Supabase + Prisma). This requires an ADR with: context, decision, alternatives, consequences, and review criteria. Without the ADR, Gate 2 is `BLOCKED_PENDING_ADR`.

**Correct approach:** Use PostgreSQL unless there is a documented, PRD-justifiable reason. Write ADR-001 before proposing MongoDB.

---

## ❌ Problem 4: Business Logic in route.ts

```ts
// BAD — route.ts with business logic
export async function POST(req: Request) {
  const body = await req.json();
  const user = await prisma.user.findUnique({ where: { id: body.userId } });
  if (!user || user.role !== 'admin') return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
  const task = await prisma.task.create({ data: { ...body, status: 'pending' } });
  await sendEmailNotification(task); // External API call in route.ts
  return NextResponse.json(task);
}
```

**Why it fails:** route.ts must be a thin shell. Business logic, authorization, external calls, and database access belong in lib/ or features/.

**Correct approach:** route.ts calls Server Action or lib/ functions only.

---

## ❌ Problem 5: No Risk Register

Architecture.md submitted without a Risk_Register.md, or with "No risks identified."

**Why it fails:** Every architecture has risks. A submission with no risks signals either: (a) risk identification was skipped, or (b) the architect is not engaged with the problem. Gate 2 will return `RETURNED_FOR_REVISION`.

**Correct approach:** Identify at minimum: migration risks, security risks, external dependency risks. Classify each as CRITICAL/HIGH/MEDIUM/LOW.

---

## ❌ Problem 6: No Security Strategy

Architecture.md mentions "we'll use authentication" without specifying: auth provider, authorization model, data classification, threat model, or audit logging plan.

**Why it fails:** Security architecture must be complete at Gate 2. Gate 5 (DevSecOps) cannot review what was never designed.

**Correct approach:** Complete Security_Strategy.md with threat model for every endpoint, data classification, and audit_log events.

---

## Summary of Failures in This Example

| Issue | Gate Impact |
|-------|-------------|
| Over-engineering without PRD justification | RETURNED_FOR_REVISION |
| middleware.ts in Next.js 16 | RETURNED_FOR_REVISION |
| MongoDB without ADR | BLOCKED_PENDING_ADR |
| Business logic in route.ts | RETURNED_FOR_REVISION |
| No Risk Register | RETURNED_FOR_REVISION |
| No Security Strategy | RETURNED_FOR_REVISION |
