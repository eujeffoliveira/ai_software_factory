# migration-risk-analysis-skill

## Purpose

Classify the risk of every proposed schema change, produce a migration execution plan, and determine whether a phased rollout is required. The output feeds directly into `Risk_Register.md` and `Deployment_Strategy.md`. No migration may proceed to staging or production without a risk classification produced by this skill.

## When to Use

- When a Prisma schema change is proposed (new table, new column, type change, column removal, table deletion)
- Before any migration is submitted to staging or production
- When revising a schema after Gate 2 feedback that modifies existing tables
- When evaluating whether a migration can be zero-downtime or requires a maintenance window

## Inputs

- `Prisma_Schema_Proposal.prisma` — the proposed schema change (from `database-modeling-skill`)
- `current_schema_path` — path to the current production/staging Prisma schema, if available (for diff-based analysis)
- `context_view_path` — `Agente02_SoftwareArchitect/context_view.md` (§6.4–6.6 Migration Policy)

## Outputs

- Migration risk entries in `Risk_Register.md` — one entry per migration step, using `RISK-NNN` IDs
- Migration execution plan section appended to `Deployment_Strategy.md`
- Summary: overall migration risk level (REVERSIBLE / COMPATIBLE / IRREVERSIBLE / DESTRUCTIVE)

## Risk Classification Taxonomy

Every schema change is classified into one of four categories:

### REVERSIBLE
The migration can be fully undone without data loss.
- Examples: adding a nullable column, adding an index, adding a new table
- Rollback: `DROP COLUMN`, `DROP INDEX`, `DROP TABLE`
- Execution: can run during deployment without maintenance window (if column is nullable)

### COMPATIBLE
The migration is forward-compatible with the current application code but cannot be trivially rolled back without a second migration.
- Examples: adding a NOT NULL column with a default value, renaming a column using a multi-step shadow approach, adding a unique constraint to an existing column
- Rollback: requires a new migration, not a simple inverse
- Execution: requires the new application code to be deployed before or simultaneously

### IRREVERSIBLE
The migration cannot be undone without data reconstruction or significant effort.
- Examples: changing a column type (e.g., `String` → `Int`), removing a unique constraint, changing a foreign key `onDelete` behavior
- Rollback: data may be altered; rollback requires restoring from backup or re-running a complex transformation
- Execution: requires a maintenance window or multi-phase approach. Create a data snapshot before running.

### DESTRUCTIVE
The migration permanently removes data or structure.
- Examples: `DROP COLUMN`, `DROP TABLE`, removing a foreign key while referenced data exists
- Rollback: data is gone unless a backup exists
- Execution: **mandatory phased plan** (see procedure step 6). Never deploy destructive migrations in a single step.

## Procedure

1. **Diff the schemas** — compare `Prisma_Schema_Proposal.prisma` against the current schema (or treat as "new from empty" if no current schema exists). Enumerate every individual change.

2. **Classify each change** — apply the taxonomy above to each change. A migration containing any DESTRUCTIVE change is overall DESTRUCTIVE. A migration with any IRREVERSIBLE change is at minimum IRREVERSIBLE.

3. **Assign RISK IDs** — each distinct migration step gets a `RISK-NNN` entry in `Risk_Register.md`:
   ```
   RISK-NNN | Migration: [description] | Classification: [REVERSIBLE/COMPATIBLE/IRREVERSIBLE/DESTRUCTIVE] | Mitigation: [plan]
   ```

4. **Write rollback plan** — for every non-REVERSIBLE migration:
   - State the exact SQL or Prisma command to roll back
   - State whether data loss occurs
   - State the backup step required before running

5. **Check zero-downtime eligibility** — a migration is zero-downtime eligible when:
   - All changes are REVERSIBLE (nullable additions, new tables, new indexes)
   - OR application code is backward-compatible with both old and new schema during the deploy window (expand-contract pattern)
   - Flag as "Requires maintenance window" if not eligible

6. **Produce phased plan for DESTRUCTIVE changes** — a phased plan has three steps:
   - Phase 1: Mark data as soft-deleted (application change, no schema change)
   - Phase 2: Deploy application change and monitor for 1 full deployment cycle
   - Phase 3: Run destructive migration in a maintenance window with backup confirmed

7. **Command validation** — verify that the migration will use `prisma migrate deploy` for staging/production. Never use `prisma db push`. Flag if deployment instructions say otherwise.

8. **Write to `Risk_Register.md` and `Deployment_Strategy.md`** — migration section includes: risk summary table, per-step classification, phased plan (if needed), rollback commands.

## Quality Gate

The migration risk analysis passes when:
- Every proposed schema change has a risk classification
- Every non-REVERSIBLE change has a rollback plan
- DESTRUCTIVE changes have a mandatory phased plan
- Migration command is `prisma migrate deploy` for staging/prod environments
- `Risk_Register.md` entries follow `RISK-NNN` format

## Failure Modes

- **Underclassifying risk:** Treating a `DROP COLUMN` as COMPATIBLE → apply the taxonomy strictly; if data is lost, it is DESTRUCTIVE
- **Missing rollback:** Stating "no rollback possible" without a phased plan → phased plan is the rollback strategy for DESTRUCTIVE migrations
- **Wrong migration command:** Writing `prisma db push` for staging/prod → this is only allowed for local/sandbox environments
- **Bulk classification:** Labeling the entire migration with one risk level without classifying each change individually → classify each change independently first, then derive overall level

## RAG Policy

Authorized collections at runtime:
- `data_intensive_applications` (knowledge/knowledge_cards.md — migration patterns, schema evolution)
- `architecture_reference_full` (context_view.md §6.4–6.6 Migration Policy)

Blocked at runtime: `context/`, `lib/`, raw PDFs

## Architecture Compliance

This skill enforces:
- `context_view.md §6.5` — Migration command policy (`prisma migrate deploy` in staging/prod)
- `context_view.md §6.6` — Destructive migration phased plan requirement
- `checklists/migration_risk_checklist.md`

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `lib/`, `context/`, or global build documents at runtime.

It may use only:
- its local files (`skill.md`, schemas, checklist, examples)
- `Agente02_SoftwareArchitect/knowledge/`
- `Agente02_SoftwareArchitect/context_view.md`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
