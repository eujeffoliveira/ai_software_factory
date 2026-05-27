# Observability & Log Specification

**Projeto:** [Nome]
**Arquétipo:** `automation_script`
**Versão:** 1.0

---

## Campos Obrigatórios em Todo Log

| Campo | Tipo | Descrição | Exemplo |
|-------|------|-----------|---------|
| `timestamp` | ISO 8601 | Momento do evento | `"2024-01-15T06:05:23.123Z"` |
| `level` | str | Nível (DEBUG/INFO/WARNING/ERROR) | `"INFO"` |
| `event` | str | Nome do evento (snake_case) | `"record_processed"` |
| `run_id` | str | UUID da execução atual | `"abc-123"` |
| `service` | str | Nome do serviço | `"nome-do-projeto"` |

---

## Eventos de Log

### Startup

```json
{"event": "startup", "config_valid": true, "dry_run": false, "run_id": "...", "level": "INFO"}
{"event": "startup_failed", "error": "Missing API_KEY", "level": "ERROR"}
```

### Processamento

```json
{"event": "processing_started", "total_input": 1500, "run_id": "...", "level": "INFO"}
{"event": "record_processed", "record_id": "xyz", "status": "success", "duration_ms": 45, "level": "DEBUG"}
{"event": "record_skipped", "record_id": "xyz", "reason": "already_processed", "level": "DEBUG"}
{"event": "record_failed", "record_id": "xyz", "error": "...", "level": "WARNING"}
{"event": "batch_completed", "processed": 100, "skipped": 5, "errors": 2, "level": "INFO"}
```

### Chamadas Externas

```json
{"event": "api_call", "url": "https://api.ex.com/endpoint", "method": "GET", "status_code": 200, "duration_ms": 123, "level": "DEBUG"}
{"event": "api_retry", "attempt": 2, "error": "timeout", "level": "WARNING"}
{"event": "api_failed", "url": "...", "attempts": 3, "final_error": "...", "level": "ERROR"}
```

### Conclusão

```json
{
  "event": "run_completed",
  "run_id": "abc-123",
  "status": "success",
  "total_input": 1500,
  "processed": 1493,
  "skipped": 5,
  "errors": 2,
  "duration_ms": 87432,
  "dry_run": false,
  "level": "INFO"
}
```

---

## Run Log (Persistência)

```python
class RunLog(BaseModel):
    run_id: str
    project: str
    started_at: datetime
    finished_at: datetime
    status: Literal["success", "partial", "failure"]
    total_input: int
    processed: int
    skipped: int
    errors: int
    dry_run: bool
    error_summary: list[str] = []
```

**Destino do run log:** `[arquivo JSON local / tabela SQLite / tabela no banco / stdout]`

---

## Setup do Logger

```python
import structlog

def setup_logging(log_level: str = "INFO") -> None:
    structlog.configure(
        processors=[
            structlog.stdlib.add_log_level,
            structlog.stdlib.add_logger_name,
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.processors.JSONRenderer()
        ],
        logger_factory=structlog.PrintLoggerFactory()
    )
```
