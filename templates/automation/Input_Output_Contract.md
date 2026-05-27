# Input/Output Contract

**Projeto:** [Nome]
**Arquétipo:** `automation_script`
**Versão:** 1.0

---

## Entrada

### Origem
[Descreva a origem: API, arquivo, banco, variáveis de ambiente]

### Schema de Entrada (Pydantic)

```python
from pydantic import BaseModel, Field
from typing import Optional
from datetime import date

class InputRecord(BaseModel):
    id: str = Field(..., description="Identificador único")
    # [adicione campos]
    
class InputConfig(BaseModel):
    start_date: date
    end_date: date
    limit: Optional[int] = Field(default=1000, ge=1, le=10000)
```

### Validações de Entrada

| Campo | Tipo | Obrigatório | Validações | Exemplo |
|-------|------|:-----------:|-----------|---------|
| id | str | S | uuid4 format | `"abc-123"` |
| [campo] | [tipo] | [S/N] | [validações] | [exemplo] |

### Exemplo de Entrada Válida

```json
{
  "id": "abc-123",
  "name": "Exemplo",
  "value": 42.5
}
```

### Comportamento com Entrada Inválida

| Situação | Comportamento esperado |
|----------|----------------------|
| Campo obrigatório ausente | `ValidationError` — script encerra com exit 1 |
| Tipo inválido | `ValidationError` — log + encerra |
| Valor fora do range | `ValidationError` — log + encerra |
| API retorna 404 | Log de warning + pular registro |
| API retorna 500 | Retry 3x + log de erro + encerra se persistir |

---

## Saída

### Destino
[Descreva o destino: arquivo, API, banco, log]

### Schema de Saída (Pydantic)

```python
class OutputRecord(BaseModel):
    id: str
    processed_at: datetime
    status: Literal["success", "skipped", "error"]
    result: Optional[dict] = None
    error_message: Optional[str] = None
```

### Exemplo de Saída Válida

```json
{
  "id": "abc-123",
  "processed_at": "2024-01-15T06:05:23Z",
  "status": "success",
  "result": {}
}
```

---

## Contrato de Run Log

```python
class RunLog(BaseModel):
    run_id: str          # uuid4
    started_at: datetime
    finished_at: datetime
    status: Literal["success", "partial", "failure"]
    total_input: int
    processed: int
    skipped: int
    errors: int
    error_details: Optional[list[str]] = None
```
