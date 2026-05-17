# Implementation Readiness Checklist
## Agente03 Software Engineer / Task Planner
## Version: 1.0.0

Run this checklist BEFORE beginning task decomposition.
This is the Definition of Ready for Agente03.
If any BLOCKING item fails, do not proceed — return BLOCKED_MISSING_ARTIFACT.

---

## Input Artifacts

### 1. Architecture Package from Agente02

- [ ] **[BLOCKING]** `Architecture.md` is present
- [ ] **[BLOCKING]** Architecture.md has a version number
- [ ] **[BLOCKING]** Architecture.md includes a list of all components (API routes, Server Actions, DB tables, UI components, cron jobs)
- [ ] `Architecture.md` includes non-functional requirements and performance/scalability constraints
- [ ] `Architecture.md` references the approved ADRs

### 2. API Contract

- [ ] **[BLOCKING]** `API_Contract.json` is present
- [ ] **[BLOCKING]** API_Contract.json defines all API endpoints with request and response schemas
- [ ] Each endpoint has HTTP method, path, request body schema, response schema, and auth requirements
- [ ] Endpoint schemas use Zod-compatible types

### 3. Database Schema

- [ ] **[BLOCKING]** DB schema is present (`DB_Schema.sql` or `Prisma_Schema_Proposal.prisma`)
- [ ] **[BLOCKING]** All tables/models required by Architecture.md are defined in the schema
- [ ] Each table has primary key, required fields, and relations defined
- [ ] Migration strategy is specified (`prisma migrate deploy` for staging/prod)

### 4. PRD

- [ ] **[BLOCKING]** `PRD.md` is present
- [ ] **[BLOCKING]** PRD.md has a list of acceptance criteria with unique IDs
- [ ] All acceptance criteria are traceable to architectural components
- [ ] PRD version matches the architecture version (no versioning drift)

### 5. Architecture Decisions (ADRs)

- [ ] **[BLOCKING]** `Architecture_Decisions.md` is present (or ADRs are embedded in Architecture.md)
- [ ] All ADRs include: decision, rationale, consequences, alternatives rejected
- [ ] Any Golden Path deviations are covered by ADRs
- [ ] ADR status is ACCEPTED (not PROPOSED or REJECTED)

### 6. Gate 2 Status

- [ ] **[BLOCKING]** Gate 2 status is `APPROVED` (confirmed in Agente02 handoff package)
- [ ] No outstanding BLOCKED status from Gate 2

---

## Architecture Comprehension

After reading Architecture.md:

- [ ] All architectural components have been enumerated (list produced)
- [ ] All API routes have been mapped to components
- [ ] All DB tables have been identified
- [ ] All Server Actions have been identified
- [ ] All Server Components and Client Components have been identified
- [ ] All cron jobs have been identified
- [ ] All configuration requirements (env vars, proxy.ts, etc.) have been identified
- [ ] Tech stack is the Golden Path (or ADRs exist for any deviations)
- [ ] Security requirements have been identified (auth, authorization, audit logging needs)

---

## Criteria Completeness

- [ ] PRD acceptance criteria have been read and understood
- [ ] A preliminary mapping of PRD criteria to architectural components exists
- [ ] No PRD criterion is obviously impossible given the architecture (if so, escalate before planning)
- [ ] PRD and Architecture.md are consistent — no conflicts found (if conflicts found, escalate immediately)

---

## Technical Constraints

- [ ] Framework is Next.js 16 App Router (or ADR exists for deviation)
- [ ] ORM is Prisma 7 with PrismaPg adapter (or ADR exists)
- [ ] Auth solution is NextAuth v5 with Google OAuth (or ADR exists)
- [ ] Validation uses Zod (or ADR exists)
- [ ] Tests use Vitest + Playwright (or ADR exists)
- [ ] All ADRs that constrain implementation have been read and will be reflected in task constraints

---

## Codebase (when applicable)

- [ ] If an existing codebase is provided, it has been reviewed for:
  - [ ] Files that will be modified by new tasks (listed as `file_path` in tasks)
  - [ ] Existing patterns and conventions that new tasks must follow
  - [ ] Existing Prisma schema entries (new tasks must not conflict)
  - [ ] Existing API routes (new tasks must not duplicate)

---

## Readiness Decision

| Category | Status |
|----------|--------|
| Architecture.md | [ ] Ready / [ ] Missing / [ ] Incomplete |
| API_Contract.json | [ ] Ready / [ ] Missing / [ ] Incomplete |
| DB Schema | [ ] Ready / [ ] Missing / [ ] Incomplete |
| PRD.md | [ ] Ready / [ ] Missing / [ ] Incomplete |
| Architecture_Decisions.md | [ ] Ready / [ ] Missing / [ ] Incomplete |
| Gate 2 Status | [ ] APPROVED / [ ] NOT APPROVED |

**Decision:**
- **All BLOCKING items pass → PROCEED** with task decomposition
- **Any BLOCKING item fails → RETURN** `BLOCKED_MISSING_ARTIFACT` with list of missing artifacts

---

## Notes

_Document any issues found during readiness review here before proceeding._
