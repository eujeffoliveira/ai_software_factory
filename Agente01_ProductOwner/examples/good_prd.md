# Product Requirements Document — Appointment Management System

**Version:** 1.0
**Date:** 2026-05-17
**Product Owner:** Agente01_ProductOwner
**Status:** Ready for Gate 1
**Gate Target:** Gate 1

---

## 1. Summary

The Appointment Management System is a SaaS platform that allows service businesses to manage client bookings end-to-end. Clients can self-schedule appointments through a public booking interface, while staff members manage availability, view their daily schedule, and track appointment history. The system eliminates the current reliance on phone-based booking and manual calendar management, which causes scheduling conflicts and double-bookings.

---

## 2. Business Problem

**Problem Statement:** Service businesses using manual scheduling (phone, paper, shared spreadsheets) experience an average of 3–5 scheduling conflicts per week, leading to client dissatisfaction and staff overtime to resolve conflicts.

**Evidence / Context:** Reported by 8 of 12 surveyed service business managers. Current tools do not enforce availability constraints — any staff member can book any slot regardless of current commitments.

**Impact of Not Solving:** Continued double-bookings damage client trust. Staff spend an estimated 4 hours/week on scheduling coordination rather than service delivery.

---

## 3. Objectives

- **OBJ-01:** Reduce scheduling conflicts to zero by enforcing availability rules and preventing double-bookings at point of creation.
- **OBJ-02:** Enable clients to self-schedule appointments without calling, reducing inbound phone volume by at least 60%.
- **OBJ-03:** Allow staff to view and manage their daily schedule in under 30 seconds from login.

---

## 4. Non-Objectives (Out of Scope)

- Payment processing — invoicing and payment collection are out of scope for v1
- Multi-location management — single location only in this release
- Mobile native application — web-only; progressive web app is not in scope

_Full scope boundary definition: `Scope_Boundary.md`_

---

## 5. Target Users

### Primary Users

**Service Staff Member** — A practitioner who provides the service (e.g., technician, consultant). They need to view their upcoming appointments, mark appointments as completed or cancelled, and block time slots for non-client activities. Currently spends excessive time on coordination calls.

### Secondary Users

**Business Administrator** — Manages staff accounts, service types, and business operating hours. Needs reporting on appointment volumes and staff utilization. Not a direct service provider.

---

## 6. User Stories

| ID | Title | User Story | Priority |
|---|---|---|---|
| US-001 | Client Self-Booking | As a client, I want to select an available time slot for a service, so that I can book an appointment without calling the business | MUST |
| US-002 | Staff Daily Schedule | As a staff member, I want to view all my appointments for the current day in a timeline view, so that I can prepare for each session without searching through multiple calendars | MUST |
| US-003 | Appointment Cancellation | As a client, I want to cancel my appointment up to 24 hours in advance, so that I can free the slot without calling the business | MUST |
| US-004 | Availability Blocking | As a staff member, I want to block specific time slots on my calendar, so that clients cannot book appointments during those periods | SHOULD |
| US-005 | Booking History | As a business administrator, I want to view a report of all appointments for a selected date range, so that I can monitor business utilization and staff workload | SHOULD |

_Full story map: `User_Story_Map.md`_

---

## 7. Acceptance Criteria

### US-001 — Client Self-Booking

**AC-001-01 [HP] — Successful booking with confirmation**
```gherkin
Given a client has navigated to the public booking page
And at least one staff member has available slots in the next 7 days
When the client selects a service, selects a date, selects an available time slot, and submits their name and email
Then the system creates an appointment record with status "Confirmed"
And the client receives a confirmation email within 60 seconds
And the selected time slot is no longer available to other clients
```
**Acceptance Metric:** Confirmation email delivered within 60 seconds in 95% of cases.

**AC-001-02 [EC] — Last available slot**
```gherkin
Given only one time slot remains available for a given staff member on a given date
When two clients simultaneously attempt to book the same slot
Then only one booking succeeds
And the second client receives a message: "This time slot is no longer available. Please choose another time."
And no double-booking is created
```

**AC-001-03 [NS] — Submitting without required fields**
```gherkin
Given a client is on the booking form with a time slot selected
When the client submits the form without entering an email address
Then the form is not submitted
And an inline validation message appears: "Email address is required to confirm your booking."
```

### US-002 — Staff Daily Schedule

**AC-002-01 [HP] — View today's appointments**
```gherkin
Given a staff member is logged into the system
When they navigate to the "My Schedule" view without selecting a date
Then the system displays all confirmed appointments for today in chronological order
And each appointment shows: client name, service type, start time, end time, and status
And the view loads within 2 seconds
```
**Acceptance Metric:** Page load P95 ≤ 2 seconds.

**AC-002-02 [EC] — No appointments today**
```gherkin
Given a staff member has no confirmed appointments for today
When they navigate to the "My Schedule" view
Then the system displays the message: "No appointments scheduled for today."
And the staff member can navigate to other dates
```

**AC-002-03 [NS] — Unauthenticated access attempt**
```gherkin
Given a user is not logged into the system
When they attempt to access the "My Schedule" URL directly
Then the system redirects them to the login page
And does not display any appointment data
```

### US-003 — Appointment Cancellation

**AC-003-01 [HP] — Successful cancellation within allowed window**
```gherkin
Given a client has a confirmed appointment scheduled more than 24 hours in the future
When the client navigates to their booking confirmation link and clicks "Cancel Appointment"
Then the system changes the appointment status to "Cancelled"
And the time slot becomes available for new bookings
And the client receives a cancellation confirmation email within 60 seconds
```

**AC-003-02 [NS] — Cancellation attempt within 24-hour window**
```gherkin
Given a client has a confirmed appointment scheduled within the next 24 hours
When the client attempts to cancel via their confirmation link
Then the system rejects the cancellation
And displays the message: "Cancellations must be made at least 24 hours in advance. Please call us to cancel."
And the appointment remains Confirmed
```

_Full acceptance criteria: `Acceptance_Criteria.md`_

---

## 8. Functional Requirements

- **FR-001:** The system must prevent a staff member from having two confirmed appointments with overlapping time ranges.
- **FR-002:** The booking interface must display only time slots that are within the business's operating hours and not already booked or blocked.
- **FR-003:** The system must send email notifications for appointment creation, modification, and cancellation events.
- **FR-004:** Staff members must only be able to view their own appointment schedule (not other staff members' schedules) unless they hold the Administrator role.
- **FR-005:** Clients must be able to access their booking confirmation and cancellation option using a unique link without creating an account.

---

## 9. Non-Functional Requirements

### 9.1 Performance
- **NFR-PERF-001:** P95 response time for the public booking page ≤ 2 seconds under 100 concurrent sessions.
- **NFR-PERF-002:** Staff schedule view must load in ≤ 2 seconds for up to 50 appointments per day.

### 9.2 Security
- **NFR-SEC-001:** Staff and administrator routes require an authenticated session; unauthenticated access returns HTTP 401 and redirects to login.
- **NFR-SEC-002:** Client confirmation links use unique tokens with minimum 128-bit entropy; tokens expire 48 hours after the appointment date.

### 9.3 Privacy
- **NFR-PRIV-001:** Client PII fields (full name, email address, phone number) must not appear in application logs in plain text.
- **NFR-PRIV-002:** Only the booking staff member and administrators can view client contact details.

### 9.4 Availability
- **NFR-AVAIL-001:** System uptime ≥ 99.5% measured monthly, excluding planned maintenance windows announced at least 24 hours in advance.

### 9.5 Observability
- **NFR-OBS-001:** All appointment state changes (created, cancelled, completed) must produce structured log entries within 500ms of the change.

### 9.6 Auditability
- **NFR-AUDIT-001:** All administrator actions (creating/deactivating staff accounts, changing operating hours, modifying service types) must be recorded in the audit log with actor ID, action type, timestamp, and before/after values.
- **NFR-AUDIT-002:** Audit logs must be retained for 24 months.

### 9.7 Accessibility
- **NFR-ACC-001:** All interactive components on the public booking interface comply with WCAG 2.1 Level AA.

### 9.8 Maintainability
- **NFR-MAINT-001:** Zero circular dependencies between domain modules (booking, scheduling, notifications, administration); enforced via CI lint rule.

### 9.9 Scalability
- **NFR-SCALE-001:** The system must support up to 50 staff members and 5,000 client appointments per month without architectural changes.

### 9.10 Data Retention
- **NFR-DRET-001:** Appointment records must be retained for 5 years from the appointment date.
- **NFR-DRET-002:** Client contact data must be deletable within 30 days of a verified deletion request.

_Full NFR definitions: `Non_Functional_Requirements.md`_

---

## 10. Business Rules

| ID | Description | Source | Applies To | Status |
|---|---|---|---|---|
| BR-001 | Clients may cancel appointments without penalty only if the cancellation is made at least 24 hours before the scheduled start time. | Business Owner, Session 1, 2026-05-10 | US-003, AC-003-02 | Confirmed |
| BR-002 | Each staff member's working hours are defined at the individual level and override the default business operating hours when both are set. | Operations Manager, Session 1, 2026-05-10 | US-004, US-001 | Confirmed |

_Full rules register: `Business_Rules.md`_

---

## 11. Data Requirements

**Core Entities:**
- **Appointment:** Represents a scheduled service session between one staff member and one client. Business-level attributes: service type, scheduled start/end time, status (Confirmed/Cancelled/Completed), associated staff member, associated client contact.
- **Staff Member:** A practitioner with individual working hours and service capabilities. Business-level attributes: name, active status, assigned services, working hour schedule.
- **Client Contact:** Information provided by clients during booking. Business-level attributes: name, email address, phone number (optional).
- **Service Type:** Defines available services and their standard duration. Business-level attributes: name, duration, active status.

**Data Sensitivity:**
- **PII Fields:** client full name, client email address, client phone number
- **Sensitive Business Data:** staff individual schedules (restricted to own schedule + administrators)

**Volume Expectations:**
- Up to 5,000 appointments/month at initial scale; expected to grow to 20,000/month by end of year 1.

---

## 12. Product Risks

| ID | Description | Category | Impact | Probability | Mitigation |
|---|---|---|---|---|---|
| PRISK-001 | Low adoption by clients if booking flow has more than 3 steps | user | HIGH | MEDIUM | Conduct usability test with 5 target clients before development phase |
| PRISK-002 | Email notifications may be delayed or land in spam, causing clients to miss confirmation | integration | MEDIUM | HIGH | Validate email delivery rates during QA phase; consider SMS as fallback in Phase 2 |

_Full risk register: `Product_Risks.md`_

---

## 13. Assumptions

- **A-01:** The business operates from a single physical location for the initial release.
- **A-02:** All staff members have internet-accessible devices for schedule management.
- **A-03:** Client accounts are not required — clients book and manage appointments via unique confirmation links.

---

## 14. Open Questions

| ID | Question | Impact | Criticality | Owner | Deadline | Status |
|---|---|---|---|---|---|---|
| OQ-001 | Should the system send SMS notifications in addition to email, or email only for v1? | Affects notification NFRs and integration scope | HIGH | Operations Manager | 2026-05-24 | Open |
| OQ-002 | Is there a maximum number of appointments a single client can book within a rolling 30-day window? | Affects booking validation rules and may add a BR-NNN | MEDIUM | Business Owner | — | Open |

_Full questions register: `Open_Questions.md`_

---

## 15. Handoff Status

**PRD Version:** 1.0
**Gate 1 Readiness:** Ready
**Blocking Issues:** None — OQ-001 and OQ-002 are non-blocking; assumptions documented
**Handoff Package:** `Handoff_To_Architect.md`
