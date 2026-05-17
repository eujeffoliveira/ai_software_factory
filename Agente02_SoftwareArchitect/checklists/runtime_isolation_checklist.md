# Runtime Isolation Checklist

_Confirms that Agente02_SoftwareArchitect operates exclusively from its local artifacts at runtime._

---

## Blocked Sources Verification

The following sources must NEVER be consulted at runtime:

- [ ] `context/` folder — BLOCKED ✅
- [ ] `lib/` folder — BLOCKED ✅
- [ ] `context/reference_architecture_generico.md` — BLOCKED ✅
- [ ] `context/integrantes.md` — BLOCKED ✅
- [ ] `context/base_teorica.md` — BLOCKED ✅
- [ ] `context/manual_arquitetura_componentes_generico.md` — BLOCKED ✅
- [ ] Any `*.pdf` file — BLOCKED ✅
- [ ] Raw bibliography (lib/SoftwareArchitect/) — BLOCKED ✅

## Allowed Sources Verification

The following sources are the ONLY sources allowed at runtime:

- [ ] `Agente02_SoftwareArchitect/prompt.md` — ALLOWED
- [ ] `Agente02_SoftwareArchitect/agent_config.json` — ALLOWED
- [ ] `Agente02_SoftwareArchitect/context_view.md` — ALLOWED
- [ ] `Agente02_SoftwareArchitect/rag_manifest.json` — ALLOWED
- [ ] `Agente02_SoftwareArchitect/skills_manifest.md` — ALLOWED
- [ ] `Agente02_SoftwareArchitect/quality_gate.md` — ALLOWED
- [ ] `Agente02_SoftwareArchitect/handoff_schema.json` — ALLOWED
- [ ] `Agente02_SoftwareArchitect/failure_modes.md` — ALLOWED
- [ ] `Agente02_SoftwareArchitect/schemas/` — ALLOWED
- [ ] `Agente02_SoftwareArchitect/templates/` — ALLOWED
- [ ] `Agente02_SoftwareArchitect/checklists/` — ALLOWED
- [ ] `Agente02_SoftwareArchitect/examples/` — ALLOWED
- [ ] `Agente02_SoftwareArchitect/skills/` — ALLOWED
- [ ] `Agente02_SoftwareArchitect/knowledge/` — ALLOWED (distilled build-time knowledge)
- [ ] Project artifacts provided as input by Tech Lead (PRD.md, ADRs, etc.) — ALLOWED

## Knowledge Distillation Verification

The following distilled knowledge artifacts were created at build-time and are available at runtime:

- [ ] `knowledge/principles.md` — present and populated (P1–P11)
- [ ] `knowledge/heuristics.md` — present and populated (H1–H15)
- [ ] `knowledge/decision_rules.md` — present and populated (DR001–DR015)
- [ ] `knowledge/knowledge_cards.md` — present and populated (Card 001–016)
- [ ] `knowledge/source_map.json` — present and records all build-time sources

## Content Verification

- [ ] `context_view.md` contains the compiled Golden Model (does not reference original context/ files)
- [ ] `skills_manifest.md` references only local skill paths
- [ ] `rag_manifest.json` has `runtime_local_only: true`
- [ ] `rag_manifest.json` has `raw_books_at_runtime: false`
- [ ] `agent_config.json` lists all global sources in `blocked_runtime_sources`
- [ ] No template or example contains a reference to `context/` or `lib/`
- [ ] No skill file contains a reference to `context/` or `lib/`

## Build-Time Verification

- [ ] All 6 bibliography PDFs were read at build-time
- [ ] Distilled knowledge covers all 6 books
- [ ] `source_map.json` lists all 6 books + 2 internal docs as sources
- [ ] No raw PDF content was copied into any runtime artifact
