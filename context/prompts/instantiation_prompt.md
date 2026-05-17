# Prompt de Instanciação — AI Software Factory
> Execute este prompt no Claude Code após clonar o repositório e preencher `context/client_profile.md`.
> Objetivo: adaptar os artefatos genéricos dos agentes ao contexto específico da organização.

---

## Pré-condições obrigatórias

Antes de executar qualquer passo, verifique:

1. `context/client_profile.md` existe e está preenchido (nenhum campo obrigatório em branco).
2. As pastas dos agentes marcados como `true` no perfil já existem no repositório.
3. Cada pasta de agente ativo possui ao menos `prompt.md` e `agent_config.json`.

Se qualquer pré-condição falhar, interrompa e relate o problema ao usuário antes de prosseguir.

---

## Fontes de leitura

Leia os seguintes arquivos antes de iniciar qualquer geração:

```
context/client_profile.md              ← fonte de verdade da instanciação
context/reference_architecture_generico.md  ← Golden Model base (padrão)
context/manual_arquitetura_componentes_generico.md  ← contratos e estrutura
context/integrantes.md                 ← papéis e responsabilidades dos agentes
```

Não leia nem modifique arquivos em `lib/`. Não leia arquivos `_raiz.md` — eles são exemplos de
instanciação já realizada, não fontes normativas.

---

## Pipeline de Instanciação

Execute as etapas na ordem abaixo. Marque cada etapa como concluída antes de avançar.

### Etapa 1 — Leitura e validação do perfil

1. Leia `context/client_profile.md` completamente.
2. Extraia e registre internamente os valores de cada seção.
3. Identifique os agentes ativos (campo `true` na Seção 6).
4. Identifique os desvios do Golden Path (Seção 3 — campos preenchidos).
5. Identifique integrações externas (Seção 4).
6. Identifique restrições regulatórias (Seção 5).
7. Produza `build/instantiation_plan.md` com um resumo do que será alterado por agente.

### Etapa 2 — Instanciação de `agent_config.json` por agente

Para cada agente ativo, atualize `AgenteXX_*/agent_config.json`:

- Substitua o nome da organização no campo `organization` (ou equivalente).
- Atualize a seção `golden_model` com os valores da Seção 3 do perfil:
  - `auth_provider`
  - `database_host`
  - `deploy_platform`
  - `email_provider`
  - `apm_tool`
  - `cron_platform`
  - `extra_packages` (adicione ao array existente, não substitua)
- Adicione as integrações externas da Seção 4 ao campo `known_integrations` (crie se não existir).
- Adicione as categorias de dados sensíveis da Seção 5 ao campo `sensitive_data_categories`.
- Não remova campos existentes que não foram afetados pelo perfil.

### Etapa 3 — Instanciação de `context_view.md` por agente

Para cada agente ativo, atualize `AgenteXX_*/context_view.md`:

- Substitua todas as ocorrências de `[ORGANIZAÇÃO]` / `[ORG]` / `genérico` pelo nome da organização.
- Injete um bloco de contexto organizacional no início da seção de contexto, com:
  - nome e tipo da organização
  - domínio de negócio
  - idioma principal
  - desvios do Golden Path aprovados
- Para `Agente05_DevFrontend`: injete os tokens de design (cores, dark mode, component library) na
  seção de design system.
- Para `Agente07_DevSecOps`: injete as categorias de dados sensíveis e frameworks regulatórios na
  seção de segurança e privacidade.
- Para `Agente08_DevOps`: injete a plataforma de deploy, APM e cron na seção de infraestrutura.

### Etapa 4 — Instanciação de `prompt.md` por agente

Para cada agente ativo, atualize `AgenteXX_*/prompt.md`:

- Substitua referências genéricas à organização pelo nome real.
- Se o perfil define `internal_systems_name`, substitua referências a "sistemas internos" por esse valor.
- Não altere a estrutura, as regras operacionais, os gates nem os critérios de qualidade —
  esses são invariantes do agente e não são customizados por organização.

### Etapa 5 — Atualização de `knowledge/` por agente

Para cada agente ativo que possui pasta `knowledge/`:

**`knowledge/principles.md`:**
- Se o perfil define frameworks regulatórios além de LGPD, adicione um princípio de compliance
  ao final da lista (ex: `P_COMPLIANCE — Conformidade com [framework]`).
- Não renumere princípios existentes — adicione ao final.

**`knowledge/knowledge_cards.md`:**
- Para `Agente05_DevFrontend`: adicione um card com os tokens de design da organização.
- Para `Agente07_DevSecOps`: adicione um card com as categorias de dados sensíveis e as regras
  de privacidade específicas da organização.
- Para `Agente10_DataIntegrationEngineer` (se ativo): adicione cards para cada integração
  externa listada na Seção 4 do perfil.

**`knowledge/decision_rules.md`:**
- Para `Agente00_TechLead`: adicione regras de decisão para os desvios do Golden Path aprovados
  (ex: `DR_CLIENT_001 — Se deploy fora da Vercel, exigir ADR de infraestrutura`).
- Não renumere regras existentes — adicione ao final com prefixo `DR_CLIENT_`.

### Etapa 6 — Geração do relatório de instanciação

Produza `build/instantiation_report.md` com:

```markdown
# Relatório de Instanciação — [organization_name]

## Data
[data de execução]

## Perfil aplicado
- Organização: ...
- Agentes instanciados: ...
- Desvios do Golden Path: ...
- Integrações: ...
- Frameworks regulatórios: ...

## Alterações por agente
| Agente | Arquivos alterados | Customizações aplicadas |
|---|---|---|
| Agente00_TechLead | ... | ... |
...

## Pendências
[liste qualquer campo do perfil que ficou em branco e pode exigir revisão futura]

## Como atualizar
Para atualizar a instanciação no futuro (ex: mudança de stack, nova integração):
1. Edite `context/client_profile.md`.
2. Re-execute este prompt.
3. O prompt é idempotente — ele sobrescreve apenas o que está mapeado ao perfil.
```

---

## Regras de idempotência

Este prompt pode ser executado múltiplas vezes sem efeitos colaterais indesejados:

- Valores já corretos não são reescritos (compare antes de escrever).
- Campos adicionados em execuções anteriores com prefixo `DR_CLIENT_` ou `P_COMPLIANCE` não são
  duplicados — verifique a existência antes de inserir.
- O relatório de instanciação é sempre sobrescrito com a versão mais recente.
- `build/instantiation_plan.md` é sempre sobrescrito.

---

## Restrições

- **Não** crie novos agentes — instancie apenas os que já existem no repositório.
- **Não** altere a estrutura de pastas dos agentes.
- **Não** modifique gates, status codes nem critérios de qualidade nos arquivos `quality_gate.md`.
- **Não** modifique schemas JSON (`*.schema.json`) — eles são contratos estruturais invariantes.
- **Não** modifique checklists de skills — eles são procedimentais e não dependem de contexto.
- **Não** acesse `lib/` durante a instanciação.
- **Não** leia nem use arquivos `*_raiz.md` como referência — eles são exemplos de instanciação,
  não templates normativos.
- Se um arquivo de agente não existir (pasta esqueleto incompleta), registre a lacuna no relatório
  e pule o agente — não crie arquivos parciais.

---

## Exemplo de execução esperada

Ao final da execução, o usuário deve ter:

```
build/
  instantiation_plan.md
  instantiation_report.md

AgenteXX_*/
  prompt.md                ← nome da organização injetado
  agent_config.json        ← golden_model e integrações atualizados
  context_view.md          ← contexto organizacional injetado
  knowledge/
    principles.md          ← princípios de compliance adicionados (se aplicável)
    knowledge_cards.md     ← cards de design system / integrações adicionados (se aplicável)
    decision_rules.md      ← regras DR_CLIENT_ adicionadas (Agente00, se aplicável)
```

Nenhum outro arquivo deve ser alterado.
