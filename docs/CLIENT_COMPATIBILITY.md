# Compatibilidade com Clientes de IA

## Resumo

| Cliente | Agentes | MCP | Modos personalizados | Suporte |
|---------|---------|-----|---------------------|---------|
| Claude Code (CLI) | Pleno via `@nome` | Sim (global, stdio) | N/A — usa `@nome` | Completo |
| Roo Code (VS Code) | Pleno via custom modes | Sim (global ou local) | Sim — `link-roo.ps1` | Completo |
| Cline (VS Code) | Pleno via custom modes | Sim (local) | Sim — `link-roo.ps1` | Completo |
| Gemini CLI | Via wrapper `factory.ps1` | Não | Não | Parcial |
| ChatGPT / outros | Manual (colar prompt) | Não | Não | Manual |

---

## Claude Code

**Suporte completo.** É o cliente primário da factory.

Após `.\install.ps1`, os 11 agentes ficam disponíveis como `@nome` em qualquer diretório do sistema — sem configuração por projeto.

### Uso

```powershell
# Em qualquer diretório
claude

# Na sessão do Claude Code:
@techlead avalie a arquitetura deste projeto
@po escreva as user stories para o módulo de autenticação
@qa crie testes Playwright para o fluxo de login
```

### Como funciona

- Arquivos de agente em `~/.claude/agents/*.md` com conteúdo híbrido (prompt + knowledge + bloco MCP)
- MCP configurado em `~/.claude.json` (raiz, escopo user)
- Servidor MCP iniciado sob demanda via stdio pelo Claude Code

### Limitações

Nenhuma limitação conhecida para uso da factory.

---

## Roo Code

**Suporte completo.** Requer VS Code com extensão Roo Code instalada e `link-roo.ps1` por projeto.

### Configuração

```powershell
# Na factory (uma vez por máquina)
.\install.ps1

# No projeto alvo
cd C:\meu-projeto
& "$env:FACTORY_ROOT\link-roo.ps1"

# Recarregar VS Code
# Selecionar modo no painel Roo Code
```

### Como funciona

- `.roomodes` no projeto define os 11 custom modes com system prompts completos
- `.clinerules` define regras globais (MCP-first policy, isolamento runtime)
- MCP configurado globalmente em `mcp_settings.json` por `install.ps1`

### Configuração MCP local (alternativa)

```powershell
& "$env:FACTORY_ROOT\link-mcp.ps1"
```

Cria `.mcp.json` no projeto com a entrada `mcpServers.knowledge`.

### Múltiplos projetos

Execute `link-roo.ps1` em cada projeto onde quiser usar os agentes. Não há limite de projetos.

---

## Cline

**Suporte completo.** Usa os mesmos arquivos do Roo Code (`.roomodes` e `.clinerules`).

### Configuração

Igual ao Roo Code:

```powershell
& "$env:FACTORY_ROOT\link-roo.ps1"
```

O Cline lerá `.roomodes` do diretório do projeto e apresentará os 11 modos no painel.

### Diferença em relação ao Roo Code

O Cline pode ter diferenças na UI de seleção de modos e nas permissões padrão, mas os arquivos de configuração são compatíveis. Teste as permissões após vincular.

---

## Gemini CLI

**Suporte parcial** via wrapper `factory.ps1` (gerado por `install.ps1`).

### Uso

```powershell
# Invocar agente específico
factory Agente06_QaEngineer gemini 'Escreva testes E2E para o fluxo de checkout'

# Modo interativo com agente
factory Agente02_SoftwareArchitect gemini

# Listar agentes disponíveis
factory list
```

### Como funciona

O `factory.ps1` lê o `prompt.md` do agente especificado e o passa como system prompt para o Gemini CLI.

### Limitações

| Funcionalidade | Status |
|----------------|--------|
| Invocação via `@nome` | Não suportado |
| MCP Knowledge Search | Não disponível |
| Acesso automático a knowledge | Não disponível |
| Custom modes | Não disponível |
| Handoff automático entre agentes | Não disponível |

**Recomendação:** para projetos que exigem acesso ao MCP e knowledge completa, prefira Claude Code ou Roo Code. Use o Gemini CLI apenas para tarefas isoladas onde o contexto pode ser fornecido manualmente.

---

## Uso manual (ChatGPT, outros)

**Suporte manual.** Não recomendado para uso em produção da factory.

### Como usar

1. Abra o arquivo de prompt do agente: `AgenteXX_Nome/prompt.md`
2. Cole o conteúdo como system prompt no cliente de sua escolha
3. Para acesso a knowledge, copie manualmente as seções relevantes de `AgenteXX_Nome/knowledge/`
4. Não há MCP, tools automáticas ou handoff estruturado

### Limitações graves

- Sem MCP: o agente não pode buscar skills, templates ou checklists dinamicamente
- Sem knowledge automática: o conteúdo de `knowledge/` precisa ser colado manualmente no contexto
- Sem orchestração: não há State Ledger, gates ou handoff estruturado
- Contexto limitado: arquivos de knowledge completos podem exceder o contexto do cliente

---

## Comparação de recursos

| Recurso | Claude Code | Roo Code | Cline | Gemini CLI | Manual |
|---------|-------------|----------|-------|------------|--------|
| System prompt completo | Automático | Automático | Automático | Via wrapper | Manual |
| Knowledge embutida | Sim | Sim | Sim | Não | Manual |
| MCP Knowledge Search | Sim | Sim | Sim | Não | Não |
| Handoff entre agentes | Sim | Sim | Sim | Manual | Manual |
| State Ledger | Sim | Sim | Sim | Manual | Manual |
| Gate validation | Automático | Automático | Automático | Manual | Manual |
| Config por projeto | Não necessária | `link-roo.ps1` | `link-roo.ps1` | Não | Não |
| Instalação | `install.ps1` | `install.ps1` + `link-roo.ps1` | Igual Roo Code | `install.ps1` | Nenhuma |

---

## Instalação e pré-requisitos

Para todos os clientes com suporte completo ou parcial:

```powershell
# Pré-requisito: Python 3.x no PATH
python --version

# Instalar factory
cd C:\Projetos\ai_software_factory
.\install.ps1
```

Consulte `docs/INSTALLATION.md` para o processo completo de instalação.
