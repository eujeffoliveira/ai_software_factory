# database-modeling-skill Checklist

## Pre-execution
- [ ] `Architecture.md` available with domain entities enumerated
- [ ] `PRD.md` read for data requirements, retention rules, privacy constraints
- [ ] Data classification input available (from security-architecture-skill or as open question to address here)
- [ ] ID strategy confirmed: default `cuid()` for user-facing models unless PRD states otherwise
- [ ] Soft-delete requirement confirmed for user-visible entities

## During execution
- [ ] Every domain entity in Architecture.md has a corresponding Prisma model
- [ ] Model names: `PascalCase` (e.g., `JobApplication`)
- [ ] Field names: `camelCase` in Prisma (e.g., `createdAt`)
- [ ] Table names: `snake_case` via `@@map` (e.g., `@@map("job_applications")`)
- [ ] Column names: `snake_case` via `@map` (e.g., `@map("created_at")`)
- [ ] Every relation has explicit `onDelete`: `Cascade`, `Restrict`, or `SetNull`
- [ ] Every user-created model has `createdAt` and `updatedAt` fields
- [ ] PII fields annotated: `/// @privacy: PII` or `/// @privacy: PII_SENSITIVE`
- [ ] No bare `String @id @default(autoincrement())` on user-facing models
- [ ] `@@index` added for all foreign keys
- [ ] `@@index` added for columns in hot-path WHERE clauses
- [ ] Soft-delete fields added where required: `deletedAt DateTime?` + `@@index([deletedAt])`
- [ ] DB_Schema.sql uses snake_case for all tables and columns
- [ ] DB_Schema.sql includes FOREIGN KEY constraints with ON DELETE behavior
- [ ] DB_Schema.sql includes CREATE INDEX statements for all Prisma @@index annotations

## Post-execution
- [ ] All entities covered — `missing_entities` list is empty
- [ ] All PII fields classified — `unclassified_pii_fields` list is empty
- [ ] `naming_convention_compliant: true`
- [ ] `relations_with_explicit_on_delete: true`
- [ ] Data classification section written to `Security_Strategy.md` or `Data_Classification.md`
- [ ] `migration_risk_notes` populated for `migration-risk-analysis-skill` input

## Runtime Knowledge Policy
- [ ] Skill does not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime
- [ ] Consult: `Agente02_SoftwareArchitect/knowledge/`, `Agente02_SoftwareArchitect/context_view.md`, and project artifacts as input only
