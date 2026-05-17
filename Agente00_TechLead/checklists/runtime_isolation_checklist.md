# Runtime Isolation Checklist

Run this checklist to verify that the Tech Lead agent is operating in proper runtime isolation mode.

---

## Sources Allowed at Runtime

- [ ] Reading from `Agente00_TechLead/prompt.md` ✅
- [ ] Reading from `Agente00_TechLead/agent_config.json` ✅
- [ ] Reading from `Agente00_TechLead/context_view.md` ✅
- [ ] Reading from `Agente00_TechLead/rag_manifest.json` ✅
- [ ] Reading from `Agente00_TechLead/skills_manifest.md` ✅
- [ ] Reading from `Agente00_TechLead/quality_gate.md` ✅
- [ ] Reading from `Agente00_TechLead/handoff_schema.json` ✅
- [ ] Reading from `Agente00_TechLead/failure_modes.md` ✅
- [ ] Reading from `Agente00_TechLead/schemas/` ✅
- [ ] Reading from `Agente00_TechLead/templates/` ✅
- [ ] Reading from `Agente00_TechLead/checklists/` ✅
- [ ] Reading from `Agente00_TechLead/examples/` ✅
- [ ] Reading from `Agente00_TechLead/skills/` ✅
- [ ] Reading from `Agente00_TechLead/knowledge/` ✅ (distilled build-time knowledge)
- [ ] Reading project artifacts provided as input by user/orchestrator ✅

---

## Sources Blocked at Runtime

The following must NEVER be accessed during runtime:

- [ ] `context/` — ❌ BLOCKED
- [ ] `context/` — ❌ BLOCKED
- [ ] `lib/` — ❌ BLOCKED
- [ ] `lib/` — ❌ BLOCKED
- [ ] `context/manual_arquitetura_componentes_generico.md` — ❌ BLOCKED
- [ ] `context/reference_architecture_generico.md` — ❌ BLOCKED
- [ ] `context/integrantes.md` — ❌ BLOCKED
- [ ] `context/base_teorica.md` — ❌ BLOCKED
- [ ] Raw PDF files (`*.pdf`) — ❌ BLOCKED
- [ ] Raw books (`raw_books`, `raw_bibliography`) — ❌ BLOCKED
- [ ] Any file outside `Agente00_TechLead/` not explicitly provided as input — ❌ BLOCKED

## Knowledge Distillation Checks

- [ ] Runtime does not access `context/`.
- [ ] Runtime does not access `lib/`.
- [ ] Runtime does not access raw PDFs.
- [ ] Runtime does not access raw books.
- [ ] Runtime uses `knowledge/` for distilled build-time knowledge.
- [ ] Runtime uses `rag_manifest.json` only for processed chunks/indexes (not raw sources).
- [ ] Runtime can explain which local artifact contains the required knowledge.
- [ ] If knowledge is absent from local artifacts, build-patch is requested — not raw source access.

---

## Verification Questions

Answer before each runtime session:

1. Am I reading technical rules from `context_view.md` (compiled local view) or from the original `reference_architecture_generico.md`?
   - **Correct:** `context_view.md` ✅
   - **Incorrect:** `reference_architecture_generico.md` ❌

2. Am I referencing the Golden Model from my local `context_view.md` or from the global context folder?
   - **Correct:** local `context_view.md` ✅
   - **Incorrect:** global `context/` ❌

3. Am I using bibliography content from compiled RAG manifests or from raw PDFs?
   - **Correct:** `rag_manifest.json` references only ✅
   - **Incorrect:** raw `lib/*.pdf` ❌

4. Am I generating agent-specific context from my local skills or from global integrantes.md?
   - **Correct:** local `skills/` and `context_view.md` ✅
   - **Incorrect:** global `integrantes.md` ❌

---

## Build vs. Runtime Distinction

| Phase | Allowed Sources |
|---|---|
| Build time (factory construction) | All `context/` and `lib/` sources |
| Runtime (factory operation) | Only `Agente00_TechLead/` and provided project artifacts |

**This checklist is a runtime check. Build-time access is governed by the build pipeline.**
