# Universal Factory CLI — Installation Guide

## What is the Universal Factory CLI?

The Universal Factory CLI is a thin bash wrapper (`~/.local/bin/factory`) that lets you invoke any of the 11 SDLC agents in this repository from **any directory on your machine** — not just from inside the `ai_software_factory` project.

### Advantages

| Advantage | Detail |
|-----------|--------|
| **Decoupling** | Agents live in one place; you call them from any project |
| **Context isolation** | Each agent session reads only its own `prompt.md` and `knowledge/` — zero cross-contamination |
| **Multi-engine** | Works with `claude` CLI or `gemini` CLI interchangeably |
| **Interactive or one-shot** | Drop the query argument for a REPL session; include it for scripted use |
| **Portability** | Re-run `install.sh` after cloning to a new machine; the wrapper self-updates |

---

## Prerequisites

Before running `install.sh`, make sure at least one of these CLIs is installed and on your PATH:

| CLI | Install |
|-----|---------|
| **Claude CLI** (required for `claude` engine) | `npm install -g @anthropic-ai/claude-code` |
| **Gemini CLI** (required for `gemini` engine) | `npm install -g @google/gemini-cli` |

Verify:
```bash
claude --version
gemini --version
```

---

## Installation

From the root of the `ai_software_factory` repository:

```bash
chmod +x install.sh
./install.sh
```

Then activate the aliases in your current shell:

```bash
# Bash
source ~/.bashrc

# Zsh
source ~/.zshrc
```

The installer is **idempotent** — safe to re-run after pulling updates or cloning to a new machine.

### What the installer does

1. Discovers `FACTORY_PATH` from `pwd` (where you run `install.sh`)
2. Creates `~/.local/bin/` if it doesn't exist
3. Writes `~/.local/bin/factory` with your `FACTORY_PATH` embedded
4. Detects your shell (`bash` or `zsh`) and injects 11 short aliases
5. Ensures `~/.local/bin` is on your `$PATH`

---

## Agent Aliases

After installation, these shortcuts are available from any directory:

| Alias | Agent | Role |
|-------|-------|------|
| `techlead` | `Agente00_TechLead` | Project oversight, quality gates, ADRs |
| `po` | `Agente01_ProductOwner` | User stories, acceptance criteria, backlog |
| `architect` | `Agente02_SoftwareArchitect` | System design, UML, architecture decisions |
| `engineer` | `Agente03_SoftwareEngineer` | Task decomposition, implementation planning |
| `devbackend` | `Agente04_DevBackend` | APIs, services, database layers, migrations |
| `devfrontend` | `Agente05_DevFrontend` | React components, pages, UI logic |
| `qa` | `Agente06_QaEngineer` | Unit, integration, E2E tests, test plans |
| `devsecops` | `Agente07_DevSecOps` | Security audits, SAST, hardening |
| `devops` | `Agente08_DevOps` | CI/CD, infrastructure, deployment, monitoring |
| `uxui` | `Agente09_UxUiDesigner` | UX research, wireframes, design systems |
| `dataengineer` | `Agente10_DataIntegrationEngineer` | Data pipelines, integrations, ETL |

---

## Usage

### Short alias (interactive REPL)

```bash
cd my-project/
techlead
```

Opens an interactive Claude session with `Agente00_TechLead`'s system prompt active. The agent has access to its own `knowledge/` folder but not to your current project files unless you tell it to read them.

### Short alias (one-shot query)

The aliases default to the `claude` engine. Pass a query as arguments:

```bash
architect 'Design a REST API for a payments service'
qa 'Write Playwright E2E tests for the login flow'
devsecops 'Audit the authentication middleware for OWASP Top 10'
```

### `factory` wrapper (full control)

```bash
factory <agent-folder> [engine] [query...]
```

| Argument | Values | Default |
|----------|--------|---------|
| `agent-folder` | Any `AgenteXX_*` folder name | required |
| `engine` | `claude` \| `gemini` | `claude` |
| `query` | Prompt text (omit for interactive) | interactive |

Examples:

```bash
# Interactive session with Gemini engine
factory Agente02_SoftwareArchitect gemini

# One-shot with Claude
factory Agente04_DevBackend claude 'Generate Prisma schema for a SaaS billing model'

# Use Gemini for a specific agent
factory Agente09_UxUiDesigner gemini 'Create a wireframe spec for a dashboard'
```

---

## Uninstalling

To remove the CLI:

```bash
rm ~/.local/bin/factory
```

Then remove the alias block from `~/.bashrc` or `~/.zshrc` — it is delimited by:

```
# BEGIN factory-aliases (ai_software_factory)
...
# END factory-aliases (ai_software_factory)
```

---

## Updating after pulling changes

If you pull new commits that update `prompt.md` files, you do **not** need to re-run `install.sh` — the wrapper reads `prompt.md` at call time, so it always uses the latest version.

Re-run `install.sh` only if:
- You cloned the repo to a new machine
- You moved the `ai_software_factory` folder to a different path
- A new agent folder was added and you want its alias

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `factory: command not found` | Run `source ~/.bashrc` (or `~/.zshrc`) and verify `~/.local/bin` is in `$PATH` |
| `Error: agent folder not found` | Re-run `install.sh` — `FACTORY_PATH` may point to an old location |
| `claude: command not found` | Install Claude CLI: `npm install -g @anthropic-ai/claude-code` |
| `gemini: command not found` | Install Gemini CLI: `npm install -g @google/gemini-cli` |
| Aliases injected twice | Remove duplicate block from `~/.bashrc` / `~/.zshrc`; installer guards against this on future runs |
