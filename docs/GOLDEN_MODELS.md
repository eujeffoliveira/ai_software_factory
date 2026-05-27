# Golden Models — Padrões Técnicos por Arquétipo

## O que é um Golden Model

Um Golden Model é o **stack canônico** para um arquétipo de projeto. Ele define as tecnologias obrigatórias, os padrões de implementação e os antipadrões proibidos.

**Regra fundamental:** escolher o arquétipo correto **não exige ADR**. ADRs são exigidos apenas para desvios *dentro* do arquétipo escolhido. O Gate 2 é bloqueado até que o ADR de desvio seja aprovado.

Os Golden Models ficam em `standards/golden-model-*.md` e são indexados no `knowledge.db`.

## Matriz de arquétipos

| Arquétipo | Golden Model | Stack principal |
|-----------|-------------|-----------------|
| `web_app` | `standards/golden-model-web-app.md` | Next.js 16 + React 19 + TypeScript + Tailwind CSS v4 + NextAuth v5 + Supabase + Prisma 7 + Vercel |
| `automation_script` | `standards/golden-model-python-automation.md` | Python 3.12+ + uv + Typer + Pydantic v2 + structlog + pytest |
| `data_pipeline` | `standards/golden-model-data-pipeline.md` | Python + Polars + DuckDB + Pandera |
| `api_service` | `standards/golden-model-api-service.md` | FastAPI (Python) ou Next.js Route Handlers |
| `cli_tool` | `standards/golden-model-cli-tool.md` | Python + Typer + pyproject.toml |
| `mcp_server` | `standards/golden-model-mcp-server.md` | Python + FastMCP + Pydantic schemas |
| `integration_worker` | `standards/golden-model-integration-worker.md` | Python + Redis/queues + tenacity + dead-letter |
| `notebook_analysis` | `standards/golden-model-notebook-analysis.md` | Jupyter + Polars/Pandas (nunca diretamente em produção) |

## Stack web_app em detalhe

O arquétipo `web_app` é o mais completo e o padrão para aplicações com interface de usuário.

| Camada | Tecnologia |
|--------|-----------|
| Framework | Next.js 16 (App Router) |
| Frontend | React 19 + TypeScript 5 |
| Estilização | Tailwind CSS v4 |
| Autenticação | NextAuth v5 + Google OAuth |
| Banco de dados | PostgreSQL via Supabase |
| ORM | Prisma 7 com PrismaPg adapter |
| Migrations | `prisma migrate deploy` (NUNCA `prisma db push` em staging/prod) |
| Deploy | Vercel |
| Cron jobs | Vercel Cron + `guardCron()` para idempotência |
| Validação | Zod em todas as fronteiras do sistema |
| Testes unitários | Vitest |
| Testes E2E | Playwright |
| Gráficos | Recharts v3 |
| Data fetching | Server Components → Server Actions → SWR (polling) |
| Variáveis de ambiente | `lib/env.ts` centralizado (nunca `process.env` espalhado) |
| Logs | JSON estruturado: `audit_log` (ações humanas) e `sync_log` (jobs) |
| Proxy | `proxy.ts` (NUNCA `middleware.ts` no Next.js 16) |

## Antipadrões críticos (web_app)

Os seguintes antipadrões **bloqueiam o Gate 5** (Security) sem exceção:

| Antipadrão | Risco | Alternativa |
|------------|-------|-------------|
| Concatenação SQL | SQL Injection | Usar Prisma ORM ou queries parametrizadas |
| Lógica de negócio em `route.ts` | Coesão, testabilidade | Mover para service layer |
| `process.env` espalhado | Config inconsistente | Centralizar em `lib/env.ts` |
| Secrets hardcoded no código | Exposição de credenciais | Variáveis de ambiente via Vercel |
| `middleware.ts` no Next.js 16 | Bug de runtime | Usar `proxy.ts` |
| `prisma db push` em staging/prod | Migration loss | Usar `prisma migrate deploy` |
| Jobs sem idempotência | Dados duplicados | Implementar `guardCron()` |
| Deploy sem plano de rollback | Indisponibilidade | Documentar rollback antes do Gate 6 |
| Stack traces expostos ao cliente | Information disclosure | Tratar erros no servidor |

## Stacks dos demais arquétipos

### automation_script

Script Python que roda em schedule ou gatilho, processa dados e chama APIs.

| Componente | Tecnologia |
|-----------|-----------|
| Runtime | Python 3.12+ |
| Gerenciador de pacotes | uv |
| CLI | Typer |
| Validação | Pydantic v2 |
| Logs | structlog |
| Testes | pytest |
| Retentativas | tenacity |

### data_pipeline

Pipelines de ingestão, transformação e carga de dados.

| Componente | Tecnologia |
|-----------|-----------|
| Transformações | Polars |
| Queries analíticas | DuckDB |
| Qualidade de dados | Pandera |
| Orquestração | Prefect ou schedule simples |

### api_service

APIs backend sem frontend próprio.

| Contexto | Stack |
|---------|-------|
| Python puro | FastAPI + Pydantic v2 + pytest |
| Integrado com Next.js | Next.js Route Handlers + Zod |

### cli_tool

Ferramentas de linha de comando distribuídas como pacotes.

| Componente | Tecnologia |
|-----------|-----------|
| CLI framework | Typer |
| Distribuição | pyproject.toml + pip |
| Config | Pydantic Settings |

### mcp_server

Servidores MCP que expõem ferramentas para agentes de IA.

| Componente | Tecnologia |
|-----------|-----------|
| Framework | FastMCP |
| Schemas | Pydantic v2 |
| Transporte | stdio (padrão) |

### integration_worker

Workers de longa duração que consomem filas e tratam falhas.

| Componente | Tecnologia |
|-----------|-----------|
| Filas | Redis Streams, SQS ou RabbitMQ |
| Retentativas | tenacity com backoff exponencial |
| Dead-letter | Fila separada para mensagens falhadas |
| Idempotência | Chave de deduplicação obrigatória |

### notebook_analysis

Análise exploratória de dados. **Nunca ir diretamente para produção.**

| Componente | Tecnologia |
|-----------|-----------|
| Ambiente | Jupyter Notebook/Lab |
| Dados | Polars (preferido) ou Pandas |
| Visualização | Matplotlib, Seaborn ou Plotly |

## ADR para desvios

Qualquer desvio do stack canônico dentro do arquétipo escolhido exige um ADR:

1. O Tech Lead aciona `@architect` para redigir o ADR
2. O ADR inclui: contexto, opções avaliadas, decisão, consequências
3. O ADR é aprovado antes do Gate 2
4. O ADR é registrado no State Ledger

Formato: `ADR-NNN-<slug-curto>.md` no diretório `docs/adr/` do projeto.

Especificações completas de cada arquétipo: `standards/golden-model-*.md`

Processo de classificação de arquétipo: `standards/project-classification.md`
