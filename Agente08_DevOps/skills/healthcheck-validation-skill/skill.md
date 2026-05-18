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

- Pre-deploy: Healthcheck endpoint validation result (PASS/FAIL with specific issues)
- Post-deploy: `Healthcheck_Report.md` with all 10 monitoring results (every 30s × 5min)

## Rollback Trigger

3 consecutive failures within the 5-minute monitoring window trigger rollback (DR006). Immediately invoke `rollback_checklist.md`.

## Constraints

- Endpoint must not require authentication
- Endpoint must verify database connectivity (not just return static 200)
- Response must conform to schema: `{"status": "ok", "timestamp": "...", "version": "..."}`
- Max acceptable response time: 2000ms
- Do not abbreviate monitoring window under schedule pressure (H6)

## Knowledge Access Policy

At runtime, reads from `context_view.md` Section 6 (Healthcheck Endpoint), `knowledge/knowledge_cards.md` Card 004 (Healthcheck Endpoint Specification), `knowledge/decision_rules.md` DR005, DR006, `knowledge/heuristics.md` H5, H6.
