# Architecture.md — [Project Name]

**Version:** 1.0  
**Date:** YYYY-MM-DD  
**Architect:** Agente02_SoftwareArchitect  
**PRD Version:** [version]  
**Golden Path Status:** FULLY_COMPLIANT | COMPLIANT_WITH_ADRS | NON_COMPLIANT_PENDING_ADRS

---

## 1. Executive Summary

[2-3 sentences describing the system's purpose and the key architectural decisions made.]

---

## 2. Architecture Style

**Style:** [fullstack-monorepo | fullstack-monorepo-with-worker | fullstack-monorepo-with-service]

**Justification:** [Why this style was chosen. Must trace to PRD non-functional requirements.]

**ADRs required:** [List ADR-NNN for each deviation, or "None — fully on Golden Path"]

---

## 3. System Components

### 3.1. Entry Points

| Component | Type | Location | Responsibility |
|-----------|------|----------|----------------|
| Proxy Guard | proxy | `proxy.ts` | Optimistic session check, cron route protection |
| Auth | auth | `auth.ts` | NextAuth v5, Google OAuth, callbacks, events |
| Healthcheck | route-handler | `app/api/health/route.ts` | Application and DB liveness check |

### 3.2. Application Layers

| Component | Type | Location | Responsibility |
|-----------|------|----------|----------------|
| [Domain] Pages | server-component | `app/(protected)/[domain]/page.tsx` | Protected initial reads |
| [Domain] Actions | server-action | `actions/[domain].ts` | Authorized mutations |
| [Domain] API | route-handler | `app/api/[domain]/route.ts` | REST endpoints (thin shell) |
| [Domain] Cron | cron-route | `app/api/cron/[job]/route.ts` | Scheduled job entry point |
| [Domain] DAL | dal | `lib/db/[domain].ts` | All database access for domain |
| [Domain] Service | service | `features/[domain]/[domain].service.ts` | Business logic |
| [Domain] Repository | dal | `features/[domain]/[domain].repository.ts` | Prisma queries |

### 3.3. External Integrations

| Integration | Type | Location | Purpose |
|-------------|------|----------|---------|
| [Service Name] | integration | `lib/integrations/[service]/` | [Purpose] |

---

## 4. Data Flows

### 4.1. Stable Read Flow

```
Browser
  → proxy.ts (session check)
  → Server Component (auth() validation)
  → lib/db/[domain].ts (DAL)
  → PostgreSQL/Supabase
```

### 4.2. Mutation Flow

```
Browser
  → Server Action (actions/[domain].ts)
  → auth() (session validation)
  → Role/status authorization
  → features/[domain]/[domain].service.ts
  → lib/db/[domain].ts
  → audit_log (if sensitive)
  → revalidatePath()
```

### 4.3. Cron Job Flow

```
Vercel Cron (vercel.json schedule)
  → app/api/cron/[job]/route.ts
  → guardCron() (CRON_SECRET validation)
  → lib/jobs/[job].ts
  → lib/db/[domain].ts
  → sync_log
```

### 4.4. Polling Flow (if applicable)

```
Browser
  → SWR (revalidateOnFocus: false)
  → app/api/[domain]/route.ts (thin shell)
  → lib/db/[domain].ts
  → PostgreSQL/Supabase
```

---

## 5. Technology Stack

| Component | Technology | Version | Notes |
|-----------|-----------|---------|-------|
| Framework | Next.js | 16.x | App Router, proxy.ts |
| Frontend | React | 19.x | Server Components by default |
| Language | TypeScript | 5.x | Strict mode |
| Styling | Tailwind CSS | 4.x | @theme in globals.css |
| Database | PostgreSQL | 16+ | Supabase hosted |
| ORM | Prisma | 7.x | PrismaPg adapter |
| Auth | NextAuth | 5.x (beta) | Google OAuth |
| Validation | Zod | 3.x | All system boundaries |
| Unit Tests | Vitest | 2.x | |
| E2E Tests | Playwright | — | Critical flows |
| Deploy | Vercel | — | Preview + Staging + Production |
| Cron | Vercel Cron | — | vercel.json configuration |

**Additional services (via ADR):**
- [Service] — ADR-NNN — [Purpose]

---

## 6. Database Schema Summary

See `Prisma_Schema_Proposal.prisma` and `DB_Schema.sql` for full definitions.

| Model | Table | Bounded Context | Key Relations |
|-------|-------|----------------|---------------|
| User | users | Auth/Identity | → Role |
| [Domain Model] | [table_name] | [Context] | [Relations] |

**Migration strategy:** `prisma migrate deploy` in staging and production.

---

## 7. Security Architecture

See `Security_Strategy.md` for full threat model.

**Auth:** NextAuth v5 + Google OAuth with domain restriction.  
**Authorization:** Server-side role + status check before all privileged operations.  
**Data protection:** [Summary of PII handling approach.]  
**Audit logging:** [Key actions that trigger audit_log.]

---

## 8. Observability

See `Observability_Strategy.md` for full specification.

**Structured logs:** JSON format, required fields: timestamp, level, message, requestId, userId.  
**audit_log:** [Key events.]  
**sync_log:** [Cron jobs.]  
**APM:** [Tool — or ADR reference.]  
**Healthcheck:** `GET /api/health` — validates app + DB.

---

## 9. Testing Strategy

See `Testing_Strategy.md` for full specification.

**Unit (Vitest):** Server Actions, lib/ functions, Zod schemas.  
**Integration (Vitest):** DAL functions with test database.  
**E2E (Playwright):** [Critical flows listed.]

---

## 10. Deployment Strategy

See `Deployment_Strategy.md` for full specification.

**Platform:** Vercel.  
**Environments:** Local → Preview → Staging → Production.  
**Migration:** `prisma migrate deploy` in CI/CD for staging and production.  
**Rollback:** [Summary — see Deployment_Strategy.md for full plan.]

---

## 11. Architecture Decisions

See `Architecture_Decisions.md` for all decisions.

| Decision | Status | ADR |
|----------|--------|-----|
| [Decision] | On Golden Path | — |
| [Decision] | Deviation | ADR-NNN |

---

## 12. PRD Requirement Traceability

| PRD Requirement | Architectural Decision | Component |
|----------------|----------------------|-----------|
| [NFR-01: response time < 500ms] | Server Components for initial renders | app/(protected)/ |
| [NFR-02: audit trail] | audit_log table + lib/db/audit-log.ts | lib/db/ |
| [FR-01: user login] | NextAuth v5 + Google OAuth | auth.ts, proxy.ts |

---

## 13. Open Questions

| # | Question | Impact | Blocking |
|---|----------|--------|----------|
| 1 | [Question] | [Impact] | Yes/No |

---

## 14. Assumptions

| # | Assumption | Impact if Wrong |
|---|-----------|-----------------|
| 1 | [Assumption] | [Impact] |
