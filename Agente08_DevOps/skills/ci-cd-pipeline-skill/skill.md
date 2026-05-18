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
