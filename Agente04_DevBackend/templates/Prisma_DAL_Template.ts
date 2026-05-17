// TEMPLATE: Replace all [PLACEHOLDER] values with your implementation.
// File location: lib/db/[model].dal.ts
//
// RULES for DAL files:
// 1. This is the ONLY file that imports prisma (besides lib/db/prisma.ts)
// 2. ALL DB operations for [Model] go through this object
// 3. NO raw SQL string concatenation — use Prisma parameterized API only
// 4. Export as named const object — not default export, not individual functions
// 5. Include upsert for cron job idempotency
// 6. All methods are typed using Prisma generated types

import { prisma } from "@/lib/db/prisma"
import type { [Model], Prisma } from "@prisma/client"

// All DB access for [Model] goes through [model]Dal.
// Consumers: features/[domain]/actions/*.ts, features/[domain]/[domain].service.ts
export const [model]Dal = {
  async findById(id: string): Promise<[Model] | null> {
    return prisma.[model].findUnique({
      where: { id },
    })
  },

  async findManyByUser(userId: string): Promise<[Model][]> {
    return prisma.[model].findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
    })
  },

  // Example: findMany with filters
  async findMany(
    where: Prisma.[Model]WhereInput,
    options?: {
      orderBy?: Prisma.[Model]OrderByWithRelationInput
      skip?: number
      take?: number
    }
  ): Promise<[Model][]> {
    return prisma.[model].findMany({
      where,
      orderBy: options?.orderBy ?? { createdAt: "desc" },
      skip: options?.skip,
      take: options?.take,
    })
  },

  async count(where?: Prisma.[Model]WhereInput): Promise<number> {
    return prisma.[model].count({ where })
  },

  async create(data: Prisma.[Model]CreateInput): Promise<[Model]> {
    return prisma.[model].create({ data })
  },

  async updateById(
    id: string,
    data: Prisma.[Model]UpdateInput
  ): Promise<[Model]> {
    return prisma.[model].update({
      where: { id },
      data,
    })
  },

  async deleteById(id: string): Promise<void> {
    await prisma.[model].delete({
      where: { id },
    })
  },

  // Upsert is critical for cron job idempotency.
  // Use when job processes external records that may already exist.
  async upsert(
    where: Prisma.[Model]WhereUniqueInput,
    create: Prisma.[Model]CreateInput,
    update: Prisma.[Model]UpdateInput
  ): Promise<[Model]> {
    return prisma.[model].upsert({
      where,
      create,
      update,
    })
  },
}
