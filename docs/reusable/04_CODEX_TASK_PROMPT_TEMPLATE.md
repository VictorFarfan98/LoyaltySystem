# Reusable Codex Task Prompt Template

Generate prompts only for the next milestone, from actual code (R03 Step 6). Each task names its scope, existing pattern, rule IDs and verification. AGENTS.md owns project execution policy, including branch/CI ownership and database lifecycle.

## Token-efficiency preflight

Standing policy: apply before every prompt handoff and task, including future milestones. Reassess only what the current task needs; do not create a separate report/checklist or investigate unrelated settings.

- Choose the smallest suitable model and reasoning effort under the routing below. Honor required security/money/offline tiers; account for retry risk rather than choosing by model size alone.
- Cite exact sections, rule IDs, code symbols and a verified pattern. Reuse unchanged context; use targeted searches, bounded tool output and supported output/verbosity limits. Batch independent reads; avoid duplicate scans or unnecessary agents/tools.
- Preserve one coherent task per chat and finish it there. Use a short task-file invocation and compact PROGRESS for handoff; do not paste document packs or repeat historical discussion.
- Batch known consequential questions with recommended answers. Resolve routine details autonomously inside approved contracts.
- Run relevant checks and every named acceptance case once; rerun after relevant changes/failures. Keep distinct SQL/API/browser boundaries and full CI coverage. Respect project-owned Git/CI duties.
- Consider other supported configuration/options when they can materially reduce this task's work. Use settings actually available; verify unfamiliar/version-sensitive options only when relevant. Apply only authorized changes; recommend user-controlled app/model settings when needed. Never invent switches, promise unmeasured savings or weaken security, correctness or required verification. No new dependency/configuration merely for optimization.

Whenever the user asks for a prompt, preface the handoff with `Run on: <model>, reasoning: <effort>; escalate to: <tier>` and one short reason. Use an available model name/picker label; do not guess unavailable names. Put the same recommendation in the task's Model header. The preflight is performed even when the user asks only for the next prompt; do not repeat its full contents in each prompt.

## Task prompt format

```text
Task: <ID> — <one concrete outcome>
Model: <Luna | Terra | Astra> (effort: <medium | high | xhigh>) · Escalate to: <next tier>
Follow AGENTS.md. This task authorizes only its scope, not deployment.

Read (sections/rule IDs only; reuse unchanged context):
- <exact file § section / rule IDs>
- <current dependency evidence and implementation reference>
- R00 § <n> only for touched concerns

Copy the pattern from:
- <existing implementation and relevant tests>

Files:
- create/edit: <exact paths>
- do not touch: <boundaries>

Implement:
1. <precise step>
2. <precise step>

Rules that must hold:
- <invariants and negative outcomes>

Verification (run all listed):
- <exact commands for affected layers and named positive/denial/rollback cases>
- <typecheck when TypeScript or generated contracts are affected>

Done when:
- <checkable outcome and required local checks pass>
- <CI/release acceptance handled by the owner specified in AGENTS.md>

Use judgment for routine implementation details within approved contracts. Batch known missing product/security/data-retention decisions or material conflicts with proposed answers before dependent work. Never silently redesign approved rules or edit canonical decisions outside scope.

At the end: update PROGRESS.md with final evidence and use R04's Task completion report.
```

## Task sizing and model routing

A Luna-sized task stays in one layer group, copies a verified reference, has exact contracts/rule IDs and checks, and introduces no first security, money or offline pattern. Resolve missing consequential decisions in C03/the owning doc before execution. Routine details within approved contracts need no new approval.

- Luna (medium): screens, forms, components, API modules, query keys, copy, tests and clear small fixes using existing patterns.
- Luna (high/xhigh): DB/Server/UI tasks copying references; non-financial RPCs using an existing pattern.
- Terra: first layer references, multi-layer/complex SQL work and tasks Luna failed twice.
- Astra: authorization/RLS audits, financial corrections, benefits, offline custody and high-risk milestone reviews.

Retry once on the same tier, then escalate per this routing. Before broadening scope, fix the vague prompt, missing reference or hidden decision that caused failure.

## Layer boundaries

After a reference exists, split vertical slices into DB (migration/RLS/RPC/fixtures/pgTAP), Server (Repository/Service/Controller/Route/DTO/API keys/Vitest), and UI (forms/screens/components/Playwright/C14). Split further only when necessary; avoid extra tasks that merely reread the same context.

## Verification and CI ownership

Choose checks for the actual change, preserving every named acceptance case. Give each business assertion a primary test layer; repeat only to verify a distinct boundary. SQL tests own database invariants/rollback; HTTP integration adds transport/JWT and multi-session behavior; browser tests own UI behavior. Documentation-only changes need relevant format/reference checks, not an application rebuild. Repeat successful checks only after relevant changes/failures; CI retains the full suite.

Follow AGENTS.md for Git/CI ownership. When the user owns CI, finish local implementation and record CI as user-owned/unverified; do not poll, inspect credentials or block on a missing run URL. Release acceptance still requires the responsible owner's CI review. Never infer a CI pass from local results; use actual results or explicit user confirmation.

## Progress file

PROGRESS.md keeps current status/model/known CI result, explicit execution approvals, verified references, final check evidence and unresolved blockers. C10 owns unstarted roadmap tasks. Replace superseded checkpoints rather than appending transcripts; historical investigation stays in Git history.

## Task completion report

Report the outcome, changed files, check results, migration/seed/fixture impact, blockers and suggested commit. Keep it short; link existing evidence instead of repeating logs. Omit empty headings and unrelated technical detail.
