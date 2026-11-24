# Loyalty System

Minimal local foundation for the managed loyalty service. Product rules and the roadmap are in `docs/canonical/`; this scaffold implements no loyalty workflow.

## Local setup

Use Node.js 26.3.1 (`.nvmrc`), pnpm 10.34.5 and a running Docker-compatible container runtime. Install dependencies with `pnpm install --frozen-lockfile`. Run `pnpm dev` and open http://localhost:3000. The local API, database, Studio, and mail UI use ports 55321–55324 to avoid conflicts with default Supabase ports. No remote project is linked. Copy `.env.example` to `.env.local` only when local configuration is needed; never commit credentials.

Checks: `pnpm lint`, `pnpm typecheck`, `pnpm format:check`, and `pnpm build`. Use `pnpm start` after a build.

## Local database

Run these commands from the repository root with Docker running. The configured project is `LoyaltySystem` and its database is on `127.0.0.1:55322`.

```sh
pnpm exec supabase start
pnpm exec supabase migration up --local
pnpm exec supabase test db
pnpm exec supabase db lint --local
pnpm exec supabase stop
```

All nine domain tables live in the private `loyalty` schema. The repository-facing RPC `public.list_my_branches()` returns `business_id`, `id` and `name` for branches in the caller’s active scope. Frontend loyalty workflows use the application HTTP API. The server repository passes the caller’s session to Supabase (DEC-023). The pgTAP suite creates synthetic fixtures inside a transaction and rolls them back.

## Version evidence

Verified 2026-11-23 against the [Node release schedule](https://nodejs.org/en/about/previous-releases), [npm registry](https://registry.npmjs.org/), [Next.js installation requirements](https://nextjs.org/docs/app/getting-started/installation), and [Supabase local CLI documentation](https://supabase.com/docs/guides/local-development). Exact package versions and transitive resolutions are pinned in `package.json` and `pnpm-lock.yaml`.

- Node 26.3.1 is on the Node 26 LTS line. pnpm 10.34.5 requires Node >=18.12; Next.js 16.4.6 requires >=20.9.
- Next.js and eslint-config-next are both 16.4.6; React and React DOM are both 19.3.1. Next accepts React/React DOM ^19 and React DOM requires React ^19.3.1.
- TypeScript 5.9.3 and ESLint 9.39.1 satisfy eslint-config-next's peers (TypeScript >=3.3.1, ESLint >=9). Its TypeScript ESLint parser 8.74.0 accepts TypeScript >=4.8.4 <6.1 and ESLint 9. TypeScript 7 was therefore not selected.
- Prettier 3.10.1, Supabase CLI 3.3.0, @types/node 26.6.6, @types/react 19.3.0 and @types/react-dom 19.3.0 are pinned; React DOM types require React types ^19.3.0. The Supabase CLI's install script is explicitly allowed for pnpm.

CI ownership and remote migration approval/runner remain open in C03 OPEN-010. Local verification does not establish CI or release acceptance.
