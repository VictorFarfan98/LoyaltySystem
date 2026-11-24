# C10 — Implementation Plan

**Status:** Roadmap approved as sequencing; exact task prompts follow repository inspection.  
**Purpose:** Full MVP roadmap. Detailed R04 task files are authored for the next milestone only after verifying the actual checkout and implementation patterns.

## Milestones

| ID | Layer | Outcome | Dependencies / rules | Blocking OPEN items |
|---|---|---|---|---|
| P00 | Repository/design | Inspect checkout; settle scaffold versions/CI ownership; install canonical docs and create minimal runnable foundation only after reading AGENTS and standards | C00, C03, §25 scaffold proposals | OPEN-010 |
| P01 | Database | Business, branch, staff membership, roles, program versions, customer, pass credential, core constraints/RLS/fixtures | C02, C04, C06, C09 | OPEN-002, OPEN-005 |
| P02 | Database | Atomic pass enrollment, authorized pass lookup, record-stamp and reward issuance operations with audit/idempotency | C02, C05, C06 | OPEN-002, OPEN-007 |
| P03 | Server | Auth/bootstrap, DTOs, Controllers/Services/Repositories/Route Handlers and stable error mapping for P01/P02 | C05, C06, engineering standards | P01/P02 |
| P04 | UI | Owner onboarding, branch/staff/program setup, customer enrollment QR/link, wallet pass add flow, branding preview | C01, C08, C14 | OPEN-001, OPEN-005, OPEN-011 |
| P05 | UI + server | Phone-first authenticated staff scan/lookup/verify/confirm-stamp/redeem flow | C02, C05, C06, C08 | P02/P03; OPEN-001 for live Wallet issue |
| P06 | Database + server + UI | Owner/manager reports, Marketing aggregate read-only reports, duplicate-same-day review, audit view | C06, C07, C08 | OPEN-004 |
| P07 | Wallet integration | Apple Wallet and Google Wallet issuance/update lifecycle, business-owned account setup and support handover | C01, C04, C06, C14 | OPEN-001 |
| P08 | Pilot readiness | Cross-tenant/security review, responsive end-to-end acceptance, onboarding checklist, privacy/retention and pricing pilot plan | C01, C03, C06, C09 | OPEN-003, OPEN-006, OPEN-008, OPEN-009 |

## Thin-slice order

Build one complete business/branch path first, then broaden tenant/branch/report handling. Keep every mutation safe and auditable from the first database operation. Wallet issuance can use provider sandbox/test configuration while account dependencies are resolved; do not fake production Wallet status.

## Task prompt policy

Per `03_HOW_TO_USE_THIS_TEMPLATE.md`, do not pre-write later milestone prompts. First inspect the actual repository, current dependencies, and relevant patterns. Then create the next milestone's R04 task file with exact files, rule IDs, commands, acceptance cases, and model recommendation. Separate database, server, and UI work once the first pattern exists. No application code is authorized by this roadmap alone.

## Change and verification budget

Each task should make the minimum complete, maintainable change needed for its outcome. Reuse verified patterns; do not introduce speculative abstractions, dependencies, unrelated refactors, or generalized features. Choose the least costly credible verification for the affected behavior. Assign each business assertion one primary test layer, avoid duplicate unit/integration/browser coverage and snapshot-heavy tests, and run relevant checks once. Documentation-only work does not require an application build. Preserve focused tests for cross-tenant and branch authorization, RLS, atomic event/progress/reward/audit behavior, idempotency, correction rules, and the critical customer/staff workflow. Task reports state the evidence and any checks not run.

## Milestone gates

- Database gate: RLS/RPC negative cases pass, including cross-tenant and unauthorized role/branch.
- Mutation gate: atomic event/progress/reward/audit behavior and idempotency are verified.
- UX gate: primary staff flow works on supported phones with camera and manual fallback.
- Wallet gate: account ownership/access documentation and pass update behavior verified with each provider.
- Pilot gate: owner accepts branding preview, business setup, reports, support and pricing terms.
