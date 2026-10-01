# GitHub Copilot — AI Software Factory Integration

Este documento descreve como utilizar a **AI Software Factory** com o **GitHub Copilot** (especialmente no VS Code, GitHub CLI e GitHub.com Copilot Chat).

---

## 1. Visao Geral da Arquitetura

A integracao com o GitHub Copilot e sustentada por tres pilares canonicamente gerados pelo `install.ps1`:

| Componente | Localizacao | Funcao |
|---|---|---|
| **Instrucoes Globais** | `.github/copilot-instructions.md` | Regras do SDLC, Quality Gates, State Ledger, ADR policy e isolamento de runtime injetados automaticamente no contexto do Copilot |
| **Prompt Files Reutilizaveis** | `.github/prompts/*.prompt.md` | Personas completas dos 12 agentes com conhecimento destilado (principles, heuristics, cards) para invocacao sob demanda no Copilot Chat |
| **MCP Knowledge Server** | `.vscode/mcp.json` | Configuracao do servidor MCP `knowledge` para consulta semantica de conhecimento no VS Code Copilot Agent mode |

---

## 2. Instalacao e Configuracao

A fonte da verdade de todos os agentes reside nas pastas `AgenteXX_RoleName/`. Para gerar ou atualizar a configuracao do GitHub Copilot:

```powershell
# Na raiz da factory:
.\install.ps1
```

O `install.ps1` executara:
1. Criacao/atualizacao de `.github/copilot-instructions.md`.
2. Geracao dos 12 arquivos de prompt em `.github/prompts/<nome>.prompt.md`.
3. Configuracao do servidor MCP em `.vscode/mcp.json`.
4. Registro no manifesto `.github/prompts/.ai_software_factory_manifest.json`.

Para validar a integracao:

```powershell
.\doctor.ps1
```

A secao **7C. GitHub Copilot — Prompt Files & Instructions** e a secao **10. MCP Configuracao** devem reportar status `[OK]`.

---

## 3. Os 12 Agentes Disponiveis

Cada agente possui um arquivo `.prompt.md` dedicado em `.github/prompts/`:

| Papel | Arquivo Prompt | Descricao |
|---|---|---|
| `techlead` | `.github/prompts/techlead.prompt.md` | Tech Lead, orquestrador do SDLC, validacao de Quality Gates, ADRs, State Ledger |
| `po` | `.github/prompts/po.prompt.md` | Product Owner, PRD, user stories, criterios de aceitacao e backlog |
| `architect` | `.github/prompts/architect.prompt.md` | Arquiteto de Software, design de sistemas, diagramas UML, decisoes e ADRs |
| `engineer` | `.github/prompts/engineer.prompt.md` | Engenheiro de Software, decomposicao de tarefas, planos e estimativas |
| `devbackend` | `.github/prompts/devbackend.prompt.md` | Dev Backend, APIs REST, servicos, banco de dados, migrations Prisma |
| `devfrontend` | `.github/prompts/devfrontend.prompt.md` | Dev Frontend, componentes React, paginas Next.js, UI Tailwind |
| `qa` | `.github/prompts/qa.prompt.md` | QA Engineer, estrategia de testes, Vitest, Playwright E2E e cobertura |
| `devsecops` | `.github/prompts/devsecops.prompt.md` | DevSecOps, auditorias de seguranca, SAST, OWASP Top 10, hardening |
| `devops` | `.github/prompts/devops.prompt.md` | DevOps, CI/CD, infraestrutura Vercel, deployment e runbooks |
| `uxui` | `.github/prompts/uxui.prompt.md` | UX/UI Designer, pesquisa de usuario, wireframes, design system |
| `dataengineer` | `.github/prompts/dataengineer.prompt.md` | Data Engineer, pipelines de dados, ETL, integracoes e governanca |
| `dataanalyst` | `.github/prompts/dataanalyst.prompt.md` | Data Analyst, metricas, analise exploratoria, insights e dashboards |

---

## 4. Como Usar no VS Code

### Modo 1: Copilot Chat com Reusable Prompt Files

O VS Code reconhece arquivos `.prompt.md` dentro de `.github/prompts/`. Voce pode utiliza-los das seguintes formas:

1. **Anexando o Prompt File**:
   - No painel do Copilot Chat (`Ctrl+Alt+I` ou `Ctrl+I`), clique no botao de anexar contexto (ou digite `#file:`) e selecione o arquivo correspondente, por exemplo: `#file:techlead.prompt.md`.
   - Adicione sua solicitacao: `Avalie o PRD atual contra o Quality Gate G0.`

2. **Invocando a Persona**:
   - Gracas ao `.github/copilot-instructions.md`, o Copilot ja conhece todas as 12 personas. Voce pode iniciar a interacao diretamente:
     ```text
     Atue sob a persona @techlead definida no repositorio. Qual e o checklist para avancar do Gate G1 para G2?
     ```

### Modo 2: VS Code Copilot Agent Mode com MCP

No modo Agent do VS Code, o Copilot tem permissao para chamar ferramentas (tool calling) automaticamente. Com o arquivo `.vscode/mcp.json` configurado, ele pode acessar diretamente o MCP `knowledge`:

- `search_knowledge`: Pesquisa em toda a base da factory.
- `search_with_filters`: Pesquisa filtrada por categoria ou metadados.
- `get_full_document`: Leitura de artefatos inteiros (schemas, templates, playbooks).
- `get_context`: Leitura de secoes adjacentes.
- `knowledge_stats`: Estatisticas da base indexada.
- `health_check`: Verificacao de conectividade do MCP.

Exemplo de prompt no Agent mode:
```text
Consulte o servidor MCP knowledge para encontrar o template de ADR e o checklist de revisao de seguranca para Gate G4.
```

---

## 5. Vinculando o MCP a Projetos Externos

Para habilitar a busca de conhecimento da factory e as configuracoes do Copilot em outro projeto consumidor:

```powershell
# Abra o terminal no diretorio do projeto consumidor e execute:
& "$env:FACTORY_ROOT\link-mcp.ps1"
```

O script criara/atualizara:
- `.mcp.json` (para Claude Code)
- `.codex/config.toml` (para Codex)
- `.vscode/mcp.json` (para VS Code Copilot Agent mode)

Caso queira que o Copilot siga as regras completas da factory no projeto consumidor, voce pode copiar a pasta `.github/` gerada ou criar um link simbolico:

```powershell
# Opcional: copiar instrucoes para o projeto consumidor
Copy-Item "$env:FACTORY_ROOT\.github\copilot-instructions.md" .github\copilot-instructions.md
```

---

## 6. Regras de Ouro e Boas Praticas

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
