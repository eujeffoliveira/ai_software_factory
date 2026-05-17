# Artifact Contract Validation Skill — Checklist

## Before Validation
- [ ] Identify gate number (1–7)
- [ ] Load gate-specific criteria from `checklists/artifact_validation_checklist.md`
- [ ] Confirm handoff package has all 7 required fields before proceeding
- [ ] Check if this is a re-validation (load previous RETURNED feedback)

## Handoff Package Field Check
- [ ] `artifact_produced` — artifact name/path is specific and present
- [ ] `summary` — minimum 3 sentences, not boilerplate
- [ ] `assumptions` — at least 1 assumption listed
- [ ] `open_questions` — each item has: question, blocking status, owner
- [ ] `risks` — each item has: description, severity, mitigation
- [ ] `required_next_agent` — valid agent ID from approved roster
- [ ] `validation_checklist` — at least 1 entry, each with criterion + status

## Artifact Content Check
- [ ] Every criterion evaluated individually — no blanket approvals
- [ ] Evidence cited for each PASS (not "looks good")
- [ ] N/A criteria have explicit justification
- [ ] No criterion left without a status

## Golden Path Check
- [ ] No middleware.ts in Next.js context (must be proxy.ts)
- [ ] No `prisma db push` in staging/prod context
- [ ] No magic numbers / untyped configurations
- [ ] No PII in log outputs mentioned
- [ ] ADR required flag set if any deviation detected

## Result Determination
- [ ] PASS: all criteria pass, no conditions
- [ ] PASS_WITH_CONDITIONS: minor issues, fixable without returning
- [ ] FAIL → RETURNED_FOR_REVISION: blocker criteria failed
- [ ] BLOCKED_PENDING_ADR: Golden Path deviation without ADR
- [ ] `recommended_gate_status` matches `validation_result`

## Runtime Knowledge Policy
- [ ] Skill does not depend on raw PDFs, raw books, `lib/`, or `context/` at runtime.
