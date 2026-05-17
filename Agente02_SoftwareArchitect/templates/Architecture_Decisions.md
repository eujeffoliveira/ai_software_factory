# Architecture Decisions — [Project Name]

**Version:** 1.0  
**Date:** YYYY-MM-DD  
**Architect:** Agente02_SoftwareArchitect

---

## Summary

| Decision | Golden Path? | ADR | Status |
|----------|-------------|-----|--------|
| Framework: Next.js 16 App Router | ✅ On Path | — | Approved |
| Database: PostgreSQL on Supabase | ✅ On Path | — | Approved |
| ORM: Prisma 7 with PrismaPg adapter | ✅ On Path | — | Approved |
| Auth: NextAuth v5 + Google OAuth | ✅ On Path | — | Approved |
| Deploy: Vercel | ✅ On Path | — | Approved |
| [Decision that deviates] | ❌ Deviation | ADR-001 | Proposed |

---

## Decisions

### D001 — Framework Choice: Next.js 16 App Router

**Decision:** Use Next.js 16 with App Router as the fullstack framework.  
**Rationale:** Golden Path — no justification required.  
**Impact:** All routes use App Router conventions; proxy.ts replaces middleware.ts.  
**ADR required:** No.

---

### D002 — Database: PostgreSQL on Supabase via Prisma 7

**Decision:** Use PostgreSQL on Supabase as the database with Prisma 7 as the ORM.  
**Rationale:** Golden Path — relational data with known schema, PostgreSQL provides ACID guarantees required for this domain.  
**Migration policy:** `prisma db push` locally, `prisma migrate deploy` in staging and production.  
**ADR required:** No.

---

### D003 — Authentication: NextAuth v5 + Google OAuth

**Decision:** Use NextAuth v5 with Google OAuth for authentication.  
**Rationale:** Golden Path. Domain restriction applied via callback.  
**User model:** status field with `pending / approved / rejected` lifecycle.  
**ADR required:** No.

---

### D004 — [Non-Golden-Path Decision Title]

**Decision:** [What was decided]  
**Rationale:** [Why the Golden Path is insufficient]  
**ADR:** [ADR-NNN] — Status: Proposed  
**Impact:** [Impact on architecture]

---

## Open ADRs

| ADR ID | Title | Status | Blocking |
|--------|-------|--------|----------|
| ADR-001 | [Title] | Proposed | Yes/No |

---

## Decisions Not Made (deferred to implementation)

| Topic | Deferred to | Reason |
|-------|------------|--------|
| [Topic] | Agente04_DevBackend | Implementation detail — not architecture decision |
| APM tool selection | DevOps phase | Requires operational budget decision |
