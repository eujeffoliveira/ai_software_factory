# Matriz de Capacidades dos Agentes

Referência rápida: qual agente faz o quê, quais artefatos produz, quais gates bloqueia e como usa o MCP.

## Tabela principal

| Agente | @slug | Decide | Produz | Valida (Gate) | Bloqueia | Usa MCP para | Arquétipos principais |
|--------|-------|--------|--------|---------------|----------|--------------|----------------------|
| Tech Lead | `@techlead` | Routing, ADRs, gates, escaladas | State_Ledger, Agent_Briefing, Gate_Decision, Risk_Register | A0–7 (todos) | Qualquer gate | Skills de orquestração, templates de gate, ADR templates, decision rules | Todos |
| Product Owner | `@po` | Escopo, prioridade, critérios de aceite | PRD.md, User_Story_Map | Gate 1 | Gate 1 | Templates PRD, skills de user story, checklists INVEST, exemplos de requisitos | web_app, api_service |
| Software Architect | `@architect` | Stack, padrões, integrações, desvios | Architecture.md, ADR-NNN.md | Gate 2 | Gate 2 | Golden Models, templates ADR, schemas de arquitetura, heurísticas de design | Todos |
| Software Engineer | `@engineer` | Decomposição, estimativas, sequenciamento | Execution_Plan.json | Gate 3 | Gate 3 | Templates de plano, skills de decomposição, checklists de task | Todos |
| Dev Backend | `@devbackend` | Implementação server-side, migrations | Pull Request (backend) | — | — | Templates de código, schemas de API, checklists de implementação | web_app, api_service, data_pipeline |
| Dev Frontend | `@devfrontend` | Implementação client-side, componentes | Pull Request (frontend) | — | — | Templates UI, checklists de acessibilidade, exemplos de componentes | web_app |
| QA Engineer | `@qa` | Estratégia de testes, cobertura, casos E2E | QA_Report.md, testes Playwright/Vitest | Gate 4 | Gate 4 | Templates de teste, checklists E2E, skills de cobertura, exemplos Playwright | Todos |
| DevSecOps | `@devsecops` | Controles de segurança, ameaças, conformidade | Security_Audit.md | Gate 5 | Gate 5 (incontornável) | OWASP checklists, threat templates, skills de auditoria, decision rules de segurança | Todos |
| DevOps | `@devops` | Deploy, rollback, SLOs, infraestrutura | Deployment_Plan.md | Gate 6 | Gate 6 (humano obrigatório) | Templates CI/CD, runbooks, checklists de deploy, skills de pipeline | web_app, api_service, mcp_server |
| UX/UI Designer | `@uxui` | Design de interação, fluxos, acessibilidade | Design_Spec.md, wireframes | — | — | Templates wireframe, checklists de acessibilidade, skills UX, exemplos de design | web_app |
| Data Engineer | `@dataengineer` | Estratégia de dados, pipelines, governança | Integration_Plan.md, schemas de pipeline | — | — | Templates pipeline, checklists ETL, schemas de integração, decision rules de dados | data_pipeline, integration_worker |

## Habilidades por agente

| Agente | Qtd. de skills | Exemplos de skills principais |
|--------|---------------|-------------------------------|
| Tech Lead | 8+ | gate-decision, adr-decision, risk-assessment, agent-briefing, state-ledger-update, archetype-classification |
| Product Owner | 10+ | user-story-generation, prd-writing, acceptance-criteria, backlog-prioritization, stakeholder-interview |
| Software Architect | 8+ | architecture-design, adr-writing, golden-model-application, integration-design, threat-modeling-arch |
| Software Engineer | 6+ | task-decomposition, effort-estimation, dependency-mapping, execution-plan-writing |
| Dev Backend | 8+ | api-implementation, migration-writing, auth-setup, prisma-schema, server-action |
| Dev Frontend | 6+ | component-building, page-creation, swr-integration, accessibility-check, recharts-integration |
| QA Engineer | 8+ | e2e-playwright, unit-vitest, coverage-analysis, qa-report, regression-mapping |
| DevSecOps | 8+ | owasp-review, threat-modeling, secrets-audit, security-report, dependency-scan |
| DevOps | 8+ | ci-cd-pipeline, deployment-plan, rollback-plan, slo-definition, infra-review |
| UX/UI Designer | 6+ | wireframe-design, user-flow, accessibility-audit, design-spec, usability-review |
| Data Engineer | 8+ | pipeline-design, etl-mapping, integration-plan, data-quality-check, governance-schema |

## Regras de bloqueio

| Regra | Descrição |
|-------|-----------|
| Gate 5 incontornável | Apenas o DevSecOps pode aprovar o Gate 5. O Tech Lead **não pode** sobrescrever um bloqueio de segurança. |
| Gate 6 com aprovação humana | O Gate 6 (Deploy) exige aprovação explícita de um humano. Nenhum agente pode aprovar sozinho. |
| Sem pulos de gate | `RETURNED` sempre volta ao agente anterior. Nunca avança para o próximo sem aprovação. |
| Risco CRITICAL bloqueia | Qualquer risco classificado como CRITICAL sem mitigação bloqueia o gate atual. |
| ADR antes do Gate 2 | Desvios do Golden Model exigem ADR aprovado antes de prosseguir para o Gate 2. |

## Fluxo de comunicação entre agentes

```
@techlead  ──(Agent_Briefing)──►  @po
@po        ──(PRD.md)──────────►  @techlead ──(Gate 1 OK)──► @architect
@architect ──(Architecture.md)──► @techlead ──(Gate 2 OK)──► @engineer
@engineer  ──(Execution_Plan)───► @techlead ──(Gate 3 OK)──► @devbackend + @devfrontend
@devbackend + @devfrontend ──────────────────────────────►  @qa
@qa        ──(QA_Report.md)─────► @techlead ──(Gate 4 OK)──► @devsecops
@devsecops ──(Security_Audit)───► @techlead ──(Gate 5 OK)──► @devops
@devops    ──(Deployment_Plan)──► Humano    ──(Gate 6 OK)──► @devops (executa deploy)
@devops    ──(Health_Report)────► @techlead ──(Gate 7 OK)──► Projeto entregue
```

## Escopo de acesso em runtime

| Categoria | Agentes com acesso | Bloqueado para |
|-----------|-------------------|----------------|
| `context/` (fontes brutas) | Nenhum em runtime | Todos os agentes |
| `lib/` (livros de referência) | Nenhum em runtime | Todos os agentes |
| `AgenteXX_*/knowledge/` | Apenas o próprio agente | Outros agentes |
| `knowledge.db` via MCP | Todos os agentes | — |
| `standards/` via MCP | Todos os agentes | — |
| `bibliography/playbooks/` via MCP | Todos os agentes | — |

A política de isolamento build-time vs. runtime é a regra arquitetural mais importante da factory. Ver `CLAUDE.md` para detalhes.
