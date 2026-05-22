# Project Archetype Classification — Gate A0

## Purpose

Before any agent applies a Golden Model, the project must be classified into one of the official archetypes. The archetype determines which Golden Model to apply, which agents are required, which artifacts are mandatory, and which items are not applicable.

**Core rule:**
> Choosing the correct archetype is NOT a deviation from the Golden Model and does NOT require an ADR.
> Deviating from the Golden Model WITHIN the chosen archetype DOES require an ADR.

---

## The 8 Official Archetypes

| ID | Name | Description | Default Stack |
|----|------|-------------|--------------|
| `web_app` | Web Application | Fullstack web app with browser UI, authentication, database, deploy | Next.js 16 + React 19 + TypeScript 5 |
| `automation_script` | Automation Script | Script, scheduled task, operational routine, batch job, ETL simple | Python 3.12+ |
| `data_pipeline` | Data Pipeline | ETL/ELT, data transformation, batch processing, analytics at scale | Python 3.12+ + Polars/DuckDB |
| `api_service` | API Service | Standalone REST/GraphQL API or backend service without browser UI | FastAPI (Python) or Next.js Route Handlers |
| `cli_tool` | CLI Tool | Command-line tool, developer utility, local tooling | Python + Typer or Node + Commander |
| `mcp_server` | MCP Server | MCP protocol server exposing tools to AI agents | Python + FastMCP |
| `integration_worker` | Integration Worker | Event consumer, queue worker, webhook handler, recurring sync | Python or Node |
| `notebook_analysis` | Notebook / Analysis | Exploratory analysis, data research, Jupyter notebook | Python + Jupyter |

---

## Gate A0 — Project Archetype Classification

Gate A0 must be completed **before Gate 1** (PRD Review) or any technical work begins.

### When Gate A0 is Required

- The project type is not explicitly stated in the input
- The user's request could map to multiple archetypes
- A new project or major feature is being started
- Existing artifacts appear to assume an incorrect archetype

### Gate A0 Criteria

| Criterion | Status |
|-----------|--------|
| Project archetype explicitly declared | Required |
| Correct Golden Model selected | Required |
| Required agents identified | Required |
| Required artifacts listed | Required |
| Not-applicable items declared | Required |
| ADR requirement assessed | Required |

### Gate A0 Output — Project Classification Record

```json
{
  "gate": "A0",
  "project_name": "string",
  "project_type": "automation_script",
  "golden_model": "python_automation",
  "classification_rationale": "Project is a scheduled Python script that reads an API and writes a report. No browser UI.",
  "required_agents": ["techlead", "engineer", "qa", "devsecops"],
  "optional_agents": ["dataengineer", "devops"],
  "required_artifacts": [
    "Automation_Brief.md",
    "Automation_Design.md",
    "Config_And_Secrets.md",
    "Idempotency_Plan.md",
    "Runbook.md",
    "Test_Plan.md"
  ],
  "not_applicable": [
    "React components",
    "NextAuth",
    "Prisma schema",
    "Vercel deployment",
    "Route Handlers",
    "Architecture.md (web format)",
    "PRD.md (product requirements)"
  ],
  "adr_required": false,
  "adr_reason": null
}
```

---

## Archetype Selection Decision Tree

```
1. Is there a browser UI (HTML pages, React/Vue components, user-facing web pages)?
   YES → web_app

2. Is it a standalone REST or GraphQL API with no UI?
   YES → api_service

3. Is it a Python script, scheduled job, or operational routine?
   YES → Does it primarily transform or move data at scale (GB+, complex lineage)?
     YES → data_pipeline
     NO  → automation_script

4. Is it a command-line tool for developers or operators?
   YES → cli_tool

5. Is it a server that exposes tools via the MCP protocol?
   YES → mcp_server

6. Is it a queue consumer, event handler, webhook processor, or recurring sync worker?
   YES → integration_worker

7. Is it a Jupyter notebook or exploratory data analysis?
   YES → notebook_analysis

8. Unclear → Invoke Gate A0 and ask the user before proceeding.
```

---

## Required Agents by Archetype

| Archetype | Required | Optional | Usually Not Applicable |
|-----------|---------|----------|----------------------|
| `web_app` | techlead, po, architect, engineer, devbackend, devfrontend, qa, devsecops, devops | uxui, dataengineer | — |
| `automation_script` | techlead, engineer, qa, devsecops | dataengineer, devops | po, architect, devfrontend, uxui |
| `data_pipeline` | techlead, dataengineer, engineer, qa | devops, devsecops | devfrontend, uxui, po |
| `api_service` | techlead, architect, engineer, devbackend, qa, devsecops | devops | devfrontend, uxui |
| `cli_tool` | techlead, engineer, qa | devsecops | po, devfrontend, uxui, devops |
| `mcp_server` | techlead, engineer, qa, devsecops | devops | po, devfrontend, uxui |
| `integration_worker` | techlead, dataengineer, engineer, qa, devsecops | devops | devfrontend, uxui |
| `notebook_analysis` | techlead, dataengineer | qa | po, devfrontend, uxui, devops, devsecops |

---

## ADR Rules by Situation

| Situation | ADR Required? | Notes |
|-----------|:---:|-------|
| Choosing the correct archetype for a project | NO | Routing, not deviation |
| Switching archetype mid-project | YES | Scope change — human approval recommended |
| Using Python for `automation_script` | NO | Default stack |
| Using TypeScript for `automation_script` | YES | Deviation from Python default |
| Deviating from any library in the Golden Model of the archetype | YES | Standard ADR flow |
| Adding a library not listed in the Golden Model | YES | Standard ADR flow |

---

## Golden Model Index

| Archetype | Golden Model File |
|-----------|-------------------|
| `web_app` | [golden-model-web-app.md](./golden-model-web-app.md) |
| `automation_script` | [golden-model-python-automation.md](./golden-model-python-automation.md) |
| `data_pipeline` | [golden-model-data-pipeline.md](./golden-model-data-pipeline.md) |
| `api_service` | [golden-model-api-service.md](./golden-model-api-service.md) |
| `cli_tool` | [golden-model-cli-tool.md](./golden-model-cli-tool.md) |
| `mcp_server` | [golden-model-mcp-server.md](./golden-model-mcp-server.md) |
| `integration_worker` | [golden-model-integration-worker.md](./golden-model-integration-worker.md) |
| `notebook_analysis` | [golden-model-notebook-analysis.md](./golden-model-notebook-analysis.md) |
