# Test Plan

**Projeto:** [Nome]
**Arquétipo:** `automation_script`
**Versão:** 1.0

---

## Estratégia de Testes

| Tipo | Ferramenta | Cobertura mínima |
|------|-----------|-----------------|
| Unitários (serviços) | pytest | 80% das funções de negócio |
| Integração (CLI) | pytest + CliRunner | Todos os comandos |
| Mock HTTP | respx / pytest-httpx | Todos os endpoints externos |
| Contrato (schema) | pytest + Pydantic | Input e output schemas |
| Idempotência | pytest | Executar 2x = mesmo resultado |
| Dry-run | pytest | Sem efeitos externos |
| Erro | pytest | Todos os erros esperados mapeados |

---

## Cenários Obrigatórios

### Happy Path
- [ ] Input válido → processamento correto → output válido
- [ ] Run log registrado com status `success`
- [ ] Dry-run: processa tudo mas não persiste nada

### Validação de Entrada
- [ ] Campo obrigatório ausente → `ValidationError` + exit 1
- [ ] Tipo inválido → erro descritivo
- [ ] API retorna payload malformado → skip registro + log warning

### Erros de Integração
- [ ] API retorna 500 → retry 3x → falha com log
- [ ] API retorna 404 → skip registro + log warning
- [ ] Timeout → retry com backoff → falha após limite
- [ ] API indisponível no startup → exit 1 + mensagem clara

### Idempotência
- [ ] Executar 2x com mesmo input → mesmo estado final
- [ ] Execução interrompida → retomar do checkpoint
- [ ] Registro já processado → skip com log

### Segurança
- [ ] Credenciais não aparecem nos logs
- [ ] Dry-run não persiste nada no destino

---

## Exemplo de Teste

```python
import pytest
from unittest.mock import patch
import respx
import httpx
from typer.testing import CliRunner
from nome_do_projeto.main import app

runner = CliRunner()

def test_run_happy_path(respx_mock):
    respx_mock.get("https://api.exemplo.com/data").mock(
        return_value=httpx.Response(200, json=[{"id": "1", "value": 42}])
    )
    result = runner.invoke(app, ["run", "--dry-run"])
    assert result.exit_code == 0
    assert "processed" in result.output

def test_run_invalid_config():
    with patch.dict("os.environ", {}, clear=True):
        result = runner.invoke(app, ["run"])
    assert result.exit_code == 1
    assert "Missing" in result.output or "ValidationError" in result.output

def test_idempotency(tmp_path, respx_mock):
    # Setup: configurar mock e estado
    respx_mock.get(...).mock(return_value=httpx.Response(200, json=[...]))
    
    runner.invoke(app, ["run", "--state-dir", str(tmp_path)])
    state_after_first = (tmp_path / "state.json").read_text()
    
    runner.invoke(app, ["run", "--state-dir", str(tmp_path)])
    state_after_second = (tmp_path / "state.json").read_text()
    
    assert state_after_first == state_after_second  # idempotente
```

---

## Como Executar os Testes

```bash
# Todos os testes
uv run pytest

# Com cobertura
uv run pytest --cov=src --cov-report=term-missing

# Apenas unitários
uv run pytest tests/services/

# Verbose
uv run pytest -v
```

---

## Critérios de Aprovação (Gate A3)

- [ ] `pytest` passa sem falhas
- [ ] `ruff check src/ tests/` sem erros
- [ ] `mypy src/` sem erros tipo (se configurado)
- [ ] Cobertura ≥ 80% dos módulos de negócio
- [ ] Todos os cenários acima cobertos
