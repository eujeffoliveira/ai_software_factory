# Checklist — Dry Run

**Arquétipo:** `automation_script`
**Gate:** A2 + A3

## Implementação

- [ ] Flag `--dry-run` implementada no CLI
- [ ] Flag `--dry-run` documentada no `--help`
- [ ] Dry-run é o modo padrão em ambientes de desenvolvimento (opcional)

## Comportamento

- [ ] Em dry-run: toda a lógica de processamento executa normalmente
- [ ] Em dry-run: nenhuma escrita ocorre no sistema externo (API, banco, arquivo)
- [ ] Em dry-run: run log NÃO é persistido como execução real
- [ ] Em dry-run: log indica claramente `"dry_run": true` em cada evento
- [ ] Em dry-run: script encerra com exit 0 se não houver erros de lógica

## O que NÃO deve ocorrer em dry-run

- [ ] Nenhuma chamada POST/PUT/DELETE para APIs externas
- [ ] Nenhuma escrita em banco de dados
- [ ] Nenhuma criação/modificação de arquivos de saída
- [ ] Nenhuma notificação enviada (email, Slack, etc.)
- [ ] Estado de idempotência NÃO é atualizado

## Teste

- [ ] Teste automatizado: dry-run + verificar que destino não foi alterado
- [ ] Teste manual: executar `--dry-run` + confirmar ausência de efeitos
- [ ] Teste de log: verificar que `dry_run: true` aparece nos logs
