# Power BI Report Delivery Checklist

## Data Preparation

- [ ] Source connection mode selected: Import, DirectQuery, or Direct Lake.
- [ ] Credentials and privacy levels documented.
- [ ] Data profiling completed for key columns.
- [ ] Nulls, unexpected values, and import errors handled.
- [ ] Fact and dimension tables identified.
- [ ] Query load configured for staging/helper queries.

## Semantic Model

- [ ] Star schema or justified alternative documented.
- [ ] Relationships, cardinality, and filter direction reviewed.
- [ ] Date table defined when time intelligence is used.
- [ ] DAX measures mapped to metric definitions.
- [ ] Performance risks checked with unnecessary rows/columns, granularity, slow measures, relationships, and visuals.

## Report and Dashboard

- [ ] Audience and decision supported stated.
- [ ] Visuals selected for the analytical question.
- [ ] Filters, slicers, interactions, and navigation specified.
- [ ] Tooltip, drillthrough, export, mobile, and accessibility behavior specified.
- [ ] Empty/error/loading/stale-data states documented.

## Workspace and Security

- [ ] Workspace and item access documented.
- [ ] Semantic model permissions documented.
- [ ] RLS roles and group mappings documented and testable.
- [ ] Sensitivity labels documented.
- [ ] Refresh schedule, gateway need, subscriptions, alerts, and distribution method documented.
