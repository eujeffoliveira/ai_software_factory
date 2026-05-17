# Agente00_TechLead — Context Routing Plan

## Build Date
2026-05-17

## Fontes lidas

1. `context/manual_arquitetura_componentes_generico.md` — pipeline de build, agentes, artefatos, gates, skills, RAG
2. `context/integrantes.md` — papel de cada agente, responsabilidades, inputs, outputs, limites
3. `context/reference_architecture_generico.md` — Golden Model técnico normativo
4. `context/base_teorica.md` — knowledge base por agente

## O que o Tech Lead precisa compreender

### Composição geral da fábrica
- 9 agentes principais (00–08) + 2 opcionais (09–10)
- Tech Lead é o único com visão holística contínua
- Todos os demais agentes são especialistas de fase

### Fluxo macro
```
User Request → Agent00 → Agent01 → Gate1 → Agent02 → Gate2 → Agent03 → Gate3 → Agent04/05 → Agent06 → Agent07 → Gate4/5 → Agent08 → Gate6 → Production
```

### Gates obrigatórios
- Gate 1: PRD Approval
- Gate 2: Architecture Approval
- Gate 3: Execution Plan Approval
- Gate 4: QA Review
- Gate 5: Security Review
- Gate 6: Deployment Approval
- Gate 7: Post-Deploy Validation

### Artefatos obrigatórios do ciclo
PRD.md → Architecture.md + API_Contract.json + DB_Schema → Execution_Plan.json → Código → QA_Report.md → Security_Audit.md → Deployment_Plan.md + Rollback_Plan.md → Post_Deploy_Report.md

### State Ledger
Registro vivo mantido pelo Tech Lead com: fase atual, agente atual, próximo agente, artefatos aprovados, dúvidas abertas, decisões, ADRs, riscos, bloqueios, aprovações humanas pendentes.

### Handoff Package
Obrigatório ao final de cada agente. Contém: artefato produzido, resumo, premissas, dúvidas, riscos, próximo agente, checklist de validação.

### Matriz de autoridade
- Tech Lead aprova/bloqueia gates
- Humano decide: escopo, deploy produção, migration destrutiva, risco de segurança aceito
- DevSecOps e QA têm poder de veto independente

### ADR Policy
ADR obrigatório em desvio do Golden Path ou decisão irreversível.

### Council Policy
Acionar em PRD approval, Architecture approval, mudança estrutural, risco crítico, go-live, incidente.

### Escalamento humano
Escalar quando: escopo, custo, decisão irreversível, deploy produção, rollback, migration destrutiva, risco segurança.

### Arquitetura técnica (Golden Model compilado)
- Next.js 16 + App Router + proxy.ts (obrigatório)
- React 19, TypeScript 5
- Supabase/PostgreSQL + Prisma 7 + migrations
- Vercel deploy + Vercel Cron
- NextAuth v5 + Google OAuth
- Zod, Vitest, Playwright
- Server Components → Server Actions → SWR (hierarquia)
- audit_log (ações humanas) + sync_log (jobs)
- Logs JSON estruturados
- ADRs em docs/adr/

### Anti-padrões críticos
- SQL raw concatenado
- lógica em route.ts
- process.env espalhado
- segredo no código
- SWR sem necessidade
- middleware.ts em Next.js 16 (usar proxy.ts)
- prisma db push em staging/produção
- job sem idempotência
- deploy sem rollback plan

### Runtime isolation policy
Após o build, o agente consulta APENAS sua pasta local `Agente00_TechLead/`.
Fontes bloqueadas em runtime: `context/`, `lib/`, manual global, reference architecture completo.

## Arquivos a compilar

| Arquivo | Fonte principal |
|---|---|
| `prompt.md` | integrantes.md + manual + arquitetura |
| `agent_config.json` | manual (seção runtime) |
| `context_view.md` | reference_architecture + integrantes + manual |
| `rag_manifest.json` | base_teorica + bibliography |
| `skills_manifest.md` | integrantes.md (seção skills) |
| `quality_gate.md` | manual (seção gates) + reference_architecture |
| `handoff_schema.json` | manual (seção handoff) |
| `failure_modes.md` | integrantes.md (limites) + manual |
| `schemas/` | manual (schemas) |
| `templates/` | reference_architecture (templates) |
| `checklists/` | manual + reference_architecture |
| `skills/` | integrantes.md (skills autorizadas) |
| `examples/` | manual (exemplos) |
