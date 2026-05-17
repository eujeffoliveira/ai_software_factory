// TEMPLATE: Replace all [PLACEHOLDER] values with your implementation.
// File location: features/[domain]/actions/[actionName].test.ts
//       or: __tests__/[domain]/[actionName].test.ts
//
// REQUIRED test cases for every Server Action:
// 1. Returns Unauthorized when session is null
// 2. Throws/returns error when input is invalid
// 3. Returns result on valid input (success path)
// 4. Handles DAL/service error and returns generic error (error path)
//
// REQUIRED test cases for every Route Handler:
// 1. Returns 401 when session is null
// 2. Returns 400 when params/body are invalid
// 3. Returns 200/201 on success (success path)
// 4. Returns 500 on service error (error path)

import { describe, it, expect, vi, beforeEach } from "vitest"
import { [actionName] } from "@/features/[domain]/actions/[actionName]"
import { [model]Dal } from "@/lib/db/[model].dal"
import { auth } from "@/lib/auth"
import { auditLog } from "@/lib/audit"

// ── Mocks ──────────────────────────────────────────────────────────────────────
// Mock all external dependencies — tests should not hit real DB or APIs.
vi.mock("@/lib/auth")
vi.mock("@/lib/db/[model].dal")
vi.mock("@/lib/audit")

// ── Test Data ──────────────────────────────────────────────────────────────────
const mockSession = {
  user: { id: "user-1", email: "user@example.com" },
} as const

const validInput = {
  name: "Test [Entity]",
  // ... other required fields
}

const mockResult = {
  id: "[entity]-1",
  name: "Test [Entity]",
  userId: "user-1",
  createdAt: new Date("2026-05-17T00:00:00Z"),
}

// ── Test Suite ─────────────────────────────────────────────────────────────────
describe("[actionName]", () => {
  beforeEach(() => {
    // Reset all mocks before each test — prevents state leakage between tests
    vi.clearAllMocks()
    // Default: authenticated session
    vi.mocked(auth).mockResolvedValue(mockSession as any)
  })

  // ── Test Case 1: Unauthenticated ─────────────────────────────────────────────
  it("throws Unauthorized when session is null", async () => {
    vi.mocked(auth).mockResolvedValue(null)

    await expect([actionName](validInput)).rejects.toThrow("Unauthorized")

    // Verify no DB operations were attempted
    expect([model]Dal.create).not.toHaveBeenCalled()
  })

  // ── Test Case 2: Invalid Input ───────────────────────────────────────────────
  it("throws when name is empty string", async () => {
    await expect([actionName]({ name: "" })).rejects.toThrow()
    expect([model]Dal.create).not.toHaveBeenCalled()
  })

  it("throws when required fields are missing", async () => {
    await expect([actionName]({})).rejects.toThrow()
    expect([model]Dal.create).not.toHaveBeenCalled()
  })

  // ── Test Case 3: Success Path ────────────────────────────────────────────────
  it("returns created [entity] on valid input", async () => {
    vi.mocked([model]Dal.create).mockResolvedValue(mockResult as any)

    const result = await [actionName](validInput)

    expect(result).toEqual(mockResult)
    expect([model]Dal.create).toHaveBeenCalledWith(
      expect.objectContaining({ name: validInput.name })
    )
    // Verify audit_log was called after success
    expect(auditLog).toHaveBeenCalledWith(
      expect.objectContaining({
        actorId: mockSession.user.id,
        action: "[ACTION_PAST_TENSE]",
        entityId: mockResult.id,
      })
    )
  })

  // ── Test Case 4: Error Path ──────────────────────────────────────────────────
  it("throws generic error when DAL fails", async () => {
    vi.mocked([model]Dal.create).mockRejectedValue(new Error("DB connection failed"))

    await expect([actionName](validInput)).rejects.toThrow(
      "Operation failed. Please try again."
    )
    // Verify error is NOT the raw DB error (no internals exposed)
    await expect([actionName](validInput)).rejects.not.toThrow("DB connection failed")
  })

  // ── Additional cases (add as needed from acceptance criteria) ─────────────────
  // Example: Authorization check
  // it("throws Forbidden when user does not own the resource", async () => {
  //   const otherUserRecord = { ...mockResult, userId: "other-user" }
  //   vi.mocked([model]Dal.findById).mockResolvedValue(otherUserRecord as any)
  //   await expect([actionName]({ id: "[entity]-1" })).rejects.toThrow()
  // })
})
