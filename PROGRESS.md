# Project progress

**Current status:** P01 database foundation implemented and verified locally on 2026-11-24. The first tenant/branch RLS design is ready for user review.

## P00 verification

- Node 26.3.1, pnpm 10.34.5 and exact package versions are pinned; compatibility evidence is in README.
- `pnpm install --frozen-lockfile`, `pnpm lint`, `pnpm typecheck`, `pnpm format:check`, and `pnpm build` passed.
- Local Supabase started on the configured 5532x ports, `pnpm exec supabase status` passed, and `pnpm exec supabase stop` stopped it. The default database port was already occupied. Migration and test directories exist and contain no business SQL; no seed or fixtures were added.
- `pnpm dev` served the root page with HTTP 200 and was stopped. The user visually verified the shell at phone width on 2026-11-24.
- No remote linkage, migrations, deployment, or CI run. The user chooses when to commit unless they say otherwise. CI/remote migration ownership remains open (C03 OPEN-010); local checks do not establish release acceptance.
- The user approved OPEN-002 and OPEN-005 defaults on 2026-11-24 (DEC-018–021). Remaining wording, merge mechanics and inactivity timeout belong to later workflows and do not block local P01.

## P01 local verification

- Supabase CLI `3.3.0`. `pnpm exec supabase start` started the LoyaltySystem stack. Before migration, local PostgreSQL 17.12 had zero Auth users and no tables in `public` or `loyalty`. The task used the existing volume without a reset.
- `pnpm exec supabase migration up --local` applied `20261124000100_loyalty_foundation.sql` to `127.0.0.1:55322`. It creates nine tables with RLS, composite tenant references and one direct staff read policy for explicitly authorized active branches. Contact lives on the customer, with timestamped consent changes and separate hash-only pass credentials.
- `pnpm exec supabase test db` passed one file and all 43 current pgTAP assertions. Cases include cross-tenant constraints, branch and role restrictions, direct write denial, credential isolation, consent changes, program versions and deactivation. A follow-up local catalog/data check confirmed the migration version and zero rows in Auth users and all nine foundation tables after rollback. No seed data.
- Following DEC-022, `pnpm exec supabase migration up --local` applied `20261124000200_allow_development_version_edits.sql` to the same local stack. It removes the version-edit trigger and function without changing data or privileges. The fixture suite now verifies an in-place term revision. C10 tracks enforcement for live versions before production.
- `pnpm exec supabase db lint --local` reported findings only in installed pgTAP extension functions, including references to session-local test tables. It reported none in the application schemas (`loyalty` and `public`). `pnpm exec supabase stop` stopped only LoyaltySystem and preserved its volume.
- Reviewed the P01 SQL, grants and changed-file inventory. `git diff --check` and whitespace checks on the P01 SQL files passed. Application builds and browser tests were outside this SQL-only task. No commit, CI, deployment or remote migration. CI and remote migration ownership remain open under OPEN-010.

## Next action

Review the P01 migration and pgTAP suite in this chat. After acceptance, use the verified database foundation to scope the P02 task under C10.
