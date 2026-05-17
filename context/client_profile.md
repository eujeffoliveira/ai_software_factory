# Client Profile — AI Software Factory
> Preencha este arquivo antes de executar `context/prompts/instantiation_prompt.md`.
> Este é o único arquivo que você precisa editar para instanciar a fábrica no contexto da sua organização.
> Após preencher, **não renomeie nem mova este arquivo** — o prompt de instanciação espera ele aqui.

---

## 1. Identidade da Organização

| Campo | Valor |
|---|---|
| `organization_name` | Nome completo da organização |
| `organization_short_name` | Sigla ou nome curto (usado em comentários e IDs) |
| `organization_type` | `edtech` / `fintech` / `healthtech` / `saas` / `enterprise` / `outro` |
| `primary_language` | `pt-BR` / `en-US` |
| `domain` | Domínio principal de negócio (ex: educação, finanças, saúde, varejo) |
| `internal_systems_name` | Como os sistemas internos são chamados (ex: "sistemas Raiz", "plataforma interna") |

**Notas de contexto de negócio:**
> Descreva aqui (em 2–5 linhas) o que a organização faz, o perfil de usuário dos sistemas e qualquer contexto
> que os agentes devem considerar ao tomar decisões técnicas ou de produto.

```
[PREENCHA AQUI]
```

---

## 2. Design System & Identidade Visual

| Campo | Valor |
|---|---|
| `brand_primary_color` | Cor primária em hex (ex: `#ef7916`) |
| `brand_secondary_color` | Cor secundária em hex (ex: `#7dcdbb`) |
| `dark_mode_default` | `dark` / `light` / `system` |
| `component_library` | `tailwind-only` / `shadcn` / `chakra` / `mui` / `outro` |

**Tokens adicionais (opcional):**
> Liste outros tokens de design relevantes (cores de status, tipografia, raios de borda, etc.)

```
[PREENCHA OU DEIXE EM BRANCO]
```

---

## 3. Golden Model — Stack Tecnológica

> Preencha apenas os campos que **divergem** do Golden Path padrão.
> O Golden Path padrão (genérico) é: Next.js 16 · React 19 · TypeScript 5 · Tailwind CSS v4 ·
> PostgreSQL via Supabase · Prisma 7 · Vercel · NextAuth v5 + Google OAuth · Zod · Vitest · Playwright · Recharts v3.

| Campo | Valor padrão (genérico) | Valor nesta organização |
|---|---|---|
| `auth_provider` | `google-oauth` | |
| `auth_additional_providers` | nenhum | ex: `microsoft-entra`, `github` |
| `database_host` | `supabase` | |
| `deploy_platform` | `vercel` | |
| `email_provider` | `aws-ses + nodemailer` | |
| `apm_tool` | nenhum definido | ex: `sentry`, `datadog`, `opentelemetry` |
| `cron_platform` | `vercel-cron` | |
| `chart_library` | `recharts-v3` | |
| `extra_packages` | nenhum | Liste pacotes adicionais aprovados |

**ADRs pré-aprovados (desvios já decididos):**
> Se a organização já tem decisões arquiteturais registradas que divergem do Golden Path, liste-as aqui
> para que os agentes as tratem como restrições, não como sugestões.

```
[PREENCHA OU DEIXE EM BRANCO]
```

---

## 4. Integrações Externas

> Liste os sistemas externos com os quais os projetos desta organização tipicamente se integram.
> Os agentes usam esta lista para identificar quando um ADR é necessário e para aplicar
> padrões de integração corretos (workers dedicados, filas, etc.).

| Nome do Sistema | Tipo | Protocolo | Notas |
|---|---|---|---|
| | `erp` / `crm` / `lms` / `idp` / `api-rest` / `webhook` / `ftp` / `outro` | REST / SOAP / SFTP / etc. | |

---

## 5. Contexto Regulatório

| Campo | Valor |
|---|---|
| `lgpd_compliance` | `true` / `false` |
| `other_frameworks` | Outros frameworks regulatórios (ex: `FERPA`, `ISO 27001`, `SOC2`, `HIPAA`) |
| `sensitive_data_categories` | Tipos de dados sensíveis presentes (ex: `CPF, dados escolares, dados financeiros`) |

**Regras específicas de privacidade (opcional):**
> Descreva restrições ou requisitos de privacidade além do padrão LGPD que os agentes devem respeitar.

```
[PREENCHA OU DEIXE EM BRANCO]
```

---

## 6. Agentes Ativos

> Marque `true` apenas para os agentes que devem ser instanciados neste contexto.
> Agentes marcados como `false` serão ignorados pelo prompt de instanciação.

| Agente | Ativo |
|---|---|
| `Agente00_TechLead` | `true` |
| `Agente01_ProductOwner` | `true` |
| `Agente02_SoftwareArchitect` | `true` |
| `Agente03_SoftwareEngineer` | `true` |
| `Agente04_DevBackend` | `true` |
| `Agente05_DevFrontend` | `true` |
| `Agente06_QaEngineer` | `true` |
| `Agente07_DevSecOps` | `true` |
| `Agente08_DevOps` | `true` |
| `Agente09_UxUiDesigner` | `false` |
| `Agente10_DataIntegrationEngineer` | `false` |

---

## 7. Notas Adicionais

> Use esta seção para qualquer informação que não se encaixe nas seções anteriores mas que seja relevante
> para os agentes: processos internos específicos, nomenclatura institucional, padrões de aprovação,
> restrições operacionais, contexto histórico do time, etc.

```
[PREENCHA OU DEIXE EM BRANCO]
```
