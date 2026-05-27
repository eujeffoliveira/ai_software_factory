# Checklist — Retries & Resilience

**Arquétipo:** `automation_script`
**Gate:** A2 + A3

## Configuração de Retry

- [ ] `tenacity` importado e configurado
- [ ] Toda chamada externa crítica usa decorator `@retry` ou contexto `Retrying`
- [ ] `stop_after_attempt(N)` definido (sugestão: 3)
- [ ] `wait_exponential(multiplier=1, min=1, max=30)` configurado
- [ ] `retry_if_exception_type(...)` especifica quais exceções fazem retry

## Quais Exceções Fazem Retry

- [ ] `httpx.TimeoutException` → retry
- [ ] `httpx.HTTPStatusError` com 5xx → retry
- [ ] `httpx.ConnectError` → retry
- [ ] `httpx.HTTPStatusError` com 4xx → NÃO faz retry (erro do cliente)
- [ ] `ValidationError` → NÃO faz retry

## Timeout

- [ ] `timeout` explícito em toda chamada `httpx.Client.get/post/...`
- [ ] Timeout configurável via variável de ambiente ou config
- [ ] Timeout documentado em `Automation_Design.md`

## Circuit Breaker (se aplicável)

- [ ] Para integrações críticas de alta frequência: circuit breaker configurado
- [ ] Threshold de abertura definido
- [ ] Tempo de recovery definido

## Testes

- [ ] Teste: API retorna 500 → retry ocorre → falha após N tentativas
- [ ] Teste: API retorna 429 (rate limit) → retry com backoff
- [ ] Teste: timeout → retry → falha
- [ ] Mock de retry com `respx` ou `pytest-httpx`
