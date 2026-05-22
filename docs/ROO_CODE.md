# Roo Code / Cline — Guia de Uso

## O que são os custom modes

O Roo Code (e o Cline) suportam **custom modes** — perfis de agente com system prompt customizado, permissões específicas e regras de comportamento. A factory gera automaticamente 11 modos (um por agente) durante a execução de `install.ps1`.

Cada modo corresponde a um agente da factory com:

- System prompt completo (extraído de `AgenteXX_*/prompt.md`)
- 8 arquivos de knowledge embutidos (principles, heuristics, decision_rules, knowledge_cards, etc.)
- Bloco de instruções MCP ao final
- Permissões: `read`, `edit`, `browser`, `command`, `mcp`

Os arquivos gerados são `roo/.roomodes` e `roo/.clinerules` (gitignored — gerados pela máquina local).

## Vincular a um projeto

Para ativar os agentes da factory em um projeto:

```powershell
# No diretório do projeto alvo
cd C:\meu-projeto
& "$env:FACTORY_ROOT\link-roo.ps1"
```

O script `link-roo.ps1` copia `.roomodes` e `.clinerules` da factory para a raiz do projeto, com backup automático das versões anteriores (`.roomodes.bak`, `.clinerules.bak`). A factory em si **não é copiada** — apenas os arquivos de configuração que apontam para ela.

Após executar, recarregue o VS Code para que os modos apareçam no painel do Roo Code.

## Modos disponíveis

| Modo | Agente | Emoji | Papel |
|------|--------|-------|-------|
| `techlead` | Agente00_TechLead | 🏗️ | Orquestrador do pipeline SDLC |
| `po` | Agente01_ProductOwner | 📋 | Requisitos e user stories |
| `architect` | Agente02_SoftwareArchitect | 📐 | Arquitetura e decisões técnicas |
| `engineer` | Agente03_SoftwareEngineer | ⚙️ | Plano de execução e decomposição |
| `devbackend` | Agente04_DevBackend | 🔌 | APIs, banco e lógica de negócio |
| `devfrontend` | Agente05_DevFrontend | 🎨 | UI, componentes e páginas |
| `qa` | Agente06_QaEngineer | 🧪 | Testes, cobertura e qualidade |
| `devsecops` | Agente07_DevSecOps | 🔒 | Segurança e conformidade |
| `devops` | Agente08_DevOps | 🚀 | CI/CD, deploy e infraestrutura |
| `uxui` | Agente09_UxUiDesigner | ✏️ | UX research, wireframes e design system |
| `dataengineer` | Agente10_DataIntegrationEngineer | 🗄️ | Pipelines, ETL e integrações de dados |

Todos os modos têm as seguintes permissões habilitadas: `read`, `edit`, `browser`, `command`, `mcp`.

## MCP no Roo Code

O servidor MCP Knowledge Search é configurado globalmente por `install.ps1` em:

```
%APPDATA%\Code\User\globalStorage\rooveterinaryinc.roo-cline\settings\mcp_settings.json
```

Para adicionar a configuração local ao projeto (alternativa ao global):

```powershell
& "$env:FACTORY_ROOT\link-mcp.ps1"
```

Isso cria `.mcp.json` no diretório atual com a entrada `mcpServers.knowledge` apontando para o servidor da factory.

## .clinerules

O arquivo `.clinerules` contém regras globais aplicadas a **todos os modos** no Roo Code. A factory usa esse arquivo para:

- Reforçar a política MCP-first
- Definir que agentes nunca acessam `context/` ou `lib/` em runtime
- Indicar que fallback silencioso é proibido

As regras em `.clinerules` têm precedência sobre instruções genéricas do Roo Code, mas são sobrescritas pelo system prompt de cada modo.

## Diferença em relação ao Claude Code

| Funcionalidade | Claude Code (CLI) | Roo Code (VS Code) |
|----------------|-------------------|---------------------|
| Invocação do agente | `@nome-do-agente` | Selecionar modo no painel |
| Instalação global | Sim — any directory | Requer `link-roo.ps1` por projeto |
| Configuração MCP | `~/.claude.json` (global) | `mcp_settings.json` (global) ou `.mcp.json` (local) |
| Arquivo de regras | N/A | `.clinerules` (aplicado a todos os modos) |
| Arquivos de agente | `~/.claude/agents/*.md` | Embutidos em `.roomodes` |
| Configuração de projeto | Não necessária | `link-roo.ps1` por projeto |

## Workflow de uso típico

```
1. install.ps1 na factory (uma vez por máquina)
2. link-roo.ps1 no projeto alvo
3. Abrir VS Code no projeto alvo
4. Selecionar modo no painel do Roo Code (ex: "🏗️ Tech Lead")
5. Iniciar conversa normalmente
```

## Atualizar modos após mudança na factory

Se a factory foi atualizada (`git pull` ou edição de `prompt.md`):

```powershell
# Na factory: regerou os arquivos de modo
.\install.ps1

# Em cada projeto vinculado: propaga os novos modos
& "$env:FACTORY_ROOT\link-roo.ps1"
```

O `install.ps1` é idempotente — rodar duas vezes é seguro.

## Solução de problemas

| Problema | Solução |
|----------|---------|
| Modos não aparecem no Roo Code | Execute `link-roo.ps1` e recarregue o VS Code (`Ctrl+Shift+P` → `Reload Window`) |
| MCP não funciona no Roo Code | Execute `.\install.ps1` e reinicie o VS Code |
| Modo aparece mas sem knowledge | Execute `.\install.ps1` — regera os arquivos de agente com knowledge embutida |
| `.roomodes` desatualizado | Execute `.\install.ps1` na factory, depois `link-roo.ps1` no projeto |
| Backup do `.roomodes` anterior | O script salva como `.roomodes.bak` na raiz do projeto |

Consulte também `docs/TROUBLESHOOTING.md` para problemas de instalação e MCP.
