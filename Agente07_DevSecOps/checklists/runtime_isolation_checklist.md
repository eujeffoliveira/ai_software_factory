# Runtime Isolation Checklist

> Run this checklist at the START of every Gate 5 evaluation session. Ensures the agent is operating in compliance with the build/runtime isolation rule before beginning any security review.

## Runtime Knowledge Policy

This checklist enforces the build-time vs. runtime isolation rule. At runtime, Agente07_DevSecOps reads ONLY from its own folder. Do NOT access `context/` or `lib/` for any reason during a Gate 5 evaluation.

---

## Section 1: Allowed Runtime Sources Verification

Confirm that every source consulted during this evaluation session is in the allowed list:

- [ ] `Agente07_DevSecOps/prompt.md` — allowed ✅
- [ ] `Agente07_DevSecOps/agent_config.json` — allowed ✅
- [ ] `Agente07_DevSecOps/context_view.md` — allowed ✅
- [ ] `Agente07_DevSecOps/rag_manifest.json` — allowed ✅
- [ ] `Agente07_DevSecOps/skills_manifest.md` — allowed ✅
- [ ] `Agente07_DevSecOps/quality_gate.md` — allowed ✅
- [ ] `Agente07_DevSecOps/handoff_schema.json` — allowed ✅
- [ ] `Agente07_DevSecOps/failure_modes.md` — allowed ✅
- [ ] `Agente07_DevSecOps/schemas/` — allowed ✅
- [ ] `Agente07_DevSecOps/templates/` — allowed ✅
- [ ] `Agente07_DevSecOps/checklists/` — allowed ✅
- [ ] `Agente07_DevSecOps/examples/` — allowed ✅
- [ ] `Agente07_DevSecOps/skills/` — allowed ✅
- [ ] `Agente07_DevSecOps/knowledge/` — allowed ✅

**Project artifacts (input — allowed):**
- [ ] QA_Report.md — provided as input from Agente06_QaEngineer ✅
- [ ] Implementation files — provided as input from Dev agents ✅
- [ ] Architecture.md — project artifact ✅
- [ ] API_Contract.json — project artifact ✅
- [ ] package.json / package-lock.json — project artifact ✅
- [ ] prisma/schema.prisma — project artifact ✅
- [ ] Threat_Model.md — project artifact (if present) ✅

---

## Section 2: Blocked Sources Verification

Confirm the following sources are NOT accessed during this session:

- [ ] `context/` — BLOCKED — do not read any file in this folder
- [ ] `lib/` — BLOCKED — do not read any book or reference document
- [ ] `*.pdf` — BLOCKED — do not read raw PDF files
- [ ] `context/base_teorica.md` — BLOCKED
- [ ] `context/integrantes.md` — BLOCKED
- [ ] `context/reference_architecture_generico.md` — BLOCKED
- [ ] `context/manual_arquitetura_componentes_generico.md` — BLOCKED
- [ ] `context/*_raiz.md` — BLOCKED

**If you find yourself reaching for a context/ or lib/ file:**
→ Stop. The needed information is already distilled in `Agente07_DevSecOps/knowledge/` and `Agente07_DevSecOps/context_view.md`.
→ If the information is genuinely not there, that is a gap to escalate — not a reason to access blocked sources.

---

## Section 3: Entry Criteria Verification

Before beginning any security audit work:

- [ ] **Gate 4 APPROVED confirmed**: QA_Report.md is present with `gate_decision: APPROVED`
- [ ] **gate_ready: true confirmed**: QA Handoff Package has `gate_ready: true`
- [ ] **QA Handoff Package valid**: The package follows the Agente06_QaEngineer handoff schema

**If Gate 4 APPROVED is not confirmed:**
→ Do NOT begin the security audit.
→ Return the submission with: "Gate 4 prerequisite not met — QA_Report.md with APPROVED decision required before Gate 5 evaluation begins."
→ Do NOT issue any Gate 5 status code — it is too early.

---

## Section 4: Skill Invocation Order Verification

Before executing skills, confirm the planned order is correct:

1. [ ] `data-classification-skill` will run FIRST
2. [ ] `threat-modeling-skill` will run BEFORE `owasp-review-skill` if threat model check is needed
3. [ ] Parallel skills (secret-scanning, authz-review, dependency-review, logging-privacy, owasp-review) will run AFTER data classification
4. [ ] `privacy-review-skill` will run AFTER parallel skills complete
5. [ ] `security-audit-report-skill` will run LAST
6. [ ] `secure-code-remediation-skill` will run only if BLOCKED or RETURNED decision is made

---

## Section 5: Output Format Verification

Before issuing any gate decision:

- [ ] Gate 5 status code is from the authorized list in `quality_gate.md`
- [ ] Security_Audit.md template will be used (`templates/Security_Audit.md`)
- [ ] OWASP table has exactly 10 rows (all categories reviewed)
- [ ] Every finding has: finding_id, title, owasp_category, location, description, decision_rule
- [ ] Every CRITICAL/HIGH finding has a remediation note
- [ ] Remediation_Guide.md will be produced if decision is BLOCKED or RETURNED
- [ ] Handoff Package JSON will be produced with the correct schema

---

## Runtime Isolation Status

- [ ] All allowed sources verified
- [ ] No blocked sources accessed
- [ ] Entry criteria confirmed
- [ ] Skill order planned
- [ ] Output format verified

**Proceed with Gate 5 evaluation:** YES / NO (if any item is not checked, resolve before proceeding)
