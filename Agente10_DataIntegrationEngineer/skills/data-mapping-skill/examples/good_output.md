# Good Output: data-mapping-skill

See `examples/good_data_mapping.md` for the full example.

Key properties of correct output:
- All external fields accounted for (mapped or explicitly dropped with reason)
- Bidirectional mapping produced (Source→Target AND Target→Source)
- Field Ownership Table present for bidirectional integration
- PII fields classified and flagged
- Computed field formulas explicit
- Zod schema requirements with `.passthrough()`
- Data lineage section complete
- Every field has a requirement_source reference
