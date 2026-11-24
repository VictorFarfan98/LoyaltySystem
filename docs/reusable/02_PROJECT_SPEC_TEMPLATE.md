# Project-Specific Canonical Specification Template

Use this alongside `00_ENGINEERING_STANDARDS.md`. Do not duplicate generic engineering conventions unless this project deliberately overrides them.

Suggested project docs:

```text
01_PRODUCT_REQUIREMENTS.md
02_DOMAIN_RULES_AND_INVARIANTS.md
03_SCOPE_DEFAULTS_AND_OPEN_EXTERNAL_DEPENDENCIES.md
04_DATA_MODEL_AND_SCHEMA.md
05_RPC_AND_TRANSACTION_DESIGN.md
06_AUTHORIZATION_AND_SECURITY.md
07_QUERY_MODELS_INDEXES_AND_PERFORMANCE.md
08_UI_READ_MODELS_AND_WORKFLOWS.md
09_SEED_BOOTSTRAP_AND_TEST_FIXTURES.md
10_IMPLEMENTATION_PLAN.md
14_DESIGN_SYSTEM.md
```

Add a dedicated file for a subsystem only when it is unusually complex (for example an advanced renderer, editor, workflow engine, or integration).

## Documentation rules

Each fact lives in exactly one owning document. Other documents reference its rule ID and section; the decision ledger retains provenance and names affected docs. C03 owns decisions/defaults/OPEN items. C14 owns UI tokens, theme code, component recipes, layout, states, voice and the design reference page.

- Product requirements define expected behavior.
- Domain rules/invariants are architectural constraints and should survive UI refactors.
- Data model/schema explains ownership, relationships, lifecycle, and structural constraints before migrations.
- RPC/transaction docs define authoritative mutations and error/warning semantics.
- Security docs define RLS/client/auth boundaries.
- Query docs define read shapes, indexes, pagination, and request/performance constraints.
- UI docs define screen read models, state ownership, interactions, responsive behavior, and implementation blueprints.
- Seed docs separate deterministic reference data, customer bootstrap, and disposable fixtures.
- Implementation plan orders vertical slices and defines tests/definition of done.

## Source-of-truth precedence

The project’s C00 owns its precedence order. Do not silently simplify a domain requirement because another implementation is easier.
