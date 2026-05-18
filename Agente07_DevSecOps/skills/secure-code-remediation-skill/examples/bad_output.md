# Bad Output — Secure Code Remediation Skill

**Vague remediation without specific code:**

SEC-001: "Add authentication to the route. Make sure to check the session before proceeding."

**Problems:** No file path, no line number, no wrong_pattern showing the actual code, no correct_pattern showing the exact fix. A Dev agent receiving this cannot implement the fix without understanding what exactly needs to change. DR014 requires: exact file:line, wrong pattern (quoted from source), and correct pattern (concrete replacement).
