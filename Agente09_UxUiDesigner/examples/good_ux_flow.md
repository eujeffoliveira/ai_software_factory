# GOOD UX Flow Example
## Why this is a good example:
# - All actors defined with roles and goals
# - Happy path has 5 numbered steps with all required fields
# - Four error paths (auth, load failure, validation, server error)
# - Three edge cases documented
# - Two decision points with both branches documented
# - Auth-required steps annotated
# - PRD traceability table at the end

---

# UX Flow
## Feature: Create Task
## Related PRD Section: US-03 (Task Management), AC-3.1 through AC-3.5
## Date: 2026-05-17
## Designed by: Agente09_UxUiDesigner

---

## Actors

- **Primary**: Authenticated User — Create a new task and assign it to a project so they can track it in their task list
- **Secondary**: None for this flow

---

## Entry Points

| Entry Point | Context |
|-------------|---------|
| `/tasks` | User clicks "+ New Task" button on the Task List page |
| `/projects/[id]` | User clicks "+ New Task" button within a specific project view |
| `/dashboard` | User clicks the "Quick Add Task" card in the dashboard shortcut zone |

---

## Happy Path

### Step 1: View Task List
- **Actor**: Authenticated User
- **Action**: Navigates to `/tasks` from the left sidebar navigation
- **Screen**: `/tasks`
- **State**: Loading (skeleton while task list fetches)
- **Annotations**: [AUTH REQUIRED] [LOADING — while GET /api/tasks resolves]
- **Outcome**: Task list renders with all tasks belonging to the authenticated user. If no tasks exist, empty state is shown.

---

### Step 2: Initiate Task Creation
- **Actor**: Authenticated User
- **Action**: Clicks the "+ New Task" button in the top-right of the page header
- **Screen**: `/tasks` (Create Task modal opens as overlay)
- **State**: Populated (underlying list remains; modal appears on top)
- **Outcome**: Create Task modal opens with all form fields empty. Focus moves to the "Task Name" input.

---

### Step 3: Fill Task Form
- **Actor**: Authenticated User
- **Action**: Types the task name, optionally adds a description, selects a project from the dropdown, and sets a due date
- **Screen**: `/tasks` (modal open)
- **State**: Populated (form fields filling as user types)
- **Annotations**: [DECISION: Task Name field is filled AND Project selected → Step 4 enabled | Required fields empty → Submit button disabled]
- **Outcome**: Submit button ("Create Task") becomes enabled once "Task Name" (required) and "Project" (required) are filled. Validation fires on blur for each field.

---

### Step 4: Submit Task Creation
- **Actor**: Authenticated User
- **Action**: Clicks the "Create Task" button
- **Screen**: `/tasks` (modal open, button in loading state)
- **State**: Loading (button shows spinner, form inputs disabled)
- **Annotations**: [LOADING — while POST /api/tasks resolves]
- **Outcome**: API call `POST /api/tasks` is made with `{ name, description, projectId, dueDate }`. Button shows spinner + label "Creating...". Form inputs are disabled to prevent changes during submission.

---

### Step 5: Confirm Task Created
- **Actor**: System
- **Action**: API returns 201 Created with the new task object
- **Screen**: `/tasks` (modal closes; task list refreshes)
- **State**: Populated (new task appears in the list)
- **Outcome**: Create Task modal closes. Task list re-fetches and renders the new task at the top of the list (sorted by `createdAt` descending). Success toast: "Task created successfully." — disappears after 3 seconds. Focus returns to the "+ New Task" button.

---

## Error Paths

### Error Path 1: Authentication Required

- **Trigger**: User accesses `/tasks` without an active session (direct URL, expired session)
- **Step triggered at**: Step 1
- **Screen**: Redirect to `/auth/signin?callbackUrl=%2Ftasks`
- **Recovery**: User authenticates successfully → redirected back to `/tasks` → task list loads normally

---

### Error Path 2: Task List Load Failure

- **Trigger**: `GET /api/tasks` returns 5xx error or network timeout
- **Step triggered at**: Step 1 (loading phase)
- **Screen**: `/tasks` — error state: `cloud-off` icon + "We couldn't load your tasks" + "Try again" button
- **Recovery**: User clicks "Try again" → re-triggers `GET /api/tasks` → on success, task list renders normally

---

### Error Path 3: Form Validation Failure

- **Trigger**: User attempts to submit with Task Name empty, or with Due Date in the past
- **Step triggered at**: Step 4 (pre-submit client-side validation)
- **Screen**: `/tasks` (modal open) — inline error messages below invalid fields
  - Empty Task Name: inline error "Task name is required"
  - Past Due Date: inline error "Due date must be today or in the future"
- **Recovery**: User corrects the invalid fields → errors clear on blur when valid → Submit re-enables → user resubmits

---

### Error Path 4: Task Creation Server Error

- **Trigger**: `POST /api/tasks` returns 4xx or 5xx response
- **Step triggered at**: Step 4 (API call)
- **Screen**: `/tasks` (modal stays open) — form-level error message appears below the form: "We couldn't create your task. Please try again."
- **Recovery**: User can click "Create Task" again immediately to retry, or click "Cancel" to close the modal without losing form data (form state preserved during error)

---

## Edge Cases

| Condition | Behavior |
|-----------|---------|
| No tasks exist yet (empty state) | Task list shows empty state: `inbox` icon + "No tasks yet" + "Create your first task" CTA that opens Create Task modal |
| Search returns no results | Task list shows search-empty state: `search-x` icon + "No results for '[query]'" + "Clear search" button |
| User has no projects (required for task creation) | "Project" dropdown in Create Task modal shows "No projects available" disabled option + helper text: "Create a project first before adding tasks." — "Create Project" link inside the modal |
| Task name at 255-character limit | Character counter shows "255/255" in amber `warning` token; submit still allowed at limit but not beyond |
| Due date picker: user selects past date | Inline validation on blur: "Due date must be today or in the future" — prevent submission until corrected |

---

## Decision Points

| Step | Condition | Path A | Path B |
|------|-----------|--------|--------|
| Step 1 | User is authenticated | Task list loads | Redirect to `/auth/signin` (Error Path 1) |
| Step 3 | Required fields (Task Name + Project) are filled and valid | Submit button enabled (proceed to Step 4) | Submit button remains disabled; no submit action possible |
| Step 4 | API call succeeds | Proceed to Step 5 (success) | Show form-level error (Error Path 4) |

---

## Traceability

| PRD Section | Flow Coverage |
|-------------|---------------|
| AC-3.1 — User can view their task list | Step 1 — Task list populated state |
| AC-3.2 — User can create a new task with a name, description, and project | Steps 2–5 — full creation happy path |
| AC-3.3 — Task name is required; description is optional | Step 3 — form validation, required field behavior |
| AC-3.4 — User sees a success confirmation after task creation | Step 5 — success toast and list refresh |
| AC-3.5 — User sees an error message if task creation fails | Error Path 4 — form-level error on server failure |
