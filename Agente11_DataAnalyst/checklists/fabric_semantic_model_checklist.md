# Fabric Semantic Model Checklist

- [ ] Business questions and metric contracts are approved.
- [ ] Storage mode is explicit: Import, DirectQuery, Direct Lake, composite, or large model.
- [ ] Direct Lake fallback and refresh behavior are documented when applicable.
- [ ] Star schema is implemented or deviation is justified.
- [ ] Bridge and many-to-many relationships are justified and tested.
- [ ] DAX calculations use variables and filter context intentionally.
- [ ] Calculation groups, dynamic format strings, and field parameters are justified.
- [ ] Incremental refresh is specified when model size or refresh time requires it.
- [ ] Performance checks cover DAX, visuals, relationships, storage settings, and query behavior.
- [ ] Workspace/item/model access and RLS/CLS/OLS requirements are documented.
- [ ] Sensitivity labels and downstream dependencies are documented.
- [ ] PBIP, deployment pipeline, XMLA, or reusable template assets are specified when lifecycle management matters.
- [ ] AI/Copilot readiness includes clear names, descriptions, relationships, measures, and business vocabulary.
