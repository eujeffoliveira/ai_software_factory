# Testing Strategy Checklist

_Run before finalizing Testing_Strategy.md._

---

## Coverage Definition

- [ ] Unit test scope is defined (what gets unit tested, what doesn't)
- [ ] Integration test scope is defined
- [ ] E2E test scope is defined (critical flows only, not everything)
- [ ] Database test strategy is defined (real DB vs mock — if mock, justified)

## Priority Order

Testing priority order is defined and follows:
- [ ] #1 Critical Server Actions
- [ ] #2 Auth and authorization paths
- [ ] #3 guardCron() protection
- [ ] #4 lib/env.ts startup validation
- [ ] #5 Zod schemas (valid + invalid inputs)
- [ ] #6 lib/ utilities
- [ ] #7 Critical DAL
- [ ] #8 Critical E2E flows

## Tooling

- [ ] Unit/integration: Vitest (or ADR for alternative)
- [ ] E2E: Playwright (or ADR for alternative, or "not applicable for this scope")
- [ ] TypeScript: tsc --noEmit in CI
- [ ] Linting: ESLint in CI
- [ ] Build: next build in CI

## CI Requirements

- [ ] All CI steps are listed in order
- [ ] Blocking conditions are defined (what prevents merge)
- [ ] Test database provisioning is described for integration tests

## E2E Flows

- [ ] Every critical user flow is listed as a Playwright test case
- [ ] Login flow is always included
- [ ] Admin approval flow is included (if applicable)
- [ ] Primary business value flow is included

## No Anti-Patterns

- [ ] No strategy proposes mocking the database for integration tests without justification
- [ ] No "test everything" E2E strategy (E2E should cover critical flows only — expensive to maintain)
- [ ] No reliance on snapshots as the primary test strategy
