// Good example: Well-structured Vitest test for the createTask Server Action
// Demonstrates: 4 required test cases, proper mocking, behavior testing, audit log verification

import { describe, it, expect, vi, beforeEach } from "vitest"
import { createTask } from "@/features/tasks/actions/createTask"

// Mock external dependencies at the module boundary (not internal implementation)
vi.mock("@/lib/db/task.dal", () => ({
  taskDAL: {
    create: vi.fn(),
    findById: vi.fn(),
  },
}))

vi.mock("@/lib/audit", () => ({
  auditLog: vi.fn(),
}))

vi.mock("next-auth", () => ({
  auth: vi.fn(),
}))

describe("createTask Server Action", () => {
  // Realistic mock session with generic identifiers
  const mockSession = {
    user: {
      id: "user-test-001",
      email: "testuser@organization.com",
      name: "Test User",
    },
    expires: "2099-12-31T00:00:00.000Z",
  }

  // Clear mock call history before every test to prevent cross-test pollution
  beforeEach(() => {
    vi.clearAllMocks()
  })

  // ─── Test Case 1: Unauthenticated ─────────────────────────────────────────
  // Tests the most critical behavior: auth check must exist and execute first
  // A missing auth check = CRITICAL security bug (auth bypass)

  it("returns Unauthorized when user is not authenticated", async () => {
    // Arrange: no session (unauthenticated caller)
    const { auth } = await import("next-auth")
    vi.mocked(auth).mockResolvedValue(null)

    // Act: call with otherwise-valid input
    const result = await createTask({
      title: "My test task",
      description: "A valid task description",
    })

    // Assert: unauthorized response
    expect(result).toEqual({ error: "Unauthorized" })

    // Critical assertion: the DAL must NOT have been called
    // This verifies the auth check happens BEFORE any DB operation
    const { taskDAL } = await import("@/lib/db/task.dal")
    expect(taskDAL.create).not.toHaveBeenCalled()

    // Also verify: audit log was NOT recorded for a rejected action
    const { auditLog } = await import("@/lib/audit")
    expect(auditLog).not.toHaveBeenCalled()
  })

  // ─── Test Case 2: Invalid Input ───────────────────────────────────────────
  // Verifies Zod validation rejects malformed data before reaching the DB
  // Tests two distinct invalid inputs using parameterized test

  it.each([
    [{ title: "" }, "empty title is rejected"],
    [{ title: null }, "null title is rejected"],
    [{ description: "no title at all" }, "missing title is rejected"],
  ])("returns validation error for invalid input — %s", async (input, _description) => {
    // Arrange: authenticated user
    const { auth } = await import("next-auth")
    vi.mocked(auth).mockResolvedValue(mockSession as any)

    // Act: call with the invalid input
    const result = await createTask(input as any)

    // Assert: validation error returned
    expect(result.error).toBeDefined()
    expect(result.success).toBeUndefined()

    // Verify: DB was NOT touched (validation happens before DAL call)
    const { taskDAL } = await import("@/lib/db/task.dal")
    expect(taskDAL.create).not.toHaveBeenCalled()
  })

  // ─── Test Case 3: Success Path ────────────────────────────────────────────
  // Happy path: valid authenticated request creates the entity
  // Also validates that audit log is called with correct parameters

  it("creates task and records TASK_CREATED audit log when authenticated user submits valid data", async () => {
    // Arrange: authenticated session
    const { auth } = await import("next-auth")
    vi.mocked(auth).mockResolvedValue(mockSession as any)

    // Arrange: DAL returns a realistic task record
    const { taskDAL } = await import("@/lib/db/task.dal")
    const mockCreatedTask = {
      id: "task-test-001",
      title: "My test task",
      description: "A valid task description",
      status: "PENDING",
      userId: mockSession.user.id,
      createdAt: new Date("2026-01-15T10:00:00.000Z"),
      updatedAt: new Date("2026-01-15T10:00:00.000Z"),
    }
    vi.mocked(taskDAL.create).mockResolvedValue(mockCreatedTask as any)

    // Arrange: audit log (just needs to be callable — no return value needed)
    const { auditLog } = await import("@/lib/audit")

    // Act: submit valid task data
    const result = await createTask({
      title: "My test task",
      description: "A valid task description",
    })

    // Assert: success result with the created task
    expect(result.success).toBe(true)
    expect(result.task).toBeDefined()
    expect(result.task?.id).toBe("task-test-001")
    expect(result.task?.title).toBe("My test task")

    // Assert: DAL called with correct data
    // userId comes from session (not from input) — critical security invariant
    expect(taskDAL.create).toHaveBeenCalledWith(
      expect.objectContaining({
        title: "My test task",
        description: "A valid task description",
        userId: mockSession.user.id, // MUST be from session, not from input
      })
    )

    // Assert: audit log recorded the action after successful creation
    // actorId and actorEmail MUST come from session (security invariant)
    expect(auditLog).toHaveBeenCalledWith(
      expect.objectContaining({
        actorId: mockSession.user.id,
        actorEmail: mockSession.user.email,
        action: "TASK_CREATED",
        entityType: "Task",
        entityId: "task-test-001",
      })
    )
  })

  // ─── Test Case 4: Error Path ──────────────────────────────────────────────
  // Verifies that DB errors are caught and a generic message is returned
  // CRITICAL: the raw DB error message must NEVER be exposed to the caller

  it("returns generic error without exposing DB details when DAL throws", async () => {
    // Arrange: authenticated session
    const { auth } = await import("next-auth")
    vi.mocked(auth).mockResolvedValue(mockSession as any)

    // Arrange: DAL throws a realistic PostgreSQL connection error
    const { taskDAL } = await import("@/lib/db/task.dal")
    vi.mocked(taskDAL.create).mockRejectedValue(
      new Error(
        "could not connect to server: Connection refused. Is the server running on host " +
        '"127.0.0.1" and accepting TCP/IP connections on port 5432?'
      )
    )

    // Act: call with valid input
    const result = await createTask({
      title: "My test task",
      description: "A valid description",
    })

    // Assert: error result (not success)
    expect(result.error).toBeDefined()
    expect(result.success).toBeUndefined()

    // CRITICAL assertions: internal DB error details must NOT be in the response
    // This prevents information disclosure to potential attackers
    expect(result.error).not.toContain("could not connect to server")
    expect(result.error).not.toContain("127.0.0.1")
    expect(result.error).not.toContain("5432")
    expect(result.error).not.toContain("Connection refused")

    // The error must be a user-facing generic message
    // (exact text depends on implementation — could be "Failed to create task" etc.)
    expect(typeof result.error).toBe("string")
    expect((result.error as string).length).toBeGreaterThan(0)
  })
})
