# Context Routing Plan — Agente02_SoftwareArchitect

**Build Date:** 2026-05-17  
**Build Phase:** Etapa 2 — Leitura e Roteamento de Contexto

---

## 1. Source Files Read

| Source | Relevant Sections Extracted |
|--------|----------------------------|
| `context/reference_architecture_generico.md` | §2 Princípios, §3 Regras, §4 ADR, §5 Arquitetura base, §6 Next.js/Proxy, §7 Stack, §10 Banco/Prisma, §13 Segurança, §14 Observabilidade, §18 Deploy, §19.3 ArchitectView, §22 Anti-padrões |
| `context/integrantes.md` | §AGENTE 02 (completo): papel, responsabilidades, inputs, outputs, artefatos, skills, RAG, DoR, DoD, escalamento, limites |
| `context/base_teorica.md` | §AGENT 02 SOFTWARE ARCHITECT: knowledge base (6 livros), rules |
| `context/manual_arquitetura_componentes_generico.md` | Pipeline de build, estrutura de pastas, handoff contracts, quality gates |

---

## 2. Knowledge Routing to Agent Artifacts

### → `context_view.md`
Sources routed in:
- §2-7 da reference_architecture (Golden Model completo para o Arquiteto)
- §10 banco/Prisma
- §13 segurança
- §14 observabilidade
- §18 deploy
- §22 anti-padrões
- Restrições organizacionais genéricas

### → `knowledge/principles.md`
Sources distilled:
- *Clean Architecture* (R.C. Martin): SOLID, use case centricity, dependency rule
- *Fundamentals of Software Architecture* (Richards & Ford): arch styles, fitness functions, trade-off analysis
- *Domain-Driven Design* (Evans): bounded context, ubiquitous language, aggregates
- §2 da reference_architecture: P1–P8
- §AGENTE 02 integrantes.md: princípios operacionais

### → `knowledge/heuristics.md`
Sources distilled:
- *Designing Data-Intensive Applications* (Kleppmann): data model selection, consistency vs. availability
- *Building Microservices* (Newman): when to split, service boundaries
- *Patterns of Enterprise Application Architecture* (Fowler): pattern selection heuristics
- §4 ADR guide from reference_architecture
- Heurísticas de decisão do Arquiteto (quando usar ADR, quando escalar)

### → `knowledge/decision_rules.md`
Sources distilled:
- §3 Regras da reference_architecture
- §4 ADR triggers
- §22 Anti-padrões
- integrantes.md §13 limites

### → `knowledge/knowledge_cards.md`
Sources distilled:
- *Clean Architecture*: dependency rule, boundaries
- *DDD*: bounded context, aggregate root, domain events
- *DDIA*: CAP theorem, ACID vs. BASE, schema-on-read vs. schema-on-write
- *Fundamentals of Software Architecture*: architecture styles, quantum concept
- *Building Microservices*: service mesh, API gateway, decomposition patterns
- *Patterns of EAA*: Repository, Unit of Work, Data Mapper

### → `templates/` and `checklists/`
Sources routed in:
- §4.2 ADR Template from reference_architecture
- §23 Templates from reference_architecture (rollback, healthcheck)
- §21 Checklist de novo projeto
- integrantes.md §11 DoD

### → `skills/*/skill.md`
Sources routed to each skill:
- *architecture-design-skill* ← Clean Architecture, Fundamentals of SW Architecture
- *golden-path-compliance-skill* ← reference_architecture §3, §5
- *adr-authoring-skill* ← reference_architecture §4
- *api-contract-design-skill* ← reference_architecture §5.3, Building Microservices
- *database-modeling-skill* ← reference_architecture §10, DDD, DDIA
- *migration-risk-analysis-skill* ← reference_architecture §10.5–10.6
- *architecture-tradeoff-analysis-skill* ← Fundamentals of SW Architecture, DDIA
- *observability-design-skill* ← reference_architecture §14
- *security-architecture-skill* ← reference_architecture §13
- *deployment-strategy-skill* ← reference_architecture §18

---

## 3. Blocked from Runtime

All of the following are **build-time only** and will not be consulted at runtime:
- `context/reference_architecture_generico.md`
- `context/integrantes.md`
- `context/base_teorica.md`
- `context/manual_arquitetura_componentes_generico.md`
- `lib/SoftwareArchitect/*.pdf`

---

## 4. Runtime Access Policy

At runtime, `Agente02_SoftwareArchitect` reads **only**:
- Local artifacts inside `Agente02_SoftwareArchitect/`
- Project artifacts provided as input by the Tech Lead (PRD.md, ADRs, etc.)
