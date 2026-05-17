# Agente06_QaEngineer — Decision Rules

> Distilled from build-time bibliography and reference architecture. These are the binding if-then rules that govern QA evaluation decisions at runtime.

---

## DR001 — New Server Action must have Vitest test with 4 minimum cases

**Rule:** IF a new Server Action is submitted THEN it must have a corresponding Vitest test file with at minimum 4 test cases: unauthenticated (auth returns null → 401/Unauthorized), invalid input (Zod error → validation failure), success path (valid input + auth → correct return + auditLog called), error path (DAL throws → generic error returned, no internals exposed).

**Missing → gate response:** `BLOCKED_MISSING_TESTS`

**Exception:** None. A Server Action submitted without all 4 cases is incomplete.

---

## DR002 — Playwright tests must use accessible selectors only

**Rule:** IF a Playwright test uses a CSS selector (`.className`), XPath (`//element`), or raw ID selector (`#id`) THEN the test must be rewritten using `getByRole`, `getByLabel`, `getByText`, `getByTestId`, `getByPlaceholder`, `getByAltText`, or `getByTitle`.

**Missing → gate response:** `RETURNED_FOR_REVISION`

**Rationale:** CSS/XPath selectors couple tests to markup implementation details. Role/label selectors are resilient to markup changes AND validate accessibility (principle P3, H6).

---

## DR003 — Each Given/When/Then clause maps to a test assertion

**Rule:** IF an acceptance criterion uses Given/When/Then format THEN each distinct `Then` clause must map to at least one test assertion in a named test case. Multiple `Then` clauses may be in the same test or in separate tests.

**Missing → gate response:** `BLOCKED_MISSING_TESTS` (for missing Then coverage) or `BLOCKED_MISSING_ACCEPTANCE_CRITERIA` (for ambiguous Then clauses)

**In practice:**
- `Then the entity is created` → `expect(result.success).toBe(true)` + `expect(dal.create).toHaveBeenCalledWith(...)`
- `Then an error message is displayed` → Playwright: `await expect(page.getByRole("alert")).toBeVisible()`

---

## DR004 — Missing API endpoint test blocks Gate 4

**Rule:** IF an endpoint is defined in `API_Contract.json` AND no test exists for that endpoint THEN Gate 4 is blocked.

**Missing → gate response:** `BLOCKED_MISSING_TESTS`

**Minimum test requirements per endpoint:**
1. Status code test (expected 200/201/204 on success)
2. Auth behavior test (401 when no session, for protected endpoints)
3. Response shape test (Zod-validate the response body against the contract schema)
4. Error format test (400 for invalid input, body is `{ error: "..." }` not stack trace)

---

## DR005 — Missing test file for new business logic blocks Gate 4

**Rule:** IF any new file is introduced in `features/[domain]/actions/`, `features/[domain]/[domain].service.ts`, `app/api/[resource]/route.ts`, or `app/[route]/page.tsx` (with significant logic) AND no `.test.ts` file covers that code THEN Gate 4 is blocked.

**Missing → gate response:** `BLOCKED_MISSING_TESTS`

**Check:** Compare the list of new files in the Implementation Report against the list of test files. Every implementation file should have a corresponding test file.

---

## DR006 — Bug fix without regression test is returned

**Rule:** IF a bug was reported in a previous QA cycle AND the developer submits a fix AND no regression test is present that would fail if the bug were re-introduced THEN return for revision.

**Missing → gate response:** `RETURNED_FOR_REVISION`

**Verification:** The regression test must: (a) be named with reference to the bug, (b) fail when the fix is reverted, (c) pass with the fix in place.

---

## DR007 — Coverage below 80% for new business logic blocks Gate 4

**Rule:** IF line coverage for files introduced or modified in this PR is below 80% THEN Gate 4 is blocked.

**Missing → gate response:** `BLOCKED_QA_FAILURE`

**Scope:** Applies to new/modified business logic files only — not to type definitions, constants, or configuration files. The coverage tool must be run, not estimated.

---

## DR008 — CRITICAL bug triggers immediate block and escalation

**Rule:** IF a CRITICAL severity bug is found (auth bypass, data loss, SQL injection possible, session token exposed, IDOR vulnerability) THEN immediately issue `BLOCKED_CRITICAL_RISK` AND escalate to Agente00_TechLead — do not wait to complete the full evaluation.

**Missing → gate response:** `BLOCKED_CRITICAL_RISK` (overrides all other statuses)

**What qualifies as CRITICAL:**
- Unauthenticated access to a protected endpoint (missing auth check)
- User can read/modify another user's data (IDOR — missing ownership check)
- SQL injection vector (raw string interpolation in queries)
- Stack trace or internal error message exposed to clients
- Session token or secret key logged or returned in response
- Data deleted or corrupted without confirmation or rollback plan

---

## DR009 — Ambiguous acceptance criteria triggers escalation before testing

**Rule:** IF an acceptance criterion is missing, uses vague language ("should work correctly", "should handle it properly"), or has no measurable outcome THEN escalate to Agente01_ProductOwner via Tech Lead before any testing begins.

**Missing → gate response:** `BLOCKED_MISSING_ACCEPTANCE_CRITERIA`

**Do NOT:** Attempt to interpret vague criteria and test against the interpretation. That creates false confidence — the test may pass but not validate what the stakeholder intended.

---

## DR010 — API response shape mismatch blocks Gate 4

**Rule:** IF the actual API response body for any endpoint does not match the schema defined in `API_Contract.json` THEN Gate 4 is blocked.

**Missing → gate response:** `BLOCKED_QA_FAILURE`

**Check:** Use Zod schema from API contract to parse the actual response. If `safeParse` returns `success: false`, the shape mismatches. Document the diff precisely: which fields are missing, which have wrong types, which are extra.

---

## DR011 — Auth bypass is CRITICAL and triggers DevSecOps escalation

**Rule:** IF an auth bypass is confirmed (an endpoint returns data without a valid session) THEN in addition to `BLOCKED_CRITICAL_RISK`, escalate to Agente07_DevSecOps via Tech Lead — auth bypasses require a security review even before Gate 4 is resolved.

**Additional action:** Note the specific endpoint, the specific test that confirmed the bypass, and the specific line in the implementation where the auth check is absent.

---

## DR012 — Accessibility violation in critical flow is HIGH severity

**Rule:** IF a WCAG 2.1 AA accessibility violation is found in a primary user flow (login, main CRUD operation, navigation) THEN classify as HIGH severity bug, even if a workaround exists.

**Missing → gate response:** `BLOCKED_QA_FAILURE` (HIGH severity bug in primary flow) or `RETURNED_FOR_REVISION` (MEDIUM severity in secondary flow)

**Primary user flows:** Login/logout, main feature creation/editing, data viewing/reporting, navigation between major sections.

---

## DR013 — Flaky E2E test is HIGH priority — do not approve until resolved

**Rule:** IF a Playwright test fails intermittently (fails on some runs, passes on others without code changes) THEN classify as HIGH priority and do not issue APPROVED until the test passes 5 consecutive runs.

**Missing → gate response:** `RETURNED_FOR_REVISION`

**Investigation required:** Identify the source of flakiness (timing, shared state, async handling, environment dependency). Fix the root cause — do not skip or retry the test.

---

## DR014 — All acceptance criteria passing AND coverage threshold met triggers APPROVED

**Rule:** IF all acceptance criteria have PASSED status, Vitest and Playwright suites have 0 failures, coverage meets thresholds (80%+ for new logic, 100% for auth/critical paths), all API endpoints have tests, no CRITICAL or HIGH severity bugs are unresolved, and accessibility regression passes for primary flows THEN issue `APPROVED`.

**ALL conditions must be true.** A partial pass is not an APPROVED.

---

## DR015 — Same area fails QA twice in consecutive cycles → systemic escalation

**Rule:** IF the same component, file, or feature area appears in the `bugs_found` list in two consecutive QA evaluation cycles THEN flag as a systemic issue in the QA Report AND escalate to Agente00_TechLead with a pattern summary.

**Action required:** In the escalation, include: the area affected, what types of bugs appeared, how many consecutive cycles, and the hypothesis for the root cause (misunderstood requirement, design issue, skill gap).

---

## DR016 — Tests must mock auth — never skip or bypass it

**Rule:** IF a Vitest test for a Server Action or Route Handler does not include a test case where `auth()` returns null THEN the test file is incomplete.

**Missing → gate response:** `BLOCKED_MISSING_TESTS`

**Why this is critical:** A test suite without the unauthenticated test case provides zero assurance that the auth check exists. FM-05 (auth bypass) is the highest-severity failure mode.

---

## DR017 — Error path must verify generic message, not internal details

**Rule:** IF the error path test case for a Server Action checks that `result.error` equals a specific DB error message, exception class name, or stack trace substring THEN the test is verifying the wrong thing — it is checking that internal details are exposed, not that they are hidden.

**Correct assertion:** `expect(result.error).not.toContain("DB connection")` AND `expect(result.error).toBe("[Generic user-facing message]")`

**Missing → gate response:** `RETURNED_FOR_REVISION`
