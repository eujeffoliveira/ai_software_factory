# Antigravity (AGY)

Este guia explica como usar a AI Software Factory no Google Antigravity (AGY),
preservando a mesma fonte canônica dos agentes usados por Claude Code e Codex.

## Modelo de integração

No Antigravity, a factory é integrada como um **Plugin Global de Customização** em:

```text
~/.gemini/config/plugins/ai-software-factory/
  ├── plugin.json
  ├── mcp_config.json
  └── skills/
      ├── techlead/SKILL.md
      ├── po/SKILL.md
      ├── architect/SKILL.md
      ├── engineer/SKILL.md
      ├── devbackend/SKILL.md
      ├── devfrontend/SKILL.md
      ├── qa/SKILL.md
      ├── devsecops/SKILL.md
      ├── devops/SKILL.md
      ├── uxui/SKILL.md
      ├── dataengineer/SKILL.md
      └── dataanalyst/SKILL.md
```

Além disso, o servidor MCP `knowledge` é registrado cirurgicamente no arquivo global:

```text
~/.gemini/config/mcp_config.json
```

Esses arquivos são gerados por `install.ps1` a partir dos mesmos artefatos canônicos:

- `AgenteXX_*/prompt.md`
- `AgenteXX_*/knowledge/`
- `skills_manifest.md`
- `quality_gate.md`
- `context_view.md`
- `failure_modes.md`

Isso garante paridade total entre runtimes sem duplicar prompts nem criar forks manuais.

## Instalação

Na raiz da factory:

```powershell
.\install.ps1
```

O instalador cria ou atualiza:

- O plugin `ai-software-factory` em `~/.gemini/config/plugins/ai-software-factory/`
- As 12 skills com frontmatter YAML e instruções completas (usando os nomes diretos dos agentes: `techlead`, `po`, `architect`, etc.)
- A configuração MCP do plugin e a chave global `mcpServers.knowledge` em `~/.gemini/config/mcp_config.json`
- O manifesto `.ai_software_factory_manifest.json`

## Como usar no Antigravity

O Antigravity utiliza o paradigma de **Progressive Disclosure** (divulgação progressiva): no início da sessão, apenas os metadados (nome e descrição) das skills estão no prompt do sistema. A instrução completa de cada agente só é carregada no contexto quando o papel é acionado.

### 1. Ativação via Skills

Você pode pedir ao Antigravity para atuar usando uma skill específica da factory diretamente pelo nome:

```text
Ative a skill techlead e avalie os quality gates deste projeto.
```

```text
Use a skill qa para criar a estratégia de testes unitários e E2E.
```

```text
Atue como architect e proponha o design da API e dos modelos de dados.
```

Ou simplesmente descrever o trabalho e o Antigravity identificará e ativará a skill correspondente:

```text
Preciso de uma revisão de segurança OWASP e auditoria de credenciais. (Ativa devsecops)
```

As 12 skills disponíveis são:

| Skill | Papel no SDLC |
|---|---|
| `techlead` | Tech Lead, Quality Gates, ADRs, State Ledger e governança |
| `po` | Product Owner, PRD, User Stories, Critérios de Aceitação |
| `architect` | Arquiteto de Software, Diagramas C4/UML, ADRs de infra e design |
| `engineer` | Engenheiro de Software, Decomposição de tarefas e sequencing |
| `devbackend` | Dev Backend, APIs REST, Prisma, ORM, Auth e Banco de Dados |
| `devfrontend` | Dev Frontend, React, Next.js, Tailwind e Acessibilidade |
| `qa` | QA Engineer, Vitest, Playwright, Relatórios de Teste |
| `devsecops` | DevSecOps, Hardening, OWASP, SAST e Gestão de Secrets |
| `devops` | DevOps, CI/CD, GitHub Actions, Docker e Runbooks |
| `uxui` | UX/UI Designer, Design System, Wireframes e Fluxos |
| `dataengineer` | Data Engineer, Pipelines ETL, Ingestão e Governança |
| `dataanalyst` | Data Analyst, Métricas, KPIs e Especificação de Dashboards |

### 2. Invocação de Subagentes

No Antigravity, o agente principal também pode instanciar subagentes dedicados (`invoke_subagent` / `define_subagent`) usando as instruções canônicas de cada papel quando tarefas paralelas ou isoladas forem necessárias:

```text
Invoque techlead e architect como subagentes para avaliarem o impacto do novo microsserviço.
```

## Acesso ao Conhecimento via MCP

O servidor `knowledge` expõe as ferramentas de busca semântica e full-text search diretamente no Antigravity:

- `mcp_knowledge_search_knowledge` — busca full-text em todos os artefatos
- `mcp_knowledge_search_with_filters` — busca com filtros de categoria, tipo e agente
- `mcp_knowledge_get_full_document` — leitura completa de documento por ID
- `mcp_knowledge_get_context` — recuperação de blocos adjacentes
- `mcp_knowledge_knowledge_stats` — estatísticas do repositório de conhecimento
- `mcp_knowledge_health_check` — verificação de conectividade e integridade

As ferramentas são registradas como `eager` no Antigravity para estarem disponíveis imediatamente.

### Política de Fallback

Se o servidor MCP não estiver acessível:
1. O agente deve avisar explicitamente que o MCP falhou.
2. Usar leitura de arquivos locais apenas como fallback declarado.
3. Recomendar ao desenvolvedor a execução de `.\test-mcp.ps1` ou `.\doctor.ps1`.
4. Nunca realizar fallback silencioso.

## Regras de Projeto e Repositório

O Antigravity descobre automaticamente os arquivos `AGENTS.md` e `GEMINI.md` na raiz de qualquer repositório aberto. As diretrizes persistentes da factory residem em `AGENTS.md`.

## Validação e Diagnóstico

Após executar `install.ps1`, valide o ambiente com:

```powershell
.\doctor.ps1
```

A seção `7B. Antigravity — Plugin & Skills` e a seção `10. MCP Configuracao` verificarão se todos os artefatos, permissões e rotas do Antigravity estão íntegros.
