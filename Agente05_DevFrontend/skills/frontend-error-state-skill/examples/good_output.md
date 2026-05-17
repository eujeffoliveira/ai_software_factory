# Good Output: frontend-error-state-skill

```json
{
  "file_path": "app/entities/error.tsx",
  "is_client_component": true,
  "exposes_error_message": false,
  "has_reset_button": true,
  "has_role_alert": true,
  "logs_internally": true
}
```

The file: (1) has `"use client"` first line, (2) logs `error.digest` to console (not `error.message`), (3) displays "Something went wrong" with generic description, (4) has a "Try again" button calling `reset()`, (5) wrapper has `role="alert"`.
