# Agentes — Referência Completa

## Visão geral do pipeline

A factory implementa um pipeline SDLC sequencial com 11 agentes especializados. O Tech Lead orquestra o fluxo e valida os gates. Nenhum gate pode ser pulado — retornos (`RETURNED`) sempre voltam ao agente anterior.

```
Humano
  │
  ▼
@techlead (Agente00) ─── Gate A0: Classificação de Arquétipo
  │
  ▼
@po (Agente01) ─────────── Gate 1: PRD Review
  │
  ▼
@architect (Agente02) ──── Gate 2: Architecture Review
  │
  ▼
@engineer (Agente03) ────── Gate 3: Execution Plan Review
  │
  ├──► @devbackend (Agente04) ─┐
  │                             ├── Gate 4: QA Gate (paralelo)
  └──► @devfrontend (Agente05)─┘
                                │
                                ▼
                   @qa (Agente06) ──────── Gate 4 aprovado
                                │
                                ▼
                   @devsecops (Agente07) ── Gate 5: Security Gate
                                           (incontornável pelo Tech Lead)
                                │
                                ▼
                   @devops (Agente08) ───── Gate 6: Deployment Gate
                                           (aprovação humana obrigatória)
                                │
                                ▼
                   @techlead ────────────── Gate 7: Post-Deploy Gate
                                           (SLO monitoring)
```

**Agentes paralelos:** `@uxui` (Agente09) e `@dataengineer` (Agente10) operam em paralelo com outros agentes conforme necessidade do projeto.

## State Ledger

O `State_Ledger.json` é a **fonte única da verdade** do projeto. Mantido pelo Tech Lead, registra:

- Fase atual e agente ativo
- Artefatos aprovados em cada gate
- Riscos abertos com status e mitigação
- ADRs pendentes e aprovados
- Perguntas abertas para o cliente
- Aprovações humanas concedidas

Todos os handoffs atualizam o State Ledger antes de passar para o próximo agente.

## Handoff Package

Todo artefato entregue por um agente segue o contrato do **Handoff Package** — 7 campos obrigatórios:

```json
{
  "artifact_produced": "PRD.md",
  "summary": "Descrição de uma linha do que foi produzido",
  "assumptions": ["lista de premissas adotadas"],
  "open_questions": ["perguntas que precisam de resposta antes do próximo gate"],
  "risks": [
    {
      "id": "RISK-001",
      "description": "descrição do risco",
      "severity": "HIGH | MEDIUM | LOW",
      "mitigation": "ação proposta"
    }
  ],
  "required_next_agent": "Agente02_SoftwareArchitect",
  "validation_checklist": ["item verificado 1", "item verificado 2"]
}
```

## Agentes — Referência Individual

---

### @techlead — Agente00_TechLead

**Papel:** Orquestrador do pipeline SDLC. Valida todos os gates (A0–7), toma decisões de ADR, mantém o State Ledger e escalona riscos críticos para o humano.

**Quando chamar:**
- Início de qualquer projeto novo
- Validação de handoffs entre agentes
- Decisões de ADR para desvios do Golden Model
- Escalada de riscos sem mitigação

**Produz:** State_Ledger.json, Agent_Briefing.md, Gate_Decision.md, Risk_Register.md

**Valida:** Todos os gates (A0 através do Gate 7)

**Exemplos de prompt:**
```
@techlead avalie a arquitetura deste projeto e identifique riscos críticos
@techlead classifique o arquétipo: script Python que sincroniza dados do ERP diariamente
@techlead o @devbackend entregou a API — valide o handoff e decida o Gate 3
@techlead precisamos desviar do Golden Model para usar MongoDB — avalie o ADR
```

---

### @po — Agente01_ProductOwner

**Papel:** Levantamento de requisitos, user stories e critérios de aceite. Produz o PRD aprovado no Gate 1.

**Quando chamar:**
- Início de projeto para levantar e estruturar requisitos
- Refinamento de user stories com critérios INVEST
- Definição de critérios de aceite para funcionalidades
- Priorização de backlog

**Produz:** PRD.md (Gate 1), User_Story_Map.md

**Valida:** Gate 1 (PRD Review)

**Exemplos de prompt:**
```
@po escreva as user stories para o módulo de autenticação com Google OAuth
@po defina os critérios de aceite para o fluxo de pagamento com Stripe
@po priorize o backlog usando MoSCoW para o MVP de e-commerce
```

---

### @architect — Agente02_SoftwareArchitect

**Papel:** Decisões de arquitetura, seleção de stack, padrões de integração e ADRs para desvios do Golden Model.

**Quando chamar:**
- Após PRD aprovado (Gate 1) para projetar a arquitetura
- Quando há desvio do Golden Model que exige ADR
- Para decisões de integração com sistemas externos
- Para revisar impacto de mudanças arquiteturais

**Produz:** Architecture.md (Gate 2), ADR-NNN.md

**Valida:** Gate 2 (Architecture Review)

**Exemplos de prompt:**
```
@architect proponha a arquitetura para uma API de pagamentos com webhook
@architect avalie se precisamos de ADR para usar PostgreSQL em vez de SQLite neste projeto
@architect decomponha este monolito em serviços — identifique os bounded contexts
```

---

### @engineer — Agente03_SoftwareEngineer

**Papel:** Plano de execução detalhado, decomposição de épicos em tarefas implementáveis e estimativas de esforço.

**Quando chamar:**
- Após Architecture aprovada (Gate 2) para criar o plano de execução
- Para decompor épicos em tasks com critérios de done claros
- Para estimativas de esforço e sequenciamento de dependências

**Produz:** Execution_Plan.json (Gate 3)

**Valida:** Gate 3 (Execution Plan Review)

**Exemplos de prompt:**
```
@engineer decomponha o épico de busca de produtos em tasks implementáveis
@engineer estime o esforço para as features do PRD usando story points
@engineer identifique as dependências entre as tasks e proponha o sequenciamento
```

---

### @devbackend — Agente04_DevBackend

**Papel:** Implementação server-side: APIs REST/GraphQL, banco de dados, migrations, autenticação e integrações.

**Quando chamar:**
- Implementação de endpoints e lógica de negócio
- Criação e aplicação de migrations (Prisma)
- Configuração de autenticação (NextAuth v5)
- Integrações com serviços externos (APIs de terceiros)

**Produz:** Pull Request (backend)

**Exemplos de prompt:**
```
@devbackend implemente POST /api/orders com validação Zod e transação Prisma
@devbackend crie a migration para adicionar a tabela de produtos com índices
@devbackend configure o NextAuth v5 com Google OAuth e Supabase adapter
```

---

### @devfrontend — Agente05_DevFrontend

**Papel:** Implementação client-side: componentes React, páginas Next.js, integração com APIs e acessibilidade.

**Quando chamar:**
- Implementação de componentes React com Tailwind CSS v4
- Criação de páginas Next.js com App Router
- Integração com Server Actions e SWR
- Gráficos e visualizações com Recharts

**Produz:** Pull Request (frontend)

**Exemplos de prompt:**
```
@devfrontend crie o formulário de checkout com validação Zod e feedback de erro
@devfrontend implemente a página de dashboard com gráficos Recharts e Server Components
@devfrontend construa o componente de tabela paginada com SWR para o backoffice
```

---

### @qa — Agente06_QaEngineer

**Papel:** Estratégia de testes, casos E2E com Playwright, cobertura com Vitest e validação de qualidade.

**Quando chamar:**
- Após implementação para criar o plano de testes
- Para escrever testes E2E com Playwright
- Para verificar cobertura de testes
- Para validação dos critérios do Gate 4

**Produz:** QA_Report.md (Gate 4), testes Playwright e Vitest

**Valida:** Gate 4 (QA Gate)

**Exemplos de prompt:**
```
@qa crie os testes Playwright para o fluxo completo de login e checkout
@qa valide se a cobertura de testes atende os critérios do Gate 4 (>80% branches)
@qa identifique os casos de teste de regressão para a feature de pagamento
```

---

### @devsecops — Agente07_DevSecOps

**Papel:** Segurança, conformidade, modelagem de ameaças, OWASP Top 10 e auditoria de segredos.

**Quando chamar:**
- Revisão de segurança antes do Gate 5
- Modelagem de ameaças para novos componentes
- Auditoria de secrets e variáveis de ambiente
- Verificação de vulnerabilidades OWASP

**Produz:** Security_Audit.md (Gate 5)

**Valida:** Gate 5 (Security Gate — incontornável pelo Tech Lead)

**Exemplos de prompt:**
```
@devsecops revise este código por vulnerabilidades OWASP Top 10
@devsecops modele as ameaças para a API de pagamentos com Stripe
@devsecops audite o repositório por secrets expostos e variáveis inseguras
```

---

### @devops — Agente08_DevOps

**Papel:** CI/CD, pipelines de deploy, infraestrutura Vercel, rollback e monitoramento de SLOs.

**Quando chamar:**
- Configuração de pipelines CI/CD
- Deploy para staging e produção
- Definição de plano de rollback
- Monitoramento e alertas pós-deploy

**Produz:** Deployment_Plan.md (Gate 6 — aprovação humana obrigatória)

**Valida:** Gate 6 (Deployment Gate)

**Exemplos de prompt:**
```
@devops configure o CI/CD para Vercel com preview environments por branch
@devops o deploy falhou na produção — analise o log e proponha o rollback
@devops defina os SLOs para a API de pedidos e configure alertas
```

---

### @uxui — Agente09_UxUiDesigner

**Papel:** UX research, arquitetura de informação, wireframes, prototipagem e design system.

**Quando chamar:**
- Pesquisa de usuário e análise de fluxos de navegação
- Wireframes e protótipos de baixa/alta fidelidade
- Revisão de acessibilidade (WCAG 2.1 AA)
- Definição e uso do design system

**Produz:** Design_Spec.md, wireframes, fluxos de navegação

**Exemplos de prompt:**
```
@uxui proponha o wireframe para a tela de onboarding de novos usuários
@uxui avalie a acessibilidade deste componente de formulário
@uxui mapeie o fluxo de navegação completo para o processo de compra
```

---

### @dataengineer — Agente10_DataIntegrationEngineer

**Papel:** Pipelines de dados, ETL/ELT, integrações com sistemas externos e governança de dados.

**Quando chamar:**
- Design de pipelines de ingestão e transformação
- Integrações com ERPs, CRMs e APIs externas
- Estratégia de sincronização incremental vs. full load
- Qualidade e governança de dados

**Produz:** Integration_Plan.md, schemas de pipeline

**Exemplos de prompt:**
```
@dataengineer projete o pipeline de ingestão de dados do ERP com Polars e DuckDB
@dataengineer avalie a estratégia de sincronização incremental para 10M de registros
@dataengineer defina a estratégia de dead-letter queue para o worker de integração
```

---

## Gates de Qualidade

| Gate | Nome | Artefato obrigatório | Quem valida | Observação |
|------|------|----------------------|-------------|------------|
| A0 | Classificação de Arquétipo | JSON de classificação | Tech Lead | Só quando arquétipo não é óbvio |
| 1 | PRD Review | PRD.md | Tech Lead | |
| 2 | Architecture Review | Architecture.md | Tech Lead | ADRs para desvios |
| 3 | Execution Plan Review | Execution_Plan.json | Tech Lead | |
| 4 | QA Gate | QA_Report.md + cobertura | QA Engineer | Cobertura mínima exigida |
| 5 | Security Gate | Security_Audit.md | DevSecOps | **Tech Lead não pode sobrescrever** |
| 6 | Deployment Gate | Deployment_Plan.md + rollback | Humano | **Aprovação humana obrigatória** |
| 7 | Post-Deploy Gate | Health report | Tech Lead + SLO | Monitoramento pós-deploy |

### Códigos de status dos gates (21 válidos)

`APPROVED` · `APPROVED_WITH_CONDITIONS` · `APPROVED_PENDING_MINOR_FIXES` ·
`BLOCKED_PENDING_ADR` · `BLOCKED_PENDING_SECURITY_REVIEW` · `BLOCKED_PENDING_HUMAN_APPROVAL` ·
`BLOCKED_CRITICAL_RISK` · `BLOCKED_MISSING_ARTIFACT` · `BLOCKED_SCHEMA_VIOLATION` ·
`RETURNED_FOR_REVISION` · `RETURNED_MISSING_INFORMATION` · `RETURNED_ASSUMPTION_INVALID` ·
`ESCALATED_TO_HUMAN` · `ESCALATED_RISK_CRITICAL` · `ESCALATED_ADR_REQUIRED` ·
`A0_APPROVED` · `A0_AMBIGUOUS` · `A0_BLOCKED` ·
`GATE_BYPASSED_EMERGENCY` · `GATE_BYPASSED_PROTOTYPE` · `IN_PROGRESS`

A lista completa com critérios de uso está em `Agente00_TechLead/quality_gate.md`.
