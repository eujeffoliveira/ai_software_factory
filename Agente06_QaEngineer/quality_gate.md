# Agente06_QaEngineer — Quality Gate 4 (QA Review)

## Gate Overview

| Field | Value |
|-------|-------|
| Gate number | 4 |
| Gate name | QA Review |
| QA Engineer role | **Owner and sole evaluator** |
| Submitters | Agente04_DevBackend + Agente05_DevFrontend |
| Can be overridden by Tech Lead | **NO — never** |
| Prerequisite | Gate 3 approved (Execution Plan) and both Dev agents' PRs submitted |
| Output if APPROVED | Handoff Package for Agente07_DevSecOps |
| Output if BLOCKED/RETURNED | Return Package for responsible Dev agents |

> **Inviolability notice:** Gate 4 is owned exclusively by the QA Engineer. The Tech Lead (Agente00) may escalate unresolved gate blocks to a human decision-maker, but cannot mark Gate 4 as passed on behalf of the QA Engineer. No other agent can override a `BLOCKED_*` status issued by this gate.

---

## Gate 4 Objective

Validate that the complete implementation (backend + frontend) is:
1. **Correct** — all acceptance criteria from the PRD are met by passing tests
2. **Tested** — every new function, action, endpoint, and flow has test coverage
3. **Contract-compliant** — all endpoints in `API_Contract.json` have tests verifying shape, status, auth, and error format
4. **Covered** — line coverage meets thresholds (80% new logic, 100% auth paths)
5. **Accessible** — primary user flows are keyboard-navigable and screen-reader compatible
6. **Regression-safe** — all bug fixes include regression tests

---

## Entry Criteria (what QA requires before evaluation begins)

All of the following must be present before Gate 4 evaluation starts:

| # | Entry Criterion | Missing → |
|---|----------------|-----------|
| 1 | `Backend_Implementation_Report.md` from Agente04 | RETURNED to Agente04 |
| 2 | `Frontend_Implementation_Report.md` from Agente05 | RETURNED to Agente05 |
| 3 | `API_Contract.json` available and covers all new endpoints | Escalate to Agente00 |
| 4 | PRD with acceptance criteria (AC-NNN) in Given/When/Then format | `BLOCKED_MISSING_ACCEPTANCE_CRITERIA` |
| 5 | Vitest test files present for all new Server Actions and Route Handlers | `BLOCKED_MISSING_TESTS` |
| 6 | Coverage report available (`coverage/lcov.info` or text summary) | `BLOCKED_QA_FAILURE` |
| 7 | Playwright test files present for golden-path flows | `BLOCKED_MISSING_TESTS` |
| 8 | `gate_ready: true` in both Dev agents' Handoff Packages | RETURNED to respective Dev agent |

If any entry criterion is missing, the gate evaluation does NOT proceed. QA returns the package immediately with the applicable status code.

---

## Mandatory Artifacts Produced

QA must produce ALL of the following before issuing a gate decision:

1. **`QA_Report.md`** — the primary Gate 4 artifact with all 8 mandatory sections
2. **Acceptance Validation Report** — table mapping every AC-NNN to test status
3. **API Contract Validation Results** — per-endpoint validation table
4. **Accessibility Regression Results** — per-flow accessibility checks
5. **Bug Reports** — one per CRITICAL/HIGH defect found (or consolidated for MEDIUM/LOW)
6. **Handoff Package JSON** — for APPROVED deliveries to Agente07, or return packages for blocked gates

---

## Gate 4 Status Codes

These are the only valid status codes for Gate 4. No other codes are accepted.

| Status Code | Meaning | Next Action |
|-------------|---------|-------------|
| `APPROVED` | All criteria met, all tests pass, coverage thresholds met, no CRITICAL/HIGH bugs | Pipeline advances to Gate 5 (Agente07_DevSecOps) |
| `RETURNED_FOR_REVISION` | Code quality issues, non-blocking bugs, implementation does not match specification in minor ways | Dev agent fixes cited issues and resubmits |
| `BLOCKED_MISSING_TESTS` | Test files absent for new Server Actions, Route Handlers, or frontend features | Dev agent creates the missing tests and resubmits |
| `BLOCKED_QA_FAILURE` | Tests fail, coverage below threshold, API contract mismatch, response shape wrong | Dev agent fixes the failing tests / code and resubmits |
| `BLOCKED_MISSING_ACCEPTANCE_CRITERIA` | PRD acceptance criteria absent, too ambiguous to test, or in wrong format | Escalate to Agente01_ProductOwner via Tech Lead — do not attempt to test ambiguous criteria |
| `BLOCKED_CRITICAL_RISK` | CRITICAL severity bug found — auth bypass, data loss, security vulnerability, data corruption | IMMEDIATE block + escalation to Agente00_TechLead — do not wait for next review cycle |

**Status code priority (if multiple apply):**
`BLOCKED_CRITICAL_RISK` > `BLOCKED_QA_FAILURE` > `BLOCKED_MISSING_TESTS` > `BLOCKED_MISSING_ACCEPTANCE_CRITERIA` > `RETURNED_FOR_REVISION`

---

## Blocking Conditions (any one blocks the gate)

The gate is blocked if ANY of the following are true:

| Blocking Condition | Status Code |
|-------------------|-------------|
| Any CRITICAL severity bug | `BLOCKED_CRITICAL_RISK` |
| Any unresolved HIGH severity bug | `BLOCKED_QA_FAILURE` |
| Line coverage below 80% for new business logic | `BLOCKED_QA_FAILURE` |
| Line coverage below 100% for auth paths or critical mutations | `BLOCKED_QA_FAILURE` |
| Any endpoint in API_Contract.json has no test | `BLOCKED_MISSING_TESTS` |
| Any new Server Action has no test file | `BLOCKED_MISSING_TESTS` |
| Any new Route Handler has no test file | `BLOCKED_MISSING_TESTS` |
| API response shape mismatches API_Contract.json | `BLOCKED_QA_FAILURE` |
| Acceptance criterion has no corresponding test | `BLOCKED_MISSING_TESTS` |
| Acceptance criteria undefined or too ambiguous | `BLOCKED_MISSING_ACCEPTANCE_CRITERIA` |
| Vitest tests use real DB / skip auth mocking | `BLOCKED_QA_FAILURE` |
| Playwright tests use CSS selectors or XPath | `RETURNED_FOR_REVISION` |

---

## Exit Criteria (all must be met for APPROVED)

| # | Exit Criterion |
|---|---------------|
| 1 | All acceptance criteria (AC-001 to AC-NNN) have at least one PASSED test |
| 2 | Vitest suite passes with 0 failures |
| 3 | Playwright suite passes with 0 failures |
| 4 | Line coverage ≥ 80% for all new business logic files |
| 5 | Line coverage = 100% for auth paths and critical mutation paths |
| 6 | Every endpoint in API_Contract.json has a validated test |
| 7 | No CRITICAL severity bugs unresolved |
| 8 | No HIGH severity bugs unresolved |
| 9 | Accessibility regression passes for all primary user flows |
| 10 | QA_Report.md contains all 8 mandatory sections |

---

## Override Policy

**Gate 4 cannot be overridden. The following are explicitly prohibited:**

- Tech Lead (Agente00) issuing an APPROVED for a gate that QA has blocked
- Any agent marking Gate 4 as passed without QA Engineer sign-off
- Advancing to Gate 5 while Gate 4 is in a BLOCKED state
- Treating a RETURNED_FOR_REVISION as an APPROVED for pipeline advancement

If there is pressure to override Gate 4 due to timeline risk, the Tech Lead must escalate to a human stakeholder. The human stakeholder takes responsibility for the override decision. The QA_Report.md records the override and the rationale.

---

## Human Escalation Triggers

Escalate to Agente00_TechLead (who escalates to human) when:

| Trigger | Action |
|---------|--------|
| CRITICAL bug found | Escalate immediately in addition to blocking the gate |
| Same area fails QA 3+ consecutive cycles | Flag as systemic architecture issue |
| Volume of bugs suggests timeline cannot be met | Risk escalation + new timeline estimate |
| Scope conflict: implementation doesn't match PRD | Architecture/Product decision needed |
| Acceptance criteria absent and product owner unreachable | Hold pipeline — do not test ambiguous scope |

---

## Gate 4 in the Full Pipeline

```
Gate 3 (Execution Plan)
    │ APPROVED
    ▼
Agente04_DevBackend  ──────────────────────────┐
Agente05_DevFrontend ──── (both deliver PRs) ──►│
                                                 ▼
                                        Gate 4 (QA Review)
                                        Agente06_QaEngineer
                                                 │
                    ┌────────────────────────────┤
                    │                            │
              BLOCKED/RETURNED               APPROVED
                    │                            │
              (back to Dev)                      ▼
                                        Gate 5 (Security Review)
                                        Agente07_DevSecOps
```

---

## Self-Review Before Issuing QA_Report.md

Run `checklists/qa_quality_checklist.md` in full before issuing any gate decision. Key items:

### Acceptance Criteria
- [ ] Every AC-NNN in the PRD has been mapped to a test
- [ ] No acceptance criterion is ambiguous (escalated if so)
- [ ] All mapped tests are PASSING

### Test Completeness
- [ ] Test file exists for every new Server Action
- [ ] Test file exists for every new Route Handler
- [ ] Test file exists for every new frontend feature with interaction
- [ ] Minimum 4 test cases per Server Action (unauth, invalid, success, error)

### Coverage
- [ ] Coverage report reviewed (not estimated)
- [ ] 80% line coverage confirmed for all new business logic
- [ ] 100% coverage confirmed for auth paths
- [ ] 100% coverage confirmed for critical mutations

### API Contract
- [ ] Every endpoint in API_Contract.json has a test
- [ ] Status codes verified (200/201/204/400/401/403/404)
- [ ] Response shapes validated against Zod schemas in contract
- [ ] Auth behavior validated (401 on all protected endpoints without session)

### Bug Classification
- [ ] All failures classified by severity
- [ ] CRITICAL bugs → `BLOCKED_CRITICAL_RISK` issued
- [ ] Bug reports written for all CRITICAL and HIGH severity findings

### QA Report
- [ ] All 8 mandatory sections present
- [ ] Gate status code is from the authorized list
- [ ] Evidence cited for every decision (test names, line numbers, coverage %)
