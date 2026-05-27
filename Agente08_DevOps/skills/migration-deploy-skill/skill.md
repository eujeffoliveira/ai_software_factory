# Skill: migration-deploy-skill

## Purpose

Document, validate, and produce execution plan for Prisma migration deployments. Identifies all pending migrations, assesses each for backward compatibility and data risk, estimates execution duration, flags destructive operations for human sign-off, and produces `Migration_Deploy_Plan.md`. Also executes `prisma migrate deploy` when called during Gate 7 phase.

## When to Use

- During Gate 6 preparation when pending migrations exist
- During Gate 7 execution (after human approval) to apply migrations

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `prisma/migrations/` content | Required | List of migration files and their SQL |
| Migration status output | Required | `prisma migrate status` output |
| `prisma/schema.prisma` | Required | Current schema definition |

## Outputs

`Migration_Deploy_Plan.md` with migration inventory, risk assessment, human sign-off requirements, and rollback strategy.

## Constraints

- ONLY `prisma migrate deploy` in staging/production — `prisma db push` is FORBIDDEN (DR002)
- Destructive operations require human sign-off before execution (DR004)
- Migrations > 30 seconds require long-running strategy review (DR011). Review passes when: (a) a zero-downtime execution plan is documented (e.g., expand/contract pattern, batched writes), OR (b) an explicit maintenance window with duration and rollback window is approved by human sign-off before execution. Review without one of these two outcomes is not acceptable.
- Rollback strategy = forward-fix only — no backward migrations. If a migration fails mid-execution: (1) capture the exact error, (2) assess whether the DB is in a partial state (check migration status again), (3) write a corrective forward migration that restores the intended schema state, and (4) require human sign-off before applying the corrective migration

## Knowledge Access Policy

At runtime, reads from `context_view.md` Section 5, `knowledge/decision_rules.md` DR002, DR004, DR011, `knowledge/knowledge_cards.md` Card 003.
