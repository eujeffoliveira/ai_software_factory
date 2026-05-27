# Skill: secret-scanning-skill

## Purpose

Scan all source files for hardcoded secrets (API keys, JWT secrets, database URLs, OAuth credentials, passwords, tokens) and identify misplaced `process.env` access outside `lib/env.ts`.

## When to Use

Every Gate 5 evaluation — mandatory. No exceptions for dev-only or test files. Any hardcoded secret anywhere in tracked source code is a CRITICAL finding.

## Inputs

- All source files in scope (TypeScript, JavaScript, JSON config, shell scripts)
- `.gitignore` — to verify `.env` files are excluded from tracking
- `lib/env.ts` — to understand the expected pattern

## Outputs

- Secrets scan report: CLEAN or list of findings with exact file:line references
- CRITICAL findings (SEC-NNN) for any hardcoded secrets found
- MEDIUM findings for `process.env` usage outside `lib/env.ts`

## Constraints

- Do NOT exclude test files — secrets in test files are still CRITICAL
- Do NOT exclude commented-out code — commented secrets are still in version control
- Do NOT accept "it's just a dev key" as justification — all hardcoded secrets are CRITICAL
- Secret rotation may be required even after code fix (escalate to Tech Lead)

## Steps

1. Run pattern scans for all 7 pattern categories in `checklists/secrets_checklist.md`
2. For each match: verify it is an actual secret (not a placeholder like `"<YOUR_KEY>"`)
3. Check `process.env` usage in all files outside `lib/env.ts`
4. Verify `.gitignore` includes `.env*` patterns
5. Check for secrets in code comments — scan both single-line (`//`) and multi-line (`/* */`) comments, including JSDoc blocks (`/** */`) and inline docstring examples; any hardcoded credential value in a comment or documentation example is CRITICAL even if unreachable at runtime
6. Report CLEAN or produce findings with SEC-NNN IDs

## Knowledge Access Policy

At runtime, reads from:
- `Agente07_DevSecOps/knowledge/decision_rules.md` → DR001, DR008
- `Agente07_DevSecOps/knowledge/principles.md` → P6
- `Agente07_DevSecOps/knowledge/heuristics.md` → H4, H5
- `Agente07_DevSecOps/checklists/secrets_checklist.md`

Do NOT access `context/` or `lib/` at runtime.
