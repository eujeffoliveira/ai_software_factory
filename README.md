# AI Software Factory — Multi-Agent SDLC Framework

Uma fábrica de software orientada a **agentes de IA especializados** que funciona como uma instalação global reutilizável. Clone o repositório uma vez, execute `.\install.ps1` e passe a ter 11 agentes disponíveis em qualquer projeto, com acesso ao conhecimento completo via MCP/RAG central — sem copiar nada para cada projeto.

Suporta **Claude Code** (agentes globais via `@nome`) e **Roo Code/Cline** (custom modes no VS Code).

---

## Índice

**Instalação e uso**
- [Quick Start](#quick-start)
- [O que o instalador faz](#o-que-o-instalador-faz)
- [Instalação global](#instalação-global)
- [Como usar em qualquer projeto — Claude Code](#como-usar-em-qualquer-projeto--claude-code)
- [Como usar em qualquer projeto — Roo Code / Cline](#como-usar-em-qualquer-projeto--roo-code--cline)
- [Vincular MCP em outro projeto](#vincular-mcp-em-outro-projeto)
- [Como o conhecimento funciona](#como-o-conhecimento-funciona)
- [Atualização da factory](#atualização-da-factory)
- [Validação pós-instalação](#validação-pós-instalação)
- [Troubleshooting](#troubleshooting)
- [Idempotência e segurança](#idempotência-e-segurança)
- [Automação e outros arquétipos](#automação-e-outros-arquétipos)

**Referência conceitual**
- [O que é a AI Software Factory](#o-que-é-a-ai-software-factory)
- [Como funciona — fluxo SDLC](#como-funciona--fluxo-sdlc)
- [Arquitetura de Agentes](#arquitetura-de-agentes)
- [Ciclo de Vida de um Projeto](#ciclo-de-vida-de-um-projeto)
- [Gates de Qualidade](#gates-de-qualidade)
- [Artefatos e Contratos](#artefatos-e-contratos)
- [Golden Model — Stack Técnica Obrigatória](#golden-model--stack-técnica-obrigatória)
- [Gate A0 — Classificação de Arquétipo](#gate-a0--classificação-de-arquétipo)
- [Standards — Matriz de Golden Models](#standards--matriz-de-golden-models)
- [Estrutura de Pastas](#estrutura-de-pastas)
- [Como criar um agente](#como-criar-um-agente)
- [Como adicionar conhecimento aos agentes](#como-adicionar-conhecimento-aos-agentes)
- [Como instanciar para uma organização](#como-instanciar-para-uma-organização)
- [Knowledge Distillation — Regra de Isolamento](#knowledge-distillation--regra-de-isolamento)
- [Estado atual dos agentes](#estado-atual-dos-agentes)
- [Referências Bibliográficas](#referências-bibliográficas)

---

## Quick Start

```powershell
git clone https://github.com/<seu-usuario>/ai_software_factory.git
cd ai_software_factory
.\install.ps1
```

Pronto. Abra qualquer projeto e chame os agentes:

```
@techlead avalie a arquitetura deste projeto
@qa monte uma estratégia de testes para este módulo
@architect revise as decisões técnicas do backend
@devsecops faça uma revisão de segurança baseada no OWASP Top 10
```

Os agentes funcionam **em qualquer diretório**, de qualquer sessão Claude Code, sem nenhuma configuração adicional por projeto.

---

## O que o instalador faz

O `install.ps1` configura tudo em uma única execução:

| O que | Onde |
|-------|------|
| Define `FACTORY_ROOT` | Variável de ambiente de usuário Windows |
| Instala 11 agentes | `~/.claude/agents/<nome>.md` |
| Instala dependências MCP | pip (controlado por hash — só quando necessário) |
| Cria banco de conhecimento | `knowledge.db` na raiz da factory (SQLite FTS5, ~7.000 docs) |
| Configura MCP global | `~/.claude/settings.json` |
| Gera `.mcp.json` | Raiz da factory |
| Gera suporte Roo Code/Cline | `roo/.roomodes` + `roo/.clinerules` |
| Gera scripts auxiliares | `update-knowledge.ps1`, `link-mcp.ps1`, `link-roo.ps1` |

Todos os arquivos gerados são comparados antes de escrever — o instalador só atualiza o que mudou.

---

## Instalação global

### Pré-requisitos

| Requisito | Observação |
|-----------|-----------|
| Windows PowerShell | Disponível nativamente no Windows 10/11 |
| Python 3.x no PATH | Necessário para o MCP/RAG (`python --version` deve funcionar) |
| Claude Code instalado | Para usar os agentes com `@nome` |

### Executar

```powershell
cd ai_software_factory
.\install.ps1
```

Se aparecer erro de política de execução:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Flags disponíveis:

| Flag | Efeito |
|------|--------|
| *(sem flags)* | Instalação padrão — idempotente |
| `-ForceDeps` | Força reinstalação das dependências Python mesmo que o hash não tenha mudado |

### O que é criado

**Agentes no Claude Code** (`~/.claude/agents/`):

| `@nome` | Papel |
|---------|-------|
| `@techlead` | Tech Lead — orquestração, gates, ADRs, oversight |
| `@po` | Product Owner — user stories, critérios de aceite, backlog |
| `@architect` | Software Architect — arquitetura, UML, decisões técnicas |
| `@engineer` | Software Engineer — decomposição de tarefas, plano de execução |
| `@devbackend` | Dev Backend — APIs, banco de dados, lógica de negócio |
| `@devfrontend` | Dev Frontend — componentes React, páginas Next.js, UI |
| `@qa` | QA Engineer — testes unitários, integração, E2E |
| `@devsecops` | DevSecOps — auditorias de segurança, OWASP, hardening |
| `@devops` | DevOps — CI/CD, infraestrutura Vercel, deploy, SRE |
| `@uxui` | UX/UI Designer — UX research, wireframes, design system |
| `@dataengineer` | Data Engineer — pipelines de dados, ETL, integrações |

Cada arquivo de agente contém:
- `prompt.md` do agente (identidade, regras, comportamentos)
- 8 arquivos de knowledge embutidos (principles, heuristics, decision_rules, knowledge_cards, skills_manifest, quality_gate, context_view, failure_modes)
- Bloco de instruções MCP para busca de conhecimento profundo

**Banco de conhecimento** (`knowledge.db`):

SQLite com FTS5 indexando todos os artefatos da factory — skills, schemas, templates, exemplos, checklists, playbooks. Aproximadamente 7.000 documentos.

**Variável de ambiente**:

`FACTORY_ROOT` é definida como variável de usuário Windows, apontando para o diretório onde a factory foi clonada. Disponível em todos os terminais após reabrir a sessão.

### Após a instalação

Reabra o terminal (para `FACTORY_ROOT` estar disponível) e verifique:

```powershell
echo $env:FACTORY_ROOT
dir "$env:USERPROFILE\.claude\agents"
```

---

## Como usar em qualquer projeto — Claude Code

Nenhuma configuração por projeto é necessária. Abra qualquer diretório com Claude Code e chame os agentes:

```powershell
cd C:\meu-projeto
claude
```

Dentro da sessão:

```
@techlead avalie este projeto usando os padrões da AI Software Factory
@qa crie uma estratégia de testes baseada nos gates da factory
@architect proponha uma refatoração para reduzir acoplamento
@devbackend implemente a rota POST /api/orders com validação Zod
@devsecops faça uma revisão de segurança deste código
@devops o deploy falhou — analise o log e proponha rollback
```

O agente acessa três coisas simultaneamente:
- **Arquivos do projeto atual** — via ferramentas do Claude Code (leitura de arquivos, git, terminal)
- **Conhecimento essencial** — embutido no `~/.claude/agents/<nome>.md`
- **Conhecimento completo da factory** — via MCP/RAG e `knowledge.db`

---

## Como usar em qualquer projeto — Roo Code / Cline

O **Roo Code** (extensão do VS Code) suporta custom modes — perfis de agente com prompt e permissões configuráveis. A factory gera os 11 agentes como modos prontos para uso.

### Configurar em um projeto

```powershell
# No diretório do projeto, com VS Code aberto
& "$env:FACTORY_ROOT\link-roo.ps1"
```

Isso copia `.roomodes` e `.clinerules` da factory para a raiz do projeto atual (com backup automático de versões anteriores). A factory **não é copiada** — apenas os arquivos de configuração que apontam para ela.

### Usar

1. Abra o projeto no VS Code
2. Abra o painel do Roo Code
3. Selecione o modo desejado (Tech Lead, QA, Architect, etc.)
4. Peça análise, revisão ou geração de código

### Modos disponíveis

| Modo | Agente |
|------|--------|
| `techlead` | Tech Lead |
| `po` | Product Owner |
| `architect` | Software Architect |
| `engineer` | Software Engineer |
| `devbackend` | Dev Backend |
| `devfrontend` | Dev Frontend |
| `qa` | QA Engineer |
| `devsecops` | DevSecOps |
| `devops` | DevOps |
| `uxui` | UX/UI Designer |
| `dataengineer` | Data/Integration Engineer |

Todos os modos têm permissões `read`, `edit`, `browser`, `command` e `mcp`.

### Atualizar os modos

Se a factory foi atualizada e os modos mudaram:

```powershell
# Na factory
.\install.ps1

# No projeto
& "$env:FACTORY_ROOT\link-roo.ps1"
```

---

## Vincular MCP em outro projeto

O MCP é configurado globalmente no Claude Code via `~/.claude/settings.json` — ele já está disponível em qualquer sessão sem configuração adicional.

Em alguns casos (Roo Code/Cline, configuração local de projeto, integração com outros clientes MCP), pode ser útil ter um `.mcp.json` local no projeto:

```powershell
# No diretório do projeto
& "$env:FACTORY_ROOT\link-mcp.ps1"
```

Isso copia `.mcp.json` da factory para o diretório atual. A factory **não é copiada** — apenas o arquivo de configuração que aponta para o servidor MCP central.

Na próxima sessão Claude Code naquele projeto, o MCP estará disponível localmente também.

---

## Como o conhecimento funciona

Cada agente opera com dois layers de conhecimento:

```
Projeto atual
   │
   ▼
Claude Code + @agent
   │
   ├── lê arquivos do projeto atual (ferramentas do Claude Code)
   │
   ├── usa prompt + knowledge essencial
   │   └── ~/.claude/agents/<nome>.md
   │       ├── prompt.md (identidade, regras, Golden Model)
   │       ├── knowledge/principles.md
   │       ├── knowledge/heuristics.md
   │       ├── knowledge/decision_rules.md
   │       ├── knowledge/knowledge_cards.md
   │       ├── skills_manifest.md
   │       ├── quality_gate.md
   │       ├── context_view.md
   │       └── failure_modes.md
   │
   └── consulta knowledge completo via MCP/RAG
       └── knowledge.db (SQLite FTS5, ~7.000 docs)
           ├── skills/ — todos os skills com checklists e exemplos
           ├── schemas/ — contratos JSON de I/O
           ├── templates/ — templates de artefatos
           ├── examples/ — exemplos bom/ruim
           ├── checklists/ — checklists operacionais
           └── bibliography/playbooks/ — 12 playbooks de engenharia
```

**Por que dois layers?**

| | Layer 1 — embutido | Layer 2 — MCP |
|---|---|---|
| Latência | Zero — já está no contexto | Requer chamada ao servidor |
| Escopo | Conhecimento essencial e frequente | Conteúdo detalhado e específico |
| Custo | Tokens sempre consumidos | Só quando necessário |
| Cobertura | 8 arquivos por agente | Todos os `.md` da factory (7.000+) |

O bloco MCP em cada agente instrui explicitamente:

> **Consulte o MCP antes de afirmar que um skill, schema, template ou checklist não existe.**

### Ferramentas MCP disponíveis

| Ferramenta | Quando usar |
|-----------|-------------|
| `search_knowledge("termo")` | Busca full-text. Suporta `AND`, `OR`, `NOT`, `"frase exata"` |
| `get_full_document("doc_id")` | Documento completo pelo ID retornado pelo search |
| `get_context("doc_id")` | Seções adjacentes do mesmo arquivo |
| `knowledge_stats()` | Estatísticas do banco e categorias indexadas |

---

## Atualização da factory

### Após `git pull`

```powershell
cd $env:FACTORY_ROOT
git pull
.\install.ps1
```

O instalador é idempotente: atualiza apenas o que mudou (agentes, knowledge.db, configurações). Segunda execução sem mudanças relata tudo como `sem mudancas`.

### Apenas o knowledge.db

Se você editou arquivos de knowledge, skills, schemas, templates, exemplos, checklists ou playbooks sem alterar os prompts dos agentes:

```powershell
cd $env:FACTORY_ROOT
.\update-knowledge.ps1
```

Mais rápido que rodar o instalador completo. O script é atômico — indexa em arquivo temporário e só substitui o banco se bem-sucedido.

**Quando usar `update-knowledge.ps1` em vez de `install.ps1`:**

- Editou `knowledge/` de algum agente
- Editou `skills/` de algum agente
- Editou `schemas/`, `templates/`, `examples/` ou `checklists/`
- Editou `bibliography/playbooks/`
- **Não** editou `prompt.md` de nenhum agente (se editou, use `install.ps1`)

---

## Validação pós-instalação

### Teste 1 — FACTORY_ROOT

```powershell
echo $env:FACTORY_ROOT
# Esperado: C:\caminho\para\ai_software_factory
```

Se vazio: reabra o terminal (a variável é definida para novos processos).

### Teste 2 — Agentes instalados

```powershell
dir "$env:USERPROFILE\.claude\agents" | Select-Object Name
```

Esperado: 11 arquivos (techlead.md, po.md, architect.md, engineer.md, devbackend.md, devfrontend.md, qa.md, devsecops.md, devops.md, uxui.md, dataengineer.md).

### Teste 3 — MCP configurado

```powershell
Get-Content "$env:USERPROFILE\.claude\settings.json" | ConvertFrom-Json | ConvertTo-Json -Depth 3
```

Esperado: chave `mcpServers.knowledge` presente, apontando para `server.py` e `knowledge.db` da factory.

### Teste 4 — Knowledge.db criado

```powershell
ls "$env:FACTORY_ROOT\knowledge.db"
```

### Teste 5 — Agentes respondem

Abra Claude Code em **qualquer diretório fora da factory**:

```powershell
cd C:\qualquer-outro-projeto
claude
```

Dentro da sessão:

```
@techlead quais gates da AI Software Factory você aplicaria neste projeto?
```

O agente deve responder com conhecimento sobre os 7 gates sem precisar de arquivos locais.

### Teste 6 — knowledge.db íntegro

```powershell
cd $env:FACTORY_ROOT
.\update-knowledge.ps1
```

Deve completar sem erros e reportar o número de documentos indexados.

---

## Troubleshooting

### `.\install.ps1` não executa — erro de Execution Policy

**Causa:** PowerShell bloqueia scripts por padrão.

**Solução:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

### Python não encontrado no PATH

**Causa:** Python não está instalado ou não está no PATH do sistema.

**Diagnóstico:**
```powershell
python --version
python3 --version
py --version
```

**Solução:** Instale Python 3.x em [python.org](https://python.org) e marque "Add Python to PATH" durante a instalação. Depois:
```powershell
.\install.ps1
```

O instalador detecta automaticamente `python`, `python3` ou `py`.

---

### Claude Code não reconhece os agentes (`@techlead` não funciona)

**Causa 1:** Sessão Claude Code aberta antes da instalação.

**Solução:** Feche e reabra o Claude Code. Os agentes são lidos de `~/.claude/agents/` no início de cada sessão.

**Causa 2:** Instalação não concluiu corretamente.

**Diagnóstico:**
```powershell
dir "$env:USERPROFILE\.claude\agents"
```

Se a pasta estiver vazia ou os arquivos não existirem:
```powershell
cd $env:FACTORY_ROOT
.\install.ps1
```

---

### Roo Code não mostra os modos da factory

**Causa:** `.roomodes` não foi copiado para o projeto atual.

**Solução:**
```powershell
cd C:\meu-projeto
& "$env:FACTORY_ROOT\link-roo.ps1"
```

Se `FACTORY_ROOT` não estiver definida na sessão atual:
```powershell
& "C:\caminho\para\ai_software_factory\link-roo.ps1"
```

---

### MCP não aparece ou não funciona

**Causa 1:** `settings.json` não foi atualizado.

**Diagnóstico:**
```powershell
Get-Content "$env:USERPROFILE\.claude\settings.json"
```

Se não houver `mcpServers.knowledge`:
```powershell
cd $env:FACTORY_ROOT
.\install.ps1
```

**Causa 2:** Python ou dependências não instaladas.

```powershell
cd $env:FACTORY_ROOT
.\install.ps1 -ForceDeps
```

**Causa 3:** `knowledge.db` não existe.

```powershell
ls "$env:FACTORY_ROOT\knowledge.db"
# Se não existir:
cd $env:FACTORY_ROOT
.\update-knowledge.ps1
```

---

### `knowledge.db` não atualiza após editar arquivos

**Causa:** `install.ps1` pula a reindexação quando o DB é mais recente que todos os `.md`.

**Solução:** Force a reindexação:
```powershell
cd $env:FACTORY_ROOT
Remove-Item knowledge.db -Force
.\update-knowledge.ps1
```

---

### `FACTORY_ROOT` não aparece na sessão atual

**Causa:** Variável de ambiente de usuário só é carregada em novos processos.

**Solução imediata** (apenas para a sessão atual):
```powershell
$env:FACTORY_ROOT = "C:\caminho\para\ai_software_factory"
```

**Solução permanente:** reabra o terminal — a variável estará disponível automaticamente em todas as sessões futuras.

---

### `install.ps1` reporta tudo como `updated` na segunda execução

**Causa:** Diferença de line endings (`\r\n` vs `\n`) entre o que está em disco e o que o script gera.

**Solução:** O instalador atual usa UTF-8 sem BOM e normalização LF em ambos os lados da comparação. Se isso ainda ocorre, verifique se o arquivo foi editado com um editor que insere BOM ou CRLF. Reinstale:
```powershell
.\install.ps1 -ForceDeps
```

---

## Idempotência e segurança

O `install.ps1` pode ser executado quantas vezes quiser, sem efeitos colaterais:

**Comparação de conteúdo antes de escrever**
- Normaliza line endings (LF) e encoding (UTF-8 sem BOM) em ambos os lados
- Só escreve se o conteúdo realmente mudou
- Segunda execução sem mudanças: todos os itens reportados como `sem mudancas`

**`settings.json` preservado**
- Lê o arquivo existente como hashtable
- Adiciona/atualiza apenas a chave `mcpServers.knowledge`
- Preserva todas as outras chaves (`model`, `enabledPlugins`, `theme`, etc.)
- Cria backup com timestamp **apenas quando há mudança real**
- Escrita atômica: grava em arquivo temporário e renomeia (sem risco de corrupção)
- Valida o JSON resultante antes de confirmar

**`knowledge.db` com proteção contra falha**
- Indexa em arquivo `.tmp` separado
- Só substitui o banco existente se a indexação for bem-sucedida
- Mantém backup `.bak` durante o processo
- Restaura o backup em caso de falha

**pip controlado por hash**
- SHA256 do `requirements.txt` salvo em `.requirements.hash`
- `pip install` só roda se o hash mudou ou o pacote `mcp` não está instalado
- Flag `-ForceDeps` força reinstalação quando necessário

**Roo e scripts auxiliares**
- `roo/.roomodes`, `roo/.clinerules`, `link-mcp.ps1`, `link-roo.ps1`, `update-knowledge.ps1` e `factory.ps1` usam a mesma comparação de conteúdo
- Só são reescritos quando o conteúdo gerado diferir do que está em disco

---

## Automação e outros arquétipos

A factory suporta 8 arquétipos de projeto. Para projetos que não são aplicações web, use `@techlead` para acionar o Gate A0 e obter o Golden Model correto:

```
@techlead Classifique o arquétipo deste projeto: script Python que sincroniza dados de uma API externa para um banco PostgreSQL, roda via cron diariamente.
```

O Tech Lead responde com um JSON de classificação e indica o Golden Model, agentes relevantes e artefatos obrigatórios.

### Arquétipo `automation_script` — exemplo de uso

```
@techlead Gate A0 para: script de sincronização de dados do ERP para banco local, roda diariamente.
@engineer Crie o plano de execução seguindo o Golden Model Python Automation em standards/golden-model-python-automation.md
@devbackend Implemente o script usando Python 3.12+, uv, Typer, Pydantic v2, structlog e tenacity
@qa Valide idempotência, dry-run, logging estruturado e testes pytest
@devsecops Revise secrets management e ausência de credenciais hardcoded
```

### Templates e checklists disponíveis

Para o arquétipo `automation_script`, os seguintes artefatos estão disponíveis via MCP/RAG:

| Artefato | Localização | Gate |
|----------|-------------|------|
| `Automation_Brief.md` | `templates/automation/` | A1 |
| `Automation_Design.md` | `templates/automation/` | A2 |
| `Idempotency_Plan.md` | `templates/automation/` | A2 |
| `Config_And_Secrets.md` | `templates/automation/` | A2 |
| `Runbook.md` | `templates/automation/` | A5 |
| Checklist de idempotência | `checklists/automation/` | A3 |
| Checklist de secrets | `checklists/automation/` | A3 |
| Checklist de logging | `checklists/automation/` | A3 |
| Checklist de testes | `checklists/automation/` | A4 |

Busque qualquer template via MCP: `search_knowledge("automation brief template")`.

---

---

## O que é a AI Software Factory

A AI Software Factory é um framework de desenvolvimento de software baseado em **múltiplos agentes de IA especializados** que operam em pipeline sequencial, governados por gates de qualidade e contratos de handoff bem definidos.

Cada agente tem:
- Um papel único e delimitado no ciclo de desenvolvimento
- Um prompt de sistema que define seu comportamento e regras
- Um conjunto de skills com schemas de entrada/saída
- Checklists e exemplos de bons/maus outputs
- Conhecimento destilado de livros e referências técnicas
- Regras de isolamento de contexto (o agente só lê seus próprios artefatos em runtime)

O **Tech Lead** (Agente00) é o orquestrador central: coordena todos os outros agentes, valida handoffs, enforça gates de qualidade, registra riscos e escala para humanos quando necessário.

---

## Como funciona — fluxo SDLC

```
Humano / Input
      │
      ▼
┌─────────────────────┐
│  Agente00_TechLead  │  ← Orquestrador / Presidente do Council
│  (sempre presente)  │
└────────┬────────────┘
         │ roteia para
    ┌────┴──────────────────────────────────────────────────┐
    │                                                       │
    ▼                                                       ▼
Agente01_ProductOwner                          Agente02_SoftwareArchitect
    │                                                       │
    ▼                                                       ▼
  PRD.md ──── Gate 1 ────► Architecture.md ── Gate 2 ────► Execution_Plan
                                                               │
                                                           Gate 3
                                                               │
                                              Agente03_SoftwareEngineer
                                                               │
                               Agente04_DevBackend + Agente05_DevFrontend
                                                               │
                                                       Gate 4 (QA)
                                                               │
                                              Agente06_QaEngineer
                                                               │
                                                   Gate 5 (Security)
                                                               │
                                              Agente07_DevSecOps
                                                               │
                                         Gate 6 (Deploy) ← Aprovação Humana
                                                               │
                                              Agente08_DevOps
                                                               │
                                                   Gate 7 (Post-Deploy)
```

O fluxo é **sempre mediado pelo Tech Lead**. Nenhum agente fala diretamente com outro — cada entrega passa por validação do orquestrador antes de avançar.

### Regras estruturais

- **Nenhum gate avança sem o artefato obrigatório** daquele gate
- **RETURNED** sempre volta ao agente anterior, nunca pula para frente
- **Riscos CRITICAL sem mitigação** bloqueiam o gate atual
- **Decisões irreversíveis** requerem aprovação humana documentada
- **Qualquer desvio do Golden Model** requer ADR aprovada antes de avançar

### Tech Lead Council

Para decisões críticas ou irreversíveis, o Tech Lead ativa o **Council** — uma deliberação com 5 personas internas:

| Persona | Papel |
|---------|-------|
| Contrarian | Questiona pressupostos, aponta riscos ocultos |
| First Principles | Raciocina a partir do zero, sem viés |
| Expansionist | Explora o espaço de soluções mais amplo |
| Outsider | Perspectiva externa, sem familiaridade com o problema |
| Executor | Foco em viabilidade prática e execução |

O Council requer **consenso de ≥ 3 personas**. Sem consenso, escala para humano.

---

## Arquitetura de Agentes

| # | Agente | Papel | Artefato Obrigatório |
|---|--------|-------|----------------------|
| 00 | **Tech Lead** | Orquestrador, State Ledger, Gates, Council | — (orquestra, não produz) |
| 01 | **Product Owner** | Levantamento de requisitos, critérios de aceite | `PRD.md` |
| 02 | **Software Architect** | Decisões de arquitetura, stack, contratos de API | `Architecture.md` |
| 03 | **Software Engineer** | Plano de execução, decomposição de tarefas | `Execution_Plan.json` |
| 04 | **Dev Backend** | Implementação de APIs, lógica de negócio, banco | Pull Request (backend) |
| 05 | **Dev Frontend** | UI, componentes, integração com APIs | Pull Request (frontend) |
| 06 | **QA Engineer** | Testes automatizados, validação de critérios | `QA_Report.md` |
| 07 | **DevSecOps** | Auditoria de segurança, modelagem de ameaças | `Security_Audit.md` |
| 08 | **DevOps** | Pipeline CI/CD, deploy, rollback, SRE | `Deployment_Plan.md` + aprovação humana |
| 09 | **UX/UI Designer** | Design de interfaces, fluxos, usabilidade | `Design_Spec.md` |
| 10 | **Data/Integration Engineer** | Integrações, pipelines de dados, eventos | `Integration_Plan.md` |

---

## Ciclo de Vida de um Projeto

```
1. Humano inicia → Tech Lead cria State_Ledger.json
2. Tech Lead → briefa Product Owner → Gate 1 (PRD válido?)
3. Tech Lead → briefa Software Architect → Gate 2 (Architecture válida?)
4. Tech Lead → briefa Software Engineer → Gate 3 (Execution Plan válido?)
5. Tech Lead → briefa Dev Backend + Dev Frontend → Gate 4 (QA aprovado?)
6. Tech Lead → briefa QA Engineer → Gate 5 (Security aprovado?)
7. Tech Lead → briefa DevSecOps → Gate 6 (Deploy aprovado?) ← HUMANO
8. Tech Lead → briefa DevOps → Gate 7 (Post-Deploy ok?)
9. Projeto encerrado
```

O **State Ledger** (`State_Ledger.json`) é a fonte única de verdade: registra fase atual, agente ativo, artefatos aprovados, riscos abertos, ADRs, questões pendentes e aprovações humanas.

---

## Gates de Qualidade

| Gate | Nome | Artefato Validado | Quem pode bloquear |
|------|------|------------------|--------------------|
| A0 | Classificação de Arquétipo | JSON de classificação (`standards/project-classification.md`) | Tech Lead |
| 1 | PRD Review | PRD.md | Tech Lead |
| 2 | Architecture Review | Architecture.md | Tech Lead |
| 3 | Execution Plan Review | Execution_Plan.json | Tech Lead |
| 4 | QA Gate | QA_Report.md + cobertura de testes | QA Engineer |
| 5 | Security Gate | Security_Audit.md | DevSecOps (Tech Lead NÃO pode sobrepor) |
| 6 | Deployment Gate | Deployment_Plan.md + rollback plan | Humano (obrigatório) |
| 7 | Post-Deploy Gate | Relatório de saúde pós-deploy | Tech Lead + SLO monitoring |

**Gate A0 — Classificação de Arquétipo:**

Roda antes de todos os gates numerados quando o tipo de projeto não é imediatamente óbvio. Output: JSON com `project_type`, `golden_model`, `required_agents`, `required_artifacts`, `not_applicable`. Status codes específicos: `A0_APPROVED` | `A0_AMBIGUOUS` | `A0_BLOCKED`.

Acione com:
```
@techlead Classifique o arquétipo deste projeto: [descrição]
```

**21 Status Codes de Gate:**

```
APPROVED | RETURNED_FOR_REVISION | BLOCKED_PENDING_ADR | BLOCKED_PENDING_HUMAN
BLOCKED_CRITICAL_RISK | BLOCKED_MISSING_ARTIFACT | BLOCKED_QA_FAILURE
BLOCKED_SECURITY_FAILURE | BLOCKED_NO_ROLLBACK_PLAN | BLOCKED_MISSING_ACCEPTANCE_CRITERIA
BLOCKED_ARCHITECTURE_DEVIATION | BLOCKED_COUNCIL_NO_CONSENSUS | BLOCKED_SCOPE_EXCEEDED
BLOCKED_MISSING_TESTS | BLOCKED_SLO_VIOLATION | CONDITIONALLY_APPROVED
APPROVED_WITH_RISK | APPROVED_PENDING_MONITORING | ESCALATED_TO_HUMAN
AWAITING_ADR_RESOLUTION | AWAITING_HUMAN_APPROVAL
```

---

## Artefatos e Contratos

Cada entrega entre agentes segue o **Handoff Package** — um contrato de 7 campos obrigatórios:

```json
{
  "artifact_produced": "PRD.md",
  "summary": "Descrição concisa do que foi produzido",
  "assumptions": ["lista de premissas adotadas"],
  "open_questions": ["questões em aberto que afetam o projeto"],
  "risks": ["riscos identificados"],
  "required_next_agent": "Agente02_SoftwareArchitect",
  "validation_checklist": ["critério 1", "critério 2"]
}
```

O Tech Lead valida o Handoff Package antes de encaminhar ao próximo agente. Handoff incompleto = entrega rejeitada.

---

## Golden Model — Stack Técnica Obrigatória

### Matriz de Golden Models por tipo de projeto

A factory não impõe uma stack única — ela classifica o projeto em um dos 8 arquétipos e aplica o Golden Model correspondente. **Escolher o arquétipo correto não é um desvio e não requer ADR.** ADRs são exigidos apenas para desvios *dentro* do arquétipo escolhido.

| Arquétipo | Golden Model | Stack principal |
|-----------|-------------|-----------------|
| `web_app` | `standards/golden-model-web-app.md` | Next.js 16 + React 19 + TypeScript + Tailwind + NextAuth + Supabase + Prisma + Vercel |
| `automation_script` | `standards/golden-model-python-automation.md` | Python 3.12+ + uv + Typer + Pydantic v2 + structlog + pytest |
| `data_pipeline` | `standards/golden-model-data-pipeline.md` | Python + Polars + DuckDB + Pandera |
| `api_service` | `standards/golden-model-api-service.md` | FastAPI (Python) ou Next.js Route Handlers |
| `cli_tool` | `standards/golden-model-cli-tool.md` | Python + Typer + pyproject.toml |
| `mcp_server` | `standards/golden-model-mcp-server.md` | Python + FastMCP + Pydantic schemas |
| `integration_worker` | `standards/golden-model-integration-worker.md` | Python + Redis/queues + tenacity + dead-letter |
| `notebook_analysis` | `standards/golden-model-notebook-analysis.md` | Jupyter + Polars/Pandas (nunca produção direta) |

O **Gate A0** (`standards/project-classification.md`) classifica o projeto antes de qualquer decisão técnica. Use `@techlead` para acionar o Gate A0:

```
@techlead Classifique o arquétipo deste projeto: [descrição do projeto]
```

### Stack `web_app` — o padrão para aplicações com interface de usuário

O **Golden Model web_app** define a stack obrigatória para aplicações web. Qualquer desvio *dentro deste arquétipo* requer ADR aprovada. Gate 2 é bloqueado até a ADR ser aprovada.

| Camada | Tecnologia |
|--------|-----------|
| Framework | Next.js 16 (App Router) |
| Frontend | React 19 + TypeScript 5 |
| Estilização | Tailwind CSS v4 |
| Autenticação | NextAuth v5 + Google OAuth |
| Backend (API) | Route Handlers no Next.js |
| Proxy/Middleware | `proxy.ts` (NUNCA `middleware.ts` no Next.js 16) |
| Banco de dados | PostgreSQL via Supabase |
| ORM | Prisma 7 com PrismaPg adapter |
| Migrations (prod) | `prisma migrate deploy` (NUNCA `db push`) |
| Deploy | Vercel |
| Cron Jobs | Vercel Cron + `guardCron()` em toda rota cron |
| Validação | Zod em todas as fronteiras do sistema |
| Testes unitários | Vitest |
| Testes E2E | Playwright |
| Gráficos | Recharts v3 |
| Data Fetching | Server Components → Server Actions → SWR (polling) |
| Variáveis de ambiente | `lib/env.ts` centralizado |
| Logs | JSON estruturado (`audit_log`, `sync_log`) |

### Antipadrões críticos (bloqueiam Gate 5)

- SQL concatenado diretamente (SQL injection)
- Lógica de negócio em `route.ts`
- `process.env` espalhado fora de `lib/env.ts`
- Segredos hardcoded no código
- `middleware.ts` no Next.js 16
- `prisma db push` em staging/produção
- Jobs sem idempotência
- Deploy sem plano de rollback documentado
- Stack traces expostos para o cliente

---

## Estrutura de Pastas

```
ai_software_factory/
│
├── install.ps1                       # ← Instalador global (execute este)
├── uninstall.ps1                     # ← Remove tudo que o installer criou
├── update-knowledge.ps1              # Reindexar knowledge.db (gerado pelo install.ps1)
├── link-mcp.ps1                      # Vincular MCP a outro projeto (gerado)
├── link-roo.ps1                      # Vincular Roo Code a outro projeto (gerado)
│
├── docs/
│   └── INSTALL_CLI.md                # Documentação detalhada do installer
│
├── tools/                            # Ferramentas compartilhadas
│   ├── factory-scripts/              # validate-framework.sh, validate-skills.sh,
│   │                                 # credential-preflight.sh, memory-guard.sh, agent-metrics.sh
│   ├── mcp-knowledge-search/         # Servidor MCP (FastMCP + SQLite FTS5)
│   │   ├── server.py                 # Servidor MCP (iniciado automaticamente)
│   │   ├── ingest.py                 # Indexador de documentos
│   │   └── requirements.txt          # Dependências Python
│   └── document-generation/          # spellcheck_document.py, validate_office_file.py
│
├── bibliography/
│   └── playbooks/                    # 12 playbooks operacionais indexados no knowledge.db
│
├── standards/                        # Matriz de Golden Models por arquétipo
│   ├── project-classification.md     # Gate A0: 8 arquétipos, árvore de decisão, regras de ADR
│   ├── golden-model-web-app.md       # Stack web_app (Next.js 16)
│   ├── golden-model-python-automation.md  # Stack automation_script (Python 3.12+)
│   ├── golden-model-data-pipeline.md # Stack data_pipeline (Polars + DuckDB)
│   ├── golden-model-api-service.md   # Stack api_service (FastAPI ou Route Handlers)
│   ├── golden-model-cli-tool.md      # Stack cli_tool (Typer + pyproject.toml)
│   ├── golden-model-mcp-server.md    # Stack mcp_server (FastMCP)
│   ├── golden-model-integration-worker.md  # Stack integration_worker (Redis + tenacity)
│   └── golden-model-notebook-analysis.md   # Stack notebook_analysis (Jupyter + Polars)
│
├── templates/
│   └── automation/                   # 10 templates para o arquétipo automation_script
│
├── checklists/
│   └── automation/                   # 8 checklists (idempotência, dry-run, secrets, logs...)
│
├── examples/
│   └── requests/                     # 6 sequências de prompt multi-agente por arquétipo
│
├── context/                          # Contexto global — BUILD-TIME apenas
│   ├── base_teorica.md               # Prompts e bases de conhecimento de todos os agentes
│   ├── integrantes.md                # Manifesto operacional completo (~2.300 linhas)
│   ├── reference_architecture_generico.md
│   ├── manual_arquitetura_componentes_generico.md
│   ├── client_profile.md             # ← Preencha ao instanciar para uma organização
│   └── prompts/
│       ├── instantiation_prompt.md   # ← Execute após preencher client_profile.md
│       └── prompt_claude_code_agente*_generico.md  # (11 arquivos)
│
├── build/                            # Relatórios de build dos agentes
│
├── Agente00_TechLead/                # ✅ 9 skills
├── Agente01_ProductOwner/            # ✅ 10 skills
├── Agente02_SoftwareArchitect/       # ✅ 10 skills
├── Agente03_SoftwareEngineer/        # ✅ 7 skills
├── Agente04_DevBackend/              # ✅ 11 skills
├── Agente05_DevFrontend/             # ✅ 10 skills
├── Agente06_QaEngineer/              # ✅ 9 skills + tools/e2e-templates/
├── Agente07_DevSecOps/               # ✅ 10 skills + tools/git-hooks/ + tools/sentinel/
├── Agente08_DevOps/                  # ✅ 9 skills + tools/git-hooks/
├── Agente09_UxUiDesigner/            # ✅ 5 skills
└── Agente10_DataIntegrationEngineer/ # ✅ 7 skills + tools/predictive-rigor/

# Gerados pelo install.ps1 (gitignored):
# knowledge.db          ← banco SQLite FTS5 (~7.000 docs)
# knowledge-config.json ← config do indexador
# .mcp.json             ← config MCP local
# roo/                  ← .roomodes e .clinerules para Roo Code
```

Estrutura interna de cada agente:

```
AgenteXX_NomeAgente/
├── prompt.md                  # Prompt de sistema completo
├── agent_config.json          # Config de runtime: fontes permitidas/bloqueadas
├── context_view.md            # Contexto compilado (substitui context/ no runtime)
├── rag_manifest.json          # Política de RAG: coleções, chunking, fontes bloqueadas
├── skills_manifest.md         # Índice de todas as skills
├── quality_gate.md            # Critérios dos gates que o agente valida
├── handoff_schema.json        # Schema do artefato de entrega
├── failure_modes.md           # Modos de falha conhecidos + mitigações
├── knowledge/
│   ├── principles.md          # Princípios operacionais (P1–PN)
│   ├── heuristics.md          # Heurísticas de decisão (H1–HN)
│   ├── decision_rules.md      # Regras if-then (DR001–DRNNN)
│   ├── knowledge_cards.md     # Cartões conceituais reutilizáveis
│   └── source_map.json        # Mapeamento fonte → artefato destilado
├── checklists/
├── schemas/
├── templates/
├── examples/
└── skills/
    └── nome-da-skill/
        ├── skill.md
        ├── input.schema.json
        ├── output.schema.json
        ├── checklist.md
        └── examples/
```

---

## Como criar um agente

### 1. Fontes de entrada (build-time)

| Fonte | O que fornece |
|-------|---------------|
| `context/base_teorica.md` | Prompt base, base de conhecimento, regras |
| `context/integrantes.md` | Manifesto operacional completo do agente |
| `context/reference_architecture_generico.md` | Golden Model técnico |
| `context/manual_arquitetura_componentes_generico.md` | Estrutura de artefatos e contratos |
| `lib/<Papel>/` | Livros de referência do agente (build-time) |

### 2. Relatórios de build

Gerar em `build/` ao final do build:

- `AgenteXX_build_report.md` — sumário completo
- `AgenteXX_generated_files_index.md` — índice de todos os arquivos
- `AgenteXX_runtime_readiness_checklist.md` — checklist de validação pré-runtime
- `AgenteXX_knowledge_distillation_patch_report.md` — fontes consumidas e destiladas

### 3. Após criar ou atualizar um agente

```powershell
cd $env:FACTORY_ROOT
.\install.ps1
```

O instalador propaga as alterações de `prompt.md` e de todos os arquivos de knowledge para `~/.claude/agents/<nome>.md`.

---

## Como adicionar conhecimento aos agentes

Quando há novas fontes de conhecimento — livros, artigos, playbooks, cursos, documentação técnica — use o **prompt padrão de destilação** para incorporá-las corretamente à factory.

**Arquivo:** `context/prompts/prompt_padrao_destilacao_conhecimento.md`

O prompt é executável por qualquer IA com acesso ao repositório (Claude Code, Gemini, Roo Code/Cline, ChatGPT). Ele guia a IA por 27 etapas:

| Etapa | O que faz |
|-------|-----------|
| 0–2 | Contextualiza o projeto e audita a estrutura atual |
| 3 | Classifica cada fonte (tipo, domínio, agentes impactados, arquétipos) |
| 4 | Extrai conhecimento em 12 camadas operacionais (princípios → heurísticas → regras → checklists → templates → schemas → skills → failure modes → exemplos) |
| 5 | Aplica política de direitos autorais e segurança |
| 6–7 | Identifica agentes impactados e atualiza `knowledge/` |
| 8–9 | Atualiza `source_map.json` e `context_view.md` |
| 10–16 | Atualiza prompts, skills, checklists, templates, schemas, exemplos, failure modes |
| 17–19 | Atualiza gates de qualidade, documentação global, manifestos e índices |
| 20 | Garante que novos arquivos entram na indexação MCP/RAG |
| 21–23 | Gera relatório de destilação em `build/`, aplica regras de conflito e precedência |
| 24–27 | Valida que `install.ps1` e `update-knowledge.ps1` continuam funcionando |

### Como usar

1. Abra o prompt em `context/prompts/prompt_padrao_destilacao_conhecimento.md`
2. Copie o conteúdo para uma nova sessão de IA (Claude Code, Roo Code, etc.)
3. No campo **"1. Fontes novas a processar"**, cole os caminhos ou descrições das fontes
4. Execute — a IA auditará o repositório e destilará o conhecimento nos artefatos corretos
5. Após a execução:

```powershell
cd $env:FACTORY_ROOT
.\install.ps1
```

### O que a destilação produz

A IA converte as fontes brutas em artefatos operacionais — nunca copia texto longo nos prompts. Os destilados vão para:

- `AgenteXX/knowledge/` — princípios, heurísticas, decision rules, knowledge cards
- `AgenteXX/skills/` — novas skills acionáveis
- `AgenteXX/checklists/` — checklists verificáveis
- `AgenteXX/templates/` — templates de artefatos
- `AgenteXX/schemas/` — contratos JSON
- `AgenteXX/failure_modes.md` — modos de falha novos
- `build/knowledge_distillation_report_YYYYMMDD.md` — relatório da rodada

---

## Como instanciar para uma organização

Este repositório é **white-label**: não contém referências a organizações, clientes ou domínios específicos. O fluxo de instanciação adapta todos os agentes a um contexto organizacional específico sem modificar o upstream.

```
1. Fork  →  2. Clone  →  3. Preencher client_profile.md  →  4. Rodar instantiation_prompt.md  →  5. Commit  →  6. install.ps1
```

**1. Fork** — O fork é o repositório da organização. O upstream (este repo) continua genérico.

**2. Clone**
```bash
git clone https://github.com/<sua-org>/ai_software_factory.git
cd ai_software_factory
```

**3. Preencher `context/client_profile.md`** — Define identidade da organização, stack overrides, integrações externas, contexto regulatório (LGPD, etc.) e quais agentes ativar.

**4. Executar `context/prompts/instantiation_prompt.md`** — Abra o Claude Code na raiz do repositório e execute o prompt de instanciação. Ele lê o perfil e patcha todos os agentes ativos.

**5. Commit** — O fork agora contém a versão instanciada.

**6. `.\install.ps1`** — Propaga as alterações para `~/.claude/agents/`.

O prompt de instanciação é idempotente: re-execute sempre que o `client_profile.md` for atualizado.

---

## Knowledge Distillation — Regra de Isolamento

A separação entre **build-time** e **runtime** é o princípio central da fábrica.

**Build-time** (apenas durante a criação do agente):
- Livros de referência são lidos e o conhecimento é destilado para `knowledge/`
- Contexto global em `context/` é processado
- Nenhum livro ou arquivo de `context/` é acessado depois disso

**Runtime** (quando o agente está em uso):
- O agente lê apenas seus próprios artefatos em `AgenteXX_*/`
- O MCP Knowledge Search estende o acesso com busca full-text, mas só indexa artefatos dos agentes — nunca `context/` ou `lib/`

**Por que isso importa:**
- **Performance** — o agente não precisa ler centenas de páginas por sessão
- **Consistência** — conhecimento destilado, curado e validado, não raw
- **Custo** — contexto menor = menos tokens

---

## Playbooks operacionais (`bibliography/playbooks/`)

12 guias indexados no `knowledge.db` e acessíveis via MCP:

| # | Playbook |
|---|----------|
| 01 | Prompt Engineering Patterns |
| 02 | Code Review Checklist |
| 03 | Segurança e Privacidade |
| 04 | Performance e Escalabilidade |
| 05 | Testes e Qualidade |
| 06 | DevOps / CI-CD |
| 07 | UX / UI Design |
| 08 | Gestão de Memória e Contexto |
| 09 | Integração de MCPs |
| 10 | Automação de Workflows |
| 11 | Incorporação de Software Existente |
| 12 | Dados e Integração |

---

## Estado atual dos agentes

| Agente | Build | Knowledge | Skills | Status |
|--------|-------|-----------|--------|--------|
| **00 TechLead** | ✅ | ✅ | ✅ 9/9 | Pronto para uso |
| **01 ProductOwner** | ✅ | ✅ | ✅ 10/10 | Pronto para uso |
| **02 SoftwareArchitect** | ✅ | ✅ | ✅ 10/10 | Pronto para uso |
| **03 SoftwareEngineer** | ✅ | ✅ | ✅ 7/7 | Pronto para uso |
| **04 DevBackend** | ✅ | ✅ | ✅ 11/11 | Pronto para uso |
| **05 DevFrontend** | ✅ | ✅ | ✅ 10/10 | Pronto para uso |
| **06 QaEngineer** | ✅ | ✅ | ✅ 9/9 | Pronto para uso |
| **07 DevSecOps** | ✅ | ✅ | ✅ 10/10 | Pronto para uso |
| **08 DevOps** | ✅ | ✅ | ✅ 9/9 | Pronto para uso |
| **09 UxUiDesigner** | ✅ | ✅ | ✅ 5/5 | Pronto para uso |
| **10 DataIntegrationEngineer** | ✅ | ✅ | ✅ 7/7 | Pronto para uso |

Todos os 11 agentes têm build completo.

---

## Referências Bibliográficas

Livros e materiais utilizados como fonte primária na construção do conhecimento de cada agente. Todo o conteúdo foi lido em build-time e destilado nos arquivos `knowledge/` de cada agente — os livros originais não são acessados em runtime.

---

### Agente00 — Tech Lead

- Brooks Jr., Frederick P. **The Mythical Man-Month: Essays on Software Engineering**. Anniversary Edition. Addison-Wesley, 1995.
- Forsgren, Nicole; Humble, Jez; Kim, Gene. **Accelerate: The Science of Lean Software and DevOps**. IT Revolution Press, 2018.
- Martin, Robert C. **The Clean Coder: A Code of Conduct for Professional Programmers**. Prentice Hall, 2011.

*Materiais complementares:* apostilas de pós-graduação — Módulo 10 (Gerenciamento de Projetos: métricas DORA, SWEBOK) e Módulo 12 (Governança de TI).

---

### Agente01 — Product Owner

- Wiegers, Karl E.; Beatty, Joy. **Software Requirements**. 3rd Edition. Microsoft Press, 2013.
- Cockburn, Alistair. **Writing Effective Use Cases**. Addison-Wesley, 2000.
- Cohn, Mike. **User Stories Applied: For Agile Software Development**. Addison-Wesley, 2004.
- Leffingwell, Dean. **Agile Software Requirements: Lean Requirements Practices for Teams, Programs, and the Enterprise**. Addison-Wesley, 2011.
- Robertson, Suzanne; Robertson, James. **Mastering the Requirements Process: Getting Requirements Right**. 3rd Edition. Addison-Wesley, 2012.

*Materiais complementares:* apostilas de pós-graduação — Módulo 02 (Engenharia de Requisitos I: BPMN, regras de negócio) e Módulo 03 (Engenharia de Requisitos II: ISO 25010, RTM, MoSCoW).

---

### Agente02 — Software Architect

- Martin, Robert C. **Clean Architecture: A Craftsman's Guide to Software Structure and Design**. Prentice Hall, 2017.
- Kleppmann, Martin. **Designing Data-Intensive Applications**. O'Reilly Media, 2017.
- Evans, Eric. **Domain-Driven Design: Tackling Complexity in the Heart of Software**. Addison-Wesley, 2003.
- Richards, Mark; Ford, Neal. **Fundamentals of Software Architecture: An Engineering Approach**. O'Reilly Media, 2020.
- Newman, Sam. **Building Microservices: Designing Fine-Grained Systems**. 2nd Edition. O'Reilly Media, 2021.
- Fowler, Martin. **Patterns of Enterprise Application Architecture**. Addison-Wesley, 2002.

*Materiais complementares:* apostilas de pós-graduação — Módulo 04 (Projeto de Software I: coesão e acoplamento) e Módulo 05 (Projeto de Software II: UML — casos de uso, sequência, classes).

---

### Agente03 — Software Engineer

- Thomas, David; Hunt, Andrew. **The Pragmatic Programmer: Your Journey to Mastery**. 20th Anniversary Edition. Addison-Wesley, 2019.
- McConnell, Steve. **Code Complete: A Practical Handbook of Software Construction**. 2nd Edition. Microsoft Press, 2004.
- Gamma, Erich; Helm, Richard; Johnson, Ralph; Vlissides, John. **Design Patterns: Elements of Reusable Object-Oriented Software**. Addison-Wesley, 1994.
- Hohpe, Gregor; Woolf, Bobby. **Enterprise Integration Patterns: Designing, Building, and Deploying Messaging Solutions**. Addison-Wesley, 2003.
- Xu, Alex. **System Design Interview: An Insider's Guide**. 2nd Edition. ByteByteGo, 2022.

*Materiais complementares:* apostilas de pós-graduação — Módulo 04 e Módulo 05 (extração de tarefas a partir de diagramas UML).

---

### Agente04 — Dev Backend

- Martin, Robert C. **Clean Code: A Handbook of Agile Software Craftsmanship**. Prentice Hall, 2008.
- Cormen, Thomas H. et al. **Introduction to Algorithms**. 4th Edition. MIT Press, 2022.
- Richardson, Chris. **Microservices Patterns: With Examples in Java**. Manning Publications, 2018.
- Percival, Harry; Gregory, Bob. **Architecture Patterns with Python: Enabling Test-Driven Development, Domain-Driven Design, and Event-Driven Microservices**. O'Reilly Media, 2020.
- Bhargava, Aditya Y. **Grokking Algorithms: An Illustrated Guide for Programmers and Other Curious People**. Manning Publications, 2016.
- Bentley, Jon. **Programming Pearls**. 2nd Edition. Addison-Wesley, 1999.

---

### Agente05 — Dev Frontend

- Haverbeke, Marijn. **Eloquent JavaScript: A Modern Introduction to Programming**. 3rd Edition. No Starch Press, 2018.
- Tidwell, Jenifer; Brewer, Charles; Valencia, Aynne. **Designing Interfaces: Patterns for Effective Interaction Design**. 3rd Edition. O'Reilly Media, 2020.
- Verou, Lea. **CSS Secrets: Better Solutions to Everyday Web Design Problems**. O'Reilly Media, 2015.
- Grigorik, Ilya. **High Performance Browser Networking: What Every Web Developer Should Know about Networking and Web Performance**. O'Reilly Media, 2013.

---

### Agente06 — QA Engineer

- Beck, Kent. **Test Driven Development: By Example**. Addison-Wesley, 2002.
- Khorikov, Vladimir. **Unit Testing: Principles, Practices, and Patterns**. Manning Publications, 2020.
- Freeman, Steve; Pryce, Nat. **Growing Object-Oriented Software, Guided by Tests**. Addison-Wesley, 2009.
- Feathers, Michael C. **Working Effectively with Legacy Code**. Prentice Hall, 2004.
- Fowler, Martin. **Refactoring: Improving the Design of Existing Code**. 2nd Edition. Addison-Wesley, 2018.

*Materiais complementares:* apostilas de pós-graduação — Módulo 06 (Teste de Software I), Módulo 07 (Teste de Software II), Módulo 08 (Qualidade I) e Módulo 09 (Qualidade II: ISO, CMMI, MPS.BR).

---

### Agente07 — DevSecOps

- Shostack, Adam. **Threat Modeling: Designing for Security**. Wiley, 2014.
- Stuttard, Dafydd; Pinto, Marcus. **The Web Application Hacker's Handbook: Finding and Exploiting Security Flaws**. 2nd Edition. Wiley, 2011.
- Dotson, Chris. **Practical Cloud Security: A Guide for Secure Design and Deployment**. O'Reilly Media, 2019.

---

### Agente08 — DevOps

- Humble, Jez; Farley, David. **Continuous Delivery: Reliable Software Releases through Build, Test, and Deployment Automation**. Addison-Wesley, 2010.
- Beyer, Betsy et al. **Site Reliability Engineering: How Google Runs Production Systems**. O'Reilly Media, 2016.
- Kim, Gene; Behr, Kevin; Spafford, George. **The Phoenix Project: A Novel about IT, DevOps, and Helping Your Business Win**. IT Revolution Press, 2013.
- Kim, Gene et al. **The DevOps Handbook: How to Create World-Class Agility, Reliability, and Security in Technology Organizations**. IT Revolution Press, 2016.
- Morris, Kief. **Infrastructure as Code: Managing Servers in the Cloud**. 2nd Edition. O'Reilly Media, 2020.

*Materiais complementares:* apostilas de pós-graduação — Módulo 11 (Gerência de Configuração: controle de mudanças, ferramentas de CM).

---

### Agente09 — UX/UI Designer

- Yablonski, Jon. **Laws of UX: Using Psychology to Design Better Products and Services**. O'Reilly Media, 2020.
- Krug, Steve. **Don't Make Me Think, Revisited: A Common Sense Approach to Web Usability**. 3rd Edition. New Riders, 2014.
- Gothelf, Jeff; Seiden, Josh. **Lean UX: Designing Great Products with Agile Teams**. 3rd Edition. O'Reilly Media, 2021.

---

### Agente10 — Data / Integration Engineer

- Reis, Joe; Housley, Matt. **Fundamentals of Data Engineering: Plan and Build Robust Data Systems**. O'Reilly Media, 2022.
- Bellemare, Adam. **Building Event-Driven Microservices: Leveraging Organizational Data at Scale**. O'Reilly Media, 2020.
- Dehghani, Zhamak. **Data Mesh: Delivering Data-Driven Value at Scale**. O'Reilly Media, 2022.
- Stopford, Ben. **Designing Event-Driven Systems: Concepts and Patterns for Streaming Services with Apache Kafka**. O'Reilly Media, 2018.
