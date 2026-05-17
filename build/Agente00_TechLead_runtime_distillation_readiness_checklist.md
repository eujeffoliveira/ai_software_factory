# Agente00_TechLead — Runtime Distillation Readiness Checklist

**Patch Date:** 2026-05-17  
**Verified By:** Static analysis (file presence + grep validation)

---

## Knowledge Directory

- [x] `knowledge/` exists at `Agente00_TechLead/knowledge/`
- [x] `knowledge_cards.md` exists — 10 concept cards
- [x] `principles.md` exists — 10 operational principles
- [x] `heuristics.md` exists — 12 decision heuristics
- [x] `decision_rules.md` exists — 31 actionable rules
- [x] `source_map.json` exists — source → artifact mapping

---

## `agent_config.json` Compliance

- [x] `"Agente00_TechLead/knowledge/"` present in `allowed_runtime_sources`
- [x] `"*.pdf"` present in `blocked_runtime_sources`
- [x] `"lib/"` present in `blocked_runtime_sources`
- [x] `"raw_books"` present in `blocked_runtime_sources`
- [x] `"raw_bibliography"` present in `blocked_runtime_sources`
- [x] `"runtime_knowledge_policy"` object present
- [x] `"raw_pdf_access_allowed": false` in `runtime_knowledge_policy`
- [x] `"bibliography_folder_access_allowed": false` in `runtime_knowledge_policy`
- [x] `"local_distilled_knowledge_allowed": true` in `runtime_knowledge_policy`
- [x] `"local_knowledge_path": "Agente00_TechLead/knowledge/"` in `runtime_knowledge_policy`

---

## `prompt.md` Compliance

- [x] `Build-Time Knowledge Distillation Policy` section present
- [x] `knowledge/` listed in Runtime Context Rule allowed sources
- [x] `lib/` listed in blocked sources
- [x] `*.pdf` listed in blocked sources
- [x] Knowledge distillation failure mode added to critical failure modes list
- [x] `knowledge/` subdirectories listed in distillation policy

---

## `rag_manifest.json` Compliance

- [x] `"raw_sources_policy"` object present
- [x] `"raw_pdfs_allowed_at_runtime": false` in `raw_sources_policy`
- [x] `"raw_books_allowed_at_runtime": false` in `raw_sources_policy`
- [x] `"bibliography_folder_allowed_at_runtime": false` in `raw_sources_policy`
- [x] `"build_time_distillation_required": true` in `raw_sources_policy`
- [x] `"runtime_uses_distilled_chunks_only": true` in `raw_sources_policy`
- [x] `"local_distilled_sources"` array present with 5 knowledge/ file references

---

## `context_view.md` Compliance

- [x] `Knowledge Distillation Boundary` section present
- [x] Section explains runtime-local status of context_view.md
- [x] Section lists which build-time sources were consumed
- [x] Section lists `knowledge/` as runtime knowledge path
- [x] Section explicitly blocks raw PDFs, books, `lib/`, `context/`

---

## `skills_manifest.md` Compliance

- [x] `Knowledge Distillation Rule for Skills` section present
- [x] Section prohibits raw PDF/book/bibliography access in skills
- [x] Section lists allowed sources for skills
- [x] Section describes build-patch process for missing knowledge

---

## `failure_modes.md` Compliance

- [x] FM-15 present — Runtime attempt to access raw bibliography
- [x] FM-15 includes: symptom, probable cause, action steps, requires human, blocks flow
- [x] FM-16 present — Missing distilled knowledge
- [x] FM-16 includes: symptom, probable cause, action steps, build-patch escalation path

---

## `checklists/runtime_isolation_checklist.md` Compliance

- [x] `Agente00_TechLead/knowledge/` listed in allowed sources
- [x] Raw PDF files (`*.pdf`) explicitly in blocked sources
- [x] Raw books (`raw_books`, `raw_bibliography`) in blocked sources
- [x] `Knowledge Distillation Checks` section present
- [x] 8 new distillation-specific checklist items present

---

## Skills Compliance (9 of 9)

### `skill.md` — `Knowledge Access Policy` section present

- [x] `state-ledger-management-skill/skill.md`
- [x] `agent-routing-skill/skill.md`
- [x] `artifact-contract-validation-skill/skill.md`
- [x] `tollgate-decision-skill/skill.md`
- [x] `council-mediation-skill/skill.md`
- [x] `adr-governance-skill/skill.md`
- [x] `human-escalation-skill/skill.md`
- [x] `risk-register-management-skill/skill.md`
- [x] `progress-reporting-skill/skill.md`

### `checklist.md` — `Runtime Knowledge Policy` section present

- [x] `state-ledger-management-skill/checklist.md`
- [x] `agent-routing-skill/checklist.md`
- [x] `artifact-contract-validation-skill/checklist.md`
- [x] `tollgate-decision-skill/checklist.md`
- [x] `council-mediation-skill/checklist.md`
- [x] `adr-governance-skill/checklist.md`
- [x] `human-escalation-skill/checklist.md`
- [x] `risk-register-management-skill/checklist.md`
- [x] `progress-reporting-skill/checklist.md`

---

## Other Agent Files — No Modifications Confirmed

- [x] `Agente01_ProductOwner/` — NOT modified
- [x] `Agente02_SoftwareArchitect/` — NOT modified
- [x] No other agent folders modified

---

## White-Label Compliance

- [x] No new references to "Raiz Educação" introduced
- [x] No domain-specific terminology introduced
- [x] knowledge/ files use generic terminology throughout
- [x] `source_map.json` uses generic agent and project references

---

## Readiness Verdict

**Agente00_TechLead knowledge distillation patch: COMPLETE**

All static checks passed. Runtime does not depend on raw PDFs or bibliography. `knowledge/` provides distilled operational knowledge accessible at runtime.
