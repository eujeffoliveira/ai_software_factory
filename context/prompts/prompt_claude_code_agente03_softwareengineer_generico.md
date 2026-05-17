# PROMPT PARA CRIAÇÃO DOS AGENTES — BUILD DO AGENTE03_SOFTWAREENGINEER

Atue como um **Principal AI Systems Engineer** especializado em construção de agentes, sistemas multiagentes, RAG, skills, arquitetura de software e automação com Claude Code.

Você está dentro do repositório da **AI Software Factory**.

Sua missão é construir **somente o agente `Agente03_SoftwareEngineer`**, usando os arquivos genéricos da fábrica como fonte de build.

Este processo é **build-time only**.

O agente gerado NÃO deve depender de documentos globais em runtime.
Depois do build, o `Agente03_SoftwareEngineer` deve operar apenas com os arquivos locais gerados dentro da própria pasta:

```txt
Agente03_SoftwareEngineer/
```


---

# 1. Objetivo

Criar o agente:

```txt
Agente03_SoftwareEngineer
```

Este agente será o **Software Engineer / Task Planner** da fábrica.

Ele será responsável por:

- transformar arquitetura aprovada em plano de execução
- quebrar trabalho em tarefas atômicas
- mapear dependências
- definir ordem de implementação
- proteger agentes de codificação contra tarefas grandes demais
- produzir Execution_Plan.json

---

# 2. Fontes obrigatórias de build

Leia os arquivos genéricos nesta ordem:

```txt
context/
  manual_arquitetura_componentes_generico.md
  reference_architecture_generico.md
  integrantes_generico.md
  base_teorica.md
```

Se `integrantes_generico.md` não existir, use:

```txt
context/integrantes.md
```

e trate qualquer menção corporativa específica como algo a ser removido ou abstraído na versão genérica.

Se algum arquivo obrigatório estiver ausente, registre a lacuna em:

```txt
build/missing_structure_report.md
```

e continue com melhor esforço, desde que seja possível construir o agente solicitado.


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
  - `corporate design system`;
  - `primary-color`;
  - `secondary-color`;
  - `data protection compliance`;
- remova referências a contexto educacional, escolas, alunos, responsáveis, unidades ou terminologias específicas;
- preserve integralmente o pilar técnico da arquitetura.

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
context/
lib/
manual_arquitetura_componentes_generico.md
reference_architecture_generico.md
integrantes_generico.md ou integrantes.md
base_teorica.md
```

Durante o runtime, o `Agente03_SoftwareEngineer` NÃO deve depender desses arquivos globais.

Portanto, compile tudo que for necessário para dentro de:

```txt
Agente03_SoftwareEngineer/
```

Em runtime, o agente só poderá consultar:

```txt
Agente03_SoftwareEngineer/prompt.md
Agente03_SoftwareEngineer/agent_config.json
Agente03_SoftwareEngineer/context_view.md
Agente03_SoftwareEngineer/rag_manifest.json
Agente03_SoftwareEngineer/skills_manifest.md
Agente03_SoftwareEngineer/quality_gate.md
Agente03_SoftwareEngineer/handoff_schema.json
Agente03_SoftwareEngineer/failure_modes.md
Agente03_SoftwareEngineer/schemas/
Agente03_SoftwareEngineer/templates/
Agente03_SoftwareEngineer/checklists/
Agente03_SoftwareEngineer/examples/
Agente03_SoftwareEngineer/knowledge/
Agente03_SoftwareEngineer/skills/
```

Regra final:

```txt
O Agente03_SoftwareEngineer deve ser autocontido após o build.
```


---

# REGRA CRÍTICA — Destilação de conhecimento da bibliografia

A pasta `lib/` e quaisquer PDFs/livros brutos devem ser usados **somente uma vez durante o build**.

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
- o agente NÃO deve consultar `lib/`;
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
Agente03_SoftwareEngineer/
```

Não gere os demais agentes.

Você pode ler informações sobre agentes relacionados para entender o fluxo, especialmente:

```txt
Agente00_TechLead
Agente01_ProductOwner
Agente02_SoftwareArchitect
Agente04_DevBackend
Agente05_DevFrontend
Agente06_QaEngineer
Agente07_DevSecOps
```

Mas não deve criar ou alterar suas pastas.

Não crie nem modifique:

```txt
Agente02_SoftwareArchitect
Agente04_DevBackend
Agente05_DevFrontend
Agente06_QaEngineer
Agente07_DevSecOps
Agente08_DevOps
Agente09_UxUiDesigner
Agente10_DataIntegrationEngineer
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
context/
lib/
Agente03_SoftwareEngineer/
```

Se `Agente03_SoftwareEngineer/` não existir, crie.

Gere ou atualize:

```txt
build/Agente03_SoftwareEngineer_scan_report.md
build/missing_structure_report.md
```

O relatório de varredura deve informar:

- arquivos de contexto encontrados;
- arquivos de contexto ausentes;
- existência ou criação da pasta `Agente03_SoftwareEngineer/`;
- fontes bibliográficas disponíveis para `Software Engineer / Task Planner`;
- riscos ou lacunas de build.

---

## Etapa 2 — Leitura e roteamento de contexto

Leia, nesta ordem:

```txt
1. context/manual_arquitetura_componentes_generico.md
2. context/integrantes_generico.md ou context/integrantes.md
3. context/reference_architecture_generico.md
4. context/base_teorica.md
```

Extraia somente o que for necessário para construir o `Agente03_SoftwareEngineer`.

Este agente precisa compreender:

- Execution_Plan.json
- Task_Backlog.md
- Dependency_Graph.md
- tarefas atômicas
- dependências
- critérios por tarefa
- requisitos de teste
- requisitos de segurança

Além disso, todos os agentes devem compreender:

- runtime isolation policy;
- handoff obrigatório;
- limites e anti-responsabilidades;
- política de escalonamento ao Tech Lead;
- fontes globais bloqueadas em runtime;
- relação entre artefatos locais, skills e RAG.

Gere:

```txt
build/Agente03_SoftwareEngineer_context_routing_plan.md
```

---

## Etapa 3 — Ingestão bibliográfica deste agente

Leia a parte da bibliografia relacionada a `Software Engineer / Task Planner` em:

```txt
context/base_teorica.md
lib/
```

Mapeie apenas fontes relevantes às responsabilidades deste agente.

Não copie livros para dentro do prompt.

Em vez disso, faça a destilação build-time: extraia princípios, heurísticas, decision rules, checklists, procedimentos e knowledge cards úteis para este agente, salvando tudo em artefatos locais.

Crie um manifesto RAG local apontando apenas para coleções/chunks/índices já processados, nunca para PDFs brutos.

Gere:

```txt
build/Agente03_SoftwareEngineer_bibliography_inventory.json
```

---

# 7. Pasta e arquivos finais esperados

Crie a seguinte estrutura:

```txt
Agente03_SoftwareEngineer/
  prompt.md
  agent_config.json
  context_view.md
  rag_manifest.json
  skills_manifest.md
  quality_gate.md
  handoff_schema.json
  failure_modes.md

  schemas/
    execution_plan.schema.json
    task.schema.json
    dependency_graph.schema.json
    task_handoff.schema.json
    task_acceptance_criteria.schema.json
    task_security_requirements.schema.json
    task_test_requirements.schema.json

  templates/
    Execution_Plan.json
    Task_Backlog.md
    Dependency_Graph.md
    Task_Template.md
    Task_Handoff_Package.md
    Implementation_Sequence.md

  checklists/
    task_atomicity_checklist.md
    dependency_checklist.md
    implementation_readiness_checklist.md
    context_window_checklist.md
    test_requirements_checklist.md
    security_requirements_checklist.md
    runtime_isolation_checklist.md

  skills/
    execution-plan-generation-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    atomic-task-decomposition-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    dependency-graph-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    task-sizing-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    acceptance-criteria-mapping-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    implementation-sequencing-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    context-window-risk-analysis-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md


  examples/
    good_execution_plan.json
    bad_execution_plan.json
    good_task.md
    bad_task.md
    good_dependency_graph.md
    bad_dependency_graph.md
```

---

# 8. Conteúdo obrigatório de `prompt.md`

Crie:

```txt
Agente03_SoftwareEngineer/prompt.md
```

Esse arquivo deve ser o prompt operacional local do agente.

Ele deve conter, no mínimo:

```md
# Agente03_SoftwareEngineer — Software Engineer / Task Planner

## Role
...

## Mission
...

## Operating Principles
...

## Runtime Context Rule
O agente só pode consultar os artefatos locais dentro da pasta `Agente03_SoftwareEngineer/` e os artefatos de projeto fornecidos como input pelo Tech Lead ou orquestrador.

Ele não deve consultar `context/`, `lib/`, o manual global, a arquitetura global ou a bibliografia bruta em runtime.

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

## Quality Gate
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

O prompt deve deixar claro que o agente:

- respeita seu escopo;
- usa apenas artefatos locais em runtime;
- escala conflitos ao Tech Lead;
- não decide fora de seu papel;
- não consulta fontes globais em runtime.

---

# 9. Conteúdo obrigatório de `agent_config.json`

Crie:

```txt
Agente03_SoftwareEngineer/agent_config.json
```

Com estrutura parecida com:

```json
{
  "agent_id": "Agente03_SoftwareEngineer",
  "name": "Software Engineer / Task Planner",
  "version": "1.0.0",
  "mode": "runtime-local-only",
  "edition": "generic-white-label",
  "primary_responsibility": "software_engineer_task_planner",
  "allowed_runtime_sources": [
    "Agente03_SoftwareEngineer/prompt.md",
    "Agente03_SoftwareEngineer/context_view.md",
    "Agente03_SoftwareEngineer/rag_manifest.json",
    "Agente03_SoftwareEngineer/skills_manifest.md",
    "Agente03_SoftwareEngineer/quality_gate.md",
    "Agente03_SoftwareEngineer/handoff_schema.json",
    "Agente03_SoftwareEngineer/failure_modes.md",
    "Agente03_SoftwareEngineer/schemas/",
    "Agente03_SoftwareEngineer/templates/",
    "Agente03_SoftwareEngineer/checklists/",
    "Agente03_SoftwareEngineer/examples/",
    "Agente03_SoftwareEngineer/skills/"
  ],
  "blocked_runtime_sources": [
    "context/",
    "lib/",
    "manual_arquitetura_componentes_generico.md",
    "reference_architecture_generico.md",
    "integrantes_generico.md",
    "base_teorica.md"
  ],
  "can_interact_with_human": false,
  "human_interaction_channel": "via_tech_lead",
  "can_execute_outside_scope": false
}
```

Adapte permissões específicas do agente quando necessário, mas preserve o bloqueio de fontes globais em runtime.

---

# 10. Conteúdo obrigatório de `context_view.md`

Crie:

```txt
Agente03_SoftwareEngineer/context_view.md
```

Esse arquivo deve ser a visão local compilada do agente.

Ele deve conter apenas o subconjunto necessário para o papel de **Software Engineer / Task Planner**.

Inclua:

- Execution_Plan.json
- Task_Backlog.md
- Dependency_Graph.md
- tarefas atômicas
- dependências
- critérios por tarefa
- requisitos de teste
- requisitos de segurança

Não copie a arquitetura inteira.  
Compile apenas o que este agente precisa para operar.

---

# 11. Conteúdo obrigatório de `rag_manifest.json`

Crie:

```txt
Agente03_SoftwareEngineer/rag_manifest.json
```

Use estrutura compatível com:

```json
{
  "agent_id": "Agente03_SoftwareEngineer",
  "edition": "generic-white-label",
  "retrieval_policy": {
    "runtime_local_only": true,
    "prefer_local_context": true,
    "prefer_normative_architecture": true,
    "books_are_theoretical": true,
    "max_chunks": 8,
    "require_source_metadata": true
  },
  "collections": [
    {
      "name": "pragmatic_programming",
      "priority": "core",
      "usage": "theoretical"
    },
    {
      "name": "code_complete",
      "priority": "core",
      "usage": "theoretical"
    },
    {
      "name": "software_design",
      "priority": "supporting",
      "usage": "theoretical"
    },
    {
      "name": "design_patterns",
      "priority": "supporting",
      "usage": "theoretical"
    },
    {
      "name": "integration_patterns",
      "priority": "supporting",
      "usage": "theoretical"
    },
    {
      "name": "architecture_reference_task_planner_view",
      "priority": "supporting",
      "usage": "normative"
    }
  ],
  "blocked_sources": [
    "raw_books_at_runtime",
    "context",
    "lib"
  ]
}
```

---

# 12. Conteúdo obrigatório de `skills_manifest.md`

Crie:

```txt
Agente03_SoftwareEngineer/skills_manifest.md
```

Liste todas as skills autorizadas:

```txt
execution-plan-generation-skill
atomic-task-decomposition-skill
dependency-graph-skill
task-sizing-skill
acceptance-criteria-mapping-skill
implementation-sequencing-skill
context-window-risk-analysis-skill
```

Para cada skill, descreva:

- propósito;
- quando usar;
- inputs;
- outputs;
- failure modes;
- quality gate;
- RAG permitido;
- conformidade com o manual da fábrica e com a arquitetura genérica.

---

# 13. Conteúdo obrigatório de `quality_gate.md`

Crie:

```txt
Agente03_SoftwareEngineer/quality_gate.md
```

Esse arquivo deve definir como o agente prepara, valida ou participa do quality gate relacionado ao seu papel.

Inclua:

- objetivo do gate;
- critérios de entrada;
- critérios de saída;
- status possíveis;
- quando bloquear;
- quando escalar ao Tech Lead;
- quando exigir humano.

---

# 14. Conteúdo obrigatório de `handoff_schema.json`

Crie:

```txt
Agente03_SoftwareEngineer/handoff_schema.json
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
Agente03_SoftwareEngineer/failure_modes.md
```

Inclua falhas específicas do papel de **Software Engineer / Task Planner**.

Para cada failure mode, defina:

- sintoma;
- causa provável;
- ação do agente;
- quando escalar ao Tech Lead;
- artefato a corrigir;
- se bloqueia o fluxo.

---

# 16. Skills obrigatórias

Para cada skill dentro de `Agente03_SoftwareEngineer/skills/`, crie:

```txt
skill.md
input.schema.json
output.schema.json
checklist.md
examples/good_output.md
examples/bad_output.md
```

Skills a criar:

```txt
execution-plan-generation-skill
atomic-task-decomposition-skill
dependency-graph-skill
task-sizing-skill
acceptance-criteria-mapping-skill
implementation-sequencing-skill
context-window-risk-analysis-skill
```

Cada `skill.md` deve conter:

```md
# Skill Name

## Purpose
...

## When to use
...

## Inputs
...

## Outputs
...

## Procedure
...

## Quality Gate
...

## Failure Modes
...

## RAG Policy
...

## Architecture Compliance
...
```

---

# 17. Schemas obrigatórios

Crie schemas JSON funcionais para:

```txt
execution_plan.schema.json
task.schema.json
dependency_graph.schema.json
task_handoff.schema.json
task_acceptance_criteria.schema.json
task_security_requirements.schema.json
task_test_requirements.schema.json
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
Execution_Plan.json
Task_Backlog.md
Dependency_Graph.md
Task_Template.md
Task_Handoff_Package.md
Implementation_Sequence.md
```

Os templates devem ser práticos, objetivos e prontos para uso pelo agente.

---

# 19. Checklists obrigatórios

Crie checklists para:

```txt
task_atomicity_checklist.md
dependency_checklist.md
implementation_readiness_checklist.md
context_window_checklist.md
test_requirements_checklist.md
security_requirements_checklist.md
runtime_isolation_checklist.md
```

Cada checklist deve ser objetivo e acionável.

---

# 20. Exemplos obrigatórios

Crie exemplos bons e ruins para:

```txt
good_execution_plan.json
bad_execution_plan.json
good_task.md
bad_task.md
good_dependency_graph.md
bad_dependency_graph.md
```

Exemplos ruins devem mostrar erros reais compatíveis com o papel do agente.

---

# 21. Regras de autoridade

O `Agente03_SoftwareEngineer` pode:

- transformar arquitetura aprovada em plano de execução
- quebrar trabalho em tarefas atômicas
- mapear dependências
- definir ordem de implementação
- proteger agentes de codificação contra tarefas grandes demais
- produzir Execution_Plan.json

O `Agente03_SoftwareEngineer` não pode:

- escrever código final
- alterar escopo
- mudar arquitetura
- inventar endpoint
- criar schema novo sem Arquiteto
- remover critério de aceite
- ignorar requisitos de teste
- ignorar requisitos de segurança

Além disso, nenhum agente pode consultar `context` ou `lib` em runtime.

---

# 22. Relatórios finais

Ao final da geração, crie:

```txt
build/Agente03_SoftwareEngineer_build_report.md
build/Agente03_SoftwareEngineer_generated_files_index.md
build/Agente03_SoftwareEngineer_runtime_readiness_checklist.md
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

- `Agente03_SoftwareEngineer/` existe;
- todos os arquivos obrigatórios foram criados;
- todas as skills obrigatórias foram criadas;
- todos os schemas obrigatórios foram criados;
- todos os templates obrigatórios foram criados;
- todos os checklists obrigatórios foram criados;
- exemplos bons e ruins foram criados;
- `rag_manifest.json` existe;
- `knowledge/` existe com conhecimento bibliográfico destilado;
- `agent_config.json` bloqueia fontes globais em runtime;
- `prompt.md` deixa claro o papel e os limites do agente;
- `context_view.md` contém apenas o contexto necessário;
- os relatórios de build foram gerados;
- não há dependência runtime de `context`;
- não há dependência runtime de `lib`;
- não há dependência runtime de PDFs ou livros brutos;
- não há menção corporativa específica;
- a versão é genérica / white-label.

---

# 24. Resposta final esperada

Depois de executar o build, responda com:

```md
# Agente03_SoftwareEngineer criado

## Pasta criada
- `Agente03_SoftwareEngineer/`

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
build/Agente03_SoftwareEngineer_build_report.md
```

e explique claramente no resumo final.

---

# 25. Regra final

Crie somente o `Agente03_SoftwareEngineer`.

Ele deve ser autocontido e aderente à versão genérica / white-label.

A arquitetura técnica deve permanecer rigorosa.  
A identidade deve permanecer white-label.  
O runtime deve depender apenas da pasta local do agente.
