# Config and Secrets

**Projeto:** [Nome]
**Arquétipo:** `automation_script`
**Versão:** 1.0

---

## Variáveis de Ambiente

| Variável | Tipo | Obrigatória | Descrição | Exemplo |
|----------|------|:-----------:|-----------|---------|
| `API_BASE_URL` | str | S | URL base da API externa | `https://api.exemplo.com` |
| `API_KEY` | SecretStr | S | Chave de autenticação da API | `sk-...` |
| `DATABASE_URL` | SecretStr | N | Connection string do banco | `postgresql://...` |
| `LOG_LEVEL` | str | N | Nível de log (INFO/DEBUG) | `INFO` |
| `DRY_RUN` | bool | N | Ativa modo dry-run | `false` |

---

## `.env.example`

```env
# API Externa
API_BASE_URL=https://api.exemplo.com
API_KEY=your-api-key-here

# Banco de dados (opcional)
# DATABASE_URL=postgresql://user:pass@host/db

# Configuração
LOG_LEVEL=INFO
DRY_RUN=false
```

---

## Config com pydantic-settings

```python
from pydantic import SecretStr, HttpUrl
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")
    
    api_base_url: HttpUrl
    api_key: SecretStr
    database_url: SecretStr | None = None
    log_level: str = "INFO"
    dry_run: bool = False

def get_settings() -> Settings:
    return Settings()
```

---

## Credenciais Externas

| Sistema | Tipo de credencial | Variável | Permissões mínimas | Como obter |
|---------|-------------------|----------|-------------------|-----------|
| [API] | API Key | `API_KEY` | read-only / write | [link/instrução] |
| [DB] | Connection string | `DATABASE_URL` | SELECT, INSERT | DBA |

---

## Regras de Segurança

- [ ] Nenhuma credencial hardcoded no código
- [ ] `.env` está no `.gitignore`
- [ ] `.env.example` não contém valores reais
- [ ] Logs não expõem valores de `SecretStr`
- [ ] Credenciais têm permissões mínimas necessárias
- [ ] Rotação de credenciais documentada (frequência: [mensal/trimestral])
