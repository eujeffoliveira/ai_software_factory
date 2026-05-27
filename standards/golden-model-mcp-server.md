# Golden Model — MCP Server (`mcp_server`)

**Archetype:** `mcp_server`
**Applies to:** Servidores que expõem ferramentas via Model Context Protocol para agentes de IA.
**Default stack:** Python + FastMCP.
**Status:** Initial version.

---

## Stack Obrigatória

| Camada | Tecnologia |
|--------|-----------|
| Linguagem | Python 3.12+ |
| Framework MCP | FastMCP |
| Validação de tools | Pydantic v2 |
| Logs | structlog (JSON) |
| Testes | pytest |
| Lint | ruff |
| Secrets | pydantic-settings + variáveis de ambiente |

---

## Regras Obrigatórias

1. **Toda tool tem schema de input/output Pydantic** — Nenhuma tool com parâmetros livres.
2. **Documentação de cada tool** — Docstring descrevendo o que faz, quando usar, limitações.
3. **Sem acesso arbitrário ao filesystem** — Paths permitidos devem ser configuráveis e restritos.
4. **Secrets via variáveis de ambiente** — Nunca hardcoded.
5. **Logs estruturados por invocação de tool** — `tool_name`, `input_summary`, `output_status`, `duration_ms`.
6. **Testes unitários de cada tool** — Mínimo: happy path + erro de input inválido.
7. **Segurança de filesystem** — Validar que paths de input não escapam do diretório permitido.

---

## Antipadrões Críticos

- Tool sem schema de input (aceita qualquer coisa)
- Acesso irrestrito ao filesystem
- Segredo hardcoded
- Tool sem documentação
- Ausência de testes

---

## Artefatos Obrigatórios

- `Tool_Catalog.md` — lista de tools com descrição, inputs, outputs, limitações
- `Security_Review.md` — análise de acesso ao filesystem e secrets
- `Test_Plan.md` — cobertura de cada tool
