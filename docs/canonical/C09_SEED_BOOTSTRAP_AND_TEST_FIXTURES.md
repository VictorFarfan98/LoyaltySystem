# C09 — Seed, Bootstrap, and Test Fixtures

**Status:** Bootstrap and fixture approach approved.  
**Purpose:** Separate system reference data, business provisioning, and disposable tests.

## System reference data

No domain catalog is required for MVP. Role codes and stable system error codes may be seeded deterministically by migrations or application constants, with one authoritative definition and generated typing where applicable. Do not seed fake real businesses as production data.

## Business bootstrap / production onboarding

Provision each business through an authorized server-side onboarding flow or controlled operator process:

1. Create the business and initial owner membership.
2. Create branches and optional staff memberships/branch assignments.
3. Create the initial program version and branding draft.
4. Verify owner access, staff roles, branch context, and report scope.
5. Complete Apple/Google Wallet account and pass configuration using the business's own accounts and documented authorization.
6. Publish the branded pass only after the business reviews the preview.

Do not use production database dumps as local development seeds.

## Development/test fixtures

Use deterministic disposable fixtures in local Supabase for:

- Business A: four branches (Skin Solutions-like scenario).
- Business B: one branch (Glossing-like scenario).
- Owner, manager, branch staff with one or more branches, and Marketing role with no branch assignment.
- Customers with no stamps, partial progress, goal reached, reward redeemed, optional-expiry scenarios, and multiple same-day stamps.
- Cross-tenant users/data and inactive branch/customer cases for denial tests.
- Idempotent replay and failed-transaction rollback cases.

Fixtures must contain synthetic names, phones, emails, and tokens only. Use deterministic non-production pass tokens in test environments; production token generation uses cryptographically secure randomness. Keep Wallet provider credentials out of fixtures.

## Test ownership

- pgTAP owns constraints, RLS, authorization denial, RPC atomicity, idempotency, progress/reward derivation, and rollback.
- Vitest owns Services, Controllers, DTO mapping, API error mapping, and pure helpers.
- Playwright owns phone-responsive enrollment/scan/confirm/redeem and role-limited report workflows.
- Include cross-tenant, inactive user, missing role, invalid branch, Marketing mutation denial, QR lookup without auth, and duplicate same-day allowed/reportable acceptance cases.
