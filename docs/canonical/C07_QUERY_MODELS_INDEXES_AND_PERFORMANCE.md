# C07 — Query Models, Reports, and Performance

**Status:** MVP read models approved. Exact indexes are finalized with migrations and measured queries.  
**Purpose:** Own query projections, report semantics, filters, and bounded reads.

## Staff pass lookup

Lookup is by opaque pass token and authenticated staff context. Return a bounded projection:

- Customer display name and status.
- Current stamp count and configured goal.
- Available reward summary and redemption status.
- Small recent event list if useful for duplicate verification.
- Current program name and relevant expiration status.

Do not return phone/email unless a later workflow has a concrete need. A lookup is not a mutation and must be tenant/branch authorized.

## Owner/manager dashboard and reports

Required report read models:

1. **Branch activity:** stamps issued and rewards redeemed by branch and Guatemala-local date range.
2. **Program overview:** active enrolled customers, stamps issued, rewards earned, and rewards redeemed for selected period.
3. **Potential duplicate review:** same customer with two or more stamp events on one Guatemala-local business date. Show event time, staff, branch, and count. This is a review signal only; no event is blocked or auto-voided.
4. **Customer activity detail:** available only to owner/manager/operational workflow as needed, not Marketing report role.

Default filters: date range and branch; no exact total count unless a visible screen needs it. Paginate potentially unbounded activity with stable order and an ID tiebreaker. Query date windows using explicit local-date boundaries converted to instants; use `America/Guatemala`.

## Marketing report scope

Marketing/Social Media Manager can view business-wide aggregates and branch/date comparison. By default, reports contain no customer-level identifiers, phone/email, exports, or ability to scan a pass. This is intentionally read-only and validated in pilot (OPEN-004).

## Search and pagination

- Customer search is business-scoped, starts at two characters, debounced around 300 ms, bounded, and returns only operationally necessary fields.
- Use deterministic OFFSET/LIMIT with stable ordering per reusable standards until actual volume justifies cursor pagination.
- Request page and pageSize; return items, page, pageSize, and hasNextPage. Avoid total count by default.
- Pass lookups are point queries by token hash and must use an index/unique constraint.
- No polling or realtime subscription is needed for MVP; after a mutation, refetch the active primary read model.

## Index intent

Plan indexes for:

- business and active status on tenant-owned lists;
- customer normalized phone within business, subject to duplicate review behavior;
- pass token hash unique lookup;
- stamp events by business/customer/time, branch/time, and business-local reporting windows;
- reward issuance by business/customer/status;
- reward redemptions by branch/time;
- staff membership by user/business/active status and branch assignment.

Validate actual plans with realistic fixture sizes before adding speculative indexes. Same-day duplicate detection is aggregation/reporting, not a uniqueness rule.
