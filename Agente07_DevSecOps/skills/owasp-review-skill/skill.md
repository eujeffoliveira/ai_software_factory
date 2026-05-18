# Skill: owasp-review-skill

## Purpose

Systematically evaluate the implementation against all 10 OWASP Top 10 (2021) categories, producing a complete coverage table with PASS/FAIL and evidence for each category.

## When to Use

Every Gate 5 evaluation — mandatory. All 10 categories must be reviewed regardless of feature scope. No category may be skipped without documented "NOT_APPLICABLE" rationale.

## Inputs

- All implementation files in scope (Server Actions, Route Handlers, cron jobs)
- `prisma/schema.prisma` — for data store analysis (A01, A03)
- `package.json` — for vulnerable components (A06)
- `Threat_Model.md` — for insecure design (A04)
- `lib/env.ts` — for cryptographic failures and misconfiguration (A02, A05)
- Results from `secret-scanning-skill`, `authz-review-skill`, `dependency-security-review-skill`, `logging-privacy-review-skill`

## Outputs

- OWASP coverage table (10 rows) for Security_Audit.md
- Findings list for categories that fail, with SEC-NNN IDs

## Constraints

- All 10 categories must appear in the output table
- Every PASS must have evidence notes (what was checked)
- Every FAIL must have a specific finding ID (SEC-NNN) and file:line reference
- NOT_APPLICABLE must have a documented rationale — it is not an automatic pass

## Steps

1. For each OWASP category, apply the specific checks defined in `checklists/owasp_top_10_checklist.md`
2. Review each relevant file against the category's checks
3. Record evidence for PASS — what was verified
4. Record findings for FAIL — specific file:line, description, decision rule
5. Aggregate results into the 10-row coverage table
6. Pass findings to `security-audit-report-skill` for aggregation

## Knowledge Access Policy

At runtime, reads from:
- `Agente07_DevSecOps/knowledge/knowledge_cards.md` → Card 002 (OWASP Top 10), Card 003 (IDOR), Card 004 (SQL injection), Card 012 (auth pattern)
- `Agente07_DevSecOps/knowledge/decision_rules.md` → DR001–DR015
- `Agente07_DevSecOps/checklists/owasp_top_10_checklist.md`
- `Agente07_DevSecOps/context_view.md` → sections 3 and 4

Do NOT access `context/` or `lib/` at runtime.
