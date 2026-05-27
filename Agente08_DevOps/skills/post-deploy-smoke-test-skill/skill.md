# Skill: post-deploy-smoke-test-skill

## Purpose

Execute and document the 4 mandatory smoke tests against the production URL immediately after deployment. Report results in a structured table. Trigger rollback if any smoke test fails on primary user flow.

## When to Use

- Immediately after every production deployment (Gate 7)
- After every rollback (to confirm rollback success)
- In staging as part of Gate 6 pre-deploy validation

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `production_url` | Required | Production application URL |
| `test_environment` | Required | "staging" (Gate 6) or "production" (Gate 7) |
| Auth test credentials | For Test 3 | Test account for authenticated smoke test — must be a dedicated smoke-test account registered in the auth provider with confirmed email and MFA disabled; never use a real user's credentials |

## Outputs

Smoke test results table for `Post_Deploy_Report.md`:
- 4 rows (one per test)
- Status: PASS/FAIL
- Retry count
- Notes

## Minimum Required Tests

1. App loads — `GET /` returns 200
2. Unauthenticated redirect — `/dashboard` → `/auth/signin`
3. Authenticated primary feature — user can access and use core feature
4. API healthcheck — `GET /api/healthcheck` returns 200 + `{"status":"ok"}`

## Constraints

- All 4 tests must pass for Gate 7 APPROVED (DR006)
- One retry allowed per test for transient flakiness
- Rollback trigger: Test 3 (primary feature) fails after retry, OR any 2 tests fail simultaneously regardless of adjacency — both conditions trigger rollback; a single failing test that is NOT Test 3 and NOT concurrent with another failure is escalated to human review, not immediate rollback
- Tests must run against production URL (not staging) for Gate 7

## Knowledge Access Policy

At runtime, reads from `context_view.md` Section 7 (Smoke Tests), `knowledge/knowledge_cards.md` Card 006, `knowledge/decision_rules.md` DR006.
