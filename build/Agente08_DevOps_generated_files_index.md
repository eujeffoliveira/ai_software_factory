# Agente08_DevOps — Generated Files Index

**Build date:** 2026-05-17
**Total files:** 99 in Agente08_DevOps/ + 4 build reports = 103 total

---

## Core Files (8)

| File | Description |
|------|-------------|
| `Agente08_DevOps/prompt.md` | Agent identity, 10 operating principles, responsibilities, workflow, escalation policy |
| `Agente08_DevOps/agent_config.json` | Runtime config: allowed/blocked sources, Golden Path, capabilities, gate definitions |
| `Agente08_DevOps/context_view.md` | Compiled operational context (Vercel, CI/CD, env vars, migrations, healthcheck, rollback, observability, DORA) |
| `Agente08_DevOps/rag_manifest.json` | RAG policy: 7 collections, blocked raw sources, retrieval order |
| `Agente08_DevOps/skills_manifest.md` | Index of all 9 skills with trigger conditions and outputs |
| `Agente08_DevOps/quality_gate.md` | Gate 6 and Gate 7 definitions: entry criteria, mandatory artifacts, status codes, decision matrix |
| `Agente08_DevOps/handoff_schema.json` | JSON Schema for Gate 6 and Gate 7 handoff packages |
| `Agente08_DevOps/failure_modes.md` | 10 failure modes with symptoms, root causes, immediate actions, escalation paths |

---

## Knowledge Files (5)

| File | Contents |
|------|----------|
| `Agente08_DevOps/knowledge/principles.md` | P1–P12: deployment pipeline, trunk-based dev, infrastructure IaC, SLOs, toil, Three Ways, error budgets, rollback, env parity, DORA, config mgmt, change control |
| `Agente08_DevOps/knowledge/heuristics.md` | H1–H15: operational decision shortcuts for rapid assessment |
| `Agente08_DevOps/knowledge/decision_rules.md` | DR001–DR015: if-then operational rules |
| `Agente08_DevOps/knowledge/knowledge_cards.md` | Card001–Card012: DORA metrics, Vercel architecture, Prisma migrations, healthcheck spec, env var pattern, smoke tests, cron pattern, SLO/SLI/SLA, rollback matrix, structured logging, runbook structure, config mgmt baseline |
| `Agente08_DevOps/knowledge/source_map.json` | Build-time source → distilled artifact mapping for 7 sources |

---

## Schemas (7)

| File | Description |
|------|-------------|
| `Agente08_DevOps/schemas/deployment_plan.schema.json` | Deployment_Plan.md structured data schema |
| `Agente08_DevOps/schemas/rollback_plan.schema.json` | Rollback_Plan.md structured data schema |
| `Agente08_DevOps/schemas/environment_checklist.schema.json` | Environment_Checklist.md structured data schema |
| `Agente08_DevOps/schemas/post_deploy_report.schema.json` | Post_Deploy_Report.md structured data schema |
| `Agente08_DevOps/schemas/healthcheck_report.schema.json` | Healthcheck_Report.md structured data schema |
| `Agente08_DevOps/schemas/migration_deploy.schema.json` | Migration_Deploy_Plan.md structured data schema |
| `Agente08_DevOps/schemas/incident_runbook.schema.json` | Incident runbook structured data schema |

---

## Templates (7)

| File | Description |
|------|-------------|
| `Agente08_DevOps/templates/Deployment_Plan.md` | Complete Gate 6 deployment plan template |
| `Agente08_DevOps/templates/Rollback_Plan.md` | Complete rollback procedure template |
| `Agente08_DevOps/templates/Post_Deploy_Report.md` | Complete Gate 7 post-deploy report template |
| `Agente08_DevOps/templates/Environment_Checklist.md` | Environment variable validation checklist template |
| `Agente08_DevOps/templates/Runbook_Template.md` | Incident runbook template |
| `Agente08_DevOps/templates/Healthcheck_Report.md` | Post-deploy healthcheck monitoring report template |
| `Agente08_DevOps/templates/Migration_Deploy_Plan.md` | Database migration deployment plan template |

---

## Checklists (8)

| File | Description |
|------|-------------|
| `Agente08_DevOps/checklists/deployment_readiness_checklist.md` | 11-section Gate 6 readiness validation (all pre-deploy checks) |
| `Agente08_DevOps/checklists/rollback_checklist.md` | 7-section rollback execution procedure |
| `Agente08_DevOps/checklists/env_validation_checklist.md` | 6-section environment variable validation |
| `Agente08_DevOps/checklists/migration_deploy_checklist.md` | 8-section migration deployment procedure |
| `Agente08_DevOps/checklists/post_deploy_smoke_checklist.md` | 4-test smoke test execution with rollback decision |
| `Agente08_DevOps/checklists/observability_checklist.md` | 6-section observability configuration verification |
| `Agente08_DevOps/checklists/healthcheck_checklist.md` | Pre-deploy verification + post-deploy monitoring template |
| `Agente08_DevOps/checklists/runtime_isolation_checklist.md` | Build-time vs. runtime source enforcement |

---

## Examples (6)

| File | Description |
|------|-------------|
| `Agente08_DevOps/examples/good_deployment_plan.md` | Complete READY_FOR_HUMAN_APPROVAL plan with all 15 checklist items verified |
| `Agente08_DevOps/examples/bad_deployment_plan.md` | Incorrectly APPROVED plan with missing rollback, no CI evidence, no monitoring |
| `Agente08_DevOps/examples/good_rollback_plan.md` | Complete plan with specific deployment ID, tested procedure, precise MTTR |
| `Agente08_DevOps/examples/bad_rollback_plan.md` | TBD rollback with vague trigger and no tested procedure |
| `Agente08_DevOps/examples/good_post_deploy_report.md` | 10-entry healthcheck table, 4/4 smoke tests, error rate data, DORA metrics |
| `Agente08_DevOps/examples/bad_post_deploy_report.md` | "Deploy successful" with no evidence, no healthcheck, no smoke tests |

---

## Skills (9 skills × 6 files = 54 files)

### vercel-deployment-skill
| File | Description |
|------|-------------|
| `skills/vercel-deployment-skill/skill.md` | Purpose, inputs, outputs, process, constraints, knowledge access policy |
| `skills/vercel-deployment-skill/input.schema.json` | Input validation schema |
| `skills/vercel-deployment-skill/output.schema.json` | Output validation schema |
| `skills/vercel-deployment-skill/checklist.md` | Pre/execution/post checklist with runtime knowledge policy |
| `skills/vercel-deployment-skill/examples/good_output.md` | Complete output with cron inventory and deployment steps |
| `skills/vercel-deployment-skill/examples/bad_output.md` | Output with missing guardCron check |

### ci-cd-pipeline-skill
| File | Description |
|------|-------------|
| `skills/ci-cd-pipeline-skill/skill.md` | 5 required pipeline steps, blocking conditions |
| `skills/ci-cd-pipeline-skill/input.schema.json` | Input schema with step statuses |
| `skills/ci-cd-pipeline-skill/output.schema.json` | Per-step PASS/FAIL results |
| `skills/ci-cd-pipeline-skill/checklist.md` | Verification of all 5 CI steps |
| `skills/ci-cd-pipeline-skill/examples/good_output.md` | All 5 steps PASS with CI run reference |
| `skills/ci-cd-pipeline-skill/examples/bad_output.md` | Vitest failing but marked PASS |

### environment-validation-skill
| File | Description |
|------|-------------|
| `skills/environment-validation-skill/skill.md` | Validation of staging + production env vars, isolation check |
| `skills/environment-validation-skill/input.schema.json` | lib/env.ts content + variable lists |
| `skills/environment-validation-skill/output.schema.json` | Per-environment results + isolation result |
| `skills/environment-validation-skill/checklist.md` | Zod schema extraction + per-env + isolation |
| `skills/environment-validation-skill/examples/good_output.md` | 6/6 present, isolation PASS |
| `skills/environment-validation-skill/examples/bad_output.md` | Missing var in production, isolation not checked |

### migration-deploy-skill
| File | Description |
|------|-------------|
| `skills/migration-deploy-skill/skill.md` | Per-migration risk assessment, DR002/DR004/DR011 enforcement |
| `skills/migration-deploy-skill/input.schema.json` | Pending migration files + table row counts |
| `skills/migration-deploy-skill/output.schema.json` | Per-migration assessment + readiness |
| `skills/migration-deploy-skill/checklist.md` | SQL classification + sign-off + forward-fix |
| `skills/migration-deploy-skill/examples/good_output.md` | LOW risk ADD COLUMN with forward-fix prepared |
| `skills/migration-deploy-skill/examples/bad_output.md` | DROP COLUMN marked LOW risk without sign-off |

### rollback-planning-skill
| File | Description |
|------|-------------|
| `skills/rollback-planning-skill/skill.md` | Mandatory Gate 6 artifact, 4 trigger conditions minimum |
| `skills/rollback-planning-skill/input.schema.json` | Feature name + migration info + production URL |
| `skills/rollback-planning-skill/output.schema.json` | plan_status + MTTR estimate + procedure_tested flag |
| `skills/rollback-planning-skill/checklist.md` | All Rollback_Plan.md sections + staging test verification |
| `skills/rollback-planning-skill/examples/good_output.md` | COMPLETE plan with specific deployment ID, tested |
| `skills/rollback-planning-skill/examples/bad_output.md` | "TBD" rollback, not tested, vague owner |

### post-deploy-smoke-test-skill
| File | Description |
|------|-------------|
| `skills/post-deploy-smoke-test-skill/skill.md` | 4 mandatory tests, rollback trigger on failure |
| `skills/post-deploy-smoke-test-skill/input.schema.json` | Target URL + test environment |
| `skills/post-deploy-smoke-test-skill/output.schema.json` | 4-entry test results array + overall status |
| `skills/post-deploy-smoke-test-skill/checklist.md` | Execute 4 tests + retry policy + rollback trigger |
| `skills/post-deploy-smoke-test-skill/examples/good_output.md` | 4/4 PASS with evidence |
| `skills/post-deploy-smoke-test-skill/examples/bad_output.md` | Test 3 FAIL ignored, marked ALL_PASS |

### observability-setup-skill
| File | Description |
|------|-------------|
| `skills/observability-setup-skill/skill.md` | 4 components: audit_log, sync_log, error tracking, uptime |
| `skills/observability-setup-skill/input.schema.json` | Files to verify + tool configuration status |
| `skills/observability-setup-skill/output.schema.json` | Per-component CONFIGURED/MISSING/PARTIAL |
| `skills/observability-setup-skill/checklist.md` | Verify each component with evidence |
| `skills/observability-setup-skill/examples/good_output.md` | All 4 components CONFIGURED with evidence |
| `skills/observability-setup-skill/examples/bad_output.md` | Missing error tracking marked CONFIGURED |

### incident-runbook-skill
| File | Description |
|------|-------------|
| `skills/incident-runbook-skill/skill.md` | 5 required runbooks for go-live, update trigger (DR015) |
| `skills/incident-runbook-skill/input.schema.json` | Action: create_initial_set or update_runbook |
| `skills/incident-runbook-skill/output.schema.json` | Runbooks produced + go_live_ready flag |
| `skills/incident-runbook-skill/checklist.md` | All 5 runbooks with all required sections |
| `skills/incident-runbook-skill/examples/good_output.md` | 5/5 runbooks with MTTR estimates |
| `skills/incident-runbook-skill/examples/bad_output.md` | 2/5 runbooks, go_live_ready: true incorrectly |

### healthcheck-validation-skill
| File | Description |
|------|-------------|
| `skills/healthcheck-validation-skill/skill.md` | Pre-deploy verification + 5-minute post-deploy monitoring |
| `skills/healthcheck-validation-skill/input.schema.json` | URL + phase + monitoring configuration |
| `skills/healthcheck-validation-skill/output.schema.json` | Overall status + rollback flag + stats |
| `skills/healthcheck-validation-skill/checklist.md` | Route handler review + 10-check monitoring |
| `skills/healthcheck-validation-skill/examples/good_output.md` | 10/10 checks PASS, all DB checks PASS |
| `skills/healthcheck-validation-skill/examples/bad_output.md` | Only 3 checks performed, 2 failures |

---

## Build Reports (4)

| File | Description |
|------|-------------|
| `build/Agente08_DevOps_build_report.md` | Build summary, sources read, design decisions, gaps |
| `build/Agente08_DevOps_generated_files_index.md` | This file — complete file inventory |
| `build/Agente08_DevOps_runtime_readiness_checklist.md` | Pre-runtime verification checklist |
| `build/Agente08_DevOps_knowledge_distillation_patch_report.md` | Knowledge distillation summary |
