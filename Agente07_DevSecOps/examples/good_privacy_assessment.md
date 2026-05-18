# Good Example — Privacy Assessment

> This is a realistic example of a HIGH-QUALITY privacy assessment. Notice: proper data classification, concrete legal basis, specific code references, clear deletion support verification.

---

# Privacy Assessment

## Feature: User Profile Update (displayName, avatarUrl, notificationPreferences)
## Assessment Date: 2026-05-17
## Produced by: Agente07_DevSecOps v1.0.0
## Overall Privacy Status: COMPLIANT

---

## Data Classification Summary

**Highest Classification Tier:** CONFIDENTIAL

| Entity | Type | Classification | PII Fields | Regulatory Obligations |
|--------|------|---------------|-----------|----------------------|
| User.displayName | FIELD | CONFIDENTIAL | displayName (full name — directly identifying) | LGPD Art. 5(I); GDPR Art. 4(1) |
| User.avatarUrl | FIELD | CONFIDENTIAL | avatarUrl (indirectly identifying via image hosting URLs) | LGPD Art. 5(I) |
| User.notificationPreferences | FIELD | CONFIDENTIAL | preferences (behavioral data, indirectly identifying) | LGPD Art. 5(I) |
| User.id | FIELD | INTERNAL | none | None |
| User.email | FIELD | CONFIDENTIAL | email (directly identifying — stored by NextAuth, read-only in this feature) | LGPD Art. 5(I); GDPR Art. 4(1) |
| audit_log (profile update entries) | TABLE | INTERNAL | actorEmail (session-sourced, controlled) | None beyond standard data handling |

**No RESTRICTED data entities found.** Human sign-off is not required at this tier.

---

## Legal Basis for Data Processing

| Data Category | Processing Activity | Legal Basis | Documented In | Status |
|--------------|---------------------|------------|--------------|--------|
| User.displayName | Profile display, personalization | CONTRACT (service agreement — user agreement to use the product) | `docs/terms-of-service.md` §4.2 | ✅ PASS |
| User.avatarUrl | Profile display, UI personalization | CONTRACT (same) | `docs/terms-of-service.md` §4.2 | ✅ PASS |
| User.notificationPreferences | Notification delivery | CONTRACT + CONSENT (explicit opt-in in onboarding) | `docs/privacy-notice.md` §3.1; `UserConsent` model in `prisma/schema.prisma` | ✅ PASS |

**Status:** ✅ PASS — All CONFIDENTIAL data has documented legal basis.

---

## Data Minimization Assessment

**Fields collected by the User Profile Update feature:**
| Field | Purpose | Necessary? | Verdict |
|-------|---------|-----------|---------|
| displayName | User-facing name in UI | YES | ✅ Necessary |
| avatarUrl | User-selected avatar image | YES | ✅ Necessary |
| notificationPreferences | Control notification delivery | YES | ✅ Necessary |

**Zod input schema (from `features/user-profile/actions/update-profile.action.ts`):**
```typescript
const UpdateProfileInputSchema = z.object({
  displayName: z.string().min(1).max(100).optional(),
  avatarUrl: z.string().url().optional(),
  notificationPreferences: z.object({
    emailDigest: z.boolean(),
    reminderAlerts: z.boolean()
  }).optional()
}).strict(); // .strict() prevents any additional fields
```

No unnecessary fields are collected. `.strict()` ensures no undeclared fields are accepted.

**Status:** ✅ PASS

---

## Consent Assessment

- **Consent required:** YES (notificationPreferences — opt-in)
- **Consent mechanism:** Explicit opt-in at onboarding step 3 (`/onboarding/notifications`), recorded in `UserConsent` table
- **Consent stored:** YES — `UserConsent` model with `userId`, `consentType: "notification_preferences"`, `consentedAt: DateTime`, `consentVersion: "v2.1"`
- **Consent withdrawal supported:** YES — user can disable all notifications in profile settings; this updates `notificationPreferences` and the `UserConsent` withdrawal is logged

**Status:** ✅ PASS

---

## Data Deletion (Right to Erasure) Assessment

- **Deletion required:** YES (CONFIDENTIAL data stored on user records)
- **Deletion mechanism:** When a user account is deleted, CASCADE DELETE on `User` model removes all associated records including the `User` record itself with all CONFIDENTIAL fields
- **Prisma cascade configured:** YES

**Prisma schema verification:**
```prisma
// prisma/schema.prisma
model Task {
  userId String
  user   User   @relation(fields: [userId], references: [id], onDelete: Cascade)
  // ...
}

model AuditLog {
  // Note: AuditLog does NOT cascade-delete — intentionally retained for compliance records
  // CONFIDENTIAL fields in AuditLog: only actorEmail (from session) — not User.displayName
}
```

**Note:** AuditLog entries are intentionally not cascade-deleted (tamper-evident audit trail). AuditLog does not contain User.displayName or other CONFIDENTIAL content — only `actorEmail` from session, which is the CONFIDENTIAL field retained for audit purposes. This is documented in the privacy notice.

- **Soft delete or hard delete:** Profile fields: hard delete (row removed). AuditLog: retained (lawful basis: legitimate interest in audit trail integrity — documented in privacy notice §5.1)

**Status:** ✅ PASS

---

## Third-Party Data Sharing Assessment

- **Third-party sharing:** YES (avatar URLs may point to third-party image hosting)

| Third Party | Data Shared | DPA in Place | DPA Reference |
|------------|------------|-------------|--------------|
| Supabase (database provider) | All user data in PostgreSQL | YES | Supabase DPA — `docs/vendor-dpa/supabase-dpa.pdf` |
| Vercel (application hosting) | Request logs, session cookies | YES | Vercel DPA — `docs/vendor-dpa/vercel-dpa.pdf` |
| User-selected image host (avatar URL) | No data is SENT — only a URL is stored. User controls the image host. | N/A | User's own choice of image hosting |

**Status:** ✅ PASS

---

## Logging Privacy Assessment

| Log Type | Call Site | Fields Present | PII Found | Status |
|----------|-----------|---------------|-----------|--------|
| audit_log | `update-profile.action.ts:28` | actorId (session.user.id), actorEmail (session.user.email), action ("user.update_profile"), entityType ("User"), entityId (userId), metadata.fieldsUpdated | NO — metadata contains only field names (`["displayName"]`), not values | ✅ PASS |
| console.error | `update-profile.action.ts:45` | String(error) only | NO | ✅ PASS |

**Specific audit_log metadata (actual logged content):**
```typescript
metadata: {
  fieldsUpdated: Object.keys(parsed.data).filter(k => parsed.data[k] !== undefined)
  // Output: ["displayName", "avatarUrl"] — field names only, never values
}
```

**Status:** ✅ PASS

---

## Privacy Findings

> No privacy findings identified. Implementation is privacy-compliant.

---

## Human Escalation Assessment

**Human sign-off required:** NO

No RESTRICTED data identified. No cross-border data transfers beyond Supabase and Vercel (both with DPAs). No ambiguous regulatory obligations.

---

## Privacy Assessment Sign-off

- [x] Data classification complete for all entities
- [x] Legal basis documented for all CONFIDENTIAL processing
- [x] Data minimization verified — no unnecessary fields collected
- [x] Consent mechanism implemented (notificationPreferences)
- [x] Deletion support configured (CASCADE DELETE on User model)
- [x] Third-party DPAs verified (Supabase, Vercel)
- [x] No PII in audit_log or sync_log
- [x] No human escalation required
