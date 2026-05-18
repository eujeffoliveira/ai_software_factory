# bibliography/playbooks

Operational playbooks for the ai_software_factory multi-agent SDLC framework.

These playbooks represent distilled operational wisdom for building software with AI agents. They were migrated from the `a-gusman-claude` legacy repository and adapted as generic, client-agnostic references.

## Index

| # | Playbook | Description |
|---|----------|-------------|
| 01 | [Spec Driven Development](01_Spec_Driven_Development.md) | 80/20 rule: spec first, code after. Prevents drift and rework. |
| 02 | [Checklist de Projeto](02_Checklist_Projeto.md) | Complete initialization checklist for new projects (7 sections). |
| 03 | [Database First](03_Database_First.md) | Schema approved before any code. UUIDs, RLS, migrations, anti-patterns. |
| 04 | [Seguranca By Design](04_Seguranca_By_Design.md) | 4-tier permissions, LGPD, security headers, incident response. |
| 05 | [Otimizacao Custos IA](05_Otimizacao_Custos_IA.md) | Opus/Sonnet/Haiku selection by task complexity + economy strategies. |
| 06 | [Desenvolvimento Paralelo](06_Desenvolvimento_Paralelo.md) | 5-terminal workflow, branch strategy, merge order, conflict resolution. |
| 07 | [Quality Assurance](07_Quality_Assurance.md) | 4-level QA pipeline, metrics, code review format. |
| 08 | [Gestao Memoria Contexto](08_Gestao_Memoria_Contexto.md) | Context window management: 60% rule, 5/10 rule, session hygiene. |
| 09 | [Integracao MCPs](09_Integracao_MCPs.md) | Sequential MCP usage, validation, error handling, `.mcp.json` config. |
| 10 | [Automacao Workflows](10_Automacao_Workflows.md) | N8N/Cron/GitHub Actions, idempotency patterns, error handling. |
| 11 | [Incorporacao Software](11_Incorporacao_Software.md) | Strangler Fig, 5-level maturity model, 6 integration phases. |
| 12 | [Power User Skills](12_Power_User_Skills.md) | Orphan skills catalog, meta-flow for creating new agents. |

## How Agents Use These Playbooks

These playbooks are **build-time reference material** — they inform the design of agent behaviors, checklists, and decision rules. At runtime, agents access distilled versions in their own `knowledge/` folders.

Do not reference this folder from agent prompts at runtime. See `AgenteXX_*/knowledge/` for runtime-accessible knowledge.

## Source

Migrated from `https://github.com/eujeffoliveira/a-gusman-claude/tree/main/Playbooks` and adapted for the generic factory framework on 2026-05-18.
