# Task: P01 — Tenant and loyalty data foundation

**Model:** gpt-6.2-astra (effort: high) · **Escalate to:** user review. This is the first tenant/branch authorization and RLS reference, with no existing SQL pattern to copy.

Follow AGENTS.md. This task authorizes only the local database scope below, not deployment, remote migration, or Git actions.

## Read

- `docs/canonical/C00_PRECEDENCE.md`; C02 core lifecycle and loyalty rules; C03 DEC-001–003, DEC-005–006, DEC-018–021, OPEN-002/005/010; C04 entity map, structural integrity and deactivation; C06 authentication, roles, authorization and pass security; C09 fixtures and test ownership; C10 P01.
- `docs/reusable/00_ENGINEERING_STANDARDS.md` §§7–8, 20–23, 25; `docs/reusable/04_CODEX_TASK_PROMPT_TEMPLATE.md`.
- `README.md`, `PROGRESS.md`, `supabase/config.toml`, and the actual `supabase/migrations/` and `supabase/tests/` contents. Supabase CLI 3.3.0 is pinned; there are no existing business migrations or database tests to copy.

## Files and boundaries

- Create timestamped SQL migration(s) in `supabase/migrations/` and focused pgTAP SQL tests with disposable synthetic fixtures in `supabase/tests/`; update `PROGRESS.md` and local instructions in `README.md` if needed for the test commands.
- Do not create production seed data, remote links, CI, application/auth UI, enrollment, lookup, stamp, redemption, merge, Wallet, reporting, or other later-milestone operations. Do not change canonical product decisions. Do not add packages unless a concrete need is demonstrated.
- Existing local database state may be valuable: inspect it before any reset. Reset only when it is confirmed disposable; otherwise use a separate disposable local project or stop and report the blocker. Never apply a remote migration.

## Implement

1. Create the minimum schema for business, branch, authenticated staff membership and role/explicit branch scope, program and program versions, customer/contact and pass credential, with lifecycle and relationships required by C04. Decide ordinary SQL names and types from the current environment. Preserve one-business-per-staff MVP, one active program per business, and tenant-consistent relationships using constraints. Represent version terms and allow local development revisions under DEC-022; do not implement loyalty event behavior.
2. Represent the approved contact/consent baseline without making normalized phone unique: marketing consent starts off and is separate, withdrawable, and changes and their times can be preserved. Do not implement enrollment, normalization, duplicate review, or consent UI. Pass credentials use a distinct opaque token hash and lifecycle metadata; do not store raw tokens or use a database primary key as the pass token.
3. Enable RLS for tenant-owned tables, choose explicit grants and policies with deny-by-default behavior, and use the verified caller's active membership and explicit role/branch scope. Do not infer operational permission from a QR token or a null branch assignment. Marketing has no operational customer or pass access; all-branch scope must be explicit as C06 requires. Keep the domain tables private. Provide scoped branch reads through the repository-facing RPC in DEC-023. Application endpoints belong to the server milestone. Do not expose credential hashes to untrusted callers. If security-definer helpers are necessary, secure their search path, ownership and grants and test them.
4. Add synthetic, disposable pgTAP fixtures and focused tests as the authoritative layer for the schema and RLS boundaries. Cover at least two businesses, active and inactive memberships and branches, owner, scoped manager, branch staff, Marketing, and unauthenticated callers. Preserve historical references on deactivation. No real customer data or provider credentials.

## Required acceptance cases

- Correct tenant references succeed; cross-business branch, membership, program, customer, and pass relationships are rejected. One staff identity cannot belong to multiple businesses in MVP; at most one active program exists per business.
- A valid active member can access only data explicitly permitted by the implemented policies; unauthenticated, inactive, cross-tenant, missing-role, and unassigned-branch access is denied. Test both reads and direct writes as applicable, including attempted tenant/branch changes and privilege escalation. Marketing cannot access operational customer/pass data or mutate operational data; null branch scope is not a blanket grant.
- Invalid pass/customer/program cross-tenant combinations fail, raw token possession never grants access, and credential hashes are not exposed through unauthorized direct reads. Duplicate normalized phone numbers within a business remain possible. Consent defaults off and its change history/time can be retained.
- Program-version terms can be revised in disposable MVP fixtures (DEC-022); deactivation prevents new authorized use without deleting historical references. Do not create placeholder event, rollback, or idempotency tests for P02 functionality that does not exist yet.

## Verification (run all listed)

- Start local Supabase with `pnpm exec supabase start`; verify the target is local and disposable before any reset. Apply the new migrations locally using the appropriate local Supabase CLI command and run `pnpm exec supabase test db`; ensure the pgTAP tests actually execute and pass. Run `pnpm exec supabase db lint --local` if supported by the pinned CLI; otherwise document the exact limitation. Stop the local stack after checking without affecting other projects.
- Review migration and test files for grants, RLS, secret exposure, tenant foreign keys, and synthetic data; run `git diff --check` and review all changed and untracked files. Do not run unrelated application builds for SQL-only changes.

## Done when

The local schema and all named acceptance cases pass, with no remote changes. Record exact commands and outcomes, migration/fixture impacts, and any blockers in `PROGRESS.md`. CI and remote migration ownership remain open; local checks are not CI or release acceptance. The user chooses when to commit. Report changed files, checks, blockers, and a suggested commit.
