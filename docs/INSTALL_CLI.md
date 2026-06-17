# Universal Factory CLI — Guia de Instalação

> **Este documento está desatualizado.** Ele descreve o instalador da versão inicial da factory, anterior ao MCP Knowledge Search, ao `FACTORY_ROOT`, ao `doctor.ps1` e ao `uninstall.ps1`.
>
> Use os documentos atuais:
> - **Instalação:** [`docs/INSTALLATION.md`](INSTALLATION.md)
> - **Operações:** [`docs/OPERATIONS.md`](OPERATIONS.md)
> - **Codex:** [`docs/CODEX.md`](CODEX.md)
> - **Gemini CLI:** [`docs/CLIENT_COMPATIBILITY.md`](CLIENT_COMPATIBILITY.md#gemini-cli)
> - **Troubleshooting:** [`docs/TROUBLESHOOTING.md`](TROUBLESHOOTING.md)
>
> O conteúdo abaixo é preservado apenas como referência histórica.

---

## O que o instalador faz

O instalador configura os 11 agentes do SDLC para uso imediato em qualquer sessão Claude Code, além de instalar um wrapper para o Gemini CLI.

| O que cria | Onde | Para quê |
|------------|------|----------|
| `~/.claude/agents/<nome>.md` (11 arquivos) | Global do Claude Code | Habilita `@techlead`, `@po`, `@architect`, etc. em qualquer sessão |
| `~/.local/bin/factory.ps1` | Terminal | Wrapper para uso com Gemini CLI |

Ambos os instaladores são **idempotentes** — podem ser executados novamente sem problema após mover o repositório ou clonar em uma nova máquina.

---

## Pré-requisitos

| CLI | Instalar |
|-----|---------|
| **Claude Code** (para `@agent-name`) | `npm install -g @anthropic-ai/claude-code` |
| **Gemini CLI** (para `factory ... gemini`) | `npm install -g @google/gemini-cli` |

Verifique:
```powershell
claude --version
gemini --version
```

---

## Instalação

### PowerShell (Windows)

Abra o **PowerShell** (não o CMD), navegue até a raiz do repositório e certifique-se de estar com a versão mais recente antes de instalar:

```powershell
cd C:\Dev\ai_software_factory   # ajuste para o seu caminho
git pull
.\install.ps1
```

Se aparecer o erro `is not recognized` ou `running scripts is disabled`, a política de execução está bloqueando scripts. Corrija com o comando completo abaixo e depois re-execute:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\install.ps1
```

> **Atenção:** o comando `Set-ExecutionPolicy` precisa dos dois argumentos na mesma linha — `-ExecutionPolicy RemoteSigned` e `-Scope CurrentUser`. Executar só até `-Scope` sem o valor causa erro.

### Git Bash / Linux / macOS

```bash
bash install.sh
source ~/.bashrc   # ou ~/.zshrc no macOS
```

---

## Uso no Claude Code

Após instalar, abra qualquer sessão Claude Code (em qualquer diretório) e chame os agentes com `@nome`:

```
@techlead eu quero criar um sistema de agendamento médico
@po escreva as user stories para o módulo de autenticação
@architect proponha uma arquitetura event-driven para este monolito
```

Os agentes ficam disponíveis globalmente — não é necessário abrir o projeto `ai_software_factory`.

### Agentes disponíveis

| `@nome` | Agente | Papel |
|---------|--------|-------|
| `@techlead` | Agente00_TechLead | Tech Lead — orquestração, quality gates, ADRs, oversight |
| `@po` | Agente01_ProductOwner | Product Owner — user stories, critérios de aceite, backlog |
| `@architect` | Agente02_SoftwareArchitect | Arquiteto — design de sistemas, UML, decisões de arquitetura |
| `@engineer` | Agente03_SoftwareEngineer | Engenheiro — decomposição de tarefas, plano de execução |
| `@devbackend` | Agente04_DevBackend | Dev Backend — APIs, banco de dados, migrations, autenticação |
| `@devfrontend` | Agente05_DevFrontend | Dev Frontend — React, Next.js, Tailwind, UI |
| `@qa` | Agente06_QaEngineer | QA — testes unitários (Vitest), E2E (Playwright), cobertura |
| `@devsecops` | Agente07_DevSecOps | DevSecOps — OWASP, SAST, hardening, secrets |
| `@devops` | Agente08_DevOps | DevOps — CI/CD, Vercel, monitoramento, runbooks |
| `@uxui` | Agente09_UxUiDesigner | UX/UI — pesquisa, wireframes, design system, acessibilidade |
| `@dataengineer` | Agente10_DataIntegrationEngineer | Data Engineer — pipelines, ETL, integrações, governança |

### Exemplos de uso dentro de uma sessão

**Iniciando um projeto:**
```
@techlead quero criar um app para gerenciar ROMs de emuladores de SNES, Mega Drive e arcade
```

**Chamando agentes especializados:**
```
@po crie as user stories para o módulo de catalogação de ROMs

@architect projete a arquitetura — sistema de arquivos local, metadados online (IGDB),
lançamento de emuladores e frontend Next.js

@devbackend implemente a rota GET /api/roms com filtros por sistema, gênero e favorito

@qa gere testes Playwright para o fluxo: busca de ROM → visualização de detalhes → lançar emulador

@devsecops audite a integração com APIs externas — verifique rate limiting e validação de input

@devops configure o pipeline CI/CD para deploy na Vercel com rollback automático
```

---

## Uso com Gemini CLI

O `factory` wrapper permite usar os agentes com o Gemini CLI no terminal:

```powershell
factory <pasta-do-agente> [engine] [query...]
```

| Argumento | Valores | Padrão |
|-----------|---------|--------|
| `pasta-do-agente` | Qualquer `AgenteXX_*` | obrigatório |
| `engine` | `gemini` \| `claude` | `gemini` |
| `query` | Prompt direto (omitir para interativo) | interativo |

**Exemplos:**

```powershell
# Sessão interativa com Gemini
factory Agente02_SoftwareArchitect gemini

# One-shot com Gemini
factory Agente04_DevBackend gemini 'Gere o schema Prisma para um SaaS de billing'
factory Agente06_QaEngineer gemini 'Escreva testes E2E para o fluxo de login'

# Com Claude (via terminal, sem abrir sessão)
factory Agente00_TechLead claude 'Qual o status atual do projeto?'
```

---

## Atualizando após mudanças

| Situação | O que fazer |
|----------|-------------|
| Nova máquina ou pasta desatualizada | `git pull` → `.\install.ps1` |
| Moveu a pasta `ai_software_factory` | `.\install.ps1` |
| Editou um `prompt.md` de agente | `.\install.ps1` para propagar a mudança |
| Adicionou um novo agente | Adicione ao array `$agents` no installer → `.\install.ps1` |

---

## Desinstalando

**PowerShell:**
```powershell
Remove-Item "$env:USERPROFILE\.local\bin\factory.ps1"
Remove-Item "$env:USERPROFILE\.claude\agents\techlead.md"
Remove-Item "$env:USERPROFILE\.claude\agents\po.md"
# ... repita para cada agente, ou:
Remove-Item "$env:USERPROFILE\.claude\agents\" -Recurse
```

**Git Bash / Linux / macOS:**
```bash
rm ~/.local/bin/factory
rm ~/.claude/agents/techlead.md ~/.claude/agents/po.md  # etc.
```

---

## Troubleshooting

| Problema | Solução |
|----------|---------|
| `@techlead` não aparece na sessão | Re-execute `install.ps1` e reabra a sessão Claude Code |
| `factory: command not found` | Verifique se `~/.local/bin` está no `$PATH` |
| `gemini: command not found` | `npm install -g @google/gemini-cli` |
| `claude: command not found` | `npm install -g @anthropic-ai/claude-code` |
| Agente responde com comportamento errado | O `prompt.md` foi atualizado? Re-execute o installer |
| `is not recognized` ou `running scripts is disabled` | Execute `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` e tente novamente |
| `Missing an argument for parameter 'Scope'` | O comando foi executado incompleto — copie a linha inteira: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` |
