# UX Flow
## Feature: [Feature Name — matches PRD section heading]
## Related PRD Section: [User story IDs or section reference, e.g., US-03, AC-3.1 through AC-3.5]
## Date: [YYYY-MM-DD]
## Designed by: Agente09_UxUiDesigner

---

## Actors

- **Primary**: [Role — e.g., Authenticated User] — [What they want to accomplish — e.g., create and manage their tasks]
- **Secondary**: [Role if any — e.g., Admin] — [What they want — e.g., view all users' tasks for reporting]

_If there is only one actor, remove the secondary row._

---

## Entry Points

| Entry Point | Context |
|-------------|---------|
| [URL/screen — e.g., /dashboard] | [From what context — e.g., User clicks "Tasks" in navigation] |
| [URL/screen — e.g., /entity/new] | [From what context — e.g., Direct link in notification email] |

---

## Happy Path

_Document every step from entry to completion. Each step is a discrete user action or system state change._

### Step 1: [Step Name — e.g., View Entity List]

- **Actor**: [Who — e.g., Authenticated User]
- **Action**: [What they do — e.g., Navigates to /entity/list from the sidebar]
- **Screen**: [URL/route — e.g., /entity/list]
- **State**: [Loading | Populated | Empty — the state the screen is in at this step]
- **Annotations**: [AUTH REQUIRED] [LOADING — while data fetches]
- **Outcome**: [What happens next — e.g., Entity list renders with all entities belonging to the user]

---

### Step 2: [Step Name — e.g., Initiate Create Entity]

- **Actor**: [Who]
- **Action**: [What they do — e.g., Clicks the "+ New Entity" button in the top-right]
- **Screen**: [URL/route — e.g., /entity/list (modal opens)]
- **State**: Populated
- **Outcome**: [What happens — e.g., Create Entity modal opens with empty form fields]

---

### Step 3: [Step Name — e.g., Fill Entity Form]

- **Actor**: [Who]
- **Action**: [What they do — e.g., Fills in Name, Description, and selects Category]
- **Screen**: [URL/route — e.g., /entity/list (modal open)]
- **State**: Populated
- **Annotations**: [DECISION: form valid → Step 4 | form invalid → Validation Error path]
- **Outcome**: [What happens — e.g., Form is filled. Submit button becomes enabled once required fields are filled.]

---

### Step 4: [Step Name — e.g., Submit Form]

- **Actor**: [Who]
- **Action**: [What they do — e.g., Clicks "Create Entity" button]
- **Screen**: [URL/route]
- **State**: Loading (button shows loading state while API call is in progress)
- **Annotations**: [LOADING — while POST /api/entities resolves]
- **Outcome**: [What happens — e.g., API call succeeds, modal closes, entity list refreshes, success toast appears]

---

### Step 5: [Step Name — e.g., Confirm Creation]

- **Actor**: [Who]
- **Action**: [System / User]
- **Screen**: [URL/route — e.g., /entity/list]
- **State**: Populated
- **Outcome**: [What happens — e.g., Entity list now includes the new entity. Toast: "Entity created successfully." disappears after 3 seconds]

---

## Error Paths

_Document every error scenario. Minimum 2: authentication error + data failure. Add more as needed._

### Error Path 1: Authentication Required

- **Trigger**: User is not authenticated (session expired or direct URL access without login)
- **Step triggered at**: Step 1
- **Screen**: Redirect to `/auth/signin?callbackUrl=/entity/list`
- **Recovery**: After successful authentication, redirect to the original destination (`/entity/list`)

---

### Error Path 2: Data Load Failure

- **Trigger**: API call to fetch entity list returns 5xx error or network timeout
- **Step triggered at**: Step 1 (loading phase)
- **Screen**: `/entity/list` — error state (icon + "Something went wrong" message + "Try again" button)
- **Recovery**: User clicks "Try again" — re-triggers data fetch; if successful, populated state renders

---

### Error Path 3: Form Validation Failure

- **Trigger**: User submits the form with one or more required fields empty or invalid
- **Step triggered at**: Step 4 (form submit)
- **Screen**: Modal stays open; invalid fields highlighted with inline error messages
- **Recovery**: User corrects the invalid fields; form re-validates on blur; submit becomes enabled again

---

### Error Path 4: Create Entity Failure (Server Error)

- **Trigger**: POST /api/entities returns 4xx or 5xx
- **Step triggered at**: Step 4 (API call)
- **Screen**: Modal stays open; form-level error message appears: "We couldn't create the entity. Please try again."
- **Recovery**: User can retry immediately or cancel and close the modal

---

## Edge Cases

_Scenarios that are not errors but represent non-standard data conditions._

| Condition | Behavior |
|-----------|---------|
| [Empty list: User has no entities] | Entity list shows empty state: icon + "No entities yet" + "Create your first entity" CTA |
| [Search returns zero results] | Entity list shows search-empty state: "No entities match '[search term]'" + "Clear search" button |
| [Filter returns zero results] | Entity list shows filter-empty state: "No entities match your filters" + "Clear filters" button |
| [Permission denied: read-only user] | Empty state CTA is hidden; create button is disabled; tooltip: "You don't have permission to create entities" |
| [Large dataset: 500+ entities] | Pagination renders; max 20 entities per page; "Showing 1–20 of 500" label visible |

---

## Decision Points

_Explicit branch points where the flow splits based on conditions._

| Step | Condition | Path A | Path B |
|------|-----------|--------|--------|
| Step 3 | All required fields filled and valid | Proceed to Step 4 (submit) | Submit button remains disabled; form-level inline errors shown |
| Step 1 | User is authenticated | Proceed to entity list load | Redirect to `/auth/signin` (Error Path 1) |
| Step 4 | API call succeeds | Proceed to Step 5 (confirm) | Show Create Entity Failure error (Error Path 4) |

---

## Traceability

| PRD Section | Flow Coverage |
|-------------|---------------|
| [e.g., AC-3.1 — User can view all their entities] | Step 1 — Entity list populated state |
| [e.g., AC-3.2 — User can create a new entity] | Steps 2–5 — Happy path |
| [e.g., AC-3.3 — User sees empty state when no entities exist] | Edge Case: empty list |
| [e.g., AC-3.4 — Form validates required fields before submission] | Error Path 3 — Validation failure |
