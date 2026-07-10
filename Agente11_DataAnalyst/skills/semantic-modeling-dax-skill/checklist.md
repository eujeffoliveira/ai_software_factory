# Semantic Modeling and DAX Checklist

- [ ] Metric contracts are approved before model design.
- [ ] Storage mode is explicit.
- [ ] Every table has type and grain.
- [ ] Star schema is used or deviation is justified.
- [ ] Bridge and many-to-many relationships are justified.
- [ ] Relationship cardinality and filter direction are documented.
- [ ] Measures map to metric IDs.
- [ ] DAX caveats around filter context and time intelligence are documented.
- [ ] Direct Lake fallback and refresh behavior are documented when applicable.
- [ ] Incremental refresh, large model, aggregations, or composite model needs are specified.
- [ ] RLS/CLS/OLS and sensitivity labels are documented.
- [ ] PBIP, deployment pipeline, XMLA, and downstream dependencies are documented when relevant.
