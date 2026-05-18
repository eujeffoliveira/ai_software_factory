# Agente10_DataIntegrationEngineer — Generated Files Index

**Build date:** 2026-05-17
**Total files:** 84

---

## Core Agent Files (8)

| # | File | Description |
|---|------|-------------|
| 1 | `Agente10_DataIntegrationEngineer/prompt.md` | System prompt: role, mission, 10 principles, responsibilities, inputs, outputs, 7 skills, workflow, gate participation, escalation, failure modes, response format |
| 2 | `Agente10_DataIntegrationEngineer/agent_config.json` | Runtime config: allowed/blocked sources, capabilities, golden_model compliance flags |
| 3 | `Agente10_DataIntegrationEngineer/context_view.md` | Compiled local context: integration patterns, idempotency strategies, data mapping rules, sync strategies, LGPD requirements, external API client patterns |
| 4 | `Agente10_DataIntegrationEngineer/rag_manifest.json` | RAG collections, chunking strategy, blocked raw sources |
| 5 | `Agente10_DataIntegrationEngineer/skills_manifest.md` | Index of 7 skills with trigger conditions and descriptions |
| 6 | `Agente10_DataIntegrationEngineer/quality_gate.md` | Gate 3.5 (Data Integration Review): entry criteria, 7 blocking criteria, evaluation checklist, status codes |
| 7 | `Agente10_DataIntegrationEngineer/handoff_schema.json` | JSON Schema for Integration Handoff Package (draft-07) |
| 8 | `Agente10_DataIntegrationEngineer/failure_modes.md` | 10 failure modes FM-01 through FM-10 with symptom, root cause, corrective action, gate impact |

---

## Knowledge Files (5)

| # | File | Content |
|---|------|---------|
| 9 | `Agente10_DataIntegrationEngineer/knowledge/principles.md` | P1–P10: Idempotency First, Data Privacy by Design, Source of Truth Ownership, Zod at Every Boundary, Sync Observability, Decoupled Integration, Forward-Compatible Contracts, Data Quality Gates, Explicit Dependency Direction, Fail Fast Log Always |
| 10 | `Agente10_DataIntegrationEngineer/knowledge/heuristics.md` | H1–H15: idempotency key, webhook vs polling, cursor pagination, Zod schema, deduplication, LGPD triggers, retry with jitter, circuit breaker, dead letter, data lineage, batch size, webhook replay, ETL vs ELT, conflict resolution, LGPD retention |
| 11 | `Agente10_DataIntegrationEngineer/knowledge/decision_rules.md` | DR001–DR020: topology selection, upsert requirement, LGPD triggers, blocking rules (PII/idempotency/transaction), ETL vs ELT, rate limits, versioning, retention, escalation |
| 12 | `Agente10_DataIntegrationEngineer/knowledge/knowledge_cards.md` | Card001–Card016: idempotency key, at-least-once vs exactly-once, ETL vs ELT, CDC, webhook security, cursor pagination, LGPD legal bases, data mesh, API versioning, conflict resolution, backoff, dead letter, circuit breaker, sync_log schema, PII classification, data quality dimensions |
| 13 | `Agente10_DataIntegrationEngineer/knowledge/source_map.json` | Build-time source → distilled artifact mapping for all principles, heuristics, DRs, and cards |

---

## JSON Schemas (6)

| # | File | Description |
|---|------|-------------|
| 14 | `Agente10_DataIntegrationEngineer/schemas/integration_spec.schema.json` | Integration Specification metadata (draft-07) |
| 15 | `Agente10_DataIntegrationEngineer/schemas/data_mapping.schema.json` | Data Mapping document (draft-07) |
| 16 | `Agente10_DataIntegrationEngineer/schemas/sync_strategy.schema.json` | Sync Strategy document (draft-07) |
| 17 | `Agente10_DataIntegrationEngineer/schemas/data_quality_checklist.schema.json` | Data Quality Checklist (draft-07) |
| 18 | `Agente10_DataIntegrationEngineer/schemas/data_risks.schema.json` | Data Risks register (draft-07) |
| 19 | `Agente10_DataIntegrationEngineer/schemas/external_api_assessment.schema.json` | External API Assessment (draft-07) |

---

## Templates (6)

| # | File | Description |
|---|------|-------------|
| 20 | `Agente10_DataIntegrationEngineer/templates/Integration_Spec.md` | Master integration specification template |
| 21 | `Agente10_DataIntegrationEngineer/templates/Data_Mapping.md` | Bidirectional field mapping template |
| 22 | `Agente10_DataIntegrationEngineer/templates/Sync_Strategy.md` | Sync job design template |
| 23 | `Agente10_DataIntegrationEngineer/templates/Data_Quality_Checklist.md` | Data quality acceptance criteria template |
| 24 | `Agente10_DataIntegrationEngineer/templates/Data_Risks.md` | Risk register template |
| 25 | `Agente10_DataIntegrationEngineer/templates/External_API_Assessment.md` | External API assessment template |

---

## Checklists (7)

| # | File | When Used |
|---|------|-----------|
| 26 | `Agente10_DataIntegrationEngineer/checklists/integration_readiness_checklist.md` | Before Gate 3.5 submission — master checklist |
| 27 | `Agente10_DataIntegrationEngineer/checklists/data_mapping_checklist.md` | During data-mapping-skill execution |
| 28 | `Agente10_DataIntegrationEngineer/checklists/sync_idempotency_checklist.md` | For every sync operation |
| 29 | `Agente10_DataIntegrationEngineer/checklists/data_quality_checklist.md` | During data-quality-validation-skill |
| 30 | `Agente10_DataIntegrationEngineer/checklists/data_privacy_risk_checklist.md` | For every integration with personal data |
| 31 | `Agente10_DataIntegrationEngineer/checklists/external_api_checklist.md` | During api-ingestion-skill execution |
| 32 | `Agente10_DataIntegrationEngineer/checklists/runtime_isolation_checklist.md` | Before any Gate 3.5 submission |

---

## Examples (6)

| # | File | What It Shows |
|---|------|---------------|
| 33 | `Agente10_DataIntegrationEngineer/examples/good_integration_spec.md` | Complete, Gate 3.5-ready integration spec with all blocking criteria satisfied |
| 34 | `Agente10_DataIntegrationEngineer/examples/bad_integration_spec.md` | Integration spec with 6 blocking violations annotated |
| 35 | `Agente10_DataIntegrationEngineer/examples/good_data_mapping.md` | Complete bidirectional mapping with ownership table, lineage, Zod schemas |
| 36 | `Agente10_DataIntegrationEngineer/examples/bad_data_mapping.md` | Mapping with 9 violations including PII omission and wrong ID mapping |
| 37 | `Agente10_DataIntegrationEngineer/examples/good_sync_strategy.md` | Payment reconciliation job with idempotency, cursor pagination, syncLog in finally |
| 38 | `Agente10_DataIntegrationEngineer/examples/bad_sync_strategy.md` | Sync strategy with 6 violations including transaction deadlock and missing guardCron |

---

## Skills (7 skills × 6 files = 42 files)

### Skill 1: data-mapping-skill (6 files)

| # | File |
|---|------|
| 39 | `Agente10_DataIntegrationEngineer/skills/data-mapping-skill/skill.md` |
| 40 | `Agente10_DataIntegrationEngineer/skills/data-mapping-skill/input.schema.json` |
| 41 | `Agente10_DataIntegrationEngineer/skills/data-mapping-skill/output.schema.json` |
| 42 | `Agente10_DataIntegrationEngineer/skills/data-mapping-skill/checklist.md` |
| 43 | `Agente10_DataIntegrationEngineer/skills/data-mapping-skill/examples/good_output.md` |
| 44 | `Agente10_DataIntegrationEngineer/skills/data-mapping-skill/examples/bad_output.md` |

### Skill 2: sync-strategy-skill (6 files)

| # | File |
|---|------|
| 45 | `Agente10_DataIntegrationEngineer/skills/sync-strategy-skill/skill.md` |
| 46 | `Agente10_DataIntegrationEngineer/skills/sync-strategy-skill/input.schema.json` |
| 47 | `Agente10_DataIntegrationEngineer/skills/sync-strategy-skill/output.schema.json` |
| 48 | `Agente10_DataIntegrationEngineer/skills/sync-strategy-skill/checklist.md` |
| 49 | `Agente10_DataIntegrationEngineer/skills/sync-strategy-skill/examples/good_output.md` |
| 50 | `Agente10_DataIntegrationEngineer/skills/sync-strategy-skill/examples/bad_output.md` |

### Skill 3: data-quality-validation-skill (6 files)

| # | File |
|---|------|
| 51 | `Agente10_DataIntegrationEngineer/skills/data-quality-validation-skill/skill.md` |
| 52 | `Agente10_DataIntegrationEngineer/skills/data-quality-validation-skill/input.schema.json` |
| 53 | `Agente10_DataIntegrationEngineer/skills/data-quality-validation-skill/output.schema.json` |
| 54 | `Agente10_DataIntegrationEngineer/skills/data-quality-validation-skill/checklist.md` |
| 55 | `Agente10_DataIntegrationEngineer/skills/data-quality-validation-skill/examples/good_output.md` |
| 56 | `Agente10_DataIntegrationEngineer/skills/data-quality-validation-skill/examples/bad_output.md` |

### Skill 4: etl-planning-skill (6 files)

| # | File |
|---|------|
| 57 | `Agente10_DataIntegrationEngineer/skills/etl-planning-skill/skill.md` |
| 58 | `Agente10_DataIntegrationEngineer/skills/etl-planning-skill/input.schema.json` |
| 59 | `Agente10_DataIntegrationEngineer/skills/etl-planning-skill/output.schema.json` |
| 60 | `Agente10_DataIntegrationEngineer/skills/etl-planning-skill/checklist.md` |
| 61 | `Agente10_DataIntegrationEngineer/skills/etl-planning-skill/examples/good_output.md` |
| 62 | `Agente10_DataIntegrationEngineer/skills/etl-planning-skill/examples/bad_output.md` |

### Skill 5: api-ingestion-skill (6 files)

| # | File |
|---|------|
| 63 | `Agente10_DataIntegrationEngineer/skills/api-ingestion-skill/skill.md` |
| 64 | `Agente10_DataIntegrationEngineer/skills/api-ingestion-skill/input.schema.json` |
| 65 | `Agente10_DataIntegrationEngineer/skills/api-ingestion-skill/output.schema.json` |
| 66 | `Agente10_DataIntegrationEngineer/skills/api-ingestion-skill/checklist.md` |
| 67 | `Agente10_DataIntegrationEngineer/skills/api-ingestion-skill/examples/good_output.md` |
| 68 | `Agente10_DataIntegrationEngineer/skills/api-ingestion-skill/examples/bad_output.md` |

### Skill 6: idempotent-sync-design-skill (6 files)

| # | File |
|---|------|
| 69 | `Agente10_DataIntegrationEngineer/skills/idempotent-sync-design-skill/skill.md` |
| 70 | `Agente10_DataIntegrationEngineer/skills/idempotent-sync-design-skill/input.schema.json` |
| 71 | `Agente10_DataIntegrationEngineer/skills/idempotent-sync-design-skill/output.schema.json` |
| 72 | `Agente10_DataIntegrationEngineer/skills/idempotent-sync-design-skill/checklist.md` |
| 73 | `Agente10_DataIntegrationEngineer/skills/idempotent-sync-design-skill/examples/good_output.md` |
| 74 | `Agente10_DataIntegrationEngineer/skills/idempotent-sync-design-skill/examples/bad_output.md` |

### Skill 7: data-privacy-risk-skill (6 files)

| # | File |
|---|------|
| 75 | `Agente10_DataIntegrationEngineer/skills/data-privacy-risk-skill/skill.md` |
| 76 | `Agente10_DataIntegrationEngineer/skills/data-privacy-risk-skill/input.schema.json` |
| 77 | `Agente10_DataIntegrationEngineer/skills/data-privacy-risk-skill/output.schema.json` |
| 78 | `Agente10_DataIntegrationEngineer/skills/data-privacy-risk-skill/checklist.md` |
| 79 | `Agente10_DataIntegrationEngineer/skills/data-privacy-risk-skill/examples/good_output.md` |
| 80 | `Agente10_DataIntegrationEngineer/skills/data-privacy-risk-skill/examples/bad_output.md` |

---

## Build Reports (4)

| # | File |
|---|------|
| 81 | `build/Agente10_build_report.md` |
| 82 | `build/Agente10_generated_files_index.md` |
| 83 | `build/Agente10_runtime_readiness_checklist.md` |
| 84 | `build/Agente10_knowledge_distillation_patch_report.md` |
