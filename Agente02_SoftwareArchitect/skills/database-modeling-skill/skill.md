# database-modeling-skill

## Purpose

Design the relational database schema using Prisma 7 conventions, produce a `Prisma_Schema_Proposal.prisma` and companion `DB_Schema.sql`, classify all data fields by privacy sensitivity, and document the indexing strategy. The schema is the authoritative data contract — all DAL functions and server actions must conform to it.

## When to Use

- After `Architecture.md` is complete and domain entities are identified
- When adding a new domain entity to an existing schema
- When revising the data model after a Gate 2 rejection or security review feedback
- When the `security-architecture-skill` produces a data classification that requires schema changes

## Inputs

- `Architecture.md` — domain entities and their relationships identified in the component inventory
- `PRD.md` — approved; data requirements, storage NFRs, data retention rules
- `context_view_path` — `Agente02_SoftwareArchitect/context_view.md` (§6 Database conventions)
- `templates/Prisma_Schema_Proposal.prisma` — base Prisma schema skeleton
- `templates/DB_Schema.sql` — companion SQL template
- `security_classification` — data classification from `security-architecture-skill` (if available)

## Outputs

- `Prisma_Schema_Proposal.prisma` — primary output; complete Prisma 7 schema with all models, relations, and `@map`/`@@map` annotations
- `DB_Schema.sql` — supplementary; CREATE TABLE statements in PostgreSQL syntax derived from the Prisma schema
- Data classification section appended to `Security_Strategy.md` (if file exists) or as standalone `Data_Classification.md`

## Procedure

1. **Extract domain entities** — read `Architecture.md` component inventory. List every noun that represents persistent data. Map each to a Prisma model.

2. **Apply naming conventions:**
   - Prisma model names: `PascalCase` (e.g., `JobApplication`)
   - Prisma field names: `camelCase` (e.g., `createdAt`)
   - Database table names: `snake_case` via `@@map` (e.g., `@@map("job_applications")`)
   - Database column names: `snake_case` via `@map` (e.g., `createdAt @map("created_at")`)
   - Never use Prisma defaults that produce camelCase in PostgreSQL — always map explicitly

3. **Classify data fields** — for each field, assign a classification:
   - `PUBLIC`: non-sensitive, no access restrictions
   - `INTERNAL`: business data, access restricted to authenticated users
   - `CONFIDENTIAL`: business-sensitive (salaries, internal notes)
   - `PII`: personally identifiable information (names, emails, phone numbers, addresses)
   - `PII_SENSITIVE`: highly sensitive PII (SSN, passport, health data)
   - Annotate PII and PII_SENSITIVE fields with `/// @privacy: PII` comment in the schema

4. **Design primary keys** — use `String @id @default(cuid())` for application-level IDs. Never use sequential integer IDs for user-facing resources (enumerable). Use `@default(autoincrement())` only for internal audit tables.

5. **Define relations** — for each relation:
   - Explicit `@relation` annotation with field and reference lists
   - `onDelete` behavior explicitly stated: `Cascade`, `Restrict`, or `SetNull`
   - Never leave `onDelete` implicit

6. **Indexing strategy:**
   - `@unique` for natural unique keys (email, slug)
   - `@@index` for foreign keys used in frequent joins
   - `@@index` for columns used in WHERE clauses in hot paths (identified from PRD acceptance criteria)
   - `@@index` for soft-delete pattern: `(userId, deletedAt)` if applicable

7. **Soft deletes** — if the PRD requires data retention or audit trail, use `deletedAt DateTime?` + `@@index([deletedAt])`. Never use physical deletes for user-visible data unless explicitly specified.

8. **Standard timestamps** — every model that is user-created or system-created must have:
   - `createdAt DateTime @default(now()) @map("created_at")`
   - `updatedAt DateTime @updatedAt @map("updated_at")`

9. **Generate `DB_Schema.sql`** — derive `CREATE TABLE` statements from the Prisma schema. Use `snake_case` for all table and column names. Include `FOREIGN KEY` constraints with explicit `ON DELETE` behavior. Include index `CREATE INDEX` statements.

10. **Verify with checklist** — run `checklists/database_modeling_checklist.md` before finalizing.

## Quality Gate

`Prisma_Schema_Proposal.prisma` passes this skill's quality check when:
- Every entity in `Architecture.md` has a corresponding Prisma model
- All PII and PII_SENSITIVE fields are annotated with `/// @privacy: PII` or `/// @privacy: PII_SENSITIVE`
- Every model has `@map` and `@@map` for all fields and tables
- Every relation has explicit `onDelete` behavior
- Every model has `createdAt` and `updatedAt` (except junction tables)
- No camelCase table or column names in PostgreSQL (verified via `@@map`/`@map`)

## Failure Modes

- **Missing `@map`/`@@map`:** Prisma generates camelCase in PostgreSQL — violates §6 naming conventions. Fix: add `@map`/`@@map` to all fields and models.
- **Missing privacy classification:** PII fields not annotated → block `security-architecture-skill` until classification is complete
- **Sequential IDs on user-facing models:** Using `@default(autoincrement())` on a model with a public-facing URL → change to `cuid()` or `uuid()`
- **Implicit `onDelete`:** Prisma defaults to `SetNull` or errors at migration time → always state `onDelete` explicitly
- **Missing indexes on foreign keys:** Un-indexed FK columns cause full table scans on joins → add `@@index` for every FK

## RAG Policy

Authorized collections at runtime:
- `data_intensive_applications` (knowledge/knowledge_cards.md — data modeling patterns)
- `domain_driven_design` (knowledge/knowledge_cards.md — aggregate boundaries, entity design)
- `enterprise_patterns` (knowledge/knowledge_cards.md — repository pattern)
- `architecture_reference_full` (context_view.md §6 Database conventions)

Blocked at runtime: `context/`, `lib/`, raw PDFs

## Architecture Compliance

This skill's output must comply with:
- `context_view.md §6` — Prisma naming conventions and migration policy
- `context_view.md §1.2` — Golden Path (Prisma 7 + PrismaPg adapter + PostgreSQL on Supabase)
- `checklists/database_modeling_checklist.md`

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:
- its local files (`skill.md`, schemas, checklist, examples)
- `Agente02_SoftwareArchitect/knowledge/`
- `Agente02_SoftwareArchitect/context_view.md`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
