# New Project Domain Discovery Checklist

**Purpose:** Start a new application without re-discussing cross-project engineering conventions. Use `00_ENGINEERING_STANDARDS.md` as the default technical baseline and focus discovery on the new domain.

---

## 1. Product boundary

- What problem does the product solve?
- Who is the paying/customer organization?
- What is explicitly MVP vs post-MVP?
- Is the product single-tenant, multi-tenant SaaS, or one internal organization?
- What geographic/language/currency/timezone assumptions matter?

## 2. Actors and authorization

For each actor:

- what may they see?
- what may they create/update/cancel/void?
- what locations/branches may they operate in?
- what actions are privileged enough to require a reason/audit record?
- which roles are defaults vs composable permission sets?

Decide whether users belong to one organization or may switch among several under one identity.

## 3. Locations/branches

- Does the organization have branches/clinics/stores?
- Which entities belong to the organization vs a physical location?
- Which operational records must retain location provenance?
- What happens when a location becomes inactive?

## 4. Core entities and ownership

List the longitudinal/root entities first, then dependent records.

For each entity decide:

- owner (`tenant_id`, branch, user, customer, etc.);
- identity/uniqueness;
- mutable vs historical fields;
- soft delete / inactive / void semantics;
- important foreign-key consistency constraints.

## 5. Workflows and states

For each major workflow:

- allowed states;
- valid transitions;
- who can transition;
- whether transition is reversible, cancelable, voidable, or corrected with a replacement record;
- whether transition must be atomic with related records;
- warnings that allow explicit override;
- concurrency/idempotency requirements.

## 6. Scheduling/appointments

If applicable:

- what is being scheduled (person, pet, resource, professional, room)?
- branch/location attribution;
- duration rules;
- overlap rules;
- business-hours rules;
- resource assignment;
- check-in/arrival/no-show/cancel behavior;
- recurring scheduling/reminders deferred or included;
- Day/Week/Month calendar needs.

## 7. Customer/patient/owner profiles

- minimum record required for quick creation;
- duplicate detection keys;
- organization-wide vs branch-local identity;
- contact/consent fields;
- related entities (pets, dependents, vehicles, etc.);
- historical record expectations.

## 8. Domain records

Identify domain-specific records and separate concepts that should not be collapsed merely because their UI looks similar.

Examples:

- observation vs planned action vs completed action;
- quote vs charge vs payment;
- coupon vs discount application;
- current state vs historical event;
- external/pre-existing record vs work performed inside the system.

## 9. Financial model

If money exists, decide before schema implementation:

- catalog/default prices;
- price snapshots;
- discounts/coupons/promotions;
- taxes;
- charges/invoices;
- payments;
- partial payments;
- credits/refunds;
- allocation rules;
- void/correction behavior;
- attribution/reporting dimensions;
- whether payments can exist before/without charges.

Avoid implementing a signed balance number as the source of truth when a ledger model is appropriate.

## 10. Coupons/promotions

If applicable:

- fixed vs percentage;
- validity windows;
- per-customer/per-pet/single-use/global usage;
- branch restrictions;
- service/category restrictions;
- stacking rules;
- minimum spend;
- usage ledger/history;
- QR/UUID representation;
- reservation vs redemption timing.

## 11. Documents/media

- required file types;
- upload size limits;
- private vs public;
- relation to domain records;
- camera/mobile upload needs;
- signatures;
- before/after media;
- signed-URL access model;
- deletion/retention rules.

## 12. Read models/pages

Define the actual pages/workspaces and what question each answers.

For each page:

- primary user/goal;
- filters;
- core read model;
- primary actions;
- lazy sections;
- pagination;
- refresh behavior;
- responsive behavior;
- required warnings/empty states.

Create lightweight ASCII implementation blueprints for the most important pages.

## 13. Search/pagination/performance

- which feeds can grow without bound?
- expected row counts in first years;
- common filters/sorts;
- autocomplete needs;
- date-bounded queries;
- likely indexes;
- expensive joins/aggregations;
- whether exact totals are necessary.

Use the engineering template's OFFSET/default request-minimization rules unless the domain volume justifies a different choice.

## 14. Settings vs permissions vs entitlements

Keep separate:

```text
permission  → may this user do it?
setting     → how does enabled behavior work?
entitlement → does this customer/plan have the capability? (only if SaaS plans need it)
```

List typed settings rather than creating a generic arbitrary configuration bag.

## 15. Audit/corrections

Identify:

- actions that require durable audit events;
- records that become immutable when finalized;
- addendum/correction/replacement behavior;
- what `void` means vs `delete` vs `cancel` vs `resolved`;
- what historical provenance must survive later edits.

## 16. Integrations

For every external integration:

- who owns credentials;
- webhook verification/idempotency;
- retry semantics;
- sync vs async requirement;
- failure/compensation behavior;
- rate limits;
- what data may be logged;
- whether integration is MVP or deferred.

## 17. Bootstrap/reference/test data

Separate:

```text
system reference data
Tenant/customer bootstrap data
development/test fixtures
```

Never use production dumps as the default local seed strategy.

## 18. Pilot defaults and unresolved external facts

For every question, classify it as:

```text
locked architecture/product decision
safe MVP default + configurable
requires customer go-live data
validate after pilot usage
external dependency/equipment unknown
```

Do not leave something as an ambiguous “open question” if a safe default can be chosen now.
