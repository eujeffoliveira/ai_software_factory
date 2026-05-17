# Good Open Questions — Examples

_Four well-formed open questions (OQ-001 to OQ-004) demonstrating correct structure, criticality assignment, impact description, and owner identification._

---

## Open Questions Register — Appointment Management System

**Last Updated:** 2026-05-17
**Total Open:** 4
**Blocking Count:** 1

---

### OQ-001 — SMS Notification Support

| Field | Value |
|---|---|
| **ID** | OQ-001 |
| **Question** | Should the system send SMS notifications (booking confirmation, reminder, cancellation) in addition to email notifications for v1, or is email-only sufficient for the initial release? |
| **Impact** | Affects NFR-PERF and integration scope: SMS requires a third-party provider integration (e.g., a messaging API), adds a new NFR category (delivery SLAs for SMS), and increases development scope. If SMS is required for v1, Scope_Boundary.md must be updated and the notification feature estimate increases. |
| **Criticality** | HIGH |
| **Owner** | Operations Manager |
| **Deadline** | 2026-05-24 |
| **Status** | Open |

**Why this is well-formed:**
- Question is specific and answerable with yes/no + rationale
- Impact describes exactly which artifacts change (NFR section, scope boundary, estimate)
- Criticality HIGH is justified — it affects integration scope and NFRs meaningfully, but does not prevent the core booking stories from being specified
- Owner is identified as Operations Manager — the person who can decide on client communication preferences

---

### OQ-002 — Cancellation Window Exception

| Field | Value |
|---|---|
| **ID** | OQ-002 |
| **Question** | Can the business override the 24-hour cancellation window for specific clients (e.g., premium clients or clients with documented emergencies), or is the rule strictly enforced without exceptions? |
| **Impact** | If exceptions exist, BR-001 must be updated to include the exception conditions, a new user story may be needed for administrators to process exception cancellations, and the acceptance criteria for US-003 must include the exception scenario. If no exceptions, BR-001 is confirmed as-is and US-003 acceptance criteria are final. |
| **Criticality** | BLOCKING |
| **Owner** | Business Owner |
| **Deadline** | 2026-05-20 |
| **Status** | Open |

**Why this is well-formed:**
- BLOCKING criticality is justified: BR-001 cannot be finalized until this is answered — it may add a story and modify acceptance criteria
- Impact is specific: describes the exact artifacts (BR-001, a new story, AC-003 updates) that change depending on the answer
- Deadline is earlier than OQ-001 because it is BLOCKING
- Owner is Business Owner — the person who sets cancellation policy, not a technical role

---

### OQ-003 — Maximum Appointments per Client

| Field | Value |
|---|---|
| **ID** | OQ-003 |
| **Question** | Is there a limit on the number of appointments a single client can book within a rolling 30-day window? If yes, what is the limit? |
| **Impact** | If a limit exists, it becomes BR-NNN with source, and AC-001 must include a negative scenario for exceeding the limit. If no limit, no change to current PRD. This question does not block any existing story from being specified. |
| **Criticality** | MEDIUM |
| **Owner** | Business Owner |
| **Deadline** | — |
| **Status** | Open |

**Why this is well-formed:**
- MEDIUM criticality is correct: the answer may add a business rule and a negative acceptance criterion, but does not prevent the current acceptance criteria from being written
- No deadline is set — it can proceed with the assumption "no limit until confirmed otherwise" if needed
- Impact clearly distinguishes the two branches (exists / doesn't exist) and what changes in each case

---

### OQ-004 — Reminder Notification Timing

| Field | Value |
|---|---|
| **ID** | OQ-004 |
| **Question** | Should the system send an automated reminder notification to clients before their appointment? If yes, at what interval (e.g., 24 hours before, 1 hour before, or both)? |
| **Impact** | If reminders are in scope: a new user story (US-NNN) is needed, a scheduled job becomes an implied technical requirement to inform the Architect, and the notification NFRs expand. If reminders are out of scope for v1, this is explicitly documented as out-of-scope in Scope_Boundary.md and deferred. This question does not block any current story. |
| **Criticality** | LOW |
| **Owner** | Operations Manager |
| **Deadline** | — |
| **Status** | Open |

**Why this is well-formed:**
- LOW criticality is correct: the answer affects a potential new story and scope boundary note, but has zero impact on the current 5 stories
- Impact still describes the consequence of each possible answer
- Owner is Operations Manager — the role responsible for client communication strategy
- No deadline because it can be deferred to a follow-up session or assumed out-of-scope for v1
