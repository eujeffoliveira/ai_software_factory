# Agente10_DataIntegrationEngineer — Runtime Readiness Checklist

**Build date:** 2026-05-17
**Verification date:** 2026-05-17

Run this checklist to verify that Agente10 is ready for production runtime deployment.

---

## Section A: File Completeness

### Core Agent Files
- [x] `prompt.md` — present and complete
- [x] `agent_config.json` — present and valid JSON
- [x] `context_view.md` — present with 9 sections
- [x] `rag_manifest.json` — present with 3 collections
- [x] `skills_manifest.md` — present with 7 skills
- [x] `quality_gate.md` — present with Gate 3.5 definition
- [x] `handoff_schema.json` — present, valid JSON Schema draft-07
- [x] `failure_modes.md` — present with FM-01 through FM-10

### Knowledge Files
- [x] `knowledge/principles.md` — P1 through P10
- [x] `knowledge/heuristics.md` — H1 through H15
- [x] `knowledge/decision_rules.md` — DR001 through DR020
- [x] `knowledge/knowledge_cards.md` — Card001 through Card016
- [x] `knowledge/source_map.json` — all artifacts mapped to sources

### Schemas
- [x] `schemas/integration_spec.schema.json`
- [x] `schemas/data_mapping.schema.json`
- [x] `schemas/sync_strategy.schema.json`
- [x] `schemas/data_quality_checklist.schema.json`
- [x] `schemas/data_risks.schema.json`
- [x] `schemas/external_api_assessment.schema.json`

### Templates
- [x] `templates/Integration_Spec.md`
- [x] `templates/Data_Mapping.md`
- [x] `templates/Sync_Strategy.md`
- [x] `templates/Data_Quality_Checklist.md`
- [x] `templates/Data_Risks.md`
- [x] `templates/External_API_Assessment.md`

### Checklists (all 7)
- [x] `checklists/integration_readiness_checklist.md`
- [x] `checklists/data_mapping_checklist.md`
- [x] `checklists/sync_idempotency_checklist.md`
- [x] `checklists/data_quality_checklist.md`
- [x] `checklists/data_privacy_risk_checklist.md`
- [x] `checklists/external_api_checklist.md`
- [x] `checklists/runtime_isolation_checklist.md`

### Examples (all 6)
- [x] `examples/good_integration_spec.md`
- [x] `examples/bad_integration_spec.md`
- [x] `examples/good_data_mapping.md`
- [x] `examples/bad_data_mapping.md`
- [x] `examples/good_sync_strategy.md`
- [x] `examples/bad_sync_strategy.md`

### Skills (7 × 6 = 42 files)

**data-mapping-skill:**
- [x] `skills/data-mapping-skill/skill.md`
- [x] `skills/data-mapping-skill/input.schema.json`
- [x] `skills/data-mapping-skill/output.schema.json`
- [x] `skills/data-mapping-skill/checklist.md`
- [x] `skills/data-mapping-skill/examples/good_output.md`
- [x] `skills/data-mapping-skill/examples/bad_output.md`

**sync-strategy-skill:**
- [x] `skills/sync-strategy-skill/skill.md`
- [x] `skills/sync-strategy-skill/input.schema.json`
- [x] `skills/sync-strategy-skill/output.schema.json`
- [x] `skills/sync-strategy-skill/checklist.md`
- [x] `skills/sync-strategy-skill/examples/good_output.md`
- [x] `skills/sync-strategy-skill/examples/bad_output.md`

**data-quality-validation-skill:**
- [x] `skills/data-quality-validation-skill/skill.md`
- [x] `skills/data-quality-validation-skill/input.schema.json`
- [x] `skills/data-quality-validation-skill/output.schema.json`
- [x] `skills/data-quality-validation-skill/checklist.md`
- [x] `skills/data-quality-validation-skill/examples/good_output.md`
- [x] `skills/data-quality-validation-skill/examples/bad_output.md`

**etl-planning-skill:**
- [x] `skills/etl-planning-skill/skill.md`
- [x] `skills/etl-planning-skill/input.schema.json`
- [x] `skills/etl-planning-skill/output.schema.json`
- [x] `skills/etl-planning-skill/checklist.md`
- [x] `skills/etl-planning-skill/examples/good_output.md`
- [x] `skills/etl-planning-skill/examples/bad_output.md`

**api-ingestion-skill:**
- [x] `skills/api-ingestion-skill/skill.md`
- [x] `skills/api-ingestion-skill/input.schema.json`
- [x] `skills/api-ingestion-skill/output.schema.json`
- [x] `skills/api-ingestion-skill/checklist.md`
- [x] `skills/api-ingestion-skill/examples/good_output.md`
- [x] `skills/api-ingestion-skill/examples/bad_output.md`

**idempotent-sync-design-skill:**
- [x] `skills/idempotent-sync-design-skill/skill.md`
- [x] `skills/idempotent-sync-design-skill/input.schema.json`
- [x] `skills/idempotent-sync-design-skill/output.schema.json`
- [x] `skills/idempotent-sync-design-skill/checklist.md`
- [x] `skills/idempotent-sync-design-skill/examples/good_output.md`
- [x] `skills/idempotent-sync-design-skill/examples/bad_output.md`

**data-privacy-risk-skill:**
- [x] `skills/data-privacy-risk-skill/skill.md`
- [x] `skills/data-privacy-risk-skill/input.schema.json`
- [x] `skills/data-privacy-risk-skill/output.schema.json`
- [x] `skills/data-privacy-risk-skill/checklist.md`
- [x] `skills/data-privacy-risk-skill/examples/good_output.md`
- [x] `skills/data-privacy-risk-skill/examples/bad_output.md`

---

## Section B: Content Integrity

### Build-time vs Runtime Isolation
- [x] `context_view.md` contains all content needed at runtime without referencing `context/` or `lib/`
- [x] All skill.md files have `## Knowledge Access Policy` section
- [x] All checklist.md files have `## Runtime Knowledge Policy` section
- [x] `agent_config.json` lists `blocked_runtime_sources` including `context/`, `lib/`, `*.pdf`
- [x] `rag_manifest.json` lists all build-time sources in `blocked_raw_sources`

### Generic/White-Label Compliance
- [x] No organization-specific names in any artifact
- [x] All example system names use generic placeholders: `crm-platform`, `payment-gateway`, `erp-system`
- [x] No domain-specific terminology that would tie artifacts to a specific client
- [x] All templates use `[placeholder]` syntax

### Golden Model Compliance
- [x] All integration client paths specified as `lib/integrations/[service].client.ts`
- [x] All env var references use `env.VARIABLE_NAME` format from `lib/env.ts`
- [x] `guardCron()` specified as first call in all cron route specs
- [x] `syncLog()` specified in `finally` block in all sync job specs
- [x] Zod validation required for all external API responses
- [x] External calls prohibited inside Prisma `$transaction()` blocks

### Gate Structure
- [x] Gate 3.5 positioned between Gate 3 and Gate 4
- [x] Gate 3.5 has 7 distinct blocking criteria (BK-01 through BK-07)
- [x] All blocking criteria have corresponding status codes
- [x] Gate 3.5 is marked as conditional (activated only for projects with integrations)
- [x] Gate 3.5 cannot be overridden by Tech Lead

### Knowledge Integrity
- [x] 10 principles (P1–P10) covering all major integration design dimensions
- [x] 15 heuristics (H1–H15) providing actionable decision rules
- [x] 20 decision rules (DR001–DR020) as if-then rules
- [x] 16 knowledge cards (Card001–Card016) as reference concepts
- [x] All knowledge artifacts traced to source_map.json

---

## Section C: Handoff Integrity

- [x] Handoff Package receives from `Agente02_SoftwareArchitect`
- [x] Handoff Package delivers to `Agente03_SoftwareEngineer` (primary)
- [x] `Data_Risks.md` shared with `Agente00_TechLead` and `Agente07_DevSecOps`
- [x] `handoff_schema.json` validates: `gate_ready`, `idempotency_coverage`, `lgpd_flows`, `blocking_issues`
- [x] Handoff Package ID pattern specified: `HANDOFF-A10-YYYYMMDD-NNNN`

---

## Section D: Integration with Factory Pipeline

- [x] Gate positioning documented in `quality_gate.md` and `agent_config.json`
- [x] Inputs from Agente02 defined in prompt.md §Inputs table
- [x] Outputs to Agente03 defined in prompt.md §Outputs table
- [x] Coordination with Agente07 documented in `context_view.md` §8.4
- [x] Agente04 sync_log pattern referenced correctly in `context_view.md` §4
- [x] Escalation to Agente00_TechLead documented in `prompt.md` §Escalation Policy

---

## Runtime Readiness Verdict

**STATUS: READY FOR RUNTIME**

All 84 files produced. All completeness and integrity checks passed. Agente10_DataIntegrationEngineer is ready for deployment in the AI Software Factory pipeline.
