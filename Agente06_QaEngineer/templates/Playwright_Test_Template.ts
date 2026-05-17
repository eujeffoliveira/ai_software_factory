import { test, expect, type Page } from "@playwright/test"

// ─── E2E Test: [Feature Name] ─────────────────────────────────────────────
//
// Maps to acceptance criteria:
//   AC-[NNN]: Given [precondition]
//             When [user action]
//             Then [expected outcome]
//
// Test pyramid position: E2E — these tests are expensive and slow.
// Only test the golden path user journey here.
// Unit and integration tests handle edge cases and error paths.
//
// Selector policy: ALWAYS use accessible selectors.
// ALLOWED: getByRole, getByLabel, getByText, getByTestId, getByPlaceholder
// FORBIDDEN: CSS selectors (.class), XPath (//div), raw ID (#id)
// ─────────────────────────────────────────────────────────────────────────────

test.describe("[Feature Name] — AC-[NNN]", () => {
  // Auth setup: run before each test in this describe block
  // Use stored authentication state for efficiency
  // Reference: playwright.config.ts storageState configuration
  test.beforeEach(async ({ page }) => {
    // Navigate to the application root
    await page.goto("/")

    // If using stored auth state configured in playwright.config.ts,
    // the session is already injected. Otherwise, perform login here:
    //
    // await page.getByLabel("Email").fill("testuser@organization.com")
    // await page.getByLabel("Password").fill(process.env.TEST_PASSWORD!)
    // await page.getByRole("button", { name: "Sign in" }).click()
    // await expect(page).toHaveURL("/dashboard")
  })

  // ─── Happy Path ───────────────────────────────────────────────────────────
  // Maps to: Given [precondition] / When [action] / Then [outcome]
  // This is the primary golden path — what the user does in the normal case

  test("successfully [performs main action] — AC-[NNN]", async ({ page }) => {
    // Navigate to the feature
    await page.goto("/[feature-path]")

    // Wait for the page to be ready (prefer role-based locators over timeouts)
    await expect(page.getByRole("heading", { name: "[Page Heading]" })).toBeVisible()

    // Fill in the form using accessible selectors
    // getByLabel: finds input by its associated <label> text
    await page.getByLabel("[Input Label]").fill("[test value]")
    await page.getByLabel("[Another Input]").fill("[another value]")

    // Select from dropdown using role
    await page.getByRole("combobox", { name: "[Dropdown Label]" }).selectOption("[value]")

    // Click the primary action button
    await page.getByRole("button", { name: "[Action Button Label]" }).click()

    // Wait for and assert the expected outcome
    // Option A: success message/toast
    await expect(page.getByRole("alert")).toContainText("Success")

    // Option B: navigation to a result page
    // await expect(page).toHaveURL("/[expected-path]")

    // Option C: the created entity appears in the list
    // await expect(page.getByRole("listitem", { name: "[entity name]" })).toBeVisible()
  })

  // ─── Error State ──────────────────────────────────────────────────────────
  // Verifies that validation errors are shown to the user
  // Tests the When → Then path where input is invalid

  test("shows validation error when required field is missing", async ({ page }) => {
    await page.goto("/[feature-path]")

    // Attempt to submit without filling required fields
    await page.getByRole("button", { name: "[Submit Button Label]" }).click()

    // Assert that an error is shown to the user
    // Errors must use role="alert" for accessibility (DR012, accessibility regression)
    await expect(page.getByRole("alert")).toBeVisible()

    // Assert the error message is user-friendly (not an internal error)
    // Avoid asserting on exact text if it might change — use partial match
    await expect(page.getByText("[Expected error text, or partial]")).toBeVisible()

    // Assert the user is still on the same page (not navigated away on error)
    await expect(page).toHaveURL("/[feature-path]")
  })

  // ─── Accessibility: Keyboard Navigation ───────────────────────────────────
  // Verifies that the feature is fully usable with keyboard only
  // Required for every primary user flow (WCAG 2.1 AA compliance)
  // Accessibility violations in primary flows = HIGH severity bug

  test("is fully navigable by keyboard — accessibility", async ({ page }) => {
    await page.goto("/[feature-path]")

    // Tab to the first interactive element
    await page.keyboard.press("Tab")

    // Assert focus is visible (not lost, not stuck on non-interactive element)
    const firstFocused = page.locator(":focus")
    await expect(firstFocused).toBeVisible()

    // Assert the focused element has an accessible name
    // This catches icon buttons and inputs without labels
    await expect(firstFocused).toHaveAttribute("aria-label")
    // OR: await expect(firstFocused).toHaveAccessibleName()

    // Tab through the form fields
    await page.keyboard.press("Tab") // Move to second interactive element
    const secondFocused = page.locator(":focus")
    await expect(secondFocused).toBeVisible()

    // Tab to the submit button
    // Repeat Tab presses as needed to reach the submit button
    await page.keyboard.press("Tab")

    // Submit the form using Enter key (keyboard activation)
    await page.keyboard.press("Enter")

    // Assert: keyboard submission produces the same result as mouse click
    // (This verifies the button/form works with keyboard, not just mouse)
  })

  // ─── Accessibility: Error Announcement ───────────────────────────────────
  // Verifies that errors are announced to screen reader users
  // Errors must use role="alert" or aria-live="polite"

  test("announces error to screen readers — accessibility", async ({ page }) => {
    await page.goto("/[feature-path]")

    // Trigger an error state
    await page.getByRole("button", { name: "[Submit Button]" }).click()

    // The error must be in a role="alert" region (auto-announced by screen readers)
    const errorAlert = page.getByRole("alert")
    await expect(errorAlert).toBeVisible()

    // The error text must be present and non-empty
    const errorText = await errorAlert.textContent()
    expect(errorText?.trim().length).toBeGreaterThan(0)
  })

  // ─── Navigation After Success ─────────────────────────────────────────────
  // Verifies that the user is taken to the right place after a successful action

  test("navigates to [result page] after successful [action]", async ({ page }) => {
    await page.goto("/[feature-path]")

    // Fill in valid data and submit
    await page.getByLabel("[Required Field]").fill("[valid value]")
    await page.getByRole("button", { name: "[Submit]" }).click()

    // Assert navigation to the expected URL
    await expect(page).toHaveURL("/[expected-path]")

    // Assert the result page shows the expected content
    await expect(page.getByRole("heading", { name: "[Expected Heading]" })).toBeVisible()
  })
})

// ─── Optional: Page Object Helper ────────────────────────────────────────────
// For complex, multi-step flows, extract interactions into a Page Object
// This reduces duplication when multiple tests need the same interactions
//
// Usage:
//   const formPage = new [Feature]Page(page)
//   await formPage.navigate()
//   await formPage.fill("[value]")
//   await formPage.submit()

export class [Feature]Page {
  constructor(private page: Page) {}

  async navigate() {
    await this.page.goto("/[feature-path]")
    await expect(this.page.getByRole("heading", { name: "[Page Heading]" })).toBeVisible()
  }

  async fill[FieldName](value: string) {
    await this.page.getByLabel("[Field Label]").fill(value)
  }

  async submit() {
    await this.page.getByRole("button", { name: "[Submit Button Label]" }).click()
  }

  async getSuccessMessage() {
    return this.page.getByRole("alert").textContent()
  }

  async getErrorMessage() {
    return this.page.getByRole("alert").textContent()
  }
}
