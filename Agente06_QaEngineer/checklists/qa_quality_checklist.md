# QA Quality Checklist — Gate 4 Evaluation

> Run this checklist before issuing any Gate 4 decision. Every item must be checked. Any unchecked item blocks APPROVED.

---

## Definition of Ready (run before evaluation begins)

- [ ] `Backend_Implementation_Report.md` received from Agente04_DevBackend
- [ ] `Frontend_Implementation_Report.md` received from Agente05_DevFrontend
- [ ] `API_Contract.json` available and covers all new endpoints
- [ ] PRD with acceptance criteria (AC-NNN) in Given/When/Then format available
- [ ] Vitest test files submitted (at least one per new Server Action / Route Handler)
- [ ] Coverage report available (`coverage/lcov.info` or text summary)
- [ ] Playwright test files submitted for golden-path flows
- [ ] `gate_ready: true` in both Dev agents' Handoff Packages

---

## Acceptance Criteria

- [ ] Every AC-NNN in the PRD has been mapped to at least one test case
- [ ] No acceptance criterion is ambiguous — escalated and clarified if so
- [ ] Every `Then` clause has at least one test assertion
- [ ] All mapped tests are PASSING (0 failures)
- [ ] Acceptance Validation Report (AV-NNN-C1) produced and complete

---

## Test Completeness

- [ ] Test file exists for every new Server Action
- [ ] Test file exists for every new Route Handler
- [ ] Test file exists for every new frontend component with significant interaction
- [ ] Minimum 4 test cases per Server Action: unauthenticated, invalid input, success, error
- [ ] Auth null test present in every Server Action and Route Handler test suite
- [ ] Invalid input test verifies Zod schema rejection (not just "something went wrong")
- [ ] Success path test verifies return value AND audit log call (if applicable)
- [ ] Error path test verifies generic message — internal DB/exception details NOT in response

---

## Test Quality

- [ ] Tests describe behavior, not implementation (no internal function call verification)
- [ ] Test names follow `it("[does X] when [condition Y]")` pattern
- [ ] No CSS selectors or XPath in Playwright tests (only getByRole/getByLabel/getByText)
- [ ] No real DB calls in Vitest tests (all external dependencies mocked)
- [ ] `vi.clearAllMocks()` in `beforeEach` of every Vitest test suite
- [ ] No flaky Playwright tests (passes consistently — 5 consecutive runs before accepting)
- [ ] `test.each` used for parameterized test scenarios (not copy-pasted tests)

---

## Coverage

- [ ] Coverage report reviewed (tool output, not estimated — `vitest --coverage`)
- [ ] ≥ 80% line coverage for all new business logic files
- [ ] 100% line coverage for auth paths (login, session check, role verification)
- [ ] 100% line coverage for critical mutation paths (create/update/delete data)
- [ ] `catch` blocks in Server Actions covered (error path test exercises them)
- [ ] Coverage gaps identified and severity classified

---

## API Contract Validation

- [ ] Every endpoint in `API_Contract.json` has at least one test
- [ ] Success status codes verified (200/201/204 as appropriate)
- [ ] 401 behavior verified for all protected endpoints (no session → 401)
- [ ] 400 behavior verified for endpoints that accept a request body (invalid input → 400)
- [ ] 403 behavior verified for ownership-protected endpoints (wrong owner → 403 or 404)
- [ ] Response shapes validated with Zod parse against contract schema
- [ ] Error format verified (`{ error: "string" }` — no stack trace, no `error.message`)
- [ ] API Contract Validation Report (ACV-NNN-C1) produced

---

## Bug Classification

- [ ] Every test failure classified by severity (CRITICAL / HIGH / MEDIUM / LOW)
- [ ] Every non-test-based finding (code review, logic error) classified by severity
- [ ] CRITICAL bugs have been escalated to Tech Lead (in addition to gate block)
- [ ] Bug reports written for all CRITICAL and HIGH findings (full BUG-NNN with reproduction steps)
- [ ] Medium and Low bugs documented in QA Report bug list

---

## Regression Analysis (resubmissions only — cycle > 1)

- [ ] Every bug from the previous QA cycle has been checked for resolution
- [ ] Every fixed bug has a regression test (`FIXED_WITH_REGRESSION_TEST` status)
- [ ] No bugs from previous cycle are NOT_FIXED
- [ ] No REGRESSED bugs (was fixed, now broken again)
- [ ] Regression Report (REG-NNN-C[N]) produced

---

## Accessibility

- [ ] Keyboard navigation tested for all primary user flows
- [ ] Focus visibility confirmed (focused element always visible)
- [ ] ARIA labels present on all interactive elements (buttons, links, inputs)
- [ ] Form inputs have associated labels (getByLabel works for all inputs)
- [ ] Errors announced via `role="alert"` or `aria-live`
- [ ] Skip link present and functional (if app has navigation header)
- [ ] Accessibility violations classified (primary flow violations = HIGH severity)

---

## QA Report

- [ ] All 8 mandatory sections present in QA_Report.md
- [ ] Gate status code is from the authorized list
- [ ] Gate decision rationale cites specific evidence (test names, coverage %, bug IDs)
- [ ] No vague "tests pass" — specific numbers provided
- [ ] Sign-off checklist in QA Report has been completed

---

## Runtime Knowledge Policy

Use only: this checklist, `context_view.md`, `quality_gate.md`, `failure_modes.md`, `knowledge/decision_rules.md`, `knowledge/principles.md`, `templates/QA_Report.md`.  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
