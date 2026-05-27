# Skill: rollback-planning-skill

## Purpose

Produce a complete, tested `Rollback_Plan.md` with rollback trigger conditions, exact Vercel dashboard rollback steps, database forward-fix rollback strategy, estimated rollback time, and rollback owner. Gate 6 cannot issue `READY_FOR_HUMAN_APPROVAL` without a complete Rollback_Plan.md.

## When to Use

- Every deployment — mandatory, no exceptions
- Before issuing Gate 6 `READY_FOR_HUMAN_APPROVAL`

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Current production deployment ID | Required | Vercel deployment ID of current production build |
| Migration plan | When migrations exist | List of pending migrations and their rollback strategy |
| Healthcheck endpoint URL | Required | Production healthcheck URL |

## Outputs

`Rollback_Plan.md` following `templates/Rollback_Plan.md` structure

## Constraints

- Missing `Rollback_Plan.md` → Gate 6 `BLOCKED_NO_ROLLBACK_PLAN` (DR001)
- Rollback procedure must be verified in staging before production deployment. Verification steps: (1) identify the previous staging deployment ID, (2) execute the Vercel rollback in staging (promote the previous deployment), (3) run `healthcheck-validation-skill` in pre_deploy mode on the reverted staging URL, (4) confirm healthcheck PASS within 2 minutes. Document the verification result (pass/fail + timestamp) in `Rollback_Plan.md`.
- Database rollback = forward-fix migration only — no backward migration
- Estimated rollback time must be stated explicitly. Acceptable targets: < 5 minutes (no migrations), 5–15 minutes (with forward-fix migration), > 15 minutes requires human sign-off justification

## Knowledge Access Policy

At runtime, reads from `context_view.md` Section 8 (Rollback Strategy), `knowledge/knowledge_cards.md` Card 009 (Rollback Decision Matrix), `knowledge/decision_rules.md` DR001, `knowledge/principles.md` P8.
