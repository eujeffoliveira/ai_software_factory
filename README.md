# AI Software Factory — Multi-Agent SDLC Framework

Uma instalação global de 11 agentes de IA especializados para o ciclo completo de desenvolvimento de software. Clone uma vez, instale, e use `@techlead`, `@qa`, `@architect` em qualquer projeto — sem copiar nada.

Suporta **Claude Code** (`@nome`) e **Roo Code / Cline** (custom modes no VS Code).

---

## Quick Start

```powershell
git clone https://github.com/jeffersonoliveira/ai_software_factory
cd ai_software_factory
.\install.ps1
```

Abra um **novo terminal** e use os agentes em qualquer projeto:

```
@techlead classifique o arquétipo deste projeto e conduza o fluxo SDLC
@po escreva o PRD para o módulo de autenticação
@architect proponha a arquitetura para a API de pagamentos
@qa crie os testes E2E Playwright para o fluxo de checkout
@devsecops revise este código por vulnerabilidades OWASP Top 10
@devops o deploy falhou — analise o log e proponha rollback
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

Ver descrição detalhada de cada agente em [`docs/AGENTS.md`](docs/AGENTS.md).

---

## Como funciona

A factory funciona como **instalação global**: os agentes vivem em `~/.claude/agents/` e funcionam em qualquer diretório, sem configuração por projeto.

Cada agente tem acesso a dois layers de conhecimento:

```
~/.claude/agents/<nome>.md       ← prompt + 8 knowledge files embutidos (zero latência)
knowledge.db (SQLite FTS5)       ← ~7.000 docs indexados, acessados via MCP sob demanda
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
| Roo Code / Cline (opcional) | Extensão VS Code |

Linux/macOS: `install.sh` configura apenas aliases de CLI — sem agentes globais, sem MCP/RAG, sem Roo Code.

---

## O que o instalador faz

`.\install.ps1` é idempotente — pode rodar múltiplas vezes sem efeitos colaterais.

| Ação | Resultado |
|------|-----------|
| Define `FACTORY_ROOT` | Variável de ambiente de usuário Windows |
| Instala 11 agentes | `~/.claude/agents/<nome>.md` |
| Cria `knowledge.db` | SQLite FTS5, ~7.000 documentos |
| Configura MCP global | `~/.claude.json` + Roo Code `mcp_settings.json` |
| Gera modos Roo Code | `roo/.roomodes` + `roo/.clinerules` |
| Gera scripts auxiliares | `update-knowledge.ps1`, `link-mcp.ps1`, `link-roo.ps1` |

Após a instalação, reabra o terminal e verifique:

```powershell
.\doctor.ps1     # diagnóstico completo (14 categorias)
.\test-mcp.ps1   # health check do MCP (7 checks)
```

---

## Roo Code / Cline

Por projeto, uma vez após `.\install.ps1`:

```powershell
cd meu-projeto
& "$env:FACTORY_ROOT\link-roo.ps1"
```

Selecione o modo no painel do Roo Code (🏗️ Tech Lead, 📋 Product Owner, etc.).

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
| [`docs/AGENTS.md`](docs/AGENTS.md) | Referência dos 11 agentes: papel, quando chamar, artefatos, exemplos |
| [`docs/AGENT_CAPABILITY_MATRIX.md`](docs/AGENT_CAPABILITY_MATRIX.md) | Matriz agente × capacidade × gate × arquétipo |
| [`docs/GOLDEN_MODELS.md`](docs/GOLDEN_MODELS.md) | 8 arquétipos com stack técnica obrigatória |
| [`docs/PROJECT_ARCHETYPES.md`](docs/PROJECT_ARCHETYPES.md) | Gate A0, classificação, ADR vs. não-ADR |
| [`docs/MCP_RAG.md`](docs/MCP_RAG.md) | knowledge.db, MCP-first, ferramentas, logs, troubleshooting |
| [`docs/ROO_CODE.md`](docs/ROO_CODE.md) | Custom modes, link-roo.ps1, .roomodes, Cline |
| [`docs/ADDING_KNOWLEDGE.md`](docs/ADDING_KNOWLEDGE.md) | Distilação de conhecimento, source_map.json, comandos |
| [`docs/CLIENT_COMPATIBILITY.md`](docs/CLIENT_COMPATIBILITY.md) | Claude Code, Roo, Cline, Gemini CLI, uso manual |
| [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) | Problemas comuns e soluções |
| [`docs/TESTING.md`](docs/TESTING.md) | doctor.ps1, test-mcp.ps1, testes manuais |
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
