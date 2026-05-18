# Bad Output: data-mapping-skill

See `examples/bad_data_mapping.md` for the full example.

Key violations in bad output:
- External `id` mapped to internal `id` (overwrites PK)
- Fields silently dropped without documentation
- No transformation type or formula for enum fields
- No reverse mapping for bidirectional integration
- No Field Ownership Table
- No PII classification (LGPD violation)
- No data lineage section
