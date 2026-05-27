# Skill: healthcheck-validation-skill

## Purpose

Define, verify, and monitor the `GET /api/healthcheck` endpoint. Confirm the endpoint implementation matches spec before Gate 6. Execute post-deploy monitoring (every 30s for 5 minutes after Gate 7). Trigger rollback on 3 consecutive failures. Produce `Healthcheck_Report.md`.

## When to Use

- Before Gate 6 `READY_FOR_HUMAN_APPROVAL`: verify endpoint exists and is correct in staging
- After every production deployment: 5-minute post-deploy monitoring window (Gate 7)
- After rollback: confirm rollback success

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| `healthcheck_url` | Required | Full URL of the healthcheck endpoint |
| `route_handler_content` | Gate 6 only | Content of `app/api/healthcheck/route.ts` |
| `check_phase` | Required | "pre_deploy" (Gate 6) or "post_deploy" (Gate 7) |

## Outputs

- Pre-deploy: Healthcheck endpoint validation result — `PASS` (all checks within spec) or `FAIL: <specific issue>` (e.g., `FAIL: response time 2300ms > 2000ms limit`, `FAIL: missing database connectivity check`, `FAIL: schema field 'version' absent`). PASS requires ALL of: HTTP 200, response time < 2000ms, response body matches schema, DB connectivity verified.
- Post-deploy: `Healthcheck_Report.md` with all 10 monitoring results (every 30s × 5min)

## Rollback Trigger

3 consecutive failures (i.e., 3 failed checks back-to-back with no passing check in between) trigger rollback (DR006). Gaps in the monitoring schedule (skipped checks) do not reset the consecutive count — treat a skipped check as a failed check. Immediately invoke `rollback_checklist.md`.

## Constraints

- Endpoint must not require authentication
- Endpoint must verify database connectivity (not just return static 200)
- Response must conform to schema: `{"status": "ok", "timestamp": "...", "version": "..."}`
- Max acceptable response time: 2000ms
- Do not abbreviate monitoring window under schedule pressure (H6)

## Knowledge Access Policy

At runtime, reads from `context_view.md` Section 6 (Healthcheck Endpoint), `knowledge/knowledge_cards.md` Card 004 (Healthcheck Endpoint Specification), `knowledge/decision_rules.md` DR005, DR006, `knowledge/heuristics.md` H5, H6.
