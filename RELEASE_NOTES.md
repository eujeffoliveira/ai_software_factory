# Release Notes — v0.1.0

**Data**: 2026-05-22

Esta é a primeira versão estável da **AI Software Factory** — uma fábrica de software orientada a agentes de IA especializados que funciona como instalação global reutilizável.

---

## O que você recebe

### 11 agentes especializados

Clone o repositório, execute `.\install.ps1` e passe a ter 11 agentes disponíveis em qualquer projeto — sem copiar nada:

```
@techlead   — orquestra o SDLC, valida gates, aprova ADRs
@po         — escreve user stories, define critérios de aceitação
@architect  — design de sistemas, decisões de arquitetura
@engineer   — decompõe tarefas, planeja implementação
@devbackend — APIs REST, banco de dados, migrations Prisma
@devfrontend — componentes React, Next.js, UI com Tailwind
@qa         — planos de teste, Vitest, Playwright
@devsecops  — SAST, OWASP Top 10, hardening, secrets
@devops     — CI/CD, Vercel, deployment, runbooks
@uxui       — pesquisa de usuário, wireframes, design system
@dataengineer — pipelines, ETL, integrações, governança
```

### Conhecimento via MCP

Todos os agentes têm acesso a ~7.000 documentos indexados (skills, schemas, templates, checklists, playbooks) via busca full-text SQLite FTS5. A política **MCP-first** garante que os agentes consultam a knowledge base antes de responder — e declaram explicitamente quando o MCP falha, em vez de silenciosamente ignorar.

### Instalação confiável

- **Idempotente**: rode `.\install.ps1` quantas vezes quiser — só atualiza o que mudou
- **Atômica**: writes via temp → rename + backup com timestamp antes de sobrescrever JSON do usuário
- **Segura**: nunca sobrescreve agentes de outros projetos; nunca apaga dados do usuário sem marcador

### Diagnóstico integrado

```powershell
.\doctor.ps1          # diagnóstico geral (14 categorias)
.\test-mcp.ps1        # saúde específica do MCP (7 checks)
```

### Desinstalação segura

```powershell
.\uninstall.ps1 -WhatIf       # preview do que seria removido
.\uninstall.ps1               # remove agentes e configs, preserva knowledge.db
.\uninstall.ps1 -Full         # remove tudo, incluindo knowledge.db
```

---

## Como começar

```powershell
git clone https://github.com/<usuario>/ai_software_factory.git
cd ai_software_factory
.\install.ps1

# Abra um novo terminal (para FACTORY_ROOT ficar disponível)
# Depois, em qualquer projeto:
@techlead avalie a arquitetura
```

Veja [docs/INSTALLATION.md](docs/INSTALLATION.md) para instruções detalhadas.

---

## Suporte

- Diagnóstico: `.\doctor.ps1`
- Troubleshooting: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
- Operações do dia-a-dia: [docs/OPERATIONS.md](docs/OPERATIONS.md)
