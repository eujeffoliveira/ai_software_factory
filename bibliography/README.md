# bibliography/

Reference material for the ai_software_factory framework. Build-time resources only — not accessible at runtime.

## Structure

```
bibliography/
└── playbooks/            # Operational playbooks for AI-assisted development
    ├── README.md         # Playbook index
    ├── 01_Spec_Driven_Development.md
    ├── 02_Checklist_Projeto.md
    ├── 03_Database_First.md
    ├── 04_Seguranca_By_Design.md
    ├── 05_Otimizacao_Custos_IA.md
    ├── 06_Desenvolvimento_Paralelo.md
    ├── 07_Quality_Assurance.md
    ├── 08_Gestao_Memoria_Contexto.md
    ├── 09_Integracao_MCPs.md
    ├── 10_Automacao_Workflows.md
    ├── 11_Incorporacao_Software.md
    └── 12_Power_User_Skills.md
```

## Access Policy

**Build-time only.** These files inform the design of agent artifacts during the build process.

- Agents do **not** read from `bibliography/` at runtime
- Knowledge distilled from these sources lives in each agent's `knowledge/` folder
- When building or updating agents, reference these playbooks to inform `principles.md`, `heuristics.md`, and `decision_rules.md`

## Playbooks

12 operational playbooks covering the full AI-assisted development lifecycle:

| Range | Topic |
|-------|-------|
| 01-03 | Process (SDD, project setup, database design) |
| 04-05 | Quality (security, AI cost optimization) |
| 06-07 | Execution (parallel development, QA) |
| 08-09 | Operations (context management, MCP integration) |
| 10-12 | Advanced (workflow automation, software incorporation, power-user skills) |

## Source

Migrated from `https://github.com/eujeffoliveira/a-gusman-claude` on 2026-05-18 during the Capability Upgrade mission. Adapted for the generic factory framework (removed organization-specific references).
