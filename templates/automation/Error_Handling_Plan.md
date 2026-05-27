# Error Handling Plan

**Projeto:** [Nome]
**Arquétipo:** `automation_script`
**Versão:** 1.0

---

## Erros Esperados

| Erro | Causa | Tratamento | Retry? | Ação |
|------|-------|-----------|:------:|------|
| `httpx.TimeoutException` | API lenta | Log + retry | S | Exponential backoff 3x |
| `httpx.HTTPStatusError 5xx` | API instável | Log + retry | S | Exponential backoff 3x |
| `httpx.HTTPStatusError 4xx` | Request inválido | Log + skip | N | Registrar erro no run log |
| `pydantic.ValidationError` | Payload malformado | Log + skip registro | N | Registrar como erro |
| `FileNotFoundError` | Arquivo de entrada ausente | Log + encerrar | N | Exit code 1 |
| `ConnectionError` | Banco inacessível | Log + encerrar | N | Exit code 1 com mensagem clara |

---

## Estratégia de Retry

```python
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type

@retry(
    retry=retry_if_exception_type((httpx.TimeoutException, httpx.HTTPStatusError)),
    wait=wait_exponential(multiplier=1, min=1, max=30),
    stop=stop_after_attempt(3),
    reraise=True
)
async def call_external_api(client: httpx.AsyncClient, url: str) -> dict:
    response = await client.get(url, timeout=30)
    response.raise_for_status()
    return response.json()
```

---

## Erros Não Recuperáveis

| Situação | Comportamento |
|----------|--------------|
| Configuração inválida no startup | Encerrar com exit 1 + mensagem clara |
| Credencial inválida (401/403) | Encerrar com exit 1 + mensagem de ação |
| Schema de saída inválido após processamento | Encerrar com exit 1 + não gravar dados inválidos |
| Erro inesperado não mapeado | Log completo do traceback + exit 1 |

---

## Alertas

| Condição | Canal | Responsável |
|----------|-------|------------|
| Job falhou completamente | [email/slack] | [responsável] |
| Taxa de erro > [X]% | [email/slack] | [responsável] |
| Timeout > [Y] minutos | [monitoramento] | [responsável] |

---

## Padrão de Log de Erro

```python
import structlog
log = structlog.get_logger()

try:
    result = process_record(record)
except ValidationError as e:
    log.warning("record_validation_failed", 
                record_id=record.id, 
                errors=e.errors(),
                run_id=run_id)
    error_count += 1
except Exception as e:
    log.error("unexpected_error",
              record_id=record.id,
              error=str(e),
              run_id=run_id,
              exc_info=True)
    raise
```
