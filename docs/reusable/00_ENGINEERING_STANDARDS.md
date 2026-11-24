# Reusable Application Engineering Standards

**Status:** Default engineering baseline for new applications  
**Purpose:** Capture cross-project engineering decisions so a new product discussion can focus on domain requirements rather than re-deciding stack, layering, frontend state, styling, security, testing, and deployment conventions.  
**Applicability:** Use as the default for new applications built with Next.js + TypeScript + Supabase + Vercel. A project-specific canonical requirement may override this file when the domain genuinely needs different behavior.

---

## 1. Core principles

1. Prefer a small number of explicit conventions over framework-heavy abstraction.
2. Keep domain truth in PostgreSQL; do not create a second authoritative state model in React.
3. Separate authentication, authorization, entitlement, and behavior/configuration.
4. Prefer feature-oriented code organization over generic technical buckets.
5. Prefer operation/query-shaped APIs and repositories over generic CRUD abstractions.
6. Make performance and authorization part of each vertical slice from the first implementation.
7. Do not optimize by hiding domain semantics behind generic layers.
8. Keep DTO/API contracts separate from database table shapes.
9. Keep UI presentation concerns separate from domain logic.
10. Implement the smallest correct solution first; avoid speculative frameworks and premature generalized engines.

---

## 2. Default stack

Use unless a project-specific requirement justifies a change:

```text
Frontend / server framework  → Next.js App Router
Language                     → TypeScript
UI                           → React
API                          → Next.js Route Handlers
Database                     → PostgreSQL via Supabase
Auth                         → Supabase Auth
Storage                      → Supabase Storage when private object storage is needed
Hosting                      → Vercel
Server/domain data cache     → TanStack Query
Forms                        → React Hook Form
UI primitives                → shadcn/ui
Styling                      → CSS Modules + semantic global CSS variables
Testing                      → Vitest + React Testing Library + Playwright + Supabase pgTAP
```

Do not add a second backend framework such as NestJS unless the product has a demonstrated requirement for an independently deployed API/backend service.

Use one repository for the application and Supabase migrations/tests unless the system grows enough to justify a monorepo.

---

## 3. Backend/application layering

Normal request path:

```text
Next.js Route Handler
→ Controller class
→ feature Application Service
→ explicit repository / infrastructure capability interface
→ Infrastructure implementation
→ Supabase / PostgreSQL RPC / query / Auth / Storage
```

### Route Handlers

Keep `route.ts` files thin. They should primarily:

- resolve request/session primitives;
- delegate to a Controller;
- return the Controller result as the HTTP response.

Do not put domain logic, Supabase Auth administration, or raw domain-table mutations in Route Handlers.

### Controllers

Controllers own the HTTP/API boundary:

- request-shape validation;
- parsing route/query/body inputs;
- calling the feature Service;
- mapping known application outcomes to HTTP status + stable error code;
- returning endpoint DTOs.

Controllers do not become the authoritative security or domain-integrity layer.

### Application Services

Use one feature Service with direct operation names, for example:

```text
PatientService.createPatient()
AppointmentService.rescheduleAppointment()
PaymentService.recordPayment()
```

Avoid one class per use case unless a real complexity boundary appears.

Services own:

- application orchestration;
- DTO-to-repository mapping;
- cross-infrastructure workflows when PostgreSQL alone cannot perform the full operation (for example Auth + DB or Storage + DB);
- repository result to response DTO mapping.

Do not reimplement database-local transactional invariants in TypeScript.

Avoid Service-to-Service chains by default. A Service may depend on more than one repository/capability when genuinely needed.

### Repositories / ports

Use explicit feature/application repository interfaces:

```text
IPatientRepository
IAppointmentRepository
IPaymentRepository
IAuthAdminService
IStorageService
```

Repository methods should be operation/query shaped and may intentionally resemble authoritative PostgreSQL RPCs.

Do not create `GenericRepository`, generic CRUD Service layers, or abstractions that erase domain meaning.

Application Service interfaces are not required unless a real substitutable boundary exists.

---

## 4. DTO and API contract conventions

Each endpoint normally defines its Request/Response DTOs together in an endpoint-specific `.dto.ts` file.

Use TypeScript interfaces/types. DTOs should not depend on database-generated table types.

Reuse a DTO only when two endpoints share the same semantic contract, not merely overlapping fields.

Typical flow:

```text
HTTP input
→ Controller validation
→ Request DTO
→ Service mapping
→ Repository/RPC/query
→ Service mapping
→ Response DTO
→ Controller response
```

Do not expose raw database schemas as frontend contracts.

---

## 5. API errors and warnings

Backend errors expose stable semantic codes, not localized user-facing text.

Default contract:

```ts
interface ApiErrorResponse {
  code: ApiErrorCode;
  fieldErrors?: Record<string, ApiErrorCode[]>;
  requestId?: string;
}
```

Rules:

- `code` drives frontend behavior and localization.
- Frontend owns user-facing text.
- Never expose raw PostgreSQL, PostgREST, Supabase, stack-trace, or exception strings.
- Unknown failures map to a safe stable code such as `UNEXPECTED_ERROR` and a request ID.
- Field-level request validation may return field error codes.

A condition that may still proceed after explicit user confirmation is a structured warning/outcome, not an exception.

Examples:

```text
possible duplicate
schedule overlap
material-change confirmation
```

Do not make the frontend parse error-message strings.

---

## 6. PostgreSQL RPC and transaction strategy

Use PostgreSQL constraints for structural impossibility and RPCs for cross-row/domain transactions.

Good RPC candidates include operations that:

- update multiple rows atomically;
- enforce concurrency/uniqueness across rows;
- create financial/clinical history that must commit together;
- require authoritative permission checks close to the data;
- produce structured warnings/confirmation outcomes.

Reads may use RLS-protected tables/views or query RPCs based on shape and sensitivity.

Do not force every simple read through a mutation-style RPC when a normal authorized query is clearer.

For PostgreSQL functions:

- use `SECURITY DEFINER` only where required;
- set a safe `search_path`;
- schema-qualify sensitive references;
- revoke/grant execute deliberately;
- perform authorization inside authoritative mutation functions;
- never use SECURITY DEFINER as a convenience bypass.

---

## 7. Supabase security/client separation

Use distinct capabilities:

### Browser Supabase client

Allowed for:

- browser session lifecycle/refresh;
- local sign-out/session events;
- direct browser upload to Storage using short-lived signed upload permissions.

Never expose service-role/admin credentials.

### Server user-scoped Supabase client

Normal domain data client. It preserves the caller's JWT so PostgreSQL can evaluate `auth.uid()`, RLS, permissions, and audit provenance.

### Auth Admin client

Server-only and used only for Supabase Auth administration such as user creation/password reset/update/compensation.

Do not use it as the normal database client.

### Storage privileged/signing capability

Server-only and isolated from normal Tenant-domain database access.

---

## 8. RLS and authorization

RLS remains enabled as defense in depth.

General rules:

- all tenant-owned rows should carry explicit `tenant_id` where practical;
- use composite FKs/constraints where they protect tenant/entity consistency;
- normal user operations preserve caller identity through PostgreSQL;
- frontend permission checks are UX only;
- Controller/Service permission checks may fail early for usability but do not replace RPC/RLS authority;
- service-role DB access is not the normal domain path.

Authorization tests must include negative cases: another tenant, inactive user, missing permission, invalid branch/location context, and restricted storage access.

---

## 9. Authentication/session frontend pattern

Successful login should return a minimal application bootstrap in the same response when possible.

Bootstrap contains shell/security UX data only, such as:

```text
user identity
principal/tenant context
allowed locations/branches
permissions
features/entitlements if the app uses them
small typed behavioral settings
must-change-password state when applicable
```

Do not preload application/domain screens on login.

Store bootstrap in TanStack Query, not a giant Auth Context. Treat it as static for the authenticated frontend lifetime unless the project explicitly requires live permission changes.

A hard refresh may fetch bootstrap once again.

Centralize session termination:

```text
cancel active queries
→ clear TanStack Query cache
→ clear non-sensitive transient coordination metadata
→ propagate logout/session termination to other tabs
→ Supabase local-session signout
→ redirect to login
```

Use `BroadcastChannel` plus small non-sensitive local activity metadata for multi-tab coordination when workstation-idle logout matters.

Project-level Supabase session controls are defense in depth; they do not necessarily equal human workstation inactivity.

For current cookie-based Supabase Auth with Next.js App Router, use a minimal `proxy.ts`/SSR cookie-refresh integration only for session plumbing. Do not perform domain authorization or Tenant resolution there.

---

## 10. Frontend state ownership

Use one clear owner per category:

```text
TanStack Query     → API/server/domain read data
URL                → navigational state worth preserving/copying
React local state  → transient interaction state
useReducer         → complex local interaction state
React Hook Form    → unsaved form state
Supabase Auth      → browser auth/session token lifecycle
PostgreSQL         → authoritative domain truth
```

Do not copy entire fetched server objects into local React state simply to render them.

Do not add Redux/Zustand for MVP unless a measured cross-screen client-state problem appears.

Use Context only for infrastructure concerns such as QueryClient/session lifecycle/toasts; avoid giant application contexts.

---

## 11. TanStack Query conventions

Feature-owned query-key factories are mandatory.

Tenant-owned keys start with explicit Tenant context, for example:

```ts
['tenant', tenantId, 'patients', 'list', params]
```

Every variable that changes the response belongs in the key.

Default screen-query behavior:

```text
staleTime: Infinity
refetchOnWindowFocus: false
refetchOnReconnect: false
refetchOnMount: true
```

This means valid cache is reused, while an explicitly invalidated inactive query refetches when later opened.

Do not persist sensitive query caches to LocalStorage/IndexedDB.

A reasonable inactive-query `gcTime` baseline is around 30 minutes unless the project has a reason to change it.

After successful mutation:

```text
refetch the active primary read model completely
mark related inactive models stale without causing immediate network requests
```

Avoid global app-wide refetches.

No polling by default. No automatic adjacent-page/range prefetch by default.

Pass TanStack Query `AbortSignal` through read requests. Do not assume cancelling a mutation means the server operation did not commit.

Read retries: at most one retry and only for clearly transient failures. Mutation retries: off by default.

---

## 12. Pagination and search

Default MVP pagination is deterministic OFFSET/LIMIT with stable ordering and an `id` tiebreaker.

API model:

```text
page      (1-based)
pageSize
```

Response:

```text
items
page
pageSize
hasNextPage
```

Do not request `totalCount`/`totalPages` by default. Query `pageSize + 1` internally when useful to derive `hasNextPage`.

Use exact totals only when a screen genuinely needs them.

No automatic page prefetch.

For searchable comboboxes, a practical default is:

```text
minimum search length: 2
~300 ms debounce
bounded result set
```

Change when domain UX requires it.

---

## 13. Frontend API modules

Allow one small generic transport:

```ts
apiRequest<TResponse>()
```

It owns infrastructure concerns only:

- fetch/HTTP;
- JSON parsing;
- common headers;
- AbortSignal;
- request ID extraction;
- typed `ApiError` construction;
- centralized session handling for `UNAUTHORIZED`.

It has no domain knowledge.

Use explicit feature modules:

```text
patientsApi
appointmentsApi
billingApi
```

Do not scatter raw fetch calls across React components.

Call frontend HTTP modules `api`, not `services`, to avoid collision with backend Application Services.

---

## 14. Forms and validation

Use React Hook Form.

Do not add Zod/schema validation merely to mirror Controller/database validation.

Frontend validation exists for immediate UX:

- required fields;
- simple formats;
- length/range;
- local cross-field checks.

Authoritative request/domain validation remains backend/PostgreSQL.

Use RHF validation rules and small pure helpers. Avoid building a validation framework.

A practical default:

```text
mode: onBlur
reValidateMode: onChange
```

Map backend field error codes into RHF fields using `setError()`.

Structured domain errors remain workflow-level, not forced into arbitrary fields.

---

## 15. Styling and design-system conventions

Default application styling:

```text
shadcn/ui primitives       → Tailwind internally is acceptable
feature/layout components  → CSS Modules
app/globals.css            → global design tokens/themes/base styles
```

Prefer semantic classes:

```tsx
<div className={styles.workspace}>
```

Avoid long Tailwind utility strings in normal feature JSX.

Avoid normal presentation/layout via `style={{ ... }}`.

Inline style/attributes are reserved for genuine runtime-calculated values such as SVG transforms, measured positions, or geometry.

Use `cn()` only for a small number of semantic classes. `data-*` attributes are encouraged for clear visual states.

### `globals.css`

Centralize semantic variables for:

```text
background / foreground / surfaces / borders
primary + foreground/hover
success / warning / error / info foreground/background/border
alerts/toasts/validation feedback
spacing/radius tokens where useful
app/domain semantic colors when needed
```

Components consume semantic variables instead of inventing independent colors.

The initial project may be light-theme only, but tokens should allow future alternate/dark themes without rewriting feature CSS.

---

## 16. Responsive conventions

Use standard breakpoint values initially:

```text
< 768px      → graceful/basic phone support
768–1023px   → compact / portrait-tablet
>= 1024px    → full application workspace
>= 1280px    → additional breathing room, not different functionality
```

Prefer CSS responsive behavior over separate mobile/desktop React trees.

General defaults:

- persistent/collapsible sidebar at wide widths;
- shadcn `Sheet` navigation below `lg`;
- one-column forms by default; two columns only for naturally paired short fields;
- no hover-only primary actions;
- approximately 44×44 CSS px hit targets for frequent tablet actions where practical;
- every drag interaction has a non-drag alternative;
- tables choose feature-specific responsive behavior rather than a universal table→card transformer;
- Dialog/AlertDialog remains for short focused decisions; contextual inspect/edit surfaces use Sheet.

---

## 17. React performance conventions

Correct query/read-model shape comes before micro-optimizing React rendering.

Use stable domain IDs as keys.

Use `useMemo`, `React.memo`, and `useCallback` where there is a concrete render-cost/referential-stability benefit, not everywhere by default.

Complex renderer/data projections may pre-index arrays into maps once rather than repeatedly filtering inside children.

---

## 18. Storage pattern

Use private object storage for sensitive files.

Store stable storage keys, not public/signed URLs.

Preferred upload flow:

```text
UI
→ API authorization + pending domain/file record
→ server returns short-lived upload permission
→ browser uploads directly to Storage
→ API verifies/finalizes domain record
```

Read flow:

```text
UI asks for authorized domain object/file
→ backend authorizes domain access
→ short-lived signed download URL
→ browser reads Storage directly
```

Use opaque object paths; avoid PII in storage keys.

Signed URLs are never persisted.

---

## 19. Logging, diagnostics, and audit

Every API request gets a server-generated request ID.

Return `X-Request-Id` on responses; errors also include `requestId` when available.

Use lightweight structured server logging from the beginning.

Never intentionally log:

```text
passwords
auth/access/refresh tokens
service keys
signed URLs
full sensitive request/response bodies
PII/clinical/business-sensitive narrative unless explicitly justified
file bytes
```

Expected domain warnings/errors are normal product outcomes and should not create noisy error logs at every layer.

Audit history and application logs are separate concerns:

```text
AuditEvent        → durable business/security provenance
application logs  → technical diagnostics
```

Do not use hosting logs as the authoritative audit trail.

---

## 20. Testing standards

Use:

```text
Supabase pgTAP                 → constraints/RLS/RPC/transaction tests
Vitest                          → backend Services/Controllers/mappers/helpers
Vitest + React Testing Library  → meaningful component interactions
Playwright                      → browser workflows + responsive/drag interactions
```

Avoid snapshot-heavy testing.

Prefer behavioral tests over implementation-detail tests.

Critical E2E tests should run against the real Next.js app + deterministic local Supabase fixtures rather than a fully mocked backend.

Test responsive behavior at least at desktop, landscape tablet, and portrait tablet for critical workflows. Phone gets smoke coverage unless it is a primary target.

---

## 21. Deployment/environment conventions

Default deployment:

```text
Vercel    → Next.js app / Route Handlers
Supabase  → PostgreSQL / Auth / Storage
```

Keep local/dev and production Supabase projects/data/secrets separate.

Never use production service keys in local frontend development.

Use environment variables for infrastructure credentials; commit an `.env.example`, never real secrets.

Prefer local Supabase for development and automated tests.

Database changes are version-controlled migrations. System reference data is deterministic/version-controlled. Tenant bootstrap/provisioning is a production workflow. Development/test fixtures remain disposable and separate from production data.

Do not make production database dumps the normal local seed workflow.

---

## 22. Clean-code and organization conventions

Prefer direct names over clever abstractions.

Examples:

```text
createPatient()
recordPayment()
getCalendar()
```

Avoid names such as generic `process()`, `handleData()`, or framework-like abstractions with unclear business intent.

Feature code should remain close to the feature that owns its primary business intent.

Avoid generic `shared/`, `common/`, `core/`, `misc/` dumping grounds. Truly generic pure helpers may live in `utils/`.

Do not create empty ceremonial directories.

Prefer composition over inheritance.

Keep functions/classes focused, but do not split code into tiny files/classes only to satisfy an arbitrary line count.

Comments should explain **why** or unusual constraints, not restate obvious code.

Do not introduce patterns/libraries because they are fashionable; require a concrete problem they solve.

---

## 23. Default repository shape

```text
src/
  app/
    (auth)/
    (app)/
    api/                       # thin Route Handlers

  components/
    ui/                        # shadcn primitives
    layout/                    # generic shell/layout primitives

  features/
    <feature>/
      api/
      queries/
      mutations/
      screens/
      components/
      forms/
      hooks/
      types/
      mappers/
      *.module.css             # only what the feature actually needs

  presentation/
    controllers/<feature>/

  application/
    <feature>/
      <feature>.service.ts
      dto/
      repositories/

  domain/
    <feature>/

  infrastructure/
    <feature>/
    supabase/
    auth/
    storage/
    logging/

  composition/
  utils/

app/globals.css
proxy.ts

supabase/
  migrations/
  tests/
  seed.sql / configured seed files

AGENTS.md
README.md

docs/
  canonical/                  # project-specific source of truth
  codex/                      # execution prompts/plans when useful
```

A feature creates only the directories it actually needs.

---

## 24. What must be re-discussed for each new application

This engineering template is not a substitute for domain discovery. For every new app, explicitly decide:

- Tenant/organization/location ownership model;
- actors/roles/permissions;
- main entities and lifecycles;
- authoritative domain invariants;
- workflows/status transitions;
- financial/ledger rules if applicable;
- scheduling/availability rules;
- documents/media/storage requirements;
- reporting/analytics requirements;
- integrations/webhooks/external systems;
- domain-specific read models/pages;
- domain-specific warnings/confirmations;
- domain-specific search/pagination expectations;
- domain-specific history/audit/correction behavior;
- domain-specific responsive/high-interaction components;
- production bootstrap/reference/catalog data;
- deferred features/non-goals.

Project-specific canonical docs always win when they deliberately differ from this baseline.

## 25. Scaffold defaults (proposed)

Each row is PROPOSED, app-agnostic, and requires project confirmation. It does not override an approved project contract.

| Status | Choice | Proposed default |
|---|---|---|
| PROPOSED | Exact framework, runtime, CLI and package versions | At scaffold time choose compatible stable releases on Node.js LTS, record exact versions including Next.js, React, TypeScript, pnpm, Supabase CLI and test tools, and commit `pnpm-lock.yaml`. Use the verified lockfile as version evidence. |
| PROPOSED | TypeScript compiler settings | Start with `strict: true`, `noEmit: true` and the selected Next.js template’s module settings. Decide `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes` and aliases after checking the codebase. |
| PROPOSED | Supabase Auth packages and sign-in policy | Prefer `@supabase/supabase-js` and `@supabase/ssr` for cookie integration. Decide email/password, OAuth, invitations, MFA, recovery and inactivity policy from the app’s actors. |
| PROPOSED | SQL naming, RPC I/O and exposure | Prefer a narrow exposed schema with verb-first snake_case operations such as `api.update_record`, explicitly named typed inputs, operation-specific projections and private helpers. Derive the actor from the verified session. Specify `expected_version` for conflicting edits and an idempotency key for replayable commands. Pick named SQL parameters, result type, grants and error mapping per slice. No global `rpc_`, `api_` or parameter prefix is ratified. |
| PROPOSED | Generated DB types | Generate from migrated local Supabase with `supabase gen types typescript --local`, store as `src/infrastructure/supabase/database.types.ts`, and check regeneration in CI. Confine generated types to infrastructure. Keep endpoint DTOs independently owned. |
| PROPOSED | Tailwind version and configuration | For a new compatible shadcn/ui setup, propose Tailwind CSS v4 with CSS-first configuration. Map primitive theme values to semantic tokens in `src/app/globals.css`. Pin the exact release at scaffold time. |
| PROPOSED | Icons, tables, feedback and charts | Start with `lucide-react` for icons and shadcn/ui Table for ordinary lists. Add `@tanstack/react-table` for complex table behavior, `sonner` for ephemeral toasts and `recharts` when a specified chart needs it. Confirm each independently. |
| PROPOSED | Dates and localization | Use date-only values for business dates, explicit IANA zones for civil-time rules and `timestamptz` for instants. Start formatting with `Intl.DateTimeFormat`. Add `date-fns` if calendar arithmetic justifies it. Define inclusivity, DST and timezone-change behavior for each workflow. |
| PROPOSED | PWA and Supabase Realtime | Enable either only for a specified workflow. Start an installable app with a manifest, icons and narrowly scoped service worker. Decide offline data, revocation, replay, cache lifetime and target browsers before choosing a worker library. Use private authorized channels for scoped foreground notifications when needed. |
| PROPOSED | Vercel previews, variables and release flow | Use local Supabase for development, an isolated nonproduction backend for Preview, and a dedicated production project. Choose shared preview vs per-PR database branch explicitly. Scope values by Vercel environment. Only browser-safe project URL and publishable key belong in public variables. Keep Auth Admin, signing and database secrets server-only. Proposed flow is PR → tested preview → reviewed merge → production. Apply compatible migrations before code that requires them, defer destructive changes and validate recovery. Branch names, CI provider and migration approval/runner remain open. |
| PROPOSED | Lint and formatting | Propose ESLint with `eslint-config-next`, Prettier, `pnpm lint` and `pnpm format:check`. Choose compatible versions and commit their configs. The README’s test and build commands are established separately. |
| PROPOSED | Repo path/casing policy | Adopt a single `src/app/` tree and `src/app/globals.css` in future scaffolds. Use PascalCase component/type names, camelCase operations and descriptive feature filenames. The standards fix role-specific names such as `*.dto.ts` and `*.module.css`; comprehensive file casing is open. |
| PROPOSED | CI provider | GitHub Actions |
| PROPOSED | Branch naming | main + short-lived feature branches named <type>/<task-id>-<slug> |
| PROPOSED | Migration runner and approval | Migrations applied by CI to preview; applied to production only after a reviewed merge. |
