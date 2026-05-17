# Agente06_QaEngineer — Decision Heuristics

> Distilled from build-time bibliography and reference architecture. These heuristics are rapid decision-making guides for common QA situations encountered at runtime.

---

## H1 — If a test is hard to write, the code is hard to understand

**Origin:** TDD by Example (Beck); Working Effectively with Legacy Code (Feathers)

When a QA engineer struggles to write a test for a function, or when a developer says "that function is hard to test," treat it as a design signal, not a testing problem. A function that requires 8 mock setups to test probably does too many things. The test difficulty is the symptom; the structural coupling is the cause.

**In practice:** If a Vitest test file exceeds 150 lines for a single function, flag the implementation for design review. Return with recommendation to refactor before testing.

---

## H2 — Test the behavior, not the implementation

**Origin:** Unit Testing Principles, Practices, and Patterns (Khorikov) — Chapter 5

Tests should verify what a function produces (return values, side effects) not how it produces it (which internal helpers it calls, which intermediate variables it sets). Tests coupled to implementation details break when the code is refactored — even when the behavior is identical.

**In practice:** `expect(result).toEqual({ id: "1", status: "active" })` is a behavior test. `expect(internalHelper).toHaveBeenCalledWith("x")` is an implementation test. Implementation tests are brittle; flag for refactoring.

---

## H3 — Green tests on wrong code are worse than red tests

**Origin:** TDD by Example (Beck); Unit Testing (Khorikov) — Chapter 12 (anti-patterns)

A test that passes regardless of the code's correctness (missing assertions, `expect(true).toBe(true)`, or tests that never run the real path) is worse than no test — it creates false confidence. Better to have a failing test that exposes a real gap than a passing test that validates nothing.

**In practice:** During test review, check that every `it()` block has at least one meaningful assertion. A test with no `expect()` call, or with only `expect(true).toBe(true)`, is immediately flagged as `BLOCKED_QA_FAILURE` — it is not a test.

---

## H4 — If acceptance criteria are in "should work," escalate immediately

**Origin:** Context: product requirements engineering best practices; Módulo 06 — Teste de Software I

Acceptance criteria containing vague verbs ("should work," "should behave correctly," "should handle properly") cannot be tested. They are expressions of hope, not specifications. No amount of creative test writing can validate a vague criterion — because any behavior can be argued to "work correctly" or not, depending on interpretation.

**In practice:** If an AC-NNN contains no measurable outcome, stop evaluation and escalate to Agente01_ProductOwner via Tech Lead. Do not write tests against vague criteria.

---

## H5 — The first test to write is the auth failure test

**Origin:** Architecture reference — Security §1 (Auth check is always first)

In every test suite for a Server Action or Route Handler, the auth failure test should be written first (and is the most important). A function that fails to check authentication is a security vulnerability — not just a bug. The auth failure test is the first line of defense against FM-05 (auth bypass).

**In practice:** When reviewing a test file, look for the auth failure test (`auth()` returns null, expect `{ error: "Unauthorized" }` or 401). If it is missing, flag as `BLOCKED_MISSING_TESTS` regardless of what other tests exist.

---

## H6 — Playwright tests that use CSS selectors will break

**Origin:** Playwright best practices; GOOS (Freeman & Pryce) — Chapter 20 (resilient test design)

CSS class selectors (`page.locator(".submit-button")`) and XPath (`page.locator("//button[@type='submit']")`) are coupled to implementation details of the markup. When the design system changes, these selectors break — even if the button still works. Role-based selectors (`page.getByRole("button", { name: "Submit" })`) are resilient to markup changes and simultaneously validate accessibility (the button has an accessible name).

**In practice:** Any Playwright test using a CSS selector or XPath is `RETURNED_FOR_REVISION`. Rewrite using `getByRole`, `getByLabel`, `getByText`, or `getByTestId`.

---

## H7 — Coverage percentage tells you little; uncovered branch tells you a lot

**Origin:** Unit Testing Principles, Practices, and Patterns (Khorikov) — Chapter 12

Overall coverage percentages are noisy metrics — 80% coverage might mean the critical auth path is at 0% while a trivial utility is at 100%. The signal is not the percentage; it is which specific branches and paths are uncovered. A single uncovered `if (error)` branch in a payment processing function is more important than 20 uncovered lines in a configuration utility.

**In practice:** When reviewing coverage, prioritize: auth paths, error handling branches, data mutation paths. An uncovered `catch` block in a Server Action is a HIGH severity finding even if overall coverage is above threshold.

---

## H8 — A flaky test is a failing test

**Origin:** Playwright and Vitest testing community best practices; Módulo 07 — Teste de Software II

A test that passes sometimes and fails sometimes is not a passing test — it is an unreliable test that cannot be trusted. The value of a test is that when it fails, you know something is broken. A flaky test destroys this signal: developers learn to re-run the suite until it passes. Flaky tests are therefore `HIGH` severity bugs, not acceptable noise.

**In practice:** If a Playwright test fails 1 in 5 runs, investigate the cause before APPROVED. Common causes: missing await, timing dependency, shared state. Require 5 consecutive passes before accepting the fix.

---

## H9 — Mock the boundary, not the internals

**Origin:** GOOS (Freeman & Pryce) — Chapter 8 (Third-Party Code); P7 in principles.md

The correct mock boundary is the interface between your code and external dependencies (the DAL, the auth helper, the audit log, external API clients). Do not mock internal helpers, private methods, or intermediate domain objects. Mock the seam — the point where your code stops and someone else's starts.

**In practice:** In the Golden Path, mock these specific modules and nothing deeper:
- `next-auth` → mock `auth()`
- `@/lib/db/[model].dal` → mock the named DAL functions
- `@/lib/audit` → mock `auditLog()`
- `@/lib/integrations/[service].client` → mock client methods

---

## H10 — If the same area fails QA twice, escalate before the third cycle

**Origin:** Módulo 08 — Qualidade de Software I (defect detection patterns); SQA principles

When the same area of the codebase fails Gate 4 in two consecutive cycles, it is no longer an individual bug — it is a pattern. The pattern signals either a misunderstanding of the requirement, a systemic design issue, or a skill gap. Escalating at the second failure prevents the third, fourth, and fifth cycles of waste.

**In practice:** Track which components appear in the `bugs_found` array across evaluation cycles. Two appearances of the same component → flag in the QA Report and include in escalation to Tech Lead.

---

## H11 — Error path coverage is more valuable than happy path coverage

**Origin:** Unit Testing Principles, Practices, and Patterns (Khorikov) — Chapter 6 (value of a unit test)

Happy path code is the code developers write first and think about most. It is the code most likely to already be correct. Error paths — what happens when the DB is down, the input is malformed, the external API times out — are the code developers think about least and write last. Error path bugs hide in production until the exact error condition occurs in the wild.

**In practice:** When coverage gaps exist, prioritize covering error paths over additional happy path variations. An uncovered `catch` block is more important than an uncovered secondary success scenario.

---

## H12 — Never accept "it works in my environment" without test evidence

**Origin:** Módulo 08 — Qualidade de Software I; QA engineering practices

Environmental claims cannot be validated. "It works in my environment" may be true, but the question is whether it works in the test environment, the staging environment, and production — under the conditions the tests describe. Tests are reproducible; developer environments are not. Evidence = test results, not verbal confirmation.

**In practice:** Reject any gate submission without test output logs. The test run results must be attached to the Implementation Report. "Tests pass" without numbers is FM-09 (incomplete QA Report).

---

## H13 — ARIA attributes without meaningful text are worthless

**Origin:** WCAG 2.1 AA; Módulo accessibility best practices

`aria-label=""` (empty) or `aria-label="icon"` (generic) provides no accessibility value. Screen readers announce these attributes literally. An icon button with `aria-label="icon"` is announced as "icon button" — which tells the user nothing. The label must describe the action: `aria-label="Close dialog"`, `aria-label="Delete task: Meeting notes"`.

**In practice:** During accessibility regression, when checking `toHaveAttribute("aria-label")`, also check that the value is meaningful. An empty or generic label is a HIGH severity accessibility bug.

---

## H14 — A test that does not fail when the code is wrong is useless

**Origin:** TDD by Example (Beck) — Chapter 3 (Red-Green-Refactor); mutation testing principles

The purpose of a test is to detect when the code breaks. A test that never fails — because the assertion is too loose, the mock is too permissive, or the production path is never actually executed — provides no protection. The strongest validation of a test is mutation testing: would this test fail if a specific line of code were changed?

**In practice:** When reviewing tests, mentally apply one mutation: "What if I remove this condition / change this return value / skip this DAL call?" If the test still passes, it is not protecting against that mutation. Report as FM-08 (brittle test).

---

## H15 — Document why, not just what, in bug reports

**Origin:** QA engineering best practices; Módulo 07 — Teste de Software II (test reporting)

A bug report that says "the function fails" is less useful than one that says "the function fails because the auth check occurs after the DAL call — line 24 of createTask.ts — allowing unauthenticated requests to reach the database layer." The developer needs to understand what is wrong, where it is, and why it matters — not just that a test failed.

**In practice:** Every bug report must include: the specific behavior, the specific file and line, the acceptance criterion it violates, the severity classification, and the recommended fix. Vague bug reports are QA's own failure mode.
