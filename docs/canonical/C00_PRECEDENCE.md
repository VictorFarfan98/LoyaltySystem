# C00 — Precedence and Document Map

**Status:** Approved design baseline; specifications ready for implementation planning.  
**Scope:** This file defines where project truth lives. Product rules are not duplicated here.

## Precedence

1. The latest explicit user-approved entry in C03 controls only the decision it names and points to its owning rule.
2. The owning canonical document is authoritative for its subject.
3. `00_ENGINEERING_STANDARDS.md` is the default for cross-project engineering conventions; project-specific approved requirements override it when necessary.
4. C10 orders implementation but does not redefine product behavior.
5. Chat history and generated source bundles are not authoritative after a decision is recorded here.

If two owning docs conflict, stop the affected work, record the conflict in C03, and propose a resolution before implementing the dependent behavior.

## Document map

| File | Owns | Read for |
|---|---|---|
| C01_PRODUCT_REQUIREMENTS.md | User-visible product scope, audiences, MVP and non-goals | Any product feature |
| C02_DOMAIN_RULES_AND_INVARIANTS.md | Loyalty concepts, lifecycle, rules, correction and expiry semantics | Any data or workflow change |
| C03_DECISIONS_AND_OPEN_ITEMS.md | Decision ledger, assumptions, unresolved questions and provenance | Before changing a contract or settling an OPEN item |
| C04_DATA_MODEL_AND_SCHEMA.md | Entity ownership, relationships, lifecycle fields and constraints | Migrations and data model changes |
| C05_RPC_AND_TRANSACTION_DESIGN.md | Mutation contracts, atomicity, warnings and stable outcomes | Database operations and service integration |
| C06_AUTHORIZATION_AND_SECURITY.md | Auth, tenant isolation, roles, branch scope, pass-token security | Any auth, RLS, scan, mutation or storage change |
| C07_QUERY_MODELS_INDEXES_AND_PERFORMANCE.md | Staff screen, reporting read models, filters and index intent | Reads, lists and analytics |
| C08_UI_READ_MODELS_AND_WORKFLOWS.md | Pages, interaction flow, mobile behavior and states | Screens and UX |
| C09_SEED_BOOTSTRAP_AND_TEST_FIXTURES.md | Tenant provisioning, demo data and disposable fixtures | Local setup and tests |
| C10_IMPLEMENTATION_PLAN.md | Complete one-line MVP roadmap, dependencies and gates | Planning and milestone handoff |
| C14_DESIGN_SYSTEM.md | Provisional app UI rules and tenant pass branding | Visual implementation |

## Baseline references

- `00_ENGINEERING_STANDARDS.md` owns the default stack, layers, DTOs, Supabase client separation, RLS principles, state ownership, styling implementation, tests, deployment, and scaffold proposals.
- `01_NEW_PROJECT_DOMAIN_DISCOVERY_CHECKLIST.md` and `02_PROJECT_SPEC_TEMPLATE.md` are reusable design aids, not project rules.
- `04_CODEX_TASK_PROMPT_TEMPLATE.md` owns task prompt format and model routing.
- `05_DESIGN_SYSTEM_PROMPT.md` owns the expected depth for a future finalized design system after brand assets exist.

## Document status

These docs represent the approved product design summary. Product and security rules are specified; exact framework/tool versions remain governed by the scaffold defaults and must be selected from compatible stable releases when the repository is inspected. External Wallet account requirements remain a go-live dependency, not a reason to weaken authentication or audit rules.
