# Receita: Adicionar Novo Conhecimento à Fábrica

## Objetivo

Incorporar novo material de referência (livro técnico, artigo, curso, documentação oficial) ao conhecimento de um agente específico, seguindo o workflow de destilação de 27 etapas, atualizando o MCP Knowledge Search e verificando que o conteúdo está acessível em runtime.

## Quando usar

- Você encontrou um livro ou artigo que contém padrões úteis não cobertos pelos agentes
- Um curso foi concluído e o conteúdo deve ser incorporado ao agente responsável
- Uma nova versão de um framework mudou práticas e as decisões dos agentes precisam refletir isso
- O `@qa` está ignorando uma técnica de teste que existe em um livro que você tem

> Esta é a receita mais "meta" da fábrica: usando a fábrica para melhorar ela mesma.
> Após a destilação, os agentes passam a usar o novo conhecimento automaticamente
> em todas as sessões futuras.

## Agentes envolvidos

Nesta receita, os agentes participam mais como **ferramentas de verificação** do
que como executores — a destilação em si é feita pelo humano seguindo o workflow:

| Agente | Papel nesta receita |
|--------|---------------------|
| Nenhum agente específico | A destilação usa o AI diretamente (novo contexto), não agentes com roles |
| `@techlead` | Verificação pós-destilação: buscar o novo conteúdo via MCP, validar qualidade |
| `@qa` (ou agente-alvo) | Teste prático: usar o agente em uma tarefa que exercite o novo conhecimento |

## Fluxo de execução

### Etapa 1 — Preparação e verificação de licença

Antes de iniciar a destilação, responda estas perguntas:

**Sobre a fonte:**
- [ ] Qual é o título, autor e ano da publicação?
- [ ] Qual agente deve receber este conhecimento?
  (ver `docs/AGENTS.md` para a lista de agentes e seus domínios)
- [ ] Quais seções são mais relevantes para o papel do agente?

**Sobre direitos:**
- [ ] Você tem acesso legítimo ao material (comprou, tem acesso via biblioteca, é gratuito)?
- [ ] O material permite síntese/derivados? (a maioria dos livros técnicos permite desde que você não reproduza verbatim)
- [ ] A fábrica usa licença CC BY 4.0 para artefatos de conhecimento — você está contribuindo com síntese original, não cópia

> Nunca copie parágrafos inteiros de obras protegidas por copyright.
> Destile: extraia princípios, heurísticas e regras com suas próprias palavras.
> Cite a fonte — isso é esperado e necessário.

---

### Etapa 2 — Leitura e marcação prévia

Antes de abrir o workflow de destilação, faça uma leitura rápida do material:

1. Identifique os 5–10 conceitos mais importantes que o agente-alvo não cobre hoje
2. Marque seções com:
   - **P** — seria um novo Princípio (P-N)
   - **H** — seria uma nova Heurística (H-N)
   - **DR** — seria uma nova Decision Rule (DR-NNN)
   - **Card** — seria um novo Knowledge Card
3. Verifique o `source_map.json` do agente para confirmar que esta fonte não foi destilada antes

```powershell
# Verificar source_map do agente-alvo (exemplo: Agente06_QaEngineer)
Get-Content "C:\Projetos\Pessoal\ai_software_factory\Agente06_QaEngineer\knowledge\source_map.json"
```

---

### Etapa 3 — Executar o workflow de destilação (27 etapas)

Abra o prompt padrão de destilação em uma **nova sessão** (não nesta):

```
Abra: context/prompts/prompt_padrao_destilacao_conhecimento.md
```

O workflow de 27 etapas guia você por:
- Leitura estruturada do material
- Extração de princípios (o que sempre é verdade)
- Extração de heurísticas (o que é verdade na maioria dos casos)
- Extração de decision rules (se X então Y)
- Criação de knowledge cards (conceitos reutilizáveis)
- Integração nos arquivos existentes do agente
- Atualização do source_map.json

> Execute o workflow em uma sessão dedicada, com o material em contexto.
> Não misture destilação com outras tarefas — foco total melhora a qualidade.

**Exemplo de prompt para iniciar a destilação:**

```
Vou destilar o conteúdo do livro "Software Testing: A Craftsman's Approach"
(Paul C. Jorgensen, 4ª edição) para o agente Agente06_QaEngineer da fábrica.

Capítulos relevantes: 7 (Structural Testing), 8 (Data Flow Testing),
12 (Mutation Testing).

Siga o workflow de destilação de 27 etapas em
context/prompts/prompt_padrao_destilacao_conhecimento.md.

O agente-alvo é Agente06_QaEngineer. Os arquivos a atualizar são:
- Agente06_QaEngineer/knowledge/principles.md
- Agente06_QaEngineer/knowledge/heuristics.md
- Agente06_QaEngineer/knowledge/decision_rules.md
- Agente06_QaEngineer/knowledge/knowledge_cards.md
- Agente06_QaEngineer/knowledge/source_map.json
```

---

### Etapa 4 — Revisar os artefatos gerados

Após a destilação, revise cada arquivo modificado:

**principles.md** — novos princípios devem:
- [ ] Ter ID único sequencial (P-N, continuando da numeração existente)
- [ ] Ser expressos como afirmações universais ("sempre", "nunca")
- [ ] Ser realmente novos (não duplicar princípios existentes)
- [ ] Ter fonte citada ao final

**heuristics.md** — novas heurísticas devem:
- [ ] Ter ID único sequencial (H-N)
- [ ] Ser expressos como regras que se aplicam "na maioria dos casos"
- [ ] Incluir quando NÃO aplicar (contraponto)

**decision_rules.md** — novas decision rules devem:
- [ ] Ter ID único sequencial (DR-NNN, zero-padded)
- [ ] Seguir o formato "SE [condição] ENTÃO [ação]"
- [ ] Ter gatilho claro e ação específica

**knowledge_cards.md** — novos cards devem:
- [ ] Ter ID único sequencial (Card NNN)
- [ ] Ser auto-suficientes (explicam o conceito sem precisar de contexto externo)
- [ ] Ter exemplos concretos quando relevante

**source_map.json** — deve incluir:
- [ ] ID da fonte (ex: "jorgensen_testing_2014")
- [ ] Título, autor, ano
- [ ] Capítulos/seções mapeados para cada artefato gerado

---

### Etapa 5 — Atualizar a base de conhecimento (MCP)

Se apenas arquivos de `knowledge/` foram modificados (sem alteração em `prompt.md`):

```powershell
# Reindexar apenas o knowledge.db (mais rápido que install.ps1 completo)
.\update-knowledge.ps1
```

Se `prompt.md` de algum agente foi modificado:

```powershell
# Regenerar os arquivos de agente E reindexar
.\install.ps1
```

> Quando em dúvida, use `.\install.ps1` — é idempotente e seguro rodar novamente.

---

### Etapa 6 — Verificar indexação via MCP

Em uma sessão Claude Code, verifique que o novo conteúdo está acessível:

```
# Verificar estatísticas do banco (contagem deve ter aumentado)
@techlead knowledge_stats()

# Buscar por palavra-chave do novo conteúdo
# (substitua pelo termo que você adicionou)
@qa search_knowledge("mutation testing")
@qa search_knowledge("data flow testing")

# Verificar que o agente-alvo encontra o conteúdo
# (use um termo específico do material destilado)
@qa search_knowledge("boundary value analysis")
```

Se a busca retornar resultados com os novos conteúdos: destilação bem-sucedida.

Se não retornar:
1. Verificar se `update-knowledge.ps1` rodou sem erros
2. Verificar se os arquivos foram salvos no diretório correto do agente
3. Rodar `.\test-mcp.ps1` para diagnóstico completo

---

### Etapa 7 — Teste prático com o agente

O melhor teste é usar o agente em uma tarefa real que exercite o novo conhecimento:

```
# Exemplo: se você adicionou conteúdo sobre mutation testing ao @qa
@qa Implemente testes de mutação com Stryker para a função calculateDiscount
em lib/pricing.ts. Use as técnicas de mutation testing para validar a qualidade
dos testes existentes.
```

Se o agente usar corretamente o novo conceito e citar as técnicas do material
destilado: o conhecimento foi incorporado com sucesso.

Se o agente ainda não usar o novo conteúdo:
1. Verificar se o `install.ps1` propagou o conhecimento para `~/.claude/agents/`
2. Reiniciar a sessão Claude Code (os agentes são carregados na inicialização)

---

### Etapa 8 — Comprometer as mudanças

```powershell
# Verificar o que foi modificado
git status
git diff Agente06_QaEngineer/knowledge/
```

```powershell
# Adicionar apenas os arquivos de conhecimento (não commits parciais)
git add Agente06_QaEngineer/knowledge/principles.md
git add Agente06_QaEngineer/knowledge/heuristics.md
git add Agente06_QaEngineer/knowledge/decision_rules.md
git add Agente06_QaEngineer/knowledge/knowledge_cards.md
git add Agente06_QaEngineer/knowledge/source_map.json

# Mensagem de commit seguindo o padrão do repositório
git commit -m "feat(Agente06): distil Software Testing Craftsman's Approach (ch.7-8-12)"
```

> Nunca commitar `knowledge.db` (gitignored) — é gerado localmente.
> Nunca commitar arquivos de `lib/` (gitignored) — são as fontes originais.

## Artefatos esperados

- Novos itens em `AgenteXX_*/knowledge/principles.md` — princípios com ID sequencial
- Novos itens em `AgenteXX_*/knowledge/heuristics.md` — heurísticas com ID sequencial
- Novos itens em `AgenteXX_*/knowledge/decision_rules.md` — regras DR-NNN
- Novos itens em `AgenteXX_*/knowledge/knowledge_cards.md` — cards com ID sequencial
- Entrada nova em `AgenteXX_*/knowledge/source_map.json` — rastreabilidade da fonte
- `knowledge.db` reindexado (não commitado — gerado localmente)

## Gates envolvidos

Esta receita não passa pelos gates normais do pipeline (A0–7), pois não está
construindo software para um cliente — está melhorando a fábrica em si.

A única validação formal é:

| Verificação | Critério |
|-------------|----------|
| MCP indexado | `knowledge_stats()` mostra contagem maior que antes |
| Busca funciona | `search_knowledge("termo do novo conteúdo")` retorna resultados |
| Agente usa o conhecimento | Teste prático com tarefa real retorna resposta incorporando o novo material |
| Licença OK | Apenas síntese original — sem reprodução verbatim de obra protegida |

## Comandos de validação

```powershell
# Verificar saúde completa do MCP
.\doctor.ps1

# Verificar contagem de documentos antes e depois
.\test-mcp.ps1
```

```powershell
# Comparar contagem de documentos antes e depois da destilação
# (anote o número antes de começar, compare após update-knowledge.ps1)
# O test-mcp.ps1 exibe: "Total documents indexed: N"
```

```powershell
# Verificar que os arquivos foram modificados com a data correta
Get-Item "Agente06_QaEngineer\knowledge\*.md" | Select-Object Name, LastWriteTime

# Verificar que source_map foi atualizado
Get-Content "Agente06_QaEngineer\knowledge\source_map.json" | ConvertFrom-Json | Select-Object sources
```

## Dicas para uma boa destilação

**O que faz uma destilação de qualidade:**
- Princípios expressos como afirmações atemporais, não como tutoriais
- Heurísticas com contraponto explícito ("exceto quando...")
- Decision rules com condição testável e ação específica
- Knowledge cards auto-suficientes (alguém que não leu o livro entende o card)
- Fonte citada com granularidade (capítulo/seção, não apenas o título)

**O que evitar:**
- Copiar listas de tópicos sem destilação real
- Princípios vagos ("sempre fazer testes de qualidade")
- Duplicar conteúdo já existente com palavras diferentes
- Adicionar conteúdo fora do domínio do agente-alvo
  (ex: conteúdo de segurança no agente de QA)

**Tamanho razoável por sessão de destilação:**
- 3–5 princípios novos
- 3–5 heurísticas novas
- 5–10 decision rules novas
- 2–4 knowledge cards novos

Mais que isso em uma sessão geralmente indica destilação superficial.

## Próximos passos

Após a destilação ser verificada:

1. **Documentar no lib/STATUS_DOWNLOADS.md**: se o livro foi adicionado à pasta `lib/`, atualize o status da entrada correspondente para ✅
2. **Compartilhar com o time**: se você está trabalhando em equipe, criar um PR com os arquivos de knowledge para revisão antes de merge
3. **Avaliar outros agentes**: o mesmo material pode ser relevante para mais de um agente — por exemplo, um livro sobre arquitetura pode enriquecer tanto `@architect` quanto `@techlead`
4. **Testar em produção**: use o agente enriquecido em um projeto real e observe se as novas regras de decisão aparecem naturalmente nas respostas
5. **Iteração**: a destilação raramente é perfeita na primeira vez — após usar o agente, você pode refinar os princípios e heurísticas com base no que funcionou e no que não funcionou
