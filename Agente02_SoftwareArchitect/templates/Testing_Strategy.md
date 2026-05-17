# Testing Strategy — [Project Name]

**Version:** 1.0  
**Date:** YYYY-MM-DD  
**Architect:** Agente02_SoftwareArchitect

---

## 1. Testing Philosophy

Tests verify business behavior, not framework behavior. TypeScript and lint checks verify syntax; tests verify that the system does what the PRD requires.

---

## 2. Test Layers

| Layer | Tool | Scope | Location |
|-------|------|-------|----------|
| Unit | Vitest | Pure functions, service logic, Zod schemas | `tests/unit/` |
| Integration | Vitest + test DB | DAL functions, Server Actions | `tests/integration/` |
| E2E | Playwright | Critical user flows | `tests/e2e/` |
| Typecheck | `tsc --noEmit` | All TypeScript | CI |
| Lint | ESLint | All code | CI |
| Build | `next build` | Compilation | CI |

---

## 3. Test Priority (implement in this order)

1. **Critical Server Actions** — every Server Action with auth + authorization + business rule
2. **Auth and authorization** — login flow, session validation, role checks, rejected user behavior
3. **guardCron()** — verify cron route blocks unauthenticated requests
4. **lib/env.ts** — verify app fails to start with missing mandatory env vars
5. **Zod schemas** — valid and invalid inputs for all system boundaries
6. **Helpers and formatters** — utility functions in lib/
7. **Critical DAL** — database queries for critical domain operations
8. **Critical E2E flows** — flows listed in §4

---

## 4. Critical E2E Flows (Playwright)

| Flow | Description |
|------|-------------|
| User login | Google OAuth → pending state → admin approval → access granted |
| [Primary feature flow] | [Description of the most critical user journey] |
| Admin actions | Admin approves/rejects user → audit_log created |

---

## 5. Integration Test Database Policy

**Strategy:** [Real test database | Mock — if mock, justify why real DB tests are infeasible]

For real test database:
- Use a separate Supabase project or local PostgreSQL for tests
- Database is reset between test runs (transactions rolled back or DB truncated)
- Migrations applied via `prisma migrate deploy` before test run

---

## 6. CI Requirements

```yaml
# Every PR must pass:
- npm run typecheck
- npm run lint
- npm run test        # Vitest (unit + integration)
- npm run build

# Additionally for staging deploys:
- Playwright E2E tests against preview environment
```

**Blocking conditions (prevents merge):**
- Typecheck failure
- Lint failure
- Any test failure
- Build failure
- New business rule without test coverage

---

## 7. Coverage Targets

| Area | Target |
|------|--------|
| Server Actions (critical) | 100% — all critical paths |
| Auth/authorization | 100% — all paths |
| Zod schemas | 100% — valid + invalid inputs |
| lib/ utilities | ≥ 80% statement coverage |
| Overall | No hard target — quality over coverage number |
