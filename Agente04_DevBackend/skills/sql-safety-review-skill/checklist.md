# sql-safety-review-skill — Execution Checklist

---

## Scan Checklist

- [ ] No `$queryRawUnsafe` anywhere in reviewed files
- [ ] No string concatenation in any Prisma call (no `+` operator in queries)
- [ ] No template literal `$queryRaw` without `Prisma.sql` tag
- [ ] All user inputs validated with Zod before reaching DAL functions
- [ ] No `SELECT *` in performance-critical paths
- [ ] No DAL calls inside loops without pagination (N+1 risk)

## Report

- [ ] `risk_level` assigned (LOW/MEDIUM/HIGH/CRITICAL)
- [ ] `sql_injection_safe` set to `true` only when no injection patterns found
- [ ] `uses_only_parameterized: true` only when all queries use Prisma API or `Prisma.sql`
- [ ] Each finding has file, line, issue, and fix fields

## Gate Action

- [ ] If `risk_level` is HIGH or CRITICAL: do NOT submit to Gate 4 — fix first
- [ ] If `risk_level` is MEDIUM or LOW: document, submit with note in Handoff Package

## Runtime Knowledge Policy

Use only: this checklist, `checklists/sql_safety_checklist.md`, `knowledge/decision_rules.md` (DR013), `knowledge/heuristics.md` (H6).  
Do NOT consult `context/`, `lib/`, or any PDF at runtime.
