# Good Output Example — prisma-dal-skill

```typescript
// lib/db/task.dal.ts
import { prisma } from "@/lib/db/prisma"
import type { Task, Prisma } from "@prisma/client"

export const taskDal = {
  async findById(id: string): Promise<Task | null> {
    return prisma.task.findUnique({ where: { id } })
  },
  async findManyByUser(userId: string, skip?: number, take?: number): Promise<Task[]> {
    return prisma.task.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
      skip,
      take,
    })
  },
  async create(data: Prisma.TaskCreateInput): Promise<Task> {
    return prisma.task.create({ data })
  },
  async updateById(id: string, data: Prisma.TaskUpdateInput): Promise<Task> {
    return prisma.task.update({ where: { id }, data })
  },
  async deleteById(id: string): Promise<void> {
    await prisma.task.delete({ where: { id } })
  },
  async upsertByExternalId(externalId: string, create: Prisma.TaskCreateInput, update: Prisma.TaskUpdateInput): Promise<Task> {
    return prisma.task.upsert({ where: { externalId }, create, update })
  },
}
```

**Why correct:** Named const export, Prisma typed, no raw SQL, upsert present, all operations parameterized.
