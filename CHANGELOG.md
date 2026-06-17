# Changelog

Todas as mudanças notáveis são documentadas aqui.
Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).
Versionamento semântico via [SemVer](https://semver.org/lang/pt-BR/).

---

## [Unreleased]

### Removed
- Integração de runtime baseada em custom modes do VS Code; a factory agora mantém suporte completo para Claude Code e Codex.

## [0.1.0] - 2026-05-22

### Added
- Instalação global via `install.ps1` com 11 agentes especializados
- Agentes Claude Code em `~/.claude/agents/` com header `AUTO-GENERATED`
- Banco de conhecimento SQLite FTS5 (`knowledge.db`, ~7.000 documentos)
- MCP/RAG central via `tools/mcp-knowledge-search/server.py` (FastMCP)
- Ferramenta `health_check()` no servidor MCP para diagnóstico
- Log estruturado JSON em `tools/mcp-knowledge-search/logs/mcp-knowledge.log`
- Política MCP-first em todos os agentes (fallback explícito, nunca silencioso)
- `test-mcp.ps1` — validação de saúde do MCP (7 checks, colorido, exit 0/1)
- `test_health.py` — validador standalone Python (5 checks)
- `doctor.ps1` — diagnóstico geral da instalação (14 categorias)
- Manifesto de instalação com versão, hashes e rastreabilidade
- Versionamento semântico via arquivo `VERSION`
- `uninstall.ps1` com modos `-KeepKnowledge`, `-Full`, `-WhatIf`, `-Force`
- Instalação idempotente: só escreve o que mudou (hash-driven)
- Instalação atômica: temp → rename + backup com timestamp
- Configuração MCP para Claude Code (`~/.claude.json`)
- `link-mcp.ps1` para vincular factory a projetos existentes
- `update-knowledge.ps1` para reindexar após editar conhecimento
- Documentação operacional: `docs/INSTALLATION.md`, `docs/OPERATIONS.md`, `docs/TROUBLESHOOTING.md`
- Variável de ambiente `FACTORY_ROOT` configurada automaticamente

### Agents

| Agent | Slug | Responsabilidade |
|-------|------|-----------------|
| Tech Lead | `techlead` | Orquestração, gates, ADRs |
| Product Owner | `po` | User stories, backlog, escopo |
| Software Architect | `architect` | Design de sistemas, UML, ADRs |
| Software Engineer | `engineer` | Decomposição, implementação |
| Dev Backend | `devbackend` | APIs REST, banco, auth |
| Dev Frontend | `devfrontend` | React, Next.js, UI |
| QA Engineer | `qa` | Testes unitários, E2E, cobertura |
| DevSecOps | `devsecops` | SAST, OWASP, hardening |
| DevOps | `devops` | CI/CD, Vercel, deployment |
| UX/UI Designer | `uxui` | Pesquisa, wireframes, design system |
| Data Engineer | `dataengineer` | Pipelines, ETL, governança |
