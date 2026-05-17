# Bad Output — migration-risk-analysis-skill

## Scenario

Same schema change: add `bio` column, rename `title` to `job_title`, drop `legacy_notes`.

## Produced analysis (problematic)

```
Migration risk: LOW

Changes:
- Add bio column
- Rename title column
- Remove legacy_notes

Rollback: run prisma db push to restore old schema

Migration command: npx prisma db push --accept-data-loss
```

## Problems identified

| # | Problem | Rule violated |
|---|---------|--------------|
| 1 | "Migration risk: LOW" — bulk single classification for 6 distinct changes | Each change must be classified individually; you cannot summarize until you classify each step |
| 2 | "Add bio column" — no risk level stated for this step | Every step needs REVERSIBLE/COMPATIBLE/IRREVERSIBLE/DESTRUCTIVE |
| 3 | "Remove legacy_notes" classified as LOW — this is DESTRUCTIVE (data loss) | DROP COLUMN is always DESTRUCTIVE if data exists |
| 4 | Rollback plan: "run prisma db push to restore old schema" — this is both wrong and dangerous | `prisma db push` is only for local/sandbox; it does not restore dropped columns; it can cause additional data loss |
| 5 | Migration command: `prisma db push --accept-data-loss` — explicitly forbidden in staging/prod | Must use `prisma migrate deploy` for staging/prod environments |
| 6 | No three-phase plan for DESTRUCTIVE changes | DESTRUCTIVE migrations require Phase 1 (app change) + Phase 2 (monitor) + Phase 3 (maintenance window) |
| 7 | No RISK-NNN entries produced | Risk_Register.md not updated |
| 8 | No maintenance window declared despite DROP operations | DESTRUCTIVE operations require maintenance window declaration |

## Gate result

`RETURNED_FOR_REVISION` — migration risk analysis fails on 8 dimensions. The use of `prisma db push --accept-data-loss` in staging/prod is a critical violation that blocks Gate 2 independently. Skill must rerun with per-step classification and correct migration commands.
