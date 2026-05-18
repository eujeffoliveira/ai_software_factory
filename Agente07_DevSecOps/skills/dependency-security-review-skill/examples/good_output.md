# Good Output — Dependency Security Review Skill

```json
{
  "status": "MEDIUM_CVE_FOUND",
  "packages_reviewed": 47,
  "lock_file_present": true,
  "vulnerabilities": [
    {
      "finding_id": "SEC-004",
      "package": "xml2js",
      "version": "0.4.19",
      "cve": "CVE-2023-0842",
      "cvss_score": 5.3,
      "severity": "MEDIUM",
      "decision_rule": "DR007",
      "remediation": "Upgrade xml2js to >= 0.5.0: npm install xml2js@latest",
      "is_dev_dependency": false
    }
  ]
}
```

MEDIUM finding — gate not blocked but tracked for remediation. Status HIGH_CVE_FOUND or CRITICAL_CVE_FOUND would require gate block.
