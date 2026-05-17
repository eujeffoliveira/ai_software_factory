# Reference Architecture & Standards Document
## Enterprise Software Factory — Golden Model v1.1.1
### Agent Knowledge Base Edition — White-label
### Base: projeto `reference-project` — Organização
### Uso: Base de Conhecimento Técnica para Agentes de IA, Skills, RAG e Revisões Humanas

---

## Status do documento

**Versão:** v1.1.1 — White-label  
**Tipo:** Arquitetura de referência e padrão técnico organizacional  
**Público principal:** Agentes da Enterprise AI Software Factory, Tech Leads humanos, arquitetos, devs, QA, DevSecOps e DevOps  
**Natureza:** Documento normativo de engenharia  
**Não é:** prompt de agente, PRD, guia de implementação de produto específico ou tutorial de tecnologia

---

# 1. Propósito e escopo

## 1.1. O que é este documento

Este documento define o **Golden Model técnico** para projetos internos da Organização.

Ele estabelece:

- arquitetura padrão;
- stack tecnológica aprovada;
- regras obrigatórias de engenharia;
- padrões de segurança;
- padrões de banco de dados;
- padrões de frontend e design system;
- padrões de deploy;
- padrões de testes;
- padrões de auditoria;
- padrões de observabilidade;
- regras de exceção;
- context views para agentes de IA;
- anti-padrões proibidos.

Este documento deve ser usado como **base de conhecimento obrigatória** para os agentes da Enterprise AI Software Factory.

## 1.2. O que este documento não é

Este documento **não é um prompt**.

Os prompts dos agentes serão definidos em documentos separados.  
Este documento é o **manual técnico de referência** que os prompts, skills e sistemas RAG devem consultar.

A relação correta é:

```txt
Reference Architecture v1.1.1
  = base normativa de engenharia

Manual de Arquitetura e Componentes da Enterprise AI Software Factory
  = manual de peças, papéis, artefatos, gates e agentes

Prompts dos agentes
  = instruções de execução de cada papel

Skills
  = ferramentas especializadas acionadas pelos agentes

RAG
  = mecanismo de recuperação da base teórica, arquitetura e documentos internos
```

## 1.3. Como os agentes devem usar este documento

- **Tech Lead / Orchestrator:** pode receber o documento completo.
- **Software Architect:** pode receber quase o documento completo, com foco em arquitetura, stack, banco, segurança, deploy e ADRs.
- **Agentes especialistas:** devem receber apenas a context view correspondente.
- **RAG:** deve indexar o documento inteiro com metadados por seção, papel e criticidade.
- **Skills:** devem citar quais seções deste documento são obrigatórias para sua execução.

## 1.4. Hierarquia de autoridade

Quando houver conflito entre fontes, use esta ordem:

```txt
1. Instrução explícita do humano responsável
2. ADR aprovado no projeto
3. Este documento de arquitetura
4. Manual de Arquitetura e Componentes da Enterprise AI Software Factory
5. Documentação específica do projeto, como CLAUDE.md
6. Base teórica via RAG
7. Conhecimento geral do modelo
```

Observações:

- ADR aprovado pode desviar do Golden Path, mas somente no escopo da decisão registrada.
- A base teórica via RAG informa boas práticas, mas não substitui a arquitetura organizacional.
- Se um agente detectar conflito, deve escalar ao Tech Lead.

---

# 2. Princípios arquiteturais

## P1 — Simplicidade antes de abstração

Prefira a solução mais simples que resolve o problema real.

Não crie abstrações prematuras.  
Generalize apenas quando existir repetição real e uma necessidade clara.

## P2 — Segurança por padrão

A configuração padrão deve ser segura.

Qualquer abertura de acesso, exposição pública, flexibilização de autenticação, log com dados sensíveis ou redução de controle deve ser explícita, justificada e registrada.

## P3 — Auditabilidade

Toda ação humana ou automatizada que afete dados sensíveis, permissões, configurações, jobs ou integrações deve ser rastreável.

Instrumentos principais:

```txt
audit_log   → ações humanas e administrativas
sync_log    → jobs automáticos
logs JSON   → diagnóstico operacional
migrations  → histórico de alterações de schema
ADRs        → histórico de decisões arquiteturais
```

## P4 — Compatibilidade com IA

Código, estrutura e documentação devem ser legíveis para agentes de IA.

Isso exige:

- tipos explícitos;
- nomes descritivos;
- funções pequenas;
- contratos claros;
- camadas bem separadas;
- ausência de comportamento implícito;
- exemplos consistentes;
- anti-padrões documentados.

## P5 — Escalabilidade progressiva

Comece simples.  
Escale quando houver evidência de necessidade.

Exceções para workloads que já nascem grandes devem ser documentadas em ADR.

## P6 — Falhar cedo e claramente

Configurações inválidas, variáveis ausentes, contratos quebrados e schemas inconsistentes devem falhar no boot, build ou CI, não em produção de forma silenciosa.

## P7 — Zero segredo no código

Nenhuma credencial, token, senha, chave, cookie, segredo ou valor sensível deve existir no código-fonte.

Segredos vivem em variáveis de ambiente e são validados por `lib/env.ts`.

## P8 — Contexto mínimo por agente

Agentes especialistas devem receber apenas o contexto necessário ao seu papel.

Contexto excessivo aumenta:

- alucinação;
- custo;
- confusão de responsabilidade;
- decisões fora de escopo.

---

# 3. Níveis de regra

Toda regra deste documento pertence a um dos níveis abaixo.

## 3.1. Obrigatório

Regras obrigatórias bloqueiam merge, deploy ou avanço de fase quando violadas.

São obrigatórios:

- TypeScript estrito.
- Nenhum segredo no código.
- Validação de variáveis de ambiente via `lib/env.ts`.
- Validação de inputs em fronteiras do sistema.
- Autorização server-side antes de leitura privilegiada ou mutação.
- Logs estruturados em JSON.
- `audit_log` para ações humanas sensíveis.
- `sync_log` para jobs automáticos.
- Testes automatizados para regras de negócio novas ou críticas.
- CI/CD com typecheck, lint, testes e build.
- Migrations versionadas em staging e produção.
- Jobs idempotentes.
- `proxy.ts` em projetos Next.js 16.
- Nunca expor stack trace ao cliente.
- Nunca concatenar SQL raw.
- Nunca importar biblioteca ausente no `package.json`.

## 3.2. Golden Path

Golden Path é a escolha padrão.  
Seguir o Golden Path não exige justificativa.

Golden Path técnico:

- Next.js 16 App Router.
- Monorepo fullstack.
- React 19.
- TypeScript 5.
- PostgreSQL no Supabase.
- Prisma 7 com PrismaPg adapter.
- Vercel para deploy.
- Vercel Cron para jobs simples e médios.
- Tailwind CSS v4.
- Design tokens da Organização.
- NextAuth v5 com Google OAuth.
- Server Components para leitura inicial.
- Server Actions para mutações.
- SWR apenas para polling ou revalidação client-side necessária.
- Zod para validação runtime.
- Vitest para testes unitários e integração.
- Playwright para fluxos E2E críticos.
- Recharts para dashboards e gráficos.
- Nodemailer + AWS SES para e-mail transacional.

## 3.3. Exceção com ADR

Qualquer desvio do Golden Path exige ADR aprovado.

Exemplos:

- backend separado;
- worker dedicado;
- fila assíncrona;
- banco diferente de PostgreSQL;
- ORM diferente de Prisma;
- deploy fora da Vercel;
- Supabase CLI como fonte principal de migrations;
- RLS universal;
- arquitetura distribuída;
- serviço Python/FastAPI;
- pipeline de dados;
- serviço de IA/embeddings;
- biblioteca de gráficos diferente de Recharts;
- provider de autenticação diferente de Google OAuth;
- runtime persistente para integrações pesadas com TOTVS/RM ou terceiros.

---

# 4. ADR — Architecture Decision Record

## 4.1. Quando criar ADR

Crie ADR antes de implementar quando houver:

- desvio do Golden Path;
- decisão irreversível ou cara de reverter;
- alteração estrutural;
- mudança de banco;
- migration destrutiva;
- novo serviço externo crítico;
- decisão relevante de segurança;
- aumento significativo de custo operacional;
- introdução de nova dependência crítica;
- mudança em autenticação/autorização;
- alteração em padrão de deploy.

## 4.2. Template de ADR

```md
# ADR-NNN — Título da decisão

## Status
Proposto | Aprovado | Rejeitado | Substituído

## Data
YYYY-MM-DD

## Contexto
Explique o problema, restrição ou oportunidade.

## Decisão
Explique a decisão tomada.

## Alternativas consideradas
| Alternativa | Prós | Contras |
|---|---|---|

## Consequências
Explique impactos técnicos, operacionais, financeiros e de manutenção.

## Critérios de revisão
Explique quando esta decisão deve ser reavaliada.
```

## 4.3. Local dos ADRs

```txt
docs/
  adr/
    ADR-001-titulo-da-decisao.md
```

---

# 5. Arquitetura base

## 5.1. Golden Path: Next.js fullstack monorepo

Use Next.js 16 App Router como framework fullstack unificado.

Frontend e backend residem no mesmo repositório por padrão.

Não separar frontend e backend em repositórios diferentes sem ADR.

## 5.2. Camadas obrigatórias

| Camada | Localização | Responsabilidade |
|---|---|---|
| Proxy / Edge Guard | `proxy.ts` | Verificação otimista de sessão e proteção de cron |
| Auth Layer | `auth.ts` | NextAuth v5, providers, callbacks e eventos |
| Server Components | `app/**/page.tsx`, `layout.tsx` | Leitura inicial, renderização servidor, validação real |
| Client Components | `components/**/*.tsx` | UI interativa e estado local |
| Route Handlers | `app/api/**/route.ts` | Endpoints REST finos |
| Cron Routes | `app/api/cron/**/route.ts` | Entrada dos jobs agendados |
| Server Actions | `actions/**/*.ts` | Mutações autorizadas |
| Data Access Layer | `lib/db/**/*.ts` | Toda consulta ao banco |
| Jobs | `lib/jobs/**/*.ts` | Lógica de coleta/processamento |
| Integrações | `lib/integrations/**` ou `lib/[servico]/**` | Clientes de APIs externas |
| Validação | `lib/env.ts`, schemas Zod | Validação runtime |
| Tipos | `types/**/*.ts` | Tipos globais e contratos |

## 5.3. Regra de ouro de Route Handlers

`route.ts` deve ser uma casca fina.

Ele pode:

- validar autenticação;
- chamar `guardCron()`;
- validar input;
- chamar função de `lib/`;
- retornar `NextResponse.json()`.

Ele não deve:

- conter regra de negócio;
- acessar banco diretamente;
- chamar API externa diretamente;
- montar queries;
- conter lógica de domínio extensa.

## 5.4. Fluxos padrão

### Leitura estável

```txt
Browser
  → proxy.ts
  → Server Component
  → lib/db
  → PostgreSQL
```

### Leitura com polling

```txt
Browser
  → SWR
  → app/api/**/route.ts
  → lib/db
  → PostgreSQL
```

### Mutação

```txt
Browser
  → Server Action
  → auth()
  → autorização
  → lib/db
  → audit_log quando aplicável
  → revalidatePath()
```

### Cron

```txt
Vercel Cron
  → app/api/cron/**/route.ts
  → guardCron()
  → lib/jobs
  → lib/db
  → sync_log
```

## 5.5. Quando o Golden Path não basta

Use ADR para:

| Situação | Exceção aceitável |
|---|---|
| Job longo | Worker dedicado |
| Retry/dead-letter | Fila |
| Alto volume público | API standalone |
| Pipeline de dados | Serviço Node/Python dedicado |
| IA/embeddings/NLP | Serviço Python/FastAPI |
| Integração TOTVS/RM persistente | Worker com estado |
| WebSockets/runtime persistente | Serviço containerizado |
| Processamento pesado de arquivos | Worker ou serviço dedicado |

---

# 6. Next.js 16, Proxy e roteamento

## 6.1. App Router obrigatório

Use exclusivamente App Router.

Não usar `pages/`.

Estrutura padrão:

```txt
app/
  (protected)/
  api/
  api/cron/
  login/
  pending-approval/
  layout.tsx
  globals.css
```

## 6.2. `proxy.ts` vs `middleware.ts`

| Arquivo | Uso |
|---|---|
| `proxy.ts` | Obrigatório em projetos Next.js 16 |
| `middleware.ts` | Legado para Next.js 15 ou anterior |

Regra:

```txt
Projetos Next.js 16 usam proxy.ts.
Não criar middleware.ts em projetos novos.
```

---

# 7. Stack tecnológica aprovada

## 7.1. Versões aprovadas

| Pacote | Linha aprovada |
|---|---|
| Next.js | 16.x |
| React | 19.x |
| TypeScript | 5.x |
| Tailwind CSS | 4.x |
| Prisma | 7.x |
| PostgreSQL | 16+ recomendado |
| pg | 8.x |
| next-auth | 5.x beta |
| @auth/prisma-adapter | 2.x |
| next-themes | 0.4.x |
| swr | 2.x |
| recharts | 3.x |
| zod | 3.x |
| vitest | 2.x |
| playwright | versão compatível com projeto |
| nodemailer | 7.x |
| axios | 1.x |

## 7.2. Política de versões

- O documento define major/minor aprovados.
- A versão patch exata pertence ao `package.json` e ao lockfile do template.
- Atualizações patch podem ser propostas por Renovate/Dependabot.
- Atualizações major exigem validação humana.
- Dependências beta exigem consciência explícita e revisão periódica.

## 7.3. Scripts obrigatórios

```json
{
  "scripts": {
    "postinstall": "prisma generate",
    "dev": "next dev",
    "typecheck": "tsc --noEmit",
    "build": "tsc --noEmit && next build",
    "start": "next start",
    "lint": "eslint",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "migrate:deploy": "prisma migrate deploy"
  }
}
```

---

# 8. Estrutura de pastas

## 8.1. Estrutura padrão

```txt
app/
  (protected)/
  api/
    cron/
    health/
    [recurso]/
  login/
  pending-approval/
  layout.tsx
  globals.css

components/
  ui/
  layout/
  charts/
  domain/

actions/
  [dominio].ts

features/
  [dominio]/
    [dominio].schema.ts
    [dominio].service.ts
    [dominio].repository.ts
    [dominio].types.ts

lib/
  prisma.ts
  env.ts
  fmt.ts
  admin.ts
  email.ts
  db/
    sync-log.ts
    audit-log.ts
    [dominio].ts
  jobs/
    cron-guard.ts
    concurrency.ts
    collect-[dominio].ts
  integrations/
    microsoft/
    totvs/
    google/
    [servico]/
  observability/
  security/

types/
  next-auth.d.ts
  [dominio].ts

prisma/
  schema.prisma
  migrations/

docs/
  adr/
  runbooks/
  architecture.md

tests/
  unit/
  integration/
  e2e/

scripts/

proxy.ts
auth.ts
next.config.ts
prisma.config.ts
vercel.json
```

## 8.2. Observação sobre templates

Templates deste documento são exemplos de referência.

Eles devem ser adaptados ao domínio do projeto.  
Não copie nomes como `dataflows`, `capacities` ou `monitoring` quando o projeto tiver outro domínio.

---

# 9. Data fetching

## 9.1. Hierarquia

Use esta ordem:

```txt
1. Server Component
2. Server Action
3. SWR
4. fetch manual
```

## 9.2. Server Components

Use para:

- carregamento inicial;
- dados estáveis;
- páginas protegidas;
- relatórios;
- listagens;
- detalhes;
- dados dependentes de sessão.

## 9.3. Server Actions

Use para:

- mutações;
- ações administrativas;
- alterações de dados;
- operações com autorização;
- workflows com `revalidatePath`.

Regras:

- validar input;
- validar sessão;
- validar autorização;
- registrar `audit_log` quando sensível;
- não expor erro interno.

## 9.4. SWR

Use SWR apenas quando houver necessidade real de:

- polling;
- dashboard vivo;
- revalidação client-side;
- filtros client-driven;
- dados que mudam rapidamente.

Regras obrigatórias:

```txt
revalidateOnFocus: false
```

Fetcher padrão:

```ts
const fetcher = (url: string) => fetch(url).then(r => {
  if (!r.ok) throw new Error(`HTTP ${r.status}`);
  return r.json();
});
```

## 9.5. Anti-padrão

Não use SWR por conveniência quando Server Component resolve.

---

# 10. Banco de dados, Prisma e migrations

## 10.1. Banco padrão

Use PostgreSQL no Supabase.

Conexão padrão:

```txt
session mode pooler — porta 5432
```

## 10.2. Prisma 7

Use:

- `prisma.config.ts` com `dotenv.config()`;
- datasource sem `url` no `schema.prisma`;
- `lib/prisma.ts` com singleton e PrismaPg adapter.

## 10.3. Convenções

- Prisma usa `camelCase`.
- Banco usa `snake_case`.
- Colunas usam `@map("snake_case")`.
- Tabelas usam `@@map("snake_case_plural")`.
- Tipos de `$queryRaw` são exportados no nível do módulo.

## 10.4. Fonte da verdade

Fonte da verdade padrão:

```txt
Prisma schema + Prisma migrations
```

Não misturar:

- migrations manuais no Supabase Dashboard;
- Supabase CLI;
- Prisma Migrate;

sem ADR específico.

## 10.5. Política de migrations

| Ambiente | Comando |
|---|---|
| Local | `prisma db push` permitido |
| Sandbox descartável | `prisma db push` permitido |
| Staging | `prisma migrate deploy` obrigatório |
| Produção | `prisma migrate deploy` via CI/CD obrigatório |

Nunca usar `prisma db push` em staging ou produção.

Nunca usar `prisma migrate dev` em banco com dados reais.

## 10.6. Mudanças destrutivas

Mudanças como:

- `DROP COLUMN`;
- `RENAME COLUMN`;
- `DROP TABLE`;
- mudança de tipo incompatível;

exigem plano em fases:

```txt
1. Compatibilidade
2. Migration
3. Limpeza
```

## 10.7. `$transaction()`

Permitido para:

- operações curtas;
- baixa cardinalidade;
- 2 a 4 statements;
- sem chamadas externas;
- atomicidade real.

Proibido para:

- loops grandes;
- chamadas externas;
- jobs longos;
- sincronização massiva;
- transações envolvendo APIs instáveis.

---

# 11. Validação runtime com Zod

## 11.1. Regra

Valide todas as fronteiras:

- env vars;
- query params;
- request body;
- Server Actions;
- APIs externas;
- payloads de jobs;
- arquivos importados.

## 11.2. `lib/env.ts`

Centralize variáveis em `lib/env.ts`.

Nunca espalhe `process.env` pelo código.

Regras:

- variável obrigatória ausente falha no boot/build;
- secrets têm tamanho mínimo;
- URLs são validadas;
- números são coerced com `z.coerce.number()`;
- feature flags usam enum ou boolean parser.

## 11.3. Validação de entrada

Todo endpoint ou action deve ter schema.

Exemplo conceitual:

```ts
const schema = z.object({
  id: z.string().min(1),
});
```

---

# 12. Jobs, crons e idempotência

## 12.1. Cron routes

Toda cron route deve começar com:

```txt
guardCron()
```

Formatos aceitos:

```txt
Authorization: Bearer <CRON_SECRET>
x-cron-secret: <CRON_SECRET>
```

## 12.2. Idempotência obrigatória

Todo job deve ser:

- idempotente;
- reexecutável;
- auditável;
- seguro contra duplicação;
- capaz de falhar sem corromper dados.

Estratégias:

- `ON CONFLICT DO UPDATE`;
- `upsert`;
- chaves naturais;
- checkpoints;
- locks;
- `job_runs`;
- `job_locks`;
- dead-letter quando aplicável.

## 12.3. Jobs longos

Jobs longos exigem:

- particionamento;
- checkpoint;
- timeout;
- retry;
- observabilidade;
- ADR para fila/worker quando necessário.

## 12.4. Paralelismo

Use `pMap` com concorrência limitada para APIs externas.  
Use `Promise.all` para operações independentes.

---

# 13. Segurança, autenticação e LGPD

## 13.1. Segurança em camadas

Camadas obrigatórias:

```txt
proxy.ts
  → layout protegido com auth()
  → Server Actions/API Routes com auth e autorização
```

## 13.2. Autenticação

Golden Path:

- NextAuth v5;
- Google OAuth;
- restrição por domínio;
- status de usuário: `pending`, `approved`, `rejected`;
- role no banco;
- sessions invalidadas quando usuário é rejeitado.

## 13.3. Autorização

Autorização é server-side.

Nunca confiar apenas em UI.

Server Actions e APIs privilegiadas devem verificar:

```txt
auth()
role
status
permissão específica quando aplicável
```

## 13.4. LGPD

Classifique dados antes de modelar.

Categorias:

- dados pessoais;
- dados sensíveis;
- dados operacionais;
- dados financeiros;
- dados escolares;
- dados de integração.

Regras:

- não logar PII em texto claro;
- mascarar dados quando necessário;
- registrar acesso sensível no `audit_log`;
- documentar retenção;
- implementar exclusão quando aplicável;
- minimizar coleta.

## 13.5. RLS

Política condicional:

| Cenário | RLS |
|---|---|
| Frontend acessa Supabase diretamente | obrigatório |
| Acesso sempre via Next.js/Prisma | opcional via ADR em tabelas sensíveis |

## 13.6. DevSecOps

DevSecOps deve revisar:

- auth;
- proxy;
- env;
- Server Actions;
- APIs públicas;
- modelos com dados pessoais;
- permissões;
- logs;
- dependências;
- exportações de dados;
- uploads;
- webhooks;
- cron manual.

## 13.7. Threat modeling mínimo

Perguntas obrigatórias:

1. Quem pode chamar?
2. O que acontece se anônimo chamar?
3. O que acontece se usuário autenticado sem permissão chamar?
4. Quais dados sensíveis passam por aqui?
5. Existe risco de SQLi, XSS, SSRF, CSRF ou Broken Auth?

---

# 14. Observabilidade, logs e auditoria

## 14.1. Logs estruturados

Logs de produção devem ser JSON.

Campos recomendados:

```txt
timestamp
level
message
requestId
userId
route
job
durationMs
status
errorCode
```

Nunca logar:

- tokens;
- cookies;
- secrets;
- payloads sensíveis completos;
- CPF;
- e-mail completo;
- nome completo;
- dados escolares sensíveis sem necessidade.

## 14.2. `sync_log`

Use para jobs automáticos.

Campos:

```txt
job
executed_at
duration_ms
status
counts
error_msg
```

## 14.3. `audit_log`

Use para ações humanas/admin.

Eventos obrigatórios:

- aprovar/rejeitar usuário;
- alterar role;
- executar job manual;
- exportar dados;
- alterar configuração;
- alterar dados financeiros;
- acessar dados sensíveis;
- alterar permissões.

## 14.4. APM

Ferramentas aceitáveis:

- Sentry;
- Datadog;
- OpenTelemetry;
- Vercel Analytics / Speed Insights.

Projetos críticos devem ter APM definido em ADR ou documentação de deploy.

---

# 15. Testes e QA

## 15.1. Regra

Testes são obrigatórios.

Typecheck e lint não substituem testes.

## 15.2. Camadas

| Camada | Ferramenta |
|---|---|
| Unitário | Vitest |
| Integração | Vitest + banco de teste |
| E2E | Playwright |
| Typecheck | `tsc --noEmit` |
| Lint | ESLint |
| Build | `next build` |

## 15.3. Prioridade de teste

Priorize:

1. Server Actions críticas.
2. Auth e autorização.
3. `guardCron`.
4. `lib/env.ts`.
5. schemas Zod.
6. helpers e formatadores.
7. DAL crítico.
8. fluxos E2E críticos.

## 15.4. QA pode bloquear

Status de QA:

```txt
PASS
FAIL_FIX_REQUIRED
FAIL_BLOCKING
```

QA deve bloquear quando:

- critério de aceite falha;
- regra de negócio sem teste;
- teste falha;
- typecheck falha;
- lint falha;
- contrato API quebra;
- regressão crítica;
- UI sem estados essenciais;
- fluxo crítico inacessível.

---

# 16. Design system e frontend

## 16.1. Identidade visual

Padrão para sistemas internos da Organização:

```txt
primary-color: var(--primary-color)
secondary-color:   var(--secondary-color)
```

## 16.2. Tailwind v4

Use `@theme` em `globals.css`.

Não usar `tailwind.config.ts` para configuração de tema no Tailwind v4.

## 16.3. Dark mode

Use `next-themes`.

Configuração padrão:

```txt
attribute="class"
defaultTheme="dark"
enableSystem={false}
```

## 16.4. Componentes base

Componentes recomendados:

- `KpiCard`;
- `MonitoringTable`;
- `StatusBadge`;
- `NavBar`;
- `ThemeProvider`;
- `ThemeToggle`;
- componentes de formulário padronizados;
- componentes de feedback: loading, empty, error.

## 16.5. Gráficos

Use Recharts v3.

Regras:

- importar via dynamic quando necessário;
- `ssr: false` para componentes dependentes de browser;
- `TooltipContentProps`;
- `content={fn}`, não `content={<Component />}`.

## 16.6. Acessibilidade

Obrigatório:

- HTML semântico;
- labels;
- foco visível;
- contraste adequado;
- navegação por teclado;
- estados loading/empty/error;
- texto alternativo quando aplicável.

## 16.7. Imagens

Use `<Image>` do Next.js.

Não usar `<img>` nativo em aplicações Next.js.

---

# 17. Dependências e supply chain

## 17.1. Regras

- Lockfile obrigatório.
- Nunca usar `npm audit fix --force`.
- Renovate/Dependabot recomendado.
- Dependência nova exige justificativa.
- Dependência client-side exige avaliação de bundle.
- Dependência beta exige aprovação.
- Licença deve ser compatível.

## 17.2. Checklist de nova dependência

Responder:

```txt
Qual problema resolve?
Existe alternativa nativa?
Está ativa?
Impacta bundle?
Tem CVEs?
Licença é compatível?
É usada no client ou server?
É necessária agora?
```

## 17.3. Regra para agentes

Agentes não podem importar biblioteca que não está no `package.json`.

Se precisarem de nova biblioteca, devem escalar ao Tech Lead.

---

# 18. Deploy, CI/CD, rollback e operação

## 18.1. Plataforma padrão

Use Vercel.

Deploy fora da Vercel exige ADR.

## 18.2. Ambientes

| Ambiente | Uso |
|---|---|
| Local | desenvolvimento |
| Preview | branches |
| Staging | validação |
| Produção | usuários reais |

Nunca reutilizar secrets entre ambientes.

## 18.3. Pipeline mínimo

Etapas obrigatórias:

```txt
npm ci
npm run typecheck
npm run lint
npm run test
npm run build
prisma migrate deploy em staging/produção
```

## 18.4. Healthcheck

Todo projeto deve ter:

```txt
GET /api/health
```

Deve validar:

- aplicação responde;
- banco responde;
- versão/commit quando possível;
- status de dependências críticas quando aplicável.

## 18.5. Rollback obrigatório

Todo deploy de produção deve ter plano de rollback.

O plano deve definir:

- condição para rollback;
- responsável;
- passos;
- impacto em banco;
- impacto em migrations;
- validação pós-rollback;
- comunicação;
- tempo máximo de decisão.

## 18.6. Migrations e rollback

Antes de produção, classificar migration como:

| Tipo | Política |
|---|---|
| Reversível | Pode ter rollback automatizado ou manual |
| Compatível | Deploy em fases |
| Irreversível | Exige aprovação humana explícita |
| Destrutiva | Exige plano formal e backup |

## 18.7. Runbook

Projetos críticos devem possuir:

```txt
docs/runbooks/
  incident-response.md
  rollback.md
  cron-failure.md
  database-issue.md
```

## 18.8. Pós-deploy

Validar:

- `/api/health`;
- tela principal;
- login;
- última execução de cron;
- logs de erro;
- APM por pelo menos 15 minutos em deploy crítico.

---

# 19. Agentes de IA e Context Views

## 19.1. Princípio

Esta seção define **quais partes da arquitetura cada agente deve receber**.

Ela não define prompts.

Prompts vivem em artefatos separados.

## 19.2. TechLeadView

Recebe:

- documento completo;
- changelog;
- ADRs;
- manual da fábrica;
- State Ledger;
- PRD atual;
- status dos gates.

Uso:

- orquestração;
- decisão;
- validação de contratos;
- ADR;
- Council;
- escalonamento humano.

## 19.3. ArchitectView

Recebe:

- Seções 2, 3, 4, 5, 6, 7, 10, 13, 14, 18, 21 e 24;
- PRD aprovado;
- ADRs existentes;
- schema atual;
- constraints organizacionais.

Uso:

- desenhar arquitetura;
- validar Golden Path;
- propor ADR;
- modelar banco;
- definir contratos.

## 19.4. BackendView

Recebe:

- Seções 5, 6, 7, 8, 9, 10, 11, 12, 14, 15, 17, 21 e 23;
- API contract;
- DB schema;
- tarefa atômica;
- tipos relevantes.

Uso:

- Server Actions;
- Route Handlers;
- DAL;
- jobs;
- integrações;
- testes backend.

## 19.5. FrontendView

Recebe:

- Seções 8, 9, 16, 17 e 23;
- design tokens;
- API contract;
- componentes existentes;
- tarefa atômica.

Uso:

- componentes;
- telas;
- estados;
- acessibilidade;
- design system.

## 19.6. QAView

Recebe:

- Seções 2, 3, 15, 21, 22 e 23;
- PRD;
- critérios de aceite;
- Execution Plan;
- código alterado.

Uso:

- validar critérios;
- gerar testes;
- classificar falhas;
- aprovar ou bloquear.

## 19.7. DevSecOpsView

Recebe:

- Seções 3, 11, 13, 14, 17, 18, 21, 22 e 23;
- auth;
- proxy;
- env;
- APIs;
- Server Actions;
- dados sensíveis.

Uso:

- threat modeling;
- LGPD;
- secrets;
- autorização;
- logs;
- vulnerabilidades.

## 19.8. DevOpsView

Recebe:

- Seções 10, 12, 14, 18, 21, 22 e 23;
- migrations;
- CI/CD;
- vercel.json;
- env requirements;
- QA/Security approvals.

Uso:

- deploy;
- migrations;
- rollback;
- runbooks;
- healthcheck;
- observabilidade.

## 19.9. Regras de ingestão RAG

Indexar com metadados:

```json
{
  "document": "reference_architecture_v1_1_1.md",
  "section": "string",
  "subsection": "string",
  "agent_views": ["TechLeadView"],
  "rule_level": "mandatory | golden_path | adr_required | reference",
  "domain": "architecture | backend | frontend | qa | security | devops | data | observability",
  "priority": "core | supporting | optional",
  "version": "1.1.1"
}
```

## 19.10. Chunking recomendado

- Chunk por subseção.
- Preservar títulos.
- Preservar tabelas com contexto.
- Separar templates em chunks próprios.
- Marcar anti-padrões como alta prioridade.
- Marcar regras obrigatórias como `mandatory`.

---

# 20. Tech Lead Council

## 20.1. Quando acionar

Acionar em:

- aprovação de PRD;
- aprovação de arquitetura;
- exceção ao Golden Path;
- mudança estrutural;
- mudança de banco;
- migration destrutiva;
- go-live;
- incidente crítico;
- decisão de segurança;
- conflito entre agentes.

## 20.2. Personas

| Persona | Foco |
|---|---|
| Contrarian | risco, segurança, custo oculto |
| First Principles Thinker | problema real, simplicidade, YAGNI |
| Expansionist | escalabilidade e futuro |
| Outsider | clareza, manutenção, DX |
| Executor | entrega, pragmatismo, MVP |

## 20.3. Saída esperada

```md
## Council Verdict — [Tema]

### Where the Council Agrees
...

### Where the Council Clashes
...

### Blind Spots Caught
...

### Recommendation
...

### The One Thing to Do First
...
```

---

# 21. Checklist de novo projeto

## 21.1. Estrutura

- [ ] Next.js 16.
- [ ] `proxy.ts`.
- [ ] App Router.
- [ ] `auth.ts`.
- [ ] `lib/env.ts`.
- [ ] `lib/prisma.ts`.
- [ ] `prisma.config.ts`.
- [ ] `prisma/migrations`.
- [ ] `docs/adr`.
- [ ] `/api/health`.

## 21.2. Segurança

- [ ] Google OAuth.
- [ ] Restrição de domínio.
- [ ] Status de usuário.
- [ ] Role no banco.
- [ ] `guardCron`.
- [ ] Nenhum secret hardcoded.
- [ ] Autorização server-side.
- [ ] Logs sem PII.

## 21.3. Banco

- [ ] Prisma schema com `@map`.
- [ ] Migrations versionadas.
- [ ] `prisma migrate deploy` no CI.
- [ ] Constraints naturais para jobs.
- [ ] `sync_log`.
- [ ] `audit_log`.

## 21.4. Qualidade

- [ ] Typecheck.
- [ ] Lint.
- [ ] Vitest.
- [ ] Playwright quando aplicável.
- [ ] Build.
- [ ] QA gate.

## 21.5. Frontend

- [ ] Tailwind v4.
- [ ] Tokens Organização.
- [ ] Dark mode.
- [ ] Inter.
- [ ] Bootstrap Icons ou ADR.
- [ ] Recharts ou ADR.
- [ ] Acessibilidade mínima.

## 21.6. Deploy

- [ ] Vercel configurado.
- [ ] Env por ambiente.
- [ ] Healthcheck.
- [ ] Rollback plan.
- [ ] Runbook quando crítico.
- [ ] Smoke test pós-deploy.

---

# 22. Anti-padrões proibidos

| Anti-padrão | Alternativa |
|---|---|
| `npm audit fix --force` | revisão manual / PR controlado |
| `prisma db push` em staging/produção | `prisma migrate deploy` |
| `prisma migrate dev` em banco real | migration revisada |
| SQL raw concatenado | template literal Prisma |
| lógica em `route.ts` | `lib/`, service ou DAL |
| `process.env` espalhado | `lib/env.ts` |
| segredo no código | env var |
| stack trace ao cliente | erro genérico |
| import de lib ausente | aprovação do Tech Lead |
| `for...of await` paralelizável | `pMap`/`Promise.all` |
| `<img>` nativo | `<Image>` |
| SWR sem necessidade | Server Component |
| `middleware.ts` em Next.js 16 | `proxy.ts` |
| `tailwind.config.ts` para tema v4 | `@theme` |
| backend separado sem ADR | monorepo Next.js |
| RLS universal sem decisão | política condicional |
| job sem idempotência | upsert/checkpoint |
| job grande sem checkpoint | job_runs/job_locks |
| API externa dentro de transação | chamar antes/depois |
| merge sem teste para regra nova | Vitest/Playwright |
| logs com PII | mascarar/omitir |

---

# 23. Templates de referência

## 23.1. Nota sobre templates

Templates deste documento são referência.

Eles devem ser adaptados:

- ao domínio;
- aos nomes reais;
- aos contratos do projeto;
- ao schema real;
- às regras de negócio.

Não copiar literalmente exemplos de `reference-project` quando o projeto tiver outro domínio.

## 23.2. Template de Server Action

```ts
"use server";

import { z } from "zod";
import { revalidatePath } from "next/cache";
import { auth } from "@/auth";
import { isAdmin } from "@/lib/admin";
import { logAudit } from "@/lib/db/audit-log";

const schema = z.object({
  id: z.string().min(1),
});

export async function performAdminAction(rawInput: unknown) {
  const session = await auth();

  if (!isAdmin(session?.user?.role)) {
    throw new Error("Unauthorized");
  }

  const input = schema.parse(rawInput);

  // Chamar função de lib/db ou service aqui.
  // Registrar audit_log quando sensível.

  await logAudit({
    actorUserId: session!.user.id,
    actorEmail: session!.user.email!,
    action: "perform_admin_action",
    entityType: "entity",
    entityId: input.id,
  });

  revalidatePath("/admin");
}
```

## 23.3. Template de Cron Route

```ts
import { NextResponse } from "next/server";
import { guardCron } from "@/lib/jobs/cron-guard";
import { logSync } from "@/lib/db/sync-log";

export async function GET(req: Request) {
  const guard = guardCron(req);
  if (guard) return guard;

  const startedAt = Date.now();

  try {
    const result = await runJob();

    await logSync({
      job: "job-name",
      durationMs: Date.now() - startedAt,
      status: "success",
      counts: result.counts,
    });

    return NextResponse.json({ ok: true, ...result });
  } catch (err) {
    await logSync({
      job: "job-name",
      durationMs: Date.now() - startedAt,
      status: "error",
      errorMsg: String(err),
    });

    return NextResponse.json(
      { ok: false, error: "Internal server error" },
      { status: 500 }
    );
  }
}
```

## 23.4. Template de Healthcheck

```ts
import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";

export async function GET() {
  try {
    await prisma.$queryRaw`SELECT 1`;

    return NextResponse.json({
      status: "ok",
      db: "ok",
      ts: new Date().toISOString(),
    });
  } catch {
    return NextResponse.json(
      {
        status: "error",
        db: "unreachable",
      },
      { status: 503 }
    );
  }
}
```

## 23.5. Template de Rollback Plan

```md
# Rollback Plan

## Deploy
Versão:
Commit:
Data:
Responsável:

## Condições para rollback
- condição 1
- condição 2

## Passos de rollback
1.
2.
3.

## Banco de dados
A migration é:
- [ ] reversível
- [ ] compatível
- [ ] irreversível
- [ ] destrutiva

Plano para banco:

## Validação pós-rollback
- [ ] /api/health
- [ ] login
- [ ] fluxo crítico
- [ ] logs
- [ ] APM

## Comunicação
Quem avisar:
Canal:
Mensagem:

## Riscos
-
```

---

# 24. Pontos que exigem validação humana

Antes de transformar em política final da organização, validar:

| Tema | Decisão proposta | Validação necessária |
|---|---|---|
| APM | Sentry/Datadog/OpenTelemetry/Vercel | ferramenta oficial |
| Rate limit | Upstash ou Edge/Vercel | custo e supply chain |
| Playwright | obrigatório para E2E crítico | escopo por tamanho de projeto |
| Branch policy | `main`, `develop`, releases | padrão interno |
| Job locks | obrigatório só em jobs críticos | critério de obrigatoriedade |
| RLS | condicional | tabelas sensíveis atuais |
| Mascaramento de logs | não logar e-mail completo | impacto em debugging |
| Timeout externo | 30s padrão | exceções por API |
| `audit_log` | obrigatório daqui em diante | plano para legados |
| Banco de teste | necessário para integração | provisionamento |

---

# 25. Relação com a Enterprise AI Software Factory

Este documento é a base técnica que todos os agentes devem respeitar.

Relação com os agentes:

| Agente | Uso deste documento |
|---|---|
| Tech Lead | governa e valida aderência |
| Product Owner | consulta apenas restrições técnicas quando necessário |
| Arquiteto | usa como base completa da solução |
| Task Planner | transforma arquitetura em tarefas aderentes |
| Dev Backend | segue BackendView |
| Dev Frontend | segue FrontendView |
| QA | valida contra QAView e anti-padrões |
| DevSecOps | valida contra SecurityView |
| DevOps | valida contra DevOpsView |

Este documento não substitui:

- PRD;
- Architecture.md específico do projeto;
- Execution_Plan.json;
- ADRs;
- prompts dos agentes;
- skills.

Ele é a base normativa que todos esses artefatos devem respeitar.

---

# 26. Versionamento e evolução

## 26.1. Versionamento

Use versionamento semântico documental:

```txt
v1.1.1
major.minor.patch
```

- `major`: mudança de stack ou filosofia.
- `minor`: nova seção ou nova política relevante.
- `patch`: ajustes editoriais, clarificações, refinamentos.

## 26.2. Revisão periódica

Revisar:

- a cada 6 meses;
- a cada major de Next.js;
- a cada major de Prisma;
- após incidente crítico;
- após 3 ADRs sobre o mesmo tema;
- quando agentes repetirem erro de forma recorrente.

## 26.3. Changelog

Toda mudança deve registrar:

- o que mudou;
- por que mudou;
- impacto nos agentes;
- impacto nos templates;
- necessidade de reindexar RAG;
- necessidade de atualizar prompts.

---

# 27. Síntese final

Esta arquitetura existe para garantir que a Enterprise AI Software Factory produza software:

- seguro;
- auditável;
- escalável;
- simples de manter;
- consistente entre projetos;
- compatível com agentes de IA;
- alinhado à realidade da Organização.

A regra central é:

```txt
Agentes podem executar.
Agentes podem sugerir.
Agentes podem detectar riscos.
Mas a arquitetura define o trilho.
```

Quando houver dúvida:

```txt
Siga o Golden Path.
Se não for suficiente, escreva um ADR.
Se o risco for alto, escale ao Tech Lead.
Se afetar produção, peça aprovação humana.
```
