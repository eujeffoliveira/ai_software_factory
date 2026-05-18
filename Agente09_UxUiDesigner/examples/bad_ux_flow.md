# BAD UX Flow Example
## Why this is a BAD example — annotated with failure modes

---

# DEFECTS IN THIS EXAMPLE:
# 1. No actors defined — who is performing this flow?
# 2. Only the happy path. No error paths at all.
# 3. Steps are vague — "user fills form", "success screen shows"
# 4. No decision points documented
# 5. No edge cases — no empty state scenario
# 6. No [AUTH REQUIRED] annotations
# 7. No PRD traceability
# 8. Step outcomes do not describe what actually happens on screen
# → Applies to failure modes: FM-04 (missing error paths), FM-02 (no PRD trace), FM-08 (vague)

---

# UX Flow
## Feature: Create Task
## Date: 2026-05-17

---

## Happy Path

### Step 1: Task List
User goes to the tasks page.

### Step 2: Create Button
User clicks the create button.

### Step 3: Form
User fills out the form with the task details.

### Step 4: Submit
User submits the form.

### Step 5: Done
Success screen shows.

---

# ANNOTATION OF DEFECTS:

## Why Step 1 is incomplete:
- No actor defined (who is "user"? Authenticated? Admin? Guest?)
- No screen URL specified (/tasks? /dashboard/tasks?)
- No state specified (is the page loading? populated? what if empty?)
- No [AUTH REQUIRED] annotation — this step clearly requires auth
- "goes to the tasks page" tells us nothing about the outcome

## Why Step 3 is incomplete:
- "fills out the form" — what fields? Which are required?
- No annotation for the decision: what if required fields are empty?
- No [DECISION: ...] annotation — there is clearly a branch here
- No mention of validation behavior

## Why Step 4 is incomplete:
- No [LOADING] annotation — API call is being made
- What happens to the button during submission?
- No [DECISION: API succeeds → Step 5 | API fails → ???]

## Why Step 5 is completely wrong:
- "Success screen shows" — what screen? What URL?
- What is the exact success message?
- Does the modal close? Does the list refresh?
- Where does focus go after success?

## Missing Sections:

### Actors (MISSING)
No actors defined. The developer will not know who this flow is designed for.

### Error Paths (MISSING — CRITICAL)
There are zero error paths. This means:
- What happens if the user is not authenticated? (they would see a blank page or 401)
- What happens if the API call to get tasks fails? (empty broken page)
- What happens if the form is submitted with empty required fields? (silent failure)
- What happens if the task creation API call fails? (form disappears, data lost)
All of these will be "invented" by Agente05_DevFrontend — which is not their job.

### Edge Cases (MISSING)
- No empty state described — what does a new user see on first visit?
- No character limit scenario
- No permission denied scenario

### Decision Points (MISSING)
The flow has implicit decisions that are never documented:
- Step 3 has a decision: are the required fields filled?
- Step 4 has a decision: did the API call succeed?
Both lead to different paths. Neither is documented.

### PRD Traceability (MISSING)
No acceptance criteria are referenced. It is impossible to verify that this flow covers what was specified.

## Correct gate outcome if this were submitted:
Status: RETURNED_FOR_REVISION
Reason: FM-04 (missing error paths), FM-02 (no PRD trace), FM-08 (vague steps)
Action: Apply `ux-flow-design-skill` — start over with complete template
