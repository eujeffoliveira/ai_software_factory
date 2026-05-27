# Checklist — Logging & Observability

**Arquétipo:** `automation_script`
**Gate:** A2 + A3

## Setup

- [ ] `structlog` configurado com output JSON
- [ ] `run_id` (UUID) gerado no startup e propagado para todos os logs
- [ ] Logger instanciado com `structlog.get_logger(__name__)`
- [ ] Nível de log configurável via `LOG_LEVEL` env var

## Campos Obrigatórios

- [ ] `timestamp` em ISO 8601 em todo evento
- [ ] `level` em todo evento
- [ ] `event` (snake_case) em todo evento
- [ ] `run_id` em todo evento
- [ ] `service` (nome do projeto) em todo evento

## Eventos Obrigatórios

- [ ] `startup` — configuração válida, dry_run status
- [ ] `processing_started` — total de registros a processar
- [ ] `record_processed` — para cada registro (nível DEBUG)
- [ ] `record_skipped` — com razão do skip
- [ ] `record_failed` — com detalhes do erro (não stacktrace completo no INFO)
- [ ] `api_call` — URL, método, status code, duration_ms
- [ ] `api_retry` — número da tentativa, erro
- [ ] `run_completed` — status, contagens, duration_ms

## Boas Práticas

- [ ] `print()` substituído por logger em todo código de produção
- [ ] Erros logados com contexto suficiente para diagnóstico
- [ ] Stacktrace completo apenas em nível ERROR com `exc_info=True`
- [ ] Campos de negócio incluídos (ex: `record_id`, `batch_id`, `date`)
- [ ] Dados sensíveis não logados (credenciais, PII)
