# How to Use This Template for a New App

The goal is to keep engineering preferences stable while re-discussing only the new product/domain.

## Step 1 — Copy the reusable baseline

Start the new project with:

```text
00_ENGINEERING_STANDARDS.md
01_NEW_PROJECT_DOMAIN_DISCOVERY_CHECKLIST.md
02_PROJECT_SPEC_TEMPLATE.md
03_HOW_TO_USE_THIS_TEMPLATE.md
04_CODEX_TASK_PROMPT_TEMPLATE.md
05_DESIGN_SYSTEM_PROMPT.md
06_CHATGPT_PROJECT_SETUP.md
scripts/build-chatgpt-sources.sh
AGENTS_TEMPLATE.md
README_TEMPLATE.md
```

Treat `00_ENGINEERING_STANDARDS.md` as the default technical baseline unless the new app has a concrete reason to differ.

## Step 2 — Discuss only the new domain

Use `01_NEW_PROJECT_DOMAIN_DISCOVERY_CHECKLIST.md` to drive the architecture conversation.

For example, for a grooming/pet-shop system, the discussion should focus on questions such as:

```text
Tenant / branches
Owners / pets
appointments and groomer assignment
check-in / grooming record
services and shampoos
photos before/after
signature / disclaimers
coupons
payments / discounts
notifications/reminders
documents/media
roles/permissions
operational pages and dashboards
```

You should not need to re-decide whether you prefer Controller→Service→Repository, React Hook Form, CSS Modules, TanStack Query, shadcn, RLS/RPC conventions, testing stack, error codes, or the Vercel/Supabase deployment baseline unless the new product genuinely needs an exception.

## Step 3 — Generate project-specific canonical docs

Use `02_PROJECT_SPEC_TEMPLATE.md` as the expected structure.

The new canonical docs should primarily contain domain behavior and project-specific read models. They may reference the reusable engineering baseline instead of duplicating every generic convention.

If the new app contains one unusually complex subsystem, give it a dedicated canonical file rather than bloating the general UI/schema docs.

## Step 4 — Create the repo root AGENTS.md

Start from `AGENTS_TEMPLATE.md` and replace the generic canonical-file map with the actual new project docs.

Keep AGENTS short. It should tell Codex:

- where truth lives;
- which files to read;
- which engineering rules are non-negotiable;
- how to report/verify work.

Do not paste the entire product specification into AGENTS.

## Step 5 — Prepare the roadmap

Define the complete one-line roadmap in C10. Prepare detailed prompts only for the next milestone using Steps 6–8 and R04; do not pre-write later milestones.

## Suggested first message for the next product-design chat

```text
I want to design a new application using my reusable engineering baseline.

Treat 00_ENGINEERING_STANDARDS.md as the default for stack, architecture, code organization, frontend state, API/RPC conventions, Supabase/RLS, styling, testing, and deployment. Do not re-discuss those conventions unless this product has a concrete reason to differ.

Use 01_NEW_PROJECT_DOMAIN_DISCOVERY_CHECKLIST.md to guide the discussion and help me produce the project-specific canonical documents described in 02_PROJECT_SPEC_TEMPLATE.md.

For this chat, focus only on the new application's domain requirements, workflows, entities, roles/permissions, pages/read models, financial rules, scheduling rules, media/integrations, defaults, and domain-specific exceptions to the baseline.
```

## Step 6 — Roadmap up front, task prompts per milestone
- C10 lists ALL milestones through MVP as one-line tasks (ID, layer, model, dependencies, rule IDs, blocking OPEN items). This gives every agent the end goal.
- Only the next milestone gets full task prompts (R04 format) in docs/codex/tasks/. Expand the following milestone near the end of the current one, from the real code.
- First instance of each layer pattern = Terra = reference implementation. Later instances = Luna.

## Step 7 — Build cycle (Codex)
1. Expand the next milestone (Terra, fresh chat, no code):

   Follow AGENTS.md. Read C00 Precedence, C10's milestone <ID> and applicable gates, PROGRESS's current checkpoint/approvals/references, and R04's Token-efficiency preflight/task format/routing. Inspect relevant current code. Write docs/codex/tasks/<TASK-ID>.md for this milestone only: exact source sections/rule IDs, files, verified pattern, affected-layer commands and named acceptance cases. Apply the preflight; state the recommended model, reasoning effort, escalation tier and brief reason in the user handoff and task header. Batch missing consequential decisions with proposed answers; routine implementation details within approved contracts need no new approval. Do not write application code or modify canonical docs.

2. If it listed questions: decide them in ChatGPT, apply them (step 6 below), then re-run step 1 for the affected tasks.
3. Run each task in its own Codex chat, on the model its file names:

   Follow AGENTS.md. Execute docs/codex/tasks/<TASK-ID>.md. Load only cited sections and relevant code. Preserve its scope and acceptance; use judgment for routine details and batch material contract conflicts before dependent work.

4. Follow AGENTS.md's Git/CI ownership. With user-owned CI, finish after local verification; the user checks CI before merge and supplies failures for a focused retry, then escalation per R04. Completed prompts are historical, not default inputs to later tasks.
5. If a task deviated in a way that affects later tasks, re-run step 1 for the remaining tasks of the milestone.
6. Applying decisions from ChatGPT (Luna, high):

   Follow AGENTS.md. Apply these approved decisions: update C03 DEC/OPEN entries and the owning sections per R02; replace duplicate rules with references. Do not change unrelated material or generate source bundles unless preparing a planning handoff. Decisions: <paste>

7. End of milestone, review (Astra for high-risk milestones, Terra otherwise):

   Follow AGENTS.md. Review milestone <ID>: the diff since <commit/tag> against the docs and rule IDs its tasks cite. Look for RLS/permission holes, cross-tenant leaks, rule-ID violations, non-atomic audit, missing negative tests, idempotency/concurrency gaps, C14 violations, and deviations not logged in PROGRESS.md. List findings by severity, each as a ready-to-run task file in R04 format with an assigned model.

8. When preparing a planning-source handoff, run scripts/build-chatgpt-sources.sh and replace the uploaded bundles. Do not regenerate/re-upload them for every task or progress edit. Generated copies remain non-authoritative and are never implementation inputs.
9. After the first milestone or two: check PROGRESS.md (CI first-pass rate per task type, escalations, stop-and-report questions). Improve references or move task types up a tier; update R04 once.

## Step 8 — Planning chat hygiene (ChatGPT)
- One topic per chat.
- Batch all questions in one numbered list, each with a proposed default; answer in one message.
- Ask for complete files or complete replacement sections, never fragments.
- Every decision becomes a C03 DEC entry; every unknown becomes an OPEN item with a proposed default.
- Checkpoint and start fresh at ~30–40 turns, a topic change, re-asked settled questions, or contradictions with the docs. Use the checkpoint prompt in R06.
