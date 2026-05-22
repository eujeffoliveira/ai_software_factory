# Checklist — Testing

**Arquétipo:** `automation_script`
**Gate:** A3 (Automation QA)

## Setup

- [ ] `pytest` instalado como dev dependency
- [ ] `conftest.py` com fixtures compartilhadas
- [ ] `respx` ou `pytest-httpx` para mock de chamadas HTTP
- [ ] `pytest --cov` configurado

## Cobertura Mínima

- [ ] Módulos de serviço/negócio: ≥ 80%
- [ ] Módulo de config: validação testada
- [ ] CLI: todos os comandos testados com CliRunner
- [ ] Integrations: mocks em 100% das chamadas externas nos testes

## Cenários Obrigatórios

### Happy Path
- [ ] Input válido → processamento → output correto
- [ ] Run log registrado com `status: "success"`

### Validação de Entrada
- [ ] Campo obrigatório ausente → erro + exit 1
- [ ] Tipo inválido → erro descritivo

### Erros de Integração
- [ ] API 500 → retry 3x → falha com log
- [ ] API 404 → skip + log warning
- [ ] Timeout → retry → falha após N tentativas
- [ ] Payload malformado da API → ValidationError + skip

### Dry-Run
- [ ] Dry-run não altera destino
- [ ] Dry-run produz logs corretos

### Idempotência
- [ ] Executar 2x → mesmo estado final
- [ ] Registro já processado → skip com log

### CLI
- [ ] `--help` retorna 0
- [ ] `--version` retorna versão correta
- [ ] Configuração inválida → exit 1 com mensagem

## Execução

- [ ] `pytest` passa sem warnings
- [ ] `ruff check src/ tests/` sem erros
- [ ] `mypy src/` sem erros (se configurado)
- [ ] CI/CD executa testes automaticamente
