# Manual de Arquitetura e Componentes — AI Software Factory

## Versão
**v1.2 — Build Blueprint Edition — White-label**

## Natureza deste documento

Este documento é o **manual de arquitetura, peças, contratos e componentes** da AI Software Factory da Organização.

Ele descreve:

- quais agentes devem existir;
- qual é o papel de cada agente;
- como os agentes se relacionam;
- quais artefatos devem ser gerados para cada agente;
- quais bases de conhecimento sustentam cada agente;
- como RAG, skills e context views devem ser construídos;
- quais gates e contratos regulam a fábrica;
- como a fábrica deve respeitar a arquitetura técnica da organização.

## Premissa fundamental

Ele funciona exclusivamente como um **roteiro de engenharia para o Claude Code construir a fábrica de agentes**.

A relação correta é:

```txt
Manual de Arquitetura e Componentes
  = roteiro de engenharia usado no build da fábrica

Reference Architecture
  = padrão técnico normativo que será transformado em artefatos locais dos agentes

00-contexto
  = índice e fonte inicial de regras para o build

01-bibliografia
  = corpus teórico usado para estruturar RAGs e bases vetoriais

Pastas raiz dos agentes
  = destino físico dos prompts, skills, RAGs, schemas, templates e configs gerados

Agentes em runtime
  = consultam somente os artefatos gerados dentro de suas próprias pastas locais
```

Portanto:

- este manual **não entra diretamente no contexto runtime dos agentes**;
- a arquitetura de referência **não deve ser enviada integralmente aos agentes em runtime**;
- a bibliografia **não deve ser copiada para dentro dos prompts**;
- o Claude Code usa este manual apenas durante a fase de construção;
- depois do build, cada agente opera com seus próprios arquivos locais.

---

# 1. Objetivo

O objetivo da AI Software Factory é criar uma fábrica de software operada por agentes de IA especializados, capazes de conduzir todo o ciclo de vida de desenvolvimento de software da organização.

A fábrica deve ser capaz de:

- levantar requisitos;
- documentar produto;
- desenhar arquitetura;
- planejar implementação;
- implementar backend;
- implementar frontend;
- validar qualidade;
- validar segurança e LGPD;
- preparar deploy;
- criar rollback plan;
- registrar decisões;
- auditar ações;
- manter rastreabilidade;
- respeitar o padrão arquitetural da empresa;
- operar com contexto isolado por agente;
- usar RAG de forma controlada;
- acionar skills especializadas conforme a fase.

O objetivo não é criar agentes soltos.

O objetivo é criar uma **esteira de engenharia de software auditável, padronizada, operável e compatível com agentes de IA**.

---

# 2. Escopo deste manual

Este manual define:

1. A composição da fábrica de agentes.
2. Os papéis de cada agente.
3. As responsabilidades e limites de cada agente.
4. As bases teóricas usadas por cada agente.
5. A relação entre agentes, skills, RAG e arquitetura.
6. Os artefatos obrigatórios do ciclo de desenvolvimento.
7. Os contratos de passagem entre agentes.
8. Os gates de qualidade e aprovação.
9. O State Ledger do projeto.
10. A matriz de autoridade e escalonamento.
11. A relação com a `Reference Architecture`.
12. As regras para contextos isolados por agente.
13. As coleções RAG esperadas.
14. Os tipos de skills esperados por agente.
15. O pipeline de construção executado pelo Claude Code.
16. Os critérios de completude da fábrica.

Este manual não define:

- o texto final dos prompts;
- a implementação final das skills;
- o código interno dos agentes;
- o engine vetorial específico;
- o mecanismo final de orquestração;
- a ferramenta final de execução runtime;
- regras de negócio de projetos específicos.

Esses itens devem ser criados posteriormente pelo Claude Code usando este manual, `00-contexto`, `01-bibliografia` e a estrutura de pastas do projeto como insumos.

---

# 3. Estrutura base do projeto

A estrutura esperada do projeto segue este modelo:

```txt
ai_software_factory/
  00-contexto/
    base_teorica.md
    integrantes.md
    manual_arquitetura_componentes.md
    reference_architecture.md

  01-bibliografia/
    TechLead/
    ProductOwner/
    SoftwareArchitect/
    SoftwareEngineer/
    DevBackend/
    DevFrontend/
    QaEngineer/
    DevSecOps/
    DevOps/

  Agente00_TechLead/
  Agente01_ProductOwner/
  Agente02_SoftwareArchitect/
  Agente03_SoftwareEngineer/
  Agente04_DevBackend/
  Agente05_DevFrontend/
  Agente06_QaEngineer/
  Agente07_DevSecOps/
  Agente08_DevOps/
```

## 3.1. Papel da pasta `00-contexto`

A pasta `00-contexto` é o **índice inicial e fonte de regras de construção**.

Ela deve conter os documentos que orientam o Claude Code durante o build da fábrica:

| Arquivo | Função |
|---|---|
| `manual_arquitetura_componentes.md` | roteiro de engenharia para construir agentes, skills, RAG e artefatos |
| `reference_architecture.md` | padrão técnico normativo que deve ser transformado em context views e regras locais |
| `integrantes.md` | definição dos agentes, papéis, inputs, outputs e responsabilidades |
| `base_teorica.md` | mapa bibliográfico por agente |

A pasta `00-contexto` é consumida **apenas no build**.

Ela não deve ser consultada diretamente pelos agentes em runtime.

## 3.2. Papel da pasta `01-bibliografia`

A pasta `01-bibliografia` é o **corpus teórico bruto** da fábrica.

Ela contém os livros e materiais baixados, separados por domínio/agente.

O Claude Code deve usar essa pasta para:

- mapear fontes por agente;
- gerar manifestos de RAG;
- definir coleções vetoriais;
- criar metadados;
- criar políticas de recuperação;
- criar referências teóricas locais por agente.

A pasta `01-bibliografia` também é consumida **apenas no build**.

Em runtime, os agentes não devem consultar diretamente os PDFs brutos. Eles devem consultar os índices, coleções, embeddings, manifests e resumos técnicos gerados dentro de suas próprias pastas.

## 3.3. Papel das pastas raiz dos agentes

As pastas raiz dos agentes são o **destino físico final** do build.

Cada pasta deve conter somente os artefatos necessários para aquele agente operar.

Exemplo:

```txt
Agente04_DevBackend/
  prompt.md
  agent_config.json
  context_view.md
  rag_manifest.json
  skills/
  schemas/
  templates/
  checklists/
  examples/
```

Em runtime, o Dev Backend deve consultar apenas os arquivos dentro de `Agente04_DevBackend/`.

O mesmo vale para todos os demais agentes.

---

# 4. Pipeline de Construção — Build Pipeline

O Claude Code deve seguir estritamente a ordem abaixo para construir a fábrica.

Este pipeline é executado **antes** da operação dos agentes.

## 4.1. Etapa 1 — Varredura e Gatilho

O Claude Code será acionado via prompt para iniciar o processo de build.

Nesta etapa, ele deve:

1. Mapear a estrutura do diretório raiz.
2. Confirmar a existência de `00-contexto`.
3. Confirmar a existência de `01-bibliografia`.
4. Confirmar a existência das pastas raiz dos agentes.
5. Identificar lacunas estruturais.
6. Criar um relatório inicial de varredura.

Entrada esperada:

```txt
ai_software_factory/
```

Saída esperada:

```txt
build/scan_report.md
build/missing_structure_report.md
```

A varredura não deve gerar prompts nem skills ainda. Ela apenas confirma a estrutura e identifica o que deve ser compilado.

## 4.2. Etapa 2 — Roteamento de Contexto (`00-contexto`)

Após a varredura, o Claude Code deve ler primeiramente a pasta:

```txt
00-contexto/
```

Esta pasta funciona como **índice de referência** e dita as regras de criação para tudo que cada agente terá.

Ordem recomendada de leitura:

```txt
1. manual_arquitetura_componentes.md
2. integrantes.md
3. reference_architecture.md
4. base_teorica.md
```

Responsabilidades desta etapa:

- entender a arquitetura da fábrica;
- identificar os agentes;
- identificar os artefatos esperados por agente;
- extrair context views necessárias;
- extrair regras normativas da arquitetura;
- mapear quais conhecimentos serão compilados localmente;
- definir o plano de geração por agente.

Saídas esperadas:

```txt
build/context_routing_plan.md
build/agent_build_matrix.json
build/context_views_plan.json
build/skills_plan.json
build/rag_plan.json
```

## 4.3. Etapa 3 — Ingestão de Conhecimento (`01-bibliografia`)

Depois de mapear o contexto, o Claude Code deve consumir a pasta:

```txt
01-bibliografia/
```

Esta etapa estrutura as referências teóricas e bases vetoriais que os agentes precisarão.

Responsabilidades:

- mapear livros por agente;
- criar inventário bibliográfico;
- definir coleções RAG por agente;
- criar metadados de indexação;
- separar teoria de norma técnica;
- impedir que livros inteiros sejam copiados para prompts;
- gerar manifests locais de RAG.

Saídas esperadas:

```txt
build/bibliography_inventory.json
build/rag_collections_manifest.json
build/rag_metadata_schema.json
build/rag_ingestion_plan.md
```

Cada item bibliográfico deve ser associado a:

```json
{
  "agent_id": "Agente04_DevBackend",
  "source_title": "Clean Code",
  "source_type": "book",
  "domain": "backend",
  "priority": "core",
  "usage": "retrieval_only"
}
```

## 4.4. Etapa 4 — Compilação dos artefatos por agente

Após a ingestão de contexto e bibliografia, o Claude Code deve gerar os artefatos locais de cada agente.

Cada agente deve receber, no mínimo:

```txt
prompt.md
agent_config.json
context_view.md
rag_manifest.json
skills_manifest.md
quality_gate.md
handoff_schema.json
failure_modes.md
```

Além disso, cada agente pode ter subpastas:

```txt
skills/
schemas/
templates/
checklists/
examples/
rag/
```

Exemplo:

```txt
Agente04_DevBackend/
  prompt.md
  agent_config.json
  context_view.md
  rag_manifest.json
  skills_manifest.md
  quality_gate.md
  handoff_schema.json
  failure_modes.md

  skills/
    server-action-skill/
    route-handler-skill/
    prisma-dal-skill/
    cron-job-skill/

  schemas/
    backend_task.schema.json
    implementation_report.schema.json

  templates/
    Backend_Implementation_Report.md
    Server_Action_Template.ts
    Cron_Route_Template.ts

  checklists/
    backend_quality_checklist.md
    security_checklist.md

  examples/
    good_output.md
    bad_output.md
```

## 4.5. Etapa 5 — Distribuição nas pastas raiz dos agentes

O processo finaliza com o Claude Code salvando fisicamente todos os arquivos gerados dentro da pasta correspondente de cada agente.

Mapeamento:

| Agente | Diretório de destino |
|---|---|
| Agent 00 — Tech Lead | `Agente00_TechLead/` |
| Agent 01 — Product Owner | `Agente01_ProductOwner/` |
| Agent 02 — Software Architect | `Agente02_SoftwareArchitect/` |
| Agent 03 — Software Engineer | `Agente03_SoftwareEngineer/` |
| Agent 04 — Dev Backend | `Agente04_DevBackend/` |
| Agent 05 — Dev Frontend | `Agente05_DevFrontend/` |
| Agent 06 — QA Engineer | `Agente06_QaEngineer/` |
| Agent 07 — DevSecOps | `Agente07_DevSecOps/` |
| Agent 08 — DevOps | `Agente08_DevOps/` |

Regra final:

```txt
Depois da geração, cada agente deve ser autocontido.
```

Isso significa que cada agente deve ter, em sua própria pasta:

- prompt;
- contexto;
- skills;
- schemas;
- templates;
- checklists;
- RAG manifest;
- exemplos;
- política de falha;
- quality gate.

## 4.6. Etapa 6 — Validação do build

Ao final, o Claude Code deve gerar uma validação do build.

Saídas esperadas:

```txt
build/build_report.md
build/agent_artifacts_matrix.md
build/runtime_readiness_checklist.md
```

Checklist mínimo:

- [ ] `00-contexto` foi lido.
- [ ] `01-bibliografia` foi inventariada.
- [ ] Todos os agentes principais foram gerados.
- [ ] Cada agente possui `prompt.md`.
- [ ] Cada agente possui `context_view.md`.
- [ ] Cada agente possui `rag_manifest.json`.
- [ ] Cada agente possui `skills_manifest.md`.
- [ ] Cada agente possui `quality_gate.md`.
- [ ] Cada agente possui `handoff_schema.json`.
- [ ] Cada agente possui `failure_modes.md`.
- [ ] A Reference Architecture foi compilada em context views locais.
- [ ] A bibliografia foi convertida em manifests RAG.
- [ ] Nenhum agente depende de consultar este manual em runtime.
- [ ] Nenhum agente depende de consultar `00-contexto` em runtime.
- [ ] Nenhum agente depende de consultar `01-bibliografia` diretamente em runtime.

---

# 5. Regra de runtime dos agentes

Após o build, os agentes operam somente com os artefatos locais gerados em suas próprias pastas.

## 5.1. Proibido em runtime

Durante a operação, agentes não devem consultar diretamente:

```txt
00-contexto/
01-bibliografia/
manual_arquitetura_componentes.md
reference_architecture.md completo
integrantes.md
base_teorica.md
PDFs brutos
```

## 5.2. Permitido em runtime

Durante a operação, cada agente pode consultar:

```txt
sua própria pasta local
seu prompt.md
seu context_view.md
seu rag_manifest.json
suas skills
seus schemas
seus templates
seus checklists
seus examples
artefatos do projeto que o Tech Lead fornecer como input
```

## 5.3. Consequência arquitetural

A operação runtime deve ser:

- isolada por agente;
- rastreável;
- reproduzível;
- controlada;
- sem dependência de contexto global gigante;
- compatível com execução local ou orquestrada.

---

# 6. Fontes oficiais de build

A AI Software Factory é construída a partir de quatro fontes principais.

## 6.1. Manual de Arquitetura e Componentes

Arquivo esperado:

```txt
00-contexto/manual_arquitetura_componentes.md
```

Função:

- define o pipeline de construção;
- define agentes;
- define artefatos;
- define gates;
- define skills esperadas;
- define relação entre RAG e agentes;
- define que o manual não é fonte de runtime.

## 6.2. Manifesto dos integrantes

Arquivo esperado:

```txt
00-contexto/integrantes.md
```

Função:

- define composição da fábrica;
- define papéis;
- define responsabilidades;
- define inputs e outputs;
- define limites de cada agente.

## 6.3. Arquitetura de referência

Arquivo esperado:

```txt
00-contexto/reference_architecture.md
```

Função:

- define o padrão técnico normativo da organização;
- deve ser compilado em context views locais;
- não deve ser consultado inteiro em runtime;
- deve prevalecer sobre preferências genéricas de agentes ou bibliografia.

## 6.4. Base teórica

Arquivos esperados:

```txt
00-contexto/base_teorica.md
01-bibliografia/
```

Função:

- `base_teorica.md` mapeia a bibliografia por agente;
- `01-bibliografia/` armazena o corpus bruto;
- o Claude Code usa ambos para criar manifests, índices e bases vetoriais.

---

# 7. Hierarquia de conhecimento

## 7.1. Durante o build

Durante o build, o Claude Code deve respeitar:

```txt
1. Prompt humano de build
2. Manual de Arquitetura e Componentes
3. Reference Architecture
4. Integrantes
5. Base Teórica
6. Bibliografia
7. Conhecimento geral do modelo
```

## 7.2. Durante o runtime

Durante o runtime, cada agente deve respeitar:

```txt
1. Instrução explícita recebida do orquestrador
2. Artefatos locais do próprio agente
3. Skills locais do próprio agente
4. RAG local autorizado para o agente
5. Artefatos do projeto fornecidos como input
```

O agente não deve depender do manual global em runtime.

---

# 8. Modelo conceitual da fábrica

A AI Software Factory é composta por cinco camadas.

## 8.1. Camada de governança

Responsável por:

- orquestração;
- estado do projeto;
- aprovação de gates;
- escalonamento humano;
- Council;
- ADRs;
- rastreabilidade;
- gestão de riscos.

Principal agente:

```txt
Agent 00 — Tech Lead / Orchestrator
```

## 8.2. Camada de especialização

Responsável por executar fases específicas do ciclo de desenvolvimento.

Agentes principais:

```txt
Agent 01 — Product Owner
Agent 02 — Software Architect
Agent 03 — Software Engineer / Task Planner
Agent 04 — Dev Backend
Agent 05 — Dev Frontend
Agent 06 — QA Engineer
Agent 07 — DevSecOps
Agent 08 — DevOps
```

Agentes opcionais:

```txt
Agent 09 — UX/UI Designer
Agent 10 — Data / Integration Engineer
```

## 8.3. Camada de conhecimento

Responsável por fornecer contexto e fundamentação durante o build.

Componentes de build:

```txt
00-contexto/
01-bibliografia/
Reference Architecture
Base teórica
Integrantes
Bibliografia por agente
```

Componentes de runtime:

```txt
context_view.md local
rag_manifest.json local
skills locais
templates locais
schemas locais
checklists locais
examples locais
```

## 8.4. Camada de capacidades

Responsável por prover ferramentas reutilizáveis.

Componentes:

```txt
Skills de orquestração
Skills de requisitos
Skills de arquitetura
Skills de backend
Skills de frontend
Skills de QA
Skills de segurança
Skills de DevOps
Skills de dados/integração
Skills de UX/UI
```

## 8.5. Camada de artefatos

Responsável por formalizar entregas.

Artefatos:

```txt
PRD.md
Architecture.md
API_Contract.json
DB_Schema.sql / Prisma_Schema_Proposal.prisma
Execution_Plan.json
Backend_Implementation_Report.md
Frontend_Implementation_Report.md
QA_Report.md
Security_Audit.md
Deployment_Plan.md
Rollback_Plan.md
Post_Deploy_Report.md
State_Ledger.json
ADR-*.md
```

---

# 9. Fluxo operacional macro da fábrica

Este fluxo descreve a operação da fábrica depois que os agentes já foram construídos.

```txt
User Request
  ↓
Agent 00 — Tech Lead
  ↓
Agent 01 — Product Owner
  ↓
Gate 1 — PRD Approval
  ↓
Agent 02 — Software Architect
  ↓
Gate 2 — Architecture Approval
  ↓
Agent 03 — Software Engineer / Task Planner
  ↓
Gate 3 — Execution Plan Approval
  ↓
Agent 04 / 05 — Dev Backend / Dev Frontend
  ↓
Agent 06 — QA
  ↓
Agent 07 — DevSecOps
  ↓
Gate 4 — Quality + Security Approval
  ↓
Agent 08 — DevOps
  ↓
Gate 5 — Deployment Approval
  ↓
Production / Delivery
```

Regra:

```txt
O fluxo operacional usa os agentes já compilados.
Ele não reconsulta este manual em runtime.
```

---

# 10. Agentes principais

A fábrica é composta por 9 agentes principais.

---

## 10.1. Agent 00 — Tech Lead / Orchestrator / Council President

### Papel

Cérebro central da fábrica. Orquestra fluxo, mantém estado global, valida contratos, aciona agentes e convoca o Council em decisões críticas.

### Responsabilidades

- Receber input inicial do usuário.
- Criar e manter o State Ledger.
- Decidir o próximo agente.
- Validar entregas de agentes.
- Garantir que os artefatos obrigatórios foram produzidos.
- Aplicar quality gates.
- Convocar o Tech Lead Council em tollgates críticos.
- Gerenciar ADRs.
- Escalar decisões humanas.
- Comunicar progresso ao usuário.
- Impedir avanço com contexto incompleto.
- Garantir aderência ao Golden Model compilado em seus artefatos locais.

### Pasta local esperada

```txt
Agente00_TechLead/
```

### Artefatos locais esperados

```txt
prompt.md
agent_config.json
context_view.md
rag_manifest.json
skills_manifest.md
quality_gate.md
handoff_schema.json
failure_modes.md
skills/
schemas/
templates/
checklists/
examples/
```

### Base teórica

- Modern Software Engineering — David Farley
- The Mythical Man-Month — Frederick Brooks
- The Clean Coder — Robert C. Martin
- Business Analysis and Leadership — Keith Hindle & Lesley Giron
- Accelerate — Nicole Forsgren, Jez Humble & Gene Kim
- Staff Engineer — Will Larson
- An Elegant Puzzle — Will Larson
- Team Topologies — Matthew Skelton & Manuel Pais

### Limites

O Tech Lead não substitui os especialistas. Ele valida, rejeita, sintetiza, pede correção, escala, aprova passagem de fase, aciona Council e exige ADR.

---

## 10.2. Agent 01 — Product Owner / Requirements Analyst

### Papel

Tradutor de necessidade de negócio em requisitos claros, testáveis e priorizados.

### Responsabilidades

- Entrevistar o usuário.
- Identificar problema real.
- Definir objetivo do produto.
- Mapear usuários e jornadas.
- Criar user stories no padrão INVEST.
- Criar critérios de aceite em BDD/Gherkin.
- Documentar requisitos funcionais.
- Documentar requisitos não funcionais.
- Definir fora de escopo.
- Registrar dúvidas abertas.
- Informar dados envolvidos em alto nível.

### Pasta local esperada

```txt
Agente01_ProductOwner/
```

### Saídas operacionais

```txt
PRD.md
Requirements_Interview_Log.md
Open_Questions.md
```

### Base teórica

- User Story Mapping — Jeff Patton
- Software Requirements — Karl Wiegers & Joy Beatty
- Specification by Example — Gojko Adzic
- Writing Effective Use Cases — Alistair Cockburn
- Impact Mapping — Gojko Adzic
- Discovering Requirements — Ian Alexander
- Inspired — Marty Cagan
- Continuous Discovery Habits — Teresa Torres
- Escaping the Build Trap — Melissa Perri

### Limites

O Product Owner não escolhe tecnologia, banco, arquitetura, biblioteca, deploy ou padrões de segurança.

---

## 10.3. Agent 02 — Software Architect

### Papel

Transforma requisitos aprovados em arquitetura técnica, contratos, modelo de dados e decisões estruturais.

### Responsabilidades

- Ler o PRD aprovado.
- Definir arquitetura seguindo o Golden Model compilado.
- Criar `Architecture.md`.
- Criar contrato de API.
- Criar proposta de schema de banco.
- Identificar ADRs necessários.
- Definir estratégia de autenticação/autorização.
- Definir estratégia de segurança.
- Definir estratégia de observabilidade.
- Definir estratégia de testes.
- Definir estratégia de deploy.
- Identificar riscos arquiteturais.
- Acionar DevSecOps quando houver risco de segurança, LGPD ou dados sensíveis.

### Pasta local esperada

```txt
Agente02_SoftwareArchitect/
```

### Saídas operacionais

```txt
Architecture.md
API_Contract.json
DB_Schema.sql ou Prisma_Schema_Proposal.prisma
Architecture_Decisions.md
ADR-*.md quando necessário
```

### Base teórica

- Clean Architecture — Robert C. Martin
- Designing Data-Intensive Applications — Martin Kleppmann
- Domain-Driven Design — Eric Evans
- Fundamentals of Software Architecture — Mark Richards & Neal Ford
- Building Microservices — Sam Newman
- Patterns of Enterprise Application Architecture — Martin Fowler
- Software Architecture: The Hard Parts — Ford, Richards, Sadalage, Dehghani
- Building Evolutionary Architectures — Ford, Parsons, Kua
- Documenting Software Architectures: Views and Beyond — Clements et al.

### Limites

O Arquiteto não escreve código final, não desvia do Golden Path sem ADR e não aprova sozinho riscos de segurança ou LGPD.

---

## 10.4. Agent 03 — Software Engineer / Task Planner

### Papel

Transforma arquitetura aprovada em tarefas atômicas executáveis pelos agentes de desenvolvimento.

### Responsabilidades

- Ler PRD, arquitetura e contratos.
- Criar plano de execução.
- Dividir trabalho em tarefas pequenas.
- Mapear dependências.
- Definir ordem de execução.
- Definir arquivos a criar ou alterar.
- Associar critérios de aceite a cada tarefa.
- Definir requisitos de teste por tarefa.
- Definir requisitos de segurança por tarefa.
- Evitar tarefas grandes demais para contexto de LLM.

### Pasta local esperada

```txt
Agente03_SoftwareEngineer/
```

### Saídas operacionais

```txt
Execution_Plan.json
Task_Backlog.md
Dependency_Graph.md
```

### Base teórica

- The Pragmatic Programmer — Andrew Hunt & David Thomas
- Code Complete — Steve McConnell
- Design Patterns — Gang of Four
- Enterprise Integration Patterns — Gregor Hohpe & Bobby Woolf
- System Design Interview — Alex Xu
- A Philosophy of Software Design — John Ousterhout
- Working Effectively with Legacy Code — Michael Feathers

### Limites

Não escreve código final, não altera escopo e não muda arquitetura.

---

## 10.5. Agent 04 — Dev Backend

### Papel

Implementa lógica de servidor, persistência, APIs, jobs e integrações conforme a arquitetura aprovada.

### Responsabilidades

- Implementar Server Actions.
- Implementar Route Handlers finos.
- Implementar camada `lib/db`.
- Implementar jobs em `lib/jobs`.
- Implementar integrações externas.
- Validar inputs com Zod.
- Aplicar autorização server-side.
- Criar logs estruturados.
- Criar testes unitários e de integração.
- Respeitar Prisma, migrations, auditabilidade e segurança.
- Registrar `audit_log` quando houver ação humana sensível.
- Registrar `sync_log` quando houver job automático.

### Pasta local esperada

```txt
Agente04_DevBackend/
```

### Saídas operacionais

```txt
Código backend
Backend_Implementation_Report.md
Test files
Handoff Package para QA
```

### Base teórica

- Clean Code — Robert C. Martin
- Introduction to Algorithms — Cormen et al.
- Grokking Algorithms — Aditya Bhargava
- Microservices Patterns — Chris Richardson
- Node.js Design Patterns — Mario Casciaro & Luciano Mammino
- API Design Patterns — JJ Geewax
- Designing Data-Intensive Applications — Martin Kleppmann

### Limites

Não deve inventar endpoint, escrever lógica em `route.ts`, concatenar SQL raw, acessar `process.env` fora de `lib/env.ts`, adicionar biblioteca sem aprovação, ignorar autorização ou criar job sem idempotência.

---

## 10.6. Agent 05 — Dev Frontend

### Papel

Implementa interfaces React/Next.js aderentes ao Design System, com performance, acessibilidade e integração correta com backend.

### Responsabilidades

- Implementar Server Components quando possível.
- Implementar Client Components quando houver interatividade.
- Consumir APIs e Server Actions.
- Aplicar Tailwind v4 e tokens oficiais.
- Implementar loading states.
- Implementar empty states.
- Implementar error states.
- Garantir responsividade.
- Garantir acessibilidade básica.
- Implementar gráficos com Recharts quando necessário.
- Respeitar o design system interno.
- Evitar client-side fetching desnecessário.

### Pasta local esperada

```txt
Agente05_DevFrontend/
```

### Saídas operacionais

```txt
Componentes React/TSX
Views funcionais
Frontend_Implementation_Report.md
Test files quando aplicável
Handoff Package para QA
```

### Base teórica

- Refactoring UI — Adam Wathan & Steve Schoger
- Eloquent JavaScript — Marijn Haverbeke
- Designing Interfaces — Jenifer Tidwell
- High Performance Browser Networking — Ilya Grigorik
- CSS Secrets — Lea Verou
- Designing Web Interfaces — Bill Scott & Theresa Neil
- Inclusive Design Patterns — Heydon Pickering
- Web Performance in Action — Jeremy Wagner

### Limites

Não deve inventar identidade visual, usar cores fora do Design System, usar `<img>` nativo, usar SWR quando Server Component resolver ou ignorar estados loading/empty/error.

---

## 10.7. Agent 06 — QA Engineer

### Papel

Valida se o software implementado cumpre PRD, critérios de aceite, contratos técnicos e padrões de qualidade.

### Responsabilidades

- Revisar código.
- Validar critérios de aceite.
- Verificar typecheck.
- Verificar lint.
- Gerar ou rodar testes Vitest.
- Gerar ou rodar testes Playwright.
- Validar contrato de API.
- Validar estados de UI.
- Validar regressões.
- Emitir relatório formal.
- Bloquear a esteira quando necessário.

### Pasta local esperada

```txt
Agente06_QaEngineer/
```

### Saídas operacionais

```txt
QA_Report.md
Test files
Bug_Report.md quando necessário
```

### Status possíveis

```txt
PASS
FAIL_FIX_REQUIRED
FAIL_BLOCKING
```

### Base teórica

- Test-Driven Development — Kent Beck
- Unit Testing Principles, Practices, and Patterns — Vladimir Khorikov
- Growing Object-Oriented Software, Guided by Tests — Freeman & Pryce
- Working Effectively with Legacy Code — Michael Feathers
- Refactoring — Martin Fowler
- xUnit Test Patterns — Gerard Meszaros
- Agile Testing — Lisa Crispin & Janet Gregory
- Continuous Delivery — Jez Humble & David Farley

### Limites

QA não aprova entregas com falhas críticas, não assume risco de segurança e não altera escopo.

---

## 10.8. Agent 07 — DevSecOps / Security Sentinel

### Papel

Garante segurança por design, conformidade LGPD, proteção contra vulnerabilidades e governança de dados sensíveis.

### Responsabilidades

- Executar threat modeling.
- Revisar arquitetura.
- Revisar código.
- Verificar OWASP Top 10.
- Verificar secrets.
- Verificar autorização.
- Verificar logs sensíveis.
- Verificar LGPD.
- Verificar dependências vulneráveis.
- Revisar exportações, uploads, webhooks e cron manual.
- Emitir relatório de segurança.
- Bloquear a esteira quando houver risco grave.

### Pasta local esperada

```txt
Agente07_DevSecOps/
```

### Saídas operacionais

```txt
Security_Audit.md
Threat_Model.md
LGPD_Assessment.md
Security_Blockers.md
```

### Status possíveis

```txt
APPROVED
APPROVED_WITH_WARNINGS
BLOCKED_SECURITY_RISK
BLOCKED_LGPD_RISK
```

### Base teórica

- Alice and Bob Learn Application Security — Tanya Janca
- Threat Modeling — Adam Shostack
- The Web Application Hacker's Handbook — Dafydd Stuttard & Marcus Pinto
- Data Privacy: A Runbook for Engineers — Nishant Bhajaria
- Secure By Design — Johnsson, Deogun & Sawano
- Practical Cloud Security — Chris Dotson
- OWASP ASVS
- OWASP Testing Guide
- NIST Secure Software Development Framework

### Limites

DevSecOps pode bloquear. DevSecOps não aceita risco grave sozinho.

---

## 10.9. Agent 08 — DevOps / Deployment / SRE

### Papel

Garante entrega segura, reprodutível, observável e com plano de rollback.

### Responsabilidades

- Criar pipeline CI/CD.
- Validar variáveis de ambiente.
- Planejar migrations.
- Configurar deploy.
- Definir healthcheck.
- Definir rollback.
- Definir smoke test pós-deploy.
- Verificar observabilidade.
- Verificar runbooks quando o projeto for crítico.
- Emitir relatórios de deploy.

### Pasta local esperada

```txt
Agente08_DevOps/
```

### Saídas operacionais

```txt
Deployment_Plan.md
Rollback_Plan.md
Environment_Checklist.md
Post_Deploy_Report.md
CI/CD config
Runbook quando aplicável
```

### Base teórica

- Continuous Delivery — Jez Humble & David Farley
- Site Reliability Engineering — Google SRE Book
- Infrastructure as Code — Kief Morris
- The DevOps Handbook — Gene Kim et al.
- The Phoenix Project — Gene Kim
- Release It! — Michael Nygard
- Observability Engineering — Charity Majors, Liz Fong-Jones, George Miranda
- Database Reliability Engineering — Laine Campbell & Charity Majors

### Limites

Não executa deploy de produção, migration destrutiva ou rollback sem aprovação humana quando exigido.

---

# 11. Agentes opcionais

## 11.1. Agent 09 — UX/UI Designer

### Quando usar

- produtos públicos;
- portal de famílias, alunos ou responsáveis;
- jornada complexa;
- onboarding;
- telas numerosas;
- validação visual;
- experiência comercial.

### Saídas

```txt
UX_Flow.md
Wireframes.md
UI_Spec.md
Usability_Checklist.md
```

## 11.2. Agent 10 — Data / Integration Engineer

### Quando usar

- TOTVS/RM;
- APIs externas;
- pipelines de dados;
- dashboards analíticos;
- planilhas;
- sincronização;
- carga incremental;
- qualidade de dados.

### Saídas

```txt
Integration_Spec.md
Data_Mapping.md
Sync_Strategy.md
Data_Quality_Checklist.md
```

---

# 12. Context Views

## 12.1. Princípio

Context View não é prompt.

Context View é o subconjunto de conhecimento compilado para um agente.

Cada agente recebe sua context view local no build e consulta apenas esse arquivo em runtime.

## 12.2. Context Views oficiais

| Agente | Contexto local esperado |
|---|---|
| Tech Lead | visão completa compilada, gates, state ledger, ADRs |
| Product Owner | PRD, requisitos, entrevistas, escopo |
| Software Architect | Golden Path, ADR, arquitetura, banco, deploy, segurança |
| Task Planner | PRD, arquitetura, contratos, gates, task sizing |
| Dev Backend | backend, API, DB, jobs, Zod, logs, testes |
| Dev Frontend | frontend, design system, acessibilidade, API contract |
| QA | critérios de aceite, testes, anti-padrões, gates |
| DevSecOps | auth, env, LGPD, OWASP, logs, dados sensíveis |
| DevOps | CI/CD, migrations, deploy, rollback, healthcheck |
| UX/UI | design system, acessibilidade, público-alvo |
| Data/Integration | dados, integrações, jobs, sync, LGPD |

---

# 13. RAG

## 13.1. Princípio

Os livros, arquitetura e documentos internos são usados para gerar artefatos locais de conhecimento.

Em runtime, agentes consultam apenas o RAG local autorizado.

## 13.2. Coleções recomendadas

```json
{
  "requirements_engineering": ["Agente01_ProductOwner"],
  "product_discovery": ["Agente01_ProductOwner"],
  "software_architecture": ["Agente00_TechLead", "Agente02_SoftwareArchitect"],
  "data_intensive_applications": ["Agente02_SoftwareArchitect", "Agente04_DevBackend"],
  "backend_engineering": ["Agente04_DevBackend"],
  "frontend_engineering": ["Agente05_DevFrontend"],
  "testing_quality": ["Agente06_QaEngineer"],
  "security_privacy": ["Agente07_DevSecOps"],
  "devops_sre": ["Agente08_DevOps"],
  "architecture_reference_full": ["Agente00_TechLead", "Agente02_SoftwareArchitect"],
  "architecture_reference_backend_view": ["Agente04_DevBackend"],
  "architecture_reference_frontend_view": ["Agente05_DevFrontend"],
  "architecture_reference_qa_view": ["Agente06_QaEngineer"],
  "architecture_reference_security_view": ["Agente07_DevSecOps"],
  "architecture_reference_devops_view": ["Agente08_DevOps"]
}
```

## 13.3. Metadados obrigatórios

```json
{
  "source_title": "string",
  "source_type": "book | standard | architecture_doc | internal_doc | adr | project_doc",
  "agent_scope": ["agent-id"],
  "domain": "requirements | architecture | backend | frontend | qa | security | devops | data | ux",
  "chapter": "string",
  "section": "string",
  "priority": "core | supporting | optional",
  "rule_level": "mandatory | golden_path | adr_required | reference | theoretical",
  "language": "pt-BR | en-US",
  "version": "string",
  "copyright_policy": "retrieval_only"
}
```

---

# 14. Skills

## 14.1. Papel das skills

Skills são capacidades reutilizáveis que cada agente pode acionar em runtime.

Este manual define quais tipos de skills devem ser geradas no build.

## 14.2. Tipos de skills

| Tipo | Exemplos |
|---|---|
| Orquestração | State Ledger, Handoff Validation, Gate Decision |
| Requisitos | PRD Generation, Interview, User Story Mapping |
| Arquitetura | ADR, API Contract, DB Modeling, Trade-off Review |
| Backend | Server Action, Route Handler, Prisma DAL, Cron Job |
| Frontend | Component Generation, Design System, A11y, Recharts |
| QA | Vitest, Playwright, Acceptance Validation |
| Segurança | Threat Modeling, OWASP Review, LGPD, Secrets |
| DevOps | CI/CD, Deployment Plan, Rollback Plan, Healthcheck |
| Dados | Data Mapping, Sync Strategy, Data Quality |
| UX/UI | UX Flow, Wireframes, UI Spec |

## 14.3. Contrato mínimo de uma skill

Toda skill deve declarar:

```txt
Nome
Propósito
Quando usar
Agentes autorizados
Entradas
Saídas
Procedimento
Quality Gate
Failure Modes
RAG permitido
Conformidade arquitetural
Exemplos bons
Exemplos ruins
```

---

# 15. Artefatos obrigatórios

## 15.1. Fluxo de artefatos operacionais

```txt
User Request
  ↓
PRD.md
  ↓
Architecture.md + API_Contract.json + DB_Schema.sql
  ↓
Execution_Plan.json
  ↓
Backend/Frontend Code
  ↓
QA_Report.md
  ↓
Security_Audit.md
  ↓
Deployment_Plan.md + Rollback_Plan.md
  ↓
Post_Deploy_Report.md
```

## 15.2. Artefatos e responsáveis

| Artefato | Responsável |
|---|---|
| `PRD.md` | Product Owner |
| `Architecture.md` | Software Architect |
| `API_Contract.json` | Software Architect |
| `DB_Schema.sql` / Prisma proposal | Software Architect |
| `Execution_Plan.json` | Software Engineer / Task Planner |
| Código Backend | Dev Backend |
| Código Frontend | Dev Frontend |
| `QA_Report.md` | QA |
| `Security_Audit.md` | DevSecOps |
| `Deployment_Plan.md` | DevOps |
| `Rollback_Plan.md` | DevOps |
| `Environment_Checklist.md` | DevOps |
| `Post_Deploy_Report.md` | DevOps |
| `State_Ledger.json` | Tech Lead |
| `ADR-*.md` | Tech Lead + Arquiteto |

---

# 16. State Ledger

O State Ledger é o registro vivo do projeto durante a operação da fábrica.

## 16.1. Schema

```json
{
  "project_name": "string",
  "project_id": "string",
  "current_phase": "requirements | architecture | planning | implementation | qa | security | deploy | maintenance",
  "current_agent": "Agent 00",
  "next_agent": "Agent 01",
  "approved_artifacts": {
    "prd": false,
    "architecture": false,
    "api_contract": false,
    "db_schema": false,
    "execution_plan": false,
    "qa": false,
    "security": false,
    "deployment": false,
    "rollback": false,
    "post_deploy": false
  },
  "open_questions": [],
  "decisions": [],
  "adrs": [],
  "risks": [],
  "blocked_tasks": [],
  "human_approvals_required": [],
  "next_action": "string"
}
```

---

# 17. Handoff Package

Todo agente deve entregar um Handoff Package.

```md
## Handoff Package

### Artifact Produced
Nome do artefato produzido.

### Summary
Resumo objetivo.

### Assumptions
Premissas assumidas.

### Open Questions
Dúvidas pendentes.

### Risks
Riscos identificados.

### Required Next Agent
Agente que deve assumir agora.

### Validation Checklist
- [ ] Item 1
- [ ] Item 2
- [ ] Item 3
```

Sem Handoff Package, a entrega é incompleta.

---

# 18. Quality Gates

## Gate 1 — PRD Approval

```txt
APPROVED
NEEDS_MORE_REQUIREMENTS
REJECTED_OUT_OF_SCOPE
```

## Gate 2 — Architecture Approval

```txt
APPROVED
APPROVED_WITH_ADR
NEEDS_REVISION
REJECTED_RISK_TOO_HIGH
```

## Gate 3 — Execution Plan Approval

```txt
APPROVED
NEEDS_TASK_SPLIT
NEEDS_DEPENDENCY_FIX
```

## Gate 4 — QA Review

```txt
PASS
FAIL_FIX_REQUIRED
FAIL_BLOCKING
```

## Gate 5 — Security Review

```txt
APPROVED
APPROVED_WITH_WARNINGS
BLOCKED_SECURITY_RISK
BLOCKED_LGPD_RISK
```

## Gate 6 — Deployment Approval

```txt
READY_FOR_DEPLOY
NEEDS_ENV_FIX
NEEDS_ROLLBACK_PLAN
BLOCKED_PRODUCTION_APPROVAL_REQUIRED
```

## Gate 7 — Post-Deploy Validation

```txt
DEPLOY_HEALTHY
DEPLOY_DEGRADED
ROLLBACK_REQUIRED
INCIDENT_OPENED
```

---

# 19. Matriz de autoridade

| Decisão | Quem propõe | Quem aprova | Aprovação humana |
|---|---|---|---|
| Ajuste pequeno de código | Dev Backend/Frontend | Tech Lead | Não |
| Alteração de escopo | Product Owner | Usuário + Tech Lead | Sim |
| Mudança arquitetural | Arquiteto | Tech Lead | Depende do impacto |
| Exceção ao Golden Path | Arquiteto/Tech Lead | Tech Lead + Humano | Sim |
| Nova dependência | Dev/Arquiteto | Tech Lead | Sim se crítica |
| Alteração de banco | Arquiteto/Backend | Tech Lead + DevOps | Sim em produção |
| Migration destrutiva | Arquiteto/DevOps | Humano | Sim |
| Deploy em produção | DevOps | Humano/Tech Lead | Sim |
| Rollback em produção | DevOps | Humano/Tech Lead | Sim |
| Aceitar risco de segurança | DevSecOps não aceita sozinho | Humano | Sim |
| Bloquear por segurança | DevSecOps | DevSecOps | Não |
| Bloquear por QA | QA | QA | Não |
| Incidente crítico | DevOps/Tech Lead | Humano informado | Sim |

---

# 20. Tech Lead Council

O Council é um mecanismo de stress-test para decisões críticas.

## 20.1. Quando usar

- aprovação de PRD;
- aprovação de arquitetura;
- mudança estrutural;
- mudança de banco;
- migration destrutiva;
- risco de segurança;
- go-live;
- incidente crítico;
- decisão de exceção ao Golden Path.

## 20.2. Personas

| Persona | Foco |
|---|---|
| Contrarian | risco, segurança, custo oculto |
| First Principles Thinker | problema real, simplicidade, YAGNI |
| Expansionist | escalabilidade e evolução |
| Outsider | manutenibilidade e DX |
| Executor | pragmatismo e entrega |

---

# 21. Checklist de completude da fábrica

## Build

- [ ] `00-contexto` existe.
- [ ] `01-bibliografia` existe.
- [ ] Pastas raiz dos agentes existem.
- [ ] Manual foi lido no build.
- [ ] Reference Architecture foi lida no build.
- [ ] Integrantes foram lidos no build.
- [ ] Base teórica foi lida no build.
- [ ] Bibliografia foi inventariada.
- [ ] Context views foram geradas.
- [ ] RAG manifests foram gerados.
- [ ] Skills manifests foram gerados.
- [ ] Prompts foram gerados.
- [ ] Artefatos foram salvos nas pastas locais dos agentes.

## Runtime

- [ ] Agentes não consultam `00-contexto`.
- [ ] Agentes não consultam `01-bibliografia` diretamente.
- [ ] Agentes não consultam este manual.
- [ ] Agentes consultam apenas sua pasta local.
- [ ] Cada agente possui `prompt.md`.
- [ ] Cada agente possui `context_view.md`.
- [ ] Cada agente possui `rag_manifest.json`.
- [ ] Cada agente possui `skills_manifest.md`.
- [ ] Cada agente possui `quality_gate.md`.
- [ ] Cada agente possui `handoff_schema.json`.
- [ ] Cada agente possui `failure_modes.md`.

## Engenharia

- [ ] Golden Model foi compilado em context views locais.
- [ ] Segurança integrada.
- [ ] QA com veto.
- [ ] DevSecOps com veto.
- [ ] DevOps com rollback.
- [ ] Deploy de produção exige humano.
- [ ] Migration destrutiva exige humano.
- [ ] Healthcheck e post-deploy definidos.

---

# 22. Diferenças desta versão em relação ao manual anterior

Esta versão incorpora a premissa fundamental de que o manual é **build-time only**.

Mudanças principais:

1. Define explicitamente que o manual não será consultado pelos agentes em runtime.
2. Define que os agentes consultam apenas artefatos locais gerados em suas pastas.
3. Adiciona o **Pipeline de Construção — Build Pipeline**.
4. Formaliza a ordem: varredura → `00-contexto` → `01-bibliografia` → pastas dos agentes.
5. Reclassifica `00-contexto` como fonte de build, não runtime.
6. Reclassifica `01-bibliografia` como corpus bruto de build, não runtime.
7. Define os artefatos mínimos que cada pasta de agente deve conter.
8. Separa hierarquia de conhecimento em build-time e runtime.
9. Adiciona checklist específico de build e runtime.
10. Remove a ideia de que prompts dos agentes consultam este manual diretamente em operação.

---

# 23. Síntese final

Este documento é o manual de arquitetura da fábrica de agentes, mas apenas para a fase de construção.

Ele define as peças que o Claude Code deve construir:

- agentes;
- context views;
- prompts;
- skills;
- RAG manifests;
- schemas;
- templates;
- checklists;
- gates;
- handoff;
- state ledger;
- governança.

A AI Software Factory deve ser construída a partir desta separação:

```txt
00-contexto
  ↓
Manual de Arquitetura e Componentes
  ↓
Reference Architecture
  ↓
01-bibliografia
  ↓
Claude Code Build Pipeline
  ↓
Pastas locais dos agentes
  ↓
Runtime isolado por agente
```

A regra central é:

```txt
O manual guia o build.
A arquitetura define o trilho técnico.
A bibliografia alimenta o RAG.
O Claude Code compila os agentes.
Os agentes executam apenas com seus artefatos locais.
```
