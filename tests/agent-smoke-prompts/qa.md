# Smoke Test — @qa

## Purpose

Verify the QA Engineer agent generates appropriate test plans, distinguishes Vitest from Playwright correctly, achieves coverage targets, and aligns tests with BDD acceptance criteria from the PRD.

---

## Smoke Test 1 — Test Plan Generation

**Prompt:**
```
@qa gere um plano de testes para um módulo de autenticação Next.js com NextAuth v5. O usuário pode logar com Google OAuth e email/senha.
```

**Expected behavior:**
- Unit tests (Vitest): validation logic, token refresh, session handling
- Integration tests: database calls via Prisma DAL
- E2E tests (Playwright): full login flow, Google OAuth redirect, logout
- Negative tests: invalid credentials, expired tokens, CSRF
- Distinguishes Vitest (unit/integration) from Playwright (E2E browser)

**Pass signals:** Vitest + Playwright both mentioned, unit + integration + E2E layers
**Fail signals:** Only one test type, no negative tests, uses Jest instead of Vitest

---

## Smoke Test 2 — Coverage Target

**Prompt:**
```
@qa o PR de backend tem 65% de cobertura de testes unitários. Você aprova o Gate 4?
```

**Expected behavior:**
- DOES NOT approve — minimum is 80% unit test coverage
- Returns `RETURNED_FOR_REVISION` or similar
- Specifies which modules need more tests
- Does not allow exceptions without explicit ADR

**Pass signals:** Gate 4 not approved, 80% threshold mentioned
**Fail signals:** Approves despite coverage below threshold

---

## Smoke Test 3 — BDD Alignment

**Prompt:**
```
@qa a user story diz: "Como comprador, quero ver o histórico de pedidos dos últimos 30 dias". Gere os testes BDD.
```

**Expected behavior:**
- Given/When/Then format
- Covers happy path (last 30 days with orders)
- Covers edge cases (no orders in period, exactly 30 days boundary, user with no history)
- Maps to Playwright E2E scenarios

**Pass signals:** Given/When/Then format, boundary testing, empty state
**Fail signals:** Generic tests not derived from the user story

---

## Notes

QA artifacts go through Gate 4. All critical bugs must be resolved before Gate 4 approval. The `qa_report.md` DoD in `docs/definition-of-done/qa-report.md` defines the complete criteria.
