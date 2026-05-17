# PROMPT PARA CRIAÇÃO DOS AGENTES — BUILD DO AGENTE09_UXUIDESIGNER

Atue como um **Principal AI Systems Engineer** especializado em construção de agentes, sistemas multiagentes, RAG, skills, arquitetura de software e automação com Claude Code.

Você está dentro do repositório da **AI Software Factory**.

Sua missão é construir **somente o agente `Agente09_UxUiDesigner`**, usando os arquivos genéricos da fábrica como fonte de build.

Este processo é **build-time only**.

O agente gerado NÃO deve depender de documentos globais em runtime.
Depois do build, o `Agente09_UxUiDesigner` deve operar apenas com os arquivos locais gerados dentro da própria pasta:

```txt
Agente09_UxUiDesigner/
```


---

# 1. Objetivo

Criar o agente:

```txt
Agente09_UxUiDesigner
```

Este agente será o **UX/UI Designer** da fábrica.

Ele será responsável por:

- mapear jornadas de usuário
- criar UX_Flow.md
- criar Wireframes.md
- criar UI_Spec.md
- definir estados de tela
- aplicar Design System genérico
- validar usabilidade e acessibilidade

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
00-contexto/
01-bibliografia/
manual_arquitetura_componentes_generico.md
reference_architecture_generico.md
integrantes_generico.md ou integrantes.md
base_teorica.md
```

Durante o runtime, o `Agente09_UxUiDesigner` NÃO deve depender desses arquivos globais.

Portanto, compile tudo que for necessário para dentro de:

```txt
Agente09_UxUiDesigner/
```

Em runtime, o agente só poderá consultar:

```txt
Agente09_UxUiDesigner/prompt.md
Agente09_UxUiDesigner/agent_config.json
Agente09_UxUiDesigner/context_view.md
Agente09_UxUiDesigner/rag_manifest.json
Agente09_UxUiDesigner/skills_manifest.md
Agente09_UxUiDesigner/quality_gate.md
Agente09_UxUiDesigner/handoff_schema.json
Agente09_UxUiDesigner/failure_modes.md
Agente09_UxUiDesigner/schemas/
Agente09_UxUiDesigner/templates/
Agente09_UxUiDesigner/checklists/
Agente09_UxUiDesigner/examples/
Agente09_UxUiDesigner/knowledge/
Agente09_UxUiDesigner/skills/
```

Regra final:

```txt
O Agente09_UxUiDesigner deve ser autocontido após o build.
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
Agente09_UxUiDesigner/
```

Não gere os demais agentes.

Você pode ler informações sobre agentes relacionados para entender o fluxo, especialmente:

```txt
Agente00_TechLead
Agente01_ProductOwner
Agente05_DevFrontend
Agente06_QaEngineer
```

Mas não deve criar ou alterar suas pastas.

Não crie nem modifique:

```txt
Agente02_SoftwareArchitect
Agente03_SoftwareEngineer
Agente04_DevBackend
Agente05_DevFrontend
Agente06_QaEngineer
Agente07_DevSecOps
Agente08_DevOps
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
00-contexto/
01-bibliografia/
Agente09_UxUiDesigner/
```

Se `Agente09_UxUiDesigner/` não existir, crie.

Gere ou atualize:

```txt
build/Agente09_UxUiDesigner_scan_report.md
build/missing_structure_report.md
```

O relatório de varredura deve informar:

- arquivos de contexto encontrados;
- arquivos de contexto ausentes;
- existência ou criação da pasta `Agente09_UxUiDesigner/`;
- fontes bibliográficas disponíveis para `UX/UI Designer`;
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

Extraia somente o que for necessário para construir o `Agente09_UxUiDesigner`.

Este agente precisa compreender:

- UX_Flow.md
- Wireframes.md
- UI_Spec.md
- Usability_Checklist.md
- estados de tela
- Design System genérico
- acessibilidade

Além disso, todos os agentes devem compreender:

- runtime isolation policy;
- handoff obrigatório;
- limites e anti-responsabilidades;
- política de escalonamento ao Tech Lead;
- fontes globais bloqueadas em runtime;
- relação entre artefatos locais, skills e RAG.

Gere:

```txt
build/Agente09_UxUiDesigner_context_routing_plan.md
```

---

## Etapa 3 — Ingestão bibliográfica deste agente

Leia a parte da bibliografia relacionada a `UX/UI Designer` em:

```txt
00-contexto/base_teorica.md
01-bibliografia/
```

Mapeie apenas fontes relevantes às responsabilidades deste agente.

Não copie livros para dentro do prompt.

Em vez disso, faça a destilação build-time: extraia princípios, heurísticas, decision rules, checklists, procedimentos e knowledge cards úteis para este agente, salvando tudo em artefatos locais.

Crie um manifesto RAG local apontando apenas para coleções/chunks/índices já processados, nunca para PDFs brutos.

Gere:

```txt
build/Agente09_UxUiDesigner_bibliography_inventory.json
```

---

# 7. Pasta e arquivos finais esperados

Crie a seguinte estrutura:

```txt
Agente09_UxUiDesigner/
  prompt.md
  agent_config.json
  context_view.md
  rag_manifest.json
  skills_manifest.md
  quality_gate.md
  handoff_schema.json
  failure_modes.md

  schemas/
    ux_flow.schema.json
    wireframe.schema.json
    ui_spec.schema.json
    usability_checklist.schema.json
    screen_state.schema.json

  templates/
    UX_Flow.md
    Wireframes.md
    UI_Spec.md
    Usability_Checklist.md
    Screen_States.md

  checklists/
    ux_flow_checklist.md
    wireframe_quality_checklist.md
    ui_spec_checklist.md
    usability_checklist.md
    design_system_application_checklist.md
    accessibility_basics_checklist.md
    runtime_isolation_checklist.md

  skills/
    ux-flow-design-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    wireframe-spec-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    ui-state-design-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    usability-review-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md

    design-system-application-skill/
      skill.md
      input.schema.json
      output.schema.json
      checklist.md
      examples/
        good_output.md
        bad_output.md


  examples/
    good_ux_flow.md
    bad_ux_flow.md
    good_ui_spec.md
    bad_ui_spec.md
    good_wireframe.md
    bad_wireframe.md
```

---

# 8. Conteúdo obrigatório de `prompt.md`

Crie:

```txt
Agente09_UxUiDesigner/prompt.md
```

Esse arquivo deve ser o prompt operacional local do agente.

Ele deve conter, no mínimo:

```md
# Agente09_UxUiDesigner — UX/UI Designer

## Role
...

## Mission
...

## Operating Principles
...

## Runtime Context Rule
O agente só pode consultar os artefatos locais dentro da pasta `Agente09_UxUiDesigner/` e os artefatos de projeto fornecidos como input pelo Tech Lead ou orquestrador.

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
Agente09_UxUiDesigner/agent_config.json
```

Com estrutura parecida com:

```json
{
  "agent_id": "Agente09_UxUiDesigner",
  "name": "UX/UI Designer",
  "version": "1.0.0",
  "mode": "runtime-local-only",
  "edition": "generic-white-label",
  "primary_responsibility": "ux/ui_designer",
  "allowed_runtime_sources": [
    "Agente09_UxUiDesigner/prompt.md",
    "Agente09_UxUiDesigner/context_view.md",
    "Agente09_UxUiDesigner/rag_manifest.json",
    "Agente09_UxUiDesigner/skills_manifest.md",
    "Agente09_UxUiDesigner/quality_gate.md",
    "Agente09_UxUiDesigner/handoff_schema.json",
    "Agente09_UxUiDesigner/failure_modes.md",
    "Agente09_UxUiDesigner/schemas/",
    "Agente09_UxUiDesigner/templates/",
    "Agente09_UxUiDesigner/checklists/",
    "Agente09_UxUiDesigner/examples/",
    "Agente09_UxUiDesigner/skills/"
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
  "can_execute_outside_scope": false
}
```

Adapte permissões específicas do agente quando necessário, mas preserve o bloqueio de fontes globais em runtime.

---

# 10. Conteúdo obrigatório de `context_view.md`

Crie:

```txt
Agente09_UxUiDesigner/context_view.md
```

Esse arquivo deve ser a visão local compilada do agente.

Ele deve conter apenas o subconjunto necessário para o papel de **UX/UI Designer**.

Inclua:

- UX_Flow.md
- Wireframes.md
- UI_Spec.md
- Usability_Checklist.md
- estados de tela
- Design System genérico
- acessibilidade

Não copie a arquitetura inteira.  
Compile apenas o que este agente precisa para operar.

---

# 11. Conteúdo obrigatório de `rag_manifest.json`

Crie:

```txt
Agente09_UxUiDesigner/rag_manifest.json
```

Use estrutura compatível com:

```json
{
  "agent_id": "Agente09_UxUiDesigner",
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
      "name": "ux_ui_design",
      "priority": "core",
      "usage": "theoretical"
    },
    {
      "name": "frontend_engineering",
      "priority": "core",
      "usage": "theoretical"
    },
    {
      "name": "accessibility",
      "priority": "supporting",
      "usage": "theoretical"
    },
    {
      "name": "design_system_reference",
      "priority": "supporting",
      "usage": "theoretical"
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
Agente09_UxUiDesigner/skills_manifest.md
```

Liste todas as skills autorizadas:

```txt
ux-flow-design-skill
wireframe-spec-skill
ui-state-design-skill
usability-review-skill
design-system-application-skill
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
Agente09_UxUiDesigner/quality_gate.md
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
Agente09_UxUiDesigner/handoff_schema.json
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
Agente09_UxUiDesigner/failure_modes.md
```

Inclua falhas específicas do papel de **UX/UI Designer**.

Para cada failure mode, defina:

- sintoma;
- causa provável;
- ação do agente;
- quando escalar ao Tech Lead;
- artefato a corrigir;
- se bloqueia o fluxo.

---

# 16. Skills obrigatórias

Para cada skill dentro de `Agente09_UxUiDesigner/skills/`, crie:

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
ux-flow-design-skill
wireframe-spec-skill
ui-state-design-skill
usability-review-skill
design-system-application-skill
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
ux_flow.schema.json
wireframe.schema.json
ui_spec.schema.json
usability_checklist.schema.json
screen_state.schema.json
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
UX_Flow.md
Wireframes.md
UI_Spec.md
Usability_Checklist.md
Screen_States.md
```

Os templates devem ser práticos, objetivos e prontos para uso pelo agente.

---

# 19. Checklists obrigatórios

Crie checklists para:

```txt
ux_flow_checklist.md
wireframe_quality_checklist.md
ui_spec_checklist.md
usability_checklist.md
design_system_application_checklist.md
accessibility_basics_checklist.md
runtime_isolation_checklist.md
```

Cada checklist deve ser objetivo e acionável.

---

# 20. Exemplos obrigatórios

Crie exemplos bons e ruins para:

```txt
good_ux_flow.md
bad_ux_flow.md
good_ui_spec.md
bad_ui_spec.md
good_wireframe.md
bad_wireframe.md
```

Exemplos ruins devem mostrar erros reais compatíveis com o papel do agente.

---

# 21. Regras de autoridade

O `Agente09_UxUiDesigner` pode:

- mapear jornadas de usuário
- criar UX_Flow.md
- criar Wireframes.md
- criar UI_Spec.md
- definir estados de tela
- aplicar Design System genérico
- validar usabilidade e acessibilidade

O `Agente09_UxUiDesigner` não pode:

- implementar código final
- alterar contrato de API
- alterar PRD sem Product Owner
- ignorar Design System
- inventar identidade visual específica
- usar tokens corporativos específicos
- definir arquitetura técnica

Além disso, nenhum agente pode consultar `00-contexto` ou `01-bibliografia` em runtime.

---

# 22. Relatórios finais

Ao final da geração, crie:

```txt
build/Agente09_UxUiDesigner_build_report.md
build/Agente09_UxUiDesigner_generated_files_index.md
build/Agente09_UxUiDesigner_runtime_readiness_checklist.md
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

- `Agente09_UxUiDesigner/` existe;
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
- não há dependência runtime de `00-contexto`;
- não há dependência runtime de `01-bibliografia`;
- não há dependência runtime de PDFs ou livros brutos;
- não há menção corporativa específica;
- a versão é genérica / white-label.

---

# 24. Resposta final esperada

Depois de executar o build, responda com:

```md
# Agente09_UxUiDesigner criado

## Pasta criada
- `Agente09_UxUiDesigner/`

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
build/Agente09_UxUiDesigner_build_report.md
```

e explique claramente no resumo final.

---

# 25. Regra final

Crie somente o `Agente09_UxUiDesigner`.

Ele deve ser autocontido e aderente à versão genérica / white-label.

A arquitetura técnica deve permanecer rigorosa.  
A identidade deve permanecer white-label.  
O runtime deve depender apenas da pasta local do agente.
