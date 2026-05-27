# Checklist — Secrets & Security

**Arquétipo:** `automation_script`
**Gate:** A4 (Security & Secrets Review)

## Código

- [ ] Grep por padrões de token/senha no código: `grep -r "api_key\s*=\s*['\"]" src/` → zero resultados
- [ ] Nenhuma URL com credencial embutida (`https://user:pass@host`)
- [ ] Nenhuma connection string hardcoded
- [ ] `SecretStr` do Pydantic usado para todas as credenciais

## Arquivos

- [ ] `.env` está no `.gitignore`
- [ ] `.env.example` não contém valores reais (apenas placeholders)
- [ ] `git log --all --full-history -- .env` não mostra commits com `.env`
- [ ] Nenhum arquivo de configuração com credencial real foi commitado

## Logs

- [ ] `SecretStr` não é serializado em logs (Pydantic bloqueia automaticamente)
- [ ] Nenhum `str(settings.api_key)` em código de log
- [ ] URLs logadas não contêm tokens no query string

## Permissões

- [ ] Credenciais externas têm permissões mínimas necessárias
- [ ] Credenciais de leitura usadas onde só leitura é necessária
- [ ] Permissões documentadas em `Config_And_Secrets.md`

## Dados Pessoais

- [ ] Dados pessoais (PII) não aparecem em logs
- [ ] Dados pessoais em trânsito usam HTTPS
- [ ] LGPD: base legal documentada para qualquer PII processado

## Rotação

- [ ] Frequência de rotação de credenciais documentada
- [ ] Processo de rotação sem downtime definido
