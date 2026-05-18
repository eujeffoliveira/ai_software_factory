# AI Software Factory — Multi-Agent SDLC Framework

Uma fábrica de software orientada a agentes de IA especializados, onde cada etapa do ciclo de desenvolvimento é executada por um agente dedicado, com papéis, artefatos, contratos e gates de qualidade bem definidos.

---

## Índice

- [O que é](#o-que-é)
- [Como funciona](#como-funciona)
- [Arquitetura de Agentes](#arquitetura-de-agentes)
- [Ciclo de Vida de um Projeto](#ciclo-de-vida-de-um-projeto)
- [Gates de Qualidade](#gates-de-qualidade)
- [Artefatos e Contratos](#artefatos-e-contratos)
- [Golden Model — Stack Técnica Obrigatória](#golden-model--stack-técnica-obrigatória)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Como instanciar para uma organização](#como-instanciar-para-uma-organização)
- [Como criar um agente](#como-criar-um-agente)
- [Como instalar e usar um agente](#como-instalar-e-usar-um-agente)
- [Knowledge Distillation — Regra de Isolamento](#knowledge-distillation--regra-de-isolamento)
- [Fontes de Conhecimento](#fontes-de-conhecimento)
- [Estado atual dos agentes](#estado-atual-dos-agentes)

---

## O que é

A AI Software Factory é um framework de desenvolvimento de software baseado em **múltiplos agentes de IA especializados** que operam em pipeline sequencial. Cada agente tem:

- Um papel único e delimitado no ciclo de desenvolvimento
- Um prompt de sistema que define seu comportamento
- Um conjunto de skills com schemas de entrada/saída
- Checklists e exemplos de bons/maus outputs
- Conhecimento destilado de livros e referências técnicas
- Regras de isolamento de contexto (o agente só lê seus próprios artefatos locais em runtime)

O Tech Lead (Agente 00) é o orquestrador central: ele não executa trabalho técnico, mas coordena todos os outros agentes, valida handoffs, enforça gates de qualidade, registra riscos e escala para humanos quando necessário.

---

## Como funciona

```
Humano / Input
      │
      ▼
┌─────────────────────┐
│  Agente00_TechLead  │  ← Orquestrador / Presidente do Council
│  (sempre presente)  │
└────────┬────────────┘
         │ roteia para
    ┌────┴─────────────────────────────────────────────────────┐
    │                                                          │
    ▼                                                          ▼
Agente01_ProductOwner                               Agente02_SoftwareArchitect
    │                                                          │
    ▼                                                          ▼
  PRD.md ──── Gate 1 ────► Architecture.md ──── Gate 2 ────► Execution_Plan
                │                    │                            │
                │                    │                        Gate 3
                │                    │                            │
                │                    └──────── Agente03_SoftwareEngineer
                │                                                 │
                │                              Agente04_DevBackend │ Agente05_DevFrontend
                │                                        │         │
                │                                    Gate 4 (QA) ◄─┘
                │                                        │
                │                               Agente06_QaEngineer
                │                                        │
                │                                    Gate 5 (Security)
                │                                        │
                │                               Agente07_DevSecOps
                │                                        │
                │                                    Gate 6 (Deploy) ← Aprovação Humana obrigatória
                │                                        │
                │                               Agente08_DevOps
                │                                        │
                └──────────────────────────────── Gate 7 (Post-Deploy)
```

O fluxo é **sempre mediado pelo Tech Lead**. Nenhum agente fala diretamente com outro — cada entrega passa por validação do orquestrador antes de avançar.

### Regras estruturais

- **Nenhum gate avança sem o artefato obrigatório** daquele gate
- **RETURNED** sempre volta ao agente anterior, nunca pula para frente
- **Riscos CRITICAL sem mitigação** bloqueiam o gate atual
- **Decisões irreversíveis** requerem aprovação humana documentada
- **Qualquer desvio do Golden Model** requer ADR (Architecture Decision Record) aprovada antes de avançar

---

## Arquitetura de Agentes

| # | Agente | Papel | Artefato Obrigatório |
|---|--------|-------|----------------------|
| 00 | **Tech Lead** | Orquestrador, State Ledger, Gates, Council | — (orquestra, não produz) |
| 01 | **Product Owner** | Levantamento de requisitos, critérios de aceite | `PRD.md` |
| 02 | **Software Architect** | Decisões de arquitetura, stack, contratos de API | `Architecture.md` |
| 03 | **Software Engineer** | Plano de execução, decomposição de tarefas | `Execution_Plan.json` |
| 04 | **Dev Backend** | Implementação de APIs, lógica de negócio, banco | Pull Request (backend) |
| 05 | **Dev Frontend** | UI, componentes, integração com APIs | Pull Request (frontend) |
| 06 | **QA Engineer** | Testes automatizados, validação de critérios | `QA_Report.md` |
| 07 | **DevSecOps** | Auditoria de segurança, modelagem de ameaças | `Security_Audit.md` |
| 08 | **DevOps** | Pipeline CI/CD, deploy, rollback, SRE | `Deployment_Plan.md` + aprovação humana |
| 09 | **UX/UI Designer** | Design de interfaces, fluxos, usabilidade | `Design_Spec.md` |
| 10 | **Data/Integration Engineer** | Integrações, pipelines de dados, eventos | `Integration_Plan.md` |

### Tech Lead Council

Para decisões críticas ou irreversíveis, o Tech Lead ativa o **Council** — uma deliberação com 5 personas internas:

| Persona | Papel |
|---------|-------|
| Contrarian | Questiona pressupostos, aponta riscos ocultos |
| First Principles | Raciocina a partir do zero, sem viés |
| Expansionist | Explora o espaço de soluções mais amplo |
| Outsider | Perspectiva externa, sem familiaridade com o problema |
| Executor | Foco em viabilidade prática e execução |

O Council requer **consenso de ≥ 3 personas**. Sem consenso, escala para humano.

---

## Ciclo de Vida de um Projeto

```
1. Humano inicia → Tech Lead cria State_Ledger.json
2. Tech Lead → briefa Product Owner → Gate 1 (PRD válido?)
3. Tech Lead → briefa Software Architect → Gate 2 (Architecture válida?)
4. Tech Lead → briefa Software Engineer → Gate 3 (Execution Plan válido?)
5. Tech Lead → briefa Dev Backend + Dev Frontend → Gate 4 (QA aprovado?)
6. Tech Lead → briefa QA Engineer → Gate 5 (Security aprovado?)
7. Tech Lead → briefa DevSecOps → Gate 6 (Deploy aprovado?) ← HUMANO
8. Tech Lead → briefa DevOps → Gate 7 (Post-Deploy ok?)
9. Projeto encerrado
```

O **State Ledger** (`State_Ledger.json`) é a fonte única de verdade e registra em tempo real: fase atual, agente ativo, artefatos aprovados, riscos abertos, ADRs, questões pendentes e aprovações humanas.

---

## Gates de Qualidade

| Gate | Nome | Artefato Validado | Quem pode bloquear |
|------|------|------------------|--------------------|
| 1 | PRD Review | PRD.md | Tech Lead |
| 2 | Architecture Review | Architecture.md | Tech Lead |
| 3 | Execution Plan Review | Execution_Plan.json | Tech Lead |
| 4 | QA Gate | QA_Report.md + cobertura de testes | QA Engineer |
| 5 | Security Gate | Security_Audit.md | DevSecOps (Tech Lead NÃO pode sobrepor) |
| 6 | Deployment Gate | Deployment_Plan.md + rollback plan | Humano (obrigatório) |
| 7 | Post-Deploy Gate | Relatório de saúde pós-deploy | Tech Lead + SLO monitoring |

**21 Status Codes de Gate:**

```
APPROVED | RETURNED_FOR_REVISION | BLOCKED_PENDING_ADR | BLOCKED_PENDING_HUMAN
BLOCKED_CRITICAL_RISK | BLOCKED_MISSING_ARTIFACT | BLOCKED_QA_FAILURE
BLOCKED_SECURITY_FAILURE | BLOCKED_NO_ROLLBACK_PLAN | BLOCKED_MISSING_ACCEPTANCE_CRITERIA
BLOCKED_ARCHITECTURE_DEVIATION | BLOCKED_COUNCIL_NO_CONSENSUS | BLOCKED_SCOPE_EXCEEDED
BLOCKED_MISSING_TESTS | BLOCKED_SLO_VIOLATION | CONDITIONALLY_APPROVED
APPROVED_WITH_RISK | APPROVED_PENDING_MONITORING | ESCALATED_TO_HUMAN
AWAITING_ADR_RESOLUTION | AWAITING_HUMAN_APPROVAL
```

---

## Artefatos e Contratos

Cada entrega entre agentes segue o **Handoff Package** — um contrato de 7 campos obrigatórios:

```json
{
  "artifact_produced": "PRD.md",
  "summary": "Descrição concisa do que foi produzido",
  "assumptions": ["lista de premissas adotadas"],
  "open_questions": ["questões em aberto que afetam o projeto"],
  "risks": ["riscos identificados"],
  "required_next_agent": "Agente02_SoftwareArchitect",
  "validation_checklist": ["critério 1", "critério 2"]
}
```

O Tech Lead valida o Handoff Package antes de encaminhar ao próximo agente. Handoff incompleto = entrega rejeitada.

---

## Golden Model — Stack Técnica Obrigatória

O **Golden Model** define a stack obrigatória de todos os projetos. Qualquer desvio requer ADR aprovada.

| Camada | Tecnologia |
|--------|-----------|
| Framework | Next.js 16 (App Router) |
| Frontend | React 19 + TypeScript 5 |
| Estilização | Tailwind CSS v4 |
| Autenticação | NextAuth v5 + Google OAuth |
| Backend (API) | Route Handlers no Next.js |
| Proxy/Middleware | `proxy.ts` (NUNCA `middleware.ts` no Next.js 16) |
| Banco de dados | PostgreSQL via Supabase |
| ORM | Prisma 7 com PrismaPg adapter |
| Migrations (prod) | `prisma migrate deploy` (NUNCA `db push`) |
| Deploy | Vercel |
| Cron Jobs | Vercel Cron + `guardCron()` em toda rota cron |
| Validação | Zod em todas as fronteiras do sistema |
| Testes unitários | Vitest |
| Testes E2E | Playwright |
| Gráficos | Recharts v3 |
| Data Fetching | Server Components → Server Actions → SWR (polling) |
| Variáveis de ambiente | `lib/env.ts` centralizado |
| Logs | JSON estruturado (`audit_log`, `sync_log`) |

### Antipadrões críticos (bloqueiam Gate 5)

- SQL concatenado diretamente (SQL injection)
- Lógica de negócio em `route.ts`
- `process.env` espalhado fora de `lib/env.ts`
- Segredos hardcoded no código
- `middleware.ts` no Next.js 16
- `prisma db push` em staging/produção
- Jobs sem idempotência
- Deploy sem plano de rollback documentado
- Stack traces expostos para o cliente

---

## Estrutura de Pastas

```
ai_software_factory/
│
├── context/                          # Contexto global — BUILD-TIME apenas
│   ├── base_teorica.md               # Prompts e bases de conhecimento de todos os agentes
│   ├── integrantes.md                # Manifesto operacional dos agentes (2.300 linhas)
│   ├── manual_arquitetura_componentes_generico.md
│   ├── reference_architecture_generico.md  # Golden Model técnico
│   ├── client_profile.md             # ← PREENCHA ISTO ao instanciar para uma organização
│   ├── estrutura_projeto.tree
│   └── prompts/                      # 11 prompts de agentes + prompt de instanciação
│       ├── instantiation_prompt.md   # ← EXECUTE ISTO após preencher client_profile.md
│       ├── prompt_claude_code_agente00_techlead_generico.md
│       ├── prompt_claude_code_agente01_productowner_generico.md
│       └── ... (um arquivo por agente)
│
├── lib/                              # Bibliografia — BUILD-TIME apenas
│   ├── TechLead/                     # The Mythical Man-Month · Accelerate · The Clean Coder
│   ├── ProductOwner/                 # Software Requirements · Writing Effective Use Cases · User Stories Applied
│   │                                 # Agile Software Requirements · Mastering the Requirements Process
│   ├── SoftwareArchitect/            # Clean Architecture · DDIA · Domain-Driven Design
│   │                                 # Fundamentals of Software Architecture · Building Microservices · PEAA
│   ├── SoftwareEngineer/             # The Pragmatic Programmer · Code Complete · Design Patterns (GoF)
│   │                                 # Enterprise Integration Patterns · System Design Interview
│   ├── DevBackend/                   # Clean Code · Introduction to Algorithms · Microservices Patterns
│   │                                 # Architecture Patterns with Python · Grokking Algorithms · Programming Pearls
│   ├── DevFrontend/                  # Eloquent JavaScript · Designing Interfaces
│   │                                 # High Performance Browser Networking · CSS Secrets
│   ├── QaEngineer/                   # TDD by Example · Unit Testing (Khorikov)
│   │                                 # Growing Object-Oriented Software · Working Effectively with Legacy Code · Refactoring
│   ├── DevSecOps/                    # Threat Modeling · The Web Application Hacker's Handbook · Practical Cloud Security
│   ├── DevOps/                       # Continuous Delivery · Site Reliability Engineering (Google)
│   │                                 # The Phoenix Project · The DevOps Handbook · Infrastructure as Code
│   ├── UxUiDesigner/                 # Laws of UX · Don't Make Me Think · Lean UX
│   └── DataIntegrationEngineer/      # Fundamentals of Data Engineering · Building Event-Driven Microservices
│                                     # Data Mesh · Designing Event-Driven Systems
│
├── build/                            # Relatórios de build e validação
│   ├── instantiation_plan.md         # Gerado pelo prompt de instanciação (o que será alterado)
│   ├── instantiation_report.md       # Gerado pelo prompt de instanciação (o que foi alterado)
│   ├── Agente00_TechLead_build_report.md
│   ├── Agente00_TechLead_generated_files_index.md
│   ├── Agente00_TechLead_runtime_readiness_checklist.md
│   ├── Agente00_TechLead_knowledge_distillation_patch_report.md
│   └── ...
│
├── Agente00_TechLead/                # Agente totalmente construído ✅
│   ├── prompt.md                     # Prompt principal do agente
│   ├── agent_config.json             # Configuração de runtime
│   ├── context_view.md               # Visão compilada do contexto
│   ├── rag_manifest.json             # Política de RAG e fontes bloqueadas
│   ├── skills_manifest.md            # Índice das 9 skills
│   ├── quality_gate.md               # Critérios dos Gates 1–7
│   ├── handoff_schema.json           # Schema de validação de handoffs
│   ├── failure_modes.md              # Modos de falha e mitigações
│   ├── knowledge/                    # Conhecimento destilado (runtime ✅)
│   │   ├── principles.md             # 10 princípios operacionais
│   │   ├── heuristics.md             # 12 heurísticas de decisão
│   │   ├── decision_rules.md         # 31 regras if-then
│   │   ├── knowledge_cards.md        # 10 cartões conceituais
│   │   └── source_map.json           # Mapeamento fonte → artefato
│   ├── checklists/                   # 8 checklists operacionais
│   ├── schemas/                      # 7 JSON Schemas de contratos
│   ├── templates/                    # 9 templates de artefatos
│   ├── examples/                     # 8 exemplos bons/ruins
│   └── skills/                       # 9 skills com 6 arquivos cada
│       ├── state-ledger-management-skill/
│       ├── agent-routing-skill/
│       ├── artifact-contract-validation-skill/
│       ├── tollgate-decision-skill/
│       ├── council-mediation-skill/
│       ├── adr-governance-skill/
│       ├── human-escalation-skill/
│       ├── risk-register-management-skill/
│       └── progress-reporting-skill/
│
├── Agente01_ProductOwner/            # Agente totalmente construído ✅ (10 skills)
├── Agente02_SoftwareArchitect/       # Agente totalmente construído ✅ (112 arquivos, 10 skills)
├── Agente03_SoftwareEngineer/        # Agente totalmente construído ✅ (81 arquivos, 7 skills)
├── Agente04_DevBackend/              # Agente totalmente construído ✅ (111 arquivos, 11 skills)
├── Agente05_DevFrontend/             # Agente totalmente construído ✅ (99 arquivos, 10 skills)
├── Agente06_QaEngineer/              # Agente totalmente construído ✅ (92 arquivos, 9 skills)
├── Agente07_DevSecOps/               # Agente totalmente construído ✅ (99 arquivos, 10 skills)
├── Agente08_DevOps/                  # Estrutura criada, build pendente
├── Agente09_UxUiDesigner/            # Não iniciado
└── Agente10_DataIntegrationEngineer/ # Não iniciado
```

---

## Como criar um agente

O processo de **build de um agente** segue estas etapas:

### 1. Fontes de entrada (build-time)

| Fonte | Onde fica | O que fornece |
|-------|-----------|---------------|
| `context/base_teorica.md` | Raiz do projeto | Prompt base, base de conhecimento, regras |
| `context/integrantes.md` | Raiz do projeto | Manifesto operacional completo do agente |
| `context/reference_architecture_generico.md` | Raiz do projeto | Golden Model técnico |
| `context/manual_arquitetura_componentes_generico.md` | Raiz do projeto | Estrutura de artefatos e contratos |
| `lib/<Papel>/` | Pasta de bibliografia | Livros de referência do agente (build-time) |

### 2. Artefatos gerados no build

Para cada agente, o build produz:

```
AgenteXX_NomeAgente/
├── prompt.md                  # Prompt de sistema completo
├── agent_config.json          # Configuração de runtime e fontes permitidas/bloqueadas
├── context_view.md            # Visão compilada do contexto (substitui context/ no runtime)
├── rag_manifest.json          # Política de RAG: coleções, chunking, fontes bloqueadas
├── skills_manifest.md         # Índice e descrição de todas as skills
├── quality_gate.md            # Critérios dos gates que o agente valida
├── handoff_schema.json        # Schema do artefato de entrega
├── failure_modes.md           # Modos de falha conhecidos + mitigações
├── knowledge/                 # Conhecimento destilado dos livros (runtime-safe)
│   ├── principles.md
│   ├── heuristics.md
│   ├── decision_rules.md
│   ├── knowledge_cards.md
│   └── source_map.json
├── checklists/                # Checklists por operação
├── schemas/                   # JSON Schemas dos contratos de I/O
├── templates/                 # Templates dos artefatos produzidos
├── examples/                  # Exemplos de bom e mau output
└── skills/                    # Uma pasta por skill com 6 arquivos:
    └── nome-da-skill/
        ├── skill.md           # Descrição da skill, quando usar, como usar
        ├── input.schema.json  # Schema do input esperado
        ├── output.schema.json # Schema do output produzido
        ├── checklist.md       # Checklist de execução
        └── examples/
            ├── good_output.md
            └── bad_output.md
```

### 3. Relatórios de build

Ao final do build, gerar em `build/`:

- `AgenteXX_build_report.md` — Sumário completo do que foi criado
- `AgenteXX_generated_files_index.md` — Índice de todos os arquivos com propósito
- `AgenteXX_runtime_readiness_checklist.md` — Checklist estático de validação pré-runtime
- `AgenteXX_knowledge_distillation_patch_report.md` — Registro das fontes consumidas e destiladas

### 4. Regra de isolamento de runtime

**CRÍTICO:** Após o build, o agente **não acessa mais** `context/`, `lib/` ou qualquer fonte global. O runtime usa apenas:

- Artefatos locais em `AgenteXX_*/` (prompt.md, schemas, templates, checklists, examples)
- `knowledge/` com o conhecimento destilado
- Inputs de projeto fornecidos diretamente pelo humano ou pelo Tech Lead

---

## Como instalar e usar um agente

### Instalação (qualquer plataforma de IA)

Os agentes são definidos por **prompts de sistema em texto puro** e funcionam com qualquer modelo de linguagem que suporte system prompts — Claude, GPT-4, Gemini, Mistral, ou modelos locais via Ollama.

1. Localize o prompt do agente desejado em:
   ```
   context/prompts/prompt_<modelo>_agente<XX>_<papel>_generico.md
   ```
2. Cole o conteúdo como **System Prompt** (instrução de sistema) da sua sessão
3. Forneça ao agente apenas os artefatos do seu diretório local (`AgenteXX_*/`)

> Os prompts existentes foram otimizados para Claude Code, mas a estrutura e as regras são independentes de modelo. Ao adaptar para outro modelo, mantenha as seções de Runtime Context Rule, Golden Model e Skills intactas.

### Chamando agentes por comando

Use o prefixo `/AgentXX_NomeAgente` para invocar um agente diretamente em qualquer sessão que tenha o prompt do Tech Lead ativo. O Tech Lead interpreta o comando, valida o contexto e roteia a tarefa.

**Iniciando um projeto novo:**
```
/Agente00_TechLead eu quero criar um sistema de agendamento de consultas médicas
com cadastro de pacientes, médicos e horários disponíveis
```

**Solicitando trabalho técnico a um agente especialista:**
```
/Agente04_DevBackend avalie a rota POST /api/appointments e identifique
problemas de concorrência no agendamento simultâneo

/Agente05_DevFrontend altere o estilo do componente <CalendarPicker>
para seguir o design system — use as cores primárias do Tailwind e
adicione estados de hover e foco acessíveis

/Agente06_QaEngineer crie testes E2E com Playwright para o fluxo de
agendamento: seleção de médico → escolha de horário → confirmação

/Agente02_SoftwareArchitect proponha uma arquitetura para suportar
notificações em tempo real sem WebSockets, usando Server-Sent Events
```

**Revisão e governança:**
```
/Agente00_TechLead qual o status atual do projeto? gere um relatório executivo

/Agente07_DevSecOps audite a implementação de autenticação — verifique
session handling, CSRF protection e rate limiting nas rotas públicas

/Agente08_DevOps o deploy falhou na Vercel com erro de build — analise
o log e proponha um plano de rollback
```

**Regras de invocação:**
- Qualquer comando `/Agente` sempre passa pelo **Tech Lead** primeiro, que valida o contexto e decide se roteia ou bloqueia
- O Tech Lead pode recusar o roteamento se o gate anterior não estiver aprovado
- Comandos diretos a agentes especialistas (sem passar pelo Tech Lead) são válidos apenas para tarefas pontuais fora do pipeline formal

### Sequência de gates (resumo prático)

```
Input: Descrição do projeto
  └── Tech Lead → Product Owner
        └── PRD.md → Gate 1 → Tech Lead
              └── Architecture.md → Gate 2 → Tech Lead
                    └── Execution Plan → Gate 3 → Tech Lead
                          └── Dev Backend + Frontend → Gate 4 (QA)
                                └── QA Report → Gate 5 (Security)
                                      └── Security Audit → Gate 6 (HUMANO aprova)
                                            └── Deploy → Gate 7 → Encerrado
```

---

## Knowledge Distillation — Regra de Isolamento

A separação entre **build-time** e **runtime** é um princípio central da fábrica.

### Build-time (apenas durante a criação do agente)

- Os livros de referência são lidos e o conhecimento é extraído
- O contexto global em `context/` é processado
- Os princípios, heurísticas e regras são destilados para `knowledge/`
- **Nenhum livro ou arquivo de `context/` é acessado depois disso**

### Runtime (quando o agente está em uso)

O agente lê **apenas**:

```
AgenteXX_NomeAgente/
├── prompt.md
├── agent_config.json
├── context_view.md
├── knowledge/           ← conhecimento destilado, não os livros originais
├── skills/
├── schemas/
├── templates/
├── checklists/
└── examples/
```

### Por que isso importa

- **Performance**: o agente não precisa ler centenas de páginas de livros em cada sessão
- **Consistência**: o conhecimento destilado é curado e validado, não raw
- **Segurança**: fontes brutas não contaminam o contexto de runtime
- **Custo**: contexto menor = menor uso de tokens

---

## Fontes de Conhecimento

### Por agente (livros de referência — `lib/`)

| Agente | Livros Principais | Materiais Complementares |
|--------|------------------|--------------------------|
| **TechLead** | The Mythical Man-Month (Brooks), Accelerate (Forsgren et al.), The Clean Coder (Martin) | Módulo 10 — Gerenciamento de Projetos (métricas, DORA, SWEBOK), Módulo 12 — Governança de TI |
| **Product Owner** | Software Requirements (Wiegers), Writing Effective Use Cases (Cockburn), User Stories Applied (Cohn) | Módulo 02 — Engenharia de Requisitos I (BPMN, regras de negócio), Módulo 03 — Engenharia de Requisitos II (ISO 25010, RTM, MoSCoW) |
| **Software Architect** | Clean Architecture, DDIA (Kleppmann), DDD (Evans), Fundamentals of Software Architecture (Richards & Ford), Building Microservices (Newman), PEAA (Fowler) | Módulo 04 — Projeto de Software I (coesão/acoplamento), Módulo 05 — Projeto de Software II (UML: casos de uso, sequência, classes) |
| **Software Engineer** | The Pragmatic Programmer, Code Complete, Design Patterns (GoF), Enterprise Integration Patterns (Hohpe & Woolf), System Design Interview (Xu) | Módulo 04 — Projeto de Software I, Módulo 05 — Projeto de Software II (extração de tarefas a partir de diagramas UML) |
| **Dev Backend** | Clean Code, Introduction to Algorithms (Cormen), Microservices Patterns (Richardson), Architecture Patterns with Python, Grokking Algorithms | — |
| **Dev Frontend** | Eloquent JavaScript, Designing Interfaces (Tidwell), CSS Secrets (Verou), High Performance Browser Networking (Grigorik) | — |
| **QA Engineer** | TDD by Example (Beck), Unit Testing (Khorikov), GOOS (Freeman & Pryce), Working Effectively with Legacy Code (Feathers), Refactoring (Fowler) | Módulo 06 — Teste de Software I, Módulo 07 — Teste de Software II, Módulo 08 — Qualidade I, Módulo 09 — Qualidade II (ISO, CMMI, MPS.BR) |
| **DevSecOps** | Threat Modeling (Shostack), The Web Application Hacker's Handbook, Practical Cloud Security (Dotson) | — |
| **DevOps** | Continuous Delivery (Humble & Farley), SRE (Google), The Phoenix Project, The DevOps Handbook (Kim et al.) | Módulo 11 — Gerência de Configuração (controle de mudanças, ferramentas de CM) |
| **UX/UI Designer** | Laws of UX (Yablonski), Don't Make Me Think (Krug), Lean UX (Gothelf & Seiden) | — |
| **Data/Integration Engineer** | Fundamentals of Data Engineering (Reis & Housley), Building Event-Driven Microservices (Bellemare), Data Mesh (Dehghani), Designing Event-Driven Systems (Stopford) | — |

> **Materiais complementares** = apostilas de pós-graduação em Engenharia de Software copiadas para `lib/` em 2026-05-17. Já destiladas nos `knowledge/` dos agentes construídos; serão usadas no build dos demais.

### Contexto global (build-time)

| Arquivo | Conteúdo |
|---------|---------|
| `context/base_teorica.md` | Prompts base e bases de conhecimento de todos os 11 agentes |
| `context/integrantes.md` | Manifesto operacional completo (~2.300 linhas) |
| `context/reference_architecture_generico.md` | Golden Model: stack técnica, padrões obrigatórios, antipadrões |
| `context/manual_arquitetura_componentes_generico.md` | Estrutura de artefatos, contratos de handoff, definição de gates |

### Prompts prontos para instalação

```
context/prompts/
├── prompt_claude_code_agente00_techlead_generico.md         (~26 KB)
├── prompt_claude_code_agente01_productowner_generico.md     (~30 KB)
├── prompt_claude_code_agente02_softwarearchitect_generico.md (~25 KB)
├── prompt_claude_code_agente03_softwareengineer_generico.md  (~24 KB)
├── prompt_claude_code_agente04_devbackend_generico.md        (~25 KB)
├── prompt_claude_code_agente05_devfrontend_generico.md       (~24 KB)
├── prompt_claude_code_agente06_qaengineer_generico.md        (~23 KB)
├── prompt_claude_code_agente07_devsecops_generico.md         (~24 KB)
├── prompt_claude_code_agente08_devops_generico.md            (~24 KB)
├── prompt_claude_code_agente09_uxuidesigner_generico.md      (~22 KB)
└── prompt_claude_code_agente10_dataintegrationengineer_generico.md (~24 KB)
```

---

## Estado atual dos agentes

| Agente | Prompt | Build completo | Knowledge | Skills | Status |
|--------|--------|----------------|-----------|--------|--------|
| **00 TechLead** | ✅ | ✅ | ✅ (+patch) | ✅ 9/9 | **Pronto para uso** |
| **01 ProductOwner** | ✅ | ✅ | ✅ (+patch) | ✅ 10/10 | **Pronto para uso** |
| **02 SoftwareArchitect** | ✅ | ✅ | ✅ (+patch) | ✅ 10/10 | **Pronto para uso** |
| **03 SoftwareEngineer** | ✅ | ✅ | ✅ (+patch) | ✅ 7/7 | **Pronto para uso** |
| **04 DevBackend** | ✅ | ✅ | ✅ | ✅ 11/11 | **Pronto para uso** |
| **05 DevFrontend** | ✅ | ✅ | ✅ | ✅ 10/10 | **Pronto para uso** |
| **06 QaEngineer** | ✅ | ✅ | ✅ | ✅ 9/9 | **Pronto para uso** |
| **07 DevSecOps** | ✅ | ✅ | ✅ | ✅ 10/10 | **Pronto para uso** |
| 08 DevOps | ✅ | ⏳ | ❌ | ❌ | Build pendente |
| 09 UxUiDesigner | ✅ | ❌ | ❌ | ❌ | Não iniciado |
| 10 DataIntegrationEngineer | ✅ | ❌ | ❌ | ❌ | Não iniciado |

> **Todos os 11 prompts genéricos estão prontos em `context/prompts/`.** Agente00, Agente01, Agente02, Agente03, Agente04, Agente05, Agente06 e Agente07 têm build completo (artefatos locais, skills, knowledge distillation). Os demais precisam passar pelo processo de build descrito acima.

---

## Como instanciar para uma organização

Este repositório é **white-label**: não contém referências a organizações, clientes ou domínios específicos. Para usar a fábrica em uma organização real, siga o fluxo abaixo.

### Fluxo completo

```
1. Fork  →  2. Clone  →  3. Preencher client_profile.md  →  4. Rodar instantiation_prompt.md  →  5. Commit
```

**1. Fork**

Faça fork deste repositório no GitHub. O fork é o repositório da organização — o upstream (este repo) continua genérico e pode receber atualizações.

**2. Clone**

```bash
git clone https://github.com/<sua-org>/ai_software_factory.git
cd ai_software_factory
```

**3. Preencher `context/client_profile.md`**

Este é o único arquivo que você precisa editar. Ele define:

- Identidade da organização (nome, tipo, idioma)
- Design system (cores, dark mode, component library)
- Desvios do Golden Path (auth provider, database host, deploy platform, etc.)
- Integrações externas (ERP, CRM, LMS, etc.)
- Contexto regulatório (LGPD, outros frameworks)
- Quais dos 11 agentes ativar

**4. Executar `context/prompts/instantiation_prompt.md`**

Abra o Claude Code na raiz do repositório e cole/execute o conteúdo de `instantiation_prompt.md`. O prompt irá:

- Ler e validar o `client_profile.md`
- Atualizar `agent_config.json`, `context_view.md` e `prompt.md` de cada agente ativo
- Injetar tokens de design, integrações e regras regulatórias nos `knowledge/` relevantes
- Gerar `build/instantiation_plan.md` e `build/instantiation_report.md`

**5. Commit**

O fork agora contém a versão instanciada da fábrica. Todos os agentes ativos estão adaptados ao contexto da organização.

### Atualizações futuras

O prompt de instanciação é **idempotente** — pode ser executado novamente sempre que o `client_profile.md` for atualizado (nova integração, mudança de stack, novo framework regulatório). Ele sobrescreve apenas os campos mapeados ao perfil; estrutura, gates, schemas e checklists nunca são modificados.

### Sobre os arquivos `_generico`

Todos os arquivos com sufixo `_generico` são white-label e devem permanecer sem referências a organizações específicas no repositório upstream. Eles são as fontes de build — o prompt de instanciação os lê mas não os modifica.
