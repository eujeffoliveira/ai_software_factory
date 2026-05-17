# Product Requirements Document — Scheduling App

**Version:** 1
**Date:** today
**Status:** Done

---

<!-- PROBLEMA: Não há versão semântica, data é "today" (não rastreável), status "Done" não é um valor válido -->

## Overview

<!-- PROBLEMA: Seção não segue a estrutura obrigatória — PRD começa com "Overview" em vez das seções numeradas definidas no template. Várias seções obrigatórias estão ausentes. -->

This document describes the scheduling app. The app should be better than what we have now.

<!-- PROBLEMA: Business Problem vago — "better than what we have now" não descreve um problema específico, não cita evidências, não menciona impacto quantificado. Nenhum stakeholder diria o que é "better". -->

---

## Features

We need the following features:

- Users should be able to login
- Users should be able to book appointments
- Admins should be able to manage stuff
- The system should send notifications
- Reports should be available

<!-- PROBLEMA: "Manage stuff" e "notifications" e "reports" são vagas ao ponto de serem inúteis. Sem user stories, sem benefício. Sem personas definidas. Seção "Objectives" ausente. Seção "Target Users" ausente. -->

---

## User Stories

- As a user, I want to be able to book an appointment
- As an admin, I want to manage users
- As a developer, I want to have a REST API so that the frontend can consume data

<!-- PROBLEMA 1: "As a user" — "user" não é uma persona. Qual tipo de usuário? Com qual objetivo?
     PROBLEMA 2: Histórias sem "so that [benefit]" — incompletas, violam formato INVEST
     PROBLEMA 3: "As a developer, I want a REST API" — tarefa técnica, não é user story. Viola o V do INVEST (não entrega valor ao usuário). REST vs GraphQL é decisão do Arquiteto.
     PROBLEMA 4: Sem IDs (US-NNN), sem prioridade -->

---

## Acceptance Criteria

- The booking should work correctly
- The login should be fast and secure
- Admins should be able to do everything they need

<!-- PROBLEMA 1: "Should work correctly" — não é testável. O que significa "correctly"?
     PROBLEMA 2: "Fast" — vago. Sem métrica (P95 ≤ Xs). Palavra vetada.
     PROBLEMA 3: "Everything they need" — não é um critério, é uma aspiração
     PROBLEMA 4: Nenhum critério usa formato Gherkin (Given/When/Then)
     PROBLEMA 5: Sem happy path, sem cenários negativos, sem edge cases -->

---

## Technical Requirements

- We should use PostgreSQL for the database
- The API should be RESTful
- Authentication via JWT tokens
- Frontend should be in React

<!-- PROBLEMA: Esta seção não deveria existir no PRD. Decisões tecnológicas (PostgreSQL, REST, JWT, React) são do domínio do Arquiteto, não do Product Owner. Incluir isso no PRD contamina os requisitos com decisões de implementação e pode conflitar com o Golden Model. -->

---

## Business Rules

- Users cannot book more than 3 appointments
- Admins have full access
- The system should validate all inputs

<!-- PROBLEMA 1: "Users cannot book more than 3 appointments" — sem fonte. Quem disse isso? Em que janela de tempo? 3 por dia? Por mês? Esta regra foi inventada.
     PROBLEMA 2: "Admins have full access" — não é uma regra de negócio, é uma decisão de autorização. Sem definição do que "full access" significa.
     PROBLEMA 3: "Validate all inputs" — decisão de implementação técnica, não regra de negócio
     PROBLEMA 4: Sem IDs (BR-NNN), sem fontes, sem aplicabilidade -->

---

## Notes

- We should also think about mobile later
- Performance should be fine
- Security is important

<!-- PROBLEMA: "Performance should be fine" e "Security is important" não são NFRs. Sem métricas, sem categorias, sem critérios de aceite. Seção de NFRs ausente por completo.
     PROBLEMA: Seção de Escopo ausente — o que está fora do escopo nunca foi declarado.
     PROBLEMA: Seção de Open Questions ausente — dúvidas em aberto nunca foram registradas.
     PROBLEMA: Seção de Product Risks ausente — nenhum risco identificado.
     PROBLEMA: Handoff Package ausente — não pode ser submetido para Gate 1. -->
