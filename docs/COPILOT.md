# GitHub Copilot — AI Software Factory Integration

Este documento descreve como utilizar a **AI Software Factory** com o **GitHub Copilot** no VS Code, cobrindo o uso global em qualquer projeto e o uso local por workspace.

---

## 1. Visao Geral da Arquitetura

A integracao com o GitHub Copilot e sustentada por pilares canonicamente gerados pelo `install.ps1`:

| Componente | Localizacao | Alcance | Funcao |
|---|---|---|---|
| **User Custom Agents** | `~/.copilot/agents/*.agent.md` | **Global** (qualquer projeto) | Agentes customizados nativos do VS Code Copilot disponiveis no seletor de Agentes (`Agent` dropdown) e mencoes `@<nome>` em qualquer workspace |
| **Workspace Custom Agents** | `.github/agents/*.agent.md` | Workspace atual | Agentes customizados especificos do workspace da factory |
| **Instrucoes Globais** | `.github/copilot-instructions.md` | Workspace atual | Regras do SDLC, Quality Gates, State Ledger, ADR policy e isolamento de runtime injetados automaticamente no contexto do Copilot |
| **Prompt Files Reutilizaveis** | `.github/prompts/*.prompt.md` | Workspace atual | Personas completas dos 12 agentes com conhecimento destilado para invocacao sob demanda via `#file:` no Copilot Chat |
| **MCP Knowledge Server** | `.vscode/mcp.json` (workspace) & `%APPDATA%\Code\User\mcp.json` (global) | Workspace e Global | Configuracao do servidor MCP `knowledge` para consulta semantica de conhecimento no VS Code Copilot Agent mode em qualquer projeto |

---

## 2. Como Funcionam os User Custom Agents Nativos (`~/.copilot/agents/`)

O GitHub Copilot no VS Code possui suporte de primeira classe a **Custom Agents de Usuario**. Arquivos com extensao `.agent.md` colocados no diretorio global do usuario (`~/.copilot/agents/`) sao descobertos e carregados automaticamente pelo Copilot em **qualquer janela, pasta ou projeto**:

```text
~/.copilot/agents/
  techlead.agent.md                   # Definicao completa do Tech Lead
  po.agent.md                         # Definicao completa do PO
  architect.agent.md                  # Definicao completa do Architect
  engineer.agent.md                   # Definicao completa do Engineer
  devbackend.agent.md                 # Definicao completa do Dev Backend
  devfrontend.agent.md                # Definicao completa do Dev Frontend
  qa.agent.md                         # Definicao completa do QA
  devsecops.agent.md                  # Definicao completa do DevSecOps
  devops.agent.md                     # Definicao completa do DevOps
  uxui.agent.md                       # Definicao completa do UX/UI
  dataengineer.agent.md               # Definicao completa do Data Engineer
  dataanalyst.agent.md                # Definicao completa do Data Analyst
  .ai_software_factory_manifest.json  # Rastreamento de versoes e hashes
```

### Por que usar User Custom Agents em vez de Extensao?
1. **Zero Duplicacao**: Nao ha registro duplicado de agentes no dropdown de chats nem no menu `@`.
2. **Isolamento de Runtimes**: Outros editores baseados no VS Code (como Antigravity IDE) nao herdam agentes indesejados da pasta de extensoes.
3. **Nativo do Copilot**: O formato `.agent.md` e a especificacao oficial recomendada pela Microsoft/GitHub para custom agents, com controle de tools e prompts por arquivo Markdown com frontmatter.

### Formato dos Arquivos `.agent.md`

Cada agente possui um cabecalho YAML com ferramentas permitidas (`tools`), descricao e o corpo completo com as diretrizes e conhecimento destilado da factory:

```markdown
---
name: techlead
description: >-
  Tech Lead e orquestrador do SDLC — quality gates, ADRs, decisoes tecnicas e oversight do projeto
tools: [vscode, tool_search, execute, read, agent, browser, edit, search, web, knowledge/*]
---

<!-- BEGIN ai_software_factory managed block -->
...
<!-- END ai_software_factory managed block -->
```

Como resultado, os agentes ficam disponiveis no VS Code Copilot Chat em **qualquer janela, pasta ou projeto** que voce abrir.

---

## 3. Instalacao e Configuracao

A fonte da verdade de todos os agentes reside nas pastas canonicas `AgenteXX_RoleName/`. Para gerar ou atualizar os artefatos do GitHub Copilot:

```powershell
# Instalacao direta para GitHub Copilot:
.\install.ps1 -Copilot

# Ou atraves do instalador interativo inteligente:
.\install.ps1
```

O `install.ps1` detecta o ambiente do VS Code / Copilot e executa automaticamente:
1. Criacao dos 12 Custom Agents globais do usuario em `~/.copilot/agents/*.agent.md` (autorizando ferramentas `knowledge/*`).
2. Limpeza automatica e auto-healing da extensao legada em `~/.vscode/extensions/ai-software-factory.agents/` (prevenindo duplicacoes).
3. Criacao dos 12 Custom Agents do workspace em `.github/agents/*.agent.md`.
4. Criacao/atualizacao de `.github/copilot-instructions.md` no workspace.
5. Geracao dos 12 arquivos de prompt em `.github/prompts/<nome>.prompt.md`.
6. Configuracao do servidor MCP em `.vscode/mcp.json` (workspace) e em `%APPDATA%\Code\User\mcp.json` (global do usuario).
7. Registro dos manifestos de rastreamento com integridade SHA256.
8. Configuracao em `settings.json` do VS Code para desativar a descoberta de agentes do Claude no Copilot (`chat.agentHost.claudeAgent.enabled: false`), prevenindo duplicacao caso `~/.claude/agents/` tambem esteja instalada para o Claude Code CLI.

Para validar a integracao:

```powershell
.\doctor.ps1
```

A secao **7C. GitHub Copilot — Prompt Files & Instructions** e a secao **10. MCP Configuracao** devem reportar status `[OK]`.

---

## 4. Os 12 Agentes Disponiveis

| Papel | Arquivo Global (`~/.copilot/agents/`) | Arquivo Prompt (`.prompt.md`) | Descricao |
|---|---|---|---|
| `techlead` | `techlead.agent.md` | `.github/prompts/techlead.prompt.md` | Tech Lead, orquestrador do SDLC, validacao de Quality Gates, ADRs, State Ledger |
| `po` | `po.agent.md` | `.github/prompts/po.prompt.md` | Product Owner, PRD, user stories, criterios de aceitacao e backlog |
| `architect` | `architect.agent.md` | `.github/prompts/architect.prompt.md` | Arquiteto de Software, design de sistemas, diagramas UML, decisoes e ADRs |
| `engineer` | `engineer.agent.md` | `.github/prompts/engineer.prompt.md` | Engenheiro de Software, decomposicao de tarefas, planos e estimativas |
| `devbackend` | `devbackend.agent.md` | `.github/prompts/devbackend.prompt.md` | Dev Backend, APIs REST, servicos, banco de dados, migrations Prisma |
| `devfrontend` | `devfrontend.agent.md` | `.github/prompts/devfrontend.prompt.md` | Dev Frontend, componentes React, paginas Next.js, UI Tailwind |
| `qa` | `qa.agent.md` | `.github/prompts/qa.prompt.md` | QA Engineer, estrategia de testes, Vitest, Playwright E2E e cobertura |
| `devsecops` | `devsecops.agent.md` | `.github/prompts/devsecops.prompt.md` | DevSecOps, auditorias de seguranca, SAST, OWASP Top 10, hardening |
| `devops` | `devops.agent.md` | `.github/prompts/devops.prompt.md` | DevOps, CI/CD, infraestrutura Vercel, deployment e runbooks |
| `uxui` | `uxui.agent.md` | `.github/prompts/uxui.prompt.md` | UX/UI Designer, pesquisa de usuario, wireframes, design system |
| `dataengineer` | `dataengineer.agent.md` | `.github/prompts/dataengineer.prompt.md` | Data Engineer, pipelines de dados, ETL, integracoes e governanca |
| `dataanalyst` | `dataanalyst.agent.md` | `.github/prompts/dataanalyst.prompt.md` | Data Analyst, metricas, analise exploratoria, insights e dashboards |

---

## 5. Como Usar no VS Code

### Modo 1: Seletor de Agentes no Chat (`Agent` dropdown / Personalizacoes do Agente) — *Nativo do VS Code*

O VS Code conta com suporte nativo a **Custom Agents** no painel de Chat:
1. Na barra de entrada do Chat do VS Code, clique no botao do modo atual (ex: `Agent`, `Ask` ou `Plan`).
2. O menu suspenso listara diretamente todos os 12 agentes da factory:
   - `techlead`, `po`, `architect`, `engineer`, `devbackend`, `devfrontend`, `qa`, `devsecops`, `devops`, `uxui`, `dataengineer`, `dataanalyst`.
3. Ao selecionar um agente (por exemplo, `techlead`), o chat passa a operar com aquela persona ativa, carregando automaticamente suas diretrizes, restricoes do SDLC e ferramentas de MCP Knowledge.
4. No menu **Configurar Agentes Personalizados...** (ou tela **Personalizacoes do Agente**), eles aparecem registrados sob **Usuario (12)** via `~/.copilot/agents/*.agent.md` (e no workspace via `.github/agents/*.agent.md`).

### Modo 2: Mencoes no Copilot Chat (`@nome`) — *Atalho rapido*

Os agentes customizados em `~/.copilot/agents/` tambem estao acessiveis via mencao direta `@`:

1. Abra o painel do Copilot Chat (`Ctrl+Alt+I` ou `Ctrl+I`).
2. Digite `@` para ver a lista de agentes participantes. Os agentes da factory aparecerao disponiveis:
   ```text
   @techlead Avalie o PRD e verifique se podemos aprovar a transicao do Gate G0 para G1.
   @qa Qual e o plano de testes recomendado para esta API de pagamentos?
   @architect Desenhe a arquitetura de servicos e defina se precisamos de um ADR para cache.
   ```
3. O agente assume sua persona, diretrizes de qualidade, restricoes do SDLC e padroes de entrega.

### Modo 3: Reusable Prompt Files (`#file:`)

Dentro do repositorio da factory (ou em qualquer projeto que tenha copiado a pasta `.github/prompts/`):

1. No Copilot Chat, anexe o arquivo usando `#file:`:
   ```text
   #file:techlead.prompt.md Avalie a conformidade do Quality Gate G2 para o plano atual.
   ```

### Modo 4: VS Code Copilot Agent Mode com MCP

No modo Agent do VS Code, o Copilot tem permissao para chamar ferramentas (tool calling) automaticamente. Com o arquivo `.vscode/mcp.json` configurado, ele pode acessar diretamente o MCP `knowledge`:

- `search_knowledge`: Pesquisa em toda a base da factory.
- `search_with_filters`: Pesquisa filtrada por categoria ou metadados.
- `get_full_document`: Leitura de artefatos inteiros (schemas, templates, playbooks).
- `get_context`: Leitura de secoes adjacentes.
- `knowledge_stats`: Estatisticas da base indexada.
- `health_check`: Verificacao de conectividade do MCP.

Exemplo de interacao no Agent mode:
```text
Consulte o servidor MCP knowledge para encontrar o template de ADR e o checklist de revisao de seguranca para Gate G4.
```

---

## 6. Vinculando o MCP a Projetos Externos
 
Com a instalacao do `install.ps1`, tanto os custom agents globais de usuario (`~/.copilot/agents/*.agent.md`) quanto o servidor MCP de conhecimento (`servers.knowledge` em `%APPDATA%\Code\User\mcp.json`) ja estao configurados globalmente. Isso significa que o Copilot tem acesso automatico as ferramentas MCP e aos agentes em **qualquer janela, pasta ou projeto** aberto no VS Code!

Caso voce deseje configurar explicitamente um arquivo `.vscode/mcp.json` especifico na raiz de um projeto consumidor (por exemplo, para versionar a configuracao ou permitir que outros membros da equipe usem):

```powershell
# Abra o terminal no diretorio do projeto consumidor e execute:
& "$env:FACTORY_ROOT\link-mcp.ps1"
```

O script criara/atualizara `.vscode/mcp.json` local com a conexao para o servidor MCP `knowledge` da factory.

Caso tambem queira que o Copilot siga as regras completas de engenharia da factory no projeto consumidor via `.github/copilot-instructions.md`:

```powershell
# Opcional: copiar instrucoes para o projeto consumidor
Copy-Item "$env:FACTORY_ROOT\.github\copilot-instructions.md" .github\copilot-instructions.md
```

---

## 7. Regras de Ouro e Boas Praticas

1. **Quality Gates sao Bloqueantes**:
   - Cada gate (G0 a G6) exige os artefatos obrigatorios aprovados antes de prosseguir.
   - O Tech Lead valida as transicoes.

2. **ADRs para Qualquer Mudanca Estrutural**:
   - Escolha de libs, bancos, frameworks ou design patterns exige criacao de documento em `docs/adr/ADR-*.md`.

3. **Politica MCP-First**:
   - O Copilot deve prioritariamente consultar as ferramentas MCP para validar regras e templates.
   - Caso o MCP esteja desconectado, o fallback via leitura de arquivo deve ser declarado explicitamente.

4. **Isolamento de Fontes**:
   - Nunca instrua o Copilot a ler `context/` ou `lib/` durante tarefas de desenvolvimento comuns (runtime). Essas pastas sao reservadas para a fase de construcao (build-time) da factory.

---

## 8. Desinstalacao

Para remover todos os componentes gerados para o GitHub Copilot e VS Code:

```powershell
cd $env:FACTORY_ROOT

# Simular a remocao (preview seguro):
.\uninstall.ps1 -WhatIf

# Executar a desinstalacao:
.\uninstall.ps1
```

O `uninstall.ps1`:
- Remove os agentes do usuario em `~/.copilot/agents/*.agent.md`
- Remove os agentes do workspace em `.github/agents/*.agent.md`
- Remove a extensao legada caso ainda exista em `~/.vscode/extensions/ai-software-factory.agents/`
- Remove os prompt files em `.github/prompts/*.prompt.md` e `.github/copilot-instructions.md`
- Remove as entradas do servidor MCP `knowledge` em `.vscode/mcp.json` e `%APPDATA%\Code\User\mcp.json`.
