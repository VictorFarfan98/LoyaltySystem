# P00 planning handoff — repository reconnaissance

**Run on:** Terra, reasoning: medium; escalate to Terra high if the checkout has existing architecture or conflicting project instructions.  
**Purpose:** Inspect the actual application repository and write the repo-specific P00 scaffold task. This is planning only; it does not authorize application-code changes.

```text
Follow AGENTS.md. This task authorizes repository inspection and creation of one focused task file only. Do not edit application code, migrations, canonical product decisions, dependencies, or deployment settings. Do not run tests or build commands.

Read:
- AGENTS.md
- docs/canonical/C00_PRECEDENCE.md
- docs/canonical/C03_DECISIONS_AND_OPEN_ITEMS.md, especially OPEN-010
- docs/canonical/C10_IMPLEMENTATION_PLAN.md, milestone P00
- 00_ENGINEERING_STANDARDS.md §2–§9, §20–§25
- 04_CODEX_TASK_PROMPT_TEMPLATE.md

Inspect the actual repository:
- Git status and current branch without changing them.
- Root files, package manager/runtime configuration, existing Next.js/Supabase setup, test/lint/format scripts, and current CI/deployment ownership evidence.
- Existing patterns only where they affect whether P00 is a new scaffold or a reconciliation task.

Then create `docs/codex/tasks/P00_SCAFFOLD.md` in the R04 task format. It must:
- Name only verified files/paths and the actual repository state.
- Choose exact compatible stable framework/tool versions only when the repo is empty or the existing versions need a justified change; record evidence in the lockfile/config and avoid unrelated upgrades.
- Resolve only scaffold choices needed by P00. Preserve open business decisions and record any truly blocking CI/migration ownership question in the report rather than guessing.
- Limit implementation scope to the smallest coherent foundation needed for the approved MVP: app shell, environment examples without secrets, local Supabase project/migration/test structure, lint/typecheck/format config, and canonical documentation placement, adapted to what already exists.
- Keep business schema, Wallet integrations, tenant workflows, and production deployment out of P00.
- Include exact commands and acceptance cases based on the actual repo. Follow AGENTS.md for check/CI ownership.
- Include a model/reasoning recommendation and escalation tier according to R04. Use an explicit model-picker label available in the active Codex environment.
- Keep the eventual scaffold task lean: only the minimum complete foundation, no speculative dependencies or refactors, and the least costly credible verification. Do not duplicate test coverage across layers; retain checks for security-critical invariants and the primary acceptance path.

Do not edit C01–C10 or C14. Do not implement P00 in this task. At completion, report repo state, verified references, any blocking decisions, the created task file, and the suggested next action. No tests/builds are run in this reconnaissance step.
```
