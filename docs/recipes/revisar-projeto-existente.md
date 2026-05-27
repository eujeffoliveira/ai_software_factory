# Receita: Revisar um Projeto Existente

## Objetivo

Incorporar um projeto já existente ao fluxo da fábrica: classificar o arquétipo, identificar desvios do Golden Model correspondente, mapear dívida técnica, avaliar cobertura de testes e auditar segurança. O resultado é um plano de ação priorizado para trazer o projeto para conformidade progressiva.

## Quando usar

- Você herdou um projeto em produção e precisa entender o que está fora do padrão
- Um time externo entregou código e você quer validar antes de assumir a manutenção
- O projeto existia antes da fábrica e precisa ser "onboardado" sem parar tudo
- Você quer descobrir quais ADRs seriam necessárias para o estado atual do código

> Esta receita não segue o fluxo sequencial Gate 1 → 2 → 3... dos projetos novos.
> Para projetos existentes, os agentes trabalham em **modo de avaliação paralela**
> e produzem um relatório consolidado antes de qualquer gate formal.

## Agentes envolvidos

| Agente | Papel nesta receita |
|--------|---------------------|
| `@techlead` | Classificação do arquétipo, registro de gaps, decisão sobre gates retroativos |
| `@architect` | Revisão de arquitetura vs. Golden Model, identificação de desvios e dívida técnica |
| `@qa` | Avaliação de cobertura de testes, identificação de gaps críticos |
| `@devsecops` | Auditoria de segurança, OWASP Top 10, revisão de secrets e dependências |
| `@engineer` | (opcional) Estimativa de esforço para remediar os gaps encontrados |
| `@po` | (opcional) Reescrever PRD retroativo se requisitos não estiverem documentados |

## Fluxo de execução

> **Antes de começar**: certifique-se de ter acesso ao código-fonte, ao README atual
> (mesmo que desatualizado) e idealmente ao histórico de decisões técnicas (issues,
> PRs, documentação). Compartilhe com os agentes via contexto de sessão.

### Etapa 1 — Classificação e mapa de gaps (Gate A0 retroativo)

```
@techlead Analise este projeto existente e:
1. Classifique o arquétipo (web_app, automation_script, data_pipeline, api_service,
   cli_tool, mcp_server, integration_worker, notebook_analysis)
2. Identifique o Golden Model correspondente
3. Liste os 5 maiores desvios observados à primeira vista
4. Determine quais gates (1–7) este projeto já satisfaz implicitamente e quais
   precisam ser formalizados

Contexto do projeto: [descreva aqui — stack atual, função, ambiente de produção]
```

Resultado esperado: classificação A0 + lista inicial de gaps para guiar
as revisões paralelas das etapas seguintes.

---

### Etapa 2 — Revisão de arquitetura (paralela)

```
@architect Revise a arquitetura atual deste projeto em relação ao Golden Model
[arquétipo identificado no Gate A0]. Produza três listas:

(A) DESVIOS QUE PRECISAM DE ADR:
    Para cada desvio: o que é, por que é um desvio, ADR proposto.
    Exemplo: "Usa Drizzle em vez de Prisma — ADR-001: justificar escolha de ORM"

(B) DÍVIDA TÉCNICA CRÍTICA (bloqueia evoluções futuras):
    Itens que, se não corrigidos, causarão problemas graves em 6–12 meses.
    Prioridade: P1 (corrigir esta sprint), P2 (próxima sprint), P3 (backlog)

(C) QUICK WINS (melhorias sem breaking changes):
    O que pode ser melhorado sem refatoração maior.
    Exemplos: adicionar Zod em uma rota não validada, extrair constante hardcoded.

Não proponha reescritas completas — o objetivo é melhoria progressiva.
```

---

### Etapa 3 — Avaliação de cobertura de testes (paralela)

```
@qa Avalie a cobertura de testes atual deste projeto:

1. Mapeamento do que existe:
   - Testes unitários: quais módulos têm testes? Qual framework?
   - Testes de integração: existem? Quais fluxos cobrem?
   - Testes E2E: existem? Cobrem o fluxo principal?

2. Gaps críticos (ordenados por risco):
   - Quais módulos/fluxos sem nenhum teste têm maior impacto se quebrarem?
   - Existe alguma função crítica de negócio completamente sem cobertura?

3. Plano de melhoria progressiva (não precisa chegar a 80% de uma vez):
   Sprint 1: quais testes adicionariam mais valor com menos esforço?
   Sprint 2–3: quais testes são importantes mas mais complexos de implementar?
   Sprint 4+: cobertura completa do fluxo principal

Seja específico: "a função calculateDiscount em lib/pricing.ts não tem nenhum teste"
é mais útil que "cobertura de testes está baixa".
```

---

### Etapa 4 — Auditoria de segurança (paralela)

```
@devsecops Faça uma revisão de segurança deste projeto existente com foco em:

1. Controle de acesso e autorização:
   - As rotas da API verificam se o usuário autenticado tem permissão?
   - Existe risco de um usuário acessar dados de outro (IDOR)?

2. Validação de inputs:
   - Os dados de entrada (formulários, query params, corpo de requisição) são
     validados antes de chegar ao banco de dados?

3. Exposição de dados sensíveis:
   - Alguma resposta de API retorna mais dados do que o cliente precisa?
   - Campos sensíveis (senhas, tokens, CPF) estão sendo filtrados nas respostas?

4. Secrets e configuração:
   - Existem credenciais hardcoded no código (API keys, senhas, tokens)?
   - O .gitignore cobre todos os arquivos com secrets?
   - Os logs estão imprimindo valores sensíveis?

5. Dependências:
   - Rode npm audit (ou pip audit/uv audit) e liste findings HIGH/CRITICAL

Classifique cada finding: CRITICAL, HIGH, MEDIUM, LOW.
CRITICAL = precisa corrigir antes do próximo deploy.
```

---

### Etapa 5 — Consolidação e priorização

```
@techlead Consolide os resultados das revisões paralelas (arquitetura, testes,
segurança) em um plano de ação priorizado:

1. BLOQUEADORES (impede evoluções até resolver):
   Lista de items CRITICAL de segurança ou dívida P1 de arquitetura

2. AÇÕES DO PRÓXIMO SPRINT:
   Lista de ADRs a escrever, quick wins de arquitetura, testes prioritários,
   findings HIGH de segurança

3. BACKLOG DE MÉDIO PRAZO (4–8 semanas):
   Restante dos gaps de arquitetura, cobertura de testes progressiva,
   findings MEDIUM de segurança

4. DECISÃO DE GATE RETROATIVO:
   O projeto pode receber aprovação implícita nos Gates 1–3 com base no estado
   atual? Ou precisa passar formalmente por algum gate antes do próximo deploy?

Formato de saída: tabela com colunas [Item, Tipo, Prioridade, Responsável, Sprint].
```

---

### Etapa 6 — Documentação retroativa (opcional, se não existe)

Se o projeto não tiver PRD nem Architecture.md documentados:

```
@po Com base no código existente e no que você entende do negócio, escreva um
PRD retroativo para este projeto. O objetivo não é reescrever os requisitos do
zero, mas documentar o que o sistema faz hoje de forma que a equipe possa usar
como base para evoluções futuras. Inclua: objetivo do produto, usuários,
funcionalidades principais, non-goals.
```

```
@architect Com base no código existente, escreva o Architecture.md atual
(estado real, não o ideal). Documente: stack completa, modelo de dados real,
decisões técnicas conhecidas. Inclua uma seção "Desvios do Golden Model"
com os ADRs que precisariam ser escritos para formalizar essas escolhas.
```

---

### Etapa 7 — Estimativa de remediação (opcional)

```
@engineer Com base no plano de ação consolidado pelo @techlead, estime o
esforço para remediar cada item em story points. Identifique quais remediações
têm dependências entre si (ex: "não dá para aumentar cobertura de testes sem
antes refatorar X"). Sugira uma ordem de execução que minimize retrabalho.
```

## Artefatos esperados

- `Gap_Analysis.md` — desvios do Golden Model, dívida técnica, classificação por prioridade
- `ADR_Backlog.md` — lista de ADRs a escrever para formalizar decisões existentes
- `Security_Findings.md` — findings de segurança com severidade e status
- `Test_Coverage_Assessment.md` — estado atual da cobertura, gaps críticos, plano de melhoria
- `Action_Plan.md` — plano priorizado com responsável e sprint estimado
- `Architecture.md` (retroativo, se não existia)
- `PRD.md` (retroativo, se não existia)

## Gates envolvidos

Para projetos existentes, os gates funcionam diferente:

| Situação | Abordagem |
|----------|-----------|
| Projeto em produção estável | Gates 1–3 podem ser aprovados implicitamente após documentação retroativa |
| Próximo deploy planejado | Gate 5 (segurança) deve ser passado antes do próximo deploy se houver findings CRITICAL |
| Refatoração maior planejada | Passar Gate 2 formalmente antes de começar (Architecture.md com ADRs aprovados) |
| Novo feature no projeto existente | Reiniciar Gate 1 apenas para o escopo do novo feature |

> Findings CRITICAL de segurança bloqueiam o próximo deploy independente do
> histórico do projeto. Gate 5 não tem exceção.

## Comandos de validação

```powershell
# Verificar saúde da fábrica
.\doctor.ps1

# Verificar MCP Knowledge Search
.\test-mcp.ps1
```

```powershell
# Para projetos web (Next.js):
npm audit --audit-level=high
npx tsc --noEmit              # verificar erros TypeScript
npx eslint . --max-warnings 0  # verificar linting

# Para projetos Python:
uv audit           # ou: pip audit
mypy src/          # verificar tipos
ruff check src/    # verificar linting
```

```powershell
# Verificar se há secrets no histórico git (ferramenta externa recomendada)
# Instalar truffleHog ou git-secrets se disponível:
# git log --all -p | grep -i "api_key\|password\|secret\|token" | head -20
```

```
# Em sessão Claude Code — verificar que os agentes têm conhecimento para revisão:
# @architect search_knowledge("Gap Analysis Golden Model")
# @devsecops search_knowledge("OWASP Top 10 checklist")
# @qa search_knowledge("test coverage assessment")
```

## Próximos passos

Após concluir a análise e ter o plano de ação:

1. **Priorizar bloqueadores**: resolver findings CRITICAL de segurança antes do próximo deploy
2. **Escrever ADRs pendentes**: formalizar decisões técnicas existentes — sem ADR aprovado, Gate 2 não pode ser reaberto
3. **Testes primeiro**: antes de refatorar qualquer módulo, adicionar testes para o comportamento atual (testes de caracterização)
4. **Iterar nos gates**: para cada novo feature, seguir o fluxo normal Gates 1–7 da receita `criar-web-app.md` (ou o equivalente para o arquétipo)
5. **Revisar em 30 dias**: verificar se os quick wins foram implementados e se os bloqueadores foram resolvidos
