# Example Request — Web Application

**Arquétipo:** `web_app`
**Golden Model:** Web Application (Next.js 16)

---

## Como usar com Claude Code

```
@techlead Quero construir um sistema de agendamento médico.

Contexto:
- Clínica com 10 médicos, ~200 pacientes ativos
- Pacientes agendam consultas online
- Médicos gerenciam agenda pelo painel
- Notificações por email de confirmação e lembrete
- LGPD: dados de saúde são dados sensíveis

Este é um projeto web_app. Por favor, classifique formalmente e inicie o fluxo SDLC.
```

```
@po Escreva o PRD para o sistema de agendamento médico.
Arquétipo: web_app. Golden Model: Next.js 16 + React 19 + TypeScript + Supabase + Vercel.
```

```
@architect Projete a arquitetura do sistema de agendamento.
Stack: Next.js 16 (App Router), PostgreSQL/Supabase, Prisma 7, NextAuth v5, Vercel.
Inclua: fluxo de autenticação, modelo de dados, estratégia de notificações.
```

```
@devbackend Implemente a rota POST /api/appointments.
Validação: Zod. Auth: NextAuth v5. DAL: Prisma. Audit log obrigatório.
Referência: API_Contract.json e atomic task block.
```

```
@qa Crie o plano de testes para o módulo de agendamento.
Golden Model Web: Vitest (unitários) + Playwright (E2E). Cobertura mínima: 80%.
```

```
@devsecops Audite a implementação do módulo de agendamento médico para OWASP Top 10.
Dados de saúde envolvidos — revisão de LGPD obrigatória.
```
