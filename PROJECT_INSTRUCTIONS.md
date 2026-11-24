# Project instructions (paste into ChatGPT Project settings)

This project designs and builds a managed digital loyalty service for small businesses in Guatemala, starting with beauty clinics and nail salons. Use the uploaded reusable engineering sources and `docs/canonical/` as the source of truth. Newer approved decisions recorded in C03 and the owning canonical rule override older conversation content.

Follow `00_ENGINEERING_STANDARDS.md` as the default stack and architecture. Do not re-discuss settled engineering conventions without a concrete product reason. Treat §25 scaffold choices as proposed until confirmed. Keep product decisions in C03 and their full rule in one owning document.

Product process:
1. Complete domain discovery from `01_NEW_PROJECT_DOMAIN_DISCOVERY_CHECKLIST.md` before writing specs or code.
2. After discovery, present a one-page design summary and wait for approval.
3. After approval, create/update canonical docs using `02_PROJECT_SPEC_TEMPLATE.md`, then create the full one-line roadmap in C10.
4. Create a detailed Codex task prompt only for the next milestone, after inspecting the actual repository and verified code patterns. Do not begin implementation outside the approved task scope.

Product constraints:
- Businesses own their Apple Developer accounts and pay Apple directly. Account setup help requires explicit authorization, with transparent ownership and exit/handover.
- Staff use a responsive mobile web app; no tablet is required.
- The server is the source of truth for stamps and rewards. Every mutation requires authenticated authorized staff and retains staff/branch provenance. A scan alone never mutates loyalty data.
- Customer passes use an opaque reusable lookup identifier, display branded progress and reward eligibility, and have no branch label in MVP.
- Same-day duplicate stamps are allowed; reports flag them for human review.
- Direct price is a provisional Q299 per branch per month plus a setup fee. Evaluate full multi-branch totals. Reseller pricing is deferred from MVP until direct pricing and support effort are validated.
- Keep MVP simple and polished for nontechnical business owners. Prioritize Spanish-language UX, reliable mobile scanning, pass previews, and hands-on support.

Implementation efficiency:
- For each Codex task, make the minimum complete, maintainable change that satisfies its approved scope. Reuse existing patterns; avoid speculative abstractions, dependencies, unrelated refactors, and adjacent features.
- Keep verification focused: choose the least costly checks that credibly cover changed behavior, run each relevant check once, and avoid redundant test layers, broad snapshots, or tests for trivial changes.
- Give each business assertion one primary test layer. Spend test effort on tenant/branch isolation, authorization, atomic stamp/reward/audit behavior, idempotency, and the main staff/owner workflows. Do not weaken those checks for efficiency; state what was run and what was not.
