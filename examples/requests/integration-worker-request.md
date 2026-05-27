# Example Request — Integration Worker

**Arquétipo:** `integration_worker`
**Golden Model:** Integration Worker (Python 3.12+)

---

## Como usar com Claude Code

```
@techlead Precisamos de um worker que consome eventos de um tópico Redis Streams
quando um novo pedido é criado no e-commerce, envia os dados para o ERP via API,
e atualiza o status no banco de dados.

Volume: ~200 pedidos/hora em pico.

Classifique como integration_worker e inicie o fluxo.
```

```
@dataengineer Projete o worker de sincronização de pedidos.
Fonte: Redis Streams (tópico order.created).
Destino: ERP REST API + PostgreSQL (status update).
Requisitos: idempotência por order_id, retry 3x com backoff, dead-letter para falhas permanentes,
observabilidade com message_id em todos os logs.
```

```
@engineer Planeje a implementação do integration worker.
Stack: Python 3.12, redis-py, httpx, tenacity, Pydantic v2, structlog, pytest.
Estrutura: consumer loop, message processor, ERP client, dead-letter handler.
```

```
@qa Valide o integration worker:
- Idempotência: processar mesmo order_id 2x → estado idêntico
- Retry: mock ERP com 500 3x → falha após 3 tentativas → dead-letter
- Dead-letter: mensagem vai para dead-letter após N falhas
- Logs: message_id presente em todo evento
- Timeout: chamada ERP sem timeout → teste detecta
```

```
@devsecops Revise o integration worker:
- Credenciais Redis e ERP via variáveis de ambiente
- Dead-letter não vaza dados pessoais de pedidos
- Timeout explícito em toda chamada ERP
- Rate limit respeitado (documentar limites da API ERP)
```
