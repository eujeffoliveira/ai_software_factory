# Golden Model — CLI Tool (`cli_tool`)

**Archetype:** `cli_tool`
**Applies to:** Ferramentas de linha de comando para desenvolvedores ou operadores, utilitários locais, scripts de developer experience.
**Default language:** Python + Typer (preferido) ou Node.js + Commander.
**Status:** Initial version.

---

## Stack Obrigatória (Python)

| Camada | Tecnologia |
|--------|-----------|
| Linguagem | Python 3.12+ |
| CLI framework | Typer |
| Config | pydantic-settings |
| Output rico | Rich (opcional) |
| Testes | pytest + CliRunner (Typer) |
| Empacotamento | `pyproject.toml` com `[project.scripts]` |
| Lint | ruff |

---

## Regras Obrigatórias

1. **`--help` completo em todo comando** — Descrição, parâmetros, exemplos no docstring.
2. **Exit codes padronizados** — `0` = sucesso, `1` = erro de uso, `2` = erro de execução.
3. **`--dry-run` em comandos destrutivos** — Todo comando que apaga, sobrescreve ou envia dados.
4. **Config documentada** — Todas as opções de configuração em README ou help.
5. **Testes de CLI** — Testar cada comando com CliRunner ou subprocess.
6. **Empacotamento correto** — Instalável via `pip install` ou `uv tool install`.
7. **Versão acessível** — `tool --version` retorna versão do `pyproject.toml`.

---

## Antipadrões Críticos

- Comando sem `--help`
- Exit code sempre 0, mesmo em erro
- Ausência de `--dry-run` em operações destrutivas
- Não testável sem side effects reais
- Não empacotável (só funciona no diretório do autor)

---

## Artefatos Obrigatórios

- `README.md` — instalação, uso, exemplos de todos os comandos
- `Test_Plan.md` — cada comando coberto com CliRunner
