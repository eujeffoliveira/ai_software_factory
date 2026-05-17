# Database Modeling Checklist

_Run before finalizing Prisma_Schema_Proposal.prisma._

---

## Prisma Conventions

- [ ] All Prisma field names are camelCase
- [ ] All database column names are snake_case via @map("snake_case")
- [ ] All database table names are snake_case_plural via @@map("snake_case_plural")
- [ ] Primary keys use @id with @default(cuid()) or @default(uuid())
- [ ] All timestamps use @default(now()) and @updatedAt where appropriate

## Schema Design

- [ ] Every PRD entity has a corresponding Prisma model
- [ ] Relations are properly defined with @relation, fields, and references
- [ ] Appropriate indexes are defined for query patterns
- [ ] UNIQUE constraints are present where business rules require uniqueness
- [ ] Mandatory fields do not have ? (nullable) unless truly optional

## Mandatory Tables

- [ ] `audit_logs` table is present (or referenced in architecture for shared use)
- [ ] `sync_logs` table is present (or referenced)
- [ ] `users` table is present with status and role fields

## Privacy Classification

- [ ] Every field has been evaluated for privacy classification
- [ ] PII fields are annotated in comments with `// PII: [category]`
- [ ] Sensitive PII is identified and has specific handling notes
- [ ] No unnecessary PII fields (minimize collection principle)

## Migration Risk

- [ ] Migration risk is classified for every proposed schema change
- [ ] Destructive changes have a phased migration plan
- [ ] No column that is NOT NULL without a default has been added to a table with existing data without a backfill plan

## Aggregate Design (DDD)

- [ ] Aggregate roots are identified
- [ ] Aggregates reference other aggregates only by ID (not embedded objects across aggregate boundaries)
- [ ] Operations that must be atomic use the same aggregate or are explicitly designed for eventual consistency

## Idempotency

- [ ] Tables used by cron jobs have natural keys or unique constraints to support upsert
- [ ] No job table design requires distributed locks for simple operations that could use ON CONFLICT DO UPDATE
