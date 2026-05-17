// BAD EXAMPLE: Incorrect Prisma DAL Implementation
// File: lib/db/task.dal.ts (WRONG VERSION)
//
// This example demonstrates 4 VIOLATIONS in data access layer code.

import { prisma } from "@/lib/db/prisma"

// VIOLATION 1: Default export instead of named const object
// Default exports make mocking in tests harder — vi.mock("@/lib/db/task.dal") won't
// give you a named property to mock individual methods on.
// Also: exporting individual functions (not an object) scatters the DAL — hard to discover
// which functions belong to the Task domain.
// FIX: export const taskDal = { findById: ..., create: ..., ... }
export default {
  // VIOLATION 2: No TypeScript types — using `any`
  // Without types, TypeScript cannot catch field mismatches, wrong argument types,
  // or return type errors. Bugs manifest at runtime in production, not at build time.
  // FIX: Use typed parameters: (id: string): Promise<Task | null>
  // and import type { Task, Prisma } from "@prisma/client"
  findTask: async (id: any) => {
    return prisma.task.findUnique({ where: { id } })
  },

  // VIOLATION 3: Raw SQL with string concatenation — SQL INJECTION vulnerability
  // If userId comes from user input and is not sanitized, an attacker can craft:
  // userId = "'; DROP TABLE tasks; --"
  // This would execute arbitrary SQL. CRITICAL security vulnerability.
  // FIX: Use Prisma parameterized API: prisma.task.findMany({ where: { userId } })
  // If raw SQL is absolutely required: prisma.$queryRaw(Prisma.sql`SELECT * WHERE user_id = ${userId}`)
  findTasksByUser: async (userId: string) => {
    // NEVER DO THIS:
    const rawSql = "SELECT * FROM tasks WHERE user_id = '" + userId + "'"
    return prisma.$queryRawUnsafe(rawSql)  // ← SQL injection via string concatenation
  },

  // VIOLATION 4: Template literal SQL interpolation — also SQL INJECTION
  // Template literals with $queryRaw (without Prisma.sql) are NOT parameterized.
  // The value is interpolated directly into the SQL string.
  // FIX: Use Prisma.sql template tag: prisma.$queryRaw(Prisma.sql`SELECT * WHERE id = ${id}`)
  findTaskWithRawQuery: async (id: string) => {
    // NEVER DO THIS:
    return prisma.$queryRaw`SELECT * FROM tasks WHERE id = ${id}`
    // This LOOKS safe because it's a tagged template, but $queryRaw with a regular
    // template literal is NOT the same as $queryRaw with Prisma.sql.
    // The correct form uses the Prisma.sql tag: Prisma.sql`...${id}...`
  },
}

// Also missing:
// - No upsert function (cron jobs have no way to be idempotent)
// - No updateById function (consumers have to use findTask + separate update call)
// - No TypeScript return types on any function
