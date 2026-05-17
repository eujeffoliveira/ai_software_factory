// BAD EXAMPLE: Poor Vitest test — DO NOT USE
// This file demonstrates multiple test quality anti-patterns
// See the annotations at the bottom for a detailed explanation of each problem

import { describe, it, expect } from "vitest"
// Problem 1: No imports of mocked dependencies
// Everything will use the real implementations
import { createTask } from "@/features/tasks/actions/createTask"

describe("createTask", () => {

  // Problem 2: Only one test case — the happy path
  // Missing: unauthenticated test, invalid input test, error path test
  // Gate 4 requires minimum 4 test cases per Server Action

  it("works", async () => {
    // Problem 3: No auth mock
    // Auth check will use whatever session is currently active in the test environment
    // If the test environment has an active session (which it often does by default),
    // the auth check passes accidentally — not because the code is correct

    // Problem 4: Type assertions bypass TypeScript safety
    const result = await createTask({
      title: "test" as any,
      userId: "some-user" as any, // Problem 5: userId in input — this should come from session!
    } as any)

    // Problem 6: Generic assertion that passes for ANY non-falsy return value
    // This test passes even if the function returns { error: "Unauthorized" }
    // because 'result' is truthy
    expect(result).toBeTruthy()

    // Problem 7: Testing implementation details instead of behavior
    // This checks HOW the code works internally, not WHAT it produces
    // When the implementation is refactored (even with identical behavior), this breaks
    // expect(internalHelper).toHaveBeenCalledTimes(2)  // Commented out but illustrative
  })

  // Problem 8: No test for unauthenticated access
  // There is literally no test that verifies the auth check exists
  // An auth bypass vulnerability would pass this test suite with flying colors

  // Problem 9: No test for invalid input
  // Zod validation is never exercised — you cannot tell if it exists

  // Problem 10: No test for error paths
  // The error handling code (the catch block) is never executed in any test
  // Line coverage will show this code as uncovered (below 80% threshold)
})

// ─── Why This Test Is BAD ─────────────────────────────────────────────────────
//
// This file would result in BLOCKED_MISSING_TESTS from Gate 4 for these reasons:
//
// 1. SINGLE TEST CASE
//    DR001 requires minimum 4 test cases per Server Action:
//    unauthenticated, invalid input, success path, error path.
//    This file has 1. The missing tests mean Gate 4 cannot validate basic correctness.
//
// 2. NO AUTH MOCK — NO AUTH TEST
//    The most critical test case (unauthenticated → 401/Unauthorized) is absent.
//    Without vi.mock("next-auth"), auth() may return a real or cached session in the
//    test environment, making the auth check appear to work when it might not.
//    DR016: auth null test is mandatory.
//
// 3. TESTING "TRUTHINESS" NOT BEHAVIOR
//    `expect(result).toBeTruthy()` passes when result is `{ error: "Unauthorized" }`.
//    This assertion provides zero protection — it validates almost nothing.
//    A test that passes for both correct and incorrect behavior is worse than no test
//    (it creates false confidence). See H3 (green tests on wrong code).
//
// 4. USERID FROM INPUT (NOT SESSION)
//    Passing `userId` as input to createTask is itself a design smell.
//    The userId must come from the session. A test that supplies userId in the input
//    is testing the wrong interface and masking an IDOR vulnerability.
//
// 5. TYPE ASSERTIONS EVERYWHERE
//    `as any` throughout the test means TypeScript cannot catch type mismatches.
//    The test could pass valid or invalid data without the type system raising an error.
//
// 6. NO MOCKS — REAL DEPENDENCIES
//    Without vi.mock() for the DAL, auth, and audit, the test calls the real
//    implementations. This makes tests slow (real DB), non-deterministic (depends on
//    test database state), and unable to isolate the function under test.
//
// 7. TEST NAME "works"
//    P2 (Tests are documentation): test names are executable specifications.
//    "works" documents nothing. It does not tell a reader what the function does,
//    under what conditions, or what the expected outcome is.
//    Good name: "creates task and records audit log when authenticated user submits valid data"
//
// 8. MISSING ERROR PATH
//    The catch block in createTask is never exercised by this test.
//    Line coverage: the error handling code shows 0% coverage.
//    The most dangerous bug pattern (DB error → stack trace exposed to client) is
//    completely undetected by this test suite.
//
// The correct implementation is in `good_test_case.ts`.
