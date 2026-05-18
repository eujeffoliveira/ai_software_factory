# Bad Output — Dependency Security Review Skill

**Incorrect CLEAN status despite HIGH vulnerability:**
```json
{ "status": "CLEAN", "packages_reviewed": 12 }
```

`lodash@4.17.15` (CVSS 7.4 — Prototype Pollution, CVE-2020-8203) is present in package.json but was not caught because only `npm audit` was checked and the advisory was not in the npm database at the time. The dependency review must also check the NVD/GitHub Advisory Database for packages known to have historical CVEs. This should have been `HIGH_CVE_FOUND` triggering a HIGH finding (DR007).
