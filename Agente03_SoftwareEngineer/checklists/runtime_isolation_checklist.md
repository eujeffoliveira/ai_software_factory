# Runtime Isolation Checklist
## Agente03 Software Engineer / Task Planner
## Version: 1.0.0

Run this checklist before publishing any Agente03 artifact.
Verifies that build-time/runtime isolation is correctly enforced throughout all agent files.

---

## agent_config.json Verification

- [ ] `mode` is `"runtime-local-only"`
- [ ] `blocked_runtime_sources` includes `"context/"`
- [ ] `blocked_runtime_sources` includes `"lib/"`
- [ ] `blocked_runtime_sources` includes `"*.pdf"`
- [ ] `blocked_runtime_sources` includes `"context/manual_arquitetura_componentes_generico.md"`
- [ ] `blocked_runtime_sources` includes `"context/reference_architecture_generico.md"`
- [ ] `blocked_runtime_sources` includes `"context/integrantes.md"`
- [ ] `blocked_runtime_sources` includes `"context/base_teorica.md"`
- [ ] `allowed_runtime_sources` only includes paths under `Agente03_SoftwareEngineer/`

---

## context_view.md Verification

- [ ] `context_view.md` contains no file references to `context/` paths
- [ ] `context_view.md` contains no file references to `lib/` paths
- [ ] `context_view.md` contains no references to source PDF titles as citations
- [ ] All knowledge in `context_view.md` is self-contained (can be read without external sources)
- [ ] `context_view.md` references only: Golden Path stack, task planning rules, agent workflow

---

## Skills Verification

For each of the 7 skills (`execution-plan-generation-skill`, `atomic-task-decomposition-skill`, `dependency-graph-skill`, `task-sizing-skill`, `acceptance-criteria-mapping-skill`, `implementation-sequencing-skill`, `context-window-risk-analysis-skill`):

- [ ] `skill.md` contains a `## Knowledge Access Policy` section
- [ ] `## Knowledge Access Policy` specifies: uses only `Agente03_SoftwareEngineer/knowledge/` and local skills
- [ ] `## Knowledge Access Policy` explicitly states: "Never reads context/ or lib/ at runtime"
- [ ] `skill.md` does not reference `lib/` file paths as runtime sources
- [ ] `skill.md` does not cite raw book titles as runtime dependencies
- [ ] `checklist.md` contains a `## Runtime Knowledge Policy` item
- [ ] `## Runtime Knowledge Policy` in `checklist.md` confirms: local artifacts only

---

## rag_manifest.json Verification

- [ ] `retrieval_policy.runtime_local_only` is `true`
- [ ] `retrieval_policy.raw_books_at_runtime` is `false`
- [ ] Every collection has `raw_source_accessible_at_runtime: false`
- [ ] Every collection has `runtime_accessible: true` (distilled knowledge is accessible, raw source is not)
- [ ] `retrieval_policy.blocked_sources` includes `"lib/"`, `"context/"`, `"*.pdf"`
- [ ] All `distilled_into` paths are under `Agente03_SoftwareEngineer/`

---

## knowledge/ Files Verification

- [ ] `knowledge/principles.md` contains no references to raw source files
- [ ] `knowledge/heuristics.md` contains no references to raw source files
- [ ] `knowledge/decision_rules.md` contains no references to raw source files
- [ ] `knowledge/knowledge_cards.md` contains no references to raw source files
- [ ] All knowledge is presented as distilled rules/principles, not as "according to [book]..."
- [ ] `knowledge/source_map.json` has `runtime_access_policy.raw_sources_allowed: false`
- [ ] `knowledge/source_map.json` has `runtime_access_policy.pdf_access_allowed: false`
- [ ] `knowledge/source_map.json` has `runtime_access_policy.bibliography_folder_allowed: false`
- [ ] `knowledge/source_map.json` has `runtime_access_policy.local_distilled_artifacts_allowed: true`

---

## prompt.md Verification

- [ ] `prompt.md` contains an explicit `## Runtime Context Rule` section
- [ ] The section lists all blocked runtime sources
- [ ] The section names the allowed runtime knowledge files
- [ ] `prompt.md` does not instruct the agent to read `context/` at runtime
- [ ] `prompt.md` does not instruct the agent to read `lib/` at runtime

---

## Generic / White-Label Verification

- [ ] No file under `Agente03_SoftwareEngineer/` references a specific organization name
- [ ] No file references a specific client name or project name (placeholders only)
- [ ] No file uses domain-specific terms from any specific vertical
- [ ] Use of generic terms: "organization", "stakeholder", "business user", "primary-color", "data protection compliance"
- [ ] All placeholder values in templates use `[brackets]` notation

---

## Runtime Knowledge Policy

This checklist is a build-time artifact — it is run by the agent builder, not at runtime.
At runtime, the agent uses only:
- `Agente03_SoftwareEngineer/knowledge/`
- `Agente03_SoftwareEngineer/context_view.md`
- Local skill files

---

## Result

- **PASS:** All items checked → Runtime isolation is correctly enforced
- **FAIL:** Any item unchecked → Fix before publishing agent artifacts

_An agent that fails runtime isolation may accidentally access build-time sources and produce client-specific or non-generic outputs at runtime._
