# Runtime Isolation Checklist

**When to run:** During build verification of Agente04_DevBackend artifacts.  
**Purpose:** Confirm that the agent's runtime artifacts enforce build/runtime isolation — no references to global context or library sources at runtime.

---

## agent_config.json

- [ ] `"mode": "runtime-local-only"` set
- [ ] `blocked_runtime_sources` includes `"context/"` 
- [ ] `blocked_runtime_sources` includes `"lib/"`
- [ ] `blocked_runtime_sources` includes `"*.pdf"`
- [ ] `blocked_runtime_sources` includes all major global docs (`base_teorica.md`, `integrantes.md`, `reference_architecture_generico.md`, `manual_arquitetura_componentes_generico.md`)
- [ ] `allowed_runtime_sources` lists only `Agente04_DevBackend/` paths

## context_view.md

- [ ] No file references to `context/` files
- [ ] No file references to `lib/` files or PDF titles
- [ ] All content is self-contained — no "see context/integrantes.md for details"
- [ ] Header confirms this file replaces global sources at runtime

## rag_manifest.json

- [ ] `"runtime_local_only": true` in `retrieval_policy`
- [ ] `"raw_books_at_runtime": false` in `retrieval_policy`
- [ ] All collections list only `Agente04_DevBackend/` source artifacts
- [ ] `blocked_sources` lists `context/`, `lib/`, `*.pdf`

## Skills — Knowledge Access Policy

For each of the 11 skills, verify `skill.md` contains:
- [ ] `nextjs-server-action-skill/skill.md` has `## Knowledge Access Policy` section
- [ ] `nextjs-route-handler-skill/skill.md` has `## Knowledge Access Policy` section
- [ ] `prisma-dal-skill/skill.md` has `## Knowledge Access Policy` section
- [ ] `zod-validation-skill/skill.md` has `## Knowledge Access Policy` section
- [ ] `cron-job-implementation-skill/skill.md` has `## Knowledge Access Policy` section
- [ ] `structured-logging-skill/skill.md` has `## Knowledge Access Policy` section
- [ ] `audit-log-implementation-skill/skill.md` has `## Knowledge Access Policy` section
- [ ] `sync-log-implementation-skill/skill.md` has `## Knowledge Access Policy` section
- [ ] `backend-test-generation-skill/skill.md` has `## Knowledge Access Policy` section
- [ ] `external-integration-client-skill/skill.md` has `## Knowledge Access Policy` section
- [ ] `sql-safety-review-skill/skill.md` has `## Knowledge Access Policy` section

## Skills — Runtime Knowledge Policy in Checklists

For each of the 11 skills, verify `checklist.md` contains:
- [ ] `nextjs-server-action-skill/checklist.md` has `## Runtime Knowledge Policy` item
- [ ] `nextjs-route-handler-skill/checklist.md` has `## Runtime Knowledge Policy` item
- [ ] `prisma-dal-skill/checklist.md` has `## Runtime Knowledge Policy` item
- [ ] `zod-validation-skill/checklist.md` has `## Runtime Knowledge Policy` item
- [ ] `cron-job-implementation-skill/checklist.md` has `## Runtime Knowledge Policy` item
- [ ] `structured-logging-skill/checklist.md` has `## Runtime Knowledge Policy` item
- [ ] `audit-log-implementation-skill/checklist.md` has `## Runtime Knowledge Policy` item
- [ ] `sync-log-implementation-skill/checklist.md` has `## Runtime Knowledge Policy` item
- [ ] `backend-test-generation-skill/checklist.md` has `## Runtime Knowledge Policy` item
- [ ] `external-integration-client-skill/checklist.md` has `## Runtime Knowledge Policy` item
- [ ] `sql-safety-review-skill/checklist.md` has `## Runtime Knowledge Policy` item

## knowledge/ Directory

- [ ] `principles.md` contains only distilled knowledge — no raw quotes requiring lib/ access
- [ ] `heuristics.md` contains only condensed heuristics — no raw quotes requiring lib/ access
- [ ] `decision_rules.md` references only `Agente04_DevBackend/` artifacts in its Action fields
- [ ] `knowledge_cards.md` is self-contained — no "see lib/CleanCode.pdf for details"
- [ ] `source_map.json` correctly maps sources to artifacts and marks `runtime_access_policy.raw_sources_allowed: false`

---

## Isolation Verification Result

| Check Area | Status |
|------------|--------|
| agent_config.json | [ ] PASS / [ ] FAIL |
| context_view.md | [ ] PASS / [ ] FAIL |
| rag_manifest.json | [ ] PASS / [ ] FAIL |
| Skills Knowledge Access Policy | [ ] PASS / [ ] FAIL |
| Skills Runtime Knowledge Policy | [ ] PASS / [ ] FAIL |
| knowledge/ self-contained | [ ] PASS / [ ] FAIL |

**Overall Isolation Status:** [ ] READY FOR RUNTIME / [ ] NEEDS FIXES

---

## Runtime Knowledge Policy

This checklist is a build-time artifact used to verify the runtime isolation of Agente04_DevBackend.  
It is part of the agent's local artifacts — do NOT consult `context/` to use it.
