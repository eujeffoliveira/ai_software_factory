# PROMPT PADRÃO — Enriquecimento de Conhecimento da AI Software Factory

Use este prompt quando houver novas fontes de conhecimento para enriquecer os agentes da `ai_software_factory`.

Objetivo:
Destilar o máximo de conhecimento operacional possível das novas fontes e incorporá-lo corretamente às bases dos agentes, sem transformar fontes brutas em dependência de runtime.

Este prompt pode ser executado por Claude Code, Gemini, ChatGPT, Roo Code/Cline ou qualquer IA com acesso ao repositório.

────────────────────────────────────────
0. Contexto do projeto
────────────────────────────────────────

Você está trabalhando no repositório `ai_software_factory`.

A AI Software Factory é um framework multiagente de SDLC. Cada agente tem:

- `prompt.md` — identidade, papel, responsabilidades e comportamento;
- `context_view.md` — contexto compilado local de runtime;
- `rag_manifest.json` — política de RAG/fontes;
- `skills_manifest.md` — índice de skills disponíveis;
- `quality_gate.md` — critérios de gates aplicáveis;
- `failure_modes.md` — modos de falha;
- `knowledge/` — conhecimento destilado;
- `skills/` — skills operacionais;
- `schemas/` — contratos JSON;
- `templates/` — templates de artefatos;
- `checklists/` — checklists de execução/validação;
- `examples/` — exemplos bons/ruins.

Regra fundamental:
As fontes brutas são build-time only. Elas devem ser usadas para gerar conhecimento destilado, mas não devem virar dependência obrigatória de runtime.

O runtime dos agentes deve usar apenas artefatos locais e/ou a base MCP/RAG indexada da factory.

────────────────────────────────────────
1. Fontes novas a processar
────────────────────────────────────────

Processar as seguintes fontes novas:

[COLE AQUI OS CAMINHOS, LINKS, ARQUIVOS, PDFs, MARKDOWNS, DOCS, ANOTAÇÕES OU DESCRIÇÕES DAS FONTES]

Exemplos:

```text
lib/TechLead/Novo Livro.pdf
lib/DevBackend/Artigo sobre FastAPI.md
bibliography/playbooks/playbook-python-automation.md
context/novas_regras_de_arquitetura.md
docs/research/observability-patterns.md
```

Se as fontes ainda não estiverem dentro do repositório:
- indique onde devem ser colocadas;
- prefira `lib/<Papel>/` para bibliografia por agente;
- prefira `bibliography/playbooks/` para playbooks operacionais;
- prefira `context/` apenas para documentos globais de build-time;
- prefira `docs/` para documentação explicativa;
- nunca coloque fonte bruta dentro de `knowledge/` como se fosse conhecimento destilado.

────────────────────────────────────────
2. Primeiro audite o repositório
────────────────────────────────────────

Antes de alterar arquivos, faça uma auditoria rápida da estrutura atual.

Revise, no mínimo:

- `README.md`
- `CLAUDE.md`, se existir
- `context/reference_architecture_generico.md`
- `context/base_teorica.md`, se existir
- `context/integrantes.md`, se existir
- `bibliography/playbooks/`
- todos os diretórios `Agente*/`
- `Agente*/prompt.md`
- `Agente*/context_view.md`
- `Agente*/rag_manifest.json`
- `Agente*/skills_manifest.md`
- `Agente*/quality_gate.md`
- `Agente*/failure_modes.md`
- `Agente*/knowledge/`
- `Agente*/skills/`
- `Agente*/schemas/`
- `Agente*/templates/`
- `Agente*/checklists/`
- `Agente*/examples/`
- `tools/mcp-knowledge-search/`
- `knowledge-config.json`, se existir
- `update-knowledge.ps1`, se existir
- `install.ps1`

Objetivo da auditoria:
- entender quais agentes existem;
- entender o padrão atual de artefatos;
- identificar onde o novo conhecimento deve ser incorporado;
- evitar duplicidade;
- preservar a arquitetura do repositório;
- manter compatibilidade com instalação global e MCP/RAG.

────────────────────────────────────────
3. Classifique cada fonte
────────────────────────────────────────

Para cada fonte nova, classifique:

```json
{
  "source_title": "",
  "source_path": "",
  "source_type": "book | article | playbook | course_material | internal_doc | technical_reference | standard | code_sample | other",
  "domain": "architecture | backend | frontend | qa | devsecops | devops | uxui | data_integration | product | techlead | automation | multi_agent | mcp | other",
  "target_agents": [],
  "project_archetypes": [],
  "confidence": "high | medium | low",
  "processing_status": "to_process | processed | skipped",
  "reason_if_skipped": ""
}
```

Agentes disponíveis:

- `Agente00_TechLead`
- `Agente01_ProductOwner`
- `Agente02_SoftwareArchitect`
- `Agente03_SoftwareEngineer`
- `Agente04_DevBackend`
- `Agente05_DevFrontend`
- `Agente06_QaEngineer`
- `Agente07_DevSecOps`
- `Agente08_DevOps`
- `Agente09_UxUiDesigner`
- `Agente10_DataIntegrationEngineer`

Arquétipos de projeto, quando aplicável:

- `web_app`
- `automation_script`
- `data_pipeline`
- `api_service`
- `cli_tool`
- `mcp_server`
- `integration_worker`
- `notebook_analysis`

Se a fonte for transversal, pode impactar múltiplos agentes.

────────────────────────────────────────
4. Extraia conhecimento em camadas
────────────────────────────────────────

Não faça apenas resumo.

Destile conhecimento em camadas operacionais, na seguinte ordem:

1. Conceitos fundamentais
   - ideias centrais;
   - definições;
   - princípios;
   - padrões recorrentes;
   - distinções importantes.

2. Princípios operacionais
   - regras amplas que devem orientar decisões dos agentes.

3. Heurísticas
   - atalhos práticos de decisão;
   - sinais de alerta;
   - critérios de priorização;
   - "quando X, prefira Y".

4. Regras if-then
   - regras acionáveis;
   - exemplos:
     - "Se o script altera dados externos, então exigir --dry-run."
     - "Se o gate não tem artefato obrigatório, então bloquear."
     - "Se a arquitetura foge do Golden Model do arquétipo, então exigir ADR."

5. Checklists
   - listas de validação para execução;
   - listas de bloqueio;
   - readiness checks;
   - review checks.

6. Templates
   - artefatos reutilizáveis;
   - estruturas de documentos;
   - modelos de relatório;
   - modelos de plano;
   - modelos de handoff.

7. Schemas
   - contratos JSON;
   - estruturas de entrada/saída;
   - campos obrigatórios;
   - enumerações;
   - regras de validação.

8. Skills
   - novas capacidades acionáveis;
   - quando usar;
   - input esperado;
   - output esperado;
   - passos de execução;
   - checklist da skill;
   - exemplos bons e ruins.

9. Failure modes
   - como o agente pode errar;
   - sintomas;
   - causa provável;
   - mitigação;
   - severidade.

10. Exemplos
   - bons outputs;
   - maus outputs;
   - exemplos mínimos;
   - exemplos complexos;
   - anti-exemplos.

11. Ajustes de prompt
   - somente quando a fonte muda comportamento fundamental do agente;
   - não inflar prompt com conteúdo que deveria ficar em knowledge/skills/checklists;
   - atualizar instruções de uso do MCP/RAG quando necessário.

12. Atualizações de documentação
   - README;
   - docs;
   - source maps;
   - changelog de conhecimento.

────────────────────────────────────────
5. Política de direitos autorais e segurança
────────────────────────────────────────

Se a fonte for livro, artigo, curso, PDF, material proprietário ou conteúdo protegido:

- não copie longos trechos literais;
- não replique capítulos;
- não reproduza conteúdo protegido em bloco;
- destile em linguagem própria;
- transforme em princípios, heurísticas, checklists e regras operacionais;
- use citações curtas apenas quando indispensável;
- registre a fonte no `source_map.json`;
- preserve rastreabilidade sem violar direitos autorais.

Se a fonte tiver segredos, tokens, credenciais, dados pessoais ou dados sensíveis:

- não copie segredos para knowledge;
- não inclua valores reais em exemplos;
- substitua por placeholders;
- registre risco em relatório;
- recomende remoção/rotação de credenciais se encontrar segredo real.

────────────────────────────────────────
6. Decidir quais agentes devem ser atualizados
────────────────────────────────────────

Para cada fonte, identifique os agentes impactados.

Exemplos:

- Governança, gates, orquestração, decisões, ADRs:
  - `Agente00_TechLead`

- Requisitos, escopo, critérios de aceite, user stories:
  - `Agente01_ProductOwner`

- Arquitetura, Golden Models, ADRs, padrões técnicos:
  - `Agente02_SoftwareArchitect`

- Planejamento, decomposição, execução técnica:
  - `Agente03_SoftwareEngineer`

- Backend, APIs, banco, jobs, automações backend:
  - `Agente04_DevBackend`

- Frontend, UX técnica, componentes, acessibilidade de UI:
  - `Agente05_DevFrontend`

- Testes, qualidade, E2E, cobertura, estratégia de QA:
  - `Agente06_QaEngineer`

- Segurança, privacidade, threat modeling, secrets:
  - `Agente07_DevSecOps`

- Deploy, CI/CD, observabilidade, rollback, operação:
  - `Agente08_DevOps`

- UX, UI, pesquisa, design system, usabilidade:
  - `Agente09_UxUiDesigner`

- Dados, integração, ETL, APIs externas, pipelines, idempotência:
  - `Agente10_DataIntegrationEngineer`

Se a fonte for transversal, atualize múltiplos agentes de forma coordenada.

────────────────────────────────────────
7. Atualizar knowledge/ de cada agente impactado
────────────────────────────────────────

Para cada agente impactado, atualizar ou criar conteúdo em:

```text
AgenteXX_Nome/knowledge/principles.md
AgenteXX_Nome/knowledge/heuristics.md
AgenteXX_Nome/knowledge/decision_rules.md
AgenteXX_Nome/knowledge/knowledge_cards.md
AgenteXX_Nome/knowledge/source_map.json
```

Regras:

- Preserve o estilo atual do arquivo.
- Não apague conhecimento existente sem motivo claro.
- Evite duplicar regras já existentes.
- Quando uma nova regra substituir uma antiga, registre a substituição.
- Use IDs consistentes:
  - princípios: `P001`, `P002`, etc. ou padrão já existente;
  - heurísticas: `H001`, `H002`, etc.;
  - decision rules: `DR001`, `DR002`, etc.;
  - cards: `Card 001`, `Card 002`, etc.
- Se o repo já usa outro padrão, siga o padrão existente.
- Inclua exemplos de violação e comportamento correto quando útil.
- Marque o conhecimento como derivado de build-time.

Formato sugerido para princípios:

```md
## PXXX — [Nome do princípio]

[Descrição operacional curta.]

**Quando aplicar:**  
[Contextos]

**Violação:**  
[Exemplo de mau uso]

**Correto:**  
[Exemplo de aplicação correta]

**Fonte destilada:**  
[Título/caminho da fonte]
```

Formato sugerido para heurísticas:

```md
## HXXX — [Nome da heurística]

**Sinal:**  
[Como reconhecer]

**Ação:**  
[O que o agente deve fazer]

**Risco evitado:**  
[Qual falha isso previne]

**Fonte destilada:**  
[Título/caminho da fonte]
```

Formato sugerido para decision rules:

```md
## DRXXX — [Nome da regra]

IF [condição]
THEN [ação obrigatória]
BECAUSE [racional]

**Bloqueia gate?** YES/NO  
**Requer ADR?** YES/NO  
**Requer humano?** YES/NO  
**Fonte destilada:** [fonte]
```

Formato sugerido para knowledge cards:

```md
## Card XXX — [Conceito]

**Resumo:**  
[Explicação curta]

**Use quando:**  
[Contexto]

**Não use quando:**  
[Limites]

**Aplicação na factory:**  
[Como isso afeta agentes, gates, templates ou skills]

**Fonte destilada:**  
[fonte]
```

────────────────────────────────────────
8. Atualizar source_map.json
────────────────────────────────────────

Para cada agente impactado, atualize `knowledge/source_map.json`.

O `source_map.json` deve registrar:

- título da fonte;
- tipo da fonte;
- caminho;
- data de processamento;
- status;
- se foi lida integralmente, parcialmente ou inventariada;
- quais artefatos foram alterados;
- quais conceitos foram destilados;
- notas de limitação;
- política de runtime.

Exemplo:

```json
{
  "source_title": "Nome da fonte",
  "source_type": "book",
  "source_path": "lib/DevOps/Nome da Fonte.pdf",
  "usage": "build_time_distillation_only",
  "status": "PROCESSED",
  "processing_date": "YYYY-MM-DD",
  "derived_artifacts": [
    "knowledge/principles.md",
    "knowledge/heuristics.md",
    "knowledge/decision_rules.md",
    "checklists/deployment_readiness.md"
  ],
  "distilled_concepts": [
    "rollback strategy",
    "deployment readiness",
    "change failure rate"
  ],
  "runtime_access_allowed": false,
  "notes": "Fonte destilada em linguagem própria; nenhum trecho longo copiado."
}
```

Se a fonte não pôde ser processada integralmente, registre claramente:

```json
{
  "status": "PARTIALLY_PROCESSED",
  "limitation": "PDF muito longo; processados capítulos X e Y.",
  "recommended_next_action": "Rodar nova rodada de destilação nos capítulos restantes."
}
```

Não finja que leu uma fonte que não foi lida.

────────────────────────────────────────
9. Atualizar context_view.md quando necessário
────────────────────────────────────────

Atualize `context_view.md` dos agentes impactados quando o novo conhecimento alterar:

- visão operacional do agente;
- Golden Model;
- gates;
- artefatos obrigatórios;
- autoridade do agente;
- matriz de decisão;
- fluxo macro;
- runtime policy;
- padrões obrigatórios.

Não copie conhecimento extenso para `context_view.md`.

Use `context_view.md` para o resumo compilado e operacional.

O detalhe deve ficar em:

- `knowledge/`;
- `skills/`;
- `checklists/`;
- `templates/`;
- `schemas/`;
- MCP/RAG.

────────────────────────────────────────
10. Atualizar prompts apenas quando necessário
────────────────────────────────────────

Atualize `prompt.md` somente se a fonte alterar:

- missão do agente;
- responsabilidades;
- boundaries;
- regras críticas de comportamento;
- skills autorizadas;
- gates;
- política de runtime;
- política de MCP/RAG;
- formatos obrigatórios de resposta.

Evite colocar conhecimento longo no prompt.

O prompt deve apontar para os artefatos corretos:

```text
Use knowledge/, skills/, checklists/, templates/, schemas/ e MCP/RAG para detalhes operacionais.
```

Se o repositório usa instalação global dos agentes em `~/.claude/agents/`, garanta que mudanças relevantes em `prompt.md` e knowledge essencial serão refletidas pelo `install.ps1`.

────────────────────────────────────────
11. Atualizar skills quando a fonte trouxer capacidade nova
────────────────────────────────────────

Se a fonte trouxer um processo operacional novo, crie ou atualize uma skill.

Local sugerido:

```text
AgenteXX_Nome/skills/nome-da-skill/
```

Estrutura esperada, se o padrão do repo permitir:

```text
skill.md
input.schema.json
output.schema.json
checklist.md
examples/good_output.md
examples/bad_output.md
```

A skill deve explicar:

- quando usar;
- quando não usar;
- pré-condições;
- input;
- output;
- passos;
- critérios de qualidade;
- falhas comuns;
- exemplos.

Não crie skills genéricas demais.

Skills devem ser acionáveis.

Exemplos de boas skills:

- `python-automation-design-review-skill`
- `idempotency-review-skill`
- `api-contract-validation-skill`
- `deployment-readiness-review-skill`
- `data-quality-gate-skill`
- `threat-modeling-review-skill`
- `prd-acceptance-criteria-refinement-skill`

────────────────────────────────────────
12. Atualizar checklists
────────────────────────────────────────

Crie ou atualize checklists quando a fonte trouxer critérios de validação.

Local possível:

```text
AgenteXX_Nome/checklists/
```

ou, se for transversal:

```text
checklists/
docs/checklists/
templates/checklists/
```

Siga o padrão existente do repo.

Checklist bom deve ter:

- itens objetivos;
- critérios verificáveis;
- linguagem acionável;
- indicação de bloqueio quando falhar;
- relação com gate quando aplicável.

Exemplo:

```md
# Checklist — Python Automation Idempotency

- [ ] Existe chave de idempotência definida.
- [ ] Reprocessamento não duplica registros.
- [ ] Existe `--dry-run` para operações destrutivas ou externas.
- [ ] Falhas parciais podem ser retomadas.
- [ ] Logs incluem `run_id`.
- [ ] Testes cobrem reexecução.
```

────────────────────────────────────────
13. Atualizar templates
────────────────────────────────────────

Crie ou atualize templates quando a fonte trouxer novos artefatos.

Local possível:

```text
AgenteXX_Nome/templates/
templates/
docs/templates/
```

Templates devem ter:

- título claro;
- campos obrigatórios;
- instruções de preenchimento;
- exemplos de valores;
- relação com gate;
- owner agent;
- critérios de aceite.

Exemplo de template:

```md
# [Artifact Name]

## Objetivo

## Escopo

## Entradas

## Saídas

## Premissas

## Riscos

## Critérios de aceite

## Checklist de validação

## Handoff Package
```

────────────────────────────────────────
14. Atualizar schemas
────────────────────────────────────────

Crie ou atualize schemas quando a fonte impactar contratos.

Local possível:

```text
AgenteXX_Nome/schemas/
schemas/
```

Schemas devem:

- ser JSON Schema válido;
- conter `title`, `description`, `type`;
- definir `required`;
- usar enums quando aplicável;
- conter descrições nos campos;
- manter compatibilidade quando possível;
- atualizar exemplos relacionados.

Se adicionar campos como `project_archetype`, `golden_model`, `source_refs`, `evidence`, `risk_level`, `gate_status`, atualize templates e examples correspondentes.

────────────────────────────────────────
15. Atualizar examples
────────────────────────────────────────

Crie exemplos bons e ruins quando a fonte puder melhorar a qualidade dos outputs.

Local possível:

```text
AgenteXX_Nome/examples/
```

Exemplos bons devem mostrar:

- output completo;
- rastreabilidade;
- checklist cumprido;
- decisão clara;
- riscos explícitos;
- formato esperado.

Exemplos ruins devem mostrar:

- falha comum;
- por que está errado;
- como corrigir.

────────────────────────────────────────
16. Atualizar failure_modes.md
────────────────────────────────────────

Se a fonte revela novos modos de falha, atualizar:

```text
AgenteXX_Nome/failure_modes.md
```

Formato sugerido:

```md
## FMXXX — [Nome da falha]

**Sintoma:**  
[Como aparece]

**Causa provável:**  
[Por que acontece]

**Impacto:**  
[Consequência]

**Mitigação:**  
[Como prevenir/corrigir]

**Severidade:** LOW | MEDIUM | HIGH | CRITICAL

**Fonte destilada:**  
[fonte]
```

────────────────────────────────────────
17. Atualizar gates de qualidade
────────────────────────────────────────

Se a fonte afeta validação, governança ou critérios de aprovação, atualize:

```text
AgenteXX_Nome/quality_gate.md
```

Possíveis atualizações:

- novos critérios de bloqueio;
- novos status codes;
- critérios por arquétipo de projeto;
- critérios específicos para automação, dados, segurança, deploy, UX ou QA;
- regras de ADR;
- requisitos de evidência.

Garanta que gates continuem claros e verificáveis.

────────────────────────────────────────
18. Atualizar documentação global
────────────────────────────────────────

Atualize documentação quando a fonte altera práticas globais.

Possíveis arquivos:

- `README.md`
- `docs/GOLDEN_MODELS.md`
- `docs/PROJECT_ARCHETYPES.md`
- `docs/MCP_RAG.md`
- `docs/KNOWLEDGE_DISTILLATION.md`
- `docs/ADDING_KNOWLEDGE.md`
- `CLAUDE.md`

Se `docs/ADDING_KNOWLEDGE.md` não existir, crie um documento com este fluxo de destilação para futuras rodadas.

O README deve conter apenas um resumo e apontar para a documentação detalhada.

────────────────────────────────────────
19. Atualizar manifestos e índices
────────────────────────────────────────

Depois das alterações, atualize índices relevantes:

- `skills_manifest.md`
- `rag_manifest.json`
- `knowledge/source_map.json`
- qualquer índice em `build/`
- qualquer índice de arquivos gerados;
- README/docs se novos arquivos forem criados.

Se a fonte impacta o MCP/RAG, garanta que os novos caminhos entram na configuração de ingestão.

────────────────────────────────────────
20. Atualizar MCP/RAG
────────────────────────────────────────

Se o repositório tiver `knowledge-config.json`, `update-knowledge.ps1` ou ferramenta MCP:

- garanta que novos arquivos serão indexados;
- inclua novos diretórios/padrões se necessário;
- preserve `knowledge.db` como artefato gerado;
- não hardcode caminhos pessoais;
- respeite `FACTORY_ROOT` se existir.

Se seguro, execute:

```powershell
.\update-knowledge.ps1
```

Se não for seguro executar, informe que deve ser executado após revisão.

────────────────────────────────────────
21. Gerar relatório de destilação
────────────────────────────────────────

Crie um relatório em `build/`, por exemplo:

```text
build/knowledge_distillation_report_YYYYMMDD.md
```

O relatório deve conter:

1. Resumo executivo.
2. Fontes processadas.
3. Fontes ignoradas e motivo.
4. Agentes impactados.
5. Arquivos criados.
6. Arquivos alterados.
7. Principais conceitos destilados.
8. Novas regras adicionadas.
9. Novas skills/checklists/templates/schemas.
10. Possíveis conflitos com conhecimento existente.
11. Decisões tomadas.
12. Limitações.
13. Próximas ações recomendadas.
14. Se `update-knowledge.ps1` foi executado.
15. Se é necessário rodar `install.ps1`.

────────────────────────────────────────
22. Critérios de qualidade da destilação
────────────────────────────────────────

A destilação só é boa se produzir conhecimento:

- operacional;
- acionável;
- rastreável;
- não redundante;
- consistente com a arquitetura dos agentes;
- compatível com runtime;
- verificável por checklist/gate;
- sem trechos longos copiados;
- sem segredos;
- aplicável por agente;
- indexável pelo MCP/RAG.

Evite outputs que sejam apenas resumos abstratos.

Sempre que possível, converta conhecimento em:

- regra;
- checklist;
- template;
- schema;
- skill;
- exemplo;
- gate;
- failure mode.

────────────────────────────────────────
23. Regras de conflito e precedência
────────────────────────────────────────

Se a nova fonte conflitar com conhecimento existente:

1. Não sobrescreva silenciosamente.
2. Registre o conflito no relatório.
3. Compare:
   - autoridade da fonte;
   - data;
   - aplicabilidade;
   - agente afetado;
   - arquétipo de projeto;
   - risco.
4. Se o conflito for técnico e relevante, crie proposta de ADR ou registre como decisão pendente.
5. Se o conflito for apenas complementar, incorpore como nuance.
6. Se a nova fonte for inferior ou menos aplicável, registre como não adotada.

Precedência sugerida:

1. Regras de segurança, privacidade e compliance.
2. Golden Models e gates oficiais.
3. Contratos/schemas.
4. Knowledge destilado validado.
5. Playbooks internos.
6. Fontes bibliográficas.
7. Preferências estilísticas.

────────────────────────────────────────
24. Regras para não quebrar instalação global
────────────────────────────────────────

Ao final, verifique se as mudanças não quebram:

```powershell
.\install.ps1
.\update-knowledge.ps1
```

Se você alterar prompts, knowledge essencial, skills, schemas, templates ou checklists, informe que o usuário deve rodar:

```powershell
.\update-knowledge.ps1
.\install.ps1
```

ou, se o instalador já chama update automaticamente:

```powershell
.\install.ps1
```

Garanta que novos arquivos relevantes sejam contemplados pela indexação do MCP/RAG.

────────────────────────────────────────
25. Saída esperada da sua execução
────────────────────────────────────────

Ao final, responda com:

```md
# Resultado da Destilação de Conhecimento

## Fontes processadas
- ...

## Agentes impactados
- ...

## Arquivos criados
- ...

## Arquivos alterados
- ...

## Conhecimento destilado
### Princípios
- ...

### Heurísticas
- ...

### Decision Rules
- ...

### Knowledge Cards
- ...

### Skills
- ...

### Checklists
- ...

### Templates
- ...

### Schemas
- ...

### Failure Modes
- ...

## Conflitos ou limitações
- ...

## Validação executada
- ...

## Próximos passos
- Rodar `.\update-knowledge.ps1`
- Rodar `.\install.ps1`, se aplicável
```

────────────────────────────────────────
26. Comando final esperado para o usuário
────────────────────────────────────────

Depois que você terminar as alterações, oriente o usuário a rodar:

```powershell
cd $env:FACTORY_ROOT
.\update-knowledge.ps1
.\install.ps1
```

Se o `install.ps1` já reindexar automaticamente, diga:

```powershell
cd $env:FACTORY_ROOT
.\install.ps1
```

────────────────────────────────────────
27. Lembrete final
────────────────────────────────────────

Não trate conhecimento novo como texto para colar no prompt.

Trate conhecimento novo como matéria-prima de build-time que deve ser transformada em artefatos operacionais da factory:

- `knowledge/`
- `skills/`
- `schemas/`
- `templates/`
- `checklists/`
- `examples/`
- `quality_gate.md`
- `failure_modes.md`
- `context_view.md`
- `source_map.json`
- documentação
- MCP/RAG indexável

O objetivo é que, depois da destilação, os agentes fiquem melhores em decidir, revisar, bloquear, orientar e executar — sem depender das fontes brutas em runtime.
