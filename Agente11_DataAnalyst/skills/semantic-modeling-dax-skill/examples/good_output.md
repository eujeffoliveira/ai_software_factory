# Good Output

## Semantic Model Spec Summary

Storage mode: Direct Lake with documented fallback to DirectQuery for unsupported operations.

Tables:

- FactSales: fact, grain = one order line.
- DimDate: role-playing date dimension for order and ship dates.
- DimCustomer: dimension, grain = one customer.
- BridgeCustomerSegment: bridge, justified for many-to-many segment membership.

Measures:

- `[Revenue]` maps to MET-001 and uses `SUM(FactSales[NetAmount])`.
- `[Revenue YoY %]` maps to MET-004 and requires approved date table.

Security:

- RLS by region and OLS for margin columns.
- PBIP and deployment pipeline required for lifecycle.
