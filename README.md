# AI Software Factory — Multi-Agent SDLC Framework

Uma instalação multi-runtime de 12 agentes de IA especializados para o ciclo completo de desenvolvimento de software. Clone uma vez, instale, e use os mesmos papéis em Claude Code, Codex, Antigravity e GitHub Copilot.

Suporta **Claude Code** (`@nome`), **Codex** (custom agents/subagents), **Antigravity** (skills/subagents) e **GitHub Copilot** (prompt files e Agent mode MCP).

---

## Quick Start

```powershell
git clone https://github.com/eujeffoliveira/ai_software_factory
cd ai_software_factory

# Instalação interativa (detecta os ambientes presentes e pergunta o que instalar):
.\install.ps1

# Ou instale diretamente para runtimes específicos:
.\install.ps1 -Antigravity
.\install.ps1 -Copilot
.\install.ps1 -All
```

Abra um **novo terminal** e use os agentes:

```
# Claude Code
@techlead classifique o arquétipo deste projeto e conduza o fluxo SDLC
@po escreva o PRD para o módulo de autenticação
@architect proponha a arquitetura para a API de pagamentos
@qa crie os testes E2E Playwright para o fluxo de checkout
@devsecops revise este código por vulnerabilidades OWASP Top 10
@devops o deploy falhou — analise o log e proponha rollback

# Codex
Use the techlead custom agent to classify this project and propose the SDLC flow.
Spawn qa and devsecops as subagents and summarize their findings.

# Antigravity (AGY)
Ative a skill techlead para avaliar este projeto.
Invoque qa como subagente para auditar a cobertura de testes.

# GitHub Copilot (VS Code)
#file:techlead.prompt.md Avalie a aderencia ao Gate G0 deste projeto
#file:qa.prompt.md Elabore o plano de testes Vitest e Playwright
```

---

## Agentes disponíveis

| `@nome` | Agente | Papel | Produz |
|---------|--------|-------|--------|
| `@techlead` | Tech Lead | Orquestração, gates, ADRs, riscos | State_Ledger, Gate Decisions |
| `@po` | Product Owner | Requisitos, user stories, critérios de aceite | PRD.md |
| `@architect` | Software Architect | Arquitetura, stack, decisões técnicas | Architecture.md |
| `@engineer` | Software Engineer | Decomposição de tarefas, plano de execução | Execution_Plan.json |
| `@devbackend` | Dev Backend | APIs, banco de dados, lógica de negócio | Pull Request (backend) |
| `@devfrontend` | Dev Frontend | Componentes React, páginas Next.js, UI | Pull Request (frontend) |
| `@qa` | QA Engineer | Testes unitários, integração, E2E | QA_Report.md |
| `@devsecops` | DevSecOps | Auditorias OWASP, modelagem de ameaças | Security_Audit.md |
| `@devops` | DevOps | CI/CD, deploy, rollback, SRE | Deployment_Plan.md |
| `@uxui` | UX/UI Designer | Pesquisa, wireframes, design system | Design_Spec.md |
| `@dataengineer` | Data Engineer | Pipelines de dados, ETL, integrações | Integration_Plan.md |
| `@dataanalyst` | Data Analyst | Métricas, análise exploratória, insights | Insight_Report.md |

Ver descrição detalhada de cada agente em [`docs/AGENTS.md`](docs/AGENTS.md).

---

## Como funciona

A factory funciona como **instalação multi-runtime**: os agentes são gerados a partir das mesmas fontes para cada cliente.

Cada agente tem acesso a dois layers de conhecimento:

```
~/.claude/agents/<nome>.md                       ← Claude Code (@nome)
~/.codex/agents/<nome>.toml                      ← Codex custom agents
~/.gemini/config/plugins/ai-software-factory/    ← Antigravity skills
.github/prompts/<nome>.prompt.md                 ← GitHub Copilot prompt files
knowledge.db (SQLite FTS5)                       ← ~8.000 docs indexados via MCP sob demanda
```

O **Tech Lead** (`@techlead`) orquestra todos os outros agentes através de gates sequenciais (A0, 1–7). Nenhum agente avança sem o artefato obrigatório do gate anterior.

```
Humano → TechLead → PO (Gate 1) → Architect (Gate 2) → Engineer (Gate 3)
       → DevBackend + DevFrontend → QA (Gate 4) → DevSecOps (Gate 5)
       → [Aprovação humana] → DevOps (Gate 6) → Post-Deploy (Gate 7)
```

A factory suporta **8 arquétipos de projeto**: `web_app`, `automation_script`, `data_pipeline`, `api_service`, `cli_tool`, `mcp_server`, `integration_worker`, `notebook_analysis`. O Gate A0 classifica o arquétipo e seleciona o Golden Model correspondente.

---

## Pré-requisitos

| Requisito | Como verificar |
|-----------|---------------|
| Windows 10/11 | — |
| Python 3.x no PATH | `python --version` |
| Claude Code | `claude --version` |
| Codex | `codex --version` |
| Antigravity (AGY) | `agy --version` |
| GitHub Copilot / VS Code | VS Code instalado |

Linux/macOS: `install.sh` mantém o fluxo CLI legado; o instalador multi-runtime completo é o `install.ps1` no Windows.

---

## O que o instalador faz

`.\install.ps1` é **inteligente** e **idempotente**:
- **Detecção automática**: identifica quais ambientes estão presentes na máquina (Claude Code, Codex, Antigravity, GitHub Copilot).
- **Seleção interativa ou via flags**: pergunta quais você deseja instalar para evitar arquivos desnecessários (`-Antigravity`, `-Copilot`, `-Codex`, `-Claude`, `-All`).
- **Geração sob demanda**: apenas os agentes, skills, prompts e configurações MCP dos runtimes selecionados são gerados ou atualizados.

| Ação | Resultado (se runtime selecionado) |
|------|-----------------------------------|
| Define `FACTORY_ROOT` | Variável de ambiente de usuário Windows (sempre) |
| Instala 12 agentes Claude | `~/.claude/agents/<nome>.md` |
| Instala 12 custom agents Codex | `~/.codex/agents/<nome>.toml` |
| Instala plugin e 12 skills Antigravity | `~/.gemini/config/plugins/ai-software-factory/skills/` |
| Gera 12 prompt files e instruções Copilot | `.github/prompts/*.prompt.md` e `.github/copilot-instructions.md` |
| Cria `knowledge.db` | SQLite FTS5, ~8.000 documentos |
| Configura MCP global | `~/.claude.json`, `~/.codex/config.toml`, `~/.gemini/config/mcp_config.json`, `.vscode/mcp.json` |
| Gera scripts auxiliares | `update-knowledge.ps1`, `link-mcp.ps1` |

Após a instalação, reabra o terminal e verifique:

```powershell
.\doctor.ps1     # diagnóstico completo multi-runtime (respeita os runtimes instalados)
.\test-mcp.ps1   # health check do MCP (7 checks)
```

---

## Operação de projetos longos (opcional)

Para projetos multi-sprint, o Tech Lead mantém um **State Ledger** — um arquivo JSON que rastreia fase atual, artefatos aprovados, gates, ADRs, riscos e decisões.

```powershell
# Inicializar workspace .factory/ no projeto atual (opcional)
cd C:\meu-projeto
& "$env:FACTORY_ROOT\init-project.ps1"
```

Isso cria:

```
.factory/
├── State_Ledger.json   ← estado global do projeto (commit este arquivo)
├── project_profile.md  ← perfil do projeto para os agentes
├── artifacts/          ← PRD.md, Architecture.md, etc.
└── decisions/          ← gate decisions, ADRs
```

Use no início de cada sessão:

```
@techlead retome o projeto. Estado atual: [attach .factory/State_Ledger.json]
```

> **Para prompts simples não é necessário nenhum setup.** Use `init-project.ps1` apenas para projetos longos com múltiplos gates e agentes.

Ver: [`docs/PROJECT_OPERATION.md`](docs/PROJECT_OPERATION.md)

---

## Codex

Após `.\install.ps1`, os custom agents ficam disponíveis em `~/.codex/agents/`.
No Codex, peça explicitamente para usar ou spawnar o agente:

```text
Use the architect custom agent to review this design.
Spawn qa and devsecops as subagents, wait for both, then summarize risks.
```

O MCP `knowledge` é configurado em `~/.codex/config.toml`. Para vincular outro
projeto:

```powershell
cd meu-projeto
& "$env:FACTORY_ROOT\link-mcp.ps1"
```

Ver: [`docs/CODEX.md`](docs/CODEX.md)

---

## Antigravity

Após `.\install.ps1 -Antigravity` (ou via seleção interativa), as 12 skills ficam instaladas em `~/.gemini/config/plugins/ai-software-factory/skills/`.
No Google Antigravity, acione as skills diretamente pelo nome ou invoque subagentes:

```text
Ative a skill techlead para avaliar os quality gates deste projeto.
Use a skill qa para elaborar os testes unitários e de integração.
Invoque techlead e architect como subagentes para refinarem a solução.
```

O MCP `knowledge` fica disponível como ferramentas nativas (`mcp_knowledge_search_knowledge`, `mcp_knowledge_get_full_document`, etc.).

Ver: [`docs/ANTIGRAVITY.md`](docs/ANTIGRAVITY.md)

---

## GitHub Copilot

Após `.\install.ps1 -Copilot` (ou via seleção interativa):
1. A **extensão global do VS Code** é instalada em `~/.vscode/extensions/ai-software-factory.agents/`, disponibilizando os 12 agentes em **qualquer projeto ou pasta** aberto no VS Code via `@<nome>` no Copilot Chat:
   ```text
   @techlead Avalie a aderencia ao Gate G0 deste projeto
   @qa Elabore o plano de testes Vitest e Playwright
   @architect Desenhe o diagrama C4 de componentes e avalie necessidade de ADR
   ```
2. Prompt files e instruções são gerados em `.github/prompts/` e `.github/copilot-instructions.md` (uso via `#file:` no repositório).
3. No modo Agent do Copilot Chat, as ferramentas MCP são chamadas automaticamente tanto globalmente (`%APPDATA%\Code\User\mcp.json`) quanto no workspace (`.vscode/mcp.json`).

Ver: [`docs/COPILOT.md`](docs/COPILOT.md)

---

## Atualização

```powershell
cd $env:FACTORY_ROOT
git pull
.\install.ps1          # propagates changes to agents and knowledge.db
```

Editou só arquivos de knowledge (sem mexer em `prompt.md`)?

```powershell
.\update-knowledge.ps1  # reindexes without reinstalling agents
```

---

## Documentação

| Documento | Conteúdo |
|-----------|----------|
| [`docs/INSTALLATION.md`](docs/INSTALLATION.md) | Instalação detalhada, fases, idempotência, uninstall |
| [`docs/OPERATIONS.md`](docs/OPERATIONS.md) | Uso do dia-a-dia, atualização, diagnóstico, múltiplas factories |
| [`docs/AGENTS.md`](docs/AGENTS.md) | Referência dos 12 agentes: papel, quando chamar, artefatos, exemplos |
| [`docs/AGENT_CAPABILITY_MATRIX.md`](docs/AGENT_CAPABILITY_MATRIX.md) | Matriz agente × capacidade × gate × arquétipo |
| [`docs/GOLDEN_MODELS.md`](docs/GOLDEN_MODELS.md) | 8 arquétipos com stack técnica obrigatória |
| [`docs/PROJECT_ARCHETYPES.md`](docs/PROJECT_ARCHETYPES.md) | Gate A0, classificação, ADR vs. não-ADR |
| [`docs/MCP_RAG.md`](docs/MCP_RAG.md) | knowledge.db, MCP-first, ferramentas, logs, troubleshooting |
| [`docs/CODEX.md`](docs/CODEX.md) | Codex custom agents, MCP e limitações |
| [`docs/ANTIGRAVITY.md`](docs/ANTIGRAVITY.md) | Antigravity skills, subagentes, MCP e regras |
| [`docs/COPILOT.md`](docs/COPILOT.md) | GitHub Copilot prompt files, instruções e MCP |
| [`docs/ADDING_KNOWLEDGE.md`](docs/ADDING_KNOWLEDGE.md) | Distilação de conhecimento, source_map.json, comandos |
| [`docs/CLIENT_COMPATIBILITY.md`](docs/CLIENT_COMPATIBILITY.md) | Claude Code, Codex, Antigravity, GitHub Copilot |
| [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) | Problemas comuns e soluções |
| [`docs/TESTING.md`](docs/TESTING.md) | Factory validators, pytest MCP, doctor.ps1, test-mcp.ps1 |
| [`docs/PROJECT_OPERATION.md`](docs/PROJECT_OPERATION.md) | State Ledger, .factory/, init-project, gates, riscos, ADRs |
| [`docs/EVALUATION.md`](docs/EVALUATION.md) | Smoke prompts, eval cases, rubricas, prevenção de regressão |
| [`CHANGELOG.md`](CHANGELOG.md) | Histórico de versões |
| [`RELEASE_NOTES.md`](RELEASE_NOTES.md) | Notas da versão atual |

### Recipes — fluxos prontos para uso

| Recipe | Arquétipo |
|--------|-----------|
| [`docs/recipes/criar-web-app.md`](docs/recipes/criar-web-app.md) | `web_app` |
| [`docs/recipes/criar-automacao-python.md`](docs/recipes/criar-automacao-python.md) | `automation_script` |
| [`docs/recipes/criar-pipeline-dados.md`](docs/recipes/criar-pipeline-dados.md) | `data_pipeline` |
| [`docs/recipes/criar-mcp-server.md`](docs/recipes/criar-mcp-server.md) | `mcp_server` |
| [`docs/recipes/revisar-projeto-existente.md`](docs/recipes/revisar-projeto-existente.md) | Qualquer |
| [`docs/recipes/gerar-plano-de-testes.md`](docs/recipes/gerar-plano-de-testes.md) | Qualquer |
| [`docs/recipes/auditar-seguranca.md`](docs/recipes/auditar-seguranca.md) | Qualquer |
| [`docs/recipes/adicionar-novo-conhecimento.md`](docs/recipes/adicionar-novo-conhecimento.md) | Factory |

---

## Instanciar para uma organização

Este repositório é **white-label** — sem referências a organizações ou domínios específicos.

```
1. Fork  →  2. Clone  →  3. Preencher context/client_profile.md
→  4. Executar context/prompts/instantiation_prompt.md
→  5. Commit  →  6. .\install.ps1
```

---

## Licenciamento e contribuição

Este repositório usa licenciamento duplo:

- **Código, scripts, ferramentas MCP, instaladores e automações**: Apache License 2.0
- **Documentação, prompts, templates, playbooks, checklists, examples e knowledge artifacts**: Creative Commons Attribution 4.0 International (CC BY 4.0), salvo indicação em contrário

Consulte [`LICENSE`](LICENSE), [`LICENSE-DOCS`](LICENSE-DOCS) e [`NOTICE`](NOTICE).

Contribuições são bem-vindas. Antes de abrir PR, leia:

- [`CONTRIBUTING.md`](CONTRIBUTING.md) — setup, tipos de contribuição, checklist de PR
- [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) — padrões de conduta da comunidade
- [`SECURITY.md`](SECURITY.md) — política de secrets e divulgação responsável
- [`SUPPORT.md`](SUPPORT.md) — como reportar problemas e onde pedir ajuda
