# Good Acceptance Criteria — BDD/Gherkin Examples

_Two user stories with complete Gherkin acceptance criteria covering happy path, edge case, and negative scenario._

---

## US-001 — Client Self-Booking

> **Story:** As a client, I want to select an available time slot for a service, so that I can book an appointment without calling the business.

---

### AC-001-01 [HP] — Successful booking with email confirmation

```gherkin
Given a client has navigated to the public booking page
And the business has at least one available time slot in the next 7 days
When the client selects a service type
And selects a date with available slots
And selects one available time slot
And enters a valid name and email address
And submits the booking form
Then the system creates an appointment record with status "Confirmed"
And the selected time slot is marked as unavailable for other clients
And the client receives a confirmation email containing the appointment date, time, staff member name, and a cancellation link
And the confirmation email is delivered within 60 seconds of submission
```

**Acceptance Metric:** Confirmation email delivered within 60 seconds in P95 of test runs.

**Why this is good:**
- Given clause establishes a concrete, testable precondition (booking page accessible, slots available)
- When clause describes a single flow with clear steps
- Then clause has 4 specific, verifiable outcomes — none use vague language
- Time metric (60 seconds) is concrete and testable

---

### AC-001-02 [EC] — Concurrent booking of the last available slot

```gherkin
Given only one time slot remains available for a staff member on a given date
And two separate clients have loaded the booking page with that slot visible
When both clients submit a booking form for the same slot within 1 second of each other
Then exactly one booking is created with status "Confirmed"
And the second submission receives a response: "This time slot is no longer available. Please choose another time."
And the slot is not double-booked
```

**Acceptance Metric:** Zero double-bookings created under concurrent load test scenarios.

**Why this is good:**
- Edge case addresses a real business risk (double-booking under concurrency)
- Outcome is explicit: one confirms, one is rejected with a specific message
- "Zero double-bookings" is a clear pass/fail criterion

---

### AC-001-03 [NS] — Missing required field on submission

```gherkin
Given a client has selected a service, date, and time slot on the booking form
When the client submits the form without entering an email address
Then the booking form is not submitted to the server
And an inline validation error appears adjacent to the email field: "Email address is required to confirm your booking."
And all other form fields retain their current values
```

**Acceptance Metric:** Validation error appears without page reload; form retains field values.

**Why this is good:**
- Specific error message text is defined (not "an error appears")
- Side effect (field retention) is explicitly stated
- Server-side submission is distinguished from client-side validation

---

## US-003 — Appointment Cancellation

> **Story:** As a client, I want to cancel my appointment up to 24 hours in advance, so that I can free the slot without calling the business.

---

### AC-003-01 [HP] — Successful cancellation within the allowed window

```gherkin
Given a client has a confirmed appointment scheduled 48 hours in the future
And the client has received a confirmation email with a cancellation link
When the client clicks the cancellation link in the email
And confirms the cancellation on the cancellation page
Then the appointment status changes to "Cancelled"
And the time slot becomes available for new bookings within 30 seconds
And the client receives a cancellation confirmation email within 60 seconds containing the cancelled appointment details
```

**Acceptance Metric:** Slot becomes available within 30 seconds; email delivered within 60 seconds.

**Why this is good:**
- Precondition specifies "48 hours" — a concrete value that falls within the allowed window
- Two steps in the When clause (click link, then confirm) reflect the real UX flow
- Three distinct Then outcomes are each individually verifiable

---

### AC-003-02 [EC] — Cancellation attempt exactly at the 24-hour boundary

```gherkin
Given a client has a confirmed appointment scheduled exactly 24 hours and 0 minutes in the future
When the client attempts to cancel via their confirmation link
Then the system allows the cancellation
And the appointment status changes to "Cancelled"
```

**Acceptance Metric:** The boundary condition (exactly 24h) must pass, not fail.

**Why this is good:**
- Tests the boundary: "up to 24 hours in advance" — is the boundary inclusive or exclusive?
- Explicitly documents the expected behavior at the boundary value
- Product Owner has made the decision (inclusive boundary) — Architect and QA do not have to guess

---

### AC-003-03 [NS] — Cancellation attempt inside the 24-hour window

```gherkin
Given a client has a confirmed appointment scheduled 12 hours in the future
When the client clicks the cancellation link in the email
And navigates to the cancellation page
Then the system displays the message: "Cancellations must be made at least 24 hours in advance. Please call us to cancel."
And no cancellation is processed
And the appointment status remains "Confirmed"
```

**Acceptance Metric:** Exact error message text matches specification; appointment status unchanged.

**Why this is good:**
- Exact error message text is specified — no ambiguity for the developer or QA engineer
- Three outcomes are each verifiable: message displayed, no cancellation processed, status unchanged
- The "call us" fallback confirms to QA that no alternative action should be offered
