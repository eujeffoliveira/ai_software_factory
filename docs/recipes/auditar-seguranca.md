# Receita: Auditar Segurança

## Objetivo

Realizar uma auditoria de segurança completa de uma codebase antes de um release importante, identificar e classificar vulnerabilidades, produzir o Security_Audit.md necessário para o Gate 5 e criar um plano de remediação priorizado.

## Quando usar

- Antes de qualquer release em produção (Gate 5 é obrigatório no pipeline da fábrica)
- Após incorporar uma integração com serviço externo novo (pagamentos, autenticação, storage)
- Quando um pesquisador externo reportar uma vulnerabilidade
- Para revisão periódica de segurança (trimestral ou semestral) de sistemas em produção

> Gate 5 (Security Gate) somente pode ser aprovado pelo `@devsecops`.
> O `@techlead` não pode fazer override mesmo com prazo de release.
> Findings classificados como CRITICAL sem mitigação documentada bloqueam Gate 5.

## Agentes envolvidos

| Agente | Papel nesta receita |
|--------|---------------------|
| `@devsecops` | Auditor principal: revisão de código, modelagem de ameaças, revisão de secrets e dependências |
| `@techlead` | Registro de findings no Risk Register, decisão de gate, comunicação com stakeholders |
| `@qa` | (opcional) Implementação de casos de teste de segurança identificados pela auditoria |

## Fluxo de execução

### Etapa 1 — Revisão de controle de acesso e autorização

```
@devsecops Revise o controle de acesso da API deste projeto. Para cada rota
ou Server Action que acessa dados:

1. Existe verificação de autenticação? (getServerSession ou equivalente)
2. Existe verificação de autorização? (usuário tem permissão para este recurso?)
3. Existe risco de IDOR? (um usuário pode manipular um ID na URL/body para
   acessar dados de outro usuário?)

Para cada rota identificada como vulnerável:
- Descreva o cenário de exploração em termos funcionais (sem código de exploit)
- Classifique: CRITICAL (dados de outros usuários expostos), HIGH (escalação de
  privilégio possível), MEDIUM (bypass de feature restrita)
- Proponha a correção específica

Formato de saída: tabela [Rota, Tipo de Risco, Classificação, Correção Proposta].
```

---

### Etapa 2 — Validação de inputs

```
@devsecops Revise a validação de inputs em toda a API:

1. Todos os endpoints têm schema Zod aplicado antes de qualquer lógica de negócio?
2. Existe algum ponto onde dados do request chegam diretamente a uma query
   Prisma sem sanitização? (ex: where: { [campo]: req.body[campo] })
3. Uploads de arquivo: existem? Há validação de tipo MIME e tamanho?
4. Parâmetros de URL ([id], [slug]): são validados como UUID/número antes
   de usar em query? Uma string malformada pode causar erro 500 com stack trace?

Para cada gap encontrado: rota afetada, risco, correção com exemplo de código.
```

---

### Etapa 3 — Exposição de dados sensíveis

```
@devsecops Revise a exposição de dados sensíveis nas respostas da API:

1. Os responses retornam apenas os campos necessários? (princípio do mínimo
   privilégio nos dados — ex: não retornar hashedPassword junto com o perfil)
2. Existe alguma rota que retorna lista sem paginação? (risco de dump de dados)
3. Os erros retornados ao cliente são genéricos ou expõem detalhes internos
   (stack traces, nomes de tabelas, queries SQL)?
4. Existe logging de dados sensíveis? (CPF, cartão de crédito, senhas, tokens
   aparecendo em logs de produção)
5. Headers HTTP: Content-Security-Policy, X-Frame-Options, X-Content-Type-Options
   estão configurados no next.config.ts?

Classifique cada finding e proponha correção.
```

---

### Etapa 4 — Revisão de secrets e configuração

```
@devsecops Revise o gerenciamento de secrets e configuração deste projeto:

1. Secrets hardcoded: existe alguma API key, senha, token ou string de conexão
   diretamente no código-fonte (mesmo em arquivos de configuração não-.env)?
2. .gitignore: .env, .env.local, .env.*.local estão listados?
3. Histórico git: algum commit anterior contém secrets? (se sim, o secret
   deve ser revogado e rotacionado imediatamente — não basta remover do código)
4. Variáveis de ambiente: o projeto usa lib/env.ts (ou equivalente) para
   centralizar e validar env vars? Ou usa process.env espalhado?
5. NEXTAUTH_SECRET: tem entropia suficiente? (mínimo 32 caracteres aleatórios)
6. Banco de dados: a string de conexão não usa conta root/superuser?
7. Chaves de API externas: têm escopos mínimos necessários? (ex: chave Stripe
   com permissão apenas de leitura em ambiente de dev)

Classifique cada finding. Qualquer secret hardcoded é automaticamente CRITICAL.
```

---

### Etapa 5 — Revisão de dependências

```
@devsecops Execute a revisão de dependências vulneráveis:

Para projetos Node.js/Next.js:
Execute: npm audit --audit-level=moderate
Liste todos os findings HIGH e CRITICAL com:
- Pacote afetado e versão atual
- CVE e descrição funcional da vulnerabilidade (sem detalhes de exploit)
- Versão corrigida disponível?
- Workaround se não há versão corrigida
- Impacto real neste projeto (nem toda vulnerabilidade em uma dependência
  transitiva é exploitável no contexto de uso)

Para projetos Python:
Execute: uv audit (ou: pip audit)
Mesma análise acima.

Priorize: CRITICAL → HIGH → MEDIUM. Findings LOW podem ir para backlog.
```

---

### Etapa 6 — Modelagem de ameaças para módulos críticos

Para módulos financeiros, de autenticação ou que lidam com dados pessoais:

```
@devsecops Faça uma modelagem de ameaças simplificada (STRIDE) para o módulo
de pagamentos deste projeto:

Para cada componente do fluxo de pagamento (formulário, API route, integração
Stripe, banco de dados):

S — Spoofing: alguém pode se passar por outro usuário neste ponto?
T — Tampering: alguém pode alterar dados em trânsito ou em repouso?
R — Repudiation: existe log de auditoria suficiente para rastrear ações?
I — Information Disclosure: dados sensíveis podem vazar neste ponto?
D — Denial of Service: este ponto pode ser sobrecarregado sem rate limiting?
E — Elevation of Privilege: alguém pode ganhar mais permissões do que deveria?

Para cada ameaça identificada: classificação (CRITICAL/HIGH/MEDIUM/LOW) e
controle mitigador existente ou proposto.
```

---

### Etapa 7 — Consolidação e Gate 5

```
@devsecops Produza o Security_Audit.md consolidado com:

1. Resumo executivo: N findings CRITICAL, M findings HIGH, P findings MEDIUM/LOW
2. Tabela de findings:
   | ID | Componente | Descrição | Classificação | Status | Responsável |
3. Para cada CRITICAL: descrição do risco, impacto de negócio, correção necessária,
   prazo máximo para resolução
4. Dependências vulneráveis: lista de pacotes e ação necessária
5. Checklist de secrets: resultado da revisão
6. Decisão de Gate 5:
   - APPROVED: nenhum CRITICAL sem mitigação documentada, HIGHs com plano definido
   - BLOCKED_SECURITY: lista exata do que impede aprovação

Lembre: CRITICAL sem mitigação = Gate 5 bloqueado. Não há exceção.
```

```
@techlead Com base no Security_Audit.md do @devsecops, atualize o Risk Register
do projeto com os findings de segurança:

Para cada CRITICAL e HIGH:
- RISK-ID único (ex: RISK-001)
- Descrição do risco
- Probabilidade (Alta/Média/Baixa) e Impacto (Alto/Médio/Baixo)
- Mitigação: o que está sendo feito para endereçar
- Owner: quem é responsável pela correção
- Prazo: data limite para resolução

Um Risk Register desatualizado é evidência de processo falho.
```

## Artefatos esperados

- `Security_Audit.md` — findings consolidados, classificações, status de mitigação, decisão de Gate 5
- `Risk_Register.md` (atualizado) — todos os risks CRITICAL e HIGH formalmente registrados
- Casos de teste de segurança (se `@qa` for envolvido) — ver receita `gerar-plano-de-testes.md`
- Plano de remediação — lista priorizada de correções com owners e prazos

## Gates envolvidos

| Gate | Responsável | Critério de aprovação |
|------|-------------|----------------------|
| 5 | `@devsecops` (exclusivo) | Security_Audit.md entregue; zero findings CRITICAL sem mitigação; HIGHs com plano documentado |

**Regras invioláveis do Gate 5:**
- Somente o `@devsecops` aprova Gate 5
- O `@techlead` não pode fazer override, mesmo com prazo de release
- Findings CRITICAL sem mitigação documentada = gate bloqueado, sem exceção
- Um finding CRITICAL não significa que o release é impossível — significa que a mitigação precisa estar documentada e aprovada pelo `@devsecops` antes de prosseguir

## Comandos de validação

```powershell
# Saúde da fábrica e dependências do MCP
.\doctor.ps1

# Verificar que @devsecops tem knowledge base de segurança
.\test-mcp.ps1
```

```bash
# Para projetos Node.js
npm audit --audit-level=high

# Para projetos Python
uv audit
# ou: pip install pip-audit && pip-audit

# Verificar se há secrets em arquivos rastreados pelo git
# (use ferramenta especializada — não faça grep manual em CI)
# Recomendado: truffleHog, gitleaks, git-secrets
```

```powershell
# Verificar configuração de headers de segurança (se Next.js)
# Após deploy em staging, verificar com:
# curl -I https://seu-projeto.vercel.app | Select-String "Content-Security|X-Frame|X-Content"

# Verificar que .env não está rastreado
git ls-files --error-unmatch .env 2>&1
# Se retornar erro: .env NÃO está rastreado (correto)
# Se não retornar erro: .env ESTÁ rastreado (problema)
```

```
# Em sessão Claude Code — verificar conhecimento do agente:
# @devsecops search_knowledge("OWASP Top 10")
# @devsecops search_knowledge("secrets management")
# @devsecops search_knowledge("STRIDE threat modeling")
```

## Próximos passos

Após Gate 5 aprovado:

1. **Rotação de secrets expostos**: qualquer secret que tenha sido encontrado hardcoded ou em histórico git deve ser revogado e rotacionado — independente do Gate 5 ter sido aprovado com mitigação
2. **CI automatizado**: configurar `npm audit` ou `uv audit` como etapa obrigatória no pipeline CI (falha se houver HIGH/CRITICAL)
3. **Revisão periódica**: agendar próxima auditoria — trimestral para sistemas com dados sensíveis, semestral para sistemas internos
4. **Findings MEDIUM/LOW**: não bloqueiam Gate 5 mas devem ir para o backlog com owner e prazo definidos
5. **Monitoramento contínuo**: considerar ferramentas como Dependabot (GitHub) ou Renovate para alertas automáticos de dependências vulneráveis
6. **Treinamento**: findings recorrentes (ex: falta de Zod em múltiplas rotas) são sinal de gap de conhecimento no time — considerar sessão de revisão de boas práticas
