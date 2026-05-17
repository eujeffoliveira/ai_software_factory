# Runtime Isolation Checklist

Run this checklist to verify that the Product Owner agent is operating in proper runtime isolation mode.

---

## Sources Allowed at Runtime

- [ ] Reading from `Agente01_ProductOwner/prompt.md` ✅
- [ ] Reading from `Agente01_ProductOwner/agent_config.json` ✅
- [ ] Reading from `Agente01_ProductOwner/context_view.md` ✅
- [ ] Reading from `Agente01_ProductOwner/rag_manifest.json` ✅
- [ ] Reading from `Agente01_ProductOwner/skills_manifest.md` ✅
- [ ] Reading from `Agente01_ProductOwner/quality_gate.md` ✅
- [ ] Reading from `Agente01_ProductOwner/handoff_schema.json` ✅
- [ ] Reading from `Agente01_ProductOwner/failure_modes.md` ✅
- [ ] Reading from `Agente01_ProductOwner/schemas/` ✅
- [ ] Reading from `Agente01_ProductOwner/templates/` ✅
- [ ] Reading from `Agente01_ProductOwner/checklists/` ✅
- [ ] Reading from `Agente01_ProductOwner/examples/` ✅
- [ ] Reading from `Agente01_ProductOwner/skills/` ✅
- [ ] Reading from `Agente01_ProductOwner/knowledge/` ✅ (distilled build-time knowledge)
- [ ] Reading project inputs provided by Agente00_TechLead briefing ✅

---

## Sources Blocked at Runtime

The following must NEVER be accessed during runtime:

- [ ] `context/` — ❌ BLOCKED
- [ ] `lib/` — ❌ BLOCKED
- [ ] `context/manual_arquitetura_componentes_generico.md` — ❌ BLOCKED
- [ ] `context/reference_architecture_generico.md` — ❌ BLOCKED
- [ ] `context/integrantes.md` — ❌ BLOCKED
- [ ] `context/integrantes_generico.md` — ❌ BLOCKED
- [ ] `context/base_teorica.md` — ❌ BLOCKED
- [ ] Raw PDF files (`*.pdf`) — ❌ BLOCKED
- [ ] `lib/ProductOwner/*.pdf` — ❌ BLOCKED
- [ ] Raw books or raw bibliography folders — ❌ BLOCKED
- [ ] Any file outside `Agente01_ProductOwner/` not explicitly provided as input — ❌ BLOCKED

---

## Skill-Level Isolation Checks

- [ ] Each skill reads only from `Agente01_ProductOwner/` and project inputs — never from `context/` or `lib/`
- [ ] Each skill's `skill.md` has a "Knowledge Access Policy" section that lists allowed and blocked sources
- [ ] Each skill's `checklist.md` has a "Runtime Knowledge Policy" section with at least one isolation item
- [ ] No skill calls out to external APIs or services not explicitly authorized in `agent_config.json`

---

## Knowledge Distillation Checks

- [ ] Runtime does not access `context/` for any purpose
- [ ] Runtime does not access `lib/` for any purpose
- [ ] Runtime does not access raw PDFs
- [ ] Runtime does not access raw books or bibliography sources
- [ ] Runtime uses `knowledge/` for all distilled build-time knowledge (principles, heuristics, decision rules)
- [ ] Runtime uses `rag_manifest.json` references only (not raw source documents)
- [ ] Runtime can explain which local artifact contains the required knowledge
- [ ] If knowledge is absent from local artifacts, a build-patch is requested — not raw source access

---

## Verification Questions

Answer before each runtime session:

1. Am I using requirements knowledge from `knowledge/principles.md` (compiled local view) or from `lib/ProductOwner/*.pdf`?
   - **Correct:** `knowledge/principles.md` ✅
   - **Incorrect:** raw `lib/ProductOwner/` PDFs ❌

2. Am I applying INVEST criteria from my local `knowledge/heuristics.md` or from the original User Stories Applied book?
   - **Correct:** local `knowledge/heuristics.md` ✅
   - **Incorrect:** `lib/ProductOwner/User Stories Applied*.pdf` ❌

3. Am I generating acceptance criteria from `skills/bdd-acceptance-criteria-skill/skill.md` or from a raw book?
   - **Correct:** local `skills/bdd-acceptance-criteria-skill/skill.md` ✅
   - **Incorrect:** raw bibliography ❌

4. Am I working with technology rules from `context_view.md` (local compiled view) or from the global architecture context?
   - **Correct:** local `context_view.md` ✅
   - **Incorrect:** global `context/` ❌

---

## Build vs. Runtime Distinction

| Phase | Allowed Sources |
|---|---|
| Build time (factory construction) | All `context/` and `lib/` sources |
| Runtime (factory operation) | Only `Agente01_ProductOwner/` and provided project inputs |

**This checklist is a runtime check. Build-time access is governed by the build pipeline.**
