# Runtime Isolation Checklist

> Verify that all produced artifacts respect the build-time vs. runtime isolation rule.
> Run before any Gate 3.5 submission.

## Blocked Sources: Confirm Not Referenced

- [ ] No reference to `context/` in any produced integration artifact
- [ ] No reference to `lib/` in any produced integration artifact
- [ ] No reference to `*.pdf` files in any produced integration artifact
- [ ] No reference to `context/base_teorica.md` in any skill output
- [ ] No reference to `context/integrantes.md` in any artifact
- [ ] No reference to `context/reference_architecture_generico.md` in any artifact
- [ ] No reference to `context/manual_arquitetura_componentes_generico.md` in any artifact

## Allowed Sources: Confirm Only These Referenced

- [ ] All knowledge claims trace back to `Agente10_DataIntegrationEngineer/knowledge/` (principles, heuristics, decision rules, knowledge cards)
- [ ] All templates used are from `Agente10_DataIntegrationEngineer/templates/`
- [ ] All checklists used are from `Agente10_DataIntegrationEngineer/checklists/`
- [ ] All skills invoked are listed in `Agente10_DataIntegrationEngineer/skills_manifest.md`
- [ ] Project artifacts used as input are limited to: `Architecture.md`, `Integration_Requirements.md`, `API_Contract.json`, external API documentation, Prisma schema

## Generic/White-Label Compliance

- [ ] No organization-specific names in produced artifacts (no client names, no brand names)
- [ ] Placeholders used: `[system-name]`, `[organization]`, `[external-system]`
- [ ] No domain-specific terminology that would tie the artifact to a specific client
- [ ] `_generico` naming convention respected for all shared artifacts

## Knowledge Distillation Compliance

- [ ] Principles applied in produced artifacts are from `knowledge/principles.md` (P1–P10)
- [ ] Heuristics applied are from `knowledge/heuristics.md` (H1–H15)
- [ ] Decision rules applied are from `knowledge/decision_rules.md` (DR001–DR020)
- [ ] Knowledge cards referenced are from `knowledge/knowledge_cards.md` (Card001–Card016)
- [ ] No raw book content reproduced in artifacts (distilled knowledge only)

## Post-Execution: Isolation Confirmed

- [ ] All items above checked — no violations found
- [ ] If violations found: remediate before Gate 3.5 submission

## Runtime Knowledge Policy

This checklist is itself a runtime artifact. It exists in `Agente10_DataIntegrationEngineer/checklists/` and is consulted at runtime without accessing `context/` or `lib/`. The knowledge it enforces is distilled in `Agente10_DataIntegrationEngineer/knowledge/`.
