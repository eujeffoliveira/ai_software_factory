# Agente07_DevSecOps — Generated Files Index

**Build Date:** 2026-05-17 | **Total Files:** 103

---

## Core Files (8)

| File | Purpose |
|------|---------|
| `Agente07_DevSecOps/prompt.md` | System prompt — agent identity, operating principles (10), workflow, handoff format |
| `Agente07_DevSecOps/agent_config.json` | Runtime config — allowed/blocked sources, capabilities, Golden Path, gate info |
| `Agente07_DevSecOps/context_view.md` | Compiled local context — STRIDE map, OWASP table, Golden Path security rules, data classification |
| `Agente07_DevSecOps/rag_manifest.json` | RAG policy — 7 collections, blocked raw sources, retrieval order |
| `Agente07_DevSecOps/skills_manifest.md` | Index of 10 skills, execution order, trigger conditions |
| `Agente07_DevSecOps/quality_gate.md` | Gate 5 full specification — entry criteria, status codes, blocking conditions, exit criteria |
| `Agente07_DevSecOps/handoff_schema.json` | JSON Schema for Gate 5 Handoff Package |
| `Agente07_DevSecOps/failure_modes.md` | 12 documented failure modes with symptoms, causes, corrective actions |

## Knowledge Files (5)

| File | Contents |
|------|---------|
| `Agente07_DevSecOps/knowledge/principles.md` | P1–P12 — security principles distilled from bibliography |
| `Agente07_DevSecOps/knowledge/heuristics.md` | H1–H15 — decision shortcuts for ambiguous security situations |
| `Agente07_DevSecOps/knowledge/decision_rules.md` | DR001–DR015 — if-then rules for finding classification and gate decisions |
| `Agente07_DevSecOps/knowledge/knowledge_cards.md` | Card 001–012 — STRIDE, OWASP, IDOR, SQL injection, defense in depth, CVSS, least privilege, privacy by design, data classification, audit_log, guardCron, NextAuth pattern |
| `Agente07_DevSecOps/knowledge/source_map.json` | Build-time source → distilled artifact mapping |

## Schema Files (6)

| File | Validates |
|------|---------|
| `Agente07_DevSecOps/schemas/security_audit.schema.json` | Security_Audit.md structured output |
| `Agente07_DevSecOps/schemas/threat_model.schema.json` | Threat_Model.md structured output |
| `Agente07_DevSecOps/schemas/privacy_assessment.schema.json` | Privacy_Assessment.md structured output |
| `Agente07_DevSecOps/schemas/security_blocker.schema.json` | Individual security blocker entry |
| `Agente07_DevSecOps/schemas/remediation_guide.schema.json` | Remediation_Guide.md structured output |
| `Agente07_DevSecOps/schemas/data_classification.schema.json` | Data_Classification.md structured output |

## Template Files (6)

| File | Purpose |
|------|---------|
| `Agente07_DevSecOps/templates/Security_Audit.md` | Complete security audit report template with all mandatory sections |
| `Agente07_DevSecOps/templates/Threat_Model.md` | STRIDE threat model template with all 6 categories and examples |
| `Agente07_DevSecOps/templates/Privacy_Assessment.md` | Privacy compliance assessment template |
| `Agente07_DevSecOps/templates/Security_Blockers.md` | Security blocker list template for BLOCKED decisions |
| `Agente07_DevSecOps/templates/Remediation_Guide.md` | Per-finding remediation guide template with wrong/correct patterns |
| `Agente07_DevSecOps/templates/Data_Classification.md` | Data entity classification template |

## Checklist Files (8)

| File | Used For |
|------|---------|
| `Agente07_DevSecOps/checklists/owasp_top_10_checklist.md` | Systematic OWASP Top 10 evaluation (all 10 categories) |
| `Agente07_DevSecOps/checklists/privacy_compliance_checklist.md` | LGPD/GDPR compliance assessment for CONFIDENTIAL/RESTRICTED data |
| `Agente07_DevSecOps/checklists/secrets_checklist.md` | Secrets scanning — 7 pattern categories |
| `Agente07_DevSecOps/checklists/authz_checklist.md` | Auth/authz pattern verification per route |
| `Agente07_DevSecOps/checklists/logging_privacy_checklist.md` | audit_log/sync_log/console PII audit |
| `Agente07_DevSecOps/checklists/dependency_security_checklist.md` | npm audit + CVSS-based dependency assessment |
| `Agente07_DevSecOps/checklists/data_classification_checklist.md` | Entity-by-entity data classification |
| `Agente07_DevSecOps/checklists/runtime_isolation_checklist.md` | Pre-session build/runtime isolation verification |

## Example Files (6)

| File | Illustrates |
|------|---------|
| `Agente07_DevSecOps/examples/good_security_audit.md` | Complete APPROVED audit with full OWASP table, evidence, MEDIUM findings, correct format |
| `Agente07_DevSecOps/examples/bad_security_audit.md` | APPROVED despite CRITICAL finding, no OWASP, no file refs — annotated with problems |
| `Agente07_DevSecOps/examples/good_threat_model.md` | Complete STRIDE model with all 6 categories, trust boundaries, assets, mitigations |
| `Agente07_DevSecOps/examples/bad_threat_model.md` | Only 2 STRIDE categories, vague threats — annotated with problems |
| `Agente07_DevSecOps/examples/good_privacy_assessment.md` | COMPLIANT assessment with legal basis, consent, cascade delete, DPA verification |
| `Agente07_DevSecOps/examples/bad_privacy_assessment.md` | COMPLIANT without evidence — annotated with problems |

## Skill Files (10 skills × 6 files = 60)

| Skill | Files |
|-------|-------|
| `threat-modeling-skill` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `owasp-review-skill` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `privacy-review-skill` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `secret-scanning-skill` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `authz-review-skill` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `security-audit-report-skill` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `dependency-security-review-skill` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `secure-code-remediation-skill` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `logging-privacy-review-skill` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |
| `data-classification-skill` | skill.md, input.schema.json, output.schema.json, checklist.md, examples/good_output.md, examples/bad_output.md |

## Build Report Files (4)

| File | Purpose |
|------|---------|
| `build/Agente07_DevSecOps_build_report.md` | Build narrative, architecture decisions, quality assurance, gaps |
| `build/Agente07_DevSecOps_generated_files_index.md` | This file — complete inventory of all 103 created files |
| `build/Agente07_DevSecOps_runtime_readiness_checklist.md` | Pre-deployment verification checklist |
| `build/Agente07_DevSecOps_knowledge_distillation_patch_report.md` | Knowledge distillation traceability from bibliography to artifacts |

---

## File Count Verification

| Category | Count |
|----------|-------|
| Core files | 8 |
| Knowledge files | 5 |
| Schema files | 6 |
| Template files | 6 |
| Checklist files | 8 |
| Example files | 6 |
| Skill files (10 × 6) | 60 |
| Build reports | 4 |
| **Total** | **103** |
