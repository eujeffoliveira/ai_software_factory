# Runtime Isolation Checklist

> Verify that the QA Engineer is operating under correct runtime isolation before and during any evaluation. This checklist enforces the build-time vs. runtime separation that is the core architectural rule of the AI Software Factory.

---

## Pre-Evaluation Isolation Check

Before starting any QA evaluation, confirm all of the following:

- [ ] I am reading ONLY from `Agente06_QaEngineer/` and project input artifacts
- [ ] I have NOT accessed `context/base_teorica.md`
- [ ] I have NOT accessed `context/integrantes.md`
- [ ] I have NOT accessed `context/reference_architecture_generico.md`
- [ ] I have NOT accessed `context/manual_arquitetura_componentes_generico.md`
- [ ] I have NOT accessed any file in `lib/` (reference books folder)
- [ ] I have NOT accessed any `*.pdf` file
- [ ] All knowledge I am using was distilled into `Agente06_QaEngineer/knowledge/` at build time

---

## Authorized Runtime Sources

The ONLY sources this agent may consult at runtime:

### Local Agent Files
- [ ] `Agente06_QaEngineer/prompt.md`
- [ ] `Agente06_QaEngineer/agent_config.json`
- [ ] `Agente06_QaEngineer/context_view.md`
- [ ] `Agente06_QaEngineer/rag_manifest.json`
- [ ] `Agente06_QaEngineer/skills_manifest.md`
- [ ] `Agente06_QaEngineer/quality_gate.md`
- [ ] `Agente06_QaEngineer/handoff_schema.json`
- [ ] `Agente06_QaEngineer/failure_modes.md`
- [ ] `Agente06_QaEngineer/schemas/` (all schema files)
- [ ] `Agente06_QaEngineer/templates/` (all template files)
- [ ] `Agente06_QaEngineer/checklists/` (all checklist files)
- [ ] `Agente06_QaEngineer/examples/` (all example files)
- [ ] `Agente06_QaEngineer/skills/` (all skill files)
- [ ] `Agente06_QaEngineer/knowledge/` (all knowledge files)

### Project Input Artifacts (provided as input to the evaluation)
- [ ] `API_Contract.json` (received as input)
- [ ] PRD document with acceptance criteria (received as input)
- [ ] `Backend_Implementation_Report.md` (received from Agente04)
- [ ] `Frontend_Implementation_Report.md` (received from Agente05)
- [ ] Test files (Vitest and Playwright, from the PR)
- [ ] Coverage report (`coverage/lcov.info` or text output)
- [ ] Application source files being reviewed (from the PR)

---

## Blocked Sources — Never Access at Runtime

- [ ] `context/` — BLOCKED (build-time only)
- [ ] `lib/` — BLOCKED (reference books, build-time only)
- [ ] `*.pdf` — BLOCKED (raw book files)
- [ ] `context/base_teorica.md` — BLOCKED
- [ ] `context/integrantes.md` — BLOCKED
- [ ] `context/reference_architecture_generico.md` — BLOCKED
- [ ] `context/manual_arquitetura_componentes_generico.md` — BLOCKED
- [ ] Any other agent's files — BLOCKED (runtime isolation is per-agent)
- [ ] `context/client_profile.md` — BLOCKED unless explicitly performing instantiation

---

## Knowledge Access Principle

All knowledge from the build-time bibliography has been distilled into:
- `knowledge/principles.md` — 12 operational principles
- `knowledge/heuristics.md` — 15 decision heuristics
- `knowledge/decision_rules.md` — 17 binding if-then rules
- `knowledge/knowledge_cards.md` — 12 concept cards

If a concept from a reference book is needed at runtime, consult the distilled version in `knowledge/` — NOT the original source in `lib/`.

**Why this matters:** Runtime isolation ensures that two different instantiations of this factory (one for client A, one for client B) can coexist in separate forks without the agents cross-contaminating context. The build-time distillation is the mechanism that makes agents portable and self-contained.

---

## Runtime Knowledge Policy

This checklist is self-referential: it is itself an authorized runtime source.  
Do NOT access `context/`, `lib/`, or any PDF to answer questions about isolation policy.  
All isolation rules are encoded in `agent_config.json` (blocked_runtime_sources) and this checklist.
