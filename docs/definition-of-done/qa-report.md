# Definition of Done — QA_Report.md

## Overview

The QA Report is the formal quality certification produced after all implementation tasks are complete. It documents that the system has been tested at every level (unit, integration, E2E), that coverage targets have been met, that all critical bugs have been resolved, and that performance benchmarks pass. The QA Engineer does not write new code — the report evaluates whether the code written by Dev Backend and Dev Frontend agents meets the quality bar.

## Owner Agent

- **Primary:** `@qa` (Agente06_QaEngineer)
- **Gate:** Gate 4 — QA Review

## Required Fields / Sections

### Test Execution Summary
- [ ] Total number of tests executed (unit + integration + E2E)
- [ ] Pass/fail counts by test type
- [ ] Test run date and duration
- [ ] Test environment described (local, staging, CI)
- [ ] Test runner versions stated (e.g., Vitest 2.x, Playwright 1.x)
- [ ] All test suites pass — zero failing tests at submission

### Unit Test Coverage
- [ ] Coverage report is attached or linked
- [ ] Overall line/branch/function coverage is >= 80%
- [ ] Coverage is measured using the project's configured tool (e.g., Vitest + v8)
- [ ] Every Server Action has a dedicated test file
- [ ] Every Route Handler has a dedicated test file
- [ ] Each test file contains a minimum of 4 test cases: unauthenticated, invalid input, success path, error path
- [ ] Coverage below 80% for any critical path module is documented with a risk justification
- [ ] Auth mock is used consistently — no test hits real auth
- [ ] DAL mock is used consistently — no unit test hits a real database

### Integration Tests
- [ ] Integration tests verify the contract between layers (e.g., Server Action → DAL → DB)
- [ ] Integration tests run against a test database (not production or staging)
- [ ] All CRUD operations for every entity are covered by at least one integration test
- [ ] Integration tests verify that auth checks reject unauthenticated requests at the integration layer
- [ ] Integration test results are included in the report

### E2E Tests (Playwright)
- [ ] At least one Playwright test per user story from the PRD
- [ ] The happy path for every user-facing workflow is covered
- [ ] Tests run against a consistent, seeded test environment
- [ ] Playwright test results (pass/fail per scenario) are included in the report
- [ ] Screenshot or trace attached for any E2E test failure that was resolved
- [ ] E2E tests are not flaky — each has run 3 consecutive passes before being marked stable

### Regression Test Suite
- [ ] A regression test suite is defined and documented
- [ ] All tests from previous approved releases are included in the regression suite
- [ ] Regression suite passes in full
- [ ] Any test removed from the regression suite has a documented justification

### Bug Tracking
- [ ] All bugs found during QA are logged with: ID, severity, description, steps to reproduce, resolution
- [ ] Zero open `critical` severity bugs at submission
- [ ] Zero open `high` severity bugs at submission
- [ ] All `medium` severity bugs are documented with a resolution plan and owner
- [ ] `low` severity bugs are logged and deferred explicitly (not silently ignored)
- [ ] Bug report is included as an appendix or linked document

### Performance Benchmarks
- [ ] Performance tests cover the NFRs stated in Architecture.md
- [ ] Response time benchmarks pass the thresholds stated in the PRD (e.g., p95 < 300ms)
- [ ] Performance test methodology is documented (tool, load profile, duration)
- [ ] Any NFR threshold not met is documented as a risk with a severity assessment
- [ ] Database query performance assessed for any query on a table with > 10,000 expected rows

### Code Quality Findings
- [ ] All Server Actions pass the backend quality checklist (from `Agente04_DevBackend`)
- [ ] No `error.message` or stack traces exposed in API responses
- [ ] Auth check is first in every Server Action and Route Handler (verified by reading test mocks)
- [ ] Zod validation present at all input boundaries (verified by reading test invalid-input cases)
- [ ] All DAL functions are accessed through the DAL layer — no direct `prisma` calls in features (verified by code inspection)

### Handoff Package
- [ ] `required_next_agent` set to `"Agente07_DevSecOps"`
- [ ] `gate_ready` set to `true`
- [ ] `coverage_percentage` populated
- [ ] `total_tests` populated
- [ ] `open_bugs` list includes only `medium` and `low` severity items
- [ ] `risks` list populated for any NFR threshold not met

## Acceptance Criteria

| Criterion | How to verify |
|-----------|---------------|
| Unit coverage >= 80% | Read coverage report; overall percentage must be >= 80% |
| Zero failing tests | Run `vitest run` (or equivalent); exit code must be 0 |
| Every Server Action has a test file | List all files in `features/*/actions/`; verify a `.test.ts` file exists for each |
| Every test file has 4+ test cases | Open each test file; count `it()` or `test()` blocks; reject if fewer than 4 |
| No critical or high bugs open | Read bug log; zero items with severity `critical` or `high` and status `open` |
| Playwright happy paths pass | Run Playwright suite; all happy-path scenarios must pass |
| Performance benchmarks pass stated NFRs | Compare benchmark results against PRD NFR thresholds; all must be met or documented as risks |
| No stack traces in API responses | Search test files for assertions on error response bodies; verify generic messages only |

## Related Gates

- **Prerequisite:** All implementation tasks from Gate 3 completed; code submitted by Agente04_DevBackend and Agente05_DevFrontend
- **This gate:** Gate 4 — QA Review (evaluated by Agente06_QaEngineer; cannot be overridden)
- **Unblocks:** Gate 5 — Security Audit (Agente07_DevSecOps)

## Gate 4 Status Codes

| Code | Meaning |
|------|---------|
| `APPROVED` | All quality criteria met; pipeline advances to Gate 5 |
| `RETURNED_FOR_REVISION` | Code quality issues found; returned to Dev Backend/Frontend |
| `BLOCKED_MISSING_TESTS` | Test files absent or coverage below threshold; implementation agents must create them |
| `BLOCKED_SECURITY_VIOLATION` | Security issue found (missing auth, exposed internals); must be resolved before Gate 5 |

## Failure Examples

- **FAIL:** Coverage report shows 72% overall coverage. The 80% threshold is not met. Gate 4 cannot be approved until coverage is raised.
- **FAIL:** `features/tasks/actions/createTask.ts` exists but `features/tasks/actions/createTask.test.ts` does not. The implementation is not testable as submitted.
- **FAIL:** A test file for `deleteTask` contains only one test case (success path). The unauthenticated, invalid input, and error path cases are missing.
- **FAIL:** An E2E test for "create task" has been passing but fails on the second run. A flaky test is not a passing test.
- **FAIL:** The bug log shows 2 open `high` severity bugs. The QA report cannot be approved while high-severity bugs are unresolved.
- **FAIL:** Performance benchmark results are not included in the report. The Tech Lead cannot verify that NFR thresholds were tested.

## When to Block

Issue `BLOCKED_MISSING_TESTS` when:
- Any Server Action or Route Handler lacks a test file
- Any test file has fewer than 4 test cases
- Overall unit test coverage is below 80%

Issue `BLOCKED_SECURITY_VIOLATION` when:
- Any test reveals that an unauthenticated request succeeds (auth bypass)
- Any API response body contains `error.message` or stack trace content
- Any test reveals that a user can access or modify another user's resources

Return `RETURNED_FOR_REVISION` when:
- Any test is failing at submission time
- The performance benchmark methodology is absent or results are not attached
- The bug log is absent or incomplete

Issue `APPROVED` only when every checkbox in this document is checked, all tests pass, coverage is >= 80%, and no critical or high severity bugs are open.
