# AI Software Factory — Multi-Agent SDLC Framework

Uma fábrica de software orientada a agentes de IA especializados, onde cada etapa do ciclo de desenvolvimento é executada por um agente dedicado, com papéis, artefatos, contratos e gates de qualidade bem definidos.

---

## Índice

- [O que é](#o-que-é)
- [Como funciona](#como-funciona)
- [Arquitetura de Agentes](#arquitetura-de-agentes)
- [Ciclo de Vida de um Projeto](#ciclo-de-vida-de-um-projeto)
- [Gates de Qualidade](#gates-de-qualidade)
- [Artefatos e Contratos](#artefatos-e-contratos)
- [Golden Model — Stack Técnica Obrigatória](#golden-model--stack-técnica-obrigatória)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Universal Factory CLI](#universal-factory-cli)
- [Como os agentes funcionam na prática](#como-os-agentes-funcionam-na-prática)
- [MCP Knowledge Search](#mcp-knowledge-search)
- [Roo Code / Cline (VS Code)](#roo-code--cline-vs-code)
- [Como instanciar para uma organização](#como-instanciar-para-uma-organização)
- [Como criar um agente](#como-criar-um-agente)
- [Knowledge Distillation — Regra de Isolamento](#knowledge-distillation--regra-de-isolamento)
- [Fontes de Conhecimento](#fontes-de-conhecimento)
- [Estado atual dos agentes](#estado-atual-dos-agentes)

---

## O que é

A AI Software Factory é um framework de desenvolvimento de software baseado em **múltiplos agentes de IA especializados** que operam em pipeline sequencial. Cada agente tem:

- Um papel único e delimitado no ciclo de desenvolvimento
- Um prompt de sistema que define seu comportamento
- Um conjunto de skills com schemas de entrada/saída
- Checklists e exemplos de bons/maus outputs
- Conhecimento destilado de livros e referências técnicas
- Regras de isolamento de contexto (o agente só lê seus próprios artefatos locais em runtime)

O Tech Lead (Agente 00) é o orquestrador central: ele não executa trabalho técnico, mas coordena todos os outros agentes, valida handoffs, enforça gates de qualidade, registra riscos e escala para humanos quando necessário.

---

## Como funciona

```
Humano / Input
      │
      ▼
┌─────────────────────┐
│  Agente00_TechLead  │  ← Orquestrador / Presidente do Council
│  (sempre presente)  │
└────────┬────────────┘
         │ roteia para
    ┌────┴─────────────────────────────────────────────────────┐
    │                                                          │
    ▼                                                          ▼
Agente01_ProductOwner                               Agente02_SoftwareArchitect
    │                                                          │
    ▼                                                          ▼
  PRD.md ──── Gate 1 ────► Architecture.md ──── Gate 2 ────► Execution_Plan
                │                    │                            │
                │                    │                        Gate 3
                │                    │                            │
                │                    └──────── Agente03_SoftwareEngineer
                │                                                 │
                │                              Agente04_DevBackend │ Agente05_DevFrontend
                │                                        │         │
                │                                    Gate 4 (QA) ◄─┘
                │                                        │
                │                               Agente06_QaEngineer
                │                                        │
                │                                    Gate 5 (Security)
                │                                        │
                │                               Agente07_DevSecOps
                │                                        │
                │                                    Gate 6 (Deploy) ← Aprovação Humana obrigatória
                │                                        │
                │                               Agente08_DevOps
                │                                        │
                └──────────────────────────────── Gate 7 (Post-Deploy)
```

O fluxo é **sempre mediado pelo Tech Lead**. Nenhum agente fala diretamente com outro — cada entrega passa por validação do orquestrador antes de avançar.

### Regras estruturais

- **Nenhum gate avança sem o artefato obrigatório** daquele gate
- **RETURNED** sempre volta ao agente anterior, nunca pula para frente
- **Riscos CRITICAL sem mitigação** bloqueiam o gate atual
- **Decisões irreversíveis** requerem aprovação humana documentada
- **Qualquer desvio do Golden Model** requer ADR (Architecture Decision Record) aprovada antes de avançar

---

## Arquitetura de Agentes

| # | Agente | Papel | Artefato Obrigatório |
|---|--------|-------|----------------------|
| 00 | **Tech Lead** | Orquestrador, State Ledger, Gates, Council | — (orquestra, não produz) |
| 01 | **Product Owner** | Levantamento de requisitos, critérios de aceite | `PRD.md` |
| 02 | **Software Architect** | Decisões de arquitetura, stack, contratos de API | `Architecture.md` |
| 03 | **Software Engineer** | Plano de execução, decomposição de tarefas | `Execution_Plan.json` |
| 04 | **Dev Backend** | Implementação de APIs, lógica de negócio, banco | Pull Request (backend) |
| 05 | **Dev Frontend** | UI, componentes, integração com APIs | Pull Request (frontend) |
| 06 | **QA Engineer** | Testes automatizados, validação de critérios | `QA_Report.md` |
| 07 | **DevSecOps** | Auditoria de segurança, modelagem de ameaças | `Security_Audit.md` |
| 08 | **DevOps** | Pipeline CI/CD, deploy, rollback, SRE | `Deployment_Plan.md` + aprovação humana |
| 09 | **UX/UI Designer** | Design de interfaces, fluxos, usabilidade | `Design_Spec.md` |
| 10 | **Data/Integration Engineer** | Integrações, pipelines de dados, eventos | `Integration_Plan.md` |

### Tech Lead Council

Para decisões críticas ou irreversíveis, o Tech Lead ativa o **Council** — uma deliberação com 5 personas internas:

| Persona | Papel |
|---------|-------|
| Contrarian | Questiona pressupostos, aponta riscos ocultos |
| First Principles | Raciocina a partir do zero, sem viés |
| Expansionist | Explora o espaço de soluções mais amplo |
| Outsider | Perspectiva externa, sem familiaridade com o problema |
| Executor | Foco em viabilidade prática e execução |

O Council requer **consenso de ≥ 3 personas**. Sem consenso, escala para humano.

---

## Ciclo de Vida de um Projeto

```
1. Humano inicia → Tech Lead cria State_Ledger.json
2. Tech Lead → briefa Product Owner → Gate 1 (PRD válido?)
3. Tech Lead → briefa Software Architect → Gate 2 (Architecture válida?)
4. Tech Lead → briefa Software Engineer → Gate 3 (Execution Plan válido?)
5. Tech Lead → briefa Dev Backend + Dev Frontend → Gate 4 (QA aprovado?)
6. Tech Lead → briefa QA Engineer → Gate 5 (Security aprovado?)
7. Tech Lead → briefa DevSecOps → Gate 6 (Deploy aprovado?) ← HUMANO
8. Tech Lead → briefa DevOps → Gate 7 (Post-Deploy ok?)
9. Projeto encerrado
```

O **State Ledger** (`State_Ledger.json`) é a fonte única de verdade e registra em tempo real: fase atual, agente ativo, artefatos aprovados, riscos abertos, ADRs, questões pendentes e aprovações humanas.

---

## Gates de Qualidade

| Gate | Nome | Artefato Validado | Quem pode bloquear |
|------|------|------------------|--------------------|
| 1 | PRD Review | PRD.md | Tech Lead |
| 2 | Architecture Review | Architecture.md | Tech Lead |
| 3 | Execution Plan Review | Execution_Plan.json | Tech Lead |
| 4 | QA Gate | QA_Report.md + cobertura de testes | QA Engineer |
| 5 | Security Gate | Security_Audit.md | DevSecOps (Tech Lead NÃO pode sobrepor) |
| 6 | Deployment Gate | Deployment_Plan.md + rollback plan | Humano (obrigatório) |
| 7 | Post-Deploy Gate | Relatório de saúde pós-deploy | Tech Lead + SLO monitoring |

**21 Status Codes de Gate:**

```
APPROVED | RETURNED_FOR_REVISION | BLOCKED_PENDING_ADR | BLOCKED_PENDING_HUMAN
BLOCKED_CRITICAL_RISK | BLOCKED_MISSING_ARTIFACT | BLOCKED_QA_FAILURE
BLOCKED_SECURITY_FAILURE | BLOCKED_NO_ROLLBACK_PLAN | BLOCKED_MISSING_ACCEPTANCE_CRITERIA
BLOCKED_ARCHITECTURE_DEVIATION | BLOCKED_COUNCIL_NO_CONSENSUS | BLOCKED_SCOPE_EXCEEDED
BLOCKED_MISSING_TESTS | BLOCKED_SLO_VIOLATION | CONDITIONALLY_APPROVED
APPROVED_WITH_RISK | APPROVED_PENDING_MONITORING | ESCALATED_TO_HUMAN
AWAITING_ADR_RESOLUTION | AWAITING_HUMAN_APPROVAL
```

---

## Artefatos e Contratos

Cada entrega entre agentes segue o **Handoff Package** — um contrato de 7 campos obrigatórios:

```json
{
  "artifact_produced": "PRD.md",
  "summary": "Descrição concisa do que foi produzido",
  "assumptions": ["lista de premissas adotadas"],
  "open_questions": ["questões em aberto que afetam o projeto"],
  "risks": ["riscos identificados"],
  "required_next_agent": "Agente02_SoftwareArchitect",
  "validation_checklist": ["critério 1", "critério 2"]
}
```

O Tech Lead valida o Handoff Package antes de encaminhar ao próximo agente. Handoff incompleto = entrega rejeitada.

---

## Golden Model — Stack Técnica Obrigatória

O **Golden Model** define a stack obrigatória de todos os projetos. Qualquer desvio requer ADR aprovada.

| Camada | Tecnologia |
|--------|-----------|
| Framework | Next.js 16 (App Router) |
| Frontend | React 19 + TypeScript 5 |
| Estilização | Tailwind CSS v4 |
| Autenticação | NextAuth v5 + Google OAuth |
| Backend (API) | Route Handlers no Next.js |
| Proxy/Middleware | `proxy.ts` (NUNCA `middleware.ts` no Next.js 16) |
| Banco de dados | PostgreSQL via Supabase |
| ORM | Prisma 7 com PrismaPg adapter |
| Migrations (prod) | `prisma migrate deploy` (NUNCA `db push`) |
| Deploy | Vercel |
| Cron Jobs | Vercel Cron + `guardCron()` em toda rota cron |
| Validação | Zod em todas as fronteiras do sistema |
| Testes unitários | Vitest |
| Testes E2E | Playwright |
| Gráficos | Recharts v3 |
| Data Fetching | Server Components → Server Actions → SWR (polling) |
| Variáveis de ambiente | `lib/env.ts` centralizado |
| Logs | JSON estruturado (`audit_log`, `sync_log`) |

### Antipadrões críticos (bloqueiam Gate 5)

- SQL concatenado diretamente (SQL injection)
- Lógica de negócio em `route.ts`
- `process.env` espalhado fora de `lib/env.ts`
- Segredos hardcoded no código
- `middleware.ts` no Next.js 16
- `prisma db push` em staging/produção
- Jobs sem idempotência
- Deploy sem plano de rollback documentado
- Stack traces expostos para o cliente

---

## Estrutura de Pastas

```
ai_software_factory/
│
├── install.ps1                       # Installer principal (PowerShell / Windows)
├── install.sh                        # Installer alternativo (Git Bash / Linux / macOS)
├── update-knowledge.ps1              # Reindexar knowledge.db após editar arquivos (gerado pelo installer)
├── link-mcp.ps1                      # Vincular MCP ao projeto atual (gerado pelo installer)
├── link-roo.ps1                      # Vincular agentes Roo ao projeto atual (gerado pelo installer)
│
├── knowledge.db                      # [gitignored] SQLite FTS5 — todos os .md indexados
├── knowledge-config.json             # [gitignored] Configuração do indexador
├── .mcp.json                         # [gitignored] Configuração MCP (factory root)
├── roo/                              # [gitignored] Arquivos para Roo Code / Cline
│   ├── .roomodes                     # 11 custom modes (JSON)
│   └── .clinerules                   # Regras e lista de agentes
│
├── docs/
│   └── INSTALL_CLI.md                # Manual completo da Universal Factory CLI
│
├── tools/                            # Ferramentas compartilhadas — acessíveis em runtime
│   ├── factory-scripts/              # validate-framework.sh, validate-skills.sh,
│   │                                 # credential-preflight.sh, memory-guard.sh, agent-metrics.sh
│   ├── mcp-knowledge-search/         # Servidor MCP de busca full-text (FastMCP + SQLite FTS5)
│   │   ├── server.py                 # Servidor MCP principal
│   │   ├── ingest.py                 # Indexador de documentos
│   │   ├── database.py               # Acesso ao SQLite FTS5
│   │   └── requirements.txt          # mcp>=1.0.0
│   └── document-generation/          # spellcheck_document.py, validate_office_file.py
│
├── bibliography/
│   └── playbooks/                    # 12 playbooks operacionais (prompt engineering, segurança,
│                                     # DevOps, UX, testes, MCPs, automação, dados, etc.)
│
├── context/                          # Contexto global — BUILD-TIME apenas
│   ├── base_teorica.md               # Prompts e bases de conhecimento de todos os agentes
│   ├── integrantes.md                # Manifesto operacional dos agentes (2.300 linhas)
│   ├── manual_arquitetura_componentes_generico.md
│   ├── reference_architecture_generico.md  # Golden Model técnico
│   ├── client_profile.md             # ← PREENCHA ISTO ao instanciar para uma organização
│   ├── estrutura_projeto.tree
│   └── prompts/                      # 11 prompts de agentes + prompt de instanciação
│       ├── instantiation_prompt.md   # ← EXECUTE ISTO após preencher client_profile.md
│       ├── prompt_claude_code_agente00_techlead_generico.md
│       ├── prompt_claude_code_agente01_productowner_generico.md
│       └── ... (um arquivo por agente)
│
├── lib/                              # Bibliografia — BUILD-TIME apenas [gitignored]
│   ├── TechLead/
│   ├── ProductOwner/
│   ├── SoftwareArchitect/
│   ├── SoftwareEngineer/
│   ├── DevBackend/
│   ├── DevFrontend/
│   ├── QaEngineer/
│   ├── DevSecOps/
│   ├── DevOps/
│   ├── UxUiDesigner/
│   └── DataIntegrationEngineer/
│
├── build/                            # Relatórios de build e validação
│   ├── instantiation_plan.md
│   ├── instantiation_report.md
│   └── Agente*_build_report.md  (e demais relatórios por agente)
│
├── Agente00_TechLead/                # ✅ Agente totalmente construído
│   ├── prompt.md
│   ├── agent_config.json
│   ├── context_view.md
│   ├── rag_manifest.json
│   ├── skills_manifest.md
│   ├── quality_gate.md
│   ├── handoff_schema.json
│   ├── failure_modes.md
│   ├── knowledge/
│   │   ├── principles.md
│   │   ├── heuristics.md
│   │   ├── decision_rules.md
│   │   ├── knowledge_cards.md
│   │   └── source_map.json
│   ├── checklists/
│   ├── schemas/
│   ├── templates/
│   ├── examples/
│   └── skills/                       # 9 skills (6 arquivos cada)
│
├── Agente01_ProductOwner/            # ✅ (10 skills)
├── Agente02_SoftwareArchitect/       # ✅ (112 arquivos, 10 skills)
├── Agente03_SoftwareEngineer/        # ✅ (81 arquivos, 7 skills)
├── Agente04_DevBackend/              # ✅ (111 arquivos, 11 skills)
├── Agente05_DevFrontend/             # ✅ (99 arquivos, 10 skills)
├── Agente06_QaEngineer/              # ✅ (9 skills)
│   └── tools/e2e-templates/          # Playwright E2E templates + audit script
├── Agente07_DevSecOps/               # ✅ (10 skills)
│   └── tools/
│       ├── git-hooks/                # Bash guards, config-guard, secret-scan, security-gate
│       └── sentinel/                 # Framework SENTINEL: k6, certificate, state scoring
├── Agente08_DevOps/                  # ✅ (9 skills)
│   └── tools/git-hooks/              # Branch protection + parallel-agent locking hooks
├── Agente09_UxUiDesigner/            # ✅ (5 skills)
│   └── knowledge/data/               # 11 CSVs de referência UX/UI
└── Agente10_DataIntegrationEngineer/ # ✅ (7 skills)
    └── tools/predictive-rigor/       # Governance framework: PFC, LAIG, baseline parity,
                                      # sunk-cost guard, goalpost lock (6 templates + 8 scripts)
```

---

## Universal Factory CLI

O `install.ps1` é o instalador principal da factory. Ele configura todos os 11 agentes nos três ecossistemas de uso (Claude Code, Roo Code/Cline e Gemini CLI) e inicializa o banco de conhecimento MCP.

### Pré-requisitos

- **PowerShell** (Windows) — já disponível no Windows 10/11
- **Python 3.x** no PATH — necessário para o MCP Knowledge Search (o indexador e o servidor)
- **Claude Code** instalado — para usar os agentes como sub-agentes com `@nome`

### Instalação

```powershell
.\install.ps1
```

Se aparecer erro de política de execução:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Flags disponíveis:

| Flag | Efeito |
|------|--------|
| *(sem flags)* | Instalação padrão — idempotente |
| `-ForceDeps` | Força reinstalação das dependências Python mesmo que o hash não tenha mudado |

### O que o install.ps1 faz (11 fases)

| Fase | O que acontece |
|------|---------------|
| **1. FACTORY_ROOT** | Define a variável de ambiente de usuário Windows `FACTORY_ROOT` apontando para o diretório da factory |
| **2. Python** | Detecta Python no PATH (tenta `python`, `python3` e `py`) |
| **3. Dependências MCP** | Executa `pip install -r requirements.txt`; controlado por hash SHA256 do arquivo em `.requirements.hash` — só reinstala se o hash mudou ou o pacote `mcp` não está instalado |
| **4. Agentes Claude Code** | Para cada um dos 11 agentes, cria `~/.claude/agents/<nome>.md` com frontmatter YAML, conteúdo de `prompt.md`, 8 arquivos de knowledge embutidos (principles, heuristics, decision_rules, knowledge_cards, skills_manifest, quality_gate, context_view, failure_modes) e bloco de instruções MCP ao final |
| **5. Knowledge Base** | Cria `knowledge-config.json` na raiz da factory; indexa todos os `.md` do repositório em `knowledge.db` (SQLite FTS5) via `ingest.py`; reindexação só ocorre se algum `.md` for mais recente que o DB |
| **6. MCP Configuration** | Cria `.mcp.json` na raiz da factory; realiza merge cirúrgico em `~/.claude/settings.json` adicionando a entrada `mcpServers.knowledge` sem tocar outras chaves do arquivo (`model`, `enabledPlugins`, `theme`, etc.) |
| **7. Roo Code / Cline** | Gera `roo/.roomodes` com todos os 11 agentes como custom modes (JSON) e `roo/.clinerules` com regras e lista de agentes |
| **8. Scripts auxiliares** | Gera os 4 scripts auxiliares em seus destinos definitivos (ver tabela abaixo) |

### Scripts auxiliares gerados

| Script | Destino | Uso |
|--------|---------|-----|
| `factory.ps1` | `~/.local/bin/factory.ps1` | Wrapper CLI para usar agentes com Gemini ou Claude via terminal |
| `update-knowledge.ps1` | raiz da factory | Reindexar `knowledge.db` após editar arquivos |
| `link-mcp.ps1` | raiz da factory | Copiar `.mcp.json` para outro projeto (ativa MCP naquele projeto) |
| `link-roo.ps1` | raiz da factory | Copiar `.roomodes` e `.clinerules` para outro projeto |

### Idempotência

O `install.ps1` é **totalmente idempotente**:

- Compara conteúdo antes de escrever (normalização LF, UTF-8 sem BOM) — segunda execução mostra todos os itens como `sem mudancas`
- pip: só instala se hash do `requirements.txt` mudou ou o pacote `mcp` não está instalado
- `knowledge.db`: só reindexa se houver algum `.md` mais recente que o DB
- `settings.json`: backup com timestamp apenas quando há mudança real; escrita atômica via arquivo temporário

### O que é criado / verificar se funcionou

Após a instalação, verifique:

```powershell
# Agentes disponíveis no Claude Code
ls "$env:USERPROFILE\.claude\agents\" | Select-Object Name

# MCP configurado globalmente
Get-Content "$env:USERPROFILE\.claude\settings.json" | Select-String "knowledge"

# Banco de conhecimento
ls "$env:FACTORY_ROOT\knowledge.db"

# FACTORY_ROOT definida
$env:FACTORY_ROOT
```

### Uso no Claude Code (recomendado)

Após instalar, chame qualquer agente com `@nome` dentro de qualquer sessão Claude Code aberta, de qualquer diretório:

```
@techlead eu quero criar um sistema de agendamento médico
@po escreva as user stories para o módulo de autenticação
@architect proponha uma arquitetura para suportar 100k usuários
@engineer decomponha o épico de pagamentos em tarefas técnicas
@devbackend implemente a rota POST /api/appointments com validação Zod
@devfrontend crie o componente CalendarPicker com estados de hover acessíveis
@qa gere testes Playwright para o fluxo de agendamento completo
@devsecops audite a implementação de auth para OWASP Top 10
@devops o deploy falhou na Vercel — analise o log e proponha rollback
@uxui crie wireframes para o dashboard principal
@dataengineer projete o pipeline de sincronização com o ERP
```

### Agentes disponíveis

| `@nome` | Agente | Papel |
|---------|--------|-------|
| `@techlead` | Agente00_TechLead | Orquestração, gates, ADRs |
| `@po` | Agente01_ProductOwner | User stories, critérios de aceite |
| `@architect` | Agente02_SoftwareArchitect | Arquitetura, UML, decisões técnicas |
| `@engineer` | Agente03_SoftwareEngineer | Decomposição de tarefas, plano de execução |
| `@devbackend` | Agente04_DevBackend | APIs, banco de dados, lógica de negócio |
| `@devfrontend` | Agente05_DevFrontend | Componentes React, páginas, UI |
| `@qa` | Agente06_QaEngineer | Testes unitários, integração, E2E |
| `@devsecops` | Agente07_DevSecOps | Auditorias de segurança, hardening |
| `@devops` | Agente08_DevOps | CI/CD, infraestrutura, deploy |
| `@uxui` | Agente09_UxUiDesigner | UX research, wireframes, design system |
| `@dataengineer` | Agente10_DataIntegrationEngineer | Pipelines de dados, integrações |

### Uso com Gemini CLI

```powershell
# Sessão interativa
factory Agente02_SoftwareArchitect gemini

# One-shot
factory Agente04_DevBackend gemini 'Gere o schema Prisma para billing'
factory Agente06_QaEngineer gemini 'Escreva testes E2E para o login'
```

### Manutenção

```powershell
# Após git pull ou ao editar knowledge/, skills/, schemas/, templates/, examples/, bibliography/
.\update-knowledge.ps1

# Para ativar o MCP em outro projeto (copiar .mcp.json)
$env:FACTORY_ROOT\link-mcp.ps1

# Para ativar os agentes Roo em outro projeto (copiar .roomodes e .clinerules)
$env:FACTORY_ROOT\link-roo.ps1
```

Documentação completa: [`docs/INSTALL_CLI.md`](docs/INSTALL_CLI.md)

---

## Como os agentes funcionam na prática

Cada agente no Claude Code é um arquivo `~/.claude/agents/<nome>.md` gerado pelo `install.ps1`. Esse arquivo contém dois layers de conhecimento que funcionam em conjunto.

### Layer 1 — Conhecimento embutido (resposta rápida)

O arquivo do agente inclui diretamente:

1. **`prompt.md`** — identidade, regras de comportamento, Golden Model, skills disponíveis
2. **8 arquivos de knowledge** embutidos com separadores de seção:
   - `knowledge/principles.md` — princípios operacionais do agente
   - `knowledge/heuristics.md` — heurísticas de decisão
   - `knowledge/decision_rules.md` — regras if-then
   - `knowledge/knowledge_cards.md` — cartões conceituais reutilizáveis
   - `skills_manifest.md` — índice de todas as skills e quando usar cada uma
   - `quality_gate.md` — critérios dos gates que o agente valida
   - `context_view.md` — visão compilada do contexto
   - `failure_modes.md` — modos de falha conhecidos e mitigações

Esse conteúdo é carregado diretamente no contexto da sessão e permite ao agente responder com precisão sem precisar consultar arquivos externos.

### Layer 2 — MCP Knowledge Search (busca profunda)

Para conteúdo que não cabe no contexto da sessão — schemas detalhados, templates completos, exemplos, checklists de skills específicas, playbooks — o agente usa o **servidor MCP** para busca full-text sob demanda.

O bloco de instruções MCP ao final de cada arquivo de agente instrui explicitamente:

> **Consulte o MCP antes de afirmar que um skill, schema, template ou checklist não existe.**

Isso garante que o agente não invente respostas quando a informação existe no banco de conhecimento.

### Por que dois layers?

| | Layer 1 (embutido) | Layer 2 (MCP) |
|---|---|---|
| **Latência** | Zero — já está no contexto | Requer chamada ao servidor |
| **Escopo** | Conhecimento essencial e frequente | Conteúdo detalhado e específico |
| **Custo** | Tokens sempre consumidos | Só consome quando necessário |
| **Cobertura** | 8 arquivos por agente | Todos os `.md` do repositório (7.000+) |

---

## MCP Knowledge Search

O MCP Knowledge Search é um servidor FastMCP que indexa todos os arquivos `.md` da factory em um banco SQLite com Full-Text Search (FTS5) e os expõe como ferramentas para agentes Claude Code.

### O que está indexado

- `Agente*/knowledge/` — principles, heuristics, decision_rules, knowledge_cards
- `Agente*/skills/` — documentação e checklists de cada skill
- `Agente*/schemas/` — contratos JSON de input/output
- `Agente*/templates/` — templates de artefatos
- `Agente*/examples/` — exemplos de bons/maus outputs
- `Agente*/checklists/` — checklists operacionais
- `bibliography/playbooks/` — 12 playbooks de engenharia

**Total indexado: aproximadamente 7.000 documentos.**

### Ferramentas disponíveis

| Ferramenta | Quando usar |
|-----------|-------------|
| `search_knowledge("termo")` | Busca full-text em skills, schemas, templates, checklists, playbooks. Suporta operadores FTS5: `AND`, `OR`, `NOT`, `"frase exata"` |
| `get_full_document("doc_id")` | Obtém o documento completo pelo ID retornado pelo search |
| `get_context("doc_id")` | Obtém seções adjacentes do mesmo arquivo (contexto ao redor) |
| `knowledge_stats()` | Exibe estatísticas do banco e categorias indexadas |

### Configuração

O installer registra o MCP globalmente em `~/.claude/settings.json`, tornando-o disponível em qualquer sessão Claude Code, de qualquer diretório:

```json
{
  "mcpServers": {
    "knowledge": {
      "command": "python",
      "args": ["<FACTORY_ROOT>/tools/mcp-knowledge-search/server.py"],
      "env": { "KNOWLEDGE_DB": "<FACTORY_ROOT>/knowledge.db" }
    }
  }
}
```

### Usar o MCP em projetos externos

Para ativar o MCP em um projeto fora da factory (por exemplo, um projeto cliente):

```powershell
# No diretório do projeto externo
$env:FACTORY_ROOT\link-mcp.ps1
```

Isso copia `.mcp.json` da factory para o diretório atual. Na próxima sessão Claude Code naquele projeto, o MCP estará disponível.

### Manter o banco atualizado

Sempre que você editar arquivos de knowledge, skills, templates ou playbooks, reindexe o banco:

```powershell
# Na raiz da factory
.\update-knowledge.ps1
```

O script é atômico: indexa em arquivo temporário e só substitui o banco existente se a indexação for bem-sucedida.

---

## Roo Code / Cline (VS Code)

O **Roo Code** (anteriormente Roo-Cline) é uma extensão do VS Code que suporta **custom modes** — perfis de agente com prompt e permissões configuráveis. O installer gera automaticamente os 11 agentes da factory como custom modes.

### Configurar em um projeto

```powershell
# No diretório do projeto (com VS Code aberto)
$env:FACTORY_ROOT\link-roo.ps1
```

Isso copia `.roomodes` e `.clinerules` da pasta `roo/` da factory para a raiz do projeto.

### Modos disponíveis

Após rodar `link-roo.ps1`, os seguintes modos ficam disponíveis no Roo Code:

| Modo | Agente |
|------|--------|
| `techlead` | Tech Lead |
| `po` | Product Owner |
| `architect` | Software Architect |
| `engineer` | Software Engineer |
| `devbackend` | Dev Backend |
| `devfrontend` | Dev Frontend |
| `qa` | QA Engineer |
| `devsecops` | DevSecOps |
| `devops` | DevOps |
| `uxui` | UX/UI Designer |
| `dataengineer` | Data/Integration Engineer |

Cada modo carrega o `prompt.md` do agente correspondente como `roleDefinition` e inclui instruções para acessar `FACTORY_ROOT` diretamente ou via MCP quando disponível.

### Grupos de permissão

Todos os modos são configurados com os grupos `read`, `edit`, `browser`, `command` e `mcp` — o conjunto completo de permissões do Roo Code.

---

## Como instanciar para uma organização

Este repositório é **white-label**: não contém referências a organizações, clientes ou domínios específicos. Para usar a fábrica em uma organização real, siga o fluxo abaixo.

### Fluxo completo

```
1. Fork  →  2. Clone  →  3. Preencher client_profile.md  →  4. Rodar instantiation_prompt.md  →  5. Commit
```

**1. Fork**

Faça fork deste repositório no GitHub. O fork é o repositório da organização — o upstream (este repo) continua genérico e pode receber atualizações.

**2. Clone**

```bash
git clone https://github.com/<sua-org>/ai_software_factory.git
cd ai_software_factory
```

**3. Preencher `context/client_profile.md`**

Este é o único arquivo que você precisa editar. Ele define:

- Identidade da organização (nome, tipo, idioma)
- Design system (cores, dark mode, component library)
- Desvios do Golden Path (auth provider, database host, deploy platform, etc.)
- Integrações externas (ERP, CRM, LMS, etc.)
- Contexto regulatório (LGPD, outros frameworks)
- Quais dos 11 agentes ativar

**4. Executar `context/prompts/instantiation_prompt.md`**

Abra o Claude Code na raiz do repositório e cole/execute o conteúdo de `instantiation_prompt.md`. O prompt irá:

- Ler e validar o `client_profile.md`
- Atualizar `agent_config.json`, `context_view.md` e `prompt.md` de cada agente ativo
- Injetar tokens de design, integrações e regras regulatórias nos `knowledge/` relevantes
- Gerar `build/instantiation_plan.md` e `build/instantiation_report.md`

**5. Commit**

O fork agora contém a versão instanciada da fábrica. Todos os agentes ativos estão adaptados ao contexto da organização.

Após o commit, execute `.\install.ps1` novamente para propagar as alterações dos `prompt.md` para `~/.claude/agents/`.

### Atualizações futuras

O prompt de instanciação é **idempotente** — pode ser executado novamente sempre que o `client_profile.md` for atualizado (nova integração, mudança de stack, novo framework regulatório). Ele sobrescreve apenas os campos mapeados ao perfil; estrutura, gates, schemas e checklists nunca são modificados.

### Sobre os arquivos `_generico`

Todos os arquivos com sufixo `_generico` são white-label e devem permanecer sem referências a organizações específicas no repositório upstream. Eles são as fontes de build — o prompt de instanciação os lê mas não os modifica.

---

## Como criar um agente

O processo de **build de um agente** segue estas etapas:

### 1. Fontes de entrada (build-time)

| Fonte | Onde fica | O que fornece |
|-------|-----------|---------------|
| `context/base_teorica.md` | Raiz do projeto | Prompt base, base de conhecimento, regras |
| `context/integrantes.md` | Raiz do projeto | Manifesto operacional completo do agente |
| `context/reference_architecture_generico.md` | Raiz do projeto | Golden Model técnico |
| `context/manual_arquitetura_componentes_generico.md` | Raiz do projeto | Estrutura de artefatos e contratos |
| `lib/<Papel>/` | Pasta de bibliografia | Livros de referência do agente (build-time) |

### 2. Artefatos gerados no build

Para cada agente, o build produz:

```
AgenteXX_NomeAgente/
├── prompt.md                  # Prompt de sistema completo
├── agent_config.json          # Configuração de runtime e fontes permitidas/bloqueadas
├── context_view.md            # Visão compilada do contexto (substitui context/ no runtime)
├── rag_manifest.json          # Política de RAG: coleções, chunking, fontes bloqueadas
├── skills_manifest.md         # Índice e descrição de todas as skills
├── quality_gate.md            # Critérios dos gates que o agente valida
├── handoff_schema.json        # Schema do artefato de entrega
├── failure_modes.md           # Modos de falha conhecidos + mitigações
├── knowledge/                 # Conhecimento destilado dos livros (runtime-safe)
│   ├── principles.md
│   ├── heuristics.md
│   ├── decision_rules.md
│   ├── knowledge_cards.md
│   └── source_map.json
├── checklists/                # Checklists por operação
├── schemas/                   # JSON Schemas dos contratos de I/O
├── templates/                 # Templates dos artefatos produzidos
├── examples/                  # Exemplos de bom e mau output
└── skills/                    # Uma pasta por skill com 6 arquivos:
    └── nome-da-skill/
        ├── skill.md           # Descrição da skill, quando usar, como usar
        ├── input.schema.json  # Schema do input esperado
        ├── output.schema.json # Schema do output produzido
        ├── checklist.md       # Checklist de execução
        └── examples/
            ├── good_output.md
            └── bad_output.md
```

### 3. Relatórios de build

Ao final do build, gerar em `build/`:

- `AgenteXX_build_report.md` — Sumário completo do que foi criado
- `AgenteXX_generated_files_index.md` — Índice de todos os arquivos com propósito
- `AgenteXX_runtime_readiness_checklist.md` — Checklist estático de validação pré-runtime
- `AgenteXX_knowledge_distillation_patch_report.md` — Registro das fontes consumidas e destiladas

### 4. Regra de isolamento de runtime

**CRÍTICO:** Após o build, o agente **não acessa mais** `context/`, `lib/` ou qualquer fonte global. O runtime usa apenas:

- Artefatos locais em `AgenteXX_*/` (prompt.md, schemas, templates, checklists, examples)
- `knowledge/` com o conhecimento destilado
- Inputs de projeto fornecidos diretamente pelo humano ou pelo Tech Lead

Após criar ou atualizar um agente, re-execute `.\install.ps1` para propagar as alterações de `prompt.md` e dos arquivos de knowledge para `~/.claude/agents/<nome>.md`.

---

## Knowledge Distillation — Regra de Isolamento

A separação entre **build-time** e **runtime** é um princípio central da fábrica.

### Build-time (apenas durante a criação do agente)

- Os livros de referência são lidos e o conhecimento é extraído
- O contexto global em `context/` é processado
- Os princípios, heurísticas e regras são destilados para `knowledge/`
- **Nenhum livro ou arquivo de `context/` é acessado depois disso**

### Runtime (quando o agente está em uso)

O agente lê **apenas**:

```
AgenteXX_NomeAgente/
├── prompt.md
├── agent_config.json
├── context_view.md
├── knowledge/           ← conhecimento destilado, não os livros originais
├── skills/
├── schemas/
├── templates/
├── checklists/
└── examples/
```

O MCP Knowledge Search estende esse acesso com busca full-text, mas também só indexa os artefatos locais dos agentes — nunca os arquivos de `context/` ou `lib/`.

### Por que isso importa

- **Performance**: o agente não precisa ler centenas de páginas de livros em cada sessão
- **Consistência**: o conhecimento destilado é curado e validado, não raw
- **Segurança**: fontes brutas não contaminam o contexto de runtime
- **Custo**: contexto menor = menor uso de tokens

---

## Fontes de Conhecimento

### Por agente (livros de referência — `lib/`)

| Agente | Livros Principais | Materiais Complementares |
|--------|------------------|--------------------------|
| **TechLead** | The Mythical Man-Month (Brooks), Accelerate (Forsgren et al.), The Clean Coder (Martin) | Módulo 10 — Gerenciamento de Projetos (métricas, DORA, SWEBOK), Módulo 12 — Governança de TI |
| **Product Owner** | Software Requirements (Wiegers), Writing Effective Use Cases (Cockburn), User Stories Applied (Cohn) | Módulo 02 — Engenharia de Requisitos I (BPMN, regras de negócio), Módulo 03 — Engenharia de Requisitos II (ISO 25010, RTM, MoSCoW) |
| **Software Architect** | Clean Architecture, DDIA (Kleppmann), DDD (Evans), Fundamentals of Software Architecture (Richards & Ford), Building Microservices (Newman), PEAA (Fowler) | Módulo 04 — Projeto de Software I (coesão/acoplamento), Módulo 05 — Projeto de Software II (UML: casos de uso, sequência, classes) |
| **Software Engineer** | The Pragmatic Programmer, Code Complete, Design Patterns (GoF), Enterprise Integration Patterns (Hohpe & Woolf), System Design Interview (Xu) | Módulo 04 — Projeto de Software I, Módulo 05 — Projeto de Software II (extração de tarefas a partir de diagramas UML) |
| **Dev Backend** | Clean Code, Introduction to Algorithms (Cormen), Microservices Patterns (Richardson), Architecture Patterns with Python, Grokking Algorithms | — |
| **Dev Frontend** | Eloquent JavaScript, Designing Interfaces (Tidwell), CSS Secrets (Verou), High Performance Browser Networking (Grigorik) | — |
| **QA Engineer** | TDD by Example (Beck), Unit Testing (Khorikov), GOOS (Freeman & Pryce), Working Effectively with Legacy Code (Feathers), Refactoring (Fowler) | Módulo 06 — Teste de Software I, Módulo 07 — Teste de Software II, Módulo 08 — Qualidade I, Módulo 09 — Qualidade II (ISO, CMMI, MPS.BR) |
| **DevSecOps** | Threat Modeling (Shostack), The Web Application Hacker's Handbook, Practical Cloud Security (Dotson) | — |
| **DevOps** | Continuous Delivery (Humble & Farley), SRE (Google), The Phoenix Project, The DevOps Handbook (Kim et al.) | Módulo 11 — Gerência de Configuração (controle de mudanças, ferramentas de CM) |
| **UX/UI Designer** | Laws of UX (Yablonski), Don't Make Me Think (Krug), Lean UX (Gothelf & Seiden) | — |
| **Data/Integration Engineer** | Fundamentals of Data Engineering (Reis & Housley), Building Event-Driven Microservices (Bellemare), Data Mesh (Dehghani), Designing Event-Driven Systems (Stopford) | — |

> **Materiais complementares** = apostilas de pós-graduação em Engenharia de Software copiadas para `lib/` em 2026-05-17. Já destiladas nos `knowledge/` dos agentes Agente00–Agente03; serão usadas no build dos demais quando aplicável.

### Playbooks operacionais (`bibliography/playbooks/`)

12 guias de referência rápida sobre práticas de engenharia, acessíveis em build-time para enriquecer o conhecimento dos agentes:

| # | Playbook |
|---|----------|
| 01 | Prompt Engineering Patterns |
| 02 | Code Review Checklist |
| 03 | Segurança e Privacidade |
| 04 | Performance e Escalabilidade |
| 05 | Testes e Qualidade |
| 06 | DevOps / CI-CD |
| 07 | UX / UI Design |
| 08 | Gestão de Memória e Contexto |
| 09 | Integração de MCPs |
| 10 | Automação de Workflows |
| 11 | Incorporação de Software Existente |
| 12 | Dados e Integração |

### Contexto global (build-time)

| Arquivo | Conteúdo |
|---------|---------|
| `context/base_teorica.md` | Prompts base e bases de conhecimento de todos os 11 agentes |
| `context/integrantes.md` | Manifesto operacional completo (~2.300 linhas) |
| `context/reference_architecture_generico.md` | Golden Model: stack técnica, padrões obrigatórios, antipadrões |
| `context/manual_arquitetura_componentes_generico.md` | Estrutura de artefatos, contratos de handoff, definição de gates |

### Prompts prontos para instalação manual

```
context/prompts/
├── prompt_claude_code_agente00_techlead_generico.md         (~26 KB)
├── prompt_claude_code_agente01_productowner_generico.md     (~30 KB)
├── prompt_claude_code_agente02_softwarearchitect_generico.md (~25 KB)
├── prompt_claude_code_agente03_softwareengineer_generico.md  (~24 KB)
├── prompt_claude_code_agente04_devbackend_generico.md        (~25 KB)
├── prompt_claude_code_agente05_devfrontend_generico.md       (~24 KB)
├── prompt_claude_code_agente06_qaengineer_generico.md        (~23 KB)
├── prompt_claude_code_agente07_devsecops_generico.md         (~24 KB)
├── prompt_claude_code_agente08_devops_generico.md            (~24 KB)
├── prompt_claude_code_agente09_uxuidesigner_generico.md      (~22 KB)
└── prompt_claude_code_agente10_dataintegrationengineer_generico.md (~24 KB)
```

---

## Estado atual dos agentes

| Agente | Prompt | Build completo | Knowledge | Skills | Status |
|--------|--------|----------------|-----------|--------|--------|
| **00 TechLead** | ✅ | ✅ | ✅ (+patch) | ✅ 9/9 | **Pronto para uso** |
| **01 ProductOwner** | ✅ | ✅ | ✅ (+patch) | ✅ 10/10 | **Pronto para uso** |
| **02 SoftwareArchitect** | ✅ | ✅ | ✅ (+patch) | ✅ 10/10 | **Pronto para uso** |
| **03 SoftwareEngineer** | ✅ | ✅ | ✅ (+patch) | ✅ 7/7 | **Pronto para uso** |
| **04 DevBackend** | ✅ | ✅ | ✅ | ✅ 11/11 | **Pronto para uso** |
| **05 DevFrontend** | ✅ | ✅ | ✅ | ✅ 10/10 | **Pronto para uso** |
| **06 QaEngineer** | ✅ | ✅ | ✅ | ✅ 9/9 | **Pronto para uso** |
| **07 DevSecOps** | ✅ | ✅ | ✅ | ✅ 10/10 | **Pronto para uso** |
| **08 DevOps** | ✅ | ✅ | ✅ | ✅ 9/9 | **Pronto para uso** |
| **09 UxUiDesigner** | ✅ | ✅ | ✅ | ✅ 5/5 | **Pronto para uso** |
| **10 DataIntegrationEngineer** | ✅ | ✅ | ✅ | ✅ 7/7 | **Pronto para uso** |

> **Todos os 11 agentes têm build completo.** Agente00–Agente10 possuem artefatos locais, skills e knowledge distillation prontos para uso. Os prompts genéricos estão em `context/prompts/`.
