# <App Name>

<One short paragraph describing what the application does and who it is for.>

## Requirements

- Node.js LTS
- pnpm
- Docker
- Supabase CLI

## Local setup

```bash
pnpm install
cp .env.example .env.local
supabase start
supabase db reset
pnpm dev
```

Open the local Next.js URL shown in the terminal.

## Tests

```bash
pnpm test
pnpm test:db
pnpm test:e2e
```

## Production build

```bash
pnpm build
```
