# Task: P00 — Minimal runnable foundation

**Model:** gpt-6.1-terra (effort: medium) · **Escalate to:** gpt-6.2-astra (high). First application foundation spans app and local database tooling; R04 routes first references to Terra.

Follow AGENTS.md. This task authorizes only its scope, not deployment.

## Read

- `docs/canonical/C00_PRECEDENCE.md`, C03 OPEN-010, C10 P00.
- `docs/reusable/00_ENGINEERING_STANDARDS.md` §§2, 7–8, 20–23, 25; `docs/reusable/04_CODEX_TASK_PROMPT_TEMPLATE.md`.
- `README.md`, `PROGRESS.md`, and the existing canonical documents. No application or test implementation exists to copy.

## Starting state and decisions

The inspected `master` checkout contains the specification pack and reusable sources, but no package manifest, lockfile, app, Supabase project, scripts, CI, or deployment configuration. Canonical docs are already in `docs/canonical/`. Existing untracked files must be preserved. CI ownership, migration runner and approval remain open in C03 OPEN-010 and do not block this local task; do not create CI, apply remote migrations, deploy, or assume ownership. Agree Git and CI ownership before those actions.

Use Next.js App Router, TypeScript, pnpm and local Supabase, with strict TypeScript and ESLint/Prettier. During P00, select exact compatible stable versions for Node LTS, pnpm, Next.js, React and React DOM, TypeScript, ESLint, eslint-config-next, Prettier, Supabase CLI and required type packages. Reinspect the repository first; verify Node LTS from https://nodejs.org/en/about/previous-releases and package releases, engines and peer dependencies from https://registry.npmjs.org/ and official tool documentation. Match Next.js and eslint-config-next versions and React with React DOM; do not assume latest releases are mutually compatible. Record exact versions and source/compatibility evidence in README and configuration, and pin dependencies in the lockfile. Do not introduce UI libraries, auth packages or test runners before they are needed.

## Files

- Create the minimal app, package/runtime and lint/format configuration, secret-free environment example, ignore rules, and local Supabase configuration and migration/test structure required by the implementation; generated paths must match the chosen tools.
- Edit `README.md` for local setup and `PROGRESS.md` for final evidence. Preserve `docs/canonical/` in place.
- Do not change canonical product decisions, business schema, existing reusable sources, deployment settings, or unrelated files.

## Implement

1. Verify prerequisites and exact compatible versions above; record chosen versions and evidence in configuration and lockfile. Use a single `src/app/` tree, neutral responsive shell, semantic global CSS, and only necessary scaffolding.
2. Initialize a local Supabase project with migration and database-test locations. No business migrations, production data, fixtures, or remote linkage. Provide an environment example containing placeholders only and ignore local secrets.
3. Provide `dev`, `build`, `start`, `lint`, `typecheck`, and `format:check` scripts and concise local setup instructions. Avoid empty architectural layers and speculative dependencies.

## Rules that must hold

- No loyalty mutation, authentication flow, tenant workflow, or Wallet integration is implemented here. QR credentials cannot authorize mutations; server authority, authenticated staff and audit provenance remain mandatory in later slices.
- Preserve later database coverage for tenant/branch denial, RLS, transaction atomicity, audit and idempotency, and focused browser coverage for primary staff/owner paths. Do not duplicate assertions across layers or create placeholder domain tests.
- Never commit secrets or expose privileged credentials to the browser. Local and production environments remain separate.

## Verification (run all listed)

- `pnpm install --frozen-lockfile` after generating the lockfile; `pnpm lint`, `pnpm typecheck`, `pnpm format:check`, `pnpm build`.
- `pnpm exec supabase start` and `pnpm exec supabase status`; verify the local project starts and its migration/test locations exist; stop it with `pnpm exec supabase stop` after checking. Requires a working local container runtime.
- `pnpm dev`: open the local root page and verify the shell renders at phone width; stop the server.
- Inspect `.env.example` and ignore rules for secret placeholders and exclusion of local environment files. Use `git diff --check` and review the resulting file list.

## Done when

The shell renders, local Supabase starts, listed checks pass, exact compatible versions and their evidence are documented, no business data/schema or secrets have been added, and `PROGRESS.md` states checks and unresolved ownership. CI/release acceptance belongs to the agreed owner and is not inferred from local checks. Report changed files, checks, migration/seed/fixture impacts, blockers and suggested commit; do not commit without agreed Git ownership.
