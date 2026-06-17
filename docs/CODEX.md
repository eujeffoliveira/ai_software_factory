# Codex

Este guia explica como usar a AI Software Factory no Codex preservando a mesma
fonte canônica dos agentes usados por Claude Code e Roo Code.

## Modelo de integração

No Codex, os agentes da factory são instalados como **custom agents** em:

```text
~/.codex/agents/<nome>.toml
```

Esses arquivos são gerados por `install.ps1` a partir dos mesmos artefatos que
alimentam Claude Code:

- `AgenteXX_*/prompt.md`
- `AgenteXX_*/knowledge/`
- `skills_manifest.md`
- `quality_gate.md`
- `context_view.md`
- `failure_modes.md`

Isso evita forks de prompt por runtime. Se um agente mudar, atualize a fonte
canônica e reexecute `.\install.ps1`.

## Instalação

Da raiz da factory:

```powershell
.\install.ps1
```

O instalador cria ou atualiza:

- `~/.codex/agents/*.toml` com os 11 custom agents
- `~/.codex/agents/.ai_software_factory_manifest.json`
- bloco `mcp_servers.knowledge` em `~/.codex/config.toml`
- `.codex/config.toml` local nesta factory, com caminhos relativos

Se `CODEX_HOME` estiver definido, o instalador respeita esse diretório no lugar
de `~/.codex`.

## Uso

Codex não usa a sintaxe `@techlead` do Claude Code. Peça explicitamente para usar
ou spawnar um custom agent:

```text
Use the techlead custom agent to classify this project and propose the SDLC flow.
```

```text
Spawn architect and devsecops as subagents, wait for both, then compare risks.
```

Os nomes disponíveis são:

```text
techlead
po
architect
engineer
devbackend
devfrontend
qa
devsecops
devops
uxui
dataengineer
```

## MCP Knowledge

O servidor `knowledge` é configurado no formato nativo do Codex:

```toml
[mcp_servers.knowledge]
command = "python"
args = ["<factory>/tools/mcp-knowledge-search/server.py"]

[mcp_servers.knowledge.env]
KNOWLEDGE_DB = "<factory>/knowledge.db"
```

No projeto da factory, `install.ps1` também gera `.codex/config.toml` com
caminhos relativos:

```toml
[mcp_servers.knowledge]
command = "python"
args = ["tools/mcp-knowledge-search/server.py"]
cwd = ".."
```

Para ativar o MCP em outro projeto:

```powershell
cd C:\meu-projeto
& "$env:FACTORY_ROOT\link-mcp.ps1"
```

Esse comando cria `.mcp.json` para clientes compatíveis com o formato Claude/Roo
e adiciona um bloco gerenciado em `.codex/config.toml` para Codex.

## Teste rápido

Da raiz da factory:

```powershell
.\test-mcp.ps1
.\doctor.ps1
python tools/factory-validators/run_all.py
```

Em uma sessão Codex, use `/mcp` para confirmar que `knowledge` está conectado
quando o cliente expõe esse comando.

## Limitações conhecidas

- Codex custom agents são usados como subagentes sob solicitação explícita; eles
  não substituem a sintaxe `@nome` do Claude Code.
- O arquivo `AGENTS.md` orienta o agente principal do Codex no repositório, mas
  não é uma lista de comandos invocáveis.
- A configuração `.codex/config.toml` local só é carregada por projetos
  confiáveis no Codex.
- O MCP `knowledge` depende de Python, pacote `mcp` e `knowledge.db` atualizado.
- O Gemini CLI continua parcial e não recebe MCP automaticamente.

## Quando reexecutar o instalador

Reexecute `.\install.ps1` quando:

- algum `AgenteXX_*/prompt.md` mudar;
- algum arquivo em `knowledge/` mudar e você quiser atualizar os custom agents;
- a factory for movida de pasta;
- `knowledge.db`, `.mcp.json`, `.codex/config.toml` ou os agentes gerados
  precisarem ser reconstruídos.
