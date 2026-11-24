# Loyalty Project Instructions

This project builds a managed digital loyalty service for small businesses in Guatemala, starting with beauty clinics and nail salons. The canonical docs under `docs/canonical/` are the product source of truth; the uploaded reusable project sources are supporting templates.

## Precedence and workflow

Read `docs/canonical/C00_PRECEDENCE.md` first. Approved decisions in C03 override the owning rule only when C03 explicitly says so; otherwise the owning canonical document governs. Follow `00_ENGINEERING_STANDARDS.md` for engineering conventions. Treat its §25 scaffold choices as proposed until confirmed or resolved at scaffold time.

Do not implement outside the task's stated scope. Keep domain rules in their owning documents, use rule IDs in code and tests where useful, and record new consequential decisions or unresolved questions in C03 before dependent implementation. A task prompt authorizes only its listed changes. Do not deploy or publish.

## Non-negotiable product rules

- The server is authoritative for loyalty progress and rewards.
- Every stamp, redemption, or correction requires authenticated and authorized staff. Record business, branch, staff, customer, and event time. A QR scan alone never changes data.
- Staff use the responsive mobile web app; MVP requires no tablet.
- QR pass identifiers are lookup credentials only, never authorization credentials. Prefer a separate opaque random pass token over a database primary key.
- Businesses own their Apple Developer accounts and pay Apple directly. Setup access requires explicit authorization, and ownership, access, and exit/handover remain transparent.
- Direct pricing is provisional at Q299 per branch per month plus a setup fee. Reseller pricing is deferred from MVP and must not be silently added to product billing scope.

## Implementation and verification efficiency

- Make the smallest complete, maintainable change that satisfies the approved task. Reuse an existing project pattern; do not add abstractions, dependencies, configuration, or adjacent features without a concrete need.
- Keep each task focused. Do not reformat or refactor unrelated files, duplicate existing coverage, or broaden scope beyond the MVP requirement.
- Use the least costly verification that gives credible evidence for the changed behavior. Run only relevant checks locally and do not repeat successful checks unless a relevant edit or failure warrants it. Documentation-only changes need document checks, not an application build.
- Add or change tests when they protect meaningful behavior, a regression, a boundary, or a domain invariant. Do not add tests for trivial markup, mechanical renames, or behavior already covered at a more authoritative layer. Avoid snapshot-heavy or redundant unit/integration/E2E coverage.
- Give each business assertion one primary test layer. Prioritize database tests for RLS, tenant/branch authorization, atomicity, idempotency, and reward invariants; use focused browser coverage for critical staff and owner workflows. Add another layer only when it verifies a distinct boundary.
- Never reduce coverage of security, tenant isolation, audit provenance, or transaction correctness to save tokens. State what was checked and what was intentionally not checked; do not claim unrun checks passed.

## Canonical documents

- C00: precedence and document map
- C01: product requirements and scope
- C02: domain rules and invariants
- C03: decisions, assumptions, and OPEN register
- C04: conceptual data model and schema constraints
- C05: authoritative operations and transaction contracts
- C06: authentication, authorization, privacy, and security
- C07: query models, reports, and performance expectations
- C08: screens and user workflows
- C09: bootstrap, reference data, and fixtures
- C10: milestone roadmap and implementation sequence
- C14: provisional design system and unresolved brand choices

Read `00_ENGINEERING_STANDARDS.md` and only the canonical sections relevant to the task. Follow the matching R04 prompt in `docs/codex/tasks/` when one exists. C10 owns the full roadmap; detailed task prompts are created for the next milestone only after inspecting the actual repository and verified implementation patterns.

## Verification and reporting

Use the task's named verification commands and acceptance cases. Do not claim unrun checks passed. Report changed files, checks and results, migration/fixture impacts, blockers, and the suggested commit. Keep `PROGRESS.md` current at task completion. Git, CI, and deployment ownership must be agreed before those actions.
