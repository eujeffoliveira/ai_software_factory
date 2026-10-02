# Compatibilidade com Clientes de IA

## Resumo

| Cliente | Agentes | MCP | Modo de ativação | Suporte |
|---|---|---|---|---|
| Claude Code | Sim | Sim | `@nome` via `~/.claude/agents/*.md` | Completo |
| Codex | Sim | Sim | custom agents em `~/.codex/agents/*.toml` | Completo |
| Antigravity | Sim | Sim | skills (`techlead`, etc.) em `~/.gemini/config/plugins/` | Completo |
| GitHub Copilot | Sim | Sim | `@nome` / seletor de agentes via `~/.copilot/agents/*.agent.md` + prompt files (`.github/prompts/`) + MCP global e local (`mcp.json`) | Completo |
| ChatGPT/outros | Manual | Não | colar prompts/knowledge | Manual |

Todos os runtimes completos usam a mesma fonte canônica:

```text
AgenteXX_*/prompt.md
AgenteXX_*/knowledge/
AgenteXX_*/skills_manifest.md
AgenteXX_*/quality_gate.md
AgenteXX_*/context_view.md
AgenteXX_*/failure_modes.md
```

## Claude Code

Claude Code é o runtime histórico da factory.

Após `.\install.ps1`, os agentes ficam em:

```text
~/.claude/agents/<nome>.md
```

Uso:

```text
@techlead avalie a arquitetura deste projeto
@po escreva user stories para autenticação
@qa crie testes Playwright para o fluxo de login
```

O MCP `knowledge` é registrado em `~/.claude.json` com `mcpServers.knowledge`.

## Codex

Codex usa custom agents, não a sintaxe Claude `@nome`.

Após `.\install.ps1`, os agentes ficam em:

```text
~/.codex/agents/<nome>.toml
```

Uso:

```text
Use the techlead custom agent to classify this project.
Spawn qa and devsecops as subagents and summarize their findings.
```

O MCP `knowledge` é configurado em:

```text
~/.codex/config.toml
.codex/config.toml
```

Leia detalhes em `docs/CODEX.md`.

## Antigravity

Antigravity usa um plugin global com skills e MCP registrados em:

```text
~/.gemini/config/plugins/ai-software-factory/
~/.gemini/config/mcp_config.json
```

Uso:

```text
Ative a skill techlead e avalie os quality gates deste projeto.
Use a skill qa para criar a suite de testes Vitest.
```

O Antigravity carrega as skills sob demanda (progressive disclosure) e pode invocar subagentes dedicados (`invoke_subagent`).
O MCP `knowledge` é registrado diretamente com ferramentas eager (`mcp_knowledge_search_knowledge`, `mcp_knowledge_get_full_document`, etc.).

Leia detalhes em `docs/ANTIGRAVITY.md`.

## GitHub Copilot

GitHub Copilot opera no VS Code com suporte global e local por workspace.

Após `.\install.ps1`, os artefatos ficam em:

```text
~/.copilot/agents/*.agent.md                       # Custom Agents globais de usuário (qualquer projeto)
.github/agents/*.agent.md                          # Custom Agents do workspace
.github/copilot-instructions.md                    # Diretrizes do SDLC e Quality Gates
.github/prompts/*.prompt.md                        # Prompt files reutilizáveis
.vscode/mcp.json                                   # Conexão MCP knowledge (Agent mode workspace)
%APPDATA%/Code/User/mcp.json                       # Conexão MCP knowledge global (qualquer projeto)
```

Uso:

```text
# 1. Globalmente em qualquer projeto/pasta via Custom Agents:
@techlead Avalie a arquitetura deste projeto
@qa Crie testes Playwright para o fluxo de checkout
@po Escreva user stories para o novo módulo de faturamento

# 2. Localmente no workspace via prompt files:
#file:techlead.prompt.md Avalie a aderencia ao Gate G0 deste projeto
#file:qa.prompt.md Elabore o plano de testes Vitest e Playwright

# Ou diretamente invocando a persona conhecida pelas copilot-instructions:
Atue como o @architect e elabore o diagrama C4 de componentes.
```

No VS Code Copilot Agent mode, o servidor MCP `knowledge` permite tool calling nativo
para busca de principios, heuristicas e playbooks.

Leia detalhes em `docs/COPILOT.md`.

## Uso manual

Para clientes sem integração:

1. Abra `AgenteXX_*/prompt.md`.
2. Copie o prompt para o cliente.
3. Copie manualmente trechos de `knowledge/` se necessário.
4. Declare manualmente quality gates, ADRs, State Ledger e Definition of Done.

Esse modo não deve ser usado para operação de produção da factory.

## Compatibilidade removida

- **Custom modes legados do VS Code**: substituídos pelo suporte nativo ao **GitHub Copilot** (reusable prompt files em `.github/prompts/` e Agent mode MCP).
- **Gemini CLI (`factory.ps1`)**: utilitário legado de terminal depreciado em favor da integração nativa com o **Google Antigravity** (plugin global, skills modulares e progressive disclosure).

## Comparação de recursos

| Recurso | Claude Code | Codex | Antigravity | GitHub Copilot | Manual |
|---|---:|---:|---:|---:|---:|
| Prompt completo | Sim | Sim | Sim | Sim | Manual |
| Knowledge embutida | Sim | Sim | Sim | Sim | Manual |
| MCP Knowledge | Sim | Sim | Sim | Sim | Não |
| Agentes especializados | `@nome` | custom agents | skills (`techlead`, etc.) | prompt files | Manual |
| State Ledger | Sim | Sim | Sim | Sim | Manual |
| Quality gates | Sim | Sim | Sim | Sim | Manual |
| Config por projeto | Opcional | `.codex/config.toml` | `AGENTS.md` | `.github/` & `.vscode/` | Não |

## Validação

```powershell
.\doctor.ps1
.\test-mcp.ps1
python tools/factory-validators/run_all.py
```

`doctor.ps1` valida agentes Claude, custom agents Codex, skills e plugin Antigravity, MCP, `knowledge.db` e
scripts esperados.
