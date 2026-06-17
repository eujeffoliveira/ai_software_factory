# Compatibilidade com Clientes de IA

## Resumo

| Cliente | Agentes | MCP | Modo de ativação | Suporte |
|---|---|---|---|---|
| Claude Code | Sim | Sim | `@nome` via `~/.claude/agents/*.md` | Completo |
| Codex | Sim | Sim | custom agents em `~/.codex/agents/*.toml` | Completo |
| Gemini CLI | Parcial | Não | wrapper `factory.ps1` | Parcial |
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

## Gemini CLI

Gemini CLI tem suporte parcial via `factory.ps1`.

```powershell
factory Agente06_QaEngineer gemini "Escreva testes E2E para checkout"
factory Agente02_SoftwareArchitect gemini
```

Limitações:

- sem `@nome`;
- sem MCP `knowledge`;
- sem custom agents nativos;
- sem handoff automático;
- exige fornecer contexto manual quando necessário.

## Uso manual

Para clientes sem integração:

1. Abra `AgenteXX_*/prompt.md`.
2. Copie o prompt para o cliente.
3. Copie manualmente trechos de `knowledge/` se necessário.
4. Declare manualmente quality gates, ADRs, State Ledger e Definition of Done.

Esse modo não deve ser usado para operação de produção da factory.

## Compatibilidade removida

O runtime de custom modes do VS Code não é mais suportado pela factory. O
instalador não gera custom modes, não cria script dedicado para esse runtime,
não edita configurações do VS Code e o diagnóstico não valida esses artefatos.

## Comparação de recursos

| Recurso | Claude Code | Codex | Gemini CLI | Manual |
|---|---:|---:|---:|---:|
| Prompt completo | Sim | Sim | Parcial | Manual |
| Knowledge embutida | Sim | Sim | Não | Manual |
| MCP Knowledge | Sim | Sim | Não | Não |
| Agentes especializados | `@nome` | custom agents | wrapper | Manual |
| State Ledger | Sim | Sim | Manual | Manual |
| Quality gates | Sim | Sim | Manual | Manual |
| Config por projeto | Opcional | `.codex/config.toml` | Não | Não |

## Validação

```powershell
.\doctor.ps1
.\test-mcp.ps1
python tools/factory-validators/run_all.py
```

`doctor.ps1` valida agentes Claude, custom agents Codex, MCP, `knowledge.db` e
scripts esperados.
