# C03 — Decisions and Open Items

**Status:** Approved decisions captured from discovery and design-summary approval.  
**Purpose:** Provenance ledger for decisions and the single register of unresolved product or external questions. Owning docs contain the complete rule.

## Decision ledger

| ID | Decision | Status / provenance | Owning rule |
|---|---|---|---|
| DEC-001 | Each business is a separate tenant; one shared program across that business's branches. | DECIDED — user approved design summary | C01, C02 |
| DEC-002 | Staff accounts belong to one business and may have optional branch assignment. | DECIDED — user clarified 2.7 | C06 |
| DEC-003 | Add a business-level Marketing/Social Media Manager role with report access and no branch assignment. | DECIDED — user clarified 2.6 and 6.24; recommendation accepted | C06, C07 |
| DEC-004 | Mobile staff web app is primary; no tablet required. | DECIDED — user supplied product brief | C01, C08 |
| DEC-005 | Authenticated staff explicitly confirm every stamp and reward redemption; server is authoritative; keep full staff/branch provenance. | LOCKED — user supplied security constraint | C02, C05, C06 |
| DEC-006 | Customer pass uses a reusable opaque identifier for app lookup only; no mutation authority. | DECIDED — user clarified 3.12; security recommendation accepted | C02, C06 |
| DEC-007 | Enrollment supports printed QR and shareable link, with QR prioritized. | DECIDED — user clarified 3.11 | C01, C08 |
| DEC-008 | A visit earns one manual staff-confirmed stamp; same-day duplicates are allowed and reportable, not blocked. | DECIDED — user clarified 4.14–4.15 | C02, C07 |
| DEC-009 | Program expiration is optional and disabled by default; if enabled, expire only incomplete stamp balances after inactivity; earned rewards remain valid until redeemed. | ASSUMED SAFE DEFAULT — user's approval of design summary; precise scope selected to make rule implementable | C02; validate in pilot (OPEN-003) |
| DEC-010 | MVP passes have no branch label; provide a pass preview. | DECIDED — user clarified 5.19 and 5.21 | C01, C08, C14 |
| DEC-011 | Skin Solutions and Glossing have equal pilot priority. | DECIDED — user clarified 7.28 | C01, C10 |
| DEC-012 | Direct monthly price hypothesis is Q299 per branch, plus a setup fee; setup amount remains undecided. | DECIDED HYPOTHESIS — prior user discussion; pilot validation needed | C01, OPEN-006 |
| DEC-013 | Reseller/wholesale pricing and partner tools are excluded from MVP for now. | DECIDED — user clarified latest discovery response; revisit after pilot | C01, C10 |
| DEC-014 | Spanish UX, Guatemala, GTQ and `America/Guatemala` are initial defaults. | ASSUMED SAFE DEFAULT — discovery recommendation accepted | C01, C07 |
| DEC-015 | Wallet pass support targets Apple Wallet and Google Wallet; businesses own/purchase their accounts and setup assistance requires explicit authorization. | DECIDED PRODUCT GOAL; platform enrollment details remain external | C01, OPEN-001 |
| DEC-016 | Marketing reports are read-only aggregate business reports without customer-level export. | ASSUMED SAFE DEFAULT — recommendation accepted | C06, C07; validate in pilot (OPEN-004) |
| DEC-017 | Codex should make the smallest complete maintainable change per task and use focused, non-redundant verification; preserve meaningful security and domain-invariant coverage. | DECIDED — user instruction | AGENTS.md, C10 |
| DEC-018 | Require customer name and mobile number; email is optional. Warn about matching normalized phone numbers within a business; a manager resolves merges while preserving history. Marketing consent is separate and opt-in. | DECIDED — user accepted OPEN-002 default on 2026-11-24 | C02, C04, C06; remaining details in OPEN-002 |
| DEC-019 | An owner/manager creates staff accounts; use password-based sign-in, standard provider recovery, and no public staff registration. | DECIDED — user accepted OPEN-005 default on 2026-11-24 | C06; remaining details in OPEN-005 |
| DEC-020 | Normalize eight-digit Guatemala numbers to `+502` plus the number; accept explicitly international numbers in international format. Compare normalized numbers for a warning, not a uniqueness constraint. Manager-reviewed merges are a later audited operation preserving both records' history. Marketing consent starts off, is separately granted and withdrawable; record changes and their time. | DECIDED — user confirmed defaults on 2026-11-24 | C02, C04, C06; final wording and merge mechanics remain in OPEN-002 |
| DEC-021 | Owners/managers invite staff by email; recipients set their own password. Use provider email recovery, Supabase session/refresh mechanisms, sign-out, and active membership checks on every protected operation. Decide inactivity timeout during authentication implementation. | DECIDED — user confirmed defaults on 2026-11-24 | C06; inactivity timeout remains in OPEN-005 |
| DEC-022 | During pre-production MVP development, the team may revise program terms, rework the schema, and rebuild disposable local data when a better design or approved product change warrants it. This overrides C04’s used-version immutability requirement for development fixtures. Enforce it before the first live stamp or reward. | DECIDED — user clarified during P01 review | C04, C10 pilot gate |
| DEC-023 | The MVP frontend uses application endpoints for loyalty data. Add an endpoint when a workflow needs it. Backend repositories call operation-specific Supabase RPCs with the caller’s session. | DECIDED — user clarified the frontend/backend boundary during P01 review | C06, engineering standards §§3, 7, 13 |

## OPEN register

| ID | Question / dependency | Proposed default | Classification | Owner / timing |
|---|---|---|---|---|
| OPEN-001 | Confirm current Apple Wallet and Google Wallet account/issuer setup requirements, costs, and authorized access workflow. | Each business owns accounts and pays providers directly; document access authorization and exit/handover. Do not centralize ownership. | External dependency/equipment unknown | Validate before pilot go-live |
| OPEN-002 | Detailed merge mechanics and final Spanish enrollment/consent wording. | Baseline in DEC-018 and DEC-020; preserve history and review the privacy notice before production onboarding. | Partially decided / go-live data | Resolve before the respective merge workflow or production onboarding; not a P01 blocker |
| OPEN-003 | Pilot response to optional stamp-balance inactivity expiration. | Default disabled; configure one inactivity duration per program; only incomplete balances expire; earned reward does not expire. | Validate after pilot usage | Pilot review |
| OPEN-004 | Whether Marketing needs narrower branch-filtered reports or customer-level data. | Business-wide aggregate report access only, no PII or exports. | Validate after pilot usage | Pilot review |
| OPEN-005 | Specific session inactivity timeout. | Baseline in DEC-019 and DEC-021; select the timeout after checking the deployment plan and staff workflow. | Partially decided | Resolve during auth implementation; not a P01 blocker |
| OPEN-006 | Setup fee, final direct rate, pilot duration, and what hands-on support includes. | Test Q299/branch/month: Q1,196 for four branches and Q299 for one; quote a one-time setup fee after onboarding scope is known; manually bill during pilot. | Validate after pilot usage / go-live commercial data | Confirm with each pilot |
| OPEN-007 | Exact program setup and changes after launch (goal/reward changes while customers have progress). | Changes apply prospectively to new accruals; preserve old terms with versioned program configuration. | Safe MVP default | Resolve before program-edit implementation |
| OPEN-008 | Business customer data retention, account closure, and legal privacy requirements. | Deactivate rather than hard-delete loyalty records; establish retention/deletion and privacy notice before production onboarding. | Requires customer go-live data / external legal dependency | Before production launch |
| OPEN-009 | Correcting an already redeemed reward. | Preserve history; require owner review and reason; do not silently reverse or erase. No automatic compensating reward in MVP. | Safe MVP default | Resolve before correction workflow |
| OPEN-010 | Exact developer/tool versions and CI/migration ownership at scaffold. | Choose compatible stable releases at repo inspection; record lockfile evidence; follow the engineering baseline and confirm proposed §25 CI/deploy defaults. | External dependency / scaffold decision | Before scaffold |
| OPEN-011 | Brand name, platform brand colors, typography, final visual identity. | Keep app UI neutral and tenant branding isolated to the customer pass until brand assets are supplied. | Requires customer/project brand input | Before polished visual implementation |

No OPEN item authorizes bypassing the locked authentication, server-authority, or provenance rules.
