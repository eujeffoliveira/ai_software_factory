# Skill: environment-validation-skill

## Purpose

Validate that all environment variables required by `lib/env.ts` are present in staging and production Vercel environments, confirm type validity, and verify environment isolation (no shared secrets). Produces `Environment_Checklist.md`.

## When to Use

- Before issuing Gate 6 `READY_FOR_HUMAN_APPROVAL`
- When `lib/env.ts` is modified (new env var added)
- When environment variable configuration changes

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `lib/env.ts` content | Required | Zod schema file |
| Staging env var list | Required | Variable names present in Vercel Preview |
| Production env var list | Required | Variable names present in Vercel Production |

## Outputs

`Environment_Checklist.md` with per-variable results and overall status

## Constraints

- Missing env var in production = CRITICAL → deploy will fail at boot via Zod
- Shared secret between staging and production = CRITICAL → escalate to Agente07_DevSecOps (DR008)
- `process.env` outside `lib/env.ts` → flag for Agente04_DevBackend (DR003)
- Do NOT log or display actual secret values

## Knowledge Access Policy

At runtime, reads from `context_view.md` Section 4, `knowledge/decision_rules.md` DR003, DR008, `knowledge/knowledge_cards.md` Card 005.
