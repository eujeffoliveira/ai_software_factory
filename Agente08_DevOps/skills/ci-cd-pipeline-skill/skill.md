# Skill: ci-cd-pipeline-skill

## Purpose

Validate that the GitHub Actions CI/CD pipeline is passing on the target commit and that all required pipeline steps are present. Block Gate 6 if any step is failing or missing. Provides CI validation evidence for `Deployment_Plan.md`.

## When to Use

- Before issuing any Gate 6 status code (mandatory first check)
- When CI/CD pipeline configuration changes

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `target_commit_sha` | Required | The git commit SHA being deployed |
| `ci_workflow_file` | Required | Contents of `.github/workflows/ci.yml` |
| `ci_run_status` | Required | Status of GitHub Actions run on the target commit |

## Outputs

| Output | Description |
|--------|-------------|
| Pipeline validation result | PASS/FAIL per step with evidence |
| Gate 6 impact | PASS or BLOCKED_CI_FAILURE |

## Required Pipeline Steps (all must be present and passing)

1. TypeScript typecheck: `npx tsc --noEmit`
2. ESLint: `npx eslint .`
3. Vitest unit tests: `npx vitest run`
4. Next.js production build: `npx next build`
5. Playwright E2E tests: `npx playwright test` (on main branch)

## Procedure

1. Verify `ci_run_status` is for `target_commit_sha` — reject if SHA mismatch
2. Parse `ci_workflow_file` to confirm all 5 required steps exist as job steps (by command or step name)
3. For each required step: check `ci_run_status` for its conclusion (`success`, `failure`, `skipped`, `cancelled`)
4. A step with conclusion `skipped` or `cancelled` counts as MISSING, not passing
5. Record per-step: step name, conclusion, and evidence (job name + step index in the workflow file)
6. Set Gate 6 impact: `PASS` only if all 5 steps present AND all conclusions = `success`; otherwise `BLOCKED_CI_FAILURE` with the specific failing/missing steps listed

## Constraints

- All 5 steps must be present AND passing for PASS result
- A single failing step = `BLOCKED_CI_FAILURE` at Gate 6
- Missing CI entirely = `BLOCKED_CI_FAILURE` with setup guidance
- No exceptions for "just a small change" — CI is not optional

## Knowledge Access Policy

At runtime, this skill reads from:
- `Agente08_DevOps/context_view.md` Section 3 (CI/CD Pipeline)
- `Agente08_DevOps/knowledge/decision_rules.md` DR010 (missing CI steps)
- `Agente08_DevOps/knowledge/heuristics.md` H10 (pipeline exists to prevent surprises)

Blocked at runtime: `context/`, `lib/`, `*.pdf`
