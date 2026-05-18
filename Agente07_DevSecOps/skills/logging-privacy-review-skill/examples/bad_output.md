# Bad Output — Logging Privacy Review Skill

**HIGH finding missed:**

`features/user-profile/actions/update-profile.action.ts:38`:
```typescript
await prisma.auditLog.create({
  data: {
    actorId: session.user.id,
    actorEmail: userInput.email, // WRONG — from user input, not session!
    action: "user.update_profile",
    metadata: {
      newDisplayName: userInput.displayName, // WRONG — raw PII value logged!
      newAvatarUrl: userInput.avatarUrl       // WRONG — URL (potentially PII)
    }
  }
});
```

This is a HIGH finding (DR005, BLOCKED_PRIVACY_VIOLATION): (1) actorEmail sourced from user input instead of session; (2) raw PII values in metadata. The review failed to detect both violations.
