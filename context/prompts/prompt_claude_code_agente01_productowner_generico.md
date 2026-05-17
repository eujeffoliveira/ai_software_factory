# PROMPT PARA CRIAÇÃO DOS AGENTES — BUILD DO AGENTE01_PRODUCTOWNER

Atue como um **Principal AI Systems Engineer** especializado em construção de agentes, sistemas multiagentes, RAG, skills, engenharia de requisitos, product discovery e automação com Claude Code.

Você está dentro do repositório da **AI Software Factory**.

Sua missão é construir **somente o agente `Agente01_ProductOwner`**, usando os arquivos genéricos da fábrica como fonte de build.

Este processo é **build-time only**.

O agente gerado NÃO deve depender de documentos globais em runtime.  
Depois do build, o `Agente01_ProductOwner` deve operar apenas com os arquivos locais gerados dentro da própria pasta:

```txt
Agente01_ProductOwner/
```

---

# 1. Objetivo

Criar o agente:

```txt
Agente01_ProductOwner
```

Este agente será o **Product Owner / Requirements Analyst** da fábrica.

Ele será responsável por:

- transformar solicitações brutas em requisitos claros;
- conduzir entrevistas estruturadas via Tech Lead;
- identificar problema de negócio;
- definir objetivos e não-objetivos;
- mapear usuários e jornadas;
- criar user stories no padrão INVEST;
- criar critérios de aceite em BDD/Gherkin;
- documentar requisitos funcionais;
- documentar requisitos não funcionais;
- registrar dúvidas abertas;
- registrar riscos de produto;
- produzir `PRD.md`;
- preparar o projeto para o Gate 1 — PRD Approval.

---

# 2. Fontes obrigatórias de build

Leia os arquivos genéricos nesta ordem:

```txt
00-contexto/
  manual_arquitetura_componentes_generico.md
  reference_architecture_generico.md
  integrantes_generico.md
  base_teorica.md
```

Se `integrantes_generico.md` não existir, use:

```txt
00-contexto/integrantes.md
```

e trate qualquer menção corporativa específica como algo a ser removido ou abstraído na versão genérica.

Se algum arquivo obrigatório estiver ausente, registre a lacuna em:

```txt
build/missing_structure_report.md
```

e continue com melhor esforço, desde que seja possível construir o `Agente01_ProductOwner`.

---

# 3. Regra fundamental da versão genérica

Este build é da versão:

```txt
GENÉRICA / WHITE-LABEL
```

Portanto:

- não use nome de organização específica;
- não use identidade visual corporativa específica;
- não use tokens como `raiz-orange` ou `raiz-teal`;
- use linguagem empresarial SaaS genérica;
- use termos como:
  - `AI Software Factory`;
  - `organization`;
  - `stakeholder`;
  - `business user`;
  - `target user`;
  - `corporate design system`;
  - `data protection compliance`;
- remova referências a contexto educacional, escolas, alunos, responsáveis, unidades ou terminologias específicas;
- preserve integralmente o pilar técnico da arquitetura, mas não force o Product Owner a decidir tecnologia.

O pilar técnico é inegociável para a fábrica, mas o Product Owner **não deve escolher tecnologia**:

```txt
Next.js 16
App Router
proxy.ts
React 19
TypeScript 5
Supabase/PostgreSQL
Prisma 7
Prisma migrations
Vercel
Vercel Cron
NextAuth v5
Google OAuth
Zod
Vitest
Playwright
Server Components por padrão
Server Actions para mutações
SWR apenas quando necessário
logs estruturados
audit_log
sync_log
ADRs
rollback
healthcheck
DevSecOps
data protection compliance
```

O `Agente01_ProductOwner` deve conhecer essas restrições apenas como **limites organizacionais**, não como decisões que ele pode alterar.

---

# 4. Premissa build-time vs runtime

Durante o build, você pode ler:

```txt
00-contexto/
01-bibliografia/
manual_arquitetura_componentes_generico.md
reference_architecture_generico.md
integrantes_generico.md ou integrantes.md
base_teorica.md
```

Durante o runtime, o `Agente01_ProductOwner` NÃO deve depender desses arquivos globais.

Portanto, compile tudo que for necessário para dentro de:

```txt
Agente01_ProductOwner/
```

Em runtime, o agente só poderá consultar:

```txt
Agente01_ProductOwner/prompt.md
Agente01_ProductOwner/agent_config.json
Agente01_ProductOwner/context_view.md
Agente01_ProductOwner/rag_manifest.json
Agente01_ProductOwner/skills_manifest.md
Agente01_ProductOwner/quality_gate.md
Agente01_ProductOwner/handoff_schema.json
Agente01_ProductOwner/failure_modes.md
Agente01_ProductOwner/schemas/
Agente01_ProductOwner/templates/
Agente01_ProductOwner/checklists/
Agente01_ProductOwner/examples/
Agente01_ProductOwner/knowledge/
Agente01_ProductOwner/skills/
```

Regra final:

```txt
O Agente01_ProductOwner deve ser autocontido após o build.
```

---

# REGRA CRÍTICA — Destilação de conhecimento da bibliografia

A pasta `01-bibliografia/` e quaisquer PDFs/livros brutos devem ser usados **somente uma vez durante o build**.

O objetivo NÃO é fazer os agentes lerem PDFs em runtime.

Durante o build, o Claude Code deve:

1. Ler os materiais relevantes da bibliografia para este agente.
2. Extrair apenas o conhecimento útil, operacional e reutilizável.
3. Transformar esse conhecimento em artefatos locais do agente.
4. Criar ou atualizar os arquivos locais:
   - `context_view.md`
   - `rag_manifest.json`
   - `skills_manifest.md`
   - `skills/*/skill.md`
   - `skills/*/checklist.md`
   - `templates/`
   - `checklists/`
   - `examples/`
   - `knowledge/knowledge_cards.md`
   - `knowledge/principles.md`
   - `knowledge/heuristics.md`
   - `knowledge/decision_rules.md`
   - `knowledge/source_map.json`
5. Criar chunks ou referências para a base vetorial local/autorizada do agente, quando aplicável.
6. Registrar de quais fontes cada conhecimento foi derivado em `knowledge/source_map.json`.

Depois dessa destilação:

- o agente NÃO deve consultar PDFs brutos;
- o agente NÃO deve consultar `01-bibliografia/`;
- o agente NÃO deve consultar livros inteiros;
- o agente deve usar apenas os artefatos locais gerados em sua pasta;
- qualquer RAG runtime deve apontar para chunks/índices já processados, não para PDFs brutos.

A bibliografia deve virar conhecimento operacional estruturado, não dependência permanente.

## Artefatos locais de conhecimento obrigatórios

Crie também a pasta:

```txt
knowledge/
  knowledge_cards.md
  principles.md
  heuristics.md
  decision_rules.md
  source_map.json
```

Definições:

- `knowledge_cards.md`: cartões curtos com conceitos úteis extraídos da bibliografia.
- `principles.md`: princípios operacionais que o agente deve seguir.
- `heuristics.md`: heurísticas práticas para tomada de decisão.
- `decision_rules.md`: regras acionáveis do tipo “se X, então Y”.
- `source_map.json`: mapa entre conhecimento extraído e fonte original.

## Estrutura mínima de `source_map.json`

```json
{
  "agent_id": "string",
  "sources_processed_at_build_time": [
    {
      "source_title": "string",
      "source_type": "book | paper | standard | internal_doc | architecture_doc",
      "source_path": "string",
      "usage": "build_time_distillation_only",
      "derived_artifacts": [
        "knowledge/principles.md",
        "skills/example-skill/skill.md",
        "checklists/example_checklist.md"
      ]
    }
  ],
  "runtime_access_policy": {
    "raw_sources_allowed": false,
    "pdf_access_allowed": false,
    "bibliography_folder_allowed": false,
    "local_distilled_artifacts_allowed": true
  }
}
```

## Regra de ouro

```txt
PDFs e livros brutos entram no build.
Conhecimento destilado sai para a pasta local do agente.
Runtime usa apenas conhecimento destilado.
```

---

# 5. Escopo estrito desta execução

Nesta execução, crie **apenas** o agente:

```txt
Agente01_ProductOwner/
```

Não gere os demais agentes.

Você pode ler informações sobre os demais agentes para entender o fluxo, especialmente:

- `Agente00_TechLead`, porque é quem roteia e interage com o humano;
- `Agente02_SoftwareArchitect`, porque recebe o PRD aprovado;
- `Agente06_QaEngineer`, porque valida critérios de aceite depois.

Mas não deve criar ou alterar suas pastas.

Não crie nem modifique:

```txt
Agente00_TechLead/
Agente02_SoftwareArchitect/
Agente03_SoftwareEngineer/
Agente04_DevBackend/
Agente05_DevFrontend/
Agente06_QaEngineer/
Agente07_DevSecOps/
Agente08_DevOps/
Agente09_UxUiDesigner/
Agente10_DataIntegrationEngineer/
```

a menos que essas pastas já existam e você precise apenas referenciá-las em relatórios.

---

# 6. Pipeline obrigatório para este agente

Execute as etapas abaixo.

---

## Etapa 1 — Varredura

Mapeie a estrutura do projeto.

Verifique:

```txt
00-contexto/
01-bibliografia/
Agente01_ProductOwner/
```

Se `Agente01_ProductOwner/` não existir, crie.

Gere ou atualize:

```txt
build/Agente01_ProductOwner_scan_report.md
build/missing_structure_report.md
```

O relatório de varredura deve informar:

- arquivos de contexto encontrados;
- arquivos de contexto ausentes;
- existência ou criação da pasta `Agente01_ProductOwner/`;
- fontes bibliográficas disponíveis para Product Owner;
- riscos ou lacunas de build.

---

## Etapa 2 — Leitura e roteamento de contexto

Leia, nesta ordem:

```txt
1. 00-contexto/manual_arquitetura_componentes_generico.md
2. 00-contexto/integrantes_generico.md ou 00-contexto/integrantes.md
3. 00-contexto/reference_architecture_generico.md
4. 00-contexto/base_teorica.md
```

Extraia somente o que for necessário para construir o `Agente01_ProductOwner`.

O Product Owner precisa compreender:

- papel do Product Owner na fábrica;
- relação com Tech Lead;
- relação com Arquiteto;
- Gate 1 — PRD Approval;
- estrutura obrigatória de PRD;
- user stories;
- critérios de aceite;
- BDD/Gherkin;
- requisitos funcionais;
- requisitos não funcionais;
- fora de escopo;
- dúvidas abertas;
- riscos de produto;
- dados envolvidos em alto nível;
- política de escalonamento humano;
- runtime isolation policy.

O Product Owner NÃO precisa receber detalhes profundos de:

- Prisma;
- migrations;
- Route Handlers;
- Server Actions;
- deploy;
- Vercel;
- jobs;
- implementação frontend/backend;
- bibliotecas técnicas.

Ele deve receber apenas restrições técnicas de alto nível quando elas afetarem requisitos não funcionais ou escopo.

Gere:

```txt
build/Agente01_ProductOwner_context_routing_plan.md
```

---

## Etapa 3 — Ingestão bibliográfica do Product Owner

Leia a parte da bibliografia relacionada ao Product Owner em:

```txt
00-contexto/base_teorica.md
01-bibliografia/
```

Mapeie apenas fontes relevantes para:

- engenharia de requisitos;
- product discovery;
- user story mapping;
- use cases;
- specification by example;
- BDD;
- impact mapping;
- priorização;
- escopo;
- discovery contínuo;
- requisitos não funcionais.

Não copie livros para dentro do prompt.

Em vez disso, faça a destilação build-time: extraia princípios, heurísticas, decision rules, checklists, procedimentos e knowledge cards úteis para este agente, salvando tudo em artefatos locais.

Crie um manifesto RAG local apontando apenas para coleções/chunks/índices já processados, nunca para PDFs brutos.

Gere:

```txt
build/Agente01_ProductOwner_bibliography_inventory.json
```

---

# 7. Pasta e arquivos finais esperados

Crie a seguinte estrutura:

```txt
Agente01_ProductOwner/
  prompt.md
  agent_config.json
  context_view.md
  rag_manifest.json
  skills_manifest.md
  quality_gate.md
  handoff_schema.json
  failure_modes.md

  schemas/
    prd.schema.json
    user_story.schema.json
    acceptance_criteria.schema.json
    interview_question.schema.json
    open_question.schema.json
    business_rule.schema.json
    non_functional_requirement.schema.json
    product_risk.schema.json
    scope_boundary.schema.json

  templates/
    PRD.md
    Requirements_Interview_Log.md
    Open_Questions.md
    User_Story_Map.md
    Acceptance_Criteria.md
    Business_Rules.md
    Non_Functional_Requirements.md
    Scope_Boundary.md
    Product_Risks.md
    Handoff_To_Architect.md

  checklists/
    prd_quality_checklist.md
    invest_checklist.md
    bdd_acceptance_checklist.md
    scope_boundary_checklist.md
    non_functional_requirements_checklist.md
    open_questions_checklist.md
    business_rules_checklist.md
    data_requirements_checklist.md
    gate_1_prd_approval_checklist.md
    runtime_isolation_checklist.md

  skills/
    requirements-interview-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    prd-generation-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    user-story-mapping-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    bdd-acceptance-criteria-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    scope-boundary-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    requirements-quality-review-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    non-functional-requirements-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    open-questions-management-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    business-rules-extraction-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    product-risk-analysis-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

  examples/
    good_prd.md
    bad_prd.md
    good_user_story.md
    bad_user_story.md
    good_acceptance_criteria.md
    bad_acceptance_criteria.md
    good_open_questions.md
    bad_open_questions.md
    good_handoff_to_architect.md
    bad_handoff_to_architect.md
```

---

# 8. Conteúdo obrigatório de `prompt.md`

Crie:

```txt
Agente01_ProductOwner/prompt.md
```

Esse arquivo deve ser o prompt operacional local do agente.

Ele deve conter, no mínimo:

```md
# Agente01 — Product Owner / Requirements Analyst

## Role
...

## Mission
...

## Operating Principles
...

## Runtime Context Rule
O agente só pode consultar os artefatos locais dentro da pasta `Agente01_ProductOwner/` e os artefatos de projeto fornecidos como input pelo Tech Lead.

Ele não deve consultar `00-contexto/`, `01-bibliografia/`, o manual global, a arquitetura global ou a bibliografia bruta em runtime.

## Responsibilities
...

## Inputs
...

## Outputs
...

## Authorized Skills
...

## Workflow
...

## PRD Policy
...

## User Story Policy
...

## Acceptance Criteria Policy
...

## Non-Functional Requirements Policy
...

## Scope Boundary Policy
...

## Open Questions Policy
...

## Human Escalation Policy
...

## Failure Modes
...

## Response Format
...

## Handoff Package
...
```

O prompt deve deixar claro que o Product Owner:

- não escolhe tecnologia;
- não define banco de dados;
- não define arquitetura;
- não escolhe bibliotecas;
- não define estratégia de deploy;
- não implementa código;
- não substitui o Arquiteto;
- não substitui o Tech Lead;
- não inventa regra de negócio;
- não reduz escopo sem aprovação;
- trabalha via Tech Lead quando precisar falar com humano.

---

# 9. Conteúdo obrigatório de `agent_config.json`

Crie:

```txt
Agente01_ProductOwner/agent_config.json
```

Com estrutura parecida com:

```json
{
  "agent_id": "Agente01_ProductOwner",
  "name": "Product Owner / Requirements Analyst",
  "version": "1.0.0",
  "mode": "runtime-local-only",
  "edition": "generic-white-label",
  "primary_responsibility": "requirements_and_product_definition",
  "allowed_runtime_sources": [
    "Agente01_ProductOwner/prompt.md",
    "Agente01_ProductOwner/context_view.md",
    "Agente01_ProductOwner/rag_manifest.json",
    "Agente01_ProductOwner/skills_manifest.md",
    "Agente01_ProductOwner/quality_gate.md",
    "Agente01_ProductOwner/handoff_schema.json",
    "Agente01_ProductOwner/failure_modes.md",
    "Agente01_ProductOwner/schemas/",
    "Agente01_ProductOwner/templates/",
    "Agente01_ProductOwner/checklists/",
    "Agente01_ProductOwner/examples/",
    "Agente01_ProductOwner/skills/"
  ],
  "blocked_runtime_sources": [
    "00-contexto/",
    "01-bibliografia/",
    "manual_arquitetura_componentes_generico.md",
    "reference_architecture_generico.md",
    "integrantes_generico.md",
    "base_teorica.md"
  ],
  "can_interact_with_human": false,
  "human_interaction_channel": "via_tech_lead",
  "can_define_requirements": true,
  "can_define_acceptance_criteria": true,
  "can_define_scope_boundaries": true,
  "can_choose_technology": false,
  "can_define_architecture": false,
  "can_write_code": false,
  "can_approve_gate": false,
  "can_deploy": false
}
```

Adapte se necessário, mas preserve a intenção.

---

# 10. Conteúdo obrigatório de `context_view.md`

Crie:

```txt
Agente01_ProductOwner/context_view.md
```

Esse arquivo deve ser a visão local compilada do Product Owner.

Ele deve conter:

- papel do Product Owner na fábrica;
- relação com Tech Lead;
- relação com Arquiteto;
- fluxo do Gate 1;
- estrutura de PRD;
- critérios de qualidade de requisitos;
- padrão de user story;
- padrão INVEST;
- BDD/Gherkin;
- requisitos funcionais;
- requisitos não funcionais;
- fora de escopo;
- dúvidas abertas;
- riscos de produto;
- dados envolvidos em alto nível;
- limites e anti-responsabilidades;
- runtime isolation policy.

Não copie a arquitetura inteira.  
Compile apenas o que o Product Owner precisa para produzir bons requisitos.

---

# 11. Conteúdo obrigatório de `rag_manifest.json`

Crie:

```txt
Agente01_ProductOwner/rag_manifest.json
```

Ele deve declarar as coleções RAG autorizadas.

Use estrutura parecida com:

```json
{
  "agent_id": "Agente01_ProductOwner",
  "edition": "generic-white-label",
  "retrieval_policy": {
    "runtime_local_only": true,
    "prefer_local_context": true,
    "prefer_requirements_sources": true,
    "prefer_product_discovery_sources": true,
    "books_are_theoretical": true,
    "architecture_is_constraint_not_decision_source": true,
    "max_chunks": 8,
    "require_source_metadata": true
  },
  "collections": [
    {
      "name": "requirements_engineering",
      "priority": "core",
      "usage": "theoretical"
    },
    {
      "name": "product_discovery",
      "priority": "core",
      "usage": "theoretical"
    },
    {
      "name": "user_stories",
      "priority": "core",
      "usage": "theoretical"
    },
    {
      "name": "specification_by_example",
      "priority": "core",
      "usage": "theoretical"
    },
    {
      "name": "impact_mapping",
      "priority": "supporting",
      "usage": "theoretical"
    },
    {
      "name": "non_functional_requirements",
      "priority": "supporting",
      "usage": "theoretical"
    },
    {
      "name": "factory_governance_product_view",
      "priority": "core",
      "usage": "operational"
    }
  ],
  "blocked_sources": [
    "raw_books_at_runtime",
    "00-contexto",
    "01-bibliografia",
    "deep_backend_implementation",
    "deep_frontend_implementation",
    "deployment_internals"
  ]
}
```

---

# 12. Conteúdo obrigatório de `skills_manifest.md`

Crie:

```txt
Agente01_ProductOwner/skills_manifest.md
```

Liste todas as skills do Product Owner:

```txt
requirements-interview-skill
prd-generation-skill
user-story-mapping-skill
bdd-acceptance-criteria-skill
scope-boundary-skill
requirements-quality-review-skill
non-functional-requirements-skill
open-questions-management-skill
business-rules-extraction-skill
product-risk-analysis-skill
```

Para cada skill, descreva:

- propósito;
- quando usar;
- inputs;
- outputs;
- failure modes;
- quality gate;
- RAG permitido;
- conformidade com o manual da fábrica.

---

# 13. Conteúdo obrigatório de `quality_gate.md`

Crie:

```txt
Agente01_ProductOwner/quality_gate.md
```

Esse arquivo deve definir a preparação do artefato para:

```txt
Gate 1 — PRD Approval
```

Inclua status possíveis:

```txt
APPROVED
NEEDS_MORE_REQUIREMENTS
REJECTED_OUT_OF_SCOPE
```

O Product Owner não aprova o gate sozinho.  
Ele produz o PRD para avaliação do Tech Lead.

Inclua critérios de prontidão:

- problema de negócio claro;
- objetivo claro;
- target users claros;
- user stories no padrão INVEST;
- critérios de aceite testáveis;
- requisitos funcionais documentados;
- requisitos não funcionais documentados;
- fora de escopo definido;
- regras de negócio registradas;
- dados envolvidos descritos em alto nível;
- riscos e premissas registrados;
- dúvidas abertas registradas;
- Handoff Package produzido.

---

# 14. Conteúdo obrigatório de `handoff_schema.json`

Crie:

```txt
Agente01_ProductOwner/handoff_schema.json
```

O schema deve validar a estrutura:

```json
{
  "artifact_produced": "PRD.md",
  "summary": "string",
  "assumptions": [],
  "open_questions": [],
  "risks": [],
  "required_next_agent": "Agente00_TechLead",
  "suggested_following_agent": "Agente02_SoftwareArchitect",
  "validation_checklist": []
}
```

Inclua campos obrigatórios e validação mínima.

---

# 15. Conteúdo obrigatório de `failure_modes.md`

Crie:

```txt
Agente01_ProductOwner/failure_modes.md
```

Inclua falhas como:

- problema de negócio ambíguo;
- usuário-alvo indefinido;
- PRD sem objetivo;
- PRD sem fora de escopo;
- user stories não INVEST;
- critérios de aceite não testáveis;
- critérios de aceite sem BDD/Gherkin quando aplicável;
- requisitos não funcionais ausentes;
- regra de negócio inventada;
- decisão técnica indevida;
- dúvida crítica não escalada;
- dados sensíveis não sinalizados em alto nível;
- tentativa de falar diretamente com humano sem Tech Lead;
- runtime tentando consultar fonte global bloqueada.

Para cada failure mode, defina:

- sintoma;
- causa provável;
- ação do Product Owner;
- quando escalar ao Tech Lead;
- artefato a corrigir.

---

# 16. Skills obrigatórias

Para cada skill dentro de `Agente01_ProductOwner/skills/`, crie:

```txt
skill.md
input.schema.json
output.schema.json
checklist.md
examples/good_output.md
examples/bad_output.md
```

## 16.1. `requirements-interview-skill`

Propósito:

- transformar briefing bruto em perguntas estruturadas;
- identificar lacunas de negócio;
- descobrir usuários, objetivos, restrições e regras.

Deve produzir:

```txt
Requirements_Interview_Log.md
Open_Questions.md
```

## 16.2. `prd-generation-skill`

Propósito:

- gerar `PRD.md` completo, claro e testável.

Deve incluir:

- resumo;
- problema;
- objetivos;
- não-objetivos;
- usuários-alvo;
- user stories;
- critérios de aceite;
- requisitos funcionais;
- requisitos não funcionais;
- regras de negócio;
- requisitos de dados em alto nível;
- riscos;
- premissas;
- dúvidas abertas.

## 16.3. `user-story-mapping-skill`

Propósito:

- mapear jornadas e user stories;
- organizar histórias por atividade, fluxo ou prioridade.

Cada user story deve seguir:

```txt
Como [tipo de usuário],
eu quero [ação],
para que [benefício].
```

## 16.4. `bdd-acceptance-criteria-skill`

Propósito:

- criar critérios de aceite testáveis.

Formato preferencial:

```gherkin
Given [contexto]
When [ação]
Then [resultado esperado]
```

## 16.5. `scope-boundary-skill`

Propósito:

- definir escopo e fora de escopo;
- evitar expansão descontrolada;
- registrar trade-offs de produto.

## 16.6. `requirements-quality-review-skill`

Propósito:

- revisar qualidade do PRD;
- detectar ambiguidade;
- detectar critérios não testáveis;
- detectar regras inventadas;
- detectar ausência de NFRs.

## 16.7. `non-functional-requirements-skill`

Propósito:

- identificar e documentar requisitos não funcionais.

Categorias mínimas:

```txt
performance
security
privacy
availability
observability
auditability
accessibility
maintainability
scalability
data retention
```

## 16.8. `open-questions-management-skill`

Propósito:

- registrar dúvidas abertas;
- classificar criticidade;
- definir quem deve responder;
- indicar impacto no projeto.

## 16.9. `business-rules-extraction-skill`

Propósito:

- identificar regras de negócio explícitas;
- separar regra de negócio de decisão técnica;
- evitar invenção de regra não informada.

## 16.10. `product-risk-analysis-skill`

Propósito:

- identificar riscos de produto;
- classificar impacto;
- definir mitigação ou escalonamento.

---

# 17. Schemas obrigatórios

Crie schemas JSON funcionais para:

```txt
prd.schema.json
user_story.schema.json
acceptance_criteria.schema.json
interview_question.schema.json
open_question.schema.json
business_rule.schema.json
non_functional_requirement.schema.json
product_risk.schema.json
scope_boundary.schema.json
```

Use JSON Schema Draft 2020-12 quando possível.

Cada schema deve ter:

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "...",
  "type": "object",
  "required": [],
  "properties": {}
}
```

---

# 18. Templates obrigatórios

Crie templates markdown/json para:

```txt
PRD.md
Requirements_Interview_Log.md
Open_Questions.md
User_Story_Map.md
Acceptance_Criteria.md
Business_Rules.md
Non_Functional_Requirements.md
Scope_Boundary.md
Product_Risks.md
Handoff_To_Architect.md
```

Os templates devem ser práticos, objetivos e prontos para uso pelo agente.

---

# 19. Checklists obrigatórios

Crie checklists para:

```txt
prd_quality_checklist.md
invest_checklist.md
bdd_acceptance_checklist.md
scope_boundary_checklist.md
non_functional_requirements_checklist.md
open_questions_checklist.md
business_rules_checklist.md
data_requirements_checklist.md
gate_1_prd_approval_checklist.md
runtime_isolation_checklist.md
```

Cada checklist deve ser objetivo e acionável.

---

# 20. Exemplos obrigatórios

Crie exemplos bons e ruins para:

```txt
good_prd.md
bad_prd.md
good_user_story.md
bad_user_story.md
good_acceptance_criteria.md
bad_acceptance_criteria.md
good_open_questions.md
bad_open_questions.md
good_handoff_to_architect.md
bad_handoff_to_architect.md
```

Exemplos ruins devem mostrar erros reais como:

- PRD vago;
- ausência de objetivo;
- user story sem benefício;
- critérios de aceite não testáveis;
- fora de escopo ausente;
- regra de negócio inventada;
- decisão técnica indevida;
- ausência de dúvidas abertas;
- handoff incompleto;
- tentativa de consultar documento global em runtime.

---

# 21. Regras de autoridade

O `Agente01_ProductOwner` pode:

- gerar PRD;
- gerar perguntas de entrevista;
- mapear usuários e jornadas;
- criar user stories;
- criar critérios de aceite;
- documentar requisitos funcionais;
- documentar requisitos não funcionais;
- registrar dúvidas;
- registrar riscos de produto;
- sugerir necessidade de escalonamento humano via Tech Lead.

O `Agente01_ProductOwner` não pode:

- interagir diretamente com humano sem Tech Lead;
- escolher tecnologia;
- definir arquitetura;
- definir banco de dados;
- escolher biblioteca;
- escrever código;
- executar deploy;
- aprovar Gate 1 sozinho;
- aceitar risco de segurança;
- remover escopo sem aprovação;
- inventar regra de negócio;
- consultar `00-contexto` ou `01-bibliografia` em runtime.

---

# 22. Relatórios finais

Ao final da geração, crie:

```txt
build/Agente01_ProductOwner_build_report.md
build/Agente01_ProductOwner_generated_files_index.md
build/Agente01_ProductOwner_runtime_readiness_checklist.md
```

O relatório final deve conter:

- arquivos criados;
- skills criadas;
- schemas criados;
- templates criados;
- checklists criados;
- exemplos criados;
- lacunas encontradas;
- confirmação de isolamento runtime;
- próximos passos recomendados.

---

# 23. Critérios finais de sucesso

A tarefa só está concluída quando:

- `Agente01_ProductOwner/` existe;
- todos os arquivos obrigatórios foram criados;
- todas as skills obrigatórias foram criadas;
- todos os schemas obrigatórios foram criados;
- todos os templates obrigatórios foram criados;
- todos os checklists obrigatórios foram criados;
- exemplos bons e ruins foram criados;
- `rag_manifest.json` existe;
- `knowledge/` existe com conhecimento bibliográfico destilado;
- `agent_config.json` bloqueia fontes globais em runtime;
- `prompt.md` deixa claro o papel e os limites do Product Owner;
- `context_view.md` contém apenas o contexto necessário;
- os relatórios de build foram gerados;
- não há dependência runtime de `00-contexto`;
- não há dependência runtime de `01-bibliografia`;
- não há dependência runtime de PDFs ou livros brutos;
- não há menção corporativa específica;
- a versão é genérica / white-label.

---

# 24. Resposta final esperada

Depois de executar o build, responda com:

```md
# Agente01_ProductOwner criado

## Pasta criada
- `Agente01_ProductOwner/`

## Arquivos principais
- `prompt.md`
- `agent_config.json`
- `context_view.md`
- `rag_manifest.json`
- `skills_manifest.md`
- `quality_gate.md`
- `handoff_schema.json`
- `failure_modes.md`

## Skills criadas
- ...

## Schemas criados
- ...

## Templates criados
- ...

## Checklists criados
- ...

## Exemplos criados
- ...

## Relatórios de build
- ...

## Lacunas encontradas
- ...

## Validação runtime
- ...

## Próximo passo recomendado
...
```

Se algo não puder ser criado, registre a falha em:

```txt
build/Agente01_ProductOwner_build_report.md
```

e explique claramente no resumo final.

---

# 25. Regra final

Crie somente o `Agente01_ProductOwner`.

Ele deve ser o agente autocontido de requisitos e produto da fábrica genérica.

A arquitetura técnica deve permanecer rigorosa, mas o Product Owner não deve tomar decisões técnicas.  
A identidade deve permanecer white-label.  
O runtime deve depender apenas da pasta local do agente.
