# Bad Acceptance Criteria — Problems Annotated

_Examples of acceptance criteria with common defects. Each problem is annotated._

---

## BAD-AC-001 — Criteria in Prose, Not Gherkin

> **Story:** As a client, I want to book an appointment, so that I can schedule a service visit.

**Acceptance Criteria (WRONG):**
- The booking should work correctly when the user fills in the form.
- The system should send an email to confirm.
- Errors should be shown if the form is wrong.

<!-- PROBLEMA: Nenhum dos três critérios usa formato Gherkin (Given/When/Then). Sem estrutura de cenários.
     PROBLEMA: "Should work correctly" — o que é "correctly"? Não testável.
     PROBLEMA: "An email to confirm" — qual o conteúdo mínimo? Em quanto tempo? Não há métrica.
     PROBLEMA: "If the form is wrong" — o que torna o formulário errado? Quais campos? Qual mensagem de erro?
     PROBLEMA: Nenhum cenário negativo explícito.
     PROBLEMA: Nenhum edge case (e.g., o que acontece se o último slot for tomado durante o preenchimento?).
     RESULTADO: Um QA engineer não consegue escrever um único teste automatizado a partir desses critérios sem adivinhar. -->

**What the correct version looks like (abbreviated):**
```gherkin
Given a client has selected a service, date, and time slot
When the client submits the form with a valid name and email
Then the system creates a confirmed appointment
And sends a confirmation email within 60 seconds
```

---

## BAD-AC-002 — Vague Language That Cannot Be Tested

> **Story:** As a staff member, I want to view my daily schedule, so that I can plan my day.

**Acceptance Criteria (WRONG):**

**AC-002-01:** The schedule should load quickly and be easy to read.

<!-- PROBLEMA: "Quickly" — sem métrica (ex: P95 ≤ 2s). Palavra vetada. Impossível saber se passou ou falhou.
     PROBLEMA: "Easy to read" — subjetivo. Não testável. O que é fácil para uma pessoa pode não ser para outra.
     PROBLEMA: Não há Given clause — sem precondição estabelecida, o teste não pode ser configurado. -->

**AC-002-02:** The user should feel confident that all their appointments are displayed.

<!-- PROBLEMA: "Should feel confident" — emoção subjetiva, impossível de medir ou testar. Um teste automatizado não pode verificar sentimentos.
     PROBLEMA: "All their appointments" — sem definição de "all". Todos do dia? Da semana? Todos os status? Cancelados incluídos?
     PROBLEMA: Novamente, sem formato Gherkin. -->

**AC-002-03:** The system should be secure.

<!-- PROBLEMA: "Be secure" não é um critério de aceite — é uma aspiração. O que especificamente deve ser seguro? Autenticação? Autorização? Criptografia?
     PROBLEMA: Critérios de segurança precisam ser específicos: "unauthenticated access returns HTTP 401 and redirects to login". -->

**What the correct version looks like (abbreviated):**
```gherkin
Given a logged-in staff member with 3 appointments today
When they navigate to the "My Schedule" view without selecting a date
Then all 3 appointments are displayed in chronological order
And the page loads within 2 seconds
```

---

## BAD-AC-003 — Scenarios Without Negative Cases and With Implementation Details

> **Story:** As a client, I want to cancel my appointment, so that I can free the slot without calling.

**Acceptance Criteria (WRONG):**

**AC-003-01:**
```
The client can click the cancel button.
The database record is updated to status=cancelled.
The Redis cache is invalidated.
```

<!-- PROBLEMA: Não está em formato Gherkin. Não tem Given, When, Then.
     PROBLEMA: "The database record is updated" e "The Redis cache is invalidated" — decisões de implementação técnica no PRD. O Product Owner não deve especificar banco de dados, cache, ou qualquer tecnologia. Isso é domínio do Arquiteto.
     PROBLEMA: "Can click the cancel button" — não descreve o resultado observável pelo usuário. O que muda depois de clicar? O que o usuário vê? -->

**AC-003-02:**
```
Happy path: works fine.
```

<!-- PROBLEMA: "Works fine" não é um critério. O que o sistema faz após a cancelação? Status muda? Email é enviado? Slot fica disponível? Cada um desses é um Then clause separado.
     PROBLEMA: Sem cenário negativo — o que acontece se o cliente tentar cancelar dentro das 24 horas? (BR-001 exige rejeição, mas os critérios não cobrem isso.) -->

**What the correct version looks like (abbreviated):**
```gherkin
Given a client has a confirmed appointment 48 hours in the future
When the client confirms the cancellation via the confirmation link
Then the appointment status changes to "Cancelled"
And the slot becomes available within 30 seconds
And the client receives a cancellation confirmation email within 60 seconds
```

```gherkin
Given a client has a confirmed appointment 12 hours in the future
When the client attempts to cancel via the confirmation link
Then the system displays: "Cancellations must be made at least 24 hours in advance."
And the appointment status remains "Confirmed"
```
