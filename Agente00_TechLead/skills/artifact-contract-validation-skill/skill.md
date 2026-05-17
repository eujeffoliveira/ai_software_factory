# Artifact Contract Validation Skill

## Purpose
Validate that a handoff package and its artifacts satisfy all requirements for the current gate before issuing a gate decision.

## When to Use
- Every time an agent submits a handoff package for gate review
- When verifying that a revised artifact addresses previous RETURNED_FOR_REVISION feedback
- During VALIDATE operation on State Ledger (cross-checking `approved_artifacts`)

## Inputs
- `gate_number` (1–7)
- `handoff_package` — the complete handoff package submitted by the delivering agent
- `artifact_checklist` — from `checklists/artifact_validation_checklist.md`
- `current_ledger` — State Ledger for context

## Outputs
- `validation_result` — PASS / FAIL / PASS_WITH_CONDITIONS
- `validation_table` — per-criterion check results
- `issues_found` — list of specific violations (empty if PASS)
- `conditions` — list of conditions if PASS_WITH_CONDITIONS
- `adr_required` — boolean, true if a Golden Path deviation was detected

## Validation Criteria by Gate

### Gate 1 — PRD Approval
- PRD document present
- All epics have BDD-format acceptance criteria (Given/When/Then)
- Non-functional requirements with measurable thresholds
- Data model sketch present
- Handoff package fields complete (all 7 required fields)

### Gate 2 — Architecture Approval
- Architecture_Document.md present
- API_Contract.json present
- DB_Schema (Prisma schema or SQL) present
- ADR_Register.md present (even if empty)
- All components reference Golden Model stack
- No middleware.ts usage in Next.js context (proxy.ts required)
- RLS mentioned for all tables

### Gate 3 — Execution Plan Approval
- All epics decomposed into tasks ≤ 5 story points
- DoR met for all tasks (acceptance criteria, design, technical spec)
- No task spans multiple layers without explicit ADR
- Dependencies mapped

### Gate 4 — QA Review
- Test plan covering unit, integration, E2E
- Coverage thresholds defined (≥ 80% unit, ≥ 60% integration)
- All user-facing flows have Playwright tests
- Performance benchmarks established

### Gate 5 — Security Review
- OWASP Top 10 addressed
- Authentication and authorization validated
- No secrets in code
- Audit log for all human actions verified
- JSON structured logs confirmed (no PII)

### Gate 6 — Deployment Approval
- Deploy runbook present
- Rollback procedure documented
- `prisma migrate deploy` used (not `prisma db push`)
- Feature flags or blue/green strategy documented
- Human approval obtained for production deploy

### Gate 7 — Post-Deploy Validation
- All smoke tests passing
- Monitoring alerts configured
- Error rate within acceptable threshold
- Rollback not triggered
- Stakeholder sign-off obtained

## Procedure

1. Load gate-specific criteria from `checklists/artifact_validation_checklist.md`
2. For each criterion: check PASS / FAIL / N/A with evidence
3. Detect any Golden Path deviations → set `adr_required = true`
4. If all criteria PASS → `validation_result = PASS`
5. If 1+ criteria FAIL but fixable with conditions → `PASS_WITH_CONDITIONS`
6. If any criterion is a hard blocker → `FAIL`
7. Return complete validation table with evidence per criterion

## Quality Gate
Every criterion must have explicit evidence or a documented N/A justification. "Looks complete" is never valid evidence.

## Failure Modes
- Handoff package missing required fields → immediate FAIL
- Artifact exists but has no content → FAIL (empty artifact)
- ADR required but absent → gate blocked (BLOCKED_PENDING_ADR)

## RAG Authorized
- `factory_architecture` — gate criteria and artifact requirements
- `project_state` — State Ledger and approved artifacts
- `quality_practices` — QA/testing standards

## Knowledge Access Policy

This skill must not read raw PDFs, raw books, `01-bibliografia/`, `00-contexto/`, or global build documents at runtime.

It may use only:

- its local files (`skill.md`, schemas, checklist, examples)
- `Agente00_TechLead/knowledge/`
- project artifacts provided as input

Any theoretical knowledge required by this skill must be pre-distilled during build-time.
