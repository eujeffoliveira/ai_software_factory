# Arquétipos de Projeto e Gate A0

## O que é o Gate A0

O Gate A0 roda **antes de todos os gates numerados** quando o tipo de projeto não é imediatamente óbvio. Ele classifica o arquétipo do projeto e seleciona o Golden Model correspondente, habilitando o Tech Lead a configurar corretamente o pipeline SDLC.

**Códigos de status:** `A0_APPROVED` | `A0_AMBIGUOUS` | `A0_BLOCKED`

- `A0_APPROVED` — arquétipo identificado com confiança, Golden Model selecionado
- `A0_AMBIGUOUS` — dois ou mais arquétipos possíveis; Tech Lead solicita informações adicionais ao humano
- `A0_BLOCKED` — o projeto não se encaixa em nenhum arquétipo; requer discussão antes de prosseguir

## Como acionar o Gate A0

```
@techlead Classifique o arquétipo deste projeto: [descrição do projeto]
```

O Tech Lead retorna um JSON de classificação:

```json
{
  "project_type": "web_app",
  "golden_model": "standards/golden-model-web-app.md",
  "required_agents": ["Agente01_ProductOwner", "Agente02_SoftwareArchitect", "..."],
  "required_artifacts": ["PRD.md", "Architecture.md", "..."],
  "not_applicable": ["Agente10_DataIntegrationEngineer"],
  "gate_status": "A0_APPROVED",
  "rationale": "O projeto tem interface de usuário e é acessado por navegador. Stack Next.js 16 aplicável."
}
```

## Regra fundamental

Escolher o arquétipo correto **não exige ADR**. ADRs são necessários apenas para desvios *dentro* do arquétipo escolhido (ex: usar MongoDB em vez de PostgreSQL num `web_app`).

## Os 8 Arquétipos

---

### 1. web_app

**O que é:** Aplicação web com interface de usuário acessada por navegador. Pode ser B2C, B2B, SaaS ou interna.

**Encaixa:**
- Plataforma de e-commerce com catálogo, carrinho e checkout
- Portal interno de RH com autenticação corporativa
- Dashboard SaaS com multi-tenancy
- Backoffice administrativo com CRUD completo

**Não encaixa:**
- Script que roda no cron sem UI (→ `automation_script`)
- API usada apenas por mobile ou terceiros sem UI (→ `api_service`)
- Pipeline de dados batch (→ `data_pipeline`)

**Golden Model:** `standards/golden-model-web-app.md`
**Stack:** Next.js 16 + React 19 + TypeScript + Tailwind + NextAuth + Supabase + Prisma + Vercel

---

### 2. automation_script

**O que é:** Script que roda em schedule, gatilho ou on-demand. Processa dados, chama APIs, gera relatórios. Sem interface interativa permanente.

**Encaixa:**
- Sincronização diária de dados do ERP para banco local
- Gerador de relatórios CSV enviados por e-mail
- Script de limpeza de dados que roda às 2h
- Cron job que chama API de terceiros e persiste resultado

**Não encaixa:**
- CLI interativa distribuída como pacote (→ `cli_tool`)
- API REST com endpoints (→ `api_service`)
- Processador de eventos em tempo real (→ `integration_worker`)
- Pipeline com múltiplas fontes e transformações complexas (→ `data_pipeline`)

**Golden Model:** `standards/golden-model-python-automation.md`
**Stack:** Python 3.12+ + uv + Typer + Pydantic v2 + structlog + pytest

---

### 3. data_pipeline

**O que é:** Pipeline de dados com ingestão de múltiplas fontes, transformações complexas, validação de qualidade e carga em destino analítico.

**Encaixa:**
- ETL do Salesforce + ERP para data warehouse
- Pipeline de validação de qualidade com Pandera antes de carga
- Aggregação analítica diária com múltiplos joins e métricas
- Ingestão de dados históricos com reprocessamento

**Não encaixa:**
- Aplicação web que apenas consulta dados (→ `web_app`)
- Script simples que copia dados sem transformação (→ `automation_script`)
- Worker que processa eventos de fila (→ `integration_worker`)

**Golden Model:** `standards/golden-model-data-pipeline.md`
**Stack:** Python + Polars + DuckDB + Pandera

---

### 4. api_service

**O que é:** Backend que expõe endpoints REST ou GraphQL, consumido por clientes externos (mobile, SPA, terceiros) sem frontend próprio.

**Encaixa:**
- REST API para aplicativo mobile iOS/Android
- Gateway GraphQL que agrega múltiplos serviços
- Webhook processor que recebe eventos externos
- Microserviço interno que expõe endpoints para outros serviços

**Não encaixa:**
- Aplicação com frontend Next.js (→ `web_app` com Route Handlers)
- Script que processa dados sem expor endpoints (→ `automation_script`)
- Worker que consome filas (→ `integration_worker`)

**Golden Model:** `standards/golden-model-api-service.md`
**Stack:** FastAPI (Python) ou Next.js Route Handlers

---

### 5. cli_tool

**O que é:** Ferramenta de linha de comando interativa, distribuída como pacote instalável via pip ou similar. Tem flags, subcomandos e documentação de uso.

**Encaixa:**
- CLI de deploy interno com subcomandos `deploy`, `rollback`, `status`
- Ferramenta de exportação de dados com flags `--format`, `--output`
- CLI de scaffolding que gera arquivos de projeto
- Utilitário de diagnóstico com múltiplos checks

**Não encaixa:**
- Script de background que não é interativo (→ `automation_script`)
- API que expõe endpoints (→ `api_service`)
- Worker que consome eventos (→ `integration_worker`)

**Golden Model:** `standards/golden-model-cli-tool.md`
**Stack:** Python + Typer + pyproject.toml

---

### 6. mcp_server

**O que é:** Servidor que implementa o protocolo MCP (Model Context Protocol) para expor ferramentas a agentes de IA. Usa transporte stdio.

**Encaixa:**
- MCP para base de conhecimento interna (busca FTS)
- MCP para acesso ao banco de dados da empresa
- MCP para sistema de tickets (Jira, Linear)
- MCP para monitoramento e alertas (Datadog, Grafana)

**Não encaixa:**
- API REST genérica sem protocolo MCP (→ `api_service`)
- Script de automação (→ `automation_script`)
- Aplicação web (→ `web_app`)

**Golden Model:** `standards/golden-model-mcp-server.md`
**Stack:** Python + FastMCP + Pydantic schemas

---

### 7. integration_worker

**O que é:** Worker de longa duração que consome filas de mensagens, processa eventos, implementa retentativas com backoff e gerencia dead-letter queues.

**Encaixa:**
- Consumer Kafka que processa pedidos em tempo real
- Worker SQS que despacha notificações por e-mail/SMS
- Processor de webhooks com fan-out para múltiplos destinos
- Worker de sincronização baseado em eventos com garantia de entrega

**Não encaixa:**
- Script batch que roda por schedule (→ `automation_script`)
- API REST (→ `api_service`)
- Pipeline de dados analítico (→ `data_pipeline`)

**Golden Model:** `standards/golden-model-integration-worker.md`
**Stack:** Python + Redis/queues + tenacity + dead-letter

---

### 8. notebook_analysis

**O que é:** Análise exploratória de dados, experimentação de modelos ou visualização em Jupyter Notebook. **Nunca vai diretamente para produção.**

**Encaixa:**
- Análise ad-hoc de vendas do último trimestre
- Experimentação de modelo de ML (feature engineering, avaliação)
- Visualização exploratória para apresentação executiva
- Prova de conceito analítica antes de construir pipeline

**Não encaixa:**
- Jobs agendados ou processos de produção (→ `automation_script` ou `data_pipeline`)
- APIs de produção (→ `api_service`)
- Qualquer coisa com SLA ou disponibilidade exigida

**Atenção:** Código de notebook que precisa virar produção deve ser portado para o arquétipo correto (`automation_script`, `data_pipeline`, etc.).

**Golden Model:** `standards/golden-model-notebook-analysis.md`
**Stack:** Jupyter + Polars/Pandas (nunca diretamente em produção)

---

## Árvore de decisão

Use esta árvore quando o arquétipo não for óbvio:

```
O projeto tem interface de usuário acessada por navegador?
  └─ SIM → web_app

É acessado por chamadas HTTP/REST/GraphQL sem UI própria?
  └─ SIM → api_service

Roda em schedule ou gatilho, sem interação contínua?
  ├─ E envolve transformações complexas de múltiplas fontes? → data_pipeline
  └─ Caso contrário → automation_script

É uma ferramenta de linha de comando instalável e distribuível?
  └─ SIM → cli_tool

Expõe ferramentas para agentes de IA via protocolo MCP?
  └─ SIM → mcp_server

Consome eventos de fila com processamento contínuo de longa duração?
  └─ SIM → integration_worker

É análise exploratória em Jupyter que não vai para produção?
  └─ SIM → notebook_analysis
```

Se ainda houver ambiguidade após a árvore, o Tech Lead emite `A0_AMBIGUOUS` e solicita informações adicionais.

## Especificação completa

A especificação detalhada do Gate A0, incluindo critérios de classificação, exemplos de JSON de saída e regras de ADR, está em:

```
standards/project-classification.md
```
