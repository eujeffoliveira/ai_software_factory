# Agente07_DevSecOps — Runtime Readiness Checklist

**Build Date:** 2026-05-17 | **Version:** 1.0.0

Use this checklist to verify the agent is correctly built and ready for runtime use before activating it in the pipeline.

---

## Section 1: Directory Structure

- [ ] `Agente07_DevSecOps/` exists at repository root
- [ ] `Agente07_DevSecOps/knowledge/` exists
- [ ] `Agente07_DevSecOps/schemas/` exists
- [ ] `Agente07_DevSecOps/templates/` exists
- [ ] `Agente07_DevSecOps/checklists/` exists
- [ ] `Agente07_DevSecOps/examples/` exists
- [ ] `Agente07_DevSecOps/skills/` exists with 10 subdirectories
- [ ] Each skill subdirectory has an `examples/` subdirectory

---

## Section 2: Core Files Present

- [ ] `prompt.md` — contains Role, Mission, 10 Operating Principles, Workflow, Handoff Package format
- [ ] `agent_config.json` — valid JSON with `can_be_overridden_by_tech_lead: false`
- [ ] `context_view.md` — contains STRIDE map, OWASP table, Golden Path security rules, data classification tiers
- [ ] `rag_manifest.json` — valid JSON with `blocked_raw_sources` including `context/` and `lib/`
- [ ] `skills_manifest.md` — lists all 10 skills with trigger conditions and execution order
- [ ] `quality_gate.md` — Gate 5 entry/exit criteria, all 7 status codes documented
- [ ] `handoff_schema.json` — valid JSON Schema with all required Handoff Package fields
- [ ] `failure_modes.md` — at least 10 failure modes documented

---

## Section 3: Knowledge Files Present and Complete

- [ ] `knowledge/principles.md` — P1–P12 present, each with Applied rule and QA implication
- [ ] `knowledge/heuristics.md` — H1–H15 present
- [ ] `knowledge/decision_rules.md` — DR001–DR015 present, each with Condition and Action sections
- [ ] `knowledge/knowledge_cards.md` — Card 001–012 present
- [ ] `knowledge/source_map.json` — valid JSON linking bibliography sources to distilled artifacts

---

## Section 4: Schema Files Valid

- [ ] `schemas/security_audit.schema.json` — valid JSON Schema draft-07/2020-12
- [ ] `schemas/threat_model.schema.json` — valid JSON Schema
- [ ] `schemas/privacy_assessment.schema.json` — valid JSON Schema
- [ ] `schemas/security_blocker.schema.json` — valid JSON Schema
- [ ] `schemas/remediation_guide.schema.json` — valid JSON Schema
- [ ] `schemas/data_classification.schema.json` — valid JSON Schema

---

## Section 5: Templates Present and Actionable

- [ ] `templates/Security_Audit.md` — has Gate 5 decision header, OWASP table, findings tables, sign-off checklist
- [ ] `templates/Threat_Model.md` — has all 6 STRIDE category tables
- [ ] `templates/Privacy_Assessment.md` — has legal basis, minimization, consent, deletion, third-party sections
- [ ] `templates/Security_Blockers.md` — has blocker format with wrong/correct patterns
- [ ] `templates/Remediation_Guide.md` — has per-finding format with wrong/correct pattern sections
- [ ] `templates/Data_Classification.md` — has entity classification table with tier reference

---

## Section 6: Checklists Present and Runtime-Isolated

- [ ] `checklists/owasp_top_10_checklist.md` — has all 10 OWASP categories
- [ ] `checklists/privacy_compliance_checklist.md` — has 7 compliance sections
- [ ] `checklists/secrets_checklist.md` — has 7 pattern categories
- [ ] `checklists/authz_checklist.md` — has per-route verification steps
- [ ] `checklists/logging_privacy_checklist.md` — has audit_log/sync_log/console sections
- [ ] `checklists/dependency_security_checklist.md` — has CVSS threshold table
- [ ] `checklists/data_classification_checklist.md` — has 4-tier classification criteria
- [ ] `checklists/runtime_isolation_checklist.md` — has allowed/blocked sources lists
- [ ] Every checklist has a `## Runtime Knowledge Policy` section

---

## Section 7: Skills Complete (10 × 6 files)

For each of the 10 skills, verify:
- [ ] `skill.md` exists with sections: Purpose, When to Use, Inputs, Outputs, Constraints, Steps, Knowledge Access Policy
- [ ] `input.schema.json` — valid JSON Schema
- [ ] `output.schema.json` — valid JSON Schema
- [ ] `checklist.md` — has `## Runtime Knowledge Policy` item
- [ ] `examples/good_output.md` — realistic positive example
- [ ] `examples/bad_output.md` — realistic negative example with annotations

**Skills to verify:**
- [ ] `threat-modeling-skill/`
- [ ] `owasp-review-skill/`
- [ ] `privacy-review-skill/`
- [ ] `secret-scanning-skill/`
- [ ] `authz-review-skill/`
- [ ] `security-audit-report-skill/`
- [ ] `dependency-security-review-skill/`
- [ ] `secure-code-remediation-skill/`
- [ ] `logging-privacy-review-skill/`
- [ ] `data-classification-skill/`

---

## Section 8: Examples Present and Annotated

- [ ] `examples/good_security_audit.md` — APPROVED decision with full evidence
- [ ] `examples/bad_security_audit.md` — shows APPROVED without evidence, annotated with problems
- [ ] `examples/good_threat_model.md` — all 6 STRIDE categories, trust boundaries, mitigations
- [ ] `examples/bad_threat_model.md` — incomplete STRIDE, annotated with problems
- [ ] `examples/good_privacy_assessment.md` — COMPLIANT with documented evidence
- [ ] `examples/bad_privacy_assessment.md` — COMPLIANT without evidence, annotated

---

## Section 9: Build/Runtime Isolation Compliance

- [ ] `agent_config.json` `blocked_runtime_sources` includes `context/`, `lib/`, `*.pdf`
- [ ] `rag_manifest.json` `blocked_raw_sources` includes `lib/DevSecOps/`, `lib/`, `context/`, `*.pdf`
- [ ] Every `skill.md` has `## Knowledge Access Policy` that references only `Agente07_DevSecOps/` paths
- [ ] Every `checklist.md` has `## Runtime Knowledge Policy` that instructs not to access `context/` or `lib/`
- [ ] `checklists/runtime_isolation_checklist.md` verifies isolation at session start

---

## Section 10: Pipeline Integration

- [ ] `agent_config.json` `handoff.receives_from` = `"Agente06_QaEngineer"`
- [ ] `agent_config.json` `handoff.delivers_to_on_approved` = `"Agente08_DevOps"`
- [ ] `agent_config.json` `quality_gate.gate_number` = `5`
- [ ] `quality_gate.md` confirms Gate 5 cannot be overridden by Tech Lead
- [ ] `handoff_schema.json` `required_next_agent` enum includes `"Agente08_DevOps"`

---

## Readiness Verdict

- All 10 sections passing: **READY FOR RUNTIME**
- Any section with unchecked items: **NOT READY — resolve before activating**

**Readiness status:** ✅ READY (as of 2026-05-17 build)
