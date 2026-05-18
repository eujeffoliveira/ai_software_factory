# Runtime Isolation Checklist
## Build-Time vs. Runtime Source Enforcement

This checklist enforces the core architectural rule: at runtime, Agente08_DevOps reads ONLY from `Agente08_DevOps/`. It never accesses `context/`, `lib/`, or raw book files.

---

## Runtime Allowed Sources

At runtime, this agent may ONLY access:

- [ ] `Agente08_DevOps/prompt.md`
- [ ] `Agente08_DevOps/agent_config.json`
- [ ] `Agente08_DevOps/context_view.md`
- [ ] `Agente08_DevOps/rag_manifest.json`
- [ ] `Agente08_DevOps/skills_manifest.md`
- [ ] `Agente08_DevOps/quality_gate.md`
- [ ] `Agente08_DevOps/handoff_schema.json`
- [ ] `Agente08_DevOps/failure_modes.md`
- [ ] `Agente08_DevOps/schemas/`
- [ ] `Agente08_DevOps/templates/`
- [ ] `Agente08_DevOps/checklists/`
- [ ] `Agente08_DevOps/examples/`
- [ ] `Agente08_DevOps/skills/`
- [ ] `Agente08_DevOps/knowledge/`
- [ ] Project artifacts provided as input (Security_Audit.md, QA_Report.md, codebase files, etc.)

---

## Runtime BLOCKED Sources

The following are **NEVER** accessible at runtime:

- [ ] `context/` — BLOCKED (global build-time context folder)
- [ ] `lib/` — BLOCKED (bibliography/reference books folder)
- [ ] `*.pdf` — BLOCKED (raw book files)
- [ ] `context/manual_arquitetura_componentes_generico.md` — BLOCKED
- [ ] `context/reference_architecture_generico.md` — BLOCKED
- [ ] `context/integrantes.md` — BLOCKED
- [ ] `context/base_teorica.md` — BLOCKED
- [ ] Any other agent's folder (`Agente00_*/` through `Agente07_*/`, `Agente09_*/`, `Agente10_*/`) — BLOCKED

---

## Knowledge Substitution Map

When knowledge is needed from a blocked source, use the distilled artifact:

| Blocked Source | Use Instead |
|----------------|------------|
| `lib/DevOps/continuous_delivery.pdf` | `knowledge/principles.md` P1, P2, P8, P9 + `knowledge/heuristics.md` H2, H4, H8 |
| `lib/DevOps/site_reliability_engineering.pdf` | `knowledge/principles.md` P4, P5, P7 + `knowledge/knowledge_cards.md` Card 008 |
| `lib/DevOps/devops_handbook.pdf` | `knowledge/principles.md` P10 + `knowledge/knowledge_cards.md` Card 001 |
| `lib/DevOps/infrastructure_as_code.pdf` | `knowledge/principles.md` P3 + `knowledge/heuristics.md` H1, H7 |
| `lib/DevOps/the_phoenix_project.pdf` | `knowledge/principles.md` P6 |
| `context/reference_architecture_generico.md` | `context_view.md` (all sections) |
| `context/integrantes.md` | `prompt.md` (operating principles + responsibilities) |
| `lib/Modulo11/gerencia_configuracao.pdf` | `knowledge/principles.md` P11, P12 + `knowledge/knowledge_cards.md` Card 012 |

---

## Self-Check Questions

Before any deployment or gate decision, verify:

1. **Did I consult only `Agente08_DevOps/` files and provided project artifacts?**
   [ ] YES — compliant / [ ] NO — violation, do not proceed

2. **Is the knowledge I'm applying from `knowledge/` or `context_view.md`?**
   [ ] YES — compliant / [ ] NO — violation

3. **Am I using templates from `templates/`?**
   [ ] YES — compliant / [ ] NO — violation

4. **Am I using checklists from `checklists/`?**
   [ ] YES — compliant / [ ] NO — violation

---

## Runtime Knowledge Policy

This checklist is the runtime isolation enforcement mechanism itself. All other checklists, skills, and knowledge files in `Agente08_DevOps/` contain their own "Runtime Knowledge Policy" section that references this rule. The rule is simple: if you need it at runtime and it is not in `Agente08_DevOps/`, it should have been distilled during the build phase — never fetch it from a blocked source.
