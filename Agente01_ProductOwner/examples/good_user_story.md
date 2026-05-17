# Good User Stories — INVEST Analysis

_Three user stories that fully satisfy the INVEST criteria, with annotations explaining each dimension._

---

## US-001 — Client Self-Scheduling

> **Story:** As a client, I want to select an available time slot for a service, so that I can book an appointment without calling the business.

### INVEST Analysis

**I — Independent:**
This story can be developed and delivered without depending on US-002 (Staff Schedule View) or US-003 (Cancellation). The booking flow is a self-contained capability. The staff schedule view is a separate feature consumed by different personas. ✅

**N — Negotiable:**
The story specifies the goal (select a slot, confirm a booking) without prescribing UI layout. The team can choose a calendar widget, a list of time slots, or a step-by-step wizard — the story accommodates any implementation. ✅

**V — Valuable:**
The "so that" clause is a genuine business outcome: clients can complete their goal without a phone call. This reduces inbound call volume and enables bookings outside business hours. Removing this story would be immediately noticed. ✅

**E — Estimable:**
A developer can reason about the scope: display available slots, capture client info, create a booking record, send confirmation. Unknowns (double-booking prevention logic) are addressed in BR-001. The team can size this in a planning session. ✅

**S — Small:**
The story covers one coherent user flow: book an appointment. It does not include managing the booking (separate stories) or staff availability management (another persona). Fits in a single sprint. ✅

**T — Testable:**
Acceptance criteria can be written in Gherkin: Given available slots exist, When client selects a slot and submits contact info, Then a confirmed appointment is created and a confirmation email is sent within 60 seconds. All outcomes are deterministic and measurable. ✅

---

## US-002 — Staff Daily Schedule View

> **Story:** As a staff member, I want to view all my appointments for the current day in a timeline view, so that I can prepare for each session without searching through multiple calendars.

### INVEST Analysis

**I — Independent:**
This story reads appointment data created by US-001 but does not depend on US-001 being in the same sprint. It can be developed with seeded test data. The dependency on data existence is a test concern, not a story dependency. ✅

**N — Negotiable:**
"Timeline view" is a suggestion from the persona interview, not a hard requirement. The team can implement a sorted list, a calendar timeline, or a table — all satisfy "view appointments for the day without searching." ✅

**V — Valuable:**
Directly eliminates the pain point identified in the business problem: staff spending time coordinating via multiple calendars. The benefit clause is specific to the persona's workflow. ✅

**E — Estimable:**
Scope is clear: fetch appointments for current day filtered by logged-in staff member, display in chronological order with key fields. No significant unknowns. NFR-PERF-002 (≤ 2s for 50 appointments) provides the performance boundary. ✅

**S — Small:**
View-only for current day. Does not include editing, managing, or viewing other staff members' schedules (those are separate stories with separate personas). ✅

**T — Testable:**
Given a logged-in staff member with 3 appointments today, When they navigate to "My Schedule", Then all 3 are displayed in chronological order and the page loads in ≤ 2 seconds. All conditions are verifiable. ✅

---

## US-003 — Appointment Cancellation

> **Story:** As a client, I want to cancel my appointment up to 24 hours in advance, so that I can free the slot without calling the business.

### INVEST Analysis

**I — Independent:**
Cancellation is a distinct capability that can be built and tested independently of the booking flow (US-001). The unique confirmation link mechanism it relies on can be designed as a shared infrastructure piece, but the cancellation logic itself is independent. ✅

**N — Negotiable:**
The story specifies the business constraint (24-hour window) as a rule (BR-001), not a UI constraint. The team can implement this via a link in the confirmation email, a web form, or both — the story is flexible. ✅

**V — Valuable:**
Clients can handle cancellations without a phone call, which is the direct complement to self-booking. Eliminates a class of inbound calls for the business. Value is clear and immediate. ✅

**E — Estimable:**
Scope: validate the confirmation token, check if appointment is > 24 hours away (BR-001), update status to Cancelled, free the slot, send cancellation email. The 24-hour rule from BR-001 makes the rule unambiguous. ✅

**S — Small:**
Covers only the cancellation flow. Rescheduling (a different action), modifying appointment details, and late-cancellation fees are separate concerns not in this story. ✅

**T — Testable:**
Happy path: Given an appointment 48 hours in the future, When the client cancels, Then status changes to Cancelled and slot is freed. Negative: Given an appointment 12 hours in the future, When the client attempts to cancel, Then the system rejects with the specific error message. Both are verifiable. ✅
