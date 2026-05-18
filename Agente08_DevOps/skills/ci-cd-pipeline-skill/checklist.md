# ci-cd-pipeline-skill Checklist

## Pre-Execution
- [ ] Target commit SHA provided
- [ ] GitHub Actions run status accessible for target commit

## Execution
- [ ] TypeScript typecheck step status confirmed
- [ ] ESLint step status confirmed
- [ ] Vitest unit tests step status confirmed
- [ ] Next.js build step status confirmed
- [ ] Playwright E2E tests step status confirmed (or noted as not-yet-configured)
- [ ] CI run ID/URL recorded for evidence

## Post-Execution
- [ ] `overall_status` set: PASS (all green) or BLOCKED_CI_FAILURE (any failing/missing)
- [ ] `failing_steps` list populated if any failing
- [ ] `gate_6_impact` states the consequence clearly

## Runtime Knowledge Policy
Read from `Agente08_DevOps/` only. Context: `context_view.md` Section 3. Rules: DR010.
