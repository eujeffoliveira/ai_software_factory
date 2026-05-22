# Golden Model — Integration Worker (`integration_worker`)

**Archetype:** `integration_worker`
**Applies to:** Consumidores de filas (SQS, RabbitMQ, Redis Streams), handlers de webhook, workers de sincronização recorrente, processadores de eventos.
**Default language:** Python 3.12+ ou Node.js (via ADR).
**Status:** Initial version.

---

## Stack Obrigatória (Python)

| Camada | Tecnologia |
|--------|-----------|
| Linguagem | Python 3.12+ |
| Fila (se aplicável) | Redis Streams, SQS, RabbitMQ |
| Scheduler (se cron) | APScheduler ou cron externo |
| Validação de payload | Pydantic v2 |
| HTTP client | httpx |
| Retry | tenacity |
| Logs | structlog (JSON) |
| Testes | pytest + mocks de fila |
| Lint | ruff |

---

## Regras Obrigatórias

1. **Idempotência obrigatória** — Processar a mesma mensagem duas vezes não deve duplicar efeitos.
2. **Dead-letter ou registro de falha** — Mensagens que falham N vezes devem ir para dead-letter queue ou tabela de falhas. Nunca descartadas silenciosamente.
3. **Retry com backoff exponencial** — Toda falha transitória tem retry configurado.
4. **Timeout em toda chamada externa** — Nenhuma chamada sem timeout explícito.
5. **Logs estruturados com `message_id`** — Todo processamento loggado com ID da mensagem e status.
6. **Runbook de operação** — Como pausar, reprocessar, investigar dead-letters.
7. **Testes com mocks de fila** — Testar sem necessidade de infra real.

---

## Antipadrões Críticos

- Worker sem idempotência
- Mensagem descartada silenciosamente em falha
- Ausência de dead-letter / registro de falha
- Ausência de retry
- Chamada externa sem timeout
- Ausência de runbook

---

## Artefatos Obrigatórios

- `Integration_Design.md` — fluxo de mensagens, sistemas envolvidos
- `Idempotency_Plan.md` — como garantir idempotência
- `Error_Handling_Plan.md` — retry, dead-letter, alertas
- `Runbook.md` — operação, reprocessamento, investigação
- `Test_Plan.md` — cenários de erro, retry, idempotência
