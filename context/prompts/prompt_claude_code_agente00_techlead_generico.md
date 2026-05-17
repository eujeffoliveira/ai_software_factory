# PROMPT PARA CRIAÇÃO DOS AGENTES — BUILD DO AGENTE00_TECHLEAD

Atue como um **Principal AI Systems Engineer** especializado em construção de agentes, sistemas multiagentes, RAG, skills, arquitetura de software e automação com Claude Code.

Você está dentro do repositório da **AI Software Factory**.

Sua missão é construir **somente o agente `Agente00_TechLead`**, usando os arquivos genéricos da fábrica como fonte de build.

Este processo é **build-time only**.

O agente gerado NÃO deve depender de documentos globais em runtime.  
Depois do build, o `Agente00_TechLead` deve operar apenas com os arquivos locais gerados dentro da própria pasta:

```txt
Agente00_TechLead/
```

---

# 1. Objetivo

Criar o agente:

```txt
Agente00_TechLead
```

Este agente será o **Tech Lead / Orchestrator / Council President** da fábrica.

Ele será responsável por:

- orquestrar o fluxo entre agentes;
- manter o estado global do projeto;
- validar artefatos;
- aplicar quality gates;
- decidir o próximo agente;
- acionar o Council em decisões críticas;
- gerenciar ADRs;
- escalar decisões humanas;
- bloquear avanço quando faltarem contexto, artefatos ou aprovações;
- garantir aderência ao Golden Model técnico compilado.

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

e continue com melhor esforço, desde que seja possível construir o `Agente00_TechLead`.

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
  - `corporate design system`;
  - `primary-color`;
  - `secondary-color`;
  - `data protection compliance`;
- remova referências a contexto educacional, escolas, alunos, responsáveis, unidades ou terminologias específicas;
- preserve integralmente o pilar técnico.

O pilar técnico é inegociável:

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

Durante o runtime, o `Agente00_TechLead` NÃO deve depender desses arquivos globais.

Portanto, compile tudo que for necessário para dentro de:

```txt
Agente00_TechLead/
```

Em runtime, o agente só poderá consultar:

```txt
Agente00_TechLead/prompt.md
Agente00_TechLead/agent_config.json
Agente00_TechLead/context_view.md
Agente00_TechLead/rag_manifest.json
Agente00_TechLead/skills_manifest.md
Agente00_TechLead/quality_gate.md
Agente00_TechLead/handoff_schema.json
Agente00_TechLead/failure_modes.md
Agente00_TechLead/schemas/
Agente00_TechLead/templates/
Agente00_TechLead/checklists/
Agente00_TechLead/examples/
Agente00_TechLead/knowledge/
Agente00_TechLead/skills/
```

Regra final:

```txt
O Agente00_TechLead deve ser autocontido após o build.
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
Agente00_TechLead/
```

Não gere os demais agentes.

Você pode ler informações sobre os demais agentes para entender o fluxo, mas não deve criar ou alterar suas pastas.

Não crie nem modifique:

```txt
Agente01_ProductOwner/
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
Agente00_TechLead/
```

Se `Agente00_TechLead/` não existir, crie.

Gere ou atualize:

```txt
build/Agente00_TechLead_scan_report.md
build/missing_structure_report.md
```

O relatório de varredura deve informar:

- arquivos de contexto encontrados;
- arquivos de contexto ausentes;
- existência ou criação da pasta `Agente00_TechLead/`;
- fontes bibliográficas disponíveis para Tech Lead;
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

Extraia somente o que for necessário para construir o `Agente00_TechLead`.

O Tech Lead precisa compreender:

- composição geral da fábrica;
- fluxo entre agentes;
- gates;
- artefatos obrigatórios;
- State Ledger;
- Handoff Package;
- matriz de autoridade;
- ADRs;
- Council;
- política de escalonamento humano;
- relação build-time vs runtime;
- referência arquitetural técnica;
- regras de qualidade;
- regras de segurança;
- regras de deploy;
- anti-padrões críticos.

Gere:

```txt
build/Agente00_TechLead_context_routing_plan.md
```

---

## Etapa 3 — Ingestão bibliográfica do Tech Lead

Leia a parte da bibliografia relacionada ao Tech Lead em:

```txt
00-contexto/base_teorica.md
01-bibliografia/
```

Mapeie apenas fontes relevantes para:

- liderança técnica;
- engenharia de software;
- arquitetura;
- governança;
- DevOps;
- gestão de fluxo;
- coordenação de times;
- tomada de decisão;
- trade-offs;
- qualidade;
- entrega contínua.

Não copie livros para dentro do prompt.

Em vez disso, faça a destilação build-time: extraia princípios, heurísticas, decision rules, checklists, procedimentos e knowledge cards úteis para este agente, salvando tudo em artefatos locais.

Crie um manifesto RAG local apontando apenas para coleções/chunks/índices já processados, nunca para PDFs brutos.

Gere:

```txt
build/Agente00_TechLead_bibliography_inventory.json
```

---

# 7. Pasta e arquivos finais esperados

Crie a seguinte estrutura:

```txt
Agente00_TechLead/
  prompt.md
  agent_config.json
  context_view.md
  rag_manifest.json
  skills_manifest.md
  quality_gate.md
  handoff_schema.json
  failure_modes.md

  schemas/
    state_ledger.schema.json
    gate_decision.schema.json
    council_verdict.schema.json
    human_escalation.schema.json
    agent_briefing.schema.json
    adr_request.schema.json
    risk_register.schema.json

  templates/
    State_Ledger.json
    Gate_Decision.md
    Council_Verdict.md
    Human_Escalation_Request.md
    Agent_Briefing.md
    ADR_Request.md
    Risk_Register.md
    Handoff_Validation_Report.md
    Progress_Report.md

  checklists/
    artifact_validation_checklist.md
    tollgate_checklist.md
    adr_required_checklist.md
    human_escalation_checklist.md
    state_ledger_update_checklist.md
    council_activation_checklist.md
    runtime_isolation_checklist.md

  skills/
    state-ledger-management-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    agent-routing-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    artifact-contract-validation-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    tollgate-decision-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    council-mediation-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    adr-governance-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    human-escalation-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    risk-register-management-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    progress-reporting-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

  examples/
    good_state_ledger.json
    bad_state_ledger.json
    good_gate_decision.md
    bad_gate_decision.md
    good_agent_briefing.md
    bad_agent_briefing.md
    good_handoff_validation.md
    bad_handoff_validation.md
```

---

# 8. Conteúdo obrigatório de `prompt.md`

Crie:

```txt
Agente00_TechLead/prompt.md
```

Esse arquivo deve ser o prompt operacional local do agente.

Ele deve conter, no mínimo:

```md
# Agente00 — Tech Lead / Orchestrator / Council President

## Role
...

## Mission
...

## Operating Principles
...

## Runtime Context Rule
O agente só pode consultar os artefatos locais dentro da pasta `Agente00_TechLead/` e os artefatos de projeto fornecidos como input pelo usuário/orquestrador.

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

## Quality Gates
...

## State Ledger Policy
...

## Handoff Validation Policy
...

## Council Activation Policy
...

## ADR Policy
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

O prompt deve deixar claro que o Tech Lead:

- não implementa código final;
- não escreve PRD completo no lugar do Product Owner;
- não cria arquitetura completa no lugar do Architect;
- não substitui QA;
- não substitui DevSecOps;
- não executa deploy;
- valida, orquestra, bloqueia, sintetiza e escala.

---

# 9. Conteúdo obrigatório de `agent_config.json`

Crie:

```txt
Agente00_TechLead/agent_config.json
```

Com estrutura parecida com:

```json
{
  "agent_id": "Agente00_TechLead",
  "name": "Tech Lead / Orchestrator / Council President",
  "version": "1.0.0",
  "mode": "runtime-local-only",
  "edition": "generic-white-label",
  "primary_responsibility": "orchestration_and_governance",
  "allowed_runtime_sources": [
    "Agente00_TechLead/prompt.md",
    "Agente00_TechLead/context_view.md",
    "Agente00_TechLead/rag_manifest.json",
    "Agente00_TechLead/skills_manifest.md",
    "Agente00_TechLead/quality_gate.md",
    "Agente00_TechLead/handoff_schema.json",
    "Agente00_TechLead/failure_modes.md",
    "Agente00_TechLead/schemas/",
    "Agente00_TechLead/templates/",
    "Agente00_TechLead/checklists/",
    "Agente00_TechLead/examples/",
    "Agente00_TechLead/skills/"
  ],
  "blocked_runtime_sources": [
    "00-contexto/",
    "01-bibliografia/",
    "manual_arquitetura_componentes_generico.md",
    "reference_architecture_generico.md",
    "integrantes_generico.md",
    "base_teorica.md"
  ],
  "can_interact_with_human": true,
  "can_trigger_council": true,
  "can_create_adr_request": true,
  "can_approve_gates": true,
  "can_execute_code": false,
  "can_deploy": false,
  "can_accept_security_risk": false
}
```

Adapte se necessário, mas preserve a intenção.

---

# 10. Conteúdo obrigatório de `context_view.md`

Crie:

```txt
Agente00_TechLead/context_view.md
```

Esse arquivo deve ser a visão local compilada do Tech Lead.

Ele deve conter:

- visão geral da fábrica;
- lista de agentes;
- fluxo macro;
- quality gates;
- State Ledger;
- Handoff Package;
- matriz de autoridade;
- ADR policy;
- Council policy;
- escalonamento humano;
- resumo da arquitetura técnica genérica;
- anti-padrões críticos;
- runtime isolation policy.

Não copie a arquitetura inteira literalmente.  
Compile apenas o que o Tech Lead precisa para orquestrar e validar.

---

# 11. Conteúdo obrigatório de `rag_manifest.json`

Crie:

```txt
Agente00_TechLead/rag_manifest.json
```

Ele deve declarar as coleções RAG autorizadas.

Use estrutura parecida com:

```json
{
  "agent_id": "Agente00_TechLead",
  "edition": "generic-white-label",
  "retrieval_policy": {
    "runtime_local_only": true,
    "prefer_local_context": true,
    "prefer_normative_architecture": true,
    "books_are_theoretical": true,
    "max_chunks": 10,
    "require_source_metadata": true
  },
  "collections": [
    {
      "name": "architecture_reference_full",
      "priority": "core",
      "usage": "normative"
    },
    {
      "name": "factory_governance",
      "priority": "core",
      "usage": "operational"
    },
    {
      "name": "software_architecture",
      "priority": "supporting",
      "usage": "theoretical"
    },
    {
      "name": "leadership_engineering",
      "priority": "supporting",
      "usage": "theoretical"
    },
    {
      "name": "devops_accelerate",
      "priority": "supporting",
      "usage": "theoretical"
    },
    {
      "name": "team_topologies",
      "priority": "optional",
      "usage": "theoretical"
    },
    {
      "name": "adr_governance",
      "priority": "core",
      "usage": "operational"
    }
  ],
  "blocked_sources": [
    "raw_books_at_runtime",
    "00-contexto",
    "01-bibliografia"
  ]
}
```

---

# 12. Conteúdo obrigatório de `skills_manifest.md`

Crie:

```txt
Agente00_TechLead/skills_manifest.md
```

Liste todas as skills do Tech Lead:

```txt
state-ledger-management-skill
agent-routing-skill
artifact-contract-validation-skill
tollgate-decision-skill
council-mediation-skill
adr-governance-skill
human-escalation-skill
risk-register-management-skill
progress-reporting-skill
```

Para cada skill, descreva:

- propósito;
- quando usar;
- inputs;
- outputs;
- failure modes;
- quality gate;
- RAG permitido;
- conformidade com a arquitetura.

---

# 13. Conteúdo obrigatório de `quality_gate.md`

Crie:

```txt
Agente00_TechLead/quality_gate.md
```

Esse arquivo deve definir como o Tech Lead decide avanço entre fases.

Inclua gates:

```txt
Gate 1 — PRD Approval
Gate 2 — Architecture Approval
Gate 3 — Execution Plan Approval
Gate 4 — QA Review
Gate 5 — Security Review
Gate 6 — Deployment Approval
Gate 7 — Post-Deploy Validation
```

Inclua status:

```txt
APPROVED
NEEDS_REVISION
APPROVED_WITH_ADR
REJECTED_RISK_TOO_HIGH
PASS
FAIL_FIX_REQUIRED
FAIL_BLOCKING
APPROVED_WITH_WARNINGS
BLOCKED_SECURITY_RISK
BLOCKED_PRIVACY_RISK
READY_FOR_DEPLOY
NEEDS_ROLLBACK_PLAN
BLOCKED_PRODUCTION_APPROVAL_REQUIRED
DEPLOY_HEALTHY
DEPLOY_DEGRADED
ROLLBACK_REQUIRED
INCIDENT_OPENED
```

Inclua regra:

```txt
O Tech Lead não deve aprovar avanço se o artefato obrigatório da fase estiver ausente.
```

---

# 14. Conteúdo obrigatório de `handoff_schema.json`

Crie:

```txt
Agente00_TechLead/handoff_schema.json
```

O schema deve validar a estrutura:

```json
{
  "artifact_produced": "string",
  "summary": "string",
  "assumptions": [],
  "open_questions": [],
  "risks": [],
  "required_next_agent": "string",
  "validation_checklist": []
}
```

Inclua campos obrigatórios e validação mínima.

---

# 15. Conteúdo obrigatório de `failure_modes.md`

Crie:

```txt
Agente00_TechLead/failure_modes.md
```

Inclua falhas como:

- artefato obrigatório ausente;
- handoff incompleto;
- PRD sem critérios de aceite;
- arquitetura sem ADR necessário;
- execution plan com tarefas grandes demais;
- QA com status bloqueante;
- DevSecOps com risco bloqueante;
- deploy sem rollback plan;
- tentativa de bypass de gate;
- conflito entre agentes;
- necessidade de aprovação humana;
- runtime tentando consultar fonte global bloqueada.

Para cada failure mode, defina:

- sintoma;
- causa provável;
- ação do Tech Lead;
- próximo agente;
- se exige humano.

---

# 16. Skills obrigatórias

Para cada skill dentro de `Agente00_TechLead/skills/`, crie:

```txt
skill.md
input.schema.json
output.schema.json
checklist.md
examples/good_output.md
examples/bad_output.md
```

## 16.1. `state-ledger-management-skill`

Propósito:

- criar;
- atualizar;
- validar;
- resumir;
- detectar inconsistências no State Ledger.

Deve lidar com fases:

```txt
requirements
architecture
planning
implementation
qa
security
deploy
post_deploy
maintenance
```

## 16.2. `agent-routing-skill`

Propósito:

- decidir qual agente deve atuar em seguida.

Deve considerar:

- fase atual;
- artefato produzido;
- status do gate;
- riscos;
- bloqueios;
- aprovações humanas pendentes.

## 16.3. `artifact-contract-validation-skill`

Propósito:

- validar se artefatos obrigatórios estão completos.

Artefatos:

```txt
PRD.md
Architecture.md
API_Contract.json
DB_Schema.sql
Execution_Plan.json
QA_Report.md
Security_Audit.md
Deployment_Plan.md
Rollback_Plan.md
Post_Deploy_Report.md
```

## 16.4. `tollgate-decision-skill`

Propósito:

- decidir status de gate.

Deve produzir:

```txt
Gate_Decision.md
```

## 16.5. `council-mediation-skill`

Propósito:

- acionar e sintetizar o Council.

Personas:

```txt
Contrarian
First Principles Thinker
Expansionist
Outsider
Executor
```

Saída:

```md
## Council Verdict

### Where the Council Agrees
...

### Where the Council Clashes
...

### Blind Spots Caught
...

### Recommendation
...

### The One Thing to Do First
...
```

## 16.6. `adr-governance-skill`

Propósito:

- identificar quando ADR é necessário;
- criar pedido de ADR;
- validar ADR;
- registrar decisão no State Ledger.

## 16.7. `human-escalation-skill`

Propósito:

- identificar quando humano deve decidir;
- criar pedido objetivo de decisão humana;
- resumir opções e riscos.

## 16.8. `risk-register-management-skill`

Propósito:

- registrar riscos;
- classificar severidade;
- definir mitigação;
- associar risco a agente ou fase.

## 16.9. `progress-reporting-skill`

Propósito:

- gerar status executivo do projeto;
- informar fase atual;
- próximos passos;
- bloqueios;
- riscos;
- decisões pendentes.

---

# 17. Schemas obrigatórios

Crie schemas JSON funcionais para:

```txt
state_ledger.schema.json
gate_decision.schema.json
council_verdict.schema.json
human_escalation.schema.json
agent_briefing.schema.json
adr_request.schema.json
risk_register.schema.json
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
State_Ledger.json
Gate_Decision.md
Council_Verdict.md
Human_Escalation_Request.md
Agent_Briefing.md
ADR_Request.md
Risk_Register.md
Handoff_Validation_Report.md
Progress_Report.md
```

Os templates devem ser práticos e prontos para uso por agente.

---

# 19. Checklists obrigatórios

Crie checklists para:

```txt
artifact_validation_checklist.md
tollgate_checklist.md
adr_required_checklist.md
human_escalation_checklist.md
state_ledger_update_checklist.md
council_activation_checklist.md
runtime_isolation_checklist.md
```

Cada checklist deve ser objetivo e acionável.

---

# 20. Exemplos obrigatórios

Crie exemplos bons e ruins para:

```txt
good_state_ledger.json
bad_state_ledger.json
good_gate_decision.md
bad_gate_decision.md
good_agent_briefing.md
bad_agent_briefing.md
good_handoff_validation.md
bad_handoff_validation.md
```

Exemplos ruins devem mostrar erros reais como:

- falta de próximo agente;
- ausência de riscos;
- gate aprovado sem artefato;
- handoff sem checklist;
- decisão sem justificativa;
- tentativa de consultar documento global em runtime.

---

# 21. Regras de segurança e autoridade

O `Agente00_TechLead` pode:

- aprovar ou bloquear gates;
- solicitar correções;
- acionar agentes;
- acionar Council;
- solicitar ADR;
- pedir aprovação humana;
- atualizar State Ledger.

O `Agente00_TechLead` não pode:

- implementar código final;
- aceitar risco grave de segurança sozinho;
- executar deploy;
- executar migration;
- escrever PRD completo no lugar do Product Owner;
- substituir QA;
- substituir DevSecOps;
- ignorar gate obrigatório;
- permitir runtime com dependência de `00-contexto` ou `01-bibliografia`.

---

# 22. Relatórios finais

Ao final da geração, crie:

```txt
build/Agente00_TechLead_build_report.md
build/Agente00_TechLead_generated_files_index.md
build/Agente00_TechLead_runtime_readiness_checklist.md
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

- `Agente00_TechLead/` existe;
- todos os arquivos obrigatórios foram criados;
- todas as skills obrigatórias foram criadas;
- todos os schemas obrigatórios foram criados;
- todos os templates obrigatórios foram criados;
- todos os checklists obrigatórios foram criados;
- exemplos bons e ruins foram criados;
- `rag_manifest.json` existe;
- `knowledge/` existe com conhecimento bibliográfico destilado;
- `agent_config.json` bloqueia fontes globais em runtime;
- `prompt.md` deixa claro o papel e os limites do Tech Lead;
- `context_view.md` contém o contexto local necessário;
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
# Agente00_TechLead criado

## Pasta criada
- `Agente00_TechLead/`

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
build/Agente00_TechLead_build_report.md
```

e explique claramente no resumo final.

---

# 25. Regra final

Crie somente o `Agente00_TechLead`.

Ele deve ser o orquestrador autocontido da fábrica genérica.

A arquitetura técnica deve permanecer rigorosa.  
A identidade deve permanecer white-label.  
O runtime deve depender apenas da pasta local do agente.
