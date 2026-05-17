// GOOD EXAMPLE: Correct Prisma DAL Implementation
// File: lib/db/task.dal.ts
//
// This example demonstrates:
// ✓ Single prisma import — only in DAL files
// ✓ Named const export — not default, not individual functions
// ✓ All operations typed with Prisma generated types
// ✓ No raw SQL — all operations via Prisma parameterized API
// ✓ Upsert included for cron job idempotency
// ✓ Clean function names that reveal intent

import { prisma } from "@/lib/db/prisma"
import type { Task, Prisma } from "@prisma/client"

// ✓ All Task DB operations go through this object
// ✓ Named const export — consumers: features/tasks/actions/*.ts, features/tasks/task.service.ts
export const taskDal = {
  async findById(id: string): Promise<Task | null> {
    return prisma.task.findUnique({
      where: { id },
    })
  },

  async findManyByUser(
    userId: string,
    options?: {
      status?: string
      skip?: number
      take?: number
    }
  ): Promise<Task[]> {
    return prisma.task.findMany({
      where: {
        userId,
        ...(options?.status ? { status: options.status } : {}),
      },
      orderBy: { createdAt: "desc" },
      skip: options?.skip,
      take: options?.take,
    })
  },

  async countByUser(userId: string, status?: string): Promise<number> {
    return prisma.task.count({
      where: {
        userId,
        ...(status ? { status } : {}),
      },
    })
  },

  // ✓ Input typed with Prisma.TaskCreateInput — TypeScript enforced at compile time
  async create(data: Prisma.TaskCreateInput): Promise<Task> {
    return prisma.task.create({ data })
  },

  // ✓ Update typed with Prisma.TaskUpdateInput — partial updates supported
  async updateById(id: string, data: Prisma.TaskUpdateInput): Promise<Task> {
    return prisma.task.update({
      where: { id },
      data,
    })
  },

  async deleteById(id: string): Promise<void> {
    await prisma.task.delete({
      where: { id },
    })
  },

  // ✓ Upsert for cron job idempotency — creates if not exists, updates if exists
  // externalId is a stable key from the source system (not a generated UUID)
  async upsertByExternalId(
    externalId: string,
    create: Prisma.TaskCreateInput,
    update: Prisma.TaskUpdateInput
  ): Promise<Task> {
    return prisma.task.upsert({
      where: { externalId },
      create,
      update,
    })
  },
}
