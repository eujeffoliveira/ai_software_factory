# Checklist — Python Project Structure

**Arquétipo:** `automation_script`
**Gate:** A2 (Implementation Readiness)

## Estrutura de Arquivos

- [ ] `pyproject.toml` existe com `[project]`, `[project.scripts]`, `[tool.ruff]`, `[tool.mypy]`
- [ ] `src/nome_do_projeto/__init__.py` existe
- [ ] `src/nome_do_projeto/main.py` existe com entrypoint Typer
- [ ] `src/nome_do_projeto/config.py` existe com `pydantic-settings`
- [ ] `src/nome_do_projeto/models.py` existe com schemas Pydantic de I/O
- [ ] `tests/conftest.py` existe
- [ ] `tests/test_main.py` existe
- [ ] `.env.example` existe com todas as variáveis documentadas
- [ ] `.env` está no `.gitignore`
- [ ] `README.md` existe com instruções de uso

## pyproject.toml

- [ ] Versão do Python declarada (`python = ">=3.12"`)
- [ ] Todas as dependências declaradas com versões mínimas
- [ ] `[project.scripts]` aponta para o entrypoint correto
- [ ] `ruff` configurado em `[tool.ruff]`
- [ ] `pytest` configurado em `[tool.pytest.ini_options]`

## Entrypoint CLI

- [ ] `main.py` usa Typer com `app = typer.Typer()`
- [ ] Comando principal existe (`run`, `sync`, ou equivalente)
- [ ] Flag `--dry-run` implementada
- [ ] `--help` retorna descrição útil de cada comando e parâmetro
- [ ] `if __name__ == "__main__": app()` presente

## Config

- [ ] `config.py` usa `BaseSettings` do `pydantic-settings`
- [ ] Todas as variáveis de ambiente têm tipo e validação
- [ ] `SecretStr` usado para credenciais
- [ ] `get_settings()` chamado no startup com falha rápida se inválida

## Dependências

- [ ] `uv` ou `poetry` como gerenciador
- [ ] `tenacity` para retries
- [ ] `httpx` para HTTP
- [ ] `structlog` para logs
- [ ] `pytest`, `ruff` em `[dependency-groups.dev]`
