# Golden Model — API Service (`api_service`)

**Archetype:** `api_service`
**Applies to:** APIs REST ou GraphQL standalone, serviços backend sem UI de browser, microsserviços.
**Default stack:** FastAPI (Python) para novos serviços Python; Next.js Route Handlers se for extensão de `web_app` existente.
**Status:** Initial version.

---

## Stack Obrigatória (Python)

| Camada | Tecnologia |
|--------|-----------|
| Linguagem | Python 3.12+ |
| Framework | FastAPI |
| Validação | Pydantic v2 |
| Banco de dados | PostgreSQL via SQLAlchemy 2 ou Prisma (se Node) |
| Autenticação | JWT + OAuth2 (via `python-jose` ou `authlib`) |
| Documentação | OpenAPI automático (FastAPI) |
| Testes | pytest + httpx (TestClient) |
| Logs | structlog (JSON) |
| Deploy | Container (Docker) + Cloud Run / Railway / Fly.io |
| Lint | ruff |

---

## Regras Obrigatórias

1. **OpenAPI completo** — Todos os endpoints documentados com schemas de request/response e códigos de erro.
2. **Autenticação em toda rota protegida** — Zero endpoints sem auth check em rotas que exigem autenticação.
3. **Paginação em toda listagem** — Nenhum endpoint retorna coleção sem limite/offset ou cursor.
4. **Versionamento de API** — Prefixo `/v1/` obrigatório. Breaking changes requerem `/v2/`.
5. **Healthcheck** — `GET /health` retorna `{"status": "ok", "version": "..."}`.
6. **Rate limiting documentado** — Definir limites e documentar no OpenAPI.
7. **Logs estruturados com `request_id`** — Todo request loggado com ID de correlação.
8. **Testes de contrato** — Testar que a API respeita os schemas definidos.

---

## Antipadrões Críticos

- Endpoint sem autenticação em rota protegida
- Resposta sem schema definido (JSON livre)
- Ausência de tratamento de erro padronizado
- Stack trace exposto ao cliente
- Ausência de paginação em listagens
- Versão da API sem prefixo no path

---

## Artefatos Obrigatórios

- `API_Contract.json` — OpenAPI spec completo
- `Auth_Strategy.md` — mecanismo de autenticação/autorização
- `Test_Plan.md` — testes de contrato, autenticação, paginação
- `Runbook.md` — deploy, rollback, healthcheck
