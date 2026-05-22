# Testes — AI Software Factory

## Estado atual

Este projeto é um framework de engenharia de prompts e design de agentes — não uma aplicação com suite de testes automatizados convencional. A validação é feita via:

1. `doctor.ps1` — diagnóstico completo da instalação (14 categorias)
2. `test-mcp.ps1` — validação de saúde do MCP (7 verificações)
3. Testes manuais de agentes — cenários realistas de uso

---

## doctor.ps1

Execute do diretório raiz da factory:

```powershell
.\doctor.ps1
```

O script verifica 14 categorias:

| # | Categoria | O que verifica |
|---|-----------|----------------|
| 1 | FACTORY_ROOT | Variável de ambiente definida e aponta para diretório existente |
| 2 | Python | Interpretador Python 3.x disponível no PATH |
| 3 | Dependências MCP | Pacote `mcp` instalado no Python detectado |
| 4 | Arquivos de agente | 11 arquivos em `~/.claude/agents/` com conteúdo válido |
| 5 | knowledge.db | Banco existe em `tools/mcp-knowledge-search/knowledge.db` |
| 6 | Tamanho do banco | knowledge.db tem tamanho razoável (não vazio ou corrompido) |
| 7 | ~/.claude.json | Entrada `mcpServers.knowledge` presente na raiz |
| 8 | mcp_settings.json | Configuração global Roo Code presente (se instalado) |
| 9 | .mcp.json | Arquivo de configuração local existe na raiz da factory |
| 10 | roo/.roomodes | Arquivo de modos Roo Code gerado |
| 11 | roo/.clinerules | Arquivo de regras Cline gerado |
| 12 | Scripts auxiliares | `update-knowledge.ps1`, `link-mcp.ps1`, `link-roo.ps1` existem |
| 13 | Factory manifest | `knowledge-config.json` existe e contém versão |
| 14 | Paths de agente | Nenhum arquivo de agente tem FACTORY_ROOT obsoleto |

**Códigos de saída:** `0` = OK ou WARN, `1` = pelo menos um ERROR

**Interpretação:**
- `OK` — verificação passou
- `WARN` — configuração opcional ausente (ex: Roo Code não instalado)
- `ERROR` — falha crítica — executar `.\install.ps1` para corrigir

---

## test-mcp.ps1

Execute do diretório raiz da factory:

```powershell
.\test-mcp.ps1
```

O script executa 7 verificações focadas no servidor MCP:

| # | Verificação | Critério de sucesso |
|---|-------------|---------------------|
| 1 | FACTORY_ROOT definido | Variável de ambiente existe e diretório é válido |
| 2 | server.py existe | `tools/mcp-knowledge-search/server.py` presente |
| 3 | knowledge.db existe | Banco em `tools/mcp-knowledge-search/knowledge.db` |
| 4 | FTS query funciona | Query de teste retorna ao menos 1 resultado |
| 5 | Pacote mcp instalado | `import mcp` não levanta ImportError |
| 6 | Tool listing funciona | Servidor responde corretamente à listagem de ferramentas |
| 7 | Document count > 0 | Banco contém documentos indexados |

**Códigos de saída:** `0` = todos passaram, `1` = um ou mais falharam

---

## Teste manual de agentes

Após a instalação, verifique que os agentes funcionam corretamente:

### 1. Verificação básica

```powershell
# Abrir Claude Code em qualquer diretório
cd C:\qualquer-projeto
claude
```

Na sessão:

```
@techlead quais gates você aplicaria a um projeto de API REST simples?
```

**Esperado:** o agente responde com conhecimento sobre os gates (A0, 1, 2, 3, Gate 5 Security incontornável, Gate 6 com aprovação humana) sem precisar de arquivos locais.

### 2. Verificação do MCP

Na sessão do Claude Code:

```
@techlead search_knowledge("tollgate decision skill")
```

**Esperado:** retorna resultados do `knowledge.db` com trechos de artefatos da factory.

### 3. Verificação de classificação de arquétipo

```
@techlead classifique o arquétipo: script Python que sincroniza dados de um ERP para um banco local, rodando todo dia às 2h
```

**Esperado:** Tech Lead retorna JSON com `project_type: "automation_script"` e `golden_model: "standards/golden-model-python-automation.md"`.

### 4. Verificação do Roo Code

Após executar `link-roo.ps1` em um projeto:

1. Abrir VS Code no projeto
2. Abrir painel do Roo Code
3. Verificar que os 11 modos aparecem com emojis
4. Selecionar "🏗️ Tech Lead" e fazer uma pergunta simples

**Esperado:** o agente responde no contexto do Tech Lead da factory.

---

## Sequência recomendada de validação pós-instalação

```powershell
# 1. Diagnóstico completo
.\doctor.ps1

# 2. Validação específica do MCP
.\test-mcp.ps1

# 3. Teste manual no Claude Code
claude --print "@techlead health_check()"
```

Se todos os três passarem sem ERROR, a instalação está funcional.

---

## Roadmap de testes (versões futuras)

Para versões futuras da factory, está previsto:

| Tipo | Escopo | Ferramenta |
|------|--------|------------|
| Testes unitários de ingestão | `ingest.py`: parsing de documentos, indexação FTS5 | pytest |
| Testes de integração do servidor | `server.py`: todas as 6 ferramentas MCP | pytest + mcp test client |
| Validação de schemas | Todos os `handoff_schema.json` dos 11 agentes | jsonschema |
| Testes E2E de invocação | Invocação de agentes via Claude Code API | pytest + anthropic SDK |
| Testes de idempotência | `install.ps1` rodando duas vezes consecutivas | PowerShell Pester |

Contribuições para estes testes são bem-vindas. Veja `CONTRIBUTING.md`.

---

## Testes de conteúdo dos agentes

Para verificar a consistência dos artefatos de um agente:

```powershell
# Validar estrutura de um agente
.\tools\factory-scripts\validate-framework.sh Agente01_ProductOwner

# Validar skills de um agente
.\tools\factory-scripts\validate-skills.sh Agente06_QaEngineer

# Métricas de todos os agentes
.\tools\factory-scripts\agent-metrics.sh
```

Esses scripts verificam: presença dos arquivos obrigatórios, estrutura de skills (6 arquivos por skill), schemas JSON válidos e contagem de artefatos.
