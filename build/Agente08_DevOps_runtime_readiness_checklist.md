# Agente08_DevOps — Runtime Readiness Checklist

**Date:** 2026-05-17
**Purpose:** Verify the agent is ready to operate before activating in a pipeline.

---

## Section 1 — Core Files Present

- [x] `Agente08_DevOps/prompt.md` — present, has 10 operating principles + runtime context rule
- [x] `Agente08_DevOps/agent_config.json` — present, `blocked_runtime_sources` includes `context/`, `lib/`, `*.pdf`
- [x] `Agente08_DevOps/context_view.md` — present, 12 sections covering full operational context
- [x] `Agente08_DevOps/rag_manifest.json` — present, 7 collections, `blocked_raw_sources` configured
- [x] `Agente08_DevOps/skills_manifest.md` — present, indexes all 9 skills with triggers
- [x] `Agente08_DevOps/quality_gate.md` — present, Gates 6 and 7 fully specified
- [x] `Agente08_DevOps/handoff_schema.json` — present, covers Gate 6 and Gate 7 packages
- [x] `Agente08_DevOps/failure_modes.md` — present, 10 failure modes with actions

---

## Section 2 — Knowledge Files Complete

- [x] `knowledge/principles.md` — P1–P12 present with source citations
- [x] `knowledge/heuristics.md` — H1–H15 present with operational application
- [x] `knowledge/decision_rules.md` — DR001–DR015 present with conditions and actions
- [x] `knowledge/knowledge_cards.md` — Card001–Card012 present with practical content
- [x] `knowledge/source_map.json` — 7 sources mapped to distilled artifacts

---

## Section 3 — Schemas Valid

- [x] `schemas/deployment_plan.schema.json` — valid JSON Schema draft-07
- [x] `schemas/rollback_plan.schema.json` — valid JSON Schema draft-07
- [x] `schemas/environment_checklist.schema.json` — valid JSON Schema draft-07
- [x] `schemas/post_deploy_report.schema.json` — valid JSON Schema draft-07
- [x] `schemas/healthcheck_report.schema.json` — valid JSON Schema draft-07
- [x] `schemas/migration_deploy.schema.json` — valid JSON Schema draft-07
- [x] `schemas/incident_runbook.schema.json` — valid JSON Schema draft-07

---

## Section 4 — Templates Usable

- [x] `templates/Deployment_Plan.md` — complete with all required sections and placeholder guidance
- [x] `templates/Rollback_Plan.md` — complete with trigger conditions, steps, DB strategy, MTTR
- [x] `templates/Post_Deploy_Report.md` — complete with healthcheck table, smoke test table, DORA section
- [x] `templates/Environment_Checklist.md` — complete per-variable validation table
- [x] `templates/Runbook_Template.md` — complete with all 7 required runbook sections
- [x] `templates/Healthcheck_Report.md` — complete 10-entry monitoring table
- [x] `templates/Migration_Deploy_Plan.md` — complete per-migration risk table + execution plan

---

## Section 5 — Checklists Operational

- [x] `checklists/deployment_readiness_checklist.md` — 11 sections covering all Gate 6 checks
- [x] `checklists/rollback_checklist.md` — 7 sections for rollback execution
- [x] `checklists/env_validation_checklist.md` — 6 sections for env var validation
- [x] `checklists/migration_deploy_checklist.md` — 8 sections for migration safety
- [x] `checklists/post_deploy_smoke_checklist.md` — 4 tests with rollback trigger logic
- [x] `checklists/observability_checklist.md` — 6 sections for observability verification
- [x] `checklists/healthcheck_checklist.md` — pre-deploy + post-deploy monitoring sections
- [x] `checklists/runtime_isolation_checklist.md` — allowed/blocked sources + substitution map

---

## Section 6 — Examples Paired Correctly

- [x] `examples/good_deployment_plan.md` + `examples/bad_deployment_plan.md` — contrasting READY vs. bad APPROVED
- [x] `examples/good_rollback_plan.md` + `examples/bad_rollback_plan.md` — specific vs. vague TBD
- [x] `examples/good_post_deploy_report.md` + `examples/bad_post_deploy_report.md` — evidence vs. "successful"

---

## Section 7 — Skills Complete (9 × 6 files = 54)

All 9 skills have all 6 required files:
- [x] `vercel-deployment-skill/` — skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md
- [x] `ci-cd-pipeline-skill/` — all 6 files present
- [x] `environment-validation-skill/` — all 6 files present
- [x] `migration-deploy-skill/` — all 6 files present
- [x] `rollback-planning-skill/` — all 6 files present
- [x] `post-deploy-smoke-test-skill/` — all 6 files present
- [x] `observability-setup-skill/` — all 6 files present
- [x] `incident-runbook-skill/` — all 6 files present
- [x] `healthcheck-validation-skill/` — all 6 files present

---

## Section 8 — Knowledge Access Policy Compliance

Each skill.md must have `## Knowledge Access Policy` section:
- [x] vercel-deployment-skill/skill.md
- [x] ci-cd-pipeline-skill/skill.md
- [x] environment-validation-skill/skill.md
- [x] migration-deploy-skill/skill.md
- [x] rollback-planning-skill/skill.md
- [x] post-deploy-smoke-test-skill/skill.md
- [x] observability-setup-skill/skill.md
- [x] incident-runbook-skill/skill.md
- [x] healthcheck-validation-skill/skill.md

Each checklist.md must have `## Runtime Knowledge Policy` item:
- [x] All 9 skill checklists contain this section
- [x] All 8 agent checklists contain this section

---

## Section 9 — Golden Path Compliance Verification

- [x] `prisma migrate deploy` used (not `prisma db push`) in all migration contexts
- [x] `vercel --prod` as production deploy command
- [x] `guardCron()` requirement in vercel-deployment-skill and cron verification checklist
- [x] `lib/env.ts` centralization enforced in environment-validation-skill
- [x] `audit_log` and `sync_log` verified in observability-setup-skill
- [x] Rollback via Vercel dashboard (not Docker/K8s rebuild) unless ADR
- [x] Human approval at Gate 6 enforced in agent_config.json (`can_approve_gate_6_without_human: false`)
- [x] Gate 7 APPROVED only after 5-minute healthcheck + 4/4 smoke tests

---

## Section 10 — White-Label Compliance

- [x] No organization names, client references, `raiz-orange`, `raiz-teal`
- [x] All placeholder values use `[Project Name]`, `[organization]`, generic role names
- [x] No domain-specific business logic or field names
- [x] No specific email addresses or personal names

---

## Runtime Readiness Verdict

**Status:** READY FOR RUNTIME

All sections verified. Agente08_DevOps can be activated in the AI Software Factory pipeline. The agent will operate correctly as Gates 6 and 7 owner using only local artifacts from `Agente08_DevOps/`.

**Instantiation note:** Before first use with a specific client, update escalation contact channels in runbook templates and provide test credentials for the authenticated smoke test (Test 3 in post-deploy-smoke-test-skill).
