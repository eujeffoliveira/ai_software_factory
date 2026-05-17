# Bad Output — database-modeling-skill

## Scenario

Same job board SaaS. 4 entities to model.

## Produced Prisma schema (excerpt — problematic)

```prisma
model User {
  id        Int      @id @default(autoincrement())
  email     String   @unique
  name      String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  Company   Company?
}

model Job {
  id          Int     @id @default(autoincrement())
  title       String
  description String
  companyId   Int
  company     Company @relation(fields: [companyId], references: [id])
}

model JobApplication {
  id          Int    @id @default(autoincrement())
  jobId       Int
  applicantId Int
  job         Job    @relation(fields: [jobId], references: [id])
  applicant   User   @relation(fields: [applicantId], references: [id])
}
```

## Problems identified

| # | Problem | Rule violated |
|---|---------|--------------|
| 1 | `@id @default(autoincrement())` on `User`, `Job`, `JobApplication` — sequential IDs expose row counts via public URLs | Use `cuid()` for user-facing models |
| 2 | No `@@map` on any model — Prisma would produce camelCase table names in PostgreSQL (`JobApplication` → public."JobApplication") | `@@map("snake_case")` required on every model |
| 3 | No `@map` on any field — `createdAt`, `updatedAt`, `companyId` stored as camelCase in DB | `@map("snake_case")` required on every field |
| 4 | `email` and `name` fields have no `/// @privacy: PII` annotation | PII classification mandatory before security-architecture-skill |
| 5 | `Job` relation has no `onDelete` — Prisma will error or use default (SetNull) which may break referential integrity | Every `@relation` must have explicit `onDelete` |
| 6 | `JobApplication` missing `createdAt` and `updatedAt` | Standard timestamps required on all non-junction models |
| 7 | No `@@index` on any foreign key column (`companyId`, `jobId`, `applicantId`) | FK columns must have `@@index` |
| 8 | No soft-delete field on `JobApplication` despite PRD requiring data retention | `deletedAt DateTime?` + `@@index([deletedAt])` required |
| 9 | `Company` entity from Architecture.md is entirely missing | `all_entities_covered: false` |

## Gate result

`RETURNED_FOR_REVISION` — schema fails quality gate on 9 dimensions. Skill must rerun with corrected naming conventions, privacy annotations, explicit relations, and all entities covered.
